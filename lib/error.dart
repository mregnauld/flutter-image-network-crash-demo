import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget
{
  final String error;
  
  const ErrorPage({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(error),
        ),
      )
    );
  }
}
