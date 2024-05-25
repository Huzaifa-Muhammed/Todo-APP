import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:taskly/models/tasks.dart';

class HomePage extends StatefulWidget{
  HomePage();
  @override
  State<StatefulWidget> createState()=>_HomePageState();

}
class _HomePageState extends State<HomePage>{

  late double deviceWidth;
  late double deviceHeight;

  String? newTaskContent;
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

  _HomePageState();
  @override
  Widget build(BuildContext context) {
    deviceHeight=MediaQuery.of(context).size.height;
    deviceWidth=MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: deviceHeight*0.15,
          title: Text("Taskly",style: GoogleFonts.aboreto(fontSize: 30,fontWeight: FontWeight.bold,letterSpacing: 15,shadows: [Shadow(color: Colors.grey.shade300, blurRadius: 2, offset: Offset(5, 10),),],),),
          centerTitle: true,
          backgroundColor: Colors.grey.shade200,
        ),
        body:taskView(),
        floatingActionButton: addTaskButton(),
      ),
    );
  }

  Widget taskView(){
    return FutureBuilder(future: Hive.openBox('tasks'), builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
        _box=snapshot.data;
        return listView();
      }else{
        return const Center(child:CircularProgressIndicator(color: Colors.cyanAccent,));
      }
    });
  }


  Widget listView() {
    List tasks = _box!.values.toList();
    List<Color> tileColors = List.generate(tasks.length, (index) => listColor[index % listColor.length]);
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return Dismissible(
          key: Key(index.toString()), // Use the index as a unique key
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _box!.deleteAt(index); // Use deleteAt() instead of delete()
            setState(() {
              tasks.removeAt(index);
              tileColors.removeAt(index);
            });
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Text("Task ${index + 1}",
                style: GoogleFonts.aBeeZee(decoration: task.done ? TextDecoration.lineThrough : null, decorationColor: Colors.red),
              ),
              title: Text(
                task.content.toString(),
                style: GoogleFonts.aBeeZee(
                  decoration: task.done ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.red,
                ),
              ),
              subtitle: Text("${task.timeLap.day}-${task.timeLap.month}-${task.timeLap.year}      ${task.timeLap.hour}:${task.timeLap.minute}:${task.timeLap.second}"),
              trailing: Icon(
                task.done ? Icons.check_box_rounded : Icons.check_box_outline_blank,
                color: Colors.black,
              ),
              tileColor: tileColors[index],
              onTap: () {
                task.done = !task.done;
                _box!.putAt(index, task.toMap());
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }



  Widget addTaskButton(){
    return FloatingActionButton(
      onPressed: displayTaskPopUp,
      child:const Icon(Icons.add,color: Colors.blueGrey,),
    );
  }


  void displayTaskPopUp(){
    showDialog(context: context, builder: (BuildContext _context){
      return AlertDialog(
        title: const Text("Add Task"),
        content: TextField(
          onSubmitted: (_){
            if(newTaskContent!=null){
              var _task=Task(content: newTaskContent!, timeLap: DateTime.now(), done: false);
              _box!.add(_task.toMap());
            }
            setState(() {
              newTaskContent=null;
              Navigator.pop(context);
            });
          },
          onChanged: (value){
            setState(() {
              newTaskContent=value;
            });
          },
        ),
      );
    });
  }


}