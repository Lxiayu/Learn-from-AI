import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/src/app/router/app_route_page.dart';

void main() {
  test('buildAppPage creates a no-transition page', () {
    const ValueKey<String> key = ValueKey<String>('route-page');

    final Page<void> page = buildAppPage<void>(
      key: key,
      child: const SizedBox(),
    );

    expect(page, isA<NoTransitionPage<void>>());
    expect(page.key, key);
  });
}
