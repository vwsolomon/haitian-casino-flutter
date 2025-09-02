import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(HaitianCasinoApp());

class HaitianCasinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haitian Casino',
      theme: ThemeData.dark(),
      home: CasinoGame(),
    );
  }
}

class CasinoGame extends StatefulWidget {
  @override
  _CasinoGameState createState() => _CasinoGameState();
}

class _CasinoGameState extends State<CasinoGame> with SingleTickerProviderStateMixin {
  List<String> deck = [];
  List<String> tableCards = [];
  List<String> playerCards = [];
  List<String> opponentCards = [];
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeDeck();
    _dealCards();
  }

  void _initializeDeck() {
    List<String> suits = ['C', 'D', 'H', 'S'];
    List<String> ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
    deck = [for (var s in suits) for (var r in ranks) '$r$s'];
    deck.shuffle(Random());
  }

  void _dealCards() {
    tableCards = deck.sublist(0, 4);
    playerCards = deck.sublist(4, 8);
    opponentCards = deck.sublist(8, 12);
    setState(() {});
  }

  Future<void> _playCaptureSound() async {
    await _player.play(AssetSource('sounds/capture.mp3'));
  }

  Widget _buildCard(String card) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade700,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Text(
        card,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCardRow(String label, List<String> cards) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 20)),
        SizedBox(height: 8),
        Wrap(children: cards.map(_buildCard).toList()),
      ],
    );
  }

  void _restartGame() {
    _initializeDeck();
    _dealCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        title: Text('Haitian Casino'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _restartGame,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCardRow('Opponent', opponentCards),
            _buildCardRow('Table', tableCards),
            _buildCardRow('You', playerCards),
            ElevatedButton(
              onPressed: () {
                _playCaptureSound();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Capture simulated!')),
                );
              },
              child: Text('Simulate Capture'),
            )
          ],
        ),
      ),
    );
  }
}
