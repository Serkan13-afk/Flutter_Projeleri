import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:havadurumu_app/ekranlar/Login.dart';
import 'package:havadurumu_app/Providerler.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'ekranlar/NavigatorGecisSayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS ve Android için default Firebase initialize
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemaOkuma()),
        ChangeNotifierProvider(create: (_) => DilOkuma()),
      ],
      child: (MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return MaterialApp(
          title: 'Anlık Hava Durumu',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: temaNesne.temaOku()
                  ? Brightness.light
                  : Brightness.dark,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.lightBlue,
              unselectedItemColor: Colors.grey[800],
            ),
          ),
          home: _auth.currentUser != null
              ? Navigatorgecissayfa(_auth.currentUser!)
              : MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => BasSayfa();
}

class BasSayfa extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // uygulama açıldığı gibi gelsin
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bilgilendirme"),
            content: Text(
              "Uygulamaya girmeden önce ayarlarınızı yapınız !",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Anladım"),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    temaNesne.temaDegistir();
                  });
                },
                icon: temaNesne.temaOku()
                    ? Icon(
                        Icons.nightlight_round_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 35,
                      )
                    : Icon(
                        Icons.sunny,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 35,
                      ),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_outlined,
                    size: 35,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  color: Colors.blueGrey,
                  onSelected: (String value) {},
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: "turkce",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.purpleAccent,
                              child: ClipOval(
                                child: Image.asset(
                                  "resimler/tr.png",

                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Türkçe",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "ingilizce",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.purpleAccent,
                              child: ClipOval(
                                child: Image.asset(
                                  "resimler/en.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "İngilizce",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],

              backgroundColor: Colors.lightBlueAccent,
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  "Giriş",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: temaNesne.temaOku() ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: temaNesne.temaOku()
                    ? [Colors.white, Colors.cyanAccent]
                    : [Colors.black, Colors.cyanAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    child: Lottie.asset("iconlar/animasyon.json"),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 300,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Atla->",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) ,
          ),

          /*Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  child: Lottie.asset("iconlar/animasyon.json"),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text(
                      "Atla->",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        );
      },
    );
  }
}
