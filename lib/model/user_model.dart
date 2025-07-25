


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class UserModel extends Model {

  FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebase_user;  // Para criar ou receber um usuário
  Map<String,dynamic> userData = Map();
  bool isLoading = false;

  // para poder acessar a class UserModel sem presizar do ScopedMode
  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

  // Função "initState" do Model
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    // para carregar o usuario assim que entra no app
    _loadCurrentUser();
  }

  void signUp({required Map<String, dynamic> user_data, required String pass, required VoidCallback onSuccess, required VoidCallback onFail}) async{

    isLoading = true;
    notifyListeners(); // Para reconstruir a pagina

    _auth.createUserWithEmailAndPassword(
        email: user_data['email'],
        password: pass,
    ).then((user) async{
      firebase_user = user.user!;
      await _saveUserData(user_data);
      _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((error){
      onFail();
      isLoading = false;
      notifyListeners();
    });


  }

  void signIn({required String email,required String password,required VoidCallback onSuccess,required VoidCallback onFail}) async{

    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(
      email: email,
      password: password
    ).then((user){
      firebase_user = user.user;
      _loadCurrentUser();
      onSuccess();

    }).catchError((error){
      onFail();
    });

    isLoading = false;
    notifyListeners();

  }

  bool isLoggedIn(){
    return firebase_user != null;
  }


  void signOut() async{
    await _auth.signOut();
    userData = Map();
    firebase_user = null;
    notifyListeners();
  }


  void recoverPass(String email){

    _auth.sendPasswordResetEmail(email: email);

  }

  Future<void> _saveUserData(Map<String, dynamic> user_data) async{
    this.userData = user_data;
    await FirebaseFirestore.instance.collection('users').doc(firebase_user!.uid).set(this.userData);
  }


  // ############## Função para pegar o usuario do firebase com acredencial ###########
  void _loadCurrentUser() async{
    if(firebase_user == null)
      firebase_user = _auth.currentUser;
    if(firebase_user != null)
      if(userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance.collection('users').doc(firebase_user?.uid).get();
        userData = docUser.data() as Map<String, dynamic>;
      }
    notifyListeners();

  }

}