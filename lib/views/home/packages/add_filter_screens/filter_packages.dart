import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';

class FilterPackages extends StatelessWidget {
  const FilterPackages({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(4, (index) => 'ACT');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Filter Packages'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FilterSection(title: "Filter By Course", items: items),
            const SizedBox(height: 10),
            FilterSection(title: "Filter By Module", items: items),
            const SizedBox(height: 10),
            FilterSection(title: "Filter By Category", items: items),
          ],
        ),
      ),
    );
  }
}

class FilterSection extends StatefulWidget {
  final String title;
  final List<String> items;

  const FilterSection({super.key, required this.title, required this.items});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List.filled(widget.items.length, true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.title}:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...List.generate(widget.items.length, (index) {
            return CheckboxListTile(
              activeColor: AppColors.primary,
              value: checked[index],
              onChanged: (val) {
                setState(() {
                  checked[index] = val ?? false;
                });
              },
              title: Text(widget.items[index]),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }
}
