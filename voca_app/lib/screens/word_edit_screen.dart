import 'package:flutter/material.dart';       // 1) Flutter UI 라이브러리
import '../models/word.dart';                  // 2) Word 모델 클래스
import '../services/api_service.dart';         // 3) ApiService 호출 로직

class WordEditScreen extends StatefulWidget {
  final Word? word;
  WordEditScreen({this.word});

  @override
  _WordEditScreenState createState() => _WordEditScreenState();
}
class _WordEditScreenState extends State<WordEditScreen> {
  final _fomKey = GlobalKey<FormState>();
  late String_term, _meaning;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _term = widget.word?.term ?? '';
    _meaning = widget.word?.meaning ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (widget.word == null) {
      await _api.addWord(Word(id: 0, term: _term, meaning: _meaning));
    } else {
      final w = widget.word!..term = _term..meaning = _meaning;
      await _api.updateWord(w);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.word == null ? '단어 추가' : '단어 수정')),
      body : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _term,
                decoration: InputDecoration(labelText: '단어'),
                validator: (v) => v!.isEmpty ? '단어를 입력하세요.' : null,
                onSaved: (v) => _term = v!,
              ),
              TextFormField(
                initialValue: _meaning,
                decoration: InputDecoration(labelText: '뜻'),
                validator: (v) => v!.isEmpty ? '뜻을 입력하세요.' : null,
                onSaved: (v) => _meaning = v!,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: Text('저장')),
            ]
          )
        )
      )
    );
  }
}