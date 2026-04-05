import 'api_transport_base.dart';
import 'api_transport_io.dart'
    if (dart.library.html) 'api_transport_web.dart' as impl;

export 'api_transport_base.dart';

ApiTransport createDefaultApiTransport() => impl.createApiTransport();
