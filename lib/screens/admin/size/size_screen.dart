import 'package:bely_boutique_princess/models/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../utils/show_alert.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

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
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Talla',
              ),
              validator: (value) => Validators.isValidateOnlyTextMinMax(
                text: value!,
                minCaracter: 1,
                maxCarater: 4,
                messageError: 'Titulo del tipo de producto no valido.',
              ),
              onSaved: (value) => setState(() {
                titlesizeProduct = value;
              }),
            ),
            Padding(
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
                    return DropDown(
                      isExpanded: true,
                      items: state.typeProducts,
                      customWidgets:
                          state.typeProducts.map((e) => Text(e.title)).toList(),
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
            MaterialButton(
              color: Theme.of(context).primaryColor.withOpacity(.8),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  ShowAlert.showErrorSnackBar(context,
                      message: 'Por favor completa el registro.');
                  return;
                }
                // save all form
                _formKey.currentState!.save();
                final sizeProduct = SizeProduct(size: titlesizeProduct!);
                context.read<SizeProductBloc>().add(
                      AddSizeProduct(sizeProduct: sizeProduct),
                    );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget showSizeProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingS),
      child: BlocBuilder<SizeProductBloc, SizeProductState>(
        builder: (context, state) {
          if (state is SizeProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SizeProductsLoaded) {
            return state.sizeProducts.isNotEmpty
                ? DataTable2(
                    columns: const [DataColumn2(label: Text('Talla'))],
                    rows: state.sizeProducts
                        .map(
                          (e) => DataRow(cells: [DataCell(Text(e.size))]),
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
}
