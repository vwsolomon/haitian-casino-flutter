import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const HaitianCasinoApp());
}

class HaitianCasinoApp extends StatelessWidget {
  const HaitianCasinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haitian Casino',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CasinoGame(),
    );
  }
}

class CasinoGame extends StatefulWidget {
  const CasinoGame({super.key});

  @override
  State<CasinoGame> createState() => _CasinoGameState();
}

class _CasinoGameState extends State<CasinoGame> {
  late final AudioPlayer _player;

  // Example game state
  List<String> _playerCards = [];
  List<String> _tableCards = ['A♠', 'K♣', '5♦', '7♥'];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playCaptureSound() async {
    try {
      await _player.play(UrlSource('assets/sounds/capture.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _captureCard(String card) {
    setState(() {
      _playerCards.add(card);
      _tableCards.remove(card);
    });
    _playCaptureSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haitian Casino'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Table Cards:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _tableCards.map((card) {
              return ElevatedButton(
                onPressed: () => _captureCard(card),
                child: Text(card, style: const TextStyle(fontSize: 24)),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            'Your Captured Cards:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _playerCards.map((card) {
              return Chip(
                label: Text(card, style: const TextStyle(fontSize: 18)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
