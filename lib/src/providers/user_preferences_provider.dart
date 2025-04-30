import 'package:flutter/cupertino.dart';

class UserPreferencesProvider extends ChangeNotifier{
  String _gender = '';
  String _age = '';
  final List<String> _favoriteGenres= [];


  String get gender => _gender;
  String get age => _age;
  List<String> get favGenres => _favoriteGenres;

  void setGender(String gender){
    _gender = gender;
    notifyListeners();
  }

  void setAge(String age){
    _age = age;
    notifyListeners();
  }

  void toggleGenre(String genre){
    if(_favoriteGenres.contains(genre)){
      _favoriteGenres.remove(genre);
    }else{
      _favoriteGenres.add(genre);
    }
    notifyListeners();
  }

}