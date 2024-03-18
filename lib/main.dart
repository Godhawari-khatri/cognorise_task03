import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  bool _playerXTurn = true; // Player X starts the game

  void _placeSymbol(int row, int col) {
    if (_board[row][col].isEmpty) {
      setState(() {
        _board[row][col] = _playerXTurn ? 'X' : 'O';
        _playerXTurn = !_playerXTurn; // Switch turns
      });
    }
  }

  void _resetGame() {
    setState(() {
      _board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', ''],
      ];
      _playerXTurn = true; // Player X starts the game
    });
  }

  String _checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] && _board[i][1] == _board[i][2] && _board[i][0].isNotEmpty) {
        return _board[i][0];
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_board[0][i] == _board[1][i] && _board[1][i] == _board[2][i] && _board[0][i].isNotEmpty) {
        return _board[0][i];
      }
    }

    // Check diagonals
    if (_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2] && _board[0][0].isNotEmpty) {
      return _board[0][0];
    }
    if (_board[0][2] == _board[1][1] && _board[1][1] == _board[2][0] && _board[0][2].isNotEmpty) {
      return _board[0][2];
    }

    // Check for a draw
    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j].isEmpty) {
          isDraw = false;
          break;
        }
      }
    }
    if (isDraw) {
      return 'Draw';
    }

    // No winner yet
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      backgroundColor: Colors.black, // Background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Player: ${_playerXTurn ? 'X' : 'O'}',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white), // Text color
          ),
          SizedBox(height: 20.0),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1.0, // Adjust the aspect ratio
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              int row = index ~/ 3;
              int col = index % 3;
              return GestureDetector(
                onTap: () {
                  _placeSymbol(row, col);
                  String winner = _checkWinner();
                  if (winner.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Game Over'),
                        content: Text(winner == 'Draw' ? 'It\'s a draw!' : 'Player $winner wins!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _resetGame();
                            },
                            child: Text('Play Again'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Card(
                  color: Colors.blue[100], // Grid color
                  elevation: 4.0,
                  child: Center(
                    child: Text(
                      _board[row][col],
                      style: TextStyle(fontSize: 48.0, color: _board[row][col] == 'X' ? Colors.red : Colors.blue), // Set symbol color
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Reset Game'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, // Button color
              onPrimary: Colors.white, // Text color
            ),
          ),
        ],
      ),
    );
  }
}
