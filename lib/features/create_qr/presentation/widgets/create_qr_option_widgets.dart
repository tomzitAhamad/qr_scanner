import 'package:flutter/material.dart';

const List<Map<String, dynamic>> createQrOptions = [
  {
    "icon": Icons.assignment_outlined,
    "title": "Content from clipboard",
    "type": "clipboard",
  },
  {
    "icon": Icons.link,
    "title": "URL",
    "type": "url",
  },
  {
    "icon": Icons.text_fields_outlined,
    "title": "Text",
    "type": "text",
  },
  {
    "icon": Icons.person_outline,
    "title": "Contact",
    "type": "contact",
  },
  {
    "icon": Icons.email_outlined,
    "title": "Email",
    "type": "email",
  },
  {
    "icon": Icons.sms_outlined,
    "title": "SMS",
    "type": "sms",
  },
  {
    "icon": Icons.location_on_outlined,
    "title": "Geo",
    "type": "geo",
  },
  {
    "icon": Icons.phone_outlined,
    "title": "Phone",
    "type": "phone",
  },
  {
    "icon": Icons.calendar_month_outlined,
    "title": "Calendar",
    "type": "calendar",
  },
  {
    "icon": Icons.wifi,
    "title": "Wifi",
    "type": "wifi",
  },
];

class CreateOptionList extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final ValueChanged<Map<String, dynamic>> onTap;

  const CreateOptionList({
    super.key,
    required this.options,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          indent: 52,
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            leading: Icon(
              option['icon'] as IconData,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            title: Text(
              option['title'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => onTap(option),
          );
        },
      ),
    );
  }
}

class CreateOptionGrid extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final ValueChanged<Map<String, dynamic>> onTap;
  final int crossAxisCount;

  const CreateOptionGrid({
    super.key,
    required this.options,
    required this.onTap,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        return Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => onTap(option),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      option['icon'] as IconData,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
