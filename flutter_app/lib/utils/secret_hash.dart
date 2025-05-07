import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

/**
 * generateSecretHash function generates a secret hash using HMAC SHA-256 algorithm.
 * It takes the username, clientId, and clientSecret as input parameters.
 * The function encodes the clientSecret and the concatenated username and clientId,
 * then computes the HMAC SHA-256 hash and returns it as a base64 encoded string.
 */
///
String generateSecretHash({
  required String username,
  required String clientId,
  required String clientSecret,
}) {
  debugPrint("generateSecretHash called");
  final key = utf8.encode(clientSecret);
  final message = utf8.encode(username + clientId);
  final hmac = Hmac(sha256, key);
  final digest = hmac.convert(message);
  debugPrint("Secret has complete");
  return base64.encode(digest.bytes);
}