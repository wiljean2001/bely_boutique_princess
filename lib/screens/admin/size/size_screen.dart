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
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: S.of(context).title_size_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(child: createSizeProduct()),
          SliverToBoxAdapter(child: selectSizeProduct()),
          SliverFillRemaining(child: showSizeProduct()),
        ],
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget createSizeProduct() {
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
              // TODO : 1 TypeProduct Duplicado
              child: BlocBuilder<TypeProductBloc, TypeProductState>(
                builder: (context, stateSizeProduct) {
                  if (stateSizeProduct is TypeProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (stateSizeProduct is TypeProductsLoaded) {
                    return DropDown(
                      isExpanded: true,
                      items: stateSizeProduct.typeProducts,
                      customWidgets: stateSizeProduct.typeProducts
                          .map((e) => Text(e.title))
                          .toList(),
                      onChanged: (TypeProduct? typeP) {
                        typeProduct = typeP!;
                      },
                      hint: const Text('Tipo de producto'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
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

  Widget selectSizeProduct() {
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
          // TODO : 2  TypeProduct Duplicado
          BlocBuilder<TypeProductBloc, TypeProductState>(
            builder: (context, state) {
              if (state is TypeProductLoading) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (state is TypeProductsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingL, vertical: kPaddingS),
                  child: DropDown(
                    hint: const Text('Seleccionar una opción'),
                    isExpanded: true,
                    items: state.typeProducts,
                    customWidgets: state.typeProducts
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
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget showSizeProduct() {
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
                    ],
                    rows: stateSizeProduct.sizeProducts
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(Text(e.size)),
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
}
