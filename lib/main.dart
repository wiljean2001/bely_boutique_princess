import 'package:bely_boutique_princess/blocs/type_product/type_product_bloc.dart';
import 'package:bely_boutique_princess/repositories/type_product/type_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
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

/// Metodo main de la aplicacion flutter
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // web controller
  // FirebaseOptions firebaseConfig = FirebaseOptions(
  //   apiKey: "AIzaSyBkzutMzpfzvVZaOnmCfenchdn9LwI-BMg",
  //   authDomain: "belyapp-87679.firebaseapp.com",
  //   projectId: "belyapp-87679",
  //   storageBucket: "belyapp-87679.appspot.com",
  //   messagingSenderId: "394573783744",
  //   appId: "1:394573783744:web:fad8afd4afe7d92dec4325",
  //   measurementId: "G-ZHGRNBD7H7",
  // );
  await Firebase.initializeApp(); //options: firebaseConfig

  final preferencesRepository = PreferencesRepositoryImpl();

  final preferencesBloc = LanguageBloc(
    preferencesRepository: preferencesRepository,
    initialLocale: await preferencesRepository.locale,
  );
  // simple bloc observer
  BlocOverrides.runZoned(
    () async => {
      runApp(
        // notifier provider, change the app theme
        ChangeNotifierProvider(
          create: (_) => ThemeChanger(themeDefault()),
          // app only DeviceOrientation portraitUp and portraitDown
          child: await SystemChrome.setPreferredOrientations(
            <DeviceOrientation>[
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ],
          ).then((_) => BlocProvider(
                // bloc languaje
                create: (context) => preferencesBloc,
                child: const MyApp(),
              )),
        ),
      ),
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // Constructor

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
    );

    final theme = Provider.of<ThemeChanger>(context);
    final ThemeData getThema = theme.getTheme<ThemeData>();
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
        //
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
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
              // una vez es instanciado se inyectara el metodo add
            )..add(
                LoadProfile(
                    userId: BlocProvider.of<AuthBloc>(context).state.user!.uid),
              ),
          ),
          BlocProvider(
            create: (context) => HomePageBloc()
              ..add(
                const HomeTabChangeEvent(
                    newIndex: 1), //newIhe first scndex = 0 is treen
              ),
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
            )..add(const LoadSizeProducts()),
          )
        ],
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            if (state is PreferencesState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Bely boutique princess',
                theme: getThema,
                localizationsDelegates: const [
                  // translate
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  S.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: state.locale,
                onGenerateRoute: Routers.onGenerateRoute,
                initialRoute: SplashScreen.routeName,
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
