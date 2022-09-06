import 'package:webview_auth_tizen/oauth/auth_data.dart';
import 'package:webview_auth_tizen/oauth/oauth2.dart';

import 'dart:async';

import 'package:http/http.dart' as http;

import 'dart:convert';

//ignore: must_be_immutable
class GoogleLoginPage extends OAuthProviderPage {
  final String clientID;
  final String state;
  final String scope;

  GoogleLoginPage({
    required this.clientID,
    required this.state,
    required this.scope,
    required super.redirectUri,
    super.key,
  }) : super(
          host: 'accounts.google.com',
          path: '/o/oauth2/auth',
        );

  @override
  Future<AuthResult> get authResult async {
    final returnedData = await redirectUriReturned.future;

    returnedData['clientID'] = clientID;
    returnedData['redirectURI'] = redirectUri;

    final authResult = AuthResult(
      clientID: clientID,
      accessToken: returnedData['access_token'],
      idToken: returnedData['id_token'],
      code: returnedData['code'],
      response: returnedData,
    );

    return authResult;
  }

  @override
  Map<String, String> buildQueryParams() {
    return {
      'client_id': clientID,
      'redirect_uri': redirectUri,
      'scope': scope,
      'response_type': 'token id_token',
    };
  }
}

//ignore: must_be_immutable
class GithubLoginPage extends OAuthProviderPage {
  final String clientID;
  final String state;
  final String scope;

  static const kAccessTokenPath = '/login/oauth/access_token';
  static const host_ = 'github.com';
  static const path_ = '/login/oauth/authorize';
  static const responseType_ = 'token id_token';

  String clientSecret;

  GithubLoginPage({
    required this.clientID,
    required this.state,
    required this.scope,
    required super.redirectUri,
    required this.clientSecret,
    super.key,
  }) : super(
          host: host_,
          path: path_,
        );

  @override
  Future<AuthResult> get authResult async {
    final returnedData = await redirectUriReturned.future;

    final authResult = AuthResult(
      clientID: clientID,
      accessToken: returnedData['access_token'],
      idToken: returnedData['id_token'],
      code: returnedData['code'],
      response: returnedData,
    );

    if (authResult.code == null) {
      throw Exception('github did not return code!');
    }

    final result = await post(kAccessTokenPath, {
      'client_id': clientID,
      'client_secret': clientSecret,
      'code': authResult.code!,
      'redirect_uri': redirectUri,
    });

    authResult.accessToken = result['access_token'];

    return authResult;
  }

  static Future post(String path, Map<String, String> params) async {
    var uri =
        Uri(scheme: 'https', host: host_, path: path, queryParameters: params);

    final res = await http.post(
      uri,
      headers: {"Accept": "application/json"},
      body: params,
    );

    if (res.statusCode == 200) {
      final decodedRes = json.decode(res.body);

      if (!decodedRes.containsKey('access_token')) {
        throw Exception("Couldn't authroize");
      }

      return decodedRes;
    } else {
      throw Exception('HttpCode: ${res.statusCode}, Body: ${res.body}');
    }
  }

  @override
  Map<String, String> buildQueryParams() {
    return {
      'client_id': clientID,
      'redirect_uri': redirectUri,
      'scope': scope,
      'state': state,
      'response_type': 'id_token',
    };
  }
}
