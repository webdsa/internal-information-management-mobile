import 'package:flutter/material.dart';
import 'Palette.dart';

class Styles {
  static final TextStyle headline1 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 36);

  static final TextStyle headline2 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 25);

  static final TextStyle headline3 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20);

  static final TextStyle headline4 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15);

  static final TextStyle headline5 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 12);

  static final TextStyle h1 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 56);

  static final TextStyle h2 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 48);

  static final TextStyle h3 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 40);

  static final TextStyle h4 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32);

  static final TextStyle h5 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 24);

  static final TextStyle h6 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20);

  static final TextStyle subtitle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16);

  static final TextStyle body = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal);

  static final TextStyle bodyLarge = TextStyle(
      fontSize: 18, color: TextColors.text5);

  static final TextStyle caption = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal);

  static final TextStyle buttonSmall = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold);

  static final TextStyle button = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold);

  static final TextStyle buttonLarge = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold);

  static final TextStyle titleMedium = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 20);

  static final TextStyle titleSmall = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 15);

  static final TextStyle bodyText =
      TextStyle(fontSize: 12);

  static final TextStyle bodyTextCaps = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w500);

  static final TextStyle bodySmall = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal);
}

class DesktopTextStyles {
  static const TextStyle headlineH1 = TextStyle(fontSize: 56, fontWeight: FontWeight.bold); // 1rem
  static const TextStyle headlineH2 = TextStyle(fontSize: 48, fontWeight: FontWeight.bold); // 0.86rem
  static const TextStyle headlineH3 = TextStyle(fontSize: 40, fontWeight: FontWeight.bold); // 0.71rem
  static const TextStyle headlineH4 = TextStyle(fontSize: 32, fontWeight: FontWeight.w700); // 0.57rem
  static const TextStyle headlineH5 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold); // 0.43rem
  static const TextStyle headlineH6 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold); // 0.36rem

  static const TextStyle subtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500); // 0.29rem

  static const TextStyle bodySmall = TextStyle(fontSize: 14); // 0.25rem
  static const TextStyle bodyRegular = TextStyle(fontSize: 16); // 0.29rem
  static const TextStyle bodyLarge = TextStyle(fontSize: 18); // 0.32rem

  static const TextStyle buttonSmall = TextStyle(fontSize: 14, fontWeight: FontWeight.bold); // 0.25rem
  static const TextStyle buttonRegular = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold); // 0.29rem
  static const TextStyle buttonLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.bold); // 0.32rem

  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400); // 0.21rem
}

class AppTextStyles {
  static const TextStyle caption2 = TextStyle(fontSize: 10); // 18rem
  static const TextStyle caption1 = TextStyle(fontSize: 12); // 21rem
  static const TextStyle footnote = TextStyle(fontSize: 13); // 23rem
  static const TextStyle subhead = TextStyle(fontSize: 14); // 25rem
  static const TextStyle callout = TextStyle(fontSize: 16); // 29rem
  static const TextStyle body = TextStyle(fontSize: 16); // 29rem
  static const TextStyle headline = TextStyle(fontSize: 17); // 3rem
  static const TextStyle title3 = TextStyle(fontSize: 20); // 36rem
  static const TextStyle title2 = TextStyle(fontSize: 22); // 39rem
  static const TextStyle title1 = TextStyle(fontSize: 28); // 5rem
  static const TextStyle largeTitle = TextStyle(fontSize: 34); // 61rem

  // Bold
  static const TextStyle boldCaption2 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  ); // 18rem

  static const TextStyle boldCaption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ); // 21rem

  static const TextStyle boldFootnote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ); // 23rem

  static const TextStyle boldSubhead = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ); // 25rem

  static const TextStyle boldCallout = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ); // 29rem

  static const TextStyle boldBody = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ); // 29rem

  static const TextStyle boldHeadline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ); // 3rem

  static const TextStyle boldTitle3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ); // 36rem

  static const TextStyle boldTitle2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  ); // 39rem

  static const TextStyle boldTitle1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  ); // 5rem
  
  static const TextStyle boldLargeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w600,
  );
}