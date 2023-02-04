import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_chi_tieu/screens/add_screen/add_screen.dart';

import '../../models/icons.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin{
  List<Tab> myTab = <Tab>[
    const Tab(text: 'Khoản chi',),
    const Tab(text: 'Thu nhập',)
  ];
  late TabController tabController;
  @override
  void initState(){
    super.initState();
    tabController = TabController(length: myTab.length, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn danh mục",),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            TabBar(
                tabs: myTab,
              controller: tabController,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.green,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  Spending(),
                  Income()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Spending extends StatelessWidget {
  const Spending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icons = IconsApp();
    List<String> key_map1 = [];
    List<String> value_map1 = [];
    icons.icons_1.forEach((element) {
      element.keys.forEach((key) {
        key_map1.add(key);
      });
      element.values.forEach((value) {
        value_map1.add(value);
      });
    });
    return ListView.builder(
      itemCount: icons.icons_1.length,
      itemBuilder: (context, index){
        return ListTile(
          onTap: (){
            Get.off(()=>Add(keys: key_map1[index], value: value_map1[index], type: '-',));
          },
          leading: Image.network(
            value_map1[index].toString(),
            height: 37,
            width: 37,
            fit: BoxFit.cover,
          ),
          title: Text(key_map1[index]),
        );
      },
    );
  }
}

class Income extends StatelessWidget {
  const Income({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icons = IconsApp();
    List<String> key_map2 = [];
    List<String> value_map2 = [];
    icons.icons_2.forEach((element) {
      element.keys.forEach((key) {
        key_map2.add(key);
      });
      element.values.forEach((value) {
        value_map2.add(value);
      });
    });
    return ListView.builder(
      itemCount: icons.icons_2.length,
      itemBuilder: (context, index){
        return ListTile(
          onTap: (){
            Get.off(()=>Add(keys: key_map2[index], value: value_map2[index], type: '+',));
          },
          leading: Image.network(
            value_map2[index].toString(),
            height: 37,
            width: 37,
            fit: BoxFit.cover,
          ),
          title: Text(key_map2[index]),
        );
      },
    );
  }
}


