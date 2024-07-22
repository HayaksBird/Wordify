import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

///Template for a path choice.
class ChooseWordTemplateWidget extends StatelessWidget {
  final Widget folders;
  final VoidCallback goBack;
  final String path;


  const ChooseWordTemplateWidget({
    super.key,
    required this.folders,
    required this.goBack,
    required path
  }): path = 'Saving to: $path';


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(  //Header
            color: AppColors.secondary1,
            child: Row(
              children: [
                _goBackButton(),
                _path(),
                const SizedBox(width: 15.0),
              ],
            ),
          ),
      
          const Divider(
            color: AppColors.navigationSecondary,
            height: 0,
            thickness: 0.2,
          ),
      
          Container(
            color: AppColors.primary,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 170.0,
              ),
              child: folders
            ),
          )
        ],
      ),
    );
  }


  ///
  Widget _goBackButton() {
    return TextButton(
      onPressed: goBack,
      child: const Row(
        children: [
          Icon(
            Icons.keyboard_arrow_left_sharp,
            size: 18.0,
            color: AppColors.navigation
          ),
          SizedBox(width: 4.0),
          Text(
            'Back',
            style: TextStyle(
              fontSize: 14.0,
              color: AppColors.navigation
            ),
          ),
          SizedBox(width: 4.0),
        ],
      )
    );
  }


  Widget _path() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          path,
          style: const TextStyle(
            fontSize: 14.0,
            color: AppColors.navigation
          ),
        )
      ),
    );
  }
}