import 'dart:math';

import 'package:flutter/material.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData(this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar(
      {super.key,
      required this.position,
      required this.duration,
      this.onChanged,
      this.onChangeEnd});

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');

      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Column(
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(widget.position)),
              Text(_formatDuration(widget.duration))
            ],
          )),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackHeight: 1.5,
                  thumbShape: const RoundSliderThumbShape(
                      disabledThumbRadius: 5, enabledThumbRadius: 5),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 10),
                  activeTrackColor: const Color(0xFFEC9A4A),
                  inactiveTrackColor: Colors.grey.withOpacity(0.4),
                  thumbColor: const Color(0xFFEC9A4A),
                  overlayColor: const Color(0xFFEC9A4A)),
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                    _dragValue ?? widget.position.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });

                  if (widget.onChanged != null) {
                    widget.onChanged!(
                      Duration(milliseconds: value.round()),
                    );
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }

                  _dragValue = null;
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
