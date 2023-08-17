import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nav_timer/utils/countdown_timer.dart';

class CountDownTimerPage extends StatefulWidget {
  const CountDownTimerPage({Key? key}) : super(key: key);

  @override
  State<CountDownTimerPage> createState() => _CountDownTimerPageState();
}

class _CountDownTimerPageState extends State<CountDownTimerPage> {
  int countdownSeconds = 180; //total timer limit in seconds
  late CountdownTimer countdownTimer;
  bool isTimerRunning = false;

  void initTimerOperation() {
    //timer callbacks
    countdownTimer = CountdownTimer(
      seconds: countdownSeconds,
      onTick: (seconds) {
        isTimerRunning = true;
        setState(() {
          countdownSeconds = seconds; //this will return the timer values
        });
      },
      onFinished: () {
        stopTimer();
        // Handle countdown finished
      },
    );

    //native app life cycle
    SystemChannels.lifecycle.setMessageHandler((msg) {
      // On AppLifecycleState: paused
      if (msg == AppLifecycleState.paused.toString()) {
        if (isTimerRunning) {
          countdownTimer.pause(countdownSeconds); //setting end time on pause
        }
      }

      // On AppLifecycleState: resumed
      if (msg == AppLifecycleState.resumed.toString()) {
        if (isTimerRunning) {
          countdownTimer.resume();
        }
      }
      return Future(() => null);
    });

    //starting timer
    isTimerRunning = true;
    countdownTimer.start();
  }

  void stopTimer() {
    isTimerRunning = false;
    countdownTimer.stop();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      countdownSeconds = 180;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NAV Timer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Countdown Timer',
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '$countdownSeconds',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Colors.tealAccent,
                  onPressed: () {
                    initTimerOperation();
                  },
                  child: const Text("Start Timer"),
                ),
                MaterialButton(
                  color: Colors.orangeAccent,
                  onPressed: () {
                    stopTimer();
                  },
                  child: const Text("Stop Timer"),
                ),
                MaterialButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    resetTimer();
                  },
                  child: const Text("Reset Timer"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
