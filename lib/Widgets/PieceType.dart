// ignore_for_file: file_names, camel_case_types

enum chesspiecetype {
  pawn,
  rook,
  knight,
  queen,
  king,
  bishop,
}

class Piece {
  final chesspiecetype piecetype;
  final bool isWhite;
  final String imgpath;

  Piece(
      {required this.piecetype, required this.isWhite, required this.imgpath});
}
