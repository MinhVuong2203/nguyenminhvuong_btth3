import 'package:flutter/material.dart';
import 'package:nguyenminhvuong_btth3/data/models/profile_entry.dart';
import 'package:nguyenminhvuong_btth3/utils/app_color.dart';

class ProfileFormScreen extends StatefulWidget {
  final String section;
  final String sectionTitle;
  final ProfileEntry? entry;

  const ProfileFormScreen({
    super.key,
    required this.section,
    required this.sectionTitle,
    this.entry,
  });

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _timeController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;
  late final TextEditingController _fileNameController;
  late final TextEditingController _fileInfoController;
  late List<String> _tags;

  bool get _isEdit => widget.entry != null;
  bool get _isAbout => widget.section == 'about';
  bool get _isTagSection =>
      widget.section == 'skill' || widget.section == 'language';
  bool get _isResume => widget.section == 'resume';

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _titleController = TextEditingController(text: entry?.title ?? '');
    _subtitleController = TextEditingController(text: entry?.subtitle ?? '');
    _timeController = TextEditingController(text: entry?.time ?? '');
    _contentController = TextEditingController(text: entry?.content ?? '');
    _tagController = TextEditingController();
    _fileNameController = TextEditingController(text: entry?.fileName ?? '');
    _fileInfoController = TextEditingController(text: entry?.fileInfo ?? '');
    _tags = entry?.tagList.toList() ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _timeController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _fileNameController.dispose();
    _fileInfoController.dispose();
    super.dispose();
  }

  void _addTag() {
    final value = _tagController.text.trim();
    if (value.isEmpty || _tags.contains(value)) {
      return;
    }

    setState(() {
      _tags.add(value);
      _tagController.clear();
    });
  }

  void _save() {
    final title = _titleController.text.trim();
    final entry = ProfileEntry(
      id: widget.entry?.id,
      section: widget.section,
      title: _titleForSave(title),
      subtitle: _subtitleController.text.trim(),
      time: _timeController.text.trim(),
      content: _contentController.text.trim(),
      tags: _tags.join('|'),
      fileName: _fileNameController.text.trim(),
      fileInfo: _fileInfoController.text.trim(),
    );

    Navigator.pop(context, entry);
  }

  String _titleForSave(String title) {
    if (title.isNotEmpty) {
      return title;
    }
    if (_isAbout || _isTagSection || _isResume) {
      return widget.sectionTitle;
    }
    return 'Untitled';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: Text('${_isEdit ? 'Edit' : 'Add'} ${widget.sectionTitle}'),
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black45,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
            decoration: BoxDecoration(
              color: AppColor.itemColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sectionTitle,
                  style: const TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                _buildFields(),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.primaryColor,
                          side: const BorderSide(color: AppColor.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'CLOSE',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFields() {
    if (_isAbout) {
      return TextField(
        controller: _contentController,
        minLines: 8,
        maxLines: 10,
        decoration: _inputDecoration('Tell me about you.'),
      );
    }

    if (_isTagSection) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _tags
                .map(
                  (tag) => _EditableChip(
                    label: tag,
                    highlighted: tag == 'Responsibility',
                    onRemove: () {
                      setState(() {
                        _tags.remove(tag);
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _tagController,
            onSubmitted: (_) => _addTag(),
            decoration: _inputDecoration('Enter ${widget.sectionTitle}'),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _addTag,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add item'),
          ),
        ],
      );
    }

    if (_isResume) {
      return Column(
        children: [
          TextField(
            controller: _fileNameController,
            decoration: _inputDecoration('File name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fileInfoController,
            decoration: _inputDecoration('File info'),
          ),
        ],
      );
    }

    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: _inputDecoration('Title'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _subtitleController,
          decoration: _inputDecoration('Subtitle'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _timeController,
          decoration: _inputDecoration('Time'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAA6B9), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFFDFDFD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _EditableChip extends StatelessWidget {
  final String label;
  final bool highlighted;
  final VoidCallback onRemove;

  const _EditableChip({
    required this.label,
    required this.highlighted,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final background = highlighted
        ? AppColor.buttonColor
        : const Color(0xFFF7F6FA);
    final foreground = highlighted ? Colors.white : const Color(0xFF524B6B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onRemove,
            child: Icon(Icons.close, color: foreground, size: 16),
          ),
        ],
      ),
    );
  }
}
