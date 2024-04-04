import 'package:flutter/material.dart';

TableRow weatherTableRow(String label, String value) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 16.0, letterSpacing: 1.2, color: Color(0xffF3F3F3)),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
              fontSize: 16.0,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: Color(0xffF3F3F3)),
        ),
      ),
    ), // Will be change later
  ]);
}
