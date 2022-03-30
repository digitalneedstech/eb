import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget{
  final String message;
  final MainAxisAlignment mainAxisAlignment;
  ChatMessage({required this.mainAxisAlignment,required this.message});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.5,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: Center(child: Text(message),),
          )
        ],
      ),
    );
  }
}