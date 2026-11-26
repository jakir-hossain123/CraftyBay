import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/core/app_navigator.dart';
import 'package:crafty_bay/data/services/cache/cache_service.dart';
import 'package:crafty_bay/data/services/network/session_expired.dart';
import 'package:crafty_bay/presentation/features/auth/viewmodel/auth_provider.dart';
import 'package:crafty_bay/presentation/features/auth/auth_redirect.dart';
import 'package:crafty_bay/presentation/features/cart/viewmodel/cart_provider.dart';
import 'package:crafty_bay/presentation/features/categories/viewmodel/category_provider.dart';
import 'package:crafty_bay/presentation/features/home/viewmodel/brand_provider.dart';
import 'package:crafty_bay/presentation/features/home/viewmodel/home_provider.dart';
import 'package:crafty_bay/presentation/features/home/viewmodel/slide_provider.dart';
import 'package:crafty_bay/presentation/features/products/viewmodel/product_provider.dart';
import 'package:crafty_bay/presentation/features/reviews/viewmodel/review_provider.dart';
import 'package:crafty_bay/presentation/features/splash/view/splash_page.dart';
import 'package:crafty_bay/presentation/features/wishlist/viewmodel/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await CacheService.init();
  SessionExpired.onExpired = _handleUnauthorized;
  runApp(const CraftyBay());
}

Future<void> _handleUnauthorized() async {
  final context = AppNavigator.key.currentContext;
  context?.read<AuthProvider>().clearSession();
  context?.read<CartProvider>().clearRemoteItems();
  context?.read<WishlistProvider>().clearRemoteItems();
  AuthRedirect.toLogin();
}

class CraftyBay extends StatelessWidget {
  const CraftyBay({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SlideProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        navigatorKey: AppNavigator.key,
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.background,
            hintStyle: const TextStyle(color: AppColors.textHint),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionHandleColor: Colors.black,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
