import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextSpan highlightSearch(String text, String query) {
  if (query.isEmpty) {
    return TextSpan(
      text: text,
      style: GoogleFonts.inter(color: Colors.black, fontSize: 15),
    );
  }

  final matches = <TextSpan>[];
  final lcText = text.toLowerCase();
  final lcQuery = query.toLowerCase();

  int start = 0;
  int index;

  while ((index = lcText.indexOf(lcQuery, start)) != -1) {
    if (index > start) {
      matches.add(
        TextSpan(
          text: text.substring(start, index),
          style: GoogleFonts.inter(color: Colors.black, fontSize: 15),
        ),
      );
    }

    matches.add(
      TextSpan(
        text: text.substring(index, index + query.length),
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 15,
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    start = index + query.length;
  }

  if (start < text.length) {
    matches.add(
      TextSpan(
        text: text.substring(start),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  return TextSpan(children: matches);
}
