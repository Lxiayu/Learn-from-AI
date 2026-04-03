import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class AppScaffoldShell extends StatelessWidget {
  const AppScaffoldShell({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
