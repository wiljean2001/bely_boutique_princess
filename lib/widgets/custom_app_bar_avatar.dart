import 'package:flutter/material.dart';

class TransitionAppBar extends StatelessWidget {
  const TransitionAppBar({
    required this.avatar,
    required this.title,
    this.onTapIcon,
    required this.textTheme,
    this.extent = 250,
    this.withIcon = false,
    Key? key,
  }) : super(key: key);

  final Widget avatar;
  final double extent;
  final String title;
  final bool withIcon;
  final Function? onTapIcon;
  final TextStyle textTheme;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
        avatar: avatar,
        title: title,
        extent: extent > 200 ? extent : 200,
        withIcon: withIcon,
        onTapIcon: onTapIcon != null ? onTapIcon : () {},
        textTheme: textTheme,
      ),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  _TransitionAppBarDelegate({
    required this.avatar,
    required this.title,
    required this.textTheme,
    this.extent = 250,
    this.withIcon = false,
    this.onTapIcon,
  }) : assert(extent >= 200, '');

  final Widget avatar;
  final double extent;
  final String title;
  final bool withIcon;
  final Function? onTapIcon;
  final TextStyle textTheme;

  // Alineación del avatar - pequeño a grande
  final _avatarAlignTween =
      AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.centerLeft);
  final _avatarMarginTween = EdgeInsetsTween(
    end: const EdgeInsets.only(left: 14, top: 36),
  );

  // Alineacion del icono
  final _iconAlignTween =
      AlignmentTween(begin: Alignment.bottomRight, end: Alignment.topRight);

  final _titleMarginTween = EdgeInsetsTween(
    begin: const EdgeInsets.only(bottom: 20),
    end: const EdgeInsets.only(left: 64, top: 45),
  );

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return avatar != oldDelegate.avatar || title != oldDelegate.title;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final tempVal = maxExtent * 72 / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final avatarMargin = _avatarMarginTween.lerp(progress);
    final titleMargin = _titleMarginTween.lerp(progress);

    final avatarAlign = _avatarAlignTween.lerp(progress);
    final iconAlign = _iconAlignTween.lerp(progress);

    final double widthScreen = MediaQuery.of(context).size.width;
    final avatarSize = (1 - progress) * widthScreen + 32;
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 80,
          constraints: BoxConstraints(maxHeight: minExtent),
          color: progress < 1
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white, //  Colors.white
          // color: Theme.of(context).primaryColor,
        ),
        Padding(
          padding: avatarMargin,
          child: Align(
            alignment: avatarAlign,
            child: SizedBox(
              height: avatarSize,
              width: avatarSize,
              child: avatar,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: progress < 0.4 ? 100 * (1 - progress) * 1.5 : 0,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //       Colors.pink[200]!.withOpacity(0.05),
            //       Colors.pink[400]!.withOpacity(0.8),
            //     ],
            //   ),
            // ),
          ),
        ),
        Padding(
          padding: titleMargin,
          child: Align(
            alignment: avatarAlign,
            child: Text(
              title,
              style: textTheme.copyWith(
                color: progress < 0.9 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        withIcon
            ? Padding(
                padding: titleMargin,
                child: Align(
                  alignment: iconAlign,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => onTapIcon != null ? onTapIcon!() : {},
                      child: Icon(
                        Icons.close_outlined,
                        size: 30,
                        color: progress < 0.4 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
