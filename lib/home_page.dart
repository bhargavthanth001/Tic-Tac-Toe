import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:gap/gap.dart';
import 'package:status_alert/status_alert.dart';
import 'package:neon/neon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isVisible = true;
  List<List<String>> gameGrid = [];
  String currentPlayer = '';

  container(String player, MaterialColor color) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
        ),
      ),
      child: Center(
        child: Text(
          player,
          style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.5
                ..color = color,
              shadows: [
                Shadow(
                  color: color,
                  blurRadius: 40,
                  offset: const Offset(0, 0),
                ),
              ]),
        ),
      ),
    );
  }

  startGame() {
    gameGrid = List.generate(3, (_) => List.filled(3, ''));
    debugPrint(gameGrid.toString());
    currentPlayer = "O";
    setState(() {});
  }

  @override
  void initState() {
    startGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6527BE),
                ),
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: -15.0,
                  blurRadius: 20.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Neon(
                  text: "Tic Tac Toe",
                  color: ,

                ),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    container("O", Colors.red),
                    const Gap(25),
                    const Text(
                      "v/s",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(25),
                    container(
                      "X",
                      Colors.green,
                    ),
                  ],
                ),
                const Gap(
                  50,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final row = index ~/ 3;
                      final colum = index % 3;
                      return GestureDetector(
                        onTap: () {
                          _sound();
                          debugPrint("Row = $row Column = $colum");
                          if (gameGrid[row][colum].isEmpty) {
                            onCellTap(row, colum);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white38,
                            ),
                          ),
                          child: Center(
                            child: Stack(children: [
                              Text(
                                gameGrid[row][colum],
                                style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 4
                                      ..color = gameGrid[row][colum] == 'O'
                                          ? Colors.red
                                          : Colors.green,
                                    shadows: [
                                      Shadow(
                                        color: gameGrid[row][colum] == 'O'
                                            ? Colors.red
                                            : Colors.green,
                                        blurRadius: 40,
                                        offset: const Offset(0, 0),
                                      )
                                    ]),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Gap(20),
                MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  onPressed: () {
                    startGame();
                  },
                  child: const Row(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text("Restart"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onCellTap(int row, int colum) {
    debugPrint("current player is :- $currentPlayer");
    setState(() {
      gameGrid[row][colum] = currentPlayer;
      debugPrint(gameGrid[row][colum]);
      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    });
    String winner = checkWinner();
    if (winner.isNotEmpty) {
      dialog("$winner is Winner !!!");
      startGame();
    }
    if (isDraw()) {
      dialog("Match Draw");
      startGame();
    }
  }

  checkWinner() {
    for (int row = 0; row < 3; row++) {
      if (gameGrid[row][0] == gameGrid[row][1] &&
          gameGrid[row][1] == gameGrid[row][2] &&
          gameGrid[row][0] != '') {
        return gameGrid[row][0];
      }
    }

    for (int col = 0; col < 3; col++) {
      if (gameGrid[0][col] == gameGrid[1][col] &&
          gameGrid[1][col] == gameGrid[2][col] &&
          gameGrid[0][col] != '') {
        return gameGrid[0][col];
      }
    }

    if (gameGrid[0][0] == gameGrid[1][1] &&
        gameGrid[1][1] == gameGrid[2][2] &&
        gameGrid[0][0] != '') {
      return gameGrid[0][0];
    }
    if (gameGrid[0][2] == gameGrid[1][1] &&
        gameGrid[1][1] == gameGrid[2][0] &&
        gameGrid[0][2] != '') {
      return gameGrid[0][2];
    }

    return "";
  }

  bool isDraw() {
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (gameGrid[row][col] == '') {
          return false;
        }
      }
    }
    return true;
  }

  Color contentColor(String winner) {
    return winner == "Match Draw"
        ? Colors.black
        : winner == "O is Winner !!!"
            ? Colors.red
            : Colors.green;
  }

  dialog(String winner) {
    StatusAlert.show(
      context,
      duration: const Duration(seconds: 3),
      title: 'Game Over !',
      subtitle: winner,
      dismissOnBackgroundTap: true,
      subtitleOptions: StatusAlertTextConfiguration(
          style: TextStyle(
        fontSize: 20,
        color: contentColor(winner),
        fontWeight: FontWeight.bold,
      )),
      titleOptions: StatusAlertTextConfiguration(
          style: TextStyle(
        fontSize: 30,
        color: contentColor(winner),
        fontWeight: FontWeight.bold,
      )),
      backgroundColor: Colors.white,
      configuration: IconConfiguration(
        icon: Icons.emoji_emotions_outlined,
        color: contentColor(winner),
      ),
      maxWidth: 260,
    );
  }

  _sound() {
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/sound/play_sound.mp3"),
      autoStart: true,
      showNotification: false,
    );
  }
}
