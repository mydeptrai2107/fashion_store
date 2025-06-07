import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/model/product_list.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/respository/components/routes.dart';
import 'package:ecommerce_app/utils/fav_provider.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';

void main() async {
  await PersistentShoppingCart().init();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51OIMAyHdpKm7MB8qqvzh6yB053y1lg8vJlUhPZ05Omb93IrEljTl9pC4YAuay0jh1cvxfQfHAkWMnkiGhfB3l92Y00XANULzRX";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ProductList();

  // addBrands();
  // ProductList.uploadProductsWithImages();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneralUtils()),
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: RouteNames.screenOne,
        onGenerateRoute: Routes.generateroutes,
      ),
    );
  }
}
