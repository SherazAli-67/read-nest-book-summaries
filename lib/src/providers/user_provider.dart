import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/cupertino.dart';
import 'package:read_nest/src/models/user_model.dart';
import 'package:read_nest/src/res/firebase_const.dart';

class UserProvider extends ChangeNotifier{
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = true;
  String? _error;

  StreamSubscription<fb.User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSubscription;

  UserProvider(){
    _listenToAuth();
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _listenToAuth(){
    _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((fb.User? user){
      _cancelUserDocSub();
      if(user == null){
        _currentUser = null;
        _isLoading = false;
        notifyListeners();
        return;
      }
      _subscribeToUserDoc(user.uid);
    });
  }

  void _subscribeToUserDoc(String userId){
    _isLoading = true;
    _error = null;
    notifyListeners();

    _userDocSubscription = _firestore
        .collection(FirebaseConst.usersCollection)
        .doc(userId)
        .snapshots()
        .listen((snapshot){
      if(snapshot.exists){
        final data = snapshot.data() ?? {};
        // Ensure userID field is populated even if missing in document
        _currentUser = UserModel.fromMap({
          'userID': data['userID'] ?? userId,
          'fName': data['fName'],
          'lName': data['lName'],
          'email': data['email'],
        });
        _isLoading = false;
        _error = null;
      }else{
        _currentUser = null;
        _isLoading = false;
        _error = 'User document not found';
      }
      notifyListeners();
    }, onError: (e){
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  void _cancelUserDocSub(){
    _userDocSubscription?.cancel();
    _userDocSubscription = null;
  }

  @override
  void dispose(){
    _authSubscription?.cancel();
    _cancelUserDocSub();
    super.dispose();
  }
}
