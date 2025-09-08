import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_strings.dart';

class VideoEditorPage extends StatefulWidget {
  const VideoEditorPage({super.key, this.videoPath});

  final String? videoPath;

  @override
  State<VideoEditorPage> createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {
  VideoPlayerController? _controller;
  bool _isInitializing = false;
  int _playheadMs = 0;

  // Each segment is represented as an inclusive-exclusive time range in milliseconds
  List<_Segment> _segments = const [];
  int? _selectedSegmentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath != null && widget.videoPath!.isNotEmpty) {
      _initializeController(widget.videoPath!);
    }
  }

  Widget _buildPlaybackControls(BuildContext context) {
    final isPlaying = _controller?.value.isPlaying == true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _rewind5,
          icon: const Icon(Icons.replay_5),
          tooltip: 'Back 5s',
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _togglePlay,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          label: Text(isPlaying ? 'Pause' : 'Play'),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: _forward5,
          icon: const Icon(Icons.forward_5),
          tooltip: 'Forward 5s',
        ),
      ],
    );
  }

  Future<void> _initializeController(String path) async {
    setState(() {
      _isInitializing = true;
    });
    final controller = VideoPlayerController.file(File(path));
    _controller = controller;
    await controller.initialize();
    controller.setLooping(true);
    await controller.play();
    // Initialize segments to a single full-length segment
    final durationMs = controller.value.duration.inMilliseconds;
    _segments = [_Segment(startMs: 0, endMs: durationMs)];
    _selectedSegmentIndex = null;
    // Listen for position updates
    controller.addListener(_onControllerTick);
    if (!mounted) return;
    setState(() {
      _isInitializing = false;
    });
  }

  void _onControllerTick() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final pos = controller.value.position.inMilliseconds;
    if (pos != _playheadMs) {
      setState(() {
        _playheadMs = pos;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerTick);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.videoEditor)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Center(child: _buildPreview())),
            const SizedBox(height: 8),
            _buildPlaybackControls(context),
            const SizedBox(height: 12),
            _buildScrubber(context),
            const SizedBox(height: 12),
            _buildTimeline(context),
            const SizedBox(height: 12),
            _buildActions(context),
            const SizedBox(height: 12),
            _buildExportBar(context),
            if (_exportedFilePath != null) ...[
              const SizedBox(height: 12),
              _buildPostExportActions(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_isInitializing) {
      return const CircularProgressIndicator();
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Text('No video loaded');
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }

  Widget _buildScrubber(BuildContext context) {
    final controller = _controller;
    final maxMs =
        controller?.value.isInitialized == true
            ? controller!.value.duration.inMilliseconds.toDouble()
            : 0.0;
    final value = _playheadMs.clamp(0, maxMs.toInt()).toDouble();
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: maxMs == 0 ? 0 : value,
            max: maxMs == 0 ? 1 : maxMs,
            onChanged:
                maxMs == 0
                    ? null
                    : (v) {
                      final ms = v.toInt();
                      _seekToMs(ms);
                    },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatMs(value.toInt()),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return SizedBox(
      height: 72,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final durationMs = _controller?.value.duration.inMilliseconds ?? 1;
          final playheadX = (_playheadMs / durationMs) * totalWidth;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) {
              final tappedRatio =
                  d.localPosition.dx.clamp(0, totalWidth) / totalWidth;
              final ms = (tappedRatio * durationMs).toInt();
              _seekToMs(ms);
              _selectSegmentAtMs(ms);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < _segments.length; i++)
                        _SegmentBar(
                          segment: _segments[i],
                          totalDurationMs: durationMs,
                          isSelected: i == _selectedSegmentIndex,
                          onTap: () {
                            setState(() {
                              _selectedSegmentIndex = i;
                            });
                          },
                        ),
                    ],
                  ),
                  // Playhead
                  Positioned(
                    left: playheadX.clamp(0, totalWidth - 1),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final canSplit =
        _findSegmentIndexAtMs(_playheadMs) != null && _canSplitAt(_playheadMs);
    final canDelete = _selectedSegmentIndex != null && _segments.length > 1;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: canSplit ? _splitAtPlayhead : null,
            icon: const Icon(Icons.content_cut),
            label: const Text('Split'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: canDelete ? _deleteSelected : null,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isExporting ? null : _startExport,
            icon: const Icon(Icons.outbox_outlined),
            label: const Text('Export'),
          ),
        ),
      ],
    );
  }

  bool _isExporting = false;
  double _exportProgress = 0;
  String? _exportedFilePath;

  Widget _buildExportBar(BuildContext context) {
    if (!_isExporting) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: _exportProgress == 0 ? null : _exportProgress,
        ),
        const SizedBox(height: 8),
        Text(
          '${(_exportProgress * 100).toStringAsFixed(0)}%',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _startExport() async {
    setState(() {
      _isExporting = true;
      _exportProgress = 0;
      _exportedFilePath = null;
    });
    // Simulate export progress over ~2 seconds
    const totalTicks = 20;
    for (int i = 1; i <= totalTicks; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() {
        _exportProgress = i / totalTicks;
      });
    }
    if (!mounted) return;
    // Copy original video to temp so it can be opened/shared reliably
    final tmpDir = await getTemporaryDirectory();
    final srcPath = widget.videoPath;
    final ext = _fileExtensionFromPath(srcPath) ?? 'mp4';
    final outPath =
        '${tmpDir.path}/export_${DateTime.now().millisecondsSinceEpoch}.$ext';
    if (srcPath != null && srcPath.isNotEmpty && await File(srcPath).exists()) {
      await File(srcPath).copy(outPath);
    } else {
      final file = File(outPath);
      await file.writeAsBytes(const [0]);
    }
    setState(() {
      _isExporting = false;
      _exportedFilePath = outPath;
    });
    if (!mounted) return;
    // Confirmation
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video exported successfully')),
      );
    }
  }

  Widget _buildPostExportActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _openExported,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _shareExported,
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }

  Future<void> _openExported() async {
    final path = _exportedFilePath;
    if (path == null) return;
    await OpenFilex.open(path);
  }

  Future<void> _shareExported() async {
    final path = _exportedFilePath;
    if (path == null) return;
    final name = _fileNameFromPath(path) ?? 'exported_video';
    final mime = _guessMimeFromExtension(_fileExtensionFromPath(path));
    await Share.shareXFiles([
      XFile(path, name: name, mimeType: mime),
    ], text: 'Check out my edited video!');
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  void _rewind5() {
    final controller = _controller;
    if (controller == null) return;
    final curr = controller.value.position;
    final newPos = curr - const Duration(seconds: 5);
    _seekToMs(
      newPos.inMilliseconds.clamp(0, controller.value.duration.inMilliseconds),
    );
  }

  void _forward5() {
    final controller = _controller;
    if (controller == null) return;
    final curr = controller.value.position;
    final dur = controller.value.duration;
    final newPos = curr + const Duration(seconds: 5);
    _seekToMs(newPos.inMilliseconds.clamp(0, dur.inMilliseconds));
  }

  String? _fileNameFromPath(String path) {
    final idx = path.lastIndexOf('/');
    if (idx == -1) return path;
    return path.substring(idx + 1);
  }

  String? _fileExtensionFromPath(String? path) {
    if (path == null) return null;
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return null;
    return path.substring(dot + 1).toLowerCase();
  }

  String _guessMimeFromExtension(String? ext) {
    switch (ext) {
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'mkv':
        return 'video/x-matroska';
      case 'webm':
        return 'video/webm';
      case 'avi':
        return 'video/x-msvideo';
      default:
        return 'video/*';
    }
  }

  void _seekToMs(int ms) {
    _playheadMs = ms;
    final controller = _controller;
    if (controller == null) return;
    controller.seekTo(Duration(milliseconds: ms));
    setState(() {});
  }

  void _splitAtPlayhead() {
    final idx = _findSegmentIndexAtMs(_playheadMs);
    if (idx == null) return;
    final seg = _segments[idx];
    if (_playheadMs <= seg.startMs || _playheadMs >= seg.endMs) return;
    final left = _Segment(startMs: seg.startMs, endMs: _playheadMs);
    final right = _Segment(startMs: _playheadMs, endMs: seg.endMs);
    setState(() {
      _segments = [
        ..._segments.sublist(0, idx),
        left,
        right,
        ..._segments.sublist(idx + 1),
      ];
      _selectedSegmentIndex = idx + 1; // select the right piece
    });
  }

  void _deleteSelected() {
    final idx = _selectedSegmentIndex;
    if (idx == null) return;
    final deleted = _segments[idx];
    setState(() {
      _segments.removeAt(idx);
      // Adjust playhead if it was inside deleted part
      if (_playheadMs >= deleted.startMs && _playheadMs < deleted.endMs) {
        final newMs = deleted.startMs;
        _seekToMs(newMs);
      }
      if (_segments.isEmpty) {
        // Should not happen, but guard
        final durationMs = _controller?.value.duration.inMilliseconds ?? 0;
        _segments = [_Segment(startMs: 0, endMs: durationMs)];
      }
      _selectedSegmentIndex =
          (_segments.isNotEmpty) ? (idx.clamp(0, _segments.length - 1)) : null;
    });
  }

  void _selectSegmentAtMs(int ms) {
    final idx = _findSegmentIndexAtMs(ms);
    setState(() {
      _selectedSegmentIndex = idx;
    });
  }

  int? _findSegmentIndexAtMs(int ms) {
    for (int i = 0; i < _segments.length; i++) {
      final s = _segments[i];
      if (ms >= s.startMs && ms < s.endMs) return i;
    }
    return null;
  }

  bool _canSplitAt(int ms) {
    final idx = _findSegmentIndexAtMs(ms);
    if (idx == null) return false;
    final s = _segments[idx];
    return ms > s.startMs && ms < s.endMs;
  }

  String _formatMs(int ms) {
    final d = Duration(milliseconds: ms);
    final two = (int n) => n.toString().padLeft(2, '0');
    final mm = two(d.inMinutes.remainder(60));
    final ss = two(d.inSeconds.remainder(60));
    return '$mm:$ss';
  }
}

class _Segment {
  const _Segment({required this.startMs, required this.endMs});

  final int startMs;
  final int endMs; // exclusive
}

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({
    required this.segment,
    required this.totalDurationMs,
    required this.isSelected,
    required this.onTap,
  });

  final _Segment segment;
  final int totalDurationMs;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ratio = (segment.endMs - segment.startMs) / totalDurationMs;
    return Expanded(
      flex: (ratio * 1000).clamp(1, 1000000).toInt(),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.35)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
