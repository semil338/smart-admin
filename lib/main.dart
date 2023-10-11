import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/landing.dart';
import 'package:smart_admin/services/auth.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/services/realtime.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Authentication()),
        Provider<Database>(create: (context) => FirestoreDatabase()),
        Provider<Realtime>(create: (context) => RealtimeDatabase()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Smart Admin",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.montserrat().fontFamily,
        ),
        home: const LandingPage(),
      ),
    );
  }
}
