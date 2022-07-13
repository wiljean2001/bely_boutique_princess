import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CustomDropDown<T> extends StatelessWidget {
  final List<MultiSelectItem<T>> listItems;
  final List<T>? listInitialValue;
  final Function(List<T> values) onConfirm;
  final Function(List<T> values) validator;
  final Text buttonText;
  final Widget title;

  const CustomDropDown({
    Key? key,
    required this.listItems,
    this.listInitialValue,
    required this.onConfirm,
    required this.validator,
    required this.buttonText,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        MultiSelectDialogField(
          separateSelectedItems: true,
          searchable: true,
          items: listItems,
          onConfirm: (List<T> values) => onConfirm(values),
          // validator: ,
          initialValue: listInitialValue ?? listInitialValue,
          cancelText: const Text('CANCELAR'),
          confirmText: const Text('ACEPTAR'),
          buttonText: buttonText,
          buttonIcon: const Icon(Icons.keyboard_arrow_down_outlined),
          dialogHeight: listItems.length * 55,
          validator: (List<T>? value) => value != null
              ? validator(value)
              : 'Selecciona al menos una opción.',
          title: title,
        ),
      ],
    );
  }
}

//   return DropdownButton<String>(
//     hint: const Text('Categorias'),
//     isExpanded: true,
//     focusColor: Theme.of(context).primaryColor.withOpacity(.5),
//     value: dropdownValue,
//     icon: const Icon(
//       Icons.keyboard_arrow_down_outlined,
//       size: 45,
//     ),
//     elevation: 8,
//     style: Theme.of(context).textTheme.titleMedium,
//     borderRadius: const BorderRadius.all(Radius.circular(10)),
//     underline: Container(
//       height: 2,
//       color: Theme.of(context).primaryColorDark,
//     ),

//     // cambiar por tipo Categorias
//     // items: <String>['opcion1', 'opcion2', 'opcion3']
//     items: state.categories.map<DropdownMenuItem<String>>(
//       (Category value) {
//         return DropdownMenuItem<String>(
//             value: value.name, child: Text(value.name));
//       },
//     ).toList(),
//     onChanged: (String? index) {
//       setState(
//         () {
//           dropdownValue = index!;
//         },
//       );
//     },
//   );
