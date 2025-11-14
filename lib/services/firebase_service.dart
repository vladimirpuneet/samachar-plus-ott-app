import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  // Auth methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }

  User? get currentUser => auth.currentUser;

  // Firestore methods
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    return await firestore.collection(collection).doc(docId).set(data);
  }

  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    return await firestore.collection(collection).doc(docId).get();
  }

  Future<QuerySnapshot> getDocuments(String collection, {Query? query}) async {
    return await (query ?? firestore.collection(collection)).get();
  }

  Stream<QuerySnapshot> streamDocuments(String collection, {Query? query}) {
    return (query ?? firestore.collection(collection)).snapshots();
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    return await firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    return await firestore.collection(collection).doc(docId).delete();
  }

  // Storage methods
  Future<String> uploadFile(String path, String filePath) async {
    return await storage.ref(path).putData(await File(filePath).readAsBytes()).then((task) => task.ref.getDownloadURL());
  }

  Future<String> uploadFileFromBytes(String path, List<int> bytes, {String? contentType}) async {
    return await storage.ref(path).putData(
      bytes,
      SettableMetadata(contentType: contentType),
    ).then((task) => task.ref.getDownloadURL());
  }

  Future<String> getDownloadURL(String path) async {
    return await storage.ref(path).getDownloadURL();
  }

  Future<void> deleteFile(String path) async {
    return await storage.ref(path).delete();
  }
}