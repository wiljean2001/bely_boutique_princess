import 'package:bely_boutique_princess/models/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../utils/show_alert.dart';
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
                    columns: const [DataColumn2(label: Text('Titulo'))],
                    rows: state.typeProducts
                        .map(
                          (e) => DataRow(cells: [DataCell(Text(e.title))]),
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
