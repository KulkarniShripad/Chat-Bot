import 'package:flutter/material.dart';
import 'package:testopenai/colors.dart';

class QnA {
  String question;
  String  answer;
  QnA({required this.question, required this.answer});
}

class QnAContainer extends StatelessWidget {
  final QnA qna;
  const QnAContainer({super.key, required this.qna});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 0,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.account_circle_rounded, size: 25,color: Colors.white,),
              Expanded(child: Text(qna.question, textAlign: TextAlign.left, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(backgroundImage: AssetImage("assets/logo.jpg"), radius: 10,),
              SizedBox(width: 2,),
              Expanded(child: Text(qna.answer, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),)),
            ],
          ),
        ],
      ),
    );
  }
}