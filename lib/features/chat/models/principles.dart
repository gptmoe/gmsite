import 'package:gptmoe/features/chat/models/principle.dart';

class Principles {
  List<Principle> list;

  Principles({required this.list});

  factory Principles.fromJson(Map<String, dynamic> json) {
    return Principles(
      list: List<Principle>.from(
        json['principles'].map((x) => Principle.fromJson(x)),
      ),
    );
  }
}
