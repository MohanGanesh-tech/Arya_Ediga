import 'dart:io';
import 'package:arya_ediga_app_1v/login.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  String usererrormessage = " ";

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      usererrormessage = " ";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email');
        usererrormessage = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user');
        usererrormessage = 'Wrong password provided for that user';
      } else {
        usererrormessage = 'Something went wrong';
      }
      return Login();
    }
  }

  Future deteleprofile(reason, pass) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_profile')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'account': 'deleted',
            'lastupdate': FieldValue.serverTimestamp(),
            'deletereason': reason
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to add user: $error"));

      AuthCredential credential = EmailAuthProvider.credential(
          email: (FirebaseAuth.instance.currentUser!.email).toString(),
          password: pass);

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential)
          .then((value) => FirebaseAuth.instance.currentUser!.delete());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  Future feedback(subject, body) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_feedback')
          .doc()
          .set({
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'subject': subject,
            'body': body,
            'createdOn': FieldValue.serverTimestamp()
          })
          .then((value) => print("Feedback Sent"))
          .catchError((error) => print("Failed to add Post: $error"));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String bio,
    required String phone,
    required String username,
    FilePickerResult? photofile,
    required String gender,
    required DateTime dob,
  }) async {
    try {
      String? imageurl;

      if (photofile != null) {
        File file = File(photofile.files.first.path!);
        print(file);
        print(photofile.files.first.name);

        Reference ref = firebase_storage.FirebaseStorage.instance
            .ref('profile/' + photofile.files.first.name);
        UploadTask uploadTask = ref.putFile(file);
        var dowurl = await (await uploadTask).ref.getDownloadURL();
        imageurl = dowurl.toString();
        print(imageurl);
      }

      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((newuser) {
        FirebaseFirestore.instance
            .collection('user_profile')
            .doc(newuser.user!.uid)
            .set({
              'username': username,
              'photo': imageurl,
              'bio': bio,
              'email': email,
              'phone': phone,
              'account': 'active',
              'gender': gender,
              'dob': dob,
              'createdOn': FieldValue.serverTimestamp()
            })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<String?> newpost({
    required String title,
    required String desc,
    FilePickerResult? photofile,
  }) async {
    try {
      String? imageurl;

      if (photofile != null) {
        File file = File(photofile.files.first.path!);
        print(file);
        print(photofile.files.first.name);

        Reference ref = firebase_storage.FirebaseStorage.instance.ref(
            'user_posts/${FirebaseAuth.instance.currentUser!.uid}/' +
                photofile.files.first.name);
        UploadTask uploadTask = ref.putFile(file);
        var dowurl = await (await uploadTask).ref.getDownloadURL();
        imageurl = dowurl.toString();
        imageurl = imageurl.toString();

        await FirebaseFirestore.instance
            .collection('user_posts')
            .doc()
            .set({
              'uid': FirebaseAuth.instance.currentUser!.uid,
              'photo': imageurl,
              'title': title,
              'desc': desc,
              'like_by': [],
              'status': 'active',
              'createdOn': FieldValue.serverTimestamp()
            })
            .then((value) => print("Post Added"))
            .catchError((error) => print("Failed to add Post: $error"));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<String?> applyscholarship({
    required String fname,
    required String lname,
    required String phone,
    required String email,
    required String gender,
    required String address,
    required String state,
    required String district,
    required String schoolcollagename,
    required String scholarshipid,
    required String account_no,
    FilePickerResult? student_photo,
    FilePickerResult? income_cast,
    FilePickerResult? markscard,
    FilePickerResult? fee_recipte,
    FilePickerResult? aadharcard,
    FilePickerResult? bankpassbook,
  }) async {
    try {
      File studentPhotoFile = File(student_photo!.files.first.path!);
      Reference studentPhotoRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_scholarship_application/$scholarshipid/${FirebaseAuth.instance.currentUser!.uid}/' +
              student_photo.files.first.name);
      UploadTask studentPhotoUploadTask =
          studentPhotoRef.putFile(studentPhotoFile);
      String studentPhotoImageurl =
          (await (await studentPhotoUploadTask).ref.getDownloadURL())
              .toString();

      File incomeCastFile = File(income_cast!.files.first.path!);
      Reference incomeCastRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_scholarship_application/$scholarshipid/${FirebaseAuth.instance.currentUser!.uid}/' +
              income_cast.files.first.name);
      UploadTask incomeCastUploadTask = incomeCastRef.putFile(incomeCastFile);
      String incomeCastImageurl =
          (await (await incomeCastUploadTask).ref.getDownloadURL()).toString();

      File markscardFile = File(markscard!.files.first.path!);
      Reference markscardRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_scholarship_application/$scholarshipid/${FirebaseAuth.instance.currentUser!.uid}/' +
              markscard.files.first.name);
      UploadTask markscardUploadTask = markscardRef.putFile(markscardFile);
      String markscardImageurl =
          (await (await markscardUploadTask).ref.getDownloadURL()).toString();

      File feeRecipteFile = File(fee_recipte!.files.first.path!);
      Reference feeRecipteRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_scholarship_application/$scholarshipid/${FirebaseAuth.instance.currentUser!.uid}/' +
              fee_recipte.files.first.name);
      UploadTask feeRecipteUploadTask = feeRecipteRef.putFile(feeRecipteFile);
      String feeRecipteImageurl =
          (await (await feeRecipteUploadTask).ref.getDownloadURL()).toString();

      File aadharcardFile = File(aadharcard!.files.first.path!);
      Reference aadharcardRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_scholarship_application/$scholarshipid/${FirebaseAuth.instance.currentUser!.uid}/' +
              aadharcard.files.first.name);
      UploadTask aadharcardUploadTask = aadharcardRef.putFile(aadharcardFile);
      String aadharcardImageurl =
          (await (await aadharcardUploadTask).ref.getDownloadURL()).toString();

      File bankpassbookFile = File(bankpassbook!.files.first.path!);
      Reference bankpassbookRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_scholarship_application/$scholarshipid/${FirebaseAuth.instance.currentUser!.uid}/' +
              bankpassbook.files.first.name);
      UploadTask bankpassbookUploadTask =
          bankpassbookRef.putFile(bankpassbookFile);
      String bankpassbookImageurl =
          (await (await bankpassbookUploadTask).ref.getDownloadURL())
              .toString();

      await FirebaseFirestore.instance
          .collection('student_scholarship_application')
          .doc()
          .set({
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'scholarshipid': scholarshipid,
            'fname': fname,
            'lname': lname,
            'phone': phone,
            'email': email,
            'gender': gender,
            'state': state,
            'district': district,
            'address': address,
            'account_no': account_no,
            'schoolcollagename': schoolcollagename,
            'student_photo': studentPhotoImageurl,
            'income_cast': incomeCastImageurl,
            'markscard': markscardImageurl,
            'fee_recipte': feeRecipteImageurl,
            'aadharcard': aadharcardImageurl,
            'bankpassbook': bankpassbookImageurl,
            'status': "pending",
            'createdOn': FieldValue.serverTimestamp()
          })
          .then((value) => print("Scholarship Applied"))
          .catchError((error) => print("Failed to add Post: $error"));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<String?> applyhostel({
    required String fname,
    required String lname,
    required String phone,
    required String email,
    required String address,
    required String state,
    required String district,
    required String schoolcollagename,
    required String hostelid,
    FilePickerResult? student_photo,
    FilePickerResult? income_cast,
    FilePickerResult? markscard,
    FilePickerResult? fee_recipte,
    FilePickerResult? aadharcard,
  }) async {
    try {
      File studentPhotoFile = File(student_photo!.files.first.path!);
      Reference studentPhotoRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_hostel_application/$hostelid/${FirebaseAuth.instance.currentUser!.uid}/' +
              student_photo.files.first.name);
      UploadTask studentPhotoUploadTask =
          studentPhotoRef.putFile(studentPhotoFile);
      String studentPhotoImageurl =
          (await (await studentPhotoUploadTask).ref.getDownloadURL())
              .toString();

      File incomeCastFile = File(income_cast!.files.first.path!);
      Reference incomeCastRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_hostel_application/$hostelid/${FirebaseAuth.instance.currentUser!.uid}/' +
              income_cast.files.first.name);
      UploadTask incomeCastUploadTask = incomeCastRef.putFile(incomeCastFile);
      String incomeCastImageurl =
          (await (await incomeCastUploadTask).ref.getDownloadURL()).toString();

      File markscardFile = File(markscard!.files.first.path!);
      Reference markscardRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_hostel_application/$hostelid/${FirebaseAuth.instance.currentUser!.uid}/' +
              markscard.files.first.name);
      UploadTask markscardUploadTask = markscardRef.putFile(markscardFile);
      String markscardImageurl =
          (await (await markscardUploadTask).ref.getDownloadURL()).toString();

      File feeRecipteFile = File(fee_recipte!.files.first.path!);
      Reference feeRecipteRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_hostel_application/$hostelid/${FirebaseAuth.instance.currentUser!.uid}/' +
              fee_recipte.files.first.name);
      UploadTask feeRecipteUploadTask = feeRecipteRef.putFile(feeRecipteFile);
      String feeRecipteImageurl =
          (await (await feeRecipteUploadTask).ref.getDownloadURL()).toString();

      File aadharcardFile = File(aadharcard!.files.first.path!);
      Reference aadharcardRef = firebase_storage.FirebaseStorage.instance.ref(
          'student_hostel_application/$hostelid/${FirebaseAuth.instance.currentUser!.uid}/' +
              aadharcard.files.first.name);
      UploadTask aadharcardUploadTask = aadharcardRef.putFile(aadharcardFile);
      String aadharcardImageurl =
          (await (await aadharcardUploadTask).ref.getDownloadURL()).toString();

      await FirebaseFirestore.instance
          .collection('student_hostel_application')
          .doc()
          .set({
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'hostelid': hostelid,
            'fname': fname,
            'lname': lname,
            'phone': phone,
            'email': email,
            'state': state,
            'district': district,
            'address': address,
            'schoolcollagename': schoolcollagename,
            'student_photo': studentPhotoImageurl,
            'income_cast': incomeCastImageurl,
            'markscard': markscardImageurl,
            'fee_recipte': feeRecipteImageurl,
            'aadharcard': aadharcardImageurl,
            'status': "pending",
            'createdOn': FieldValue.serverTimestamp()
          })
          .then((value) => print("Hostel Applied"))
          .catchError((error) => print("Failed to add Post: $error"));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
