import 'package:budgets/data/repository/implementation/user_repository.dart';
import 'package:budgets/src/bloc/cubit/user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:budgets/src/bloc/cubit/auth_cubit.dart';
import 'package:budgets/src/navigation/routes.dart';

import 'constants.dart';
import 'data/repository/implementation/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authCubit = AuthCubit(AuthRepository());
  final userCubit = UserCubit(UserRepository());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => authCubit..init(),
        ),
        BlocProvider(
          create: (context) => userCubit..getUser(),
        ),
      ],
      child: MyApp.create(),
    ),
  );
}

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static Widget create() {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(Routes.intro, (route) => false);
        } else if (state is AuthSignedIn) {
          _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(Routes.main, (route) => false);
        }
      },
      child: MyApp(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Budgets App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimayColor,
        accentColor: kAccentColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
      ),
      onGenerateRoute: Routes.routes,
    );
  }
}
