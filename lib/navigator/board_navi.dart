import 'dart:async';
import 'package:baegopa/screens/board_screen.dart';
import 'package:baegopa/utils/ShowDialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late double screenWidth = 0.0;
  late double screenHeight = 0.0;
  Dio dio = Dio();

  Timer? timer;
  List<Map<String, dynamic>> dataList = [];
  int visibleItemCount = 10; // 초기에 보여줄 아이템 개수
  int additionalItemCount = 10; // 더보기 버튼 클릭 시 추가로 보여줄 아이템 개수
  bool showMoreButton = false; // 더보기 버튼 표시 여부
  bool dataStatus = false;

  @override
  void initState() {
    super.initState();
    _getScreenSize();
    _boardlist();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void _getScreenSize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        screenWidth = MediaQuery.of(context).size.width;
        screenHeight = MediaQuery.of(context).size.height;
      });
    });
  }

  void _boardlist() async {
    try {
      Response response =
          await dio.get('http://211.201.93.173:8081/board_list');
      if (response.statusCode == 200) {
        dataStatus = true;
        List<dynamic> data = response.data;
        setState(() {
          dataList = data.map((item) {
            return {
              "번호": item["NUM"],
              "제목": item["TITLE"],
              "작성자": item["WRITER"],
              "내용": item["CONTENT"],
              "작성날짜": item["REGDATE"],
              "조회수": item["CNT"]
            };
          }).toList();
        });
        showMoreButton = visibleItemCount < dataList.length;
      } else {
        dataStatus = false;
      }
    } catch (error) {
      setState(() {
        dataStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
        title: const Text("전체게시판", style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          _boardlist();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!dataStatus)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (dataStatus && dataList.isEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "게시글이 없습니다.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (dataList.isNotEmpty)
                ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: visibleItemCount > dataList.length
                      ? dataList.length
                      : visibleItemCount,
                  itemBuilder: (context, index) {
                    final item = dataList[index];
                    int num = item["번호"];
                    String title = item["제목"];
                    String content = item["내용"];
                    String writer = item["작성자"];
                    String date = DateFormat('yy.MM.dd. hh.mm').format(
                      DateTime.parse(item["작성날짜"]),
                    );
                    String cnt = item["조회수"].toString();

                    return listTile(
                      context,
                      num,
                      title,
                      content,
                      writer,
                      date,
                      cnt,
                      _boardlist,
                    );
                  },
                ),
              if (showMoreButton)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visibleItemCount += additionalItemCount;
                      showMoreButton = visibleItemCount < dataList.length;
                    });
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
                    "더보기",
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget listTile(BuildContext context, int num, String title, contents, writer,
    datetime, cnt, VoidCallback onTap) {
  String rogdate = '$writer ${datetime.substring(0, 8)}. 조회 $cnt';

  return Column(
    children: [
      Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ListTile(
          onTap: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BoardScreen(
                        num: num,
                        title: title,
                        contents: contents,
                        writer: writer,
                        date: datetime,
                        cnt: cnt)));
            if (!result) {
              onTap();
            }
          },
          horizontalTitleGap: 0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(190, 0, 0, 0))),
          subtitle: Text(rogdate,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        showMsg(context, '댓글', '추가예정');
                      }, //댓글
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.height * 0.07),
                        elevation: 0,
                        backgroundColor: Colors.grey.shade200.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      child: const Text('0\n댓글',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          textAlign: TextAlign.center),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        height: 0.5,
        width: MediaQuery.of(context).size.width * 0.87,
        color: Colors.grey.shade400,
      ),
    ],
  );
}
