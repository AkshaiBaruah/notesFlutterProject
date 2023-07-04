import 'package:flutter/material.dart';
import 'package:my_notes/utilities/Dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context){
  return showGenericDialog(
      context: context,
      title: 'Delete',
      content: 'Are you sure you want to delete this item',
      optionBuilder: () =>{
        'Cancel' : false,
        'Delete' : true,
      },
  ).then((value) => value ?? false);
}