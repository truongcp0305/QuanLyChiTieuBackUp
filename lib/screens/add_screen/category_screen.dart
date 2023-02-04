import 'package:flutter/material.dart';

import '../../models/icons.dart';

class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn danh mục'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: icons.icons_1.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                  },
                  child: ListTile(
                    leading: Image.network(
                        value_map1[index].toString(),
                      height: 37,
                      width: 37,
                      fit: BoxFit.cover,
                    ),
                    title: Text(key_map1[index]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
