import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ma_navigation.dart';
import '../theme/ma_build_context_extension.dart';

mixin UIMessagesManager {
  BuildContext get _context => Get.context!;

  void showMessage({required String message}) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showError({required String message}) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _context.colors.errorContainerDark,
      ),
    );
  }

  void showModalInfo({
    String? title,
    required String message,
    void Function()? onPressed,
  }) {
    showDialog(
      context: _context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: title != null,
                  child: Text(
                    title ?? '',
                    style: Theme.of(_context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 12),
                Text(message, style: Theme.of(_context).textTheme.bodyLarge),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          MaNavigation.pop();
                          if (onPressed != null) onPressed();
                        },
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showModalQuestion({
    String? title,
    required String message,
    void Function()? onPressedNo,
    required void Function()? onPressedYes,
  }) async {
    await showDialog(
      context: _context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: title != null,
                  child: Text(title ?? '',
                      style: Theme.of(_context).textTheme.titleLarge),
                ),
                const SizedBox(height: 12),
                Text(message, style: Theme.of(_context).textTheme.bodyLarge),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: onPressedNo ?? MaNavigation.pop,
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(_context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(_context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: Theme.of(_context).colorScheme.primary),
                          ),
                        ),
                        child: const Text('Não'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: onPressedYes ?? MaNavigation.pop,
                        child: const Text('Sim'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
