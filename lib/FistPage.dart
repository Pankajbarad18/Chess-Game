// ignore_for_file: file_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chess_game/chessboard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Gap(MediaQuery.of(context).size.height * .1),
            const Image(
              image: AssetImage(
                "lib/Images/chessopen.gif",
              ),
            ),
            const Gap(25),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText("Ready To Play MindGame",
                    textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Gap(45),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade500,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: const Text(
                    "Let's Start",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ChessBoard()))),
            ),
          ],
        ),
      ),
    );
  }
}
