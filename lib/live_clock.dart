import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveClock extends StatefulWidget {
  const LiveClock({super.key});

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  String _dateTime = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Timer is local to this small widget
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTime(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    // Format must match your requirements
    final formatted = DateFormat('EEEE, dd MMM yyyy – hh:mm:ss a').format(now);

    // Only rebuild this specific Text widget!
    if (mounted) {
      setState(() => _dateTime = formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _dateTime,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}
