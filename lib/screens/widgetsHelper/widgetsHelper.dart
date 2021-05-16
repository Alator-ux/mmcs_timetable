import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/enums.dart';
import '../../main.dart' show SizeProvider;

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final VoidCallback onTap;
  CustomButton({this.width, this.height, this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width != null ? width : SizeProvider().getSize(0.5),
        height: height != null
            ? height
            : SizeProvider().getSize(0.1, from: SizeFrom.height),
        decoration: BoxDecoration(
          color: Colors.cyan[600],
          borderRadius: BorderRadius.all(
            Radius.circular(SizeProvider().getSize(0.02)),
          ),
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;
  final Widget child;
  const MyButton({Key key, this.size, this.onTap, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        child: Container(
          width: size,
          height: size,
          child: child,
        ),
      ),
    );
  }
}
