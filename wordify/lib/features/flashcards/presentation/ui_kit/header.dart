import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/core/ui_kit/stripe_list_widget.dart';

///Show the header for the flashcards page.
///Contains the return button and the folder path.
class Header extends StatelessWidget {
  final String path, delimiter;


  const Header({
    super.key,
    required this.path,
    required this.delimiter
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          color: AppColors.primary,
          child: Row(
            children: [
              NavigationBackButton(
                text: 'Return',
                goBack: () { Navigator.pop(context); }
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StripeListWidget(
                    path: path,
                    delimiter: delimiter,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.navigationSecondary,
          height: 0,
          thickness: 0.3,
        )
      ]
    );
  }
}