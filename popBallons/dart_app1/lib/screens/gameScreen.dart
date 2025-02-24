import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Timer timer1;
  double ust = -50.0;
  double sag = 15.0;
  double dikenUst = 690;
  int puan = 0;
  bool oyunDurumu = false;

  void baslat() {
    ust = -50;
    sag = _resetBalon();
    oyunDurumu = true; // Oyun başladığında durumu true yap

    timer1 = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        ust += 3;
        _carpismaKontrol();
      });
    });
  }

  void _onBalloonPressed() {
    if (!oyunDurumu) return; // Oyun durduysa geri dönecek

    setState(() {
      puan += 1000;
      sag = _resetBalon();
      ust = -50;
    });
  }

  double _resetBalon() {
    Random random = Random();
    return random.nextInt(320).toDouble();
  }

  void yenidenBaslat() {
    setState(() {
      puan = 0;
      ust = -50;
      sag = _resetBalon();
      oyunDurumu = false; // Oyun yeniden başlatıldığında durumu false yap
    });
    baslat();
  }

  void _carpismaKontrol() {
    if (ust >= dikenUst - 78 && ust <= dikenUst) {
      setState(() {
        oyunDurumu = false; // Oyun durdu
        timer1.cancel(); // Timer'ı durdur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: ust,
              right: sag,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(30),
                  backgroundColor: Colors.greenAccent,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: _onBalloonPressed,
                child: const Text(
                  "Balloon",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            if (!oyunDurumu) // Oyun durmadıysa "Start" butonunu göster
              Positioned(
                left: 70,
                bottom: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: baslat, // Başlatma işlemi
                  child: const Text(
                    "Start",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                  ),
                ),
              ),
            if (!oyunDurumu &&
                ust >=
                    dikenUst -
                        78) // Oyun bittiğinde "Try Again" butonunu göster
              Positioned(
                top: MediaQuery.of(context).size.height / 2,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: ElevatedButton(
                  onPressed: yenidenBaslat,
                  child: Text("Try Again!   Score=$puan"),
                ),
              ),
            Positioned(
              bottom: 50,
              right: 70,
              child: Text(
                '$puan',
                style: const TextStyle(color: Colors.red, fontSize: 30),
              ),
            ),
            Positioned(
              top: dikenUst,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(25, (index) {
                  return Container(
                    width: 15,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(9, 25),
                        topRight: Radius.elliptical(9, 25),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
