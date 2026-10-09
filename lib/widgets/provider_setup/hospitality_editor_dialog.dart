import 'package:flutter/material.dart';

class HospitalityEditorDialog extends StatefulWidget {
  final List<String> capacityRanges;
  final Map<String, dynamic>? existingItem;

  const HospitalityEditorDialog({
    super.key,
    required this.capacityRanges,
    this.existingItem,
  });

  @override
  State<HospitalityEditorDialog> createState() =>
      _HospitalityEditorDialogState();
}

class _HospitalityEditorDialogState extends State<HospitalityEditorDialog> {
  static const Color cream = Color(0xFFF3EDE2);
  static const Color navy = Color(0xFF1B2A4A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color textDark = Color(0xFF202020);
  static const Color textGrey = Color(0xFF777777);
  static const Color softBorder = Color(0xFFE6E0D5);

  late final TextEditingController nameController;

  final Map<String, TextEditingController> controllers = {};
  final Set<String> selected = {};

  bool get isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.existingItem?['name']?.toString() ?? '',
    );

    for (final range in widget.capacityRanges) {
      controllers[range] = TextEditingController();
    }

    final pricing = (widget.existingItem?['pricing'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    for (final item in pricing) {
      final range = item['peopleRange']?.toString();

      if (range != null && controllers.containsKey(range)) {
        selected.add(range);
        controllers[range]!.text = item['price']?.toString() ?? '';
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();

    for (final controller in controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: cream,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 25,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
            maxHeight: 650,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(17),
                decoration: const BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_cafe_outlined, color: gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEditing ? 'تعديل الضيافة' : 'إضافة ضيافة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nameController,
                        textAlign: TextAlign.right,
                        decoration: _inputDecoration(
                          hint: 'مثال: قهوة عربية',
                          icon: Icons.local_cafe_outlined,
                        ),
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 12,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'السعر حسب عدد الأشخاص',
                        style: TextStyle(
                          color: navy,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...widget.capacityRanges.map(_buildRangeRow),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: navy,
                          side: const BorderSide(color: softBorder),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(fontFamily: 'LibertinusMath'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'حفظ',
                          style: TextStyle(
                            fontFamily: 'LibertinusMath',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRangeRow(String range) {
    final isSelected = selected.contains(range);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? gold.withOpacity(0.6) : softBorder,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 35,
            child: Checkbox(
              value: isSelected,
              activeColor: navy,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selected.add(range);
                  } else {
                    selected.remove(range);
                    controllers[range]!.clear();
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Text(
              range,
              style: const TextStyle(
                color: textDark,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'LibertinusMath',
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: TextField(
              controller: controllers[range],
              enabled: isSelected,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'السعر',
                suffixText: '₪',
                filled: true,
                fillColor: isSelected ? cream : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 9,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                color: navy,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: textGrey,
        fontSize: 11,
        fontFamily: 'LibertinusMath',
      ),
      prefixIcon: Icon(icon, color: navy, size: 19),
      filled: true,
      fillColor: cream.withOpacity(0.55),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: softBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: softBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gold, width: 1.4),
      ),
    );
  }

  void _save() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إدخال اسم الضيافة',
            textAlign: TextAlign.right,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final pricing = <Map<String, dynamic>>[];

    for (final range in selected) {
      final price = controllers[range]!.text.trim();

      if (price.isNotEmpty) {
        pricing.add({
          'peopleRange': range,
          'price': price,
        });
      }
    }

    if (pricing.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إضافة سعر لفئة واحدة على الأقل',
            textAlign: TextAlign.right,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      {
        'name': name,
        'pricing': pricing,
      },
    );
  }
}