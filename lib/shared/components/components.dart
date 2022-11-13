// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, constant_identifier_names, prefer_is_empty, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_social_app/shared/styles/icon_broken.dart';
import 'package:fluttertoast/fluttertoast.dart';


// reusable components :

// 1. timing
// 2. refactor
// 3. quality
// 4. clean code

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) => AppBar(
  leading: IconButton(
    icon: Icon(
      IconBroken.Arrow___Left_2,
    ),
    onPressed: ()
    {
      Navigator.pop(context);
    },
  ),
  titleSpacing: 5.0,
  title: Text(
    title!,
  ),
  actions: actions,
);

Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double border = 10.0,
  required VoidCallback? function,
  required String text,
}) => Container(
  width: width,
  height: 38.0,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
          color: Colors.white
      ),
    ),
  ),
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(
        border
    ),
  ),
);

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
          text.toUpperCase(),
      ),
    );

Widget defaultFormField ({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  required FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) => TextFormField(

  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  enabled: isClickable,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: onTap,
  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix
    ),
    suffixIcon: suffix != null ? IconButton(
      icon: Icon(
        suffix,
      ),
      onPressed: suffixPressed!(),
    )
    : null,
    border: OutlineInputBorder(),
  ),
);

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

void navigateTo(
       context,
       widget,
     )
=> Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => widget,
     ),
   );

void navigateAndFinish(
       context,
       widget,
     )
=> Navigator.pushAndRemoveUntil(
     context,
     MaterialPageRoute(
       builder: (context) => widget,
     ),
     (Route<dynamic> route)
     {
       return false;
     },
   );

void showToast({
  required String text,
  required ToastStates state,
}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

// enum
enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;

  switch(state)
  {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}


