import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../config/wp_config.dart';
import '../../models/member.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

abstract class AuthRepoAbstract {
  /// Login User
  Future<Member?> login({required String email, required String password});

  /// Logout User
  Future<void> logout();

  /// Signup User
  Future<bool> signUp({
    required String userName,
    required String email,
    required String password,
  });

  /// Send OTP for password reset link
  Future<bool> sendPasswordResetLink(String email);

  /// Verify OTP
  Future<bool> verifyOTP({required int otp, required String email});

  /// Set The New Password
  Future<bool> setPassword({
    required String email,
    required String newPassword,
    required int otp,
  });

  /// Is User Logged In
  Future<bool> isLoggedIn();

  /// Saves Token to Secure Storage
  Future<bool> saveToken({required String token});

  /// Deletes token from secure Storage
  Future<bool> deleteToken();

  /// Retrieve Token from Secure Storage
  Future<String?> getToken();

  /// Validate Token from Server
  Future<bool> vallidateToken({required String token});

  /// Get Saved user on device
  Future<Member?> getUser();

  /// Delete Saved user on device;
  Future<void> deleteUserData();

  /// Save User Data on device
  Future<void> saveUserData(Member data);
}

/// Responsible for Communicating with server get
/// data about authentication
class AuthRepository extends AuthRepoAbstract {
  /// Used for fetching, deleting, updating, it can be anything in String
  /// Don't modify it unless necessary
  final String _tokenKey = '_thePro322';
  static const _iOptions = IOSOptions(
    accessibility: IOSAccessibility.first_unlock,
  );
  static const _aOptions = AndroidOptions(encryptedSharedPreferences: true);

  @override
  Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    String? _value = await _storage.read(
      key: _tokenKey,
      iOptions: _iOptions,
      aOptions: _aOptions,
    );
    return _value;
  }

  @override
  Future<bool> saveToken({required String token}) async {
    const _storage = FlutterSecureStorage();

    try {
      await _storage.write(
        key: _tokenKey,
        value: token,
        iOptions: _iOptions,
        aOptions: _aOptions,
      );
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteToken() async {
    const _storage = FlutterSecureStorage();
    try {
      await _storage.delete(key: _tokenKey);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> vallidateToken({required String token}) async {
    String _url = 'https://${WPConfig.url}/wp-json/jwt-auth/v1/token/validate';

    try {
      final _response = await http.post(
        Uri.parse(_url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (_response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    String? _token = await getToken();
    bool _loggedIn = false;

    if (_token != null) {
      bool _isValid = await vallidateToken(token: _token);
      if (_isValid) _loggedIn = true;
    }
    return _loggedIn;
  }

  @override
  Future<Member?> login({
    required String email,
    required String password,
  }) async {
    String _url = 'https://${WPConfig.url}/wp-json/jwt-auth/v1/token';

    try {
      final _response = await http.post(
        Uri.parse(_url),
        body: {
          'username': email,
          'password': password,
        },
      );
      if (_response.statusCode == 200) {
        final _decodeResponse = jsonDecode(_response.body);
        await saveToken(token: _decodeResponse['token']);
        final _user = Member.fromServer(_decodeResponse);
        await saveUserData(_user);
        return _user;
      } else {
        return null;
      }
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await deleteToken();
      deleteUserData();
    } on Exception catch (_) {}
  }

  @override
  Future<bool> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    String _url = 'https://${WPConfig.url}/wp-json/wp/v2/users/register/';

    try {
      final _response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {'username': userName, 'email': email, 'password': password},
        ),
      );

      if (_response.statusCode == 200) {
        return true;
      } else if (_response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'Email/Username already exists');
        return false;
      } else {
        return false;
      }
    } on Exception catch (_) {
      Fluttertoast.showToast(msg: 'Oops! Something gone wrong');
      return false;
    }
  }

  @override
  Future<bool> sendPasswordResetLink(String email) async {
    String _url =
        'https://${WPConfig.url}/wp-json/bdpwr/v1/reset-password?email=$email';

    debugPrint('Send Password $_url');

    try {
      final _response = await http.post(Uri.parse(_url));
      if (_response.statusCode == 200) {
        return true;
      } else if (_response.statusCode == 500) {
        Fluttertoast.showToast(msg: 'No Users Exist with this email');
        return false;
      } else if (_response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'You must provide an email address');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Something gone wrong');
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  @override
  Future<bool> setPassword({
    required String email,
    required String newPassword,
    required int otp,
  }) async {
    String _url =
        'https://${WPConfig.url}/wp-json/bdpwr/v1/set-password?email=$email&password=$newPassword&code=$otp';

    debugPrint('Set password url $_url');

    try {
      final _response = await http.post(Uri.parse(_url));

      if (_response.statusCode == 200) {
        return true;
      } else if (_response.statusCode == 500) {
        Fluttertoast.showToast(msg: 'Reset Code is Invalid');
        return false;
      }
      {
        Fluttertoast.showToast(msg: 'Password could not be set');
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  @override
  Future<bool> verifyOTP({required int otp, required String email}) async {
    String _url =
        'https://${WPConfig.url}/wp-json/bdpwr/v1/validate-code?email=$email&code=$otp';

    debugPrint('Verify OTP url $_url');
    try {
      final _response = await http.post(Uri.parse(_url));
      if (_response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  /* <----  -----> */ /* <----  -----> */
  /* <-----------------------> 
      USER DATA SAVING [Local]     
  <-----------------------> */

  final String _userBoxKey = 'user';
  final String _userKey = '_jiie';

  @override
  Future<Member?> getUser() async {
    var box = Hive.box(_userBoxKey);
    final Map? _data = box.get(_userKey);
    if (_data != null) {
      final _theUser = Member.fromLocal(Map.from(_data));
      return _theUser;
    } else {
      return null;
    }
  }

  @override
  Future<void> saveUserData(Member data) async {
    var box = Hive.box(_userBoxKey);
    await box.put(_userKey, data.toMap());
  }

  @override
  Future<void> deleteUserData() async {
    var box = Hive.box(_userBoxKey);
    await box.delete(_userKey);
  }

  /// Initializes Users Databases
  Future<void> init() async {
    await Hive.openBox(_userBoxKey);
  }
}
