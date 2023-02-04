import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/screens/user/user_detail.dart';
import '../bars/pie_chart_test.dart';
import '../bars/schedule.dart';
import '../chart/mainChart.dart';
import '../home_screen/home.dart';


class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;
  late List<Map<String, Widget>> _pages;
  @override
  void initState(){
    _pages =[
      {
        'page' : const Home()
      },
      {
        'page' :  MainChart()
      },
      {
        'page' : const UserDetail()
      },
      {
        'page' : const Schedule()
      }

    ];
    super.initState();
  }

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _pages[currentIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.green,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              tooltip: 'Home',
              label: 'Home',
              //backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                tooltip: 'Chart',
                label: 'Chart'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                tooltip: 'User',
                label: 'User'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_sharp),
              tooltip: "test",
              label: "test"
            )
          ],
        ),
      ),
    );
  }
}