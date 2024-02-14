import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool oTurn = true;
  bool winnerFound = false;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  int attempts = 0;

  List<int> matchedindexes = [];
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];

  String resultDeclaration = '';

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle:
        const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 28),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Player O",
                            style: customFontWhite,
                          ),
                          Text(
                            oScore.toString(),
                            style: customFontWhite,
                          ),
                        ],
                      ),
                      const SizedBox(width: 55),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Player X",
                            style: customFontWhite,
                          ),
                          Text(
                            xScore.toString(),
                            style: customFontWhite,
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          tapped(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: mainColor.primaryColor,
                            ),
                            color: matchedindexes.contains(index)
                                ? mainColor.accentColor
                                : mainColor.secondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              displayXO[index],
                              style: GoogleFonts.coiny(
                                textStyle: TextStyle(
                                  fontSize: 63,
                                  color: mainColor.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        resultDeclaration,
                        style: customFontWhite,
                      ),
                      const SizedBox(height: 10),
                      buildTimer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  Widget buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
            width: 78,
            height: 78,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                  backgroundColor: mainColor.accentColor,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                )
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            onPressed: () {
              startTimer();
              resetGame();
              attempts++;
            },
            child: Text(
              attempts == 0 ? 'Start!' : 'Play Again!',
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ));
  }

  void tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
          filledBoxes++;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filledBoxes++;
        }

        oTurn = !oTurn;
        checkWinner();
      });
    }
  }

  void checkWinner() {
    //check 1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[0]} Wins!";
        matchedindexes.addAll([0, 1, 2]);
        stopTimer();
        updateScore(displayXO[0]);
      });
    }

    //check 2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[3]} Wins!";
        matchedindexes.addAll([3, 4, 5]);
        stopTimer();
        updateScore(displayXO[3]);
      });
    }

    //check 3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[6]} Wins!";
        matchedindexes.addAll([6, 7, 8]);
        stopTimer();
        updateScore(displayXO[6]);
      });
    }

    //check 1st diagonal
    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[0]} Wins!";
        matchedindexes.addAll([0, 4, 8]);
        stopTimer();
        updateScore(displayXO[0]);
      });
    }

    //check 2nd diagonal
    if (displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[2]} Wins!";
        matchedindexes.addAll([2, 4, 6]);
        stopTimer();
        updateScore(displayXO[2]);
      });
    }

    //check 1st column
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[0]} Wins!";
        matchedindexes.addAll([0, 3, 6]);
        stopTimer();
        updateScore(displayXO[0]);
      });
    }

    //check 2nd column
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[1]} Wins!";
        matchedindexes.addAll([1, 4, 7]);
        stopTimer();
        updateScore(displayXO[1]);
      });
    }

    //check 3rd column
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[2]} Wins!";
        matchedindexes.addAll([2, 5, 8]);
        stopTimer();
        updateScore(displayXO[2]);
      });
    } else if (!winnerFound && filledBoxes == 9) {
      setState(() {
        resultDeclaration = 'Nobody Wins! :(';
      });
    }
  }

  void updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void resetGame() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
      matchedindexes.clear();
    });
    filledBoxes = 0;
  }
}
