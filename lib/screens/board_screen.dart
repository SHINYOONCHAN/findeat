import 'package:baegopa/utils/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BoardScreen extends StatefulWidget {
  final int num;
  final String title;
  final String contents;
  final String writer;
  final String date;
  final String cnt;

  const BoardScreen(
      {Key? key,
      required this.num,
      required this.title,
      required this.contents,
      required this.writer,
      required this.date,
      required this.cnt})
      : super(key: key);

  @override
  BoardScreenState createState() => BoardScreenState();
}

class BoardScreenState extends State<BoardScreen> {
  Dio dio = Dio();
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

    Future<List<dynamic>?> fetchData() async {
    try {
      Response response = await dio.post('http://211.201.93.173:8081/board_select',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'NUM': widget.num,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) {
          return {
            "번호": item["NUM"],
            "제목": item["TITLE"],
            "작성자": item["WRITER"],
            "내용": item["CONTENT"],
            "작성날짜": item["REGDATE"],
            "조회수": item["CNT"]
          };
        }).toList();
      } else {
        throw Exception('Failed to data');
      }
    } catch (error) {
      Navigator.pop(context, false);
      showMsg(context, '게시글', '삭제된 게시글입니다.');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('전체게시판',
              style: TextStyle(fontSize: 17, color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child:  Icon(Icons.more_vert_rounded),
            ), 
          ],
        ),
        body: boardWidget(context));
  }

  Widget boardWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 15, left: 0, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 0),
                        horizontalTitleGap: 10,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: IconButton(
                                onPressed: () {
                                  //
                                },
                                splashRadius: 20,
                                padding: EdgeInsets.zero,
                                iconSize: 35,
                                icon: const Icon(Icons.person_outline,
                                    color: Colors.black)
                            ),
                          ),
                        ),
                        title: Text(widget.writer,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        subtitle: Text("${widget.date} 조회 ${widget.cnt}",
                            style: const TextStyle(
                                color: Color(0xff767676),
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                        onTap: () {
                          //
                        },
                      ),
                      Container(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width * 0.87,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.contents,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
