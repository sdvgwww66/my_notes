import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мои заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ========== ГЛАВНЫЙ ЭКРАН ==========
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _notes = []; // id, text, date
  Color _backgroundColor = Colors.white;
  Color _buttonColor = Colors.blue;
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    // Добавляем пример заметки для демонстрации
    _notes.add({
      'id': 1,
      'text': 'Пример заметки',
      'date': DateTime.now(),
    });
    _nextId = 2;
  }

  // Функция 1: Вывод текста в консоль
  void _printInputText() {
    print("📝 Текст из поля ввода: ${_textController.text}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Printed to console: ${_textController.text}")),
    );
  }

  // Функция 2: Изменение цвета кнопки и фона
  void _changeColors() {
    setState(() {
      _backgroundColor = _backgroundColor == Colors.white ? Colors.grey[200]! : Colors.white;
      _buttonColor = _buttonColor == Colors.blue ? Colors.green : Colors.blue;
    });
    print("🎨 Цвета изменены: фон=${_backgroundColor == Colors.white ? 'белый' : 'серый'}, кнопка=${_buttonColor == Colors.blue ? 'синяя' : 'зелёная'}");
  }

  // Добавление заметки
  void _addNote() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Введите текст заметки")),
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
    print("✅ Добавлена новая заметка");
  }

  // Функция 5: Удаление заметки с AlertDialog
  void _deleteNote(int index, int id, String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("🗑️ Удаление заметки"),
        content: Text("Вы уверены, что хотите удалить:\n\"$text\"?"),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Отмена", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(index);
              });
              Navigator.pop(ctx);
              print("❌ Удалена заметка ID: $id");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Заметка удалена")),
              );
            },
            child: Text("Удалить", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Форматирование даты
  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("Мои заметки", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: _changeColors,
            tooltip: "Сменить цвета",
          ),
        ],
      ),
      body: Column(
        children: [
          // Панель ввода
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Введите заметку...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Кнопка Print
                ElevatedButton(
                  onPressed: _printInputText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Print", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 8),
                // Кнопка Add
                ElevatedButton(
                  onPressed: _addNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Add", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Список заметок
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Нет заметок",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          "Добавьте первую заметку выше",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (ctx, index) {
                      final note = _notes[index];
                      return Card(
                        color: Colors.yellow[100],
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              "${note['id']}",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            note['text'],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "📅 ${_formatDate(note['date'])}",
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(index, note['id'], note['text']),
                          ),
                          // Функция 4: Переход на второй экран с передачей ID
                          onTap: () {
                            print("🔍 Переход на детальный экран с ID: ${note['id']}");
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

// ========== ВТОРОЙ ЭКРАН (ДЕТАЛИ ЗАМЕТКИ) ==========
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
    // Функция 4: Вывод в консоль ID заметки, который пришёл с первого экрана
    print("=" * 40);
    print("📱 ЭКРАН ДЕТАЛЕЙ ЗАМЕТКИ");
    print("📌 Получен ID заметки: $noteId");
    print("📌 Текст заметки: $noteText");
    print("=" * 40);

    return Scaffold(
      appBar: AppBar(
        title: Text("Детали заметки"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Блок с ID заметки
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.tag, color: Colors.blue, size: 28),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID ЗАМЕТКИ",
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                      Text(
                        "$noteId",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Содержание заметки
            Text(
              "📝 СОДЕРЖАНИЕ:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                noteText,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            SizedBox(height: 24),
            // Дата создания
            Text(
              "🕐 ДАТА СОЗДАНИЯ:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(noteDate, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}