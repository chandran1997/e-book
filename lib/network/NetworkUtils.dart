import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutterapp/main.dart';
import 'package:flutterapp/utils/QueryString.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class APICall {
  bool? isHttps;

  APICall() {
    if (BASE_URL.startsWith("https")) {
      this.isHttps = true;
    } else {
      this.isHttps = false;
    }
  }

  _getOAuthURL(String requestMethod, String endpoint) {
    var consumerKey = CONSUMER_KEY;
    var consumerSecret = CONSUMER_SECRET;

    var token = "";
    var tokenSecret = "";
    var url = BASE_URL + endpoint;
    var containsQueryParams = url.contains("?");

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if (this.isHttps == true) {
      return url +
          (containsQueryParams == true
              ? "&consumer_key=" + CONSUMER_KEY + "&consumer_secret=" + CONSUMER_SECRET
              : "?consumer_key=" +
                  CONSUMER_KEY +
                  "&"
                      "consumer_secret=" +
                  CONSUMER_SECRET);
    } else {
      var rand = new Random();
      var codeUnits = new List.generate(10, (index) {
        return rand.nextInt(26) + 97;
      });

      var nonce = new String.fromCharCodes(codeUnits);
      int timestamp = new DateTime.now().millisecondsSinceEpoch ~/ 1000;

      var method = requestMethod;
      var parameters =
          "oauth_consumer_key=" + consumerKey + "&oauth_nonce=" + nonce + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" + timestamp.toString() + "&oauth_token=" + token + "&oauth_version=1.0&";

      if (containsQueryParams == true) {
        parameters = parameters + url.split("?")[1];
      } else {
        parameters = parameters.substring(0, parameters.length - 1);
      }

      Map<dynamic, dynamic> params = QueryString.parse(parameters);
      Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
      treeMap.addAll(params);

      String parameterString = "";

      for (var key in treeMap.keys) {
        parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
      }

      parameterString = parameterString.substring(0, parameterString.length - 1);

      var baseString = method + "&" + Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) + "&" + Uri.encodeQueryComponent(parameterString);

      var signingKey = consumerSecret + "&" + tokenSecret;
      var hmacSha1 = new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
      var signature = hmacSha1.convert(utf8.encode(baseString));

      var finalSignature = base64Encode(signature.bytes);

      var requestUrl = "";

      if (containsQueryParams == true) {
        requestUrl = url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
      } else {
        requestUrl = url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
      }

      return requestUrl;
    }
  }

  Future<http.Response> getAsync(String endPoint) async {
    var url = this._getOAuthURL("GET", endPoint);

    print(url);
    final response = await http.get(Uri.parse(url));
    print('${response.statusCode} $url');
    print(jsonDecode(response.body));

    return response;
  }

  Future<http.Response> postMethod(String endPoint, Map? data, {requireToken = false}) async {
    var url = this._getOAuthURL("POST", endPoint);

    print(url);
    print(jsonEncode(data));

    var headers = {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8', HttpHeaders.cacheControlHeader: 'no-cache'};

    if (requireToken) {
      var header = {"token": "${appStore.token}", "id": "${appStore.userId}"};
      headers.addAll(header);
    }
    var client = new http.Client();

    var response = await client.post(Uri.parse(url), body: jsonEncode(data), headers: headers);
    return response;
  }

  Future<http.Response> tokenPostMethod(String endPoint, {requireToken = false}) async {
    Map<String, String> buildHeaderTokens() {
      Map<String, String> header = {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.cacheControlHeader: 'no-cache',
        HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Origin': '*',
      };

      if (appStore.isLoggedIn) {
        header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}, id ${appStore.userId}');
      }
      log(jsonEncode(header));
      return header;
    }

    var url = this._getOAuthURL("POST", endPoint);

    print(url);
    print("Reuqest");

    var client = new http.Client();
    var response = await client.post(Uri.parse(url), headers: buildHeaderTokens());
    return response;
  }

  Future<http.Response> getMethod(String endpoint, {requireToken = false}) async {
    var url = this._getOAuthURL("GET", endpoint);
    print(url);

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };

    if (requireToken) {
      var header = {"token": "${appStore.token}", "id": "${appStore.userId}"};
      headers.addAll(header);
    }

    final response = await http.get(Uri.parse(url), headers: headers);
    print("Response");

    return response;
  }
}
