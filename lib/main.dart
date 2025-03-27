import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notes_app/Pages/homepage.dart';
import 'package:notes_app/Pages/signuppage.dart';
import 'package:notes_app/Provider/imageprovider.dart';
import 'package:notes_app/Provider/themeprovider.dart';
import 'package:notes_app/utils.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await sharedPrefs.init();
  runApp(MultiProvider(
      providers:[
        ChangeNotifierProvider<ImagesProvider>(create: (context)=>ImagesProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (context)=>ThemeProvider())
      ], child:const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData=Provider.of<ThemeProvider>(context).getTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: SpinKitDancingSquare(color: Theme.of(context).colorScheme.secondary));
            }
            if(snapshot.hasData){
              return Homepage();
            }
            return Signuppage();
          })
    );
  }
}