// ignore_for_file: file_names, non_constant_identifier_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chess_game/Components/isInBoard.dart';
import 'package:chess_game/Widgets/PieceType.dart';
import 'package:chess_game/Widgets/board.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'Components/iswhite.dart';
import 'Widgets/deadpiece.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  late List<List<Piece?>> board;
  Piece? selectedpiece;
  int selectedrow = -1, selectedcol = -1;
  List<List<int>> ValidMoves = [];
  List<Piece> whitedead = [];
  List<Piece> blackdead = [];
  bool iswhiteTurn = true;
  List<int> whitekingpos = [7, 4];
  List<int> blackkingpos = [0, 4];
  bool check = false;
  bool? kingwhitecheck;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  //initialize the board with every position with piece
  void _initialize() {
    //declare the new board initially its empty/null
    List<List<Piece?>> newboard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //pawn we have at row 1 and 6
    for (int i = 0; i < 8; i++) {
      newboard[1][i] = Piece(
          piecetype: chesspiecetype.pawn,
          isWhite: false,
          imgpath: 'lib/Images/pawn.png');
      newboard[6][i] = Piece(
          piecetype: chesspiecetype.pawn,
          isWhite: true,
          imgpath: 'lib/Images/pawn.png');
    }
    //rook  we have to declare at each corner
    newboard[0][0] = Piece(
        piecetype: chesspiecetype.rook,
        isWhite: false,
        imgpath: "lib/Images/rook.png");
    newboard[0][7] = Piece(
        piecetype: chesspiecetype.rook,
        isWhite: false,
        imgpath: "lib/Images/rook.png");
    newboard[7][0] = Piece(
        piecetype: chesspiecetype.rook,
        isWhite: true,
        imgpath: "lib/Images/rook.png");
    newboard[7][7] = Piece(
        piecetype: chesspiecetype.rook,
        isWhite: true,
        imgpath: "lib/Images/rook.png");

    //knight  we have put on the second last position from every side
    newboard[0][1] = Piece(
        piecetype: chesspiecetype.knight,
        isWhite: false,
        imgpath: "lib/Images/knight.png");
    newboard[0][6] = Piece(
        piecetype: chesspiecetype.knight,
        isWhite: false,
        imgpath: "lib/Images/knight.png");
    newboard[7][1] = Piece(
        piecetype: chesspiecetype.knight,
        isWhite: true,
        imgpath: "lib/Images/knight.png");
    newboard[7][6] = Piece(
        piecetype: chesspiecetype.knight,
        isWhite: true,
        imgpath: "lib/Images/knight.png");

    //bishop we have place at athe third last position
    newboard[0][2] = Piece(
        piecetype: chesspiecetype.bishop,
        isWhite: false,
        imgpath: "lib/Images/bishop.png");
    newboard[0][5] = Piece(
        piecetype: chesspiecetype.bishop,
        isWhite: false,
        imgpath: "lib/Images/bishop.png");
    newboard[7][2] = Piece(
        piecetype: chesspiecetype.bishop,
        isWhite: true,
        imgpath: "lib/Images/bishop.png");
    newboard[7][5] = Piece(
        piecetype: chesspiecetype.bishop,
        isWhite: true,
        imgpath: "lib/Images/bishop.png");

    //queen at 3 and 4 th palce black and white accordingly
    newboard[0][3] = Piece(
        piecetype: chesspiecetype.queen,
        isWhite: false,
        imgpath: "lib/Images/queen.png");
    newboard[7][3] = Piece(
        piecetype: chesspiecetype.queen,
        isWhite: true,
        imgpath: "lib/Images/queen.png");

    //king is placed to beside to queen
    newboard[0][4] = Piece(
        piecetype: chesspiecetype.king,
        isWhite: false,
        imgpath: "lib/Images/king.png");
    newboard[7][4] = Piece(
        piecetype: chesspiecetype.king,
        isWhite: true,
        imgpath: "lib/Images/king.png");

    board = newboard;
  }

// selected function that gives the value of the row and col
  void pieceselect(int row, int col) {
    setState(() {
      if (board[row][col] != null) {
        if (board[row][col]!.isWhite == iswhiteTurn) {
          selectedpiece = board[row][col];
          selectedrow = row;
          selectedcol = col;
          ValidMoves = realmoves(row, col, selectedpiece, true);
        }
      }
      if (selectedpiece != null &&
          ValidMoves.any((element) => row == element[0] && col == element[1])) {
        movepiece(row, col);
      }
    });
  }

//Move the Piece
  void movepiece(int row, int col) {
    if (board[row][col] != null) {
      if (board[row][col]!.isWhite) {
        whitedead.add(board[row][col]!);
      } else {
        blackdead.add(board[row][col]!);
      }
    }
    board[row][col] = selectedpiece;
    board[selectedrow][selectedcol] = null;
    if (kingCheck(!iswhiteTurn)) {
      check = true;
      kingwhitecheck = !iswhiteTurn;
    } else {
      check = false;
    }
    String winner = !kingwhitecheck! ? "White" : "Black";
    if (checkmatefunc(!iswhiteTurn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Column(children: [
                  const Text(
                    "CHECKMATE",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  AnimatedTextKit(animatedTexts: [
                    TyperAnimatedText(
                      "$winner wins the Game",
                      textStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ])
                ]),
                actions: [
                  ElevatedButton.icon(
                      onPressed: reset,
                      icon: const Icon(Icons.replay),
                      label: const Text("RESTART GAME"))
                ],
              ));
    }
    if (selectedpiece!.piecetype == chesspiecetype.king) {
      if (selectedpiece!.isWhite) {
        whitekingpos = [row, col];
      } else {
        blackkingpos = [row, col];
      }
    }
    setState(() {
      selectedpiece = null;
      selectedrow = -1;
      selectedcol = -1;
      ValidMoves = [];
    });

    iswhiteTurn = !iswhiteTurn;
  }

  void reset() {
    Navigator.pop(context);
    _initialize();
    whitedead = [];
    blackdead = [];
    check = false;
    iswhiteTurn = true;
    setState(() {});
  }

  bool checkmatefunc(bool iswhite) {
    if (!kingCheck(iswhite)) {
      return false;
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != iswhite) {
          continue;
        }
        List<List<int>> mate = realmoves(i, j, board[i][j], true);

        if (mate.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

//Check checking function it will go through all the square and check the check is implemented or not
  bool kingCheck(bool iswhite) {
    List<int> king = iswhite ? whitekingpos : blackkingpos;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == iswhite) {
          continue;
        }
        List<List<int>> piecemoves = realmoves(i, j, board[i][j], false);
        if (piecemoves
            .any((element) => king[0] == element[0] && king[1] == element[1])) {
          return true;
        }
      }
    }
    return false;
  }

//find the all possible moves for the piece
  List<List<int>> moves(int row, int col, Piece? selected) {
    List<List<int>> usermove = [];
    if (selectedpiece == null) return [];
    int direction = selected!.isWhite ? -1 : 1;
    switch (selected.piecetype) {
      case chesspiecetype.pawn:
        // Moves in row initially 2 and after that 1
        //case 1 one step
        if (isInsideBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          usermove.add([row + direction, col]);
        }

        // case 2 : two step
        if ((row == 1 && !selected.isWhite) || (row == 6 && selected.isWhite)) {
          if (isInsideBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            usermove.add([row + direction, col]);
            usermove.add([row + 2 * direction, col]);
          }
        }
        //diagonally if any piece is present
        if (isInsideBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]?.isWhite != selected.isWhite) {
          usermove.add([row + direction, col - 1]);
        }
        if (isInsideBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]?.isWhite != selected.isWhite) {
          usermove.add([row + direction, col + 1]);
        }

      case chesspiecetype.rook:
        //move in horizontal and vertical direction
        //positive direction -> and down direction
        //negative direction <- and up direction
        var dirs = [
          [1, 0],
          [0, 1],
          [-1, 0],
          [0, -1]
        ];
        for (var dir in dirs) {
          int i = 1;
          while (true) {
            int availrow = row + i * dir[0];
            int availcol = col + i * dir[1];
            if (!isInsideBoard(availrow, availcol)) break;
            if (board[availrow][availcol] != null) {
              if (board[availrow][availcol]!.isWhite != selected.isWhite) {
                usermove.add([availrow, availcol]);
              }
              break;
            }
            usermove.add([availrow, availcol]);
            i++;
          }
        }
        break;
      case chesspiecetype.knight:
        //knight moves in 2.5 steps like 2up and 1left or right so direction list can be
        var dirs = [
          //up ,left side negative and down,right side positive
          [-2, -1], //2 up,1 left
          [-2, 1], //2 up ,1 right
          [2, -1], //2 down,1 left
          [2, 1], //2 down,1 right
          [1, 2], //2 right,1 down
          [-1, 2], //2 right 1 up
          [1, -2], //2 left 1 down
          [-1, -2], //2 left 1 up
        ];

        for (var dir in dirs) {
          int availrow = row + dir[0];
          int availcol = col + dir[1];
          if (!isInsideBoard(availrow, availcol)) {
            continue;
          }
          if (board[availrow][availcol] != null) {
            if (board[availrow][availcol]!.isWhite != selected.isWhite) {
              usermove.add([availrow, availcol]);
            }
            continue;
          }
          usermove.add([availrow, availcol]);
        }
        break;
      case chesspiecetype.bishop:
        var dirs = [
          [-1, -1], //top left
          [-1, 1], //top right
          [1, -1], //down left
          [1, 1] //down right
        ];

        for (var dir in dirs) {
          int i = 1;
          while (true) {
            int availrow = row + i * dir[0];
            int avialcol = col + i * dir[1];
            if (!isInsideBoard(availrow, avialcol)) {
              break;
            }
            if (board[availrow][avialcol] != null) {
              if (board[availrow][avialcol]!.isWhite != selected.isWhite) {
                usermove.add([availrow, avialcol]);
              }
              break;
            }
            usermove.add([availrow, avialcol]);
            i++;
          }
        }
        break;

      case chesspiecetype.queen:
        var dirs = [
          [1, 0],
          [0, 1],
          [-1, 0],
          [0, -1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        for (var dir in dirs) {
          int i = 1;
          while (true) {
            int availrow = row + i * dir[0];
            int avialcol = col + i * dir[1];
            if (!isInsideBoard(availrow, avialcol)) {
              break;
            }
            if (board[availrow][avialcol] != null) {
              if (board[availrow][avialcol]!.isWhite != selected.isWhite) {
                usermove.add([availrow, avialcol]);
              }
              break;
            }
            usermove.add([availrow, avialcol]);
            i++;
          }
        }
        break;
      case chesspiecetype.king:
        var dirs = [
          [1, 0],
          [0, 1],
          [-1, 0],
          [0, -1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        for (var dir in dirs) {
          int availrow = row + dir[0];
          int avialcol = col + dir[1];
          if (!isInsideBoard(availrow, avialcol)) {
            continue;
          }
          if (board[availrow][avialcol] != null) {
            if (board[availrow][avialcol]!.isWhite != selected.isWhite) {
              usermove.add([availrow, avialcol]);
            }
            continue;
          }
          usermove.add([availrow, avialcol]);
        }
        break;
      default:
    }
    return usermove;
  }

//find the real moves that can only a selected piece can do because of check
  List<List<int>> realmoves(int row, int col, Piece? selected, bool checkreal) {
    List<List<int>> realmove = [];
    List<List<int>> usermove = moves(row, col, selected);
    if (checkreal) {
      for (var mov in usermove) {
        int temprow = mov[0];
        int tempcol = mov[1];

        if (Safe(row, col, temprow, tempcol, selected!)) {
          realmove.add(mov);
        }
      }
    } else {
      realmove = usermove;
    }
    return realmove;
  }

//it will check th real moves.move will give the values move of square we
//should put the piece into that position and check that  check is implemented or not
  bool Safe(int row, int col, int temprow, int tempcol, Piece selected) {
    Piece? OriginalPiece = board[temprow][tempcol];
    List<int>? Originalkingpos;
    if (selected.piecetype == chesspiecetype.king) {
      Originalkingpos = selected.isWhite ? whitekingpos : blackkingpos;
      if (selected.isWhite) {
        whitekingpos = [temprow, tempcol];
      } else {
        blackkingpos = [temprow, tempcol];
      }
    }
    // print(OriginalPiece);
    // print(Originalkingpos);

    board[temprow][tempcol] = selected;
    board[row][col] = null;

    bool Incheck = kingCheck(selected.isWhite);

    board[row][col] = selected;
    board[temprow][tempcol] = OriginalPiece;

    if (selected.piecetype == chesspiecetype.king) {
      if (selected.isWhite) {
        whitekingpos = Originalkingpos!;
      } else {
        blackkingpos = Originalkingpos!;
      }
    }
    return !Incheck;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Column(
          children: [
            const Gap(15),
            Expanded(
                child: GridView.builder(
                    itemCount: whitedead.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8),
                    itemBuilder: (context, index) => DeadPiece(
                          imagepath: whitedead[index].imgpath,
                          isWhite: true,
                        ))),
            Text(
              check ? "Check" : "",
              style: const TextStyle(fontSize: 35, color: Colors.red),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                  itemCount: 8 * 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;
                    bool isSelected = row == selectedrow && col == selectedcol;
                    bool isvalid = false;
                    for (var pos in ValidMoves) {
                      if (pos[0] == row && pos[1] == col) isvalid = true;
                    }
                    bool checkking = false;
                    if (board[row][col] != null && kingwhitecheck != null) {
                      checkking = check &&
                          board[row][col]!.piecetype == chesspiecetype.king &&
                          board[row][col]!.isWhite == kingwhitecheck;
                    }
                    return Board(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      ontapped: () => pieceselect(row, col),
                      isValid: isvalid,
                      isCheck: checkking,
                    );
                  }),
            ),
            Expanded(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: blackdead.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8),
                    itemBuilder: (context, index) => DeadPiece(
                          imagepath: blackdead[index].imgpath,
                          isWhite: false,
                        ))),
          ],
        ),
      ),
    );
  }
}
