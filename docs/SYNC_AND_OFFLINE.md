# Sync and offline: still to check

Last updated: 27 October 2026.

The merge rules are implemented and covered by automated tests. What has not been checked is the same behavior on a real phone, with the server actually unreachable, with the app killed in between, and with two devices editing at once. That pass comes before relying on sync.

This note is the same file in `movieCollector` and `movieshelf_server`.

## What already exists

The phone keeps the whole collection in Drift (schema v5). While self-hosted storage is selected, `SyncEngine` compares that collection with `sync_shadow`, the last state both sides agreed on, and sends the difference. The collection is the outbox, so closing the app before a sync does not drop the edit.

The server stores one copy per user in `SyncCollections` and `SyncRecords`. `SyncMerger` applies a change field by field:

- A field nobody else changed since `baseSeq` is applied.
- The same value from two devices is one value.
- A field both devices changed keeps the server value and returns both values. The other fields of that change still apply.
- A repeated `opId` returns the original answer and writes nothing again.

Push is `POST /api/sync/push` (500 changes at most). Pull is `GET /api/sync/pull?cursor=&limit=`. Tombstones and remembered operation ids last 180 days. A cursor older than that gets `reset: true` and the device reloads.

A sync runs about five seconds after a local change to a listened table, one second after the app returns to the foreground, and from Daten & Synchronisation. A run that cannot reach the server throws before it rewrites local rows. Disconnecting the server, or switching storage back to this device, leaves the phone collection in place.

Known barcodes, owned copies, and Fundstück verdicts are computed from Drift and need no network. An unknown barcode is stored in the pending scan queue.

Titles, seasons, barcodes, and personal state use a UUIDv5 derived from what they describe, so two phones that add the same TMDB film offline create one record. Editions and copies use a random UUIDv4, so two Blu-rays stay two copies.

Playback of a server file needs the server on the LAN. The shelf does not.

## Already proven by tests

Run these before the device pass. A failure here is a code bug, not a device bug.

| Check | Where |
|---|---|
| Different fields merge. The same field waits for a choice. Deletes of an edited record conflict. A lost push is idempotent. Two offline creates of the same film become one title. | `movieCollector/test/core/sync/sync_engine_test.dart` |
| One phone's film arrives on the other. A concurrent location edit stays until the user picks a side. Stopping sync leaves the phone collection in place. | `movieCollector/test/integration/collection_sync_test.dart` (needs a running server; `movieshelf_server/scripts/flutter-integration.ps1`) |
| Merger rules without a database. | `movieshelf_server/tests/MovieShelf.Tests/Core/SyncMergerTests.cs` |
| One device reaches the other, retries, paging, users stay separate, subscriptions, the dashboard lists the collection. | `movieshelf_server/tests/MovieShelf.Tests/Server/SyncTests.cs` |
| A known barcode is assessed from the local shelf. | `movieCollector/test/features/scanner/scan_assessment_test.dart` |

Commands:

```powershell
cd movieCollector
flutter test test/core/sync/sync_engine_test.dart test/features/scanner/scan_assessment_test.dart

cd ..\movieshelf_server
dotnet test --filter "FullyQualifiedName~Sync"
```

The integration file is skipped unless a server is already up. `scripts/flutter-integration.ps1` starts one.

## What still has to be checked on devices

Do this with two phones, or one phone and one emulator, and a server on the same LAN. On both phones choose self-hosted storage and pair them to the same user. Airplane mode is the offline switch. After each step, force-stop the app once and open it again. The result must be the same.

1. **Edit with the server off.** Airplane mode on. Add a film, change a copy's location, set a rating. The shelf shows the new values. Daten & Synchronisation shows them as waiting. Turn the network on. Within a few seconds the other phone has the same film, location, and rating. The waiting list is empty.
2. **Kill the app before it syncs.** Make an edit, force-stop within two seconds, then reopen on the network. The edit is still there and then reaches the other phone. `sync_shadow` is behind the collection until that run finishes.
3. **Same film, both offline.** Airplane mode on both. Add the same TMDB film on both, with a different rating on each. Go online and let both sync. There is one title. The rating is a conflict on the second phone, with both numbers, until someone picks one under Daten & Synchronisation. The location, if only one phone set it, is already merged.
4. **Server switched off mid-sync.** Start a sync, then stop the server process. The phone keeps every local row. The error is the sync screen's message, not a blank shelf. Start the server. The next run sends the waiting edits.
5. **Leave self-hosted storage.** Switch back to "only on this device". Every film, copy, barcode, and rating is still on the phone. The other phone, still self-hosted, keeps the last synced copy and does not wipe itself.
6. **Known barcode, no network.** Airplane mode. Scan a barcode that was confirmed before. Fundstück shows the owned or missing verdict from the local shelf.
7. **Unknown barcode, no network.** Airplane mode. Scan a new code. It stays in the pending list. Turn the network on, open Fundstück. The pending processor looks the code up. A second code behind a failure stays queued.
8. **Long gap.** Leave one phone offline across many edits on the other, past a normal session. When it returns, its own unsent edits are still on the device, and it receives the other phone's edits. A full reload must not delete a row that never reached the server.
9. **Watched from playback.** Play a server file to the end, or past 90 percent. The film is watched in personal state, and the other phone shows that after the next sync.
10. **Streaming services.** Change the subscription list, leave the app in the foreground, and do not switch away. Today this can sit unsynced until the app is resumed. After the scheduler change below, the other phone should see the new services within a few seconds without a resume.

Write down the build, the two device names, and any step whose result differed. A differing step gets a regression test named after the step, in the file from the table above that already owns that case.

## How to implement the two gaps

Both are small. Do them before treating the device pass as the last word, because steps 7 and 10 fail for a structural reason.

### 1. Sync streaming subscriptions without waiting for resume

`streaming_subscriptions` is a synced record (`subscription` in `CollectionRecords`). `syncSchedulerProvider` in `movieCollector/lib/features/sync/application/sync_providers.dart` listens to movies, series, seasons, editions, copies, barcodes, and personal state. It does not listen to `streamingSubscriptions`, so a subscription edit waits for the next foreground resume or a manual sync.

Add `db.streamingSubscriptions` to that `TableUpdateQuery.onAllTables` list. The five-second debounce already used for the other tables then pushes the change.

Cover it in `sync_engine_test.dart`: insert a subscription on one device, run both engines, and expect the same provider id on the second device. The server already has `StreamingSubscriptionsSyncLikeOtherRecords` in `SyncTests.cs`.

### 2. Drain the offline scan queue when the device is back

`PendingScanProcessor` in `movieCollector/lib/features/scanner/application/scan_providers.dart` runs when the scanner screen opens and when the recent-scans sheet asks it to. It stops at the first `BarcodeUnresolvedOffline` and leaves the rest queued, which is the right stop while the network is still down. Nothing calls it when connectivity returns or when the app resumes onto another tab.

Call `pendingScanProcessorProvider.run()` from the same `AppLifecycleListener.onResume` that already schedules a sync, in `sync_providers.dart`. One resume handler should schedule the sync and start the scan drain. The processor already refuses a second overlapping run.

Add a widget or provider test that queues two codes, resolves the first as a known local barcode, returns `BarcodeUnresolvedOffline` for the second, and expects the first marked resolved and the second still pending. That locks the stop rule. The device pass (step 7) is what shows that resume actually calls it.

## If a device step fails

| What went wrong | Where to change it |
|---|---|
| An offline edit disappeared | `SyncEngine._push` and `_writeShadow` in `lib/core/sync/sync_engine.dart`. The shadow may only move forward inside the transaction that follows a successful push response. |
| The second phone lost its own edit on pull | `SyncEngine._pull`. A field that differs from the shadow stays local while it is blocked or still dirty. A full reload may delete only rows that were in the shadow and are absent from the server. |
| A conflict was overwritten | `SyncMerger.Apply` in `src/MovieShelf.Core/Sync/SyncMerger.cs`, then the phone side that writes `sync_conflicts` and skips those fields in `pendingChanges`. |
| The shelf went empty when the server was off | The caller of `SyncEngine.run` in `sync_providers.dart` and `sync_screen.dart`. A thrown request must leave Drift unread. |
| Switching storage deleted films | `storage_migration.dart`. Leaving self-hosted mode drops the server link and the shadow, and keeps the collection tables. |
| Two offline adds of one film became two films | `SyncIds` in `lib/core/sync/sync_ids.dart`. The id has to be UUIDv5 of `movie:<tmdbId>`, not a random id. |
