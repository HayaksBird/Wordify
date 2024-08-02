import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/core/ui_kit/word_view/stripe_list_widget.dart';

class WordListTemplateWidget extends StatelessWidget {
  final String path, delimiter;
  final bool isBuffer;
  final Widget list;
  final void Function() closePressed;
  final void Function() addWordPressed;


  const WordListTemplateWidget({
    super.key,
    required this.path,
    required this.delimiter,
    required this.list,
    required this.closePressed,
    this.isBuffer = false,
    required this.addWordPressed
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: Container( //Outter frame with the list of words
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
                child: isBuffer ? _bufferHeading() : _heading()
              ),

              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Divider(
                  color: AppColors.navigationSecondary,
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
          child: _addWordButton()
        ),
    
        _closeButton()
      ]
    );
  }


  ///
  Widget _bufferHeading() {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'Buffer',
              style: TextStyle(
                color: AppColors.navigation,
                fontSize: 18.0,
              ),
            ),
          )
        ),

        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: _addWordButton()
        ),
    
        _closeButton()
      ],
    );
  }


  ///
  Widget _addWordButton() {
    return Tooltip(
      message: 'Add new word',
      waitDuration: const Duration(milliseconds: 400),
      child: IconButton(
        icon: const Icon(
          Icons.add_circle,
          color: AppColors.navigation,
        ),
        onPressed: addWordPressed
      )
    );
  }


  ///
  Widget _closeButton() {
    return Tooltip(
      message: 'Close',
      waitDuration: const Duration(milliseconds: 400),
      child: IconButton(
        icon: const Icon(
          Icons.close_rounded,
          color: AppColors.navigation,
        ),
        onPressed: closePressed
      )
    );
  }
}