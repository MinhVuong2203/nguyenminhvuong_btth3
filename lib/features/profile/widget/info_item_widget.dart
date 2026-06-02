import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nguyenminhvuong_btth3/utils/app_color.dart';

class InfoItemWidget extends StatelessWidget {
  final String title;
  final String iconUrl;
  final bool expanded;
  final VoidCallback onHeaderTap;
  final VoidCallback onAdd;
  final List<Widget> children;

  const InfoItemWidget({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.expanded,
    required this.onHeaderTap,
    required this.onAdd,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.itemColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onHeaderTap,
            contentPadding: const EdgeInsets.fromLTRB(18, 8, 16, 8),
            leading: SvgPicture.asset(
              iconUrl,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColor.buttonColor,
                BlendMode.srcIn,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: AppColor.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: IconButton(
              onPressed: onAdd,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                'assets/icons/add.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColor.buttonColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, color: Color(0xFFF0EFF7)),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
