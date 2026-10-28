import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/features/playback/data/pending_stops.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a position that could not be sent is sent next time', () async {
    final stops = PendingStops(await SharedPreferences.getInstance());
    await stops.add('s1', 812.5, 7200);
    await stops.add('s2', 30, 5400);
    await stops.add('s1', 900, 7200);
    expect(stops.all, hasLength(2));

    final sent = <String, double>{};
    var online = false;
    Future<void> stop(String session, double position, double duration) async {
      if (!online) throw const ServerUnreachableException();
      if (session == 's2') throw const ServerRejectedException('weg', 404);
      sent[session] = position;
    }

    // Still offline: everything stays.
    await stops.flush(stop);
    expect(stops.all, hasLength(2));

    online = true;
    await stops.flush(stop);
    expect(sent, {'s1': 900});
    // The session the server no longer knows is not kept either.
    expect(stops.all, isEmpty);
  });
}
