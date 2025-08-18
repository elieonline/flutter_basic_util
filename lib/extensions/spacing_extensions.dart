import 'package:flutter/material.dart';

extension SpacingExtensions on num {
  double sh(BuildContext cx) {
    return MediaQuery.sizeOf(cx).height * this;
  }

  double sw(BuildContext cx) {
    return MediaQuery.sizeOf(cx).width * this;
  }

  Widget get sbH => SizedBox(height: toDouble());
  Widget get sbW => SizedBox(width: toDouble());
}
