import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../features/auth/providers/auth_providers.dart';

class StudyTimerWidget extends ConsumerStatefulWidget {
  final String? dayTaskId;

  const StudyTimerWidget({super.key, this.dayTaskId});

  @override
  ConsumerState<StudyTimerWidget> createState() => _StudyTimerWidgetState();
}

class _StudyTimerWidgetState extends ConsumerState<StudyTimerWidget> {
  int _selectedMinutes = 25;
  int _remainingSeconds = 25 * 60;
  bool _running = false;
  DateTime? _startedAt;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _startedAt = DateTime.now();
    setState(() {
      _running = true;
      _remainingSeconds = _selectedMinutes * 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stop(completed: true);
        }
      });
    });
  }

  void _stop({bool completed = false}) {
    _timer?.cancel();
    setState(() => _running = false);
    if (_startedAt != null) {
      final endedAt = DateTime.now();
      final elapsed =
          endedAt.difference(_startedAt!).inMinutes.clamp(1, _selectedMinutes);
      _saveSession(elapsed, _startedAt!, endedAt);
      _startedAt = null;
    }
    if (completed) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⏰ Study session complete! Session saved.'),
            backgroundColor: AppColors.bgCard,
          ),
        );
      }
    }
  }

  Future<void> _saveSession(
      int durationMinutes, DateTime startedAt, DateTime endedAt) async {
    try {
      final userId = ref.read(currentProfileProvider).valueOrNull?.id;
      if (userId == null) return;
      await ref.read(progressRepositoryProvider).saveStudySession(
            userId: userId,
            dayTaskId: widget.dayTaskId,
            durationMinutes: durationMinutes,
            startedAt: startedAt,
            endedAt: endedAt,
          );
    } catch (_) {}
  }

  String get _timeDisplay {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _running
        ? (_selectedMinutes * 60 - _remainingSeconds) /
            (_selectedMinutes * 60)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cyberPurple.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: AppColors.cyberPurple, size: 18),
              const SizedBox(width: 6),
              const Text(
                'STUDY TIMER',
                style: TextStyle(
                  color: AppColors.cyberPurple,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Preset buttons
          if (!_running)
            Wrap(
              spacing: 8,
              children: AppConstants.timerPresets.map((min) {
                final selected = _selectedMinutes == min;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedMinutes = min;
                    _remainingSeconds = min * 60;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.cyberPurple.withOpacity(0.2)
                          : AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected
                            ? AppColors.cyberPurple
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Text(
                      '${min}m',
                      style: TextStyle(
                        color: selected
                            ? AppColors.cyberPurple
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 16),

          // Timer display
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: _running ? progress : 0,
                  strokeWidth: 6,
                  backgroundColor: AppColors.progressBg,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.cyberPurple),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                _timeDisplay,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_running)
                ElevatedButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('START'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyberPurple,
                    foregroundColor: Colors.white,
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: () => _stop(),
                  icon: const Icon(Icons.stop),
                  label: const Text('STOP & SAVE'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.cyberPurple,
                    side: const BorderSide(color: AppColors.cyberPurple),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
