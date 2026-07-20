import 'package:flutter/material.dart';

class MyScheduleScreen
    extends StatelessWidget {
  const MyScheduleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Schedule',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(32),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons
                    .favorite_outline,
                size: 58,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Your personal schedule',
                textAlign:
                    TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Sets you like will appear here in chronological order.',
                textAlign:
                    TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}