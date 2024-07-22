import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

class FolderRowWidget extends StatelessWidget {
  final bool isExpanded;
  final Widget listTile;
  final void Function() toggleFolder;
  final int layer;
  final bool isFirstFolder;
  static bool drawStripe = true;


  const FolderRowWidget({
    super.key,
    required this.isExpanded,
    required this.listTile,
    required this.toggleFolder,
    required this.layer,
    this.isFirstFolder = false
  });


  @override
  Widget build(BuildContext context) {
    //If its the first folder then make sure that it has a stripe
    isFirstFolder ? drawStripe = true : drawStripe = !drawStripe;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      
      child: Container(
        decoration: BoxDecoration(
          color: drawStripe ? AppColors.primaryDarkerVariant : null,
          borderRadius: BorderRadius.circular(10.0) // Adjust the radius as needed
        ),

        //Depending on the layer in the tree provide an offset
        padding: EdgeInsets.only(left: 22.0 * layer),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IgnorePointer(
              ignoring: false,
              child: IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4.0),
                onPressed: toggleFolder,
                icon: isExpanded ?
                const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppColors.text,
                  size: 20.0,
                ) :
                const Icon(
                  Icons.keyboard_arrow_right_sharp,
                  color: AppColors.text,
                  size: 20.0,
                ),
              ),
            ),
        
            Expanded(
              child: listTile
            )
          ],
        ),
      ),
    );
  }
}



///
class FolderTileWidget extends StatelessWidget { 
  final String name;
  final bool isActivated;


  const FolderTileWidget({
    super.key,
    required this.name,
    required this.isActivated
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14.0,
          color: isActivated ? AppColors.textClicked : AppColors.text,
        ),
      ),
    );
  }
}