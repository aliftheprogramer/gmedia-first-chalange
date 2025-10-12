// lib/features/auth/data/model/login_request_model.dart

import 'dart:convert';

import 'package:gmedia_project/features/auth/domain/entities/login_request_entity.dart';

class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }

  String toJson() => json.encode(toMap());

  LoginRequestEntity toEntity() {
    return LoginRequestEntity(email: email, password: password);
  }

  factory LoginRequestModel.fromMap(Map<String, dynamic> map) {
    return LoginRequestModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  factory LoginRequestModel.fromJson(String source) =>
      LoginRequestModel.fromMap(json.decode(source));
}
