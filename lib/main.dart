import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Todo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _todoController = TextEditingController();

  String data = "";
  final todos = [];

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              // height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                        controller: _todoController,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                            hintText: 'What do you want to do',
                            suffixIcon: InkWell(
                                onTap: () {
                                  _todoController.clear();
                                },
                                splashColor: Colors.red[300],
                                child: const Icon(Icons.clear)),
                            border: const OutlineInputBorder())),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: MaterialButton(
                        splashColor: Colors.blue,
                        color: Colors.amber,
                        onPressed: () => add(currentFocus),
                        child: const Icon(Icons.add),
                      ))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: index == 0
                            ? const EdgeInsets.only(
                                top: 10, left: 3, right: 3, bottom: 10)
                            : const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 3),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              // BoxShadow(
                              //     color: Colors.grey.shade400,
                              //     offset: const Offset(-3, -3),
                              //     blurRadius: 10.4,
                              //     spreadRadius: 1.0),
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(0, 3),
                                  blurRadius: 10.4,
                                  spreadRadius: 1.0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                todos[index].toString(),
                                style: const TextStyle(fontSize: 25),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 15,
                            // ),
                            Flexible(
                                child: MaterialButton(
                              splashColor: Colors.red,
                              color: Colors.transparent,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: SizedBox(
                                            height: 300,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    todos[index],
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                    ),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Close"))
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              child: const Icon(Icons.edit),
                            )),
                            Flexible(
                                child: MaterialButton(
                              splashColor: Colors.red,
                              color: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  todos.removeAt(index);
                                });
                              },
                              child: const Icon(Icons.delete),
                            )),
                          ],
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }

  void add(currentFocus) {
    setState(() {
      data = _todoController.text;
      _todoController.text.isEmpty ? null : todos.add(data);
    });

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _todoController.text = "";
  }

// Future  openEditDialog() => showDialog(context: context, builder:         Dialog(
//     shape: RoundedRectangleBorder(
//     borderRadius:BorderRadius.circular(30.0)),
// child: Container(
// height: 300,
// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// FlutterLogo(size: 150,),
// Text("This is a Custom Dialog",style:TextStyle(fontSize: 20),),
// ElevatedButton(
//
// onPressed: (){
// Navigator.of(context).pop();
// }, child: Text("Close"))
// ],
// ))
}
