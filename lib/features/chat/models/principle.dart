class Principle {
  final List<String> tags;
  final String text;

  Principle({required this.tags, required this.text});

  factory Principle.fromJson(Map<String, dynamic> json) {
    final tagsList = List<String>.from(json['tags'] ?? []);
    final text = json['text'] ?? '';

    return Principle(tags: tagsList, text: text);
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags,
      'text': text,
    };
  }
}
