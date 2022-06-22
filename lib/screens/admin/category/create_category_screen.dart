import 'package:bely_boutique_princess/blocs/blocs.dart';
import 'package:bely_boutique_princess/models/category_model.dart';
import 'package:bely_boutique_princess/widgets/custom_image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class CreateCategoryScreen extends StatelessWidget {
  const CreateCategoryScreen({Key? key}) : super(key: key);
// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          CustomSliverAppBar(
            title: S.of(context).title_show_products_screen,
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
    // return Scaffold(
    //   body: Padding(
    //     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         CustomAppBar(
    //             title: S.of(context).title_create_category_screen,
    //             hasActions: false),
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.all(kPaddingM),
    //             child: FormCreateCategory(),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class FormCreateCategory extends StatelessWidget {
  FormCreateCategory({
    Key? key,
  }) : super(key: key);

  String? nameCategory;
  XFile? xfile;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
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
                  onChanged: (nameC) => nameCategory = nameC,
                  validator: (value) => value!.isEmpty
                      ? 'Campo categoría no puede estar vacía.'
                      : null,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kPaddingS, vertical: kPaddingS),
            child: CustomImageContainer(
              onPressed: (XFile _file) {
                print('imagen');
                xfile = _file;
              },
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.6),
            child: MaterialButton(
              textColor: Theme.of(context).primaryColorLight,
              color: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).primaryColorLight,
              elevation: 10,
              onPressed: () async {
                if (!_keyForm.currentState!.validate() && xfile == null) return;

                Category categoria =
                    Category(name: nameCategory!, imageUrl: '');
                BlocProvider.of<CategoryBloc>(context).add(
                  AddCategory(category: categoria, image: xfile!),
                );
                // ShowToast.showMessage(
                //     msg: '¡Categoría agregada exitósamente!.');
                // BlocProvider.of<CategoryBloc>(context)
                //     .add(UpdateCategory(category: categoria));
              },
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
