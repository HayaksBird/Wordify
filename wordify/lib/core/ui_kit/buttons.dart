import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

///
class WordifyFloatingActionButton extends FloatingActionButton {
  const WordifyFloatingActionButton({
    super.key,
    required VoidCallback super.onPressed,
    required String tooltip,
  }) : super(
        child: const Icon(Icons.add, color: AppColors.text),
        tooltip: tooltip,
        backgroundColor: AppColors.navigation,
        shape: const CircleBorder(),
      );
}



///
class WordifyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;


  const WordifyElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.navigation; // Change this to your desired pressed color
            }

            return AppColors.primary; // Default color
          },
        ),

        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary; // Change this to your desired pressed color
            }

            return AppColors.navigation;
          },
        ),

        textStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) {
            return const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            );
          },
        ),

        side: WidgetStateProperty.resolveWith<BorderSide>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return const BorderSide(color: AppColors.navigation, width: 1.0); // Change this to your desired hover border
            }
            return BorderSide.none; // Default border
          },
        ),

        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),

        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}



///
class WordifyTextButton extends TextButton {
  WordifyTextButton({
    super.key,
    required VoidCallback super.onPressed,
    required String text,
  }) : super(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.navigation,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text),
      );
}



///
class ButtonsInRow extends StatelessWidget {
  final List<Widget> buttons;
  
  
  const ButtonsInRow({
    super.key,
    required this.buttons
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons
      )
    );
  }
}



///
class ArrowUpButton extends IconButton {
  const ArrowUpButton({
    super.key,
    required VoidCallback super.onPressed,
  }) : super(
          icon: const Icon(
            Icons.keyboard_arrow_up_sharp,
            color: AppColors.navigationSecondary,
            size: 25
          )
        );
}



///
class ArrowDownButton extends IconButton {
  const ArrowDownButton({
    super.key,
    required VoidCallback super.onPressed,
  }) : super(
          icon: const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: AppColors.navigationSecondary,
            size: 25
          )
        );
}