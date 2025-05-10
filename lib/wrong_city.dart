import 'package:flutter/material.dart';

class WrongCity extends StatelessWidget {
  const WrongCity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AYOO?'
        ),
      ),
      body: Center(child: Text('DID U ENTERED THE CORRECT CITY BRO?? 💀💀❌❌',
      style: TextStyle(
        fontSize: 30
      ),
      )
      ),
    );
  }
}