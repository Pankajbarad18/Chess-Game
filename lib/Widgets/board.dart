import 'package:flutter/material.dart';

import 'PieceType.dart';

class Board extends StatelessWidget {
  final bool isWhite;
  final Piece? piece;
  final bool isSelected;
  final bool isValid;
  final bool isCheck;
  final void Function()? ontapped;
  const Board(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.ontapped,
      required this.isValid, required this.isCheck});

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (isSelected) {
      color = Colors.green;
    } else if (isValid) {
      color = Colors.green[300];
    } else if (isCheck) {
      color = Colors.red;
    } else {
      color = isWhite ? Colors.grey[400] : Colors.grey[700];
    }
    return InkWell(
      onTap: ontapped,
      child: Container(
        color: color,
        margin: EdgeInsets.all(isValid ? 4 : 0),
        child: piece != null
            ? Image.asset(
                piece!.imgpath,
                color: piece!.isWhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
