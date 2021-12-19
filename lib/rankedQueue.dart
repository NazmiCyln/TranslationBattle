import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfirsproje/Finish.dart';
import 'package:myfirsproje/service/auth.dart';

class rankedQueue extends StatefulWidget {
  String homekullaniciAdi, odaID;

  rankedQueue({this.homekullaniciAdi, this.odaID});

  @override
  _rankedQueueState createState() => _rankedQueueState();
}

class _rankedQueueState extends State<rankedQueue> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  int selectedans = 0;
  String cevap1 = "";
  String cevap2 = "";
  List<int> cevaplar = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  int userElo = 0;
  String cevap3 = "";
  int dogrucevap = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool isitcorrect = false;
  bool correctAnswerSelected = false;

  AuthService _authService = AuthService();

  void _questionAnswered(bool isitcorrect) {
    setState(() {
      cevaplar[_questionIndex] = selectedans;
      print(cevaplar[_questionIndex]);
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (isitcorrect) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      //adding to the score tracker on top
      _scoreTracker.add(
        isitcorrect
            ? Icon(
          Icons.check_circle,
          color: Colors.green,
        )
            : Icon(
          Icons.clear,
          color: Colors.red,
        ),
      );
      //  when the quiz ends
      if (_questionIndex + 1 == 10) {
        endOfQuiz = true;
        finish();
      }
    });
  }

  void finish() {
    // Süreyi durdurup geçen süreyi tutar
    bitisSuresi = 100 - timer.tick;
    timer.cancel();
    _counter = bitisSuresi;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

    FirebaseFirestore.instance
        .collection("Person")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
      userElo = ds["elo"];
      if (_totalScore > 7) {
        userElo = 5 + userElo;
      } else {
        userElo = userElo - 5;
      }
      //İki kullanıcı karşılaştırma ekranı
      FirebaseFirestore.instance
          .collection("Games")
          .doc(widget.odaID)
          .get()
          .then((value) {
        if (value[1]["totalScore"] > value[0]["totalScore"]) {
          print("2. kullanıcı kazandı");
        } else if (value[1]["totalScore"] == value[0]["totalScore"]) {
          print("berabere");
        } else
          print("2. kullanıcı kazandı");
      });
      //Test bitince kullanılan oda siliniyor
      // FirebaseFirestore.instance
      //     .collection("Games")
      //     .doc(FirebaseAuth.instance.currentUser.uid)
      //     .delete();

      //  Kulanıcının test sonuçlarını firebase'e kaydediyoruz
      final fireStore = FirebaseFirestore.instance;
      CollectionReference firebaseRef = fireStore
          .collection("Users")
          .doc("ID")
          .collection(FirebaseAuth.instance.currentUser.uid);
      Map<String, dynamic> resultsData = {
        'oyunTürü': "Ranked",
        'kullanıcıAdi': widget.homekullaniciAdi,
        'totalScore': _totalScore,
        'elo': userElo,
        'tarih': formattedDate,
        'süre': timer.tick,
      };
      firebaseRef.doc(formattedDate).set(resultsData);

      // elo güncelleme
      fireStore
          .collection('Person')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({'elo': userElo});
    });
    // Sonuç ekranını açıyoruz
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Finishh(
          finishKullaniciAdi: widget.homekullaniciAdi,
          totalScore: _totalScore,
        ),
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      selectedans = 0;
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
      isitcorrect = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  double value = 0;
  int _counter;
  int bitisSuresi;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    value = 0;
    zamanlayici();
    super.initState();
  }

  //Zamanlayıcı ayarı
  void zamanlayici() {
    _counter = 100;
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timer.tick == 101) {
          timer.cancel();

          finish();
        } else {
          value = value + 0.01;
          _counter--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Questions").snapshots(),
      builder: (context, veriAl) {
        var alinanVeri = veriAl.data.docs;
        dogrucevap = alinanVeri[_questionIndex]["dogrucevap"];
        return Scaffold(
          backgroundColor: Color(0xFF373855),
          appBar: AppBar(
            backgroundColor: Color(0xFF373855),
            title: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '${widget.homekullaniciAdi}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 8, bottom: 3),
                      child: Icon(
                        Icons.timer,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        '$_counter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  //margin: EdgeInsets.all(20),
                  // padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.lightGreen,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xA8632626),
                    color: Colors.green,
                    minHeight: 7,
                    value: value,
                  ),
                ),
                Row(
                  children: [
                    if (_scoreTracker.length == 0)
                      SizedBox(
                        height: 25.0,
                      ),
                    if (_scoreTracker.length > 0) ..._scoreTracker
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 130.0,
                  margin:
                  EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
                  padding:
                  EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      alinanVeri[_questionIndex]["soru"].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selectedans = 1;
                    if (answerWasSelected) {
                      return;
                    }
                    if (dogrucevap == 1) {
                      isitcorrect = true;
                    }
                    _questionAnswered(isitcorrect);
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    margin:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: (answerWasSelected)
                          ? (dogrucevap != 1)
                          ? (selectedans == 1)
                          ? Colors.red
                          : Colors.white
                          : Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      alinanVeri[_questionIndex]["1"],
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selectedans = 2;
                    if (answerWasSelected) {
                      return;
                    }
                    if (dogrucevap == 2) {
                      isitcorrect = true;
                    }
                    _questionAnswered(isitcorrect);
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    margin:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: (answerWasSelected)
                          ? (dogrucevap != 2)
                          ? (selectedans == 2)
                          ? Colors.red
                          : Colors.white
                          : Colors.green
                          : Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      alinanVeri[_questionIndex]["2"],
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selectedans = 3;
                    if (answerWasSelected) {
                      return;
                    }
                    if (dogrucevap == 3) {
                      isitcorrect = true;
                    }
                    _questionAnswered(isitcorrect);
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    margin:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: (answerWasSelected)
                          ? (dogrucevap != 3)
                          ? (selectedans == 3)
                          ? Colors.red
                          : Colors.white
                          : Colors.green
                          : Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      alinanVeri[_questionIndex]["3"],
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40.0),
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      if (!answerWasSelected) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Please select an answer before going to the next question'),
                        ));
                        return;
                      }
                      _nextQuestion();
                    },
                    child: Text(
                      endOfQuiz ? 'Restart Quiz' : 'Next Question',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    '${(_questionIndex + 1).toString()}/${_questions.length}',
                    style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                if (answerWasSelected && !endOfQuiz)
                  Container(
                    height: 30,
                    width: double.infinity,
                    color: correctAnswerSelected ? Colors.green : Colors.red,
                    child: Center(
                      child: Text(
                        correctAnswerSelected
                            ? 'Well done, you got it right!'
                            : 'Wrong :/',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final _questions = const [
  //Kolay seviye sorular
  {
    'question': '    "Ability" türkcesi nedir?',
    'answers': [
      {'answerText': '  Beceri', 'score': true},
      {'answerText': '  Güç', 'score': false},
      {'answerText': '  Hobi', 'score': false},
    ],
  },
  {
    'question': '    "School" türkcesi nedir?',
    'answers': [
      {'answerText': '  Okul', 'score': true},
      {'answerText': '  Okumak', 'score': false},
      {'answerText': '  Öğrenci', 'score': false},
    ],
  },
  {
    'question': '    "Access" türkcesi nedir?',
    'answers': [
      {'answerText': '  Başlatmak', 'score': false},
      {'answerText': '  Kapatmak', 'score': false},
      {'answerText': '  Erişmek', 'score': true},
    ],
  },
  {
    'question': '    "Airport " türkcesi nedir?',
    'answers': [
      {'answerText': '  Uçak', 'score': false},
      {'answerText': '  Otobüs durağı', 'score': false},
      {'answerText': '  Havalimanı', 'score': true},
    ],
  },
  {
    'question': '    "Bathroom" türkcesi nedir?',
    'answers': [
      {'answerText': '  Yatak odası', 'score': false},
      {'answerText': '  Banyo', 'score': true},
      {'answerText': '  Mutfak', 'score': false},
    ],
  },
  {
    'question': '    "Blind" türkcesi nedir?',
    'answers': [
      {'answerText': '  Kör', 'score': true},
      {'answerText': '  Görüş', 'score': false},
      {'answerText': '  Kapalı', 'score': false},
    ],
  },
  {
    'question': '    "Brain " türkcesi nedir?',
    'answers': [
      {'answerText': '  Beyin', 'score': true},
      {'answerText': '  Kafa', 'score': false},
      {'answerText': '  Akıl', 'score': false},
    ],
  },
  {
    'question': '    "Playground" türkcesi nedir?',
    'answers': [
      {'answerText': '  Oyun sahası', 'score': true},
      {'answerText': '  Oyun', 'score': false},
      {'answerText': '  Oyun satıcısı', 'score': false},
    ],
  },
  {
    'question': '    "Murder" türkcesi nedir?',
    'answers': [
      {'answerText': '  Kanıt', 'score': false},
      {'answerText': '  Katil', 'score': false},
      {'answerText': '  Cinayet', 'score': true},
    ],
  },
  {
    'question': '    "Lucky" türkcesi nedir?',
    'answers': [
      {'answerText': '  Derece', 'score': false},
      {'answerText': '  Bonus', 'score': false},
      {'answerText': '  Şanslı', 'score': true},
    ],
  },
  //orta seviye sorular
  {
    'question': '    "attention" türkcesi nedir?',
    'answers': [
      {'answerText': '  atak', 'score': false},
      {'answerText': '  Dikkat', 'score': true},
      {'answerText': '  hücum', 'score': false},
    ],
  },
  {
    'question': '    "Bridge" türkcesi nedir?',
    'answers': [
      {'answerText': '  Köprü', 'score': true},
      {'answerText': '  Yol', 'score': false},
      {'answerText': '  Boğaz', 'score': false},
    ],
  },
  {
    'question': '    "Budget" türkcesi nedir?',
    'answers': [
      {'answerText': '  Ücret', 'score': false},
      {'answerText': '  Bütçce', 'score': true},
      {'answerText': '  But', 'score': false},
    ],
  },
  {
    'question': '    "Cell " türkcesi nedir?',
    'answers': [
      {'answerText': '  Satış', 'score': false},
      {'answerText': '  Satmak', 'score': false},
      {'answerText': '  Hücre', 'score': true},
    ],
  },
  {
    'question': '    "court" türkcesi nedir?',
    'answers': [
      {'answerText': '  Mahkeme', 'score': true},
      {'answerText': '  Kuzen', 'score': false},
      {'answerText': '  Tavşan', 'score': false},
    ],
  },
  {
    'question': '    "attorney" türkcesi nedir?',
    'answers': [
      {'answerText': '  Avukat', 'score': true},
      {'answerText': '  Gün doğumu', 'score': false},
      {'answerText': '  Saldırı', 'score': false},
    ],
  },
  {
    'question': '    "Interview " türkcesi nedir?',
    'answers': [
      {'answerText': '  Röportaj', 'score': true},
      {'answerText': '  Ulus', 'score': false},
      {'answerText': '  İlişki', 'score': false},
    ],
  },
  {
    'question': '    "Measure" türkcesi nedir?',
    'answers': [
      {'answerText': '  Mezura', 'score': false},
      {'answerText': '  Ölçmek', 'score': true},
      {'answerText': '  Metre', 'score': false},
    ],
  },
  {
    'question': '    "Pressure" türkcesi nedir?',
    'answers': [
      {'answerText': '  Premature', 'score': false},
      {'answerText': '  Basmak', 'score': false},
      {'answerText': '  Basınç', 'score': true},
    ],
  },
  {
    'question': '    "Remain" türkcesi nedir?',
    'answers': [
      {'answerText': '  Tekrar', 'score': false},
      {'answerText': '  Kalmak', 'score': true},
      {'answerText': '  Ana menü', 'score': false},
    ],
  },
  // Zor seviye sorular
  {
    'question': '    "Lemniscate" türkcesi nedir?',
    'answers': [
      {'answerText': '  Sonsuzluk işareti', 'score': true},
      {'answerText': '  Evren', 'score': false},
      {'answerText': '  Galaksi', 'score': false},
    ],
  },
  {
    'question': '    "Beneficial" türkcesi nedir?',
    'answers': [
      {'answerText': '  Faydalı', 'score': true},
      {'answerText': '  Kayıp', 'score': false},
      {'answerText': '  Benfikalı', 'score': false},
    ],
  },
  {
    'question': '    "Capable " türkcesi nedir?',
    'answers': [
      {'answerText': '  Yerleşim', 'score': false},
      {'answerText': '  Kapasite', 'score': false},
      {'answerText': '  Yetenekli', 'score': true},
    ],
  },
  {
    'question': '    "Certain" türkcesi nedir?',
    'answers': [
      {'answerText': '  Becerikli', 'score': false},
      {'answerText': '  Belirli', 'score': true},
      {'answerText': '  Belirsiz', 'score': false},
    ],
  },
  {
    'question': '    "Differential" türkcesi nedir?',
    'answers': [
      {'answerText': '  Ücret farkı', 'score': true},
      {'answerText': '  Farklılık', 'score': false},
      {'answerText': '  Kayıp', 'score': false},
    ],
  },
  {
    'question': '    "Inherent " türkcesi nedir?',
    'answers': [
      {'answerText': '  Doğa', 'score': false},
      {'answerText': '  Doğasında olan', 'score': true},
      {'answerText': '  Refleks', 'score': false},
    ],
  },
  {
    'question': '    "Intrinsic" türkcesi nedir?',
    'answers': [
      {'answerText': '  Esrar', 'score': false},
      {'answerText': '  Esas', 'score': true},
      {'answerText': '  İlginç', 'score': false},
    ],
  },
  {
    'question': '    "Obsolete" türkcesi nedir?',
    'answers': [
      {'answerText': '  Orman', 'score': false},
      {'answerText': '  Oradan', 'score': false},
      {'answerText': '  Eskimiş', 'score': true},
    ],
  },
  {
    'question': '    "Satisfactory" türkcesi nedir?',
    'answers': [
      {'answerText': '  Satışlar', 'score': false},
      {'answerText': '  Hoşnut edici', 'score': true},
      {'answerText': '  Kar', 'score': false},
    ],
  },
  {
    'question': '    "Oyster" türkcesi nedir?',
    'answers': [
      {'answerText': '  Ördek', 'score': false},
      {'answerText': '  İstridye', 'score': true},
      {'answerText': '  İnci', 'score': false},
    ],
  },
];
