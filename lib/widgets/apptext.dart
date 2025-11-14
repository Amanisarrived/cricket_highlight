import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(
      this.text, {
        super.key,
        this.fontSize = 16,
        this.fontWeight = FontWeight.normal,
        this.color = Colors.black,
        this.textAlign = TextAlign.start,
        this.overflow,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.bebasNeue(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
