import 'dart:typed_data';
import 'package:baegopa/navigator/board_navi.dart';
import 'package:flutter/material.dart';
import 'board_write_navi.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  NavigatorScreenState createState() => NavigatorScreenState();
}

class NavigatorScreenState extends State<NavigatorScreen>
    with TickerProviderStateMixin {
  Color myColor = Colors.pink.shade200;
  late Uint8List? profile;
  late List<Widget> _children;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      const HomeScreen(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const BoardWriteScreen()
    ];

    Widget fadeZoomTransition(Widget child) {
      return ScaleTransition(
        scale:
            Tween<double>(begin: 0.99, end: 1.0).animate(_animationController),
        child: FadeTransition(
          opacity: _animation,
          child: child,
        ),
      );
    }

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _children.map((e) => fadeZoomTransition(e)).toList(),
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        child: BottomAppBar(
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(0.0),
            ),
            padding: const EdgeInsets.only(top: 3.0, bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildNavItem(Icons.library_books, 0),
                const SizedBox(width: 8.0),
                _buildNavItem(Icons.notifications, 1),
                const SizedBox(width: 8.0),
                _buildNavItem(Icons.person, 2),
                const SizedBox(width: 8.0),
                _buildNavItem(Icons.edit_document, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isActive = index == _currentIndex;
    return GestureDetector(
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 64.0,
            height: MediaQuery.of(context).size.height * 0.035,
            decoration: BoxDecoration(
              color: isActive ? Colors.red.shade400.withOpacity(0.8) : Colors.transparent,
              borderRadius: BorderRadius.circular(isActive ? 16.0 : 0.0),
            ),
            child: Icon(
              icon,
              size: 24.0,
              color: isActive ? Colors.white : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _animationController.forward(from: 0.0);
      pageController.jumpToPage(index);
    }
  }
}
