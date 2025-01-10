import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, //Http response from the request.
  required BuildContext context, // Context is to show the snackbar.
  required VoidCallback
      onSuccess, //the callback to execute on a successful response.
}) {
  //Switch statement to handle differet http status codes .
  switch (response.statusCode) {
    case 200: //Status code 200 indecates successful request.
      onSuccess();
      break;
    case 400: //status code 400 indecates bad request.
      showSnackbar(context, json.decode(response.body)['msg']);
      break;
    case 500: //status code 400 indecates bad request.
      showSnackbar(context, json.decode(response.body)['error']);
      break;
    case 201: //Status code 201 indecates request was successfully created.
      onSuccess();
      break;
  }
}

void showSnackbar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
