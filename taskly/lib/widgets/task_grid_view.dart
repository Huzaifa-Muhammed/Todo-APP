import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:taskly/model/tasks.dart';

class TaskGridView extends StatelessWidget {
  final Box taskBox;
  final List<Color> listColor;

  const TaskGridView({Key? key, required this.taskBox, required this.listColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tasks = taskBox.values.toList();
    Random random = Random();

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        Color tileColor = listColor[random.nextInt(listColor.length)];
        double width = 300;
        double height = [100.0, 150.0, 200.0][random.nextInt(3)];

        return Dismissible(
          key: Key(index.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            taskBox.deleteAt(index);
          },
          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  task.content,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  "${task.timeLap.day}-${task.timeLap.month}-${task.timeLap.year}",
                  style: GoogleFonts.aBeeZee(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
