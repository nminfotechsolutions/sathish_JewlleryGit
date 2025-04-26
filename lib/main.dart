import 'package:agni_chit_saving/routes/app_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SATHISH',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.CommonColor),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashscreens,
      routes: AppRoutes.Routes,
    );
  }
}
