import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cache/cache.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/firebase_options.dart';
import 'package:social_app/layout_screens/login_layout/login.dart';
import 'package:social_app/layout_screens/social_layout/social_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Widget firstPage = const Login();
  await CacheHelper.initalCache().then((value) {
    String? uId = CacheHelper.getData("uId");
    firstPage = (uId == null) ? const Login() : const SocialLayout();
  });
  return runApp(Main(
    firstPage: firstPage,
  ));
}

class Main extends StatelessWidget {
  final Widget firstPage;
  const Main({super.key, required this.firstPage});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..getUserData()..getAllUsers(),
      child: MaterialApp(
        themeMode: ThemeMode.system,
        home: firstPage,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue, brightness: Brightness.light)),
        darkTheme: ThemeData(
          useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue, brightness: Brightness.dark)),
      ),
    );
  }
}
