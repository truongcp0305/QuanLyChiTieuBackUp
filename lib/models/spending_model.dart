class SpendingModel{
  String id;
  String money;
  String icon;
  String category;
  String time;
  String type;
  String note;

  SpendingModel({required this.id,
    required this.money,
    required this.icon,
    required this.category,
    required this.time,
    required this.type,
    required this.note
  });

  Map<String, dynamic> toJson (){
    return
        {
          'id': id,
          'money': money,
          'icon': icon,
          'category': category,
          'time': time,
          'type': type,
          'note': note,
        };
  }
}