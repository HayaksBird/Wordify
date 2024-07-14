import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/core/ui_kit/word_view/stripe_list_widget.dart';

class WordListTemplateWidget extends StatelessWidget {
  final String path, delimiter;
  final Widget list;


  const WordListTemplateWidget({
    super.key,
    required this.path,
    required this.delimiter,
    required this.list
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: const Color(0xFF352839),
          borderRadius: BorderRadius.circular(20), // Change the value to adjust the roundness
        ),

        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: _heading()
              ),

              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Divider(
                  color: AppColors.text,
                  height: 0,
                  thickness: 0.2,
                ),
              ),

              Expanded(child: list)
            ]
          ),
        )
      ),
    );
  }


  ///
  Widget _heading() {
    return Row(
      children: [ 
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StripeListWidget(
              path: path,
              delimiter: delimiter,
            ),
          ),
        ),
    
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.navigation,
            ),
            onPressed: () {},
          ),
        ),
    
        IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.navigation,
          ),
          onPressed: () {},
        )
      ]
    );
  }
}