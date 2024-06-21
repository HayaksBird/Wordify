import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///
class AddWordButton extends FloatingActionButton {
  const AddWordButton({
    super.key,
    required VoidCallback super.onPressed,
  }) : super(
        child: const Icon(Icons.add),
        tooltip: 'Add Word',
      );
}


///
class SubmitButton extends ElevatedButton {
  SubmitButton({
    super.key,
    required VoidCallback super.onPressed,
  }) : super(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Submit'),
      );
}


///
class ReturnButton extends TextButton {
  ReturnButton({
    super.key,
    required VoidCallback super.onPressed,
  }) : super(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Return'),
      );
}


///
class ChooseItemButton extends DropdownButton<Folder> {
  ChooseItemButton({
    super.key,
    required List<Folder> items,
    Folder? selectedItem,
    required ValueChanged<Folder?> super.onChanged,
  }) : super(
        hint: const Text("Select a Folder"),
        value: selectedItem,
        items: items.map<DropdownMenuItem<Folder>>((Folder folder) {
          return DropdownMenuItem<Folder>(
            value: folder,
            child: Text(folder.name),
          );
        }).toList(),
      );
}