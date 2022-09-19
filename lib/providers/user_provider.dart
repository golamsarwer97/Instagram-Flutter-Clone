import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethod _authMethod = AuthMethod();

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

// = UserModel(
// userName: '',
// userEmail: '',
// userId: '',
// userBio: '',
// photoUrl: '',
// followers: [],
// following: [],
// );
