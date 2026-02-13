import 'package:flutter/material.dart';
import 'package:httapp/main.dart';
import 'package:httapp/services/text_theme_service.dart';

class CustomizationSettings extends StatelessWidget {
  final String title = 'Customization Settings';

  const CustomizationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [
          _TextSizeSection().build(context),
          //const Divider(),
          
        ],
      ),
    );
  }
}

class TextSizeSection extends StatefulWidget {
  const TextSizeSection({super.key});

  @override
  State<TextSizeSection> createState() => _TextSizeSection();
}

class _TextSizeSection extends State<TextSizeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        MenuAnchor(
          alignmentOffset: Offset(MediaQuery.of(context).size.width, 0),
          builder: (context, controller, child) {
            return ListTile(
              leading: Icon(Icons.format_size_rounded),
              title: Text('Body Font Size'),
              subtitle: Text('Change the font size of body text.'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            );
          },
          menuChildren: [
            MenuItemButton(
              child: Text('Small', style: Theme.of(context).textTheme.bodySmall),
              onPressed: () {
                // Change body font size to TextTheme.bodySmall
                TextThemeService().setBodySize = Size.small;
                TextThemeService().setMarkdownTextScale = Size.small;
              },
            ),
            MenuItemButton(
              child: Text('Medium', style: Theme.of(context).textTheme.bodyMedium),
              onPressed: () {
                // Change body font size to TextTheme.bodyMedium
                TextThemeService().setBodySize = Size.medium;
                TextThemeService().setMarkdownTextScale = Size.medium;
              },
            ),
            MenuItemButton(
              child: Text('Large', style: Theme.of(context).textTheme.bodyLarge),
              onPressed: () {
                // Change body font size to TextTheme.bodyLarge
                TextThemeService().setBodySize = Size.large;
                TextThemeService().setMarkdownTextScale = Size.large;
              },
            ),
          ],
        ),

        const Divider(),
      ],
    );
  }
}

class StatelessSettingCard extends StatelessWidget {
  const StatelessSettingCard({
    required this.cardName,
    required this.children,
    this.mainAxisAlignment
  });

  final String cardName;
  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      width: MediaQuery.of(context).size.width - 16,
      child: Column(
        mainAxisAlignment: mainAxisAlignment == null ? MainAxisAlignment.start : mainAxisAlignment!,
        children: children
      )
    );
  }
}
