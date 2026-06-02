import 'package:flutter/material.dart';
import 'package:nguyenminhvuong_btth3/controller/profile_controller.dart';
import 'package:nguyenminhvuong_btth3/data/models/profile_entry.dart';
import 'package:nguyenminhvuong_btth3/features/profile/screens/profile_form_screen.dart';
import 'package:nguyenminhvuong_btth3/features/profile/widget/info_item_widget.dart';
import 'package:nguyenminhvuong_btth3/utils/app_color.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Set<String> _expandedSections = {};
  final ProfileController _controller = ProfileController();
  List<ProfileEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _controller.getEntries();
    if (!mounted) {
      return;
    }
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  void _toggleSection(String section) {
    setState(() {
      if (_expandedSections.contains(section)) {
        _expandedSections.remove(section);
      } else {
        _expandedSections.add(section);
      }
    });
  }

  Future<void> _openForm(_SectionMeta section, ProfileEntry? entry) async {
    final savedEntry = await Navigator.push<ProfileEntry>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileFormScreen(
          section: section.key,
          sectionTitle: section.title,
          entry: entry,
        ),
      ),
    );

    if (savedEntry == null) {
      return;
    }

    await _controller.saveEntry(savedEntry);
    await _loadEntries();
    setState(() {
      _expandedSections.add(section.key);
    });
  }

  Future<void> _deleteEntry(ProfileEntry entry) async {
    await _controller.deleteEntry(entry);
    await _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.itemColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/flutter_logo.png",
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Nguyễn Minh Vương",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "6451071090@st.utc2.edu.vn",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._sections.map(_buildSection),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSection(_SectionMeta section) {
    final sectionEntries = _entries
        .where((entry) => entry.section == section.key)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InfoItemWidget(
        title: section.title,
        iconUrl: section.iconUrl,
        expanded: _expandedSections.contains(section.key),
        onHeaderTap: () => _toggleSection(section.key),
        onAdd: () => _openForm(section, null),
        children: [
          if (sectionEntries.isEmpty)
            const Text('Không có dữ liệu', style: _bodyStyle)
          else
            ...sectionEntries.map(
              (entry) => _ProfileEntryView(
                entry: entry,
                section: section,
                onEdit: () => _openForm(section, entry),
                onDelete: section.key == 'resume'
                    ? () => _deleteEntry(entry)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

const TextStyle _bodyStyle = TextStyle(
  color: Color(0xFF524B6B),
  fontSize: 13,
  height: 1.35,
);

const List<_SectionMeta> _sections = [
  _SectionMeta('about', 'About me', 'assets/icons/account.svg'),
  _SectionMeta('work', 'Work experience', 'assets/icons/work.svg'),
  _SectionMeta('education', 'Education', 'assets/icons/edu.svg'),
  _SectionMeta('skill', 'Skill', 'assets/icons/skill.svg'),
  _SectionMeta('language', 'Language', 'assets/icons/lang.svg'),
  _SectionMeta('appreciation', 'Appreciation', 'assets/icons/apprec.svg'),
  _SectionMeta('resume', 'Resume', 'assets/icons/resume.svg'),
];

class _SectionMeta {
  final String key;
  final String title;
  final String iconUrl;

  const _SectionMeta(this.key, this.title, this.iconUrl);
}

class _ProfileEntryView extends StatelessWidget {
  final ProfileEntry entry;
  final _SectionMeta section;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const _ProfileEntryView({
    required this.entry,
    required this.section,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildContent()),
          IconButton(
            onPressed: onEdit,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColor.buttonColor,
              size: 20,
            ),
          ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFFFF4F5E),
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (section.key == 'about') {
      return Text(entry.content, style: _bodyStyle);
    }

    if (section.key == 'skill' || section.key == 'language') {
      return _ChipGroup(labels: entry.tagList);
    }

    if (section.key == 'resume') {
      return _ResumeInfo(entry: entry);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.title,
          style: const TextStyle(
            color: AppColor.primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (entry.subtitle.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(entry.subtitle, style: _bodyStyle),
        ],
        if (entry.time.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(entry.time, style: _bodyStyle),
        ],
      ],
    );
  }
}

class _ChipGroup extends StatelessWidget {
  final List<String> labels;

  const _ChipGroup({required this.labels});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: labels.map((label) => _InfoChip(label: label)).toList(),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF524B6B),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ResumeInfo extends StatelessWidget {
  final ProfileEntry entry;

  const _ResumeInfo({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFF4F5E),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: const Text(
            "PDF",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.fileName.isEmpty ? entry.title : entry.fileName,
                style: const TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (entry.fileInfo.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(entry.fileInfo, style: _bodyStyle),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
