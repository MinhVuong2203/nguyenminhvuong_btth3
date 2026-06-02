import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nguyenminhvuong_btth3/features/profile/widget/info_item_widget.dart';

void main() {
  testWidgets('Info item expands from header and opens add from plus', (
    tester,
  ) async {
    var expanded = false;
    var addTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return InfoItemWidget(
                title: 'About me',
                iconUrl: 'assets/icons/account.svg',
                expanded: expanded,
                onHeaderTap: () => setState(() {
                  expanded = !expanded;
                }),
                onAdd: () {
                  addTapped = true;
                },
                children: const [Text('Saved profile data')],
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Saved profile data'), findsNothing);

    await tester.tap(find.text('About me'));
    await tester.pump();

    expect(find.text('Saved profile data'), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    expect(addTapped, isTrue);
  });
}
