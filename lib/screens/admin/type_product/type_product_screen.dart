import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../utils/custom_alert_dialog.dart';
import '../../../utils/show_alert.dart';
import 'package:bely_boutique_princess/models/models.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class TypeProductScreen extends StatefulWidget {
  const TypeProductScreen({Key? key}) : super(key: key);

  @override
  State<TypeProductScreen> createState() => _TypeProductScreenState();
}

class _TypeProductScreenState extends State<TypeProductScreen> {
  String? titleTypeProduct;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: S.of(context).title_type_product,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(child: createTypeProduct()),
          SliverFillRemaining(child: showTypeProduct()),
        ],
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget createTypeProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingM),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tipo de producto',
              ),
              validator: (value) => Validators.isValidateOnlyTextMinMax(
                text: value!,
                minCaracter: 1,
                maxCarater: 40,
                messageError: 'Titulo del tipo de producto no valido.',
              ),
              onSaved: (value) => setState(() {
                titleTypeProduct = value;
              }),
            ),
            const SizedBox(height: kPaddingS),
            MaterialButton(
              color: Theme.of(context).primaryColor.withOpacity(.8),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  ShowAlert.showErrorSnackBar(context,
                      message: 'Por favor completa el registro.');
                  return;
                }
                _formKey.currentState!.save();
                var typeProduct = TypeProduct(title: titleTypeProduct!);
                context.read<TypeProductBloc>().add(
                      AddTypeProduct(typeProducts: typeProduct),
                    );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget showTypeProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingS),
      child: BlocBuilder<TypeProductBloc, TypeProductState>(
        builder: (context, state) {
          if (state is TypeProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TypeProductsLoaded) {
            return state.typeProducts.isNotEmpty
                ? DataTable2(
                    columns: const [
                      DataColumn2(label: Text('Titulo')),
                      DataColumn2(label: Text('Opciones')),
                    ],
                    rows: state.typeProducts
                        .map(
                          (e) => DataRow2(
                            cells: [
                              DataCell(Text(e.title)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _customDialogEdit(context, e),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        CustomAlertDialog.contentButtonAndTitle(
                                          context: context,
                                          content: OutlinedButton(
                                            onPressed: () {
                                              BlocProvider.of<TypeProductBloc>(
                                                      context)
                                                  .add(
                                                DeleteTypeProduct(
                                                    typeProducts: e),
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text('CONFIRMAR'),
                                          ),
                                          title: Text(
                                            'Confirmar eliminación',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete_outline)),
                                ],
                              )),
                            ],
                          ),
                        )
                        .toList(),
                  )
                : const SizedBox();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _customDialogEdit(BuildContext context, TypeProduct typeProduct) {
    final GlobalKey<FormState> _formKeyEdit = GlobalKey<FormState>();
    String? editTitleTypeProduct;
    return CustomAlertDialog.contentButtonAndTitle(
      context: context,
      content: Form(
        key: _formKeyEdit,
        child: Column(
          children: [
            TextFormField(
              initialValue: typeProduct.title,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tipo de producto',
              ),
              validator: (value) => Validators.isValidateOnlyTextMinMax(
                text: value!,
                minCaracter: 1,
                maxCarater: 40,
                messageError: 'Titulo del tipo de producto no valido.',
              ),
              onSaved: (value) => setState(() {
                editTitleTypeProduct = value;
              }),
            ),
            OutlinedButton(
              onPressed: () {
                if (!_formKeyEdit.currentState!.validate()) return;
                _formKeyEdit.currentState!.save();
                BlocProvider.of<TypeProductBloc>(context).add(
                  UpdateTypeProduct(
                    typeProduct:
                        typeProduct.copyWith(title: editTitleTypeProduct),
                  ),
                );
                ShowAlert.showSuccessSnackBar(
                  context,
                  message: '¡Tipo de producto actualizado exitosamente!.',
                );
                Navigator.pop(context);
              },
              child: const Text('CONFIRMAR'),
            ),
          ],
        ),
      ),
      title: Text(
        'Confirmar eliminación',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
