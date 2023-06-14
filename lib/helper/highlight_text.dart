import 'dart:developer';

import 'package:flutter/material.dart';

List<TextSpan> highlightText({
  required String searchText,
  required String text,
}) {
  List<TextSpan> texts = [];

  final RegExp regExp =
      RegExp(searchText, caseSensitive: false, multiLine: true);

  final Iterable<Match> matches = regExp.allMatches(text);
  log(texts.toString(), name: "texts");
  log(searchText, name: "search");

  if (matches.isEmpty) {
    texts.add(highlightTextSpan(
      text: text,
      needHighlight: false,
    ));
  }

  int startIndex = 0;

  for (var i = 0; i < matches.length; i++) {
    final Match match = matches.elementAt(i);

    texts.add(
      highlightTextSpan(
        text: text.substring(startIndex, match.start),
        needHighlight: false,
      ),
    );

    texts.add(
      highlightTextSpan(
        text: text.substring(match.start, match.end),
        needHighlight: true,
      ),
    );

    if (i == matches.length - 1 && match.end != text.length) {
      texts.add(
        highlightTextSpan(
          text: text.substring(match.end),
          needHighlight: false,
        ),
      );
    }

    startIndex = match.end;
  }

  return texts;
}

TextSpan highlightTextSpan({
  required String text,
  required bool needHighlight,
}) {
  return TextSpan(
    text: text,
    style: TextStyle(
      color: needHighlight ? Colors.orange : Colors.black,
    ),
  );
}
