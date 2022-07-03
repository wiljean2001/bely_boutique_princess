import 'package:bely_boutique_princess/blocs/blocs.dart';
import 'package:bely_boutique_princess/config/responsive.dart';
import 'package:bely_boutique_princess/models/category_model.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:bely_boutique_princess/widgets/custom_image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../models/type_product_model.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class CreateCategoryScreen extends StatelessWidget {
  const CreateCategoryScreen({Key? key}) : super(key: key);
// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          CustomSliverAppBar(
            title: S.of(context).title_create_category_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingM),
              child: FormCreateCategory(),
            ),
          ),
        ],
      ),
    );
  }
}

class FormCreateCategory extends StatefulWidget {
  FormCreateCategory({
    Key? key,
  }) : super(key: key);

  @override
  State<FormCreateCategory> createState() => _FormCreateCategoryState();
}

class _FormCreateCategoryState extends State<FormCreateCategory> {
  String? nameCategory;
  TypeProduct? typeProduct;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  XFile? xfile;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Categorias',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kPaddingL, vertical: kPaddingS),
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre de la categoría',
                  ),
                  maxLines: 1,
                  onSaved: (nameC) => setState(() {
                    nameCategory = nameC;
                  }),
                  validator: (value) => value!.isEmpty
                      ? 'Campo categoría no puede estar vacía.'
                      : null,
                ),
              ],
            ),
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
          xfile == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: Responsive.isMobile(context) ? 150 : 450,
                        maxHeight: Responsive.isMobile(context) ? 100 : 400,
                      ),
                      child: CustomImageContainer(
                        onPressed: (XFile _file) {
                          print('imagen');
                          xfile = _file;
                        },
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.6),
            child: MaterialButton(
              textColor: Theme.of(context).primaryColorLight,
              color: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).primaryColorLight,
              elevation: 10,
              onPressed: () async {
                if (!_keyForm.currentState!.validate() ||
                    xfile == null ||
                    typeProduct == null) {
                  ShowAlert.showErrorSnackBar(
                    context,
                    message: 'Por favor no dejar los campos vacíos!.',
                  );
                  return;
                }
                _keyForm.currentState!.save();
                Category categoria = Category(
                    name: nameCategory!,
                    imageUrl: '',
                    typeProductId: typeProduct!.id!);
                BlocProvider.of<CategoryBloc>(context).add(
                  AddCategory(category: categoria, image: xfile!),
                );
                ShowAlert.showSuccessSnackBar(
                  context,
                  message: 'Categoría registrada correctacmente!.',
                );
                xfile = null;
                typeProduct = null;
                _keyForm.currentState!.reset();
              },
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
