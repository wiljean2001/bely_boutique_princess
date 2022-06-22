import 'package:flutter/material.dart';

class CustomButtonGradiant extends StatelessWidget {
  final double width, height;
  final Function onPressed;
  final Icon icon;
  final Text text;

  const CustomButtonGradiant({
    Key? key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xffffae88), Color(0xff8f93ea)],
        ),
      ),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        onPressed: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            text,
            icon,
          ],
        ),
      ),
    );
  }
}
