import 'package:bely_boutique_princess/blocs/order_detail/order_detail_bloc.dart';
import 'package:bely_boutique_princess/blocs/search_order_detail/search_order_detail_bloc.dart';
import 'package:bely_boutique_princess/blocs/type_product/type_product_bloc.dart';
import 'package:bely_boutique_princess/repositories/type_product/type_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'repositories/repositories.dart';
import 'blocs/blocs.dart';
import 'cubit/cubits.dart';

import 'blocs/theme.dart';
import 'config/theme_default.dart';
import 'screens/splash_screen.dart';
import 'package:bely_boutique_princess/config/routers.dart';
import 'package:bely_boutique_princess/sinple_bloc_observer.dart';
import 'package:bely_boutique_princess/screens/screens.dart';

/// application's main method
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initializacion

  await Firebase.initializeApp(); //options: firebaseConfig
  // Instance repository
  final preferencesRepository = PreferencesRepositoryImpl();

  final preferencesBloc = LanguageBloc(
    preferencesRepository: preferencesRepository,
    initialLocale: await preferencesRepository.locale,
  );

  BlocOverrides.runZoned(
    () async => {
      runApp(
        // notifier provider, change the theme from app
        ChangeNotifierProvider(
          create: (_) => ThemeChanger(themeDefault()), // theme notif.
          // app orientation only portrait
          child: await SystemChrome.setPreferredOrientations(
            <DeviceOrientation>[
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ],
          ).then(
            (_) => BlocProvider(
              // bloc languaje
              create: (context) => preferencesBloc,
              child: const MyApp(),
            ),
          ),
        ),
      ),
    },
    blocObserver: SimpleBlocObserver(), // simple bloc observer for all blocs
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ); // change the system navigation bar style and notification bar style

    final theme = Provider.of<ThemeChanger>(context); // get theme reference
    final ThemeData getThema = theme.getTheme<ThemeData>(); // get theme
    /**
     * MultiRepositoryProvider
     */
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
      ],
      /**
       * MultiBLocProvider
       */
      child: MultiBlocProvider(
        // All blocs to be inserted in the application context
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<OnboardingBloc>(
            create: (context) => OnboardingBloc(
              databaseRepository: context.read<DatabaseRepository>(),
              storageRepository: context.read<StorageRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              authBloc: BlocProvider.of<AuthBloc>(context),
              databaseRepository: context.read<DatabaseRepository>(),
              storageRepository: context.read<StorageRepository>(),
              // una vez es instanciado se inyectara el metodo add
            )..add(
                LoadProfile(
                  userId: BlocProvider.of<AuthBloc>(context).state.user!.uid,
                ),
              ),
          ),
          BlocProvider(
            create: (context) =>
                HomePageBloc()..add(const HomeTabChangeEvent(newIndex: 1)),
            //newIndex as first, index = 0 is treen
            // authBloc: BlocProvider.of<AuthBloc>(context),
            // databaseRepository: context.read<DatabaseRepository>(),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              categoryRepository: CategoryRepository(),
              storageRepository: context.read<StorageRepository>(),
            )..add(const LoadCategories()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              storageRepository: context.read<StorageRepository>(),
              productRepository: ProductRepository(),
            )..add(LoadProducts()),
          ),
          BlocProvider(
            create: (context) => RoleBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(const LoadUsers(role: 'admin')),
          ),
          BlocProvider(
            create: (context) => TypeProductBloc(
              typeProductRepository: TypeProductRepository(),
            )..add(LoadTypeProducts()),
          ),
          BlocProvider(
              create: (context) => SizeProductBloc(
                    sizeProductRepository: SizeProductRepository(),
                  )..add(const LoadSizeProducts())
              // ..add(LoadAllSizeProducts()),
              ),
          // BlocProvider(
          //   create: (context) => OrderBloc(
          //     authBloc: BlocProvider.of<AuthBloc>(context),
          //     orderRepository: OrderRepository(),
          //   )..add(
          //       LoadOrderById(
          //         userId: BlocProvider.of<AuthBloc>(context).state.user!.uid,
          //       ),
          //     ),
          // ),
          BlocProvider(
            create: (context) => OrderDetailBloc(
              authBloc: BlocProvider.of<AuthBloc>(context),
              orderRepository: OrderRepository(),
            )..add(
                LoadOrderDetailById(
                  userId: BlocProvider.of<AuthBloc>(context).state.user!.uid,
                ),
              ),
          ),
          BlocProvider(
            create: (context) => SearchOrderDetailBloc(
              databaseRepository: context.read<DatabaseRepository>(),
              orderRepository: OrderRepository(),
              productRepository: ProductRepository(),
            ),
          ),
        ],
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            // if language state is loaded then
            if (state is PreferencesState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Bely boutique princess',
                theme: getThema, // theme
                localizationsDelegates: const [
                  // translate
                  LocaleNamesLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  S.delegate,
                ], // definition delegates
                supportedLocales: S.delegate.supportedLocales, // list locales
                locale: state.locale,
                onGenerateRoute: Routers.onGenerateRoute, // list route
                initialRoute: SplashScreen.routeName, // initial route
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
