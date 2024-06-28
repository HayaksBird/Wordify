import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///
class WordifyFloatingActionButton extends FloatingActionButton {
  const WordifyFloatingActionButton({
    super.key,
    required VoidCallback super.onPressed,
    required String tooltip
  }) : super(
        child: const Icon(Icons.add),
        tooltip: tooltip,
      );
}


///
class WordifyElevatedButton extends ElevatedButton {
  WordifyElevatedButton({
    super.key,
    required VoidCallback super.onPressed,
    required String text,
  }) : super(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text),
      );
}


///
class WordifyTextButton extends TextButton {
  WordifyTextButton({
    super.key,
    required VoidCallback super.onPressed,
    required String text,
  }) : super(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text),
      );
}


///
class ChooseItemButton extends DropdownButtonFormField<Folder> {
  ChooseItemButton({
    super.key,
    required List<Folder> items,
    required Folder? selectedItem,
    required ValueChanged<Folder?> super.onChanged,
    super.validator,
  }) : super(
        hint: const Text("Select a Folder"),
        value: selectedItem,
        items: items.map<DropdownMenuItem<Folder>>((Folder folder) {
          return DropdownMenuItem<Folder>(
            value: folder,
            child: Text(folder.name),
          );
        }).toList()
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons
      )
    );
  }
}