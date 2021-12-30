import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:website/app.dart';

void main() {
  if (!kDebugMode) setPathUrlStrategy();
  runApp(const WaterbyteApp());
}
