import 'package:bely_boutique_princess/screens/admin/admin_screens.dart';
import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/size_product/size_product_bloc.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../config/responsive.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../models/category_model.dart';
import '../../../models/type_product_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/show_alert.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_image_container.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class UpdateCategoryScreen extends StatefulWidget {
  const UpdateCategoryScreen({Key? key}) : super(key: key);

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  String? nameCategory;
  TypeProduct? typeProduct;
  TypeProduct? historyTypeProduct;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  XFile? xfile;
  String? xfileLoaded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2)
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          CustomSliverAppBar(
            title: S.of(context).title_update_category_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<TypeProductBloc, TypeProductState>(
              builder: (context, stateSizeProduct) {
                if (stateSizeProduct is TypeProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (stateSizeProduct is TypeProductsLoaded) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kPaddingL, vertical: kPaddingS),
                        child: DropDown(
                          isExpanded: true,
                          items: stateSizeProduct.typeProducts,
                          customWidgets: stateSizeProduct.typeProducts
                              .map((category) => Text(category.title))
                              .toList(),
                          onChanged: (TypeProduct? typeP) {
                            historyTypeProduct = typeP!;
                            context.read<SizeProductBloc>().add(
                                  LoadSizeProducts(typeProductId: typeP.id),
                                );
                            context.read<CategoryBloc>().add(
                                  LoadCategories(typeProductId: typeP.id),
                                );
                          },
                          hint: const Text('Tipo de producto'),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          SliverFillRemaining(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CategoryLoaded) {
                  int contIndex = 0;
                  return DataTable2(
                    // headingRowColor: MaterialStateProperty.all<Color>(
                    //   Theme.of(context).primaryColorLight.withOpacity(.3),
                    // ),
                    // dataRowColor: MaterialStateProperty.all<Color>(
                    //   Theme.of(context).primaryColorLight.withOpacity(.1),
                    // ),
                    // headingTextStyle: Theme.of(context)
                    //     .textTheme
                    //     .titleMedium
                    //     ?.copyWith(fontWeight: FontWeight.bold),
                    dataRowHeight: 100,
                    // columnSpacing: 1,
                    minWidth: 600,
                    // horizontalMargin: 12,
                    columns: customColumnsCategories,
                    rows: state.categories.isNotEmpty
                        ? state.categories.map<DataRow>((category) {
                            contIndex += 1;
                            return customRowsCategories(
                                contIndex, category, context);
                          }).toList()
                        : [],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn2> get customColumnsCategories {
    return const <DataColumn2>[
      // DataColumn2(label: SizedBox()),
      // DataColumn(label: SizedBox()),
      DataColumn2(
        label: Text('N°', style: TextStyle(fontStyle: FontStyle.italic)),
        numeric: true,
        fixedWidth: 50,
      ),
      DataColumn2(
        label: Text('Categoría', style: TextStyle(fontStyle: FontStyle.italic)),
        size: ColumnSize.L,
        fixedWidth: 150,
      ),
      DataColumn2(
        label: Text('Imagen', style: TextStyle(fontStyle: FontStyle.italic)),
        fixedWidth: 100,
        // fixedWidth: 150,
      ),
      DataColumn2(label: Text(""), fixedWidth: 250),
    ];
  }

  DataRow2 customRowsCategories(
      int contIndex, Category category, BuildContext context) {
    xfileLoaded = category.imageUrl;
    nameCategory = category.name;
    return DataRow2(
      cells: [
        // DataCell(
        //   Row(
        //     children: [
        //       IconButton(
        //           onPressed: () {},
        //           icon: Icon(Icons.edit_outlined)),
        //       IconButton(
        //           onPressed: () {},
        //           icon: Icon(Icons.delete_outline))
        //     ],
        //   ),
        // ),
        DataCell(Text(contIndex.toString())),
        DataCell(Text(category.name)),
        DataCell(
          category.imageUrl.isNotEmpty
              ? FadeInImage(
                  placeholder: const AssetImage(
                    Assets.imagesLogoTextoRosa,
                  ),
                  image: NetworkImage(
                    category.imageUrl,
                  ),
                )
              : const SizedBox(),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                textColor: Theme.of(context).primaryColorLight,
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).primaryColorLight,
                elevation: 10,
                onPressed: () => CustomAlertDialog.contentButtonAndTitle(
                  context: context,
                  content: Form(
                    key: _keyForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormField(
                          initialValue: category.name,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombre de la categoría',
                          ),
                          maxLines: 1,
                          onSaved: (nameC) => nameCategory = nameC,
                          validator: (value) => value!.isEmpty
                              ? 'Campo categoría no puede estar vacía.'
                              : null,
                        ),
                        BlocBuilder<TypeProductBloc, TypeProductState>(
                          builder: (context, state) {
                            if (state is TypeProductLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is TypeProductsLoaded) {
                              TypeProduct typeproduct = state.typeProducts
                                  .firstWhere((element) =>
                                      element.id == category.typeProductId);
                              typeProduct = typeproduct;
                              return DropDown(
                                initialValue: typeproduct,
                                isExpanded: true,
                                items: state.typeProducts,
                                customWidgets: state.typeProducts
                                    .map((category) => Text(category.title))
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    Responsive.isMobile(context) ? 150 : 450,
                                maxHeight:
                                    Responsive.isMobile(context) ? 100 : 400,
                              ),
                              child: CustomImageContainer(
                                imageUrl: category.imageUrl,
                              ),
                            ),
                            const Icon(Icons.roundabout_right_sharp),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    Responsive.isMobile(context) ? 150 : 450,
                                maxHeight:
                                    Responsive.isMobile(context) ? 100 : 400,
                              ),
                              child: CustomImageContainer(
                                onPressed: (XFile _file) {
                                  print('imagen');
                                  xfile = null;

                                  setState(() {
                                    xfile = _file;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              textColor: Theme.of(context).primaryColorLight,
                              color: Theme.of(context).primaryColor,
                              splashColor: Theme.of(context).primaryColorLight,
                              elevation: 10,
                              onPressed: () async {
                                if (!_keyForm.currentState!.validate() ||
                                    typeProduct == null) {
                                  ShowAlert.showErrorSnackBar(
                                    context,
                                    message:
                                        'Por favor no dejar los campos vacíos!.',
                                  );
                                  return;
                                }
                                _keyForm.currentState!.save();
                                // print(nameCategory);
                                // print(typeProduct!.id);
                                // registro de imagen
                                BlocProvider.of<CategoryBloc>(context).add(
                                  UpdateCategory(
                                    category: category.copyWith(
                                      name: nameCategory,
                                      typeProductId: typeProduct!.id,
                                    ),
                                    image: xfile != null ? xfile! : null,
                                    historyTypeProductId:
                                        historyTypeProduct!.id,
                                  ),
                                );
                                Navigator.pop(context);
                                ShowAlert.showSuccessSnackBar(
                                  context,
                                  message:
                                      'Categoría registrada correctacmente!.',
                                );
                                // xfile = null;
                                // typeProduct = null;
                                _keyForm.currentState!.reset();
                              },
                              child: const Text('Guardar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Actualizar categoría',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                // YYNoticeDialog(category),
                child: const Text(
                  'Editar',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              MaterialButton(
                textColor: Theme.of(context).primaryColorLight,
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).primaryColorLight,
                elevation: 10,
                onPressed: () {
                  BlocProvider.of<CategoryBloc>(context).add(
                    DeleteCategory(category: category),
                  );
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
