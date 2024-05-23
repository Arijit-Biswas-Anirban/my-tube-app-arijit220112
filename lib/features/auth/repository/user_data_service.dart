import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService{
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  UserDataService({
  required this.auth,
  required this.firestore,
});

  addUserDataToFirestore() async{

  }

}