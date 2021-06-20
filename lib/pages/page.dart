import 'package:flutter/material.dart';

abstract class AppPage extends StatelessWidget {
  const AppPage(this.leading, this.title);

  final Widget leading;
  final String title;
}