import 'package:bely_boutique_princess/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    // });
  }

// lista de drawer (botones internos del drawer)
  void setDrawerListArray() async {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME_USER,
        labelName: S.of(context).title_show_as_user, // 'Ver como usuario',
        icon: const Icon(Icons.home_outlined),
      ),
      DrawerList(
        index: DrawerIndex.DASHBOARD,
        labelName: S.of(context).title_dashboard_screen, // 'Dashboard',
        icon: const Icon(Icons.dashboard_outlined),
      ),
      DrawerList(
        index: DrawerIndex.Products,
        labelName: S.of(context).title_products, // 'Productos',
        icon: const Icon(Icons.addchart_outlined),
        // isAssetsImage: true,
        // imageName: 'graphics/images/whatsapp_64.png',
        isTap: false,
      ),
      DrawerList(
        index: DrawerIndex.Product_create,
        labelName:
            S.of(context).title_create_product_screen, // 'Agregar producto'
        isAssetsImage: false,
      ),
      DrawerList(
        index: DrawerIndex.Product_edit,
        labelName: S.of(context).title_update_product_screen, // Editar Producto
        isAssetsImage: false,
      ),
      DrawerList(
        index: DrawerIndex.Product_show,
        labelName: S.of(context).title_show_products_screen, // Ver Productos
        isAssetsImage: false,
      ),
      DrawerList(
        index: DrawerIndex.Categories,
        labelName: S.of(context).title_show_products_screen, // 'Categorías',
        icon: const Icon(Icons.category_outlined),
        isTap: false,
      ),
      DrawerList(
        index: DrawerIndex.Category_create,
        labelName:
            S.of(context).title_create_category_screen, // 'Agregar categoría',
        isAssetsImage: false,
      ),
      DrawerList(
        index: DrawerIndex.Category_edit,
        labelName:
            S.of(context).title_update_category_screen, // 'Editar categoría',
        isAssetsImage: false,
      ),
      DrawerList(
        index: DrawerIndex.Category_show,
        labelName:
            S.of(context).title_show_categories_screen, // 'Ver categorías',
        isAssetsImage: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    setDrawerListArray();
    return Scaffold(
      // backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      backgroundColor: Theme.of(context)
          .primaryColorLight
          .withOpacity(0.4), // with opacity background
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ProfileLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: widget.iconAnimationController!,
                          builder: (BuildContext context, Widget? child) {
                            return ScaleTransition(
                              scale: AlwaysStoppedAnimation<double>(1.0 -
                                  (widget.iconAnimationController!.value) *
                                      0.2),
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation<double>(
                                    Tween<double>(begin: 0.0, end: 24.0)
                                            .animate(CurvedAnimation(
                                                parent: widget
                                                    .iconAnimationController!,
                                                curve: Curves.fastOutSlowIn))
                                            .value /
                                        360),
                                child: Container(
                                  // User photo
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        // color: AppTheme.grey.withOpacity(0.6),
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.6),
                                        offset: const Offset(2.0, 4.0),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(60.0)),
                                    child: state.user.image.isNotEmpty
                                        ? Image.network(
                                            state.user.image, // user image
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/profile_pic.png',
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            state.user.name, // name user
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              // color: AppTheme.grey,
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            // color: AppTheme.grey.withOpacity(0.6),
            color: Theme.of(context).primaryColorDark.withOpacity(0.7),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).primaryColorDark.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    // fontFamily: AppTheme.fontName,
                    fontFamily:
                        Theme.of(context).textTheme.headline1?.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    // color: AppTheme.darkText,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: const Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                onTap: () {
                  onTapped();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onTapped() {
    print('Haciendo algo...'); // Print to console.
  }

// customizacion de los botones internos del drawer
  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          listData.isTap == true ? navigationtoScreen(listData.index!) : null;
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage // valida si ingresa icon o image
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Theme.of(context).primaryColor
                                  // : AppTheme.nearlyBlack),
                                  : Theme.of(context).primaryColorDark),
                        )
                      : Icon(listData.icon?.icon,
                          color: widget.screenIndex == listData.index
                              ? Theme.of(context).primaryColor
                              // : AppTheme.nearlyBlack),
                              : Theme.of(context).primaryColorDark),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Theme.of(context).primaryColor
                          // : AppTheme.nearlyBlack,
                          : Theme.of(context).primaryColorDark,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                          (MediaQuery.of(context).size.width * 0.75 - 64) *
                              (1.0 -
                                  widget.iconAnimationController!.value -
                                  1.0),
                          0.0,
                          0.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              // esferico a la derecha
                              // color: Colors.blue.withOpacity(0.2),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  // cambiar de pantalla
  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  HOME_USER,
  DASHBOARD,
  Products,
  Product_create,
  Product_edit,
  Product_show,
  Categories,
  Category_create,
  Category_edit,
  Category_show,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
    this.isTap = true,
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
  bool? isTap;
}
