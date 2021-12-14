import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfirsproje/home.dart';
import 'package:myfirsproje/main.dart';
import 'package:myfirsproje/ranks.dart';
import 'package:myfirsproje/service/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Menu extends StatefulWidget {
  String kullaniciAdi;

  Menu({this.kullaniciAdi});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  AuthService _authService = AuthService();
  var mevcutKullanici = FirebaseAuth.instance.currentUser;

  var user = FirebaseAuth.instance.currentUser;
  var fireStore = FirebaseFirestore.instance;

  var usersRef = FirebaseFirestore.instance.collection("Person");
  var onlineRef = FirebaseDatabase.instance.ref('.info/connected');

  @override
  void initState() {
    // TODO: implement initState

    FirebaseDatabase.instance
        .ref('status/${user.uid}')
        .onDisconnect()
        .set('offline')
        .then((value) => {
              print("asdad"),
              fireStore
                  .collection("Person")
                  .doc(user.uid)
                  .update({'durum': true}),
            });

    FirebaseDatabase.instance.ref('status/${user.uid}').set('online');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 60;
    return Scaffold(
      body: Container(
        color: Color(0xFF272837),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Person")
              .doc(mevcutKullanici.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var alinanVeri = snapshot.data["nick"];
              var urlTutucu = snapshot.data["resim"];

              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Row(
                            children: [
                              Image.network(
                                urlTutucu,
                                height: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(2, 0, 220, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                KullaniciGecmis()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2952BF),
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      alinanVeri,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontFamily: 'İtalic',
                                          decoration: TextDecoration.none,
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _authService.signOut();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GirisEkrani()));
                                },
                                child: Text(
                                  "Çıkış",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Image.network(
                            "https://pbs.twimg.com/media/CktwjRtWkAAm3Dc.png",
                            width: 150.0,
                            height: 100.0,
                          ),
                        ),
                        Text(
                          'Translation Battle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'yazi',
                              decoration: TextDecoration.none,
                              fontSize: 50,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        circButton(FontAwesomeIcons.info, infoScreen()),
                        circButton(FontAwesomeIcons.medal, achievementScreen()),
                        circButton(FontAwesomeIcons.lightbulb, hintScreen()),
                        circButton(FontAwesomeIcons.cog, profileScreen()),
                      ],
                    ),
                    Wrap(
                      runSpacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChoiseLevel(
                                  lKullanici: alinanVeri,
                                ),
                              ),
                            );
                          },
                          child: modeButton(
                              'Play',
                              'Play o normal game',
                              FontAwesomeIcons.trophy,
                              Color(0xFF2F80ED),
                              width),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: modeButton(
                              'Time Trial',
                              'Race against the clock',
                              FontAwesomeIcons.userClock,
                              Color(0xFFDF1D5A),
                              width),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Ranks(),
                              ),
                            );
                          },
                          child: modeButton('Ranks', 'Show ranks',
                              FontAwesomeIcons.couch, Color(0xFF45D280), width),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: modeButton(
                              'Pass & Play',
                              'Challenge your friends',
                              FontAwesomeIcons.userFriends,
                              Color(0xFFFF8306),
                              width),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Padding circButton(IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        fillColor: Colors.white,
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 35, minWidth: 35),
        child: FaIcon(icon, size: 22, color: Color(0xFF2F3041)),
      ),
    );
  }

  GestureDetector modeButton(
      String title, String subtitle, IconData icon, Color color, double width) {
    return GestureDetector(
      child: Container(
        width: width,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 17, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'Manrope',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 17, 25, 20),
              child: FaIcon(
                icon,
                size: 35,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//kullanıcı adına tıklanınca sayfa
class KullaniciGecmis extends StatefulWidget {
  @override
  _KullaniciGecmisState createState() => _KullaniciGecmisState();
}

class _KullaniciGecmisState extends State<KullaniciGecmis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272837),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc("ID")
            .collection(FirebaseAuth.instance.currentUser.uid)
            .orderBy("elo", descending: true)
            .snapshots(),
        builder: (context, veriAl) {
          if (veriAl.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var veri = veriAl.data.docs;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: veri.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(12, 5, 12, 1),
                  height: 65,
                  decoration: BoxDecoration(
                    color: Color(0xFFAEE095),
                    border: Border.all(
                      width: 3,
                      color: Color(0xFF000000),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(veri[index]["kullanıcıAdi"],
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(veri[index]["elo"].toString(),
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(veri[index]["süre"].toString(),
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(veri[index]["totalScore"].toString(),
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(veri[index]["tarih"].toString(),
                                style: TextStyle(fontSize: 15)),
                          )
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
    );
  }
}

// Level seçme ekranı
class ChoiseLevel extends StatefulWidget {
  String lKullanici;

  ChoiseLevel({this.lKullanici});

  @override
  _ChoiseLevelState createState() => _ChoiseLevelState();
}

class _ChoiseLevelState extends State<ChoiseLevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF272837),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Lütfen oynamak istediğiniz seviyeyi seçin",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold),
              ),
              Text("                                            "
                  ""
                  "       "),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text(
                  "Kolay",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      decoration: TextDecoration.none),
                ),
                onPressed: () {
                  var odaID = sirayaGir(widget.lKullanici);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        homekullaniciAdi: widget.lKullanici,
                        odaID: odaID,
                      ),
                    ),
                  );
                },
              ),
              Text("              "),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text(
                  "Orta",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        homekullaniciAdi: widget.lKullanici,
                      ),
                    ),
                  );
                },
              ),
              Text("              "),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text(
                  "Zor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      decoration: TextDecoration.none),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        homekullaniciAdi: widget.lKullanici,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

String sirayaGir(nick) {
  var currentID = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance.collection("Games").get().then((data) {
    var alinanVeri = data.docs;
    var odakurucuid;
    for (int i = 0; i < alinanVeri.length; i++) {
      if (alinanVeri[i]["odaVisiblity"] == true) {
        odakurucuid = alinanVeri[i]["odaID"];
        FirebaseFirestore.instance
            .collection("Games")
            .doc(odakurucuid)
            .collection(currentID)
            .doc("answers")
            .set({"finishtime": 0, "nick": nick, "totalScore": 0});

        FirebaseFirestore.instance
            .collection("Games")
            .doc(odakurucuid)
            .update({"odaVisiblity": false});
        return odakurucuid;
      }
    }
    FirebaseFirestore.instance
        .collection("Games")
        .doc(currentID)
        .collection(currentID)
        .doc("answers")
        .set({"finishtime": 0, "nick": nick, "totalScore": 0});
    FirebaseFirestore.instance
        .collection("Games")
        .doc(currentID)
        .set({"odaID": currentID, "odaVisiblity": true});
    return currentID;
  });
}

// İnfo ekranı
class infoScreen extends StatefulWidget {
  @override
  _infoScreenState createState() => _infoScreenState();
}

class _infoScreenState extends State<infoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// Ödül ekranı
class achievementScreen extends StatefulWidget {
  @override
  _achievementScreenState createState() => _achievementScreenState();
}

class _achievementScreenState extends State<achievementScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF373855),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Person").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            Text("Aktarım Başarısız!");
          }
          var veriler = snapshot.data.docs;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  "Top List",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontFamily: "yazi",
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: veriler.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot satirVerisi = veriler[index];

                  return Container(
                    margin: const EdgeInsets.fromLTRB(12, 5, 12, 1),
                    height: 75,
                    decoration: BoxDecoration(
                      color: Color(0xFFCD9D30),
                      border: Border.all(
                        width: 3,
                        color: Color(0xFF000000),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    size: 50,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 80),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      satirVerisi["nick"],
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Text(
                                  satirVerisi["elo"].toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// İpucu ekranı
class hintScreen extends StatefulWidget {
  @override
  _hintScreenState createState() => _hintScreenState();
}

class _hintScreenState extends State<hintScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Games").snapshots(),
        builder: (context, veriler) {
          var alinanVeri = veriler.data.docs;
          for (int i = 0; i <= alinanVeri.length; i++) {
            if (alinanVeri[i]["odaVisiblity"] == true) {
              print(i);
            }
          }
          return Text("asdasd");
        },
      ),
    );
  }
}

// Profil ekranı
class profileScreen extends StatefulWidget {
  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final TextEditingController sifrec = TextEditingController();
  final TextEditingController nickc = TextEditingController();
  final TextEditingController adc = TextEditingController();
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Person")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            var urlTutucu = snapshot.data["resim"];
            return Scaffold(
              backgroundColor: Color(0xE2013865),
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Avatar()));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff055884),
                              fixedSize: Size(90, 90),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: Image.network(urlTutucu),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(
                              height: size.height * .55,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Color(0xFF105A58).withOpacity(.75),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(28)),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xE4928686).withOpacity(.6),
                                        blurRadius: 50,
                                        spreadRadius: 2)
                                  ]),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 12, 15, 0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          controller: adc,
                                          style: TextStyle(color: Colors.white),
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Color(0xFFD1D9DC),
                                            ),
                                            hintText: "Yeni kullanıcı adı",
                                            prefixText: " ",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Colors.white,
                                            )),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          controller: nickc,
                                          style: TextStyle(color: Colors.white),
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.sports_esports,
                                              color: Color(0xFFD1D9DC),
                                            ),
                                            hintText: "Yeni nick",
                                            prefixText: " ",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Colors.white,
                                            )),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: sifrec,
                                          validator: (_passwordController) {
                                            return _passwordController.length >=
                                                    6
                                                ? null
                                                : "Şifre 6 karakterden az olamaz";
                                          },
                                          style: TextStyle(color: Colors.white),
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.vpn_key,
                                              color: Color(0xFFD1D9DC),
                                            ),
                                            hintText: "Yeni şifre",
                                            prefixText: " ",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Colors.white,
                                            )),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          {
                                            _authService.guncelle(sifrec.text,
                                                nickc.text, adc.text);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xff055884),
                                            fixedSize: Size(250, 55),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                        child: Text(
                                          'Güncelle',
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

//Avatar seçim ekranı
class Avatar extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  var user = FirebaseAuth.instance.currentUser;
  var firebase = FirebaseFirestore.instance;

  AuthService authService = AuthService();

  var alinanDosya;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar1.png").then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar1.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar3.png").then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar3.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
