import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirsproje/Finish.dart';
import 'package:myfirsproje/home.dart';
import 'package:myfirsproje/menu.dart';
import 'package:myfirsproje/service/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, veri){
          if(veri.hasData){
            return Menu(kullaniciAdi: "asd",);
          }
          else{
            return GirisEkrani();
          }
        },
      ),
    );
  }
}

var currentUser = FirebaseAuth.instance.currentUser;

class KayitEkrani extends StatefulWidget {
  @override
  _KayitEkraniState createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nickController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF373855),
      body: Form(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                  child: Image.network(
                    "https://pbs.twimg.com/media/CktwjRtWkAAm3Dc.png",
                    width: 150.0,
                    height: 150.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Ad soyad giriniz",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: _nickController,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Kullanıcı adını giriniz",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "E-mail giriniz",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Sifre giriniz",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _authService
                        .createPerson(
                            _nameController.text,
                            _nickController.text,
                            _emailController.text,
                            _passwordController.text)
                        .then((value) {
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GirisEkrani()));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2F80ED),
                      fixedSize: Size(250, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: Text(
                    'Başla',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: 'Manrope',
                        decoration: TextDecoration.none),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      //Giriş sayfasına git
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GirisEkrani()));
                    },
                    child: Text(
                      "Hesabım Var",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF373855),
      body: Form(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                  child: Image.network(
                    "https://pbs.twimg.com/media/CktwjRtWkAAm3Dc.png",
                    width: 150.0,
                    height: 150.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "E-mail giriniz",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Sifre giriniz",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _authService
                        .signIn(_emailController.text, _passwordController.text)
                        .then((value) {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Menu(
                            kullaniciAdi: null,
                          ),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2F80ED),
                      fixedSize: Size(250, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: Text(
                    'Başla',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: 'Manrope',
                        decoration: TextDecoration.none),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      //Kayıt sayfasına git
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KayitEkrani()));
                    },
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SoruEkran()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2F80ED),
                      fixedSize: Size(250, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: Text(
                    'Git',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: 'Manrope',
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoruEkran extends StatefulWidget {
  @override
  _SoruEkranState createState() => _SoruEkranState();
}

class _SoruEkranState extends State<SoruEkran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sdfsdf"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("Questions").snapshots(),
          builder: (context, veriAl) {
            if (veriAl.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var alinanVeri = veriAl.data.docs;
              return ListView.builder(
                itemCount: alinanVeri.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(alinanVeri[index]["soru"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(alinanVeri[index]["1"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(alinanVeri[index]["2"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(alinanVeri[index]["3"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(alinanVeri[index]["dogrucevap"].toString()),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
