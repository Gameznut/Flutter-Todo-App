import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.red,
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
  List<String>? todos = [];

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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
                  itemCount: todos?.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 6),
                        margin: index == 0
                            ? const EdgeInsets.only(
                                top: 30, left: 3, right: 3, bottom: 10)
                            : const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 3),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
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
                                todos![index].toString(),
                                style: const TextStyle(fontSize: 25),
                              ),
                            ),
                            Flexible(
                                child: MaterialButton(
                              splashColor: Colors.pink,
                              color: Colors.transparent,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: SizedBox(
                                            height: 100,
                                            child: Column(

                                              children: [
                                                Text(
                                                  todos![index],
                                                  style: const TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
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
                                delete(index);
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

  Future<void> get() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todos = (prefs.getStringList("todos"))!;
    });
  }

  Future<void> delete(index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todos?.removeAt(index);
      prefs.setStringList("todos", <String>[...?todos]);
      todos = (prefs.getStringList("todos"))!;
    });
  }

  Future<void> add(currentFocus) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      data = _todoController.text;
      _todoController.text.isEmpty ? "null" : todos!.add(data);
      prefs.setStringList("todos", <String>[...?todos]);
    });

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _todoController.text = "";
  }
}
