import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

NoTransitionPage<T> buildAppPage<T>({
  required LocalKey key,
  required Widget child,
  String? name,
}) {
  return NoTransitionPage<T>(
    key: key,
    name: name,
    child: child,
  );
}
