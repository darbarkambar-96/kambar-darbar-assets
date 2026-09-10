import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class AudioTrack {
  final String name;
  final String path;
  final String downloadUrl;

  AudioTrack({
    required this.name,
    required this.path,
    required this.downloadUrl,
  });
}

class GlobalAudioManager {
  static final GlobalAudioManager instance = GlobalAudioManager._internal();
  GlobalAudioManager._internal();

  final AudioPlayer player = AudioPlayer();
  final ValueNotifier<AudioTrack?> currentTrackNotifier = ValueNotifier<AudioTrack?>(null);
  final ValueNotifier<bool> isLoopingNotifier = ValueNotifier<bool>(false);

  void init() {
    player.loopModeStream.listen((mode) {
      isLoopingNotifier.value = (mode == LoopMode.one);
    });
  }

  Future<void> playTrack(AudioTrack track) async {
    try {
      currentTrackNotifier.value = track;
      await player.setUrl(track.downloadUrl);
      player.play();
    } catch (e) {
      debugPrint("Audio playback error: $e");
    }
  }

  void togglePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void toggleLoop() {
    final nextMode = isLoopingNotifier.value ? LoopMode.off : LoopMode.one;
    player.setLoopMode(nextMode);
  }

  void stopAndDismiss() {
    player.stop();
    currentTrackNotifier.value = null;
  }

  void seekRelative(int seconds) {
    final current = player.position;
    final target = current + Duration(seconds: seconds);
    final maxDur = player.duration ?? Duration.zero;
    if (target < Duration.zero) {
      player.seek(Duration.zero);
    } else if (target > maxDur) {
      player.seek(maxDur);
    } else {
      player.seek(target);
    }
  }
}

class GlobalAudioOverlay extends StatelessWidget {
  const GlobalAudioOverlay({super.key});

  static bool _isSheetActive = false;

  String _cleanTitle(String rawName) {
    return rawName
        .replaceAll(RegExp(r'\.(mp3|wav|m4a)$', caseSensitive: false), '')
        .replaceAll('_', ' ')
        .trim();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${duration.inHours}:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  void _showFullPlayerSheet(BuildContext context, AudioTrack track, bool isDark) {
    if (_isSheetActive) return;
    _isSheetActive = true;

    final targetContext = appNavigatorKey.currentContext ?? context;
    const Color brandSaffron = Color(0xFFE65100);
    final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
    final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
    final Color secondaryText = isDark ? Colors.white60 : const Color(0xFF7A6B63);

    showModalBottomSheet(
      context: targetContext,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        int? activePointer;
        double startY = 0;
        double startX = 0;
        bool isDismissing = false;

        return SafeArea(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (activePointer == null) {
                activePointer = event.pointer;
                startY = event.position.dy;
                startX = event.position.dx;
              }
            },
            onPointerMove: (event) {
              if (isDismissing || event.pointer != activePointer) return;
              final double dy = event.position.dy - startY;
              final double dx = (event.position.dx - startX).abs();

              // Trigger collapse on downward swipe anywhere on sheet
              // Ensuring movement is predominantly vertical so seeking remains unaffected
              if (dy > 35 && dy > dx * 1.2) {
                isDismissing = true;
                Navigator.of(ctx).pop();
              }
            },
            onPointerUp: (event) {
              if (event.pointer == activePointer) {
                activePointer = null;
              }
            },
            onPointerCancel: (event) {
              if (event.pointer == activePointer) {
                activePointer = null;
              }
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 52),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _cleanTitle(track.name),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Swipe down to collapse",
                                style: GoogleFonts.poppins(fontSize: 12, color: secondaryText),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: GlobalAudioManager.instance.isLoopingNotifier,
                          builder: (context, isLooping, _) {
                            return IconButton(
                              icon: Icon(
                                isLooping ? Icons.repeat_one_rounded : Icons.repeat_rounded,
                                color: isLooping ? brandSaffron : secondaryText,
                                size: 24,
                              ),
                              onPressed: GlobalAudioManager.instance.toggleLoop,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: secondaryText, size: 28),
                          onPressed: () {
                            if (!isDismissing) {
                              isDismissing = true;
                              Navigator.of(ctx).pop();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    StreamBuilder<Duration>(
                      stream: GlobalAudioManager.instance.player.positionStream,
                      builder: (context, snapshotPos) {
                        final position = snapshotPos.data ?? Duration.zero;
                        final duration = GlobalAudioManager.instance.player.duration ?? Duration.zero;

                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                                activeTrackColor: brandSaffron,
                                thumbColor: brandSaffron,
                                inactiveTrackColor: brandSaffron.withValues(alpha: 0.2),
                              ),
                              child: Slider(
                                min: 0.0,
                                max: duration.inMilliseconds.toDouble() > 0
                                    ? duration.inMilliseconds.toDouble()
                                    : 1.0,
                                value: position.inMilliseconds.toDouble().clamp(
                                  0.0,
                                  duration.inMilliseconds.toDouble() > 0
                                      ? duration.inMilliseconds.toDouble()
                                      : 1.0,
                                ),
                                onChanged: (val) {
                                  GlobalAudioManager.instance.player
                                      .seek(Duration(milliseconds: val.toInt()));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style: GoogleFonts.poppins(fontSize: 11, color: secondaryText),
                                  ),
                                  Text(
                                    _formatDuration(duration),
                                    style: GoogleFonts.poppins(fontSize: 11, color: secondaryText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10_rounded, color: primaryText, size: 32),
                          onPressed: () => GlobalAudioManager.instance.seekRelative(-10),
                        ),
                        const SizedBox(width: 20),
                        StreamBuilder<PlayerState>(
                          stream: GlobalAudioManager.instance.player.playerStateStream,
                          builder: (context, snapshot) {
                            final playing = snapshot.data?.playing ?? false;
                            return IconButton(
                              iconSize: 54,
                              icon: Icon(
                                playing
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_fill_rounded,
                                color: brandSaffron,
                              ),
                              onPressed: GlobalAudioManager.instance.togglePlayPause,
                            );
                          },
                        ),
                        const SizedBox(width: 21),
                        IconButton(
                          icon: Icon(Icons.forward_10_rounded, color: primaryText, size: 32),
                          onPressed: () => GlobalAudioManager.instance.seekRelative(10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isSheetActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AudioTrack?>(
      valueListenable: GlobalAudioManager.instance.currentTrackNotifier,
      builder: (context, track, _) {
        if (track == null) return const SizedBox.shrink();

        return AnimatedBuilder(
          animation: Listenable.merge([themeNotifier, languageNotifier]),
          builder: (context, _) {
            final bool isDark = themeNotifier.value == ThemeMode.dark;
            const Color brandSaffron = Color(0xFFE65100);
            final Color cardBg = isDark ? const Color(0xFF221E1B) : Colors.white;
            final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
            final Color secondaryText = isDark ? Colors.white60 : const Color(0xFF7A6B63);

            return Positioned(
              left: 12,
              right: 68,
              bottom: 14,
              child: SafeArea(
                top: false,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(20),
                  color: cardBg,
                  shadowColor: Colors.black.withValues(alpha: 0.35),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showFullPlayerSheet(context, track, isDark),
                    child: Container(
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: brandSaffron.withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: brandSaffron.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.audiotrack_rounded, color: brandSaffron, size: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _cleanTitle(track.name),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: primaryText,
                                          ),
                                        ),
                                        Text(
                                          "Tap to Expand",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<PlayerState>(
                                    stream: GlobalAudioManager.instance.player.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playing = snapshot.data?.playing ?? false;
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                                        icon: Icon(
                                          playing
                                              ? Icons.pause_circle_filled_rounded
                                              : Icons.play_circle_fill_rounded,
                                          color: brandSaffron,
                                          size: 32,
                                        ),
                                        onPressed: GlobalAudioManager.instance.togglePlayPause,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                    icon: Icon(Icons.close_rounded, color: secondaryText, size: 18),
                                    onPressed: GlobalAudioManager.instance.stopAndDismiss,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: StreamBuilder<Duration>(
                                stream: GlobalAudioManager.instance.player.positionStream,
                                builder: (context, snapshotPos) {
                                  final pos = snapshotPos.data ?? Duration.zero;
                                  final dur = GlobalAudioManager.instance.player.duration ?? Duration.zero;
                                  final double progress = (dur.inMilliseconds > 0)
                                      ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                                      : 0.0;

                                  return LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 2.2,
                                    backgroundColor: Colors.transparent,
                                    valueColor: const AlwaysStoppedAnimation<Color>(brandSaffron),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}