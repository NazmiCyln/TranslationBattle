import 'package:flutter/material.dart';
import 'package:myfirsproje/Finish.dart';
import 'package:myfirsproje/answer.dart';

class Home extends StatefulWidget {
  String homekullaniciAdi;
  int levelIndex;
  Home({this.homekullaniciAdi, this.levelIndex});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //when the quiz ends
      if (_questionIndex + widget.levelIndex + 1 ==
          widget.levelIndex + 10 /*_questions.length*/) {
        endOfQuiz = true;
        finish();
      }
    });
  }

  void finish() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Finish(
          finishKullaniciAdi: widget.homekullaniciAdi,
          totalScore: _totalScore + widget.levelIndex,
        ),
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF373855),
      appBar: AppBar(
        backgroundColor: Color(0xFF373855),
        title: Text(
          'Kullanıcı adı : ${widget.homekullaniciAdi}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
        child: Center(
          child: Column(
            children: [
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
                margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    _questions[_questionIndex + widget.levelIndex]['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ...(_questions[_questionIndex + widget.levelIndex]['answers']
                      as List<Map<String, Object>>)
                  .map(
                (answer) => Answer(
                  answerText: answer['answerText'],
                  answerColor: answerWasSelected
                      ? answer['score']
                          ? Colors.green
                          : Colors.red
                      : null,
                  answerTap: () {
                    // if answer was already selected then nothing happens onTap
                    if (answerWasSelected) {
                      return;
                    }
                    //answer is being selected
                    _questionAnswered(answer['score']);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
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
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  '${(_questionIndex + widget.levelIndex + 1).toString()}/${_questions.length}',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              if (answerWasSelected && !endOfQuiz)
                Container(
                  height: 100,
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
      ),
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
