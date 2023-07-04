
import 'package:flutter/material.dart';
import 'package:my_notes/utilities/Dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context){
  return showGenericDialog<bool>(
      context: context,
      title: 'Log Out',
      content: 'Are you sure you want to logout?',
      optionBuilder: () =>{
        'Cancel' : false,
        'Logout' : true,
      },
  ).then((value) => value ?? false);
}

