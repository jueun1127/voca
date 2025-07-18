// json 인코딩,디코딩을 위해 필요
import 'dart:convert' ;
// get(), post(), put(), delete() 같은 메서드를 제공
import 'package:http/http.dart' as http;
//정의한 word 모델을 가져옴
import '../models/word.dart';

class ApiService {
  static const String_baseUrl = 'http://10.0.2.2:3000';

  Future<List<Word>> fetchWords() async {
    final uri = Uri.parse('$_baseUrl/words');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => Word.fromJson(e)).toList();
    } else {
      throw Exception('단어 목록 조회 실패 : ${response.statusCode}');
    }
  }

//단어 추가
  Future<Word> addWord(Word word) async {
    final uri = Uri.parse('$_baseUrl/words');
    final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(word.toJson())
    );
    if (response.statusCode == 201) {
      return Word.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('단어 추가 실패: ${response.statusCode}');
    }
  }

  //단어 수정 -put 메서드 사용
  Future<Word> updateWord(Word word) async {
    final uri = Uri.parse('$_baseUrl/words/${word.id}');
    final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(word.toJson())
    );
    if (response.statusCode == 201) {
      return Word.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('단어 수정 실패: ${response.statusCode}');
    }
  }

//단어 삭제 - delete 메서드 사용
  Future<Word> deleteWord(int id) async {
    final uri = Uri.parse('$_baseUrl/words/$id');
    final response = await http.delete(uri);

    if (response.statusCode == 201) {
      return Word.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('단어 삭제 실패: ${response.statusCode}');
    }
  }

//즐겨찾기 설정
  Future<Word> toggleFavorite(Word word) async {
    word.favorite = !word.favorite;
    return updateWord(word);
  }
}