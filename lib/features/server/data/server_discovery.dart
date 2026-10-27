import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:multicast_dns/multicast_dns.dart';

class DiscoveredServer {
  const DiscoveredServer({
    required this.name,
    required this.host,
    required this.port,
    required this.serverId,
    required this.fingerprint,
    required this.tls,
    this.securePort,
    this.certificateSha256,
  });

  final String name;
  final String host;
  final int port;
  final String serverId;
  final String fingerprint;
  final bool tls;
  final int? securePort;
  final String? certificateSha256;

  /// Plain HTTP: what mDNS says about the certificate is not trusted until
  /// the signed identity response confirms it.
  String get baseUrl => 'http://$host:$port';
}

abstract class ServerDiscovery {
  Future<List<DiscoveredServer>> discover({
    Duration timeout = const Duration(seconds: 4),
  });
}

class MdnsServerDiscovery implements ServerDiscovery {
  static const _serviceType = '_movieshelf._tcp';
  static const _lock = MethodChannel('movieshelf/multicast');

  @override
  Future<List<DiscoveredServer>> discover({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    await _setLock(true);
    final client = MDnsClient();
    final found = <String, DiscoveredServer>{};
    try {
      await client.start();
      await for (final pointer in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('$_serviceType.local'),
        timeout: timeout,
      )) {
        final server = await _resolve(client, pointer.domainName, timeout);
        if (server != null) found[server.serverId] = server;
      }
    } on SocketException {
      return found.values.toList();
    } finally {
      client.stop();
      await _setLock(false);
    }
    return found.values.toList();
  }

  Future<DiscoveredServer?> _resolve(
    MDnsClient client,
    String instance,
    Duration timeout,
  ) async {
    final service = await _first(
      client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(instance),
        timeout: timeout,
      ),
    );
    final text = await _first(
      client.lookup<TxtResourceRecord>(
        ResourceRecordQuery.text(instance),
        timeout: timeout,
      ),
    );
    if (service == null || text == null) return null;

    final properties = {
      for (final line in text.text.split('\n'))
        if (line.contains('='))
          line.substring(0, line.indexOf('=')): line.substring(
            line.indexOf('=') + 1,
          ),
    };
    final address = await _first(
      client.lookup<IPAddressResourceRecord>(
        ResourceRecordQuery.addressIPv4(service.target),
        timeout: timeout,
      ),
    );
    if (address == null || properties['id'] == null) return null;

    return DiscoveredServer(
      name: instance.split('.$_serviceType').first,
      host: address.address.address,
      port: service.port,
      serverId: properties['id']!,
      fingerprint: properties['fp'] ?? '',
      tls: properties['tls'] == '1',
      securePort: int.tryParse(properties['sp'] ?? ''),
      certificateSha256: properties['cfp'],
    );
  }

  static Future<T?> _first<T>(Stream<T> stream) async {
    await for (final value in stream) {
      return value;
    }
    return null;
  }

  Future<void> _setLock(bool held) async {
    try {
      await _lock.invokeMethod<void>(held ? 'acquire' : 'release');
    } on MissingPluginException {
      return;
    }
  }
}
