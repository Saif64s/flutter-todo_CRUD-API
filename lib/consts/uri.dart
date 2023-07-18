// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const BASE_URL = 'api.nstack.in';

void showFeedback(BuildContext context, String msg, Color bgColor) {
  final snackbar = SnackBar(
    content: Text(msg),
    backgroundColor: bgColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
