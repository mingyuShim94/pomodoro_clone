import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int _selectedTime = 25; // Initial time is set to 25 minutes
  int _completedCycles = 0;
  int _completedRounds = 0;
  bool _isRunning = false;
  Timer? _timer;
  int _remainingMinutes = 0;
  int _remainingSeconds = 0;

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else if (_remainingMinutes > 0) {
          _remainingMinutes--;
          _remainingSeconds = 59;
        } else {
          // Timer is up
          _completedCycles++;
          if (_completedCycles % 4 == 0) {
            // Take a longer break after every 4 cycles (rounds)
            _completedRounds++;
            _showBreakDialog();
          }
          _resetTimer();
        }
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
      _remainingMinutes = _selectedTime;
      _remainingSeconds = 0;
    });
  }

  void _showBreakDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Take a Break'),
          content:
              const Text('You have completed a round. Take a 5-minute break.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _startTimer(); // Resume the timer after the break
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Pomodoro Timer'),
      ),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  '$_remainingMinutes:${_remainingSeconds.toString().padLeft(2, '0')}', // Format minutes and seconds
                  style: const TextStyle(
                    fontSize: 48, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for (int time in [15, 20, 25, 30, 35])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                          _resetTimer(); // Reset timer when the time is changed
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white,
                            // Set border color based on selection
                            width: 2.0, // Set border width
                          ),

                          color: _selectedTime == time
                              ? Colors.white
                              : Colors
                                  .transparent, // Set background color based on selection
                        ),
                        child: Text(
                          '$time',
                          style: TextStyle(
                            color: _selectedTime == time
                                ? Colors.red
                                : Colors
                                    .white, // Set text color based on selection
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _isRunning ? _pauseTimer : _startTimer,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRunning
                            ? const Color.fromARGB(255, 165, 35, 33)
                            : const Color.fromARGB(255, 165, 35, 33),
                      ),
                      child: _isRunning
                          ? const Icon(Icons.pause, color: Colors.white)
                          : const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: _resetTimer,
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.blueGrey, shape: BoxShape.circle),
                        child: const Icon(Icons.restore, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '$_completedRounds/4',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ROUUND',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '$_completedCycles/12',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'GOAL',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
