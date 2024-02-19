import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:testopenai/colors.dart';
import 'package:testopenai/qna.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late TextEditingController controller;
  String response = "";
  List<QnA> qnaList = [QnA(question: "Hii", answer: "How can i help you?")];
  String history = "";

  @override
  void initState() {
    controller = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: backgroundColor,
      title: "ChatGpt",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text("Lets Chat..."),
        ),
        backgroundColor: backgroundColor,
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          response == "Loading" ? const Text("Loading....") : const SizedBox(),
          Expanded(
            child: ListView.builder(
                reverse: true,
                itemCount: qnaList.length,
                itemBuilder: ((context, index) {
                  const SizedBox(height: 10,);
                  return QnAContainer(qna: qnaList[index]);
                })),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  cursorColor: textfeild,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: textfeild),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: textfeild),
                      ),
                      hintText: "Input",
                      hintStyle: TextStyle(color: textfeild)),
                ),
              ),
              TextButton(
                  onPressed: () {
                    callapi(controller.text);
                    controller.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Icon(
                    Icons.send,
                    color: textfeild,
                  )),
            ],
          ),
        ]),
      ),
    );
  }

  callapi(String input) async {
    setState(() {
      response = "Loading...";
    });
    for (var i in qnaList) {
      history = '$history\n${i.question}';
    }
    var url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['token']}'
        },
        body: jsonEncode({
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a helpful assistant designed to output in paras or sentense.",
            },
            {
              "role" : "system",
              "content" : "Answer according to the previous questions and those are given each question is seperated by '\n' $history"
            },
            {"role": "user", "content": input},
          ],
          "model": "gpt-3.5-turbo",
          "max_tokens": 250,
          "temperature": 0,
          "top_p": 1,
        }));

    print(res.body);

    if (res.statusCode == 200) {
      final jasonResponse = json.decode(res.body);
      setState(() {
        response = jasonResponse['choices'][0]['message']['content'];
        qnaList.insert(0, QnA(question: input, answer: response));
      });
    }
  }
}
