import 'package:flutter/material.dart';
import 'package:kofoos/src/pages/home/home_recommendation_page.dart';

void homeRecommendFunc(BuildContext context, List<dynamic> recommendations) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomeRecommendationPage(recommendations: recommendations),
    ),
  );
}