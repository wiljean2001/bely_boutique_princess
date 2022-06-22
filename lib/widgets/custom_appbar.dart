import 'package:flutter/material.dart';
import '../generated/assets.dart';
import '../generated/l10n.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool hasActions;
  final bool hasIcon;
  final Function? onTapOption;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasActions = true,
    this.hasIcon = true,
    this.onTapOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: SizedBox(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                hasIcon
                    ? const Image(
                        image: AssetImage(Assets.imagesLocoCorona),
                        width: 45,
                      )
                    : const SizedBox(),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
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
                        borderRadius: BorderRadius.circular(
                            AppBar().preferredSize.height),
                        child: Tooltip(
                          message: S.of(context).tooltip_bttn_search_products,
                          child: Icon(Icons.search_outlined,
                              color: Theme.of(context).primaryColorLight),
                        ),
                        onTap: () => onTapOption != null ? onTapOption!() : {},
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
