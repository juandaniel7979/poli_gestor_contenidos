import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/screens/feedback_screen.dart';
import 'package:poli_gestor_contenidos/screens/profile_screen.dart';
import 'package:poli_gestor_contenidos/screens/publication_tabs.dart';
import 'package:poli_gestor_contenidos/screens/screens.dart';
import 'package:poli_gestor_contenidos/screens/subcategory_edit_screen.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/services/notifications_service.dart';
import 'package:poli_gestor_contenidos/services/push_notifications_service.dart';
import 'package:poli_gestor_contenidos/services/search_service.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();
  await PushNotificationService.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider( create: ( _ ) => AuthService()),
        ChangeNotifierProvider( create: ( _ ) => ThemeProvider(isDarkMode: Preferences.isDarkMode )),
        ChangeNotifierProvider( create: ( _ ) => PublicationProvider()),
        ChangeNotifierProvider( create: ( _ ) => CategoryProvider()),
        ChangeNotifierProvider( create: ( _ ) => SubcategoryProvider()),
        ChangeNotifierProvider( create: ( _ ) => SuscripcionProvider()),
        ChangeNotifierProvider( create: ( _ ) => SearchService()),
        
        
      ],
      child: const MyApp(),
      )
    );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();
  
  @override
  void initState() {
    super.initState();
    PushNotificationService.messagesStream.listen((message) {
      print('My app: ${message}');
      // navigatorKey.currentState?.pushNamed(SettingsScreen.routerName, arguments: message);
      final snackBar = SnackBar(content: Text(message));
      NotificationsService.messengerKey.currentState?.showSnackBar(snackBar);

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material  App',
      navigatorKey: navigatorKey, //Navegar
      scaffoldMessengerKey: NotificationsService.messengerKey, //Mostrar snapbar
      initialRoute: CheckAuthScreen.routerName,
      routes: {
        CategoryEditScreen.routerName     : ( _ ) => const CategoryEditScreen(),
        CategoryDetailScreen.routerName   : ( _ ) => const CategoryDetailScreen(),
        FeedbackScreen.routerName         : ( _ ) => const FeedbackScreen(),
        CheckAuthScreen.routerName        : ( _ ) => const CheckAuthScreen(),
        HomeScreen.routerName             : ( _ ) => const HomeScreen(),
        LoginScreen.routerName            : ( _ ) => const LoginScreen(),
        ListCategoriesScreen.routerName   : ( _ ) => const ListCategoriesScreen(),
        PublicationEditScreen.routerName  : ( _ ) => const PublicationEditScreen(),
        PublicationTabsPage.routerName    : ( _ ) =>       PublicationTabsPage(),
        ProfileScreen.routerName          : ( _ ) => const ProfileScreen(),
        RegisterScreen.routerName         : ( _ ) => const RegisterScreen(),
        SettingsScreen.routerName         : ( _ ) => const SettingsScreen(),
        SubcategoryEditScreen.routerName  : ( _ ) => const SubcategoryEditScreen(),
        
        
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      // scaffoldMessengerKey: NotificationsService.messengerKey,
      
    );
  }
}