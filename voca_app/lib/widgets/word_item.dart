import 'package:flutter/material.dart';
import '../models/word.dart';

/// 단어 리스트 항목 위젯
class WordItem extends StatelessWidget {
  final Word word;
  /// 편집 콜백
  final Future<void> Function(Word) onEdit;
  /// 삭제 콜백
  final Future<void> Function(Word) onDelete;
  /// 즐겨찾기 토글 콜백
  final Future<void> Function(Word) onToggleFav;

  const WordItem({
    Key? key,
    required this.word,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word.term),
      subtitle: Text(word.meaning),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              word.favorite ? Icons.star : Icons.star_border,
              color: word.favorite ? Colors.amber : null,
            ),
            onPressed: () => onToggleFav(word),
            tooltip: word.favorite ? '즐겨찾기 해제' : '즐겨찾기',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(word),
            tooltip: '수정',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(word),
            tooltip: '삭제',
          ),
        ],
      ),
    );
  }
}