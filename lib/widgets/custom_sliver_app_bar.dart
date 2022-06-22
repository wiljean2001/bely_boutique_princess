import 'package:flutter/material.dart';

import '../generated/assets.dart';
import '../generated/l10n.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final bool hasActions;
  final bool hasIcon;
  final Function? onTapOption;
  final bool isTextCenter;

  const CustomSliverAppBar({
    Key? key,
    required this.title,
    this.hasActions = true,
    this.hasIcon = true,
    this.onTapOption,
    this.isTextCenter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      // backgroundColor: Colors.transparent,
      floating: true,
      elevation: 8.0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment:
            isTextCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          hasIcon
              ? const Image(
                  image: AssetImage(Assets.imagesLocoCorona),
                  width: 45,
                )
              : const SizedBox(),
          isTextCenter ? const SizedBox() : const SizedBox(width: 40),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
      actions: [
        hasActions
            ? Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Container(
                  width: AppBar().preferredSize.height - 8,
                  height: AppBar().preferredSize.height - 8,
                  color: Colors.transparent,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onTapOption != null ? onTapOption!() : {},
                      borderRadius:
                          BorderRadius.circular(AppBar().preferredSize.height),
                      child: Tooltip(
                        message: S.of(context).tooltip_bttn_search_products,
                        child: Icon(Icons.search_outlined,
                            color: Theme.of(context).primaryColorLight),
                      ),
                      // onTap: () => onTapOption != null ? onTapOption!() : {},
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
