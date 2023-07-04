import 'package:flutter/cupertino.dart';

extension ContextArgs on BuildContext{
  T? contextArgs<T> (){
    final args = ModalRoute.of(this)?.settings.arguments;
    if(args != null && args is T){
      return args as T;
    }else{
      return null;
    }
  }
}

//we aren't guarding us on modal route being null
//what will we return if modalroute of(this> is null -> args ->null