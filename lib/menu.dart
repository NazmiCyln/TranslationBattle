import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfirsproje/home.dart';
import 'package:myfirsproje/main.dart';
import 'package:myfirsproje/rankedQueue.dart';
import 'package:myfirsproje/service/auth.dart';

import 'Finish.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  AuthService _authService = AuthService();

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
              .doc(user.uid)
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
                                padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
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
                        circButton(FontAwesomeIcons.info, rankLaunchScreen()),
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
                            var currentID =
                                FirebaseAuth.instance.currentUser.uid;
                            FirebaseFirestore.instance
                                .collection("Games")
                                .get()
                                .then((data) {
                              var readdata = data.docs;
                              var odakurucuid;
                              for (int i = 0; i < readdata.length; i++) {
                                if (readdata[i]["odaVisiblity"] == true) {
                                  odakurucuid = readdata[i]["odaID"];
                                  FirebaseFirestore.instance
                                      .collection("Games")
                                      .doc(odakurucuid)
                                      .update({
                                    "odaVisiblity": false,
                                    "user2": alinanVeri,
                                    "user2resim": urlTutucu.toString(),
                                    "user2totalScore": 0,
                                    "user2time": 0,
                                    "user2testDurum": "devam",
                                  });
                                  print(odakurucuid);
                                  return Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              rankLaunchScreen(
                                                user: "user2",
                                                nick: alinanVeri,
                                                odaID: odakurucuid,
                                              )));
                                }
                              }
                              FirebaseFirestore.instance
                                  .collection("Games")
                                  .doc(currentID)
                                  .set({
                                "odaID": currentID,
                                "odaVisiblity": true,
                                "user1": alinanVeri,
                                "user2": "Waiting",
                                "user1resim": urlTutucu.toString(),
                                "user2resim": "bekle",
                                "user1totalScore": 0,
                                "user2totalScore": 0,
                                "user1time": 0,
                                "user2time": 0,
                                "user1testDurum": "devam",
                                "user2testDurum": "baslamadi",
                              });
                              return Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => rankLaunchScreen(
                                            user: "user1",
                                            nick: alinanVeri,
                                            odaID: currentID,
                                          )));
                            });
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
            .orderBy("tarih", descending: true)
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
                  margin: const EdgeInsets.fromLTRB(9, 5, 9, 1),
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
      backgroundColor: Color(0xFF303247),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Levels",
                style: TextStyle(
                  fontFamily: "yazi",
                  fontSize: 45,
                  color: Color(0xFFC9F3F3),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF00FFFA).withOpacity(.7),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xE404805A).withOpacity(.35),
                              blurRadius: 40,
                              spreadRadius: 2)
                        ]),
                    child: ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1A8B8B),
                        fixedSize: (Size(75, 75)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/3564/3564180.png",
                        height: 45,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF00FFFA).withOpacity(.7),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xE404805A).withOpacity(.35),
                              blurRadius: 40,
                              spreadRadius: 2)
                        ]),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1A8B8B),
                        fixedSize: (Size(75, 75)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/641/641693.png",
                        height: 40,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF00FFFA).withOpacity(.7),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xE404805A).withOpacity(.35),
                              blurRadius: 40,
                              spreadRadius: 2)
                        ]),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1A8B8B),
                        fixedSize: (Size(75, 75)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/641/641693.png",
                        height: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF00FFFA).withOpacity(.7),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xE404805A).withOpacity(.35),
                              blurRadius: 40,
                              spreadRadius: 2)
                        ]),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1A8B8B),
                        fixedSize: (Size(75, 75)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/641/641693.png",
                        height: 120,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF00FFFA).withOpacity(.7),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xE404805A).withOpacity(.35),
                              blurRadius: 40,
                              spreadRadius: 2)
                        ]),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1A8B8B),
                        fixedSize: (Size(75, 75)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/641/641693.png",
                        height: 40,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF00FFFA).withOpacity(.7),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xE404805A).withOpacity(.35),
                              blurRadius: 40,
                              spreadRadius: 2)
                        ]),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1A8B8B),
                        fixedSize: (Size(75, 75)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/641/641693.png",
                        height: 40,
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

// İnfo ekranı
class infoScreen extends StatefulWidget {
  @override
  _infoScreenState createState() => _infoScreenState();
}

class _infoScreenState extends State<infoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Finishh(
                finishKullaniciAdi: "nzm",
                totalScore: 10,
              ),
            ),
          );
        },
      ),
    );
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
        stream: FirebaseFirestore.instance
            .collection("Person")
            .orderBy("elo", descending: true)
            .snapshots(),
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
                        color: (user.email.contains(satirVerisi["email"]))
                            ? Color(0xFF198E07)
                            : Color(0xFF000000),
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
                                  Image.network(
                                    satirVerisi["resim"],
                                    height: 50,
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
    return Scaffold();
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
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              _authService.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GirisEkrani()));
                            },
                            icon: Icon(
                              Icons.exit_to_app,
                              color: Color(0xE4D0C5C5),
                              size: 25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 13, 0, 30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Avatar()));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff055884),
                              fixedSize: Size(95, 95),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: Image.network(
                              urlTutucu,
                              height: 95,
                            ),
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

class rankLaunchScreen extends StatefulWidget {
  String user, nick, odaID;

  rankLaunchScreen({this.user, this.nick, this.odaID});

  @override
  _rankLaunchScreenState createState() => _rankLaunchScreenState();
}

class _rankLaunchScreenState extends State<rankLaunchScreen> {
  var odaDurum;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Person").snapshots(),
        builder: (context, veri2) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Games")
                  .doc(widget.odaID)
                  .snapshots(),
              builder: (context, veri) {
                odaDurum = veri.data["odaVisiblity"].toString();
                var user1 = veri.data["user1"].toString();
                var user2 = veri.data["user2"].toString();
                var user1resim = veri.data["user1resim"].toString();
                var user2resim = veri.data["user2resim"].toString();
                if (odaDurum == "false") {
                  Future.delayed(
                    Duration(milliseconds: 2500),
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => rankedQueue(
                            user: widget.user,
                            homekullaniciAdi: widget.nick,
                            odaID: widget.odaID,
                          ),
                        ),
                      );
                    },
                  );
                }

                return Scaffold(
                  backgroundColor: Color(0xE2013865),
                  body: Column(
                    children: [
                      Text(odaDurum),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 200, 0, 0),
                        child: Row(
                          children: [
                            Image.network(
                              (user1resim == "bekle")
                                  ? "https://w7.pngwing.com/pngs/273/858/png-transparent-question-mark-computer-icons-exclamation-mark-desktop-question-mark-emoji-angle-text-logo.png"
                                  : user1resim,
                              height: 150,
                              width: 150,
                            ),
                            Image.network(
                              (user2resim == "bekle")
                                  ? "https://w7.pngwing.com/pngs/273/858/png-transparent-question-mark-computer-icons-exclamation-mark-desktop-question-mark-emoji-angle-text-logo.png"
                                  : user2resim,
                              height: 150,
                              width: 150,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(80, 20, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              user1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Text(
                              user2,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: CircularProgressIndicator(
                          color: Colors.red,
                          strokeWidth: 5,
                        ),
                      ),
                      Text((odaDurum == "true")
                          ? "Kullanıcı Bekleniyor"
                          : "Oyun birazdan başlayacak"),
                    ],
                  ),
                );
              });
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
                        Navigator.pushReplacement(
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
                      authService.resimAl("avatar2.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar2.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar3.png").then((value) {
                        Navigator.pushReplacement(
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
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar4.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar4.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar5.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar5.png"),
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
                      authService.resimAl("avatar6.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar6.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar7.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar7.png"),
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
                      authService.resimAl("avatar8.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar8.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar9.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar9.png"),
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
                      authService.resimAl("avatar10.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar10.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar11.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar11.png"),
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
                      authService.resimAl("avatar12.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar12.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar13.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar13.png"),
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
                      authService.resimAl("avatar14.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar14.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar15.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar15.png"),
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
                      authService.resimAl("avatar16.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar16.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar17.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar17.png"),
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
                      authService.resimAl("avatar18.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar18.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar19.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar19.png"),
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
                      authService.resimAl("avatar20.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar20.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar21.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar21.png"),
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
                      authService.resimAl("avatar22.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar22.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar23.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar23.png"),
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
                      authService.resimAl("avatar24.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar24.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar25.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar25.png"),
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
                      authService.resimAl("avatar26.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar26.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar27.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar27.png"),
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
                      authService.resimAl("avatar28.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar28.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar29.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar29.png"),
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
                      authService.resimAl("avatar30.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar30.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar31.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar31.png"),
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
                      authService.resimAl("avatar32.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar32.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar33.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar33.png"),
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
                      authService.resimAl("avatar34.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar34.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar35.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar35.png"),
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
                      authService.resimAl("avatar36.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar36.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar37.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar37.png"),
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
                      authService.resimAl("avatar38.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar38.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar39.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar39.png"),
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
                      authService.resimAl("avatar40.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar40.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar41.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar41.png"),
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
                      authService.resimAl("avatar42.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar42.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar43.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar43.png"),
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
                      authService.resimAl("avatar44.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar44.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar45.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar45.png"),
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
                      authService.resimAl("avatar46.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar46.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar47.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar47.png"),
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
                      authService.resimAl("avatar48.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar48.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar49.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar49.png"),
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
                      authService.resimAl("avatar50.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar50.png"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar51.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar51.png"),
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
                      authService.resimAl("avatar52.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar52.png"),
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

  Padding avatarButton(Image img) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: ElevatedButton(
        onPressed: () {
          authService.resimAl("");

          },
        child: Image(
          image: AssetImage("img"),
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
    );
  }
}
