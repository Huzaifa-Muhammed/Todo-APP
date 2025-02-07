import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../widgets/task_grid_view.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
                  color: Colors.blueGrey.shade200,
                  blurRadius: 2,
                  offset: const Offset(5, 10),
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade300,
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
          return TaskGridView(taskBox: snapshot.data, listColor: listColor);
        } else {
          return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
        }
      },
    );
  }

  Widget addTaskButton() {
    return FloatingActionButton(
      onPressed: () async {
        final newTask = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTaskPage()),
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