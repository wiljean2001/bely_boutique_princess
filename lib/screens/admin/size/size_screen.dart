import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

import '../../../blocs/blocs.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/show_alert.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_sliver_app_bar.dart';
import 'package:bely_boutique_princess/models/models.dart';

class SizeScreen extends StatefulWidget {
  const SizeScreen({Key? key}) : super(key: key);

  @override
  State<SizeScreen> createState() => _SizeScreenState();
}

class _SizeScreenState extends State<SizeScreen> {
  String? titlesizeProduct;
  TypeProduct? typeProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TypeProductBloc, TypeProductState>(
        builder: (context, stateTypeProduct) {
          if (stateTypeProduct is TypeProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (stateTypeProduct is TypeProductsLoaded) {
            return CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  title: S.of(context).title_size_screen,
                  hasActions: false,
                  hasIcon: false,
                  isTextCenter: false,
                ),
                SliverToBoxAdapter(child: createSizeProduct(stateTypeProduct)),
                SliverToBoxAdapter(child: selectSizeProduct(stateTypeProduct)),
                SliverFillRemaining(child: showSizeProduct(stateTypeProduct)),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget createSizeProduct(TypeProductsLoaded stateTypeProduct) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingM),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REGISTRAR TALLA',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingL, vertical: kPaddingS),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Talla',
                ),
                validator: (value) => Validators.isValidateOnlyTextMinMax(
                  text: value!,
                  minCaracter: 1,
                  maxCarater: 8,
                  messageError: 'Titulo del tipo de producto no valido.',
                ),
                onSaved: (value) => setState(() {
                  titlesizeProduct = value;
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingL, vertical: kPaddingS),
              child: DropDown(
                isExpanded: true,
                items: stateTypeProduct.typeProducts,
                customWidgets: stateTypeProduct.typeProducts
                    .map((e) => Text(e.title))
                    .toList(),
                onChanged: (TypeProduct? typeP) {
                  typeProduct = typeP!;
                },
                hint: const Text('Tipo de producto'),
              ),
            ),
            const SizedBox(height: kPaddingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate() ||
                        typeProduct == null) {
                      ShowAlert.showErrorSnackBar(context,
                          message: 'Por favor completa el registro.');
                      return;
                    }
                    // save all form
                    _formKey.currentState!.save();
                    final sizeProduct = SizeProduct(
                      size: titlesizeProduct!,
                      typeProductId: typeProduct!.id!,
                    );
                    context.read<SizeProductBloc>().add(
                          AddSizeProduct(sizeProduct: sizeProduct),
                        );
                    ShowAlert.showSuccessSnackBar(
                      context,
                      message: '¡Talla agregada exitosamente!.',
                    );
                  },
                  child: const Text('Registrar'),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: kPaddingL,
            ),
          ],
        ),
      ),
    );
  }

  Widget selectSizeProduct(TypeProductsLoaded stateTypeProduct) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingS),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VER TALLAS',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kPaddingL, vertical: kPaddingS),
            child: DropDown(
              hint: const Text('Seleccionar una opción'),
              isExpanded: true,
              items: stateTypeProduct.typeProducts,
              customWidgets: stateTypeProduct.typeProducts
                  .map(
                    (e) => Text(e.title),
                  )
                  .toList(),
              onChanged: (TypeProduct? typeP) {
                context.read<SizeProductBloc>().add(
                      LoadSizeProducts(typeProductId: typeP!.id),
                    );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget showSizeProduct(TypeProductsLoaded stateTypeProduct) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingS),
      child: BlocBuilder<SizeProductBloc, SizeProductState>(
        builder: (context, stateSizeProduct) {
          if (stateSizeProduct is SizeProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (stateSizeProduct is SizeProductsLoaded) {
            return stateSizeProduct.sizeProducts.isNotEmpty
                ? DataTable2(
                    columns: const [
                      DataColumn2(label: Text('Talla')),
                      DataColumn2(label: Text('Opciones')),
                    ],
                    rows: stateSizeProduct.sizeProducts
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(Text(e.size)),
                              DataCell(Row(
                                children: [
                                  _customDialogEdit(
                                      context, e, stateTypeProduct),
                                  IconButton(
                                      onPressed: () {
                                        CustomAlertDialog.contentButtonAndTitle(
                                          context: context,
                                          content: OutlinedButton(
                                            onPressed: () {
                                              BlocProvider.of<SizeProductBloc>(
                                                      context)
                                                  .add(
                                                DeleteSizeProduct(
                                                    sizeProduct: e),
                                              );
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  IconButton _customDialogEdit(
    BuildContext context,
    SizeProduct sizeProduct,
    TypeProductsLoaded stateTypeProduct,
  ) {
    String? editTitleSizeProduct;
    bool clearDropDown = false;

    TypeProduct? editTypeProduct = stateTypeProduct.typeProducts.firstWhere(
      (e) => e.id == sizeProduct.typeProductId,
    );
    final GlobalKey<FormState> _formKeyOnDialog = GlobalKey<FormState>();
    return IconButton(
        onPressed: () => CustomAlertDialog.contentButtonAndTitle(
              context: context,
              content: Form(
                key: _formKeyOnDialog,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: sizeProduct.size,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Talla',
                      ),
                      validator: (value) => Validators.isValidateOnlyTextMinMax(
                        text: value!,
                        minCaracter: 1,
                        maxCarater: 8,
                        messageError: 'Titulo del tipo de producto no valido.',
                      ),
                      onSaved: (value) => setState(() {
                        editTitleSizeProduct = value;
                      }),
                    ),
                    DropDown(
                      initialValue: editTypeProduct,
                      isExpanded: true,
                      items: stateTypeProduct.typeProducts,
                      customWidgets: stateTypeProduct.typeProducts
                          .map((e) => Text(e.title))
                          .toList(),
                      onChanged: (TypeProduct? typeP) {
                        editTypeProduct = typeP!;
                      },
                      isCleared: clearDropDown,
                      hint: const Text('Tipo de producto'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (!_formKeyOnDialog.currentState!.validate()) return;
                        // new size: editTitleSizeProduct
                        // new type product id: editTypeProduct
                        // print(editTypeProduct);
                        _formKeyOnDialog.currentState!.save();
                        BlocProvider.of<SizeProductBloc>(context).add(
                          UpdateSizeProduct(
                            sizeProduct: sizeProduct.copyWith(
                              size: editTitleSizeProduct,
                              typeProductId: editTypeProduct!.id,
                            ),
                          ),
                        );
                        Navigator.pop(context);
                        ShowAlert.showSuccessSnackBar(context,
                            message: '¡Talla actualizada exitosamente!.');
                        // clearDropDown
                      },
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
              title: Text(
                'Actualizar talla',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
        icon: const Icon(Icons.edit_outlined));
  }
}
