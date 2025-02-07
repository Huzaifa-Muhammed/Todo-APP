class Task {
  String title;
  String content;
  DateTime timeLap;
  bool done;

  Task({
    required this.title,
    required this.content,
    required this.timeLap,
    required this.done,
  });

  factory Task.fromMap(Map task) {
    return Task(
      title: task["title"],
      content: task["content"],
      timeLap: task["timeLap"],
      done: task["done"],
    );
  }

  Map toMap() {
    return {
      "title": title,
      "content": content,
      "timeLap": timeLap,
      "done": done,
    };
  }
}