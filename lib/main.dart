import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'
    show WordPair, generateWordPairs;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starup Name generator',
      home: const RandomWords(),
      theme: ThemeData(
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black))),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // 覆写这个方法，渲染
    return RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _sugguestion = <WordPair>[];
  final _saved = <WordPair>{}; // 已添加喜爱
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    _sugguestion.addAll(generateWordPairs().take(10));
    return ListView.builder(
      // 内置列表视图
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return const Divider(); // 奇数底下加一条线
        final index = i ~/ 2; // 除2后向下取整
        if (index >= _sugguestion.length) {
          // ListView如果不配置itemCount, itemBuilder并不会根据你的数据数进行生成行数，而且一直向下生成
          // 如果行数除2后超出已经存放的内容，则再生成10个
          _sugguestion.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_sugguestion[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 覆写build方法，生成状态逻辑
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list))
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) =>
          ListTile(title: Text(pair.asPascalCase, style: _biggerFont)));
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Sugguestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
