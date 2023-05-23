import 'package:flutter/material.dart';

abstract class UtilEvents {}

class SizeEvents extends UtilEvents {
  Size size;
  SizeEvents({required this.size});
}
