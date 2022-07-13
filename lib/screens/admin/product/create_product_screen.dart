import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import 'package:bely_boutique_princess/config/responsive.dart';
import '../../../config/constrants.dart';
import '../../../widgets/custom_carousel_sliders.dart';
import '../../../widgets/custom_multi_dropdown.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/custom_sliver_app_bar.dart';
import 'package:bely_boutique_princess/models/models.dart';
import 'package:bely_boutique_princess/screens/onboarding_auth/onboarding_screen.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:bely_boutique_princess/utils/validators.dart';

class CreateProductScreen extends StatefulWidget {
  static const String routeName = '/admin/nuevo/producto'; //route

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print the status user with the authbloc
        print(BlocProvider.of<AuthBloc>(context).state.status);

        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const OnboardingScreen()
            : CreateProductScreen();
      },
    );
  }

  CreateProductScreen({Key? key}) : super(key: key);

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  @override
  void initState() {
    context.read<SizeProductBloc>().add(LoadSizeProducts());
    context.read<CategoryBloc>().add(LoadCategories());
    super.initState();
  }

  // images product
  List<XFile>? itemsImages = [];
  List<String?>? categoriesProduct = [];
  List<String?>? sizesProduct = [];
  String? title;
  String? description;
  TypeProduct? typeProduct;
  List<double>? price = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            title: S.of(context).title_create_product_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingM),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'PRODUCTO',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kPaddingL, vertical: kPaddingS),
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
                                print(typeP!);
                                typeProduct = typeP;
                                context.read<SizeProductBloc>().add(
                                      LoadSizeProducts(typeProductId: typeP.id),
                                    );
                                context.read<CategoryBloc>().add(
                                      LoadCategories(typeProductId: typeP.id),
                                    );
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
                    formProduct(),
                    const SizedBox(height: 10),
                    Text(
                      'CATEGORÍAS',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // TODO : Categories
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is CategoryLoaded) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingL, vertical: kPaddingS),
                            child: CustomDropDown(
                              title: const Text('Categorías'),
                              listItems: state.categories
                                  .map((e) => MultiSelectItem(e, e.name))
                                  .toList(),
                              buttonText: const Text('Seleccionar categorías'),
                              onConfirm: (List<Category> values) {
                                categoriesProduct = [];
                                // categoriesProduct = values;
                                values
                                    .map((e) => categoriesProduct!.add(e.id))
                                    .toList();
                              },
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Selecciona al menos una opción.';
                                }
                              },
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    Text(
                      'TALLAS Y MÉTRICAS',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // TODO : Sizes product
                    Padding(
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
                            return CustomDropDown(
                              buttonText: const Text('Seleccionar tallas'),
                              listItems: state.sizeProducts
                                  .map((e) => MultiSelectItem(e, e.size))
                                  .toList(),
                              onConfirm: (List<SizeProduct> values) {
                                sizesProduct = [];
                                values
                                    .map((e) => sizesProduct!.add(e.id))
                                    .toList();
                              },
                              title: const Text('Tallas'),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Selecciona al menos una opción.';
                                }
                              },
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    CustomCarouselSliders(
                      itImages: itemsImages!,
                      onTap: () async {
                        ImagePicker _picker = ImagePicker();
                        final List<XFile>? imagesXfile =
                            await _picker.pickMultiImage(imageQuality: 100);

                        if (imagesXfile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Imagen no seleccionada.')),
                          );
                        }

                        if (imagesXfile != null) {
                          print('Uploading ...');
                          setState(() {
                            // itemsImages = null;
                            itemsImages = imagesXfile;
                          });

                          // context
                          //     .read<ProductBloc>()
                          //     .add(UpdateProductImages(image: imagesXfile));
                        }
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Responsive.isMobile(context)
                              ? MediaQuery.of(context).size.width * 0.4
                              : MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          elevation: 8.0,
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              ShowAlert.showErrorSnackBar(context,
                                  message: 'Por favor completa el registro.');
                              return;
                            }
                            // itemsImages validar
                            _formKey.currentState!.save();
                            ShowAlert.showSuccessSnackBar(context,
                                message: 'Registrando...');
                            Product product = Product(
                              title: title!,
                              descript: description!,
                              prices: price!,
                              imageUrls: const [], //downloadURLProduct
                              sizes: sizesProduct!,
                              categories: categoriesProduct!,
                              typeProductId: typeProduct!.id!,
                            );

                            // print(product);
                            context.read<ProductBloc>().add(
                                  AddProduct(
                                      product: product, images: itemsImages!),
                                );
                            ShowAlert.showSuccessSnackBar(context,
                                message: '¡Registro exitoso!.');
                          },
                          child: ListTile(
                            textColor: Theme.of(context).primaryColorLight,
                            iconColor: Theme.of(context).primaryColorLight,
                            // trailing: Icon(Icons.save_outlined),
                            title: const Text('Guardar'),
                            leading: const Icon(Icons.save_outlined),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(
          //       left: MediaQuery.of(context).size.width * 0.5,
          //       right: kPaddingM),
          //   child: MaterialButton(
          //     onPressed: () {},
          //     child: ListTile(
          //       title: Text('Guardar'),
          //       leading: Icon(Icons.save_outlined),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget formProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingS),
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre',
            ),
            validator: (value) => Validators.isValidateOnlyTextMinMax(
              text: value!,
              minCaracter: 3,
              maxCarater: 50,
              messageError: 'Nombre no valido.',
            ),
            onSaved: (value) => setState(() {
              title = value;
            }),
          ),
          const SizedBox(height: kPaddingS),
          TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripción',
              ),
              validator: (value) => Validators.isValidateOnlyTextMinMax(
                    text: value!,
                    minCaracter: 3,
                    maxCarater: 100,
                    messageError: 'Descripción no valido.',
                  ),
              onSaved: (value) => setState(() {
                    description = value;
                  })),
          const SizedBox(height: 10),
          TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Precio Max',
              suffixText: 'Soles',
              prefixText: 'S/',
            ),
            validator: (value) => Validators.isValidateOnlyTextMinMax(
              text: value!,
              minCaracter: 1,
              maxCarater: 6,
              messageError: 'Costo no valido.',
            ),
            onSaved: (value) => setState(() {
              price!.insert(0, double.parse(value!));
            }),
          ),
          const SizedBox(height: 10),
          TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Precio Min',
              suffixText: 'Soles',
              prefixText: 'S/',
            ),
            validator: (value) => Validators.isValidateOnlyTextMinMax(
              text: value!,
              minCaracter: 1,
              maxCarater: 6,
              messageError: 'Costo no valido.',
            ),
            onSaved: (value) => setState(() {
              price!.insert(0, double.parse(value!));
            }),
          ),
        ],
      ),
    );
  }
}
