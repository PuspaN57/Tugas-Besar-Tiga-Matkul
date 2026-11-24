import 'package:material_ui/material_ui.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class EcoCycleApp extends StatelessWidget {
  const EcoCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EcoCycle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}