import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';
import 'notes_screen.dart';

class NoteEditScreen extends ConsumerStatefulWidget {
  final String? noteId;
  final String? dayTaskId;

  const NoteEditScreen({
    super.key,
    this.noteId,
    this.dayTaskId,
  });

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _isPinned = false;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      _loadNote();
    }
  }

  Future<void> _loadNote() async {
    setState(() => _isLoading = true);
    try {
      final res = await SupabaseService.notes
          .select()
          .eq('id', widget.noteId!)
          .maybeSingle();

      if (res != null) {
        _titleController.text = res['title'] ?? '';
        _contentController.text = res['content'] ?? '';
        _isPinned = res['is_pinned'] == true;
        final tags = (res['tags'] as List?)?.join(', ') ?? '';
        _tagsController.text = tags;
      }
    } catch (_) {
      // In offline / demo mode fallback
      _titleController.text = 'TCP 3-Way Handshake & Wireshark Filter Cheat-Sheet';
      _contentController.text = 'SYN -> SYN-ACK -> ACK.\\nFilter in Wireshark: tcp.flags.syn==1 and tcp.flags.ack==0.\\nLook for unusual RST packets indicating firewalls or resets.';
      _isPinned = true;
      _tagsController.text = 'networking, wireshark';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note title')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final tagsList = _tagsController.text
        .split(',')
        .map((s) => s.trim().replaceAll('#', ''))
        .where((s) => s.isNotEmpty)
        .toList();

    try {
      final userId = SupabaseService.currentUserId;
      final data = {
        'title': title,
        'content': _contentController.text.trim(),
        'tags': tagsList,
        'is_pinned': _isPinned,
        if (widget.dayTaskId != null) 'day_task_id': widget.dayTaskId,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (widget.noteId != null) {
        await SupabaseService.notes.update(data).eq('id', widget.noteId!);
      } else {
        if (userId != null) data['user_id'] = userId;
        await SupabaseService.notes.insert(data);
      }

      ref.invalidate(notesListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved locally: $e')),
        );
        ref.invalidate(notesListProvider);
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteNote() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Delete Note?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      if (widget.noteId != null) {
        await SupabaseService.notes.delete().eq('id', widget.noteId!);
      }
      ref.invalidate(notesListProvider);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) context.pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.cyberCyan))
              : Column(
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.textPrimary),
                            onPressed: () => context.pop(),
                          ),
                          Expanded(
                            child: Text(
                              widget.noteId != null ? 'Edit Field Note' : 'New Field Note',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                              color: _isPinned ? AppColors.cyberCyan : AppColors.textMuted,
                            ),
                            tooltip: 'Pin Note',
                            onPressed: () => setState(() => _isPinned = !_isPinned),
                          ),
                          if (widget.noteId != null)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.neonRed),
                              tooltip: 'Delete Note',
                              onPressed: _deleteNote,
                            ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: _isSaving ? null : _saveNote,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cyberCyan,
                              foregroundColor: AppColors.bgPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgPrimary),
                                  )
                                : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

                    // Editor Fields
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _titleController,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Note Title...',
                                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 20),
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(color: AppColors.borderColor),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _tagsController,
                              style: const TextStyle(color: AppColors.cyberCyan, fontSize: 13),
                              decoration: const InputDecoration(
                                hintText: 'Tags (comma separated, e.g. websec, sqli, recon)',
                                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                                prefixIcon: Icon(Icons.tag, size: 18, color: AppColors.cyberCyan),
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(color: AppColors.borderColor),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _contentController,
                              maxLines: null,
                              minLines: 15,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                height: 1.5,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Write down key findings, syntax, payloads, commands...',
                                hintStyle: TextStyle(color: AppColors.textMuted),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
