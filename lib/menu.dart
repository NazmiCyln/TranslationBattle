import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfirsproje/home.dart';
import 'package:myfirsproje/ranks.dart';
import 'package:myfirsproje/service/auth.dart';
import 'package:flutter/services.dart';

class Menu extends StatefulWidget {
  String kullaniciAdi;

  Menu({this.kullaniciAdi});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  AuthService _authService = AuthService();

  var mevcutKullanici = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width - 80;

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
              }
              var alinanVeri = snapshot.data["nick"];

              return Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _authService.signOut();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Çıkış",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Image.network(
                              "https://pbs.twimg.com/media/CktwjRtWkAAm3Dc.png",
                              width: 150.0,
                              height: 150.0,
                            ),
                          ),
                          Text(
                            'Türkçe-İngilizce Çeviri Oyunu',
                            style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                fontSize: 36,
                                color: Colors.white),
                          ),
                          Text(
                            'Hoşgeldin ' + alinanVeri,
                            style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                fontSize: 36,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 0.7
                                  ..color = Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          circButton(FontAwesomeIcons.info),
                          circButton(FontAwesomeIcons.medal),
                          circButton(FontAwesomeIcons.lightbulb),
                          circButton(FontAwesomeIcons.cog),
                        ],
                      ),
                      Wrap(
                        runSpacing: 16,
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
                ),
              );
            }),
      ),
    );
  }

  Padding circButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RawMaterialButton(
        onPressed: () {},
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
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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

class ChoiseLevel extends StatefulWidget {
  String lKullanici;

  ChoiseLevel({this.lKullanici});

  @override
  _ChoiseLevelState createState() => _ChoiseLevelState();
}

class _ChoiseLevelState extends State<ChoiseLevel> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      homekullaniciAdi: widget.lKullanici,
                      levelIndex: 0,
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
                      levelIndex: 10,
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
                      levelIndex: 20,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
