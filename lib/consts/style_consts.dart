import 'package:flutter/material.dart';

InputDecoration inputDecoration(String hintText, Icon icon) {
  return InputDecoration(
    hintText: hintText,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    icon: icon,
    alignLabelWithHint: true,
  );
}
