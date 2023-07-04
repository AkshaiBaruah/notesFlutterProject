import 'package:flutter/material.dart';
import 'package:my_notes/utilities/Dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
   BuildContext context,
   String text ,
) {
  return showGenericDialog(
      context: context,
      title: 'Oops! An error occured',
      content: text,
      optionBuilder: () {      //option builder expected a function that return a map
        return {             //function body that return the required map
          'OK' : null,
        };
      },
  );
}