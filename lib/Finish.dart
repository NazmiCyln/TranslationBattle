import 'package:flutter/material.dart';
import 'package:myfirsproje/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Finish extends StatefulWidget {
  String finishKullaniciAdi;
  int totalScore;
  Finish({this.finishKullaniciAdi, this.totalScore});

  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  String kullaniciAdi;
  int puan;
  void kayitYap(String kullaniciAdi, int tscore) async {
    final kayitAraci = await SharedPreferences.getInstance();

    kayitAraci.setString("name", kullaniciAdi);
    kayitAraci.setInt("score", tscore);
  }

  void kayitGoster() async {
    final kayitAraci = await SharedPreferences.getInstance();

    String kIsim = kayitAraci.getString("name");
    int kScore = kayitAraci.getInt("score");

    setState(() {
      kullaniciAdi = kIsim;
      puan = kScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: Color(0xFF373855),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 300, 20, 0),
          child: Column(
            children: [
              Image.network(
                "https://cdn-icons-png.flaticon.com/512/5229/5229601.png",
                width: 150.0,
                height: 150.0,
              ),
              Text(""
                  ""),
              Text(
                'Kullanıcı adı : ${widget.finishKullaniciAdi}',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text("   "),
              Text(
                widget.totalScore > 5
                    ? 'Tebrikler final skorun : ${widget.totalScore}'
                    : 'Final skorun:  ${widget.totalScore}. Bir daha ki sefere iyi şanslar!!',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: widget.totalScore > 5 ? Colors.green : Colors.red,
                ),
              ),
              Text(""),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text(
                  "Çıkış",
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
                      builder: (context) => Menu(
                        kullaniciAdi: widget.finishKullaniciAdi,
                      ),
                    ),
                  );
                },
              )
              // ElevatedButton(
              //   child: Text("Kaydet"),
              //   onPressed: () =>
              //       kayitYap(widget.finishKullaniciAdi, widget.totalScore),
              // ),
              // ElevatedButton(
              //   child: Text("Getir"),
              //   onPressed: () => kayitGoster(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
