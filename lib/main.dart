import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мои заметки',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _notes = [];
  Color _backgroundColor = Colors.white;
  Color _buttonColor = Colors.blue;
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    // Добавляем пример заметки
    _notes.add({
      'id': _nextId,
      'text': 'Пример заметки',
      'date': DateTime.now(),
    });
    _nextId++;
  }

  void _printInputText() {
    print("Текст из поля ввода: ${_textController.text}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Printed: ${_textController.text}")),
    );
  }

  void _changeColors() {
    setState(() {
      _backgroundColor = _backgroundColor == Colors.white ? Colors.grey[200]! : Colors.white;
      _buttonColor = _buttonColor == Colors.blue ? Colors.green : Colors.blue;
    });
  }

  void _addNote() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Введите текст")),
      );
      return;
    }
    setState(() {
      _notes.add({
        'id': _nextId,
        'text': _textController.text.trim(),
        'date': DateTime.now(),
      });
      _nextId++;
      _textController.clear();
    });
  }

  void _deleteNote(int index, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Удаление"),
        content: Text("Вы уверены?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Отмена"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(index);
              });
              Navigator.pop(ctx);
              print("Удалена заметка ID: $id");
            },
            child: Text("Удалить", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("Мои заметки"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: _changeColors,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Введите заметку...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _printInputText,
                  style: ElevatedButton.styleFrom(backgroundColor: _buttonColor),
                  child: Text("Print"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addNote,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                final note = _notes[index];
                return Card(
                  color: Colors.yellow[100],
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(note['text']),
                    subtitle: Text("${_formatDate(note['date'])}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(index, note['id']),
                    ),
                    onTap: () {
                      print("Переход к заметке ID: ${note['id']}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            noteId: note['id'],
                            noteText: note['text'],
                            noteDate: _formatDate(note['date']),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final int noteId;
  final String noteText;
  final String noteDate;

  const DetailScreen({
    Key? key,
    required this.noteId,
    required this.noteText,
    required this.noteDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Получен ID заметки: $noteId");
    return Scaffold(
      appBar: AppBar(
        title: Text("Детали заметки"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("ID заметки: $noteId"),
            ),
            SizedBox(height: 20),
            Text("Содержание:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(noteText, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Дата создания:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(noteDate),
          ],
        ),
      ),
    );
  }
}