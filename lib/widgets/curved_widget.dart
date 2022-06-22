import 'package:flutter/material.dart';

class CurvedWidget extends StatelessWidget {
  final Widget chield;
  final double curvedDistance, curvedHeight;
  final int mode;

  const CurvedWidget(
      {Key? key,
      required this.chield,
      this.curvedDistance = 80,
      this.curvedHeight = 80,
      this.mode = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveWidgetBackgroundClipper(
        curvedDistance: curvedDistance,
        curvedHeight: curvedHeight,
        mode: mode,
      ),
      child: chield,
    );
  }
}

class CurveWidgetBackgroundClipper extends CustomClipper<Path> {
  final double curvedDistance;
  final double curvedHeight;
  final int mode;

  CurveWidgetBackgroundClipper({
    required this.curvedDistance,
    required this.curvedHeight,
    required this.mode,
  });

  @override
  getClip(Size size) {
    Path clippedpath = Path();
    if (mode == 0) {
      clippedpath.lineTo(size.width, 0);

      clippedpath.lineTo(
          size.width, size.height - curvedDistance - curvedHeight);

      clippedpath.quadraticBezierTo(size.width, size.height - curvedHeight,
          size.width - curvedDistance, size.height - curvedHeight);

      clippedpath.lineTo(curvedDistance, size.height - curvedHeight);

      clippedpath.quadraticBezierTo(
          0, size.height - curvedHeight, 0, size.height);

      clippedpath.lineTo(0, 0);
    }
    if (mode == 1) {
      clippedpath.lineTo(0, size.height - curvedHeight);
      clippedpath.quadraticBezierTo(size.width / 4, size.height - 40,
          size.width / 2, size.height - 20 * 2);
      clippedpath.quadraticBezierTo(
          3 / 4 * size.width, size.height, size.width, size.height - 30 * 2);
      clippedpath.lineTo(size.width, 0);
    }
    if (mode == 2) {
      clippedpath.lineTo(0, size.height * .9);
      var firstEndPoint = new Offset(size.width * .5, size.height * .9);
      var firstControlPoint = new Offset(size.width * .25, size.height);
      clippedpath.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondEndPoint = new Offset(size.width, size.height);
      var secondControlPoint = new Offset(size.width * .75, size.height * .75);
      clippedpath.quadraticBezierTo(secondControlPoint.dx,
          secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

      clippedpath.lineTo(size.width, 0);
      clippedpath.lineTo(0, 0);
    }
    if (mode == 3) {}

    return clippedpath;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
