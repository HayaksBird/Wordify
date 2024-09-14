import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';
import 'package:wordify/core/presentation/ui_kit/wordify_overlay_entry.dart';

class WordActionsOverlay {
  ///
  static void showOverlay({
    required VoidCallback update,
    required VoidCallback delete,
    required Offset position,
    VoidCallback? onOverlayClosed,
    required BuildContext context
  }) {
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => WordifyOverlayEntry(
        inputs: _toDoAction(update, delete),
        position: position,
        overlayEntry: overlayEntry,
        onOverlayClosed: onOverlayClosed
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }


  ///
  static List<DoAction> _toDoAction(
    Function update,
    Function delete
  ) {
    return [
      DoAction(
        title: 'Update',
        action: update,
        icon: Icons.edit,
        color: AppColors.text
      ),

      DoAction(
        title: 'Delete',
        action: delete,
        icon: Icons.delete,
        color: AppColors.error
      ),
    ];
  }
}