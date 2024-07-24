import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/core/ui_kit/components.dart';

class FolderActionsOverlay {
  
  ///
  static void showOverlay({
    required VoidCallback create,
    required VoidCallback update,
    required VoidCallback delete,
    required Offset position,
    required BuildContext context
  }) {
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => WordifyOverlayEntry(
        inputs: _toDoAction(create, update, delete),
        position: position,
        overlayEntry: overlayEntry,
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }


  ///
  static List<DoAction> _toDoAction(
    Function create,
    Function update,
    Function delete
  ) {
    return [
      DoAction(
        title: 'Create',
        action: create,
        icon: Icons.add_circle_outline_rounded,
        color: AppColors.text
      ),

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