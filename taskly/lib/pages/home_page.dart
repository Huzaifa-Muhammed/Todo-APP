import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../model/tasks.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double deviceWidth;
  late double deviceHeight;
  Box? _box;

  List<Color> listColor = [
    Colors.orangeAccent.shade100,
    Colors.blueAccent.shade100,
    Colors.deepPurpleAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.redAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.pinkAccent.shade100,
    Colors.amberAccent.shade100,
    Colors.cyanAccent.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.indigoAccent.shade100,
    Colors.deepOrangeAccent.shade100,
    Colors.lightGreenAccent.shade100,
    Colors.limeAccent.shade100,
    Colors.purpleAccent.shade100,
    Colors.brown.shade200,
    Colors.grey.shade200,
    Colors.blueGrey.shade200,
  ];

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: deviceHeight * 0.15,
          title: Text(
            "Taskly",
            style: GoogleFonts.aboreto(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 15,
              shadows: [
                Shadow(
                  color: Colors.grey.shade300,
                  blurRadius: 2,
                  offset: Offset(5, 10),
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey.shade200,
        ),
        body: taskView(),
        floatingActionButton: addTaskButton(),
      ),
    );
  }

  Widget taskView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return listView();
        } else {
          return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
        }
      },
    );
  }

  Widget listView() {
    List tasks = _box!.values.toList();
    Random random = Random();

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        Color tileColor = listColor[random.nextInt(listColor.length)];
        double width = [100, 200, 300][random.nextInt(3)] as double;
        double height = [50, 100, 150][random.nextInt(3)] as double;

        return Dismissible(
          key: Key(index.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _box!.deleteAt(index);
            setState(() {});
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
            padding: EdgeInsets.all(10),
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
                SizedBox(height: 5),
                Text(
                  task.content,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
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

  Widget addTaskButton() {
    return FloatingActionButton(
      onPressed: () async {
        final newTask = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskPage()),
        );
        if (newTask != null) {
          _box!.add(newTask.toMap());
          setState(() {});
        }
      },
      child: const Icon(Icons.add, color: Colors.blueGrey),
    );
  }
}