import 'package:flutter/material.dart'; // Flutter 기본 UI 라이브러리
import '../models/word.dart'; // Word 모델 클래스
import '../services/api_service.dart'; // API 호출 로직
import '../widgets/word_item.dart'; // 재사용 위젯
import 'word_edit_screen.dart'; // 단어 추가/수정 화면

/// 단어 목록 화면을 StatefulWidget으로 정의
class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  // ApiService 인스턴스 생성: 네트워크 호출에 사용
  final ApiService _api = ApiService();
  // Future로 반환될 단어 목록 데이터를 저장
  late Future<List<Word>> _futureWords;

  @override
  void initState() {
    super.initState();
    _refreshList(); // 화면 최초 로드시 단어 목록 호출
  }

  // 단어 목록을 가져오는 메서드: fetchWords 호출 결과를 _futureWords에 할당
  void _refreshList() {
    _futureWords = _api.fetchWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('단어장'), // AppBar 제목
      ),
      body: FutureBuilder<List<Word>>(
        future: _futureWords, // 기다릴 Future 지정
        builder: (context, snapshot) {
          // 로딩 중일 때
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          // 에러 발생 시
          if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          }
          // 데이터가 정상적으로 도착했을 때
          final words = snapshot.data ?? [];
          return ListView.builder(
            itemCount: words.length, // 리스트 길이
            itemBuilder: (context, index) {
              final word = words[index];
              return WordItem(
                word: word,
                // 수정 버튼 클릭 시
                onEdit: (w) async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WordEditScreen(word: w),
                    ),
                  );
                  setState(_refreshList); // 목록 갱신
                },
                // 삭제 버튼 클릭 시
                onDelete: (w) async {
                  await _api.deleteWord(w.id);
                  setState(_refreshList);
                },
                // 즐겨찾기 토글 클릭 시
                onToggleFav: (w) async {
                  await _api.toggleFavorite(w);
                  setState(_refreshList);
                },
              );
            },
          );
        },
      ),
      // 단어 추가를 위한 FloatingActionButton
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WordEditScreen()),
          );
          setState(_refreshList);
        },
      ),
    );
  }
}

