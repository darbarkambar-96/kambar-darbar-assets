import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';
import 'package:darbar_app_of_kambar_darbar/global_audio_manager.dart';

class BhajansScreen extends StatefulWidget {
  const BhajansScreen({super.key});

  @override
  State<BhajansScreen> createState() => _BhajansScreenState();
}

class _BhajansScreenState extends State<BhajansScreen> {
  static const String repoOwner = "darbarkambar-96";
  static const String repoName = "kambar-darbar-assets";
  static const String rootPath = "audio";

  final List<GitHubItem> _pathStack = [
    GitHubItem(
      name: "Audio Library",
      path: rootPath,
      type: "dir",
      url: "https://api.github.com/repos/$repoOwner/$repoName/contents/$rootPath",
      downloadUrl: null,
    )
  ];

  List<GitHubItem> _currentItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDirectoryContents(_pathStack.last);
  }

  // NOTE: No AudioPlayer disposal here so the music continues playing globally

  String _cleanTitle(String rawName) {
    return rawName
        .replaceAll(RegExp(r'\.(mp3|wav|m4a)$', caseSensitive: false), '')
        .replaceAll('_', ' ')
        .trim();
  }

  Future<void> _fetchDirectoryContents(GitHubItem dir, {bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = "gh_cache_${dir.path}";

    if (!forceRefresh) {
      final cached = prefs.getString(cacheKey);
      if (cached != null) {
        try {
          final List<dynamic> decoded = jsonDecode(cached);
          setState(() {
            _currentItems = decoded.map((e) => GitHubItem.fromJson(e)).toList();
            _isLoading = false;
          });
          return;
        } catch (_) {}
      }
    }

    try {
      final response = await http.get(
        Uri.parse(dir.url),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final items = jsonList
            .map((item) => GitHubItem.fromJson(item as Map<String, dynamic>))
            .where((item) => item.isFolder || item.isAudioFile)
            .toList();

        items.sort((a, b) {
          if (a.isFolder && !b.isFolder) return -1;
          if (!a.isFolder && b.isFolder) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        await prefs.setString(cacheKey, jsonEncode(items.map((e) => e.toJson()).toList()));

        setState(() {
          _currentItems = items;
          _isLoading = false;
        });
      } else if (response.statusCode == 404 && dir.path == rootPath) {
        final fallbackUrl = "https://api.github.com/repos/$repoOwner/$repoName/contents";
        final fallbackRes = await http.get(Uri.parse(fallbackUrl));
        if (fallbackRes.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(fallbackRes.body);
          final items = jsonList
              .map((item) => GitHubItem.fromJson(item as Map<String, dynamic>))
              .where((item) => item.isFolder || item.isAudioFile)
              .toList();

          setState(() {
            _currentItems = items;
            _isLoading = false;
          });
        } else {
          throw Exception("Directory not found on GitHub");
        }
      } else {
        throw Exception("GitHub API error (${response.statusCode})");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Unable to load audio files. Please check internet connection.";
        _isLoading = false;
      });
    }
  }

  void _playTrack(GitHubItem item) {
    if (item.downloadUrl == null) return;
    GlobalAudioManager.instance.playTrack(
      AudioTrack(
        name: item.name,
        path: item.path,
        downloadUrl: item.downloadUrl!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value;

        final Color scaffoldBg =
        isDark ? const Color(0xFF131315) : const Color.fromRGBO(235, 236, 222, 1);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText = isDark ? Colors.white60 : const Color(0xFF7A6B63);
        final Color accentColor =
        isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);

        final currentFolder = _pathStack.last;

        return PopScope(
          canPop: _pathStack.length <= 1,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (_pathStack.length > 1) {
              setState(() {
                _pathStack.removeLast();
              });
              _fetchDirectoryContents(_pathStack.last);
            }
          },
          child: Scaffold(
            backgroundColor: scaffoldBg,
            appBar: AppBar(
              backgroundColor: cardBg,
              elevation: 0.5,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: accentColor),
                onPressed: () {
                  if (_pathStack.length > 1) {
                    setState(() {
                      _pathStack.removeLast();
                    });
                    _fetchDirectoryContents(_pathStack.last);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(
                _pathStack.length > 1
                    ? _cleanTitle(currentFolder.name)
                    : (lang == 0 ? "Bhajans & Pravachans" : "भजन एवं प्रवचन"),
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: "Refresh Library",
                  icon: Icon(Icons.refresh_rounded, color: accentColor),
                  onPressed: () =>
                      _fetchDirectoryContents(_pathStack.last, forceRefresh: true),
                ),
              ],
            ),
            body: Column(
              children: [
                if (_pathStack.length > 1)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: accentColor.withValues(alpha: 0.08),
                    child: Row(
                      children: [
                        Icon(Icons.folder_open_rounded, size: 16, color: accentColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _pathStack.map((e) => _cleanTitle(e.name)).join(" > "),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _isLoading
                      ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: accentColor,
                      size: 40,
                    ),
                  )
                      : _errorMessage != null
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_off_rounded,
                              size: 48, color: secondaryText),
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: secondaryText, fontSize: 13),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor),
                            onPressed: () => _fetchDirectoryContents(
                                _pathStack.last,
                                forceRefresh: true),
                            child: const Text("Retry",
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  )
                      : _currentItems.isEmpty
                      ? Center(
                    child: Text(
                      lang == 0
                          ? "No audio files found in this folder."
                          : "इस फ़ोल्डर में कोई ऑडियो नहीं मिला।",
                      style: GoogleFonts.poppins(
                          color: secondaryText, fontSize: 13),
                    ),
                  )
                      : ValueListenableBuilder<AudioTrack?>(
                    valueListenable:
                    GlobalAudioManager.instance.currentTrackNotifier,
                    builder: (context, currentTrack, _) {
                      return ListView.builder(
                        // Padding at bottom so the persistent overlay doesn't obscure the last track
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 12, bottom: 90),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _currentItems.length,
                        itemBuilder: (context, index) {
                          final item = _currentItems[index];
                          final bool isPlayingThis = currentTrack != null &&
                              currentTrack.path == item.path;

                          if (item.isFolder) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white12
                                      : Colors.black.withValues(alpha: 0.04),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.black45
                                        : Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.folder_rounded,
                                      color: accentColor, size: 24),
                                ),
                                title: Text(
                                  _cleanTitle(item.name),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: primaryText,
                                  ),
                                ),
                                trailing: Icon(Icons.chevron_right_rounded,
                                    color: secondaryText, size: 20),
                                onTap: () {
                                  setState(() {
                                    _pathStack.add(item);
                                  });
                                  _fetchDirectoryContents(item);
                                },
                              ),
                            );
                          } else {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isPlayingThis
                                      ? accentColor
                                      : (isDark
                                      ? Colors.white12
                                      : Colors.black.withValues(alpha: 0.04)),
                                  width: isPlayingThis ? 1.6 : 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.black45
                                        : Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isPlayingThis
                                        ? accentColor
                                        : accentColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isPlayingThis
                                        ? Icons.graphic_eq_rounded
                                        : Icons.audiotrack_rounded,
                                    color: isPlayingThis ? Colors.white : accentColor,
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  _cleanTitle(item.name),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: isPlayingThis
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isPlayingThis ? accentColor : primaryText,
                                  ),
                                ),
                                subtitle: Text(
                                  "Audio Recording",
                                  style: GoogleFonts.poppins(
                                      fontSize: 11, color: secondaryText),
                                ),
                                trailing: StreamBuilder<PlayerState>(
                                  stream: GlobalAudioManager
                                      .instance.player.playerStateStream,
                                  builder: (context, snapshot) {
                                    final playing = isPlayingThis &&
                                        (snapshot.data?.playing ?? false);

                                    return IconButton(
                                      icon: Icon(
                                        playing
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_fill_rounded,
                                        color: accentColor,
                                        size: 32,
                                      ),
                                      onPressed: () {
                                        if (isPlayingThis) {
                                          GlobalAudioManager.instance.togglePlayPause();
                                        } else {
                                          _playTrack(item);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GitHubItem {
  final String name;
  final String path;
  final String type;
  final String url;
  final String? downloadUrl;

  GitHubItem({
    required this.name,
    required this.path,
    required this.type,
    required this.url,
    this.downloadUrl,
  });

  bool get isFolder =>
      type == 'dir' &&
          !name.toLowerCase().contains('system volume information') &&
          !name.startsWith('.');

  bool get isAudioFile {
    if (type != 'file') return false;
    final lower = name.toLowerCase();
    return lower.endsWith('.mp3') || lower.endsWith('.wav') || lower.endsWith('.m4a');
  }

  factory GitHubItem.fromJson(Map<String, dynamic> json) {
    return GitHubItem(
      name: json['name']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      downloadUrl: json['download_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type,
      'url': url,
      'download_url': downloadUrl,
    };
  }
}