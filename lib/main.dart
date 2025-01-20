import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Layout',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 223, 9, 198)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Jogo da Velha'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> board = List.filled(9, ""); // Representa o tabuleiro
  String currentPlayer = "X"; // Jogador atual
  bool _contraMaquina = false; // Define se o jogo é contra a máquina

  void _onTileTapped(int index) {
    setState(() {
      if (board[index].isEmpty) {
        board[index] = currentPlayer;
        if (!_checkWinner()) {
          currentPlayer = currentPlayer == "X" ? "O" : "X"; // Alterna jogador

          if (_contraMaquina && currentPlayer == "O") {
            _playAsMachine();
          }
        }
      }
    });
  }

  void _playAsMachine() {
    final emptyIndexes = List.generate(board.length, (i) => i).where((i) => board[i].isEmpty).toList();
    if (emptyIndexes.isNotEmpty) {
      final randomIndex = (emptyIndexes..shuffle()).first;
      board[randomIndex] = "O";
      _checkWinner();
      currentPlayer = "X";
    }
  }

  bool _checkWinner() {
    const winningPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6],           // Diagonais
    ];

    for (var positions in winningPositions) {
      if (board[positions[0]] == board[positions[1]] &&
          board[positions[1]] == board[positions[2]] &&
          board[positions[0]].isNotEmpty) {
        _showWinnerDialog(board[positions[0]]);
        return true;
      }
    }

    if (!board.contains("")) {
      _showWinnerDialog("Empate");
      return true;
    }

    return false;
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(winner == "Empate" ? "Empate!" : "Vitória!"),
        content: Text(winner == "Empate"
            ? "O jogo terminou em empate."
            : "O jogador $winner venceu!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                board = List.filled(9, "");
                currentPlayer = "X";
              });
            },
            child: const Text("Jogar Novamente"),
          ),
        ],
      ),
    );
  }

  Widget buildTile(int index) {
    return GestureDetector(
      onTap: () => _onTileTapped(index),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Text(
          board[index],
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _contraMaquina,
                    onChanged: (value) {
                      setState(() {
                        _contraMaquina = value;
                        board = List.filled(9, "");
                        currentPlayer = "X";
                      });
                    },
                  ),
                ),
                Text(
                  _contraMaquina ? 'Computador' : 'Humano',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            Text(
              "Vez do jogador: $currentPlayer",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 223, 9, 198),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return buildTile(index);
                        },
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            board = List.filled(9, ""); // Reinicia o tabuleiro
            currentPlayer = "X"; // Reinicia o jogador
          });
        },
        tooltip: 'Reiniciar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
