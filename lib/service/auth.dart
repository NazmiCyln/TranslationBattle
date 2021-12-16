import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Giriş yap
  Future<User> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

//çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  //kayıt ol fonksiyonu
  Future<User> createPerson(
      String name, String nick, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    String resimYolu =
        "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png";

    await _firestore.collection("Person").doc(user.user.uid).set({
      'userName': name,
      'nick': nick,
      'email': email,
      'elo': 200,
      'durum': false,
      'resim': resimYolu,
    });

    return user.user;
  }

  Future<User> guncelle(String passwordU, String nick, String nameU) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred =
        EmailAuthProvider.credential(email: user.email, password: "cccccc");

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(passwordU).then((value) {
        Fluttertoast.showToast(msg: "t.");
      });
    });

    DocumentReference veriGuncellemeYolu =
        _firestore.collection("Person").doc(_auth.currentUser.uid);

    Map<String, dynamic> guncellenecekVeri = {
      "userName": nameU,
      "nick": nick,
    };

    veriGuncellemeYolu.update(guncellenecekVeri).whenComplete(() {
      Fluttertoast.showToast(msg: "Guncellendi.");
    });
  }

  Future resimAl(String resim) async {
    var data = await FirebaseStorage.instance.ref().child(resim);

    var url = await data.getDownloadURL();

    _firestore
        .collection("Person")
        .doc(_auth.currentUser.uid)
        .update({"resim": url});
  }
}
