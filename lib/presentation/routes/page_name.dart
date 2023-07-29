import '../screen/product/product_screen.dart';
import '../screen/splash/splash_screen.dart';
import 'page_routes.dart';

//untuk membuat rute pada screen
class AppPage {
  static final pages = {
    RouteName.splashScreen: (context) => const SplashScreen(),
    RouteName.listProduct: (context) => const ListProduct()
  };
}
