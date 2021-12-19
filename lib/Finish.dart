import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirsproje/menu.dart';


class Finishh extends StatefulWidget {
  String finishKullaniciAdi;
  int totalScore;

  Finishh({this.finishKullaniciAdi, this.totalScore});

  @override
  _FinishhState createState() => _FinishhState();
}

class _FinishhState extends State<Finishh> {
  int eloPuan;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Person")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var resim = snapshot.data["resim"];

              return Scaffold(
                //backgroundColor: Color(0xFF006358),
                backgroundColor: Color(0xFF3C3E63),
                body: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (widget.totalScore < 3)
                              ? "Bad"
                              : (widget.totalScore >= 3 &&
                                      widget.totalScore <= 5)
                                  ? "Not Bad"
                                  : (widget.totalScore >= 6 &&
                                          widget.totalScore <= 8)
                                      ? "Good"
                                      : (widget.totalScore > 8)
                                          ? "Legendary"
                                          : null,
                          style: TextStyle(
                            fontSize: 70,
                            fontFamily: "yazi",
                            color: Color(0xFFC7C768),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height * .5,
                              width: size.width * .75,
                              decoration: BoxDecoration(
                                  color: Color(0xFF43456D).withOpacity(.85),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(28)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: (widget.totalScore <= 7)
                                            ? Color(0xE4FF0000).withOpacity(.5)
                                            : (widget.totalScore > 7)
                                                ? Color(0xE41FFF42)
                                                    .withOpacity(.6)
                                                : null,
                                        blurRadius: 50,
                                        spreadRadius: 2)
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        resim,
                                        height: 130,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    snapshot.data["nick"],
                                    style: TextStyle(
                                      color: Color(0xFFC7C768),
                                      fontSize: 22,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    (widget.totalScore <= 7)
                                        ? "-5"
                                        : (widget.totalScore > 7)
                                            ? "+5"
                                            : null,
                                    style: TextStyle(
                                      color: (widget.totalScore <= 7)
                                          ? Colors.red
                                          : (widget.totalScore > 7)
                                              ? Colors.green
                                              : null,
                                      fontSize: 60,
                                    ),
                                  ),
                                  Text(
                                    "Total Puan: " +
                                        snapshot.data["elo"].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFC7C768),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
