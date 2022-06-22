import 'package:flutter/material.dart';

class SettingItemNormal extends StatelessWidget {
  final String title;
  final List<SettingOpcionNormal> listItems;
  const SettingItemNormal(
      {Key? key, required this.title, required this.listItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // seccion account
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 30),
              const SizedBox(width: 25),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const Divider(),
          Column(
            children: listItems.map<Widget>((e) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => e.onTap(),
                    child: Row(
                      children: [
                        Text('Temas',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SettingOpcionNormal {
  final String title;
  final Function onTap;

  SettingOpcionNormal({required this.title, required this.onTap});
}
