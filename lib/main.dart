import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _views = [
    PresentationView(),
    MessagesAndCallsView(),
    StatefulExampleView(),
    HttpRequestView(),  // Aquí está la vista que utiliza http
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Presentation'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages & Calls'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Stateful'),
          BottomNavigationBarItem(icon: Icon(Icons.http), label: 'HTTP'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PresentationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('https://via.placeholder.com/150'), // Placeholder image
          DataTable(
            columns: [
              DataColumn(label: Text('Matrícula')),
              DataColumn(label: Text('Nombre')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('213691')),
                DataCell(Text('Ulises Gálvez Miranda')),
              ]),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Open Project 1 repository
            },
            child: Text('Proyecto 1'),
          ),
          ElevatedButton(
            onPressed: () {
              // Open Project 2 repository
            },
            child: Text('Proyecto 2'),
          ),
        ],
      ),
    );
  }
}

class MessagesAndCallsView extends StatelessWidget {
  final String phoneNumber = '951 527 1070';
  final String name = 'José Ángel Ortega Merlín';

  void _makePhoneCall(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'No se pudo hacer la llamada a $number';
    }
  }

  void _sendMessage(BuildContext context, String number) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enviar Mensaje'),
          content: TextField(
            controller: messageController,
            decoration: InputDecoration(hintText: 'Escribe tu mensaje'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final Uri smsUri = Uri(
                  scheme: 'sms',
                  path: number,
                  queryParameters: {
                    'body': messageController.text,
                  },
                );
                if (await canLaunchUrl(smsUri)) {
                  await launchUrl(smsUri);
                }
                Navigator.of(context).pop();
              },
              child: Text('Enviar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DataTable(
        columns: [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Número')),
          DataColumn(label: Text('Send Message')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text(name)),
            DataCell(GestureDetector(
              onTap: () => _makePhoneCall(phoneNumber),
              child: Text(
                phoneNumber,
                style: TextStyle(color: Colors.blue),
              ),
            )),
            DataCell(IconButton(
              icon: Icon(Icons.message),
              onPressed: () => _sendMessage(context, phoneNumber),
            )),
          ]),
        ],
      ),
    );
  }
}

class StatefulExampleView extends StatefulWidget {
  @override
  _StatefulExampleViewState createState() => _StatefulExampleViewState();
}

class _StatefulExampleViewState extends State<StatefulExampleView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You have pressed the button this many times:'),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium, // Reemplazar headline4 con headlineMedium
          ),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: Text('Increment Counter'),
          ),
        ],
      ),
    );
  }
}

class HttpRequestView extends StatefulWidget {
  @override
  _HttpRequestViewState createState() => _HttpRequestViewState();
}

class _HttpRequestViewState extends State<HttpRequestView> {
  bool _loading = false;
  String _response = '';

  Future<void> _makeGetRequest() async {
    setState(() {
      _loading = true;
    });

    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));

    setState(() {
      _loading = false;
      _response = jsonDecode(response.body).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _makeGetRequest,
            child: Text('Make GET Request'),
          ),
          _loading ? CircularProgressIndicator() : Text(_response),
        ],
      ),
    );
  }
}

