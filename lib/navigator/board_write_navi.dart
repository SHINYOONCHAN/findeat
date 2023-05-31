import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BoardWriteScreen extends StatefulWidget {

  const BoardWriteScreen({Key? key}) : super(key: key);

  @override
  BoardWriteScreenState createState() => BoardWriteScreenState();
}

class BoardWriteScreenState extends State<BoardWriteScreen> {
  Dio dio = Dio();

  void _insertboard() async {
    try {
      Response response = await dio.post(
        'http://211.201.93.173:8081/board_insert',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'TITLE': "클라이언트",
          'WRITER': "클라이언트",
          'CONTENT': "클라이언트"
        },
      );
      if (response.statusCode == 200) {
      }
    } catch (error) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
        title: const Text("글쓰기", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: (){
                    _insertboard();
                  },
                style: ElevatedButton.styleFrom(
                  splashFactory: InkRipple.splashFactory,
                  elevation: 0.1,
                  backgroundColor: Colors.red.shade50,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                child: Text(
                  "글쓰기",
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}