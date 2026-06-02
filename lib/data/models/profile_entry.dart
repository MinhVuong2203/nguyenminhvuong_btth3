class ProfileEntry {
  final int? id;
  final String section;
  final String title;
  final String subtitle;
  final String time;
  final String content;
  final String tags;
  final String fileName;
  final String fileInfo;

  const ProfileEntry({
    this.id,
    required this.section,
    required this.title,
    this.subtitle = '',
    this.time = '',
    this.content = '',
    this.tags = '',
    this.fileName = '',
    this.fileInfo = '',
  });

  List<String> get tagList {
    if (tags.trim().isEmpty) {
      return [];
    }
    return tags.split('|').where((tag) => tag.trim().isNotEmpty).toList();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'section': section,
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'content': content,
      'tags': tags,
      'fileName': fileName,
      'fileInfo': fileInfo,
    };
  }

  factory ProfileEntry.fromMap(Map<String, Object?> map) {
    return ProfileEntry(
      id: map['id'] as int?,
      section: map['section'] as String,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      time: map['time'] as String? ?? '',
      content: map['content'] as String? ?? '',
      tags: map['tags'] as String? ?? '',
      fileName: map['fileName'] as String? ?? '',
      fileInfo: map['fileInfo'] as String? ?? '',
    );
  }

  ProfileEntry copyWith({
    int? id,
    String? section,
    String? title,
    String? subtitle,
    String? time,
    String? content,
    String? tags,
    String? fileName,
    String? fileInfo,
  }) {
    return ProfileEntry(
      id: id ?? this.id,
      section: section ?? this.section,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      fileName: fileName ?? this.fileName,
      fileInfo: fileInfo ?? this.fileInfo,
    );
  }
}
