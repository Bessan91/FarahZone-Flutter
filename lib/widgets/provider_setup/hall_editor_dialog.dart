import 'package:flutter/material.dart';
import 'hospitality_editor_dialog.dart';
import 'package:farah/utils/hall_shape.dart';

class HallEditorDialog extends StatefulWidget {
  final List<String> capacityRanges;
  final List<String> includedOptions;
  final List<String> serviceOptions;
  final List<String> occasionOptions;
  final Map<String, dynamic>? existingHall;

  const HallEditorDialog({
    super.key,
    required this.capacityRanges,
    required this.includedOptions,
    required this.serviceOptions,
    required this.occasionOptions,
    this.existingHall,
  });

  @override
  State<HallEditorDialog> createState() => _HallEditorDialogState();
}

class _HallEditorDialogState extends State<HallEditorDialog> {
  static const Color cream = Color(0xFFF3EDE2);
  static const Color navy = Color(0xFF1B2A4A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color textDark = Color(0xFF202020);
  static const Color textGrey = Color(0xFF777777);
  static const Color softBorder = Color(0xFFE6E0D5);
  static const Color green = Color(0xFF3E8E68);
  static const Color red = Color(0xFFB84C4C);

  late final TextEditingController nameController;

  final Map<String, TextEditingController> pricingControllers = {};
  final Set<String> selectedRanges = {};
  final List<String> selectedIncludedItems = [];
  final List<String> selectedServices = [];
  final Set<String> selectedOccasions = {};
  final Map<String, TextEditingController> occasionPriceControllers = {};
  final List<Map<String, dynamic>> hospitalityItems = [];

  bool get isEditing => widget.existingHall != null;

  String _normalize(String input) {
    return input
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('  ', ' ')
        .trim();
  }

  @override
  void initState() {
    super.initState();

    final hall = widget.existingHall != null
        ? HallShape.normalize(widget.existingHall!)
        : null;

    nameController = TextEditingController(
      text: hall?['name']?.toString() ?? '',
    );

    final List pricingList = (hall?['pricing'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    for (final range in widget.capacityRanges) {
      pricingControllers[range] = TextEditingController();

      for (final item in pricingList) {
        final rawRange = item['peopleRange']?.toString() ?? '';
        final rawPrice = item['price']?.toString() ?? '';

        if (_normalize(rawRange) == _normalize(range) ||
            (_normalize(rawRange).isNotEmpty &&
                (_normalize(range).contains(_normalize(rawRange)) ||
                    _normalize(rawRange).contains(_normalize(range))))) {
          selectedRanges.add(range);
          pricingControllers[range]!.text = rawPrice;
          break;
        }
      }
    }

    final rawIncluded = hall?['includedItems'] as List? ?? [];
    selectedIncludedItems.addAll(rawIncluded.map((e) => e.toString()).toList());

    final rawServices = hall?['services'] as List? ?? [];
    selectedServices.addAll(rawServices.map((e) => e.toString()).toList());

    final savedOccasions = hall?['occasions'] as List? ?? [];

    for (final occasion in widget.occasionOptions) {
      occasionPriceControllers[occasion] = TextEditingController();

      for (final item in savedOccasions) {
        if (item is Map) {
          final name = item['name']?.toString() ?? '';

          if (_normalize(name) == _normalize(occasion)) {
            selectedOccasions.add(occasion);
            occasionPriceControllers[occasion]!.text =
                item['price']?.toString() ?? '';
            break;
          }
        }
      }
    }

    final rawHospitality = hall?['hospitality'] as List? ?? [];
    hospitalityItems.addAll(
      rawHospitality
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item)),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    for (final controller in pricingControllers.values) {
      controller.dispose();
    }
    for (final controller in occasionPriceControllers.values) {
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: SizedBox(
          width: 650,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBasicSection(),
                      const SizedBox(height: 14),
                      _buildPricingSection(),
                      const SizedBox(height: 14),
                      _buildServicesSection(),
                      const SizedBox(height: 14),
                      _buildOccasionsSection(),
                      const SizedBox(height: 14),
                      _buildHospitalitySection(),
                    ],
                  ),
                ),
              ),
              _buildDialogActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: const BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: gold, shape: BoxShape.circle),
            child: const Icon(Icons.home_work_outlined, color: navy, size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              isEditing ? 'تعديل القاعة' : 'إضافة القاعة وخدماتها',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'LibertinusMath',
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicSection() {
    return _dialogSection(
      title: 'اسم القاعة',
      icon: Icons.info_outline,
      child: TextField(
        controller: nameController,
        textAlign: TextAlign.right,
        decoration: _inputDecoration(
          hint: 'ادخل اسم قاعتك',
          icon: Icons.home_work_outlined,
        ),
        style: const TextStyle(
          color: textDark,
          fontSize: 13,
          fontFamily: 'LibertinusMath',
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return _dialogSection(
      title: 'الأسعار',
      icon: Icons.payments_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'حدد أولاً ما يشمله السعر الأساسي، ثم أضف السعر المناسب لكل فئة من عدد الأشخاص.',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
              height: 1.5,
              fontFamily: 'LibertinusMath',
            ),
          ),
          const SizedBox(height: 13),
          _buildIncludedSelector(),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: gold.withOpacity(0.25)),
            ),
            child: const Row(
              children: [
                Icon(Icons.groups_outlined, color: navy, size: 19),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'السعر حسب عدد الأشخاص',
                    style: TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          ...widget.capacityRanges.map(_buildCapacityRow),
        ],
      ),
    );
  }

  Widget _buildIncludedSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ماذا يشمل السعر الأساسي؟',
            style: TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: widget.includedOptions.map((item) {
              final selected = selectedIncludedItems.contains(item);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      selectedIncludedItems.remove(item);
                    } else {
                      selectedIncludedItems.add(item);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? navy : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? navy : softBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? Icons.check_circle : Icons.add_circle_outline,
                        size: 15,
                        color: selected ? gold : textGrey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item,
                        style: TextStyle(
                          color: selected ? Colors.white : textDark,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityRow(String range) {
    final selected = selectedRanges.contains(range);
    final controller = pricingControllers[range]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: selected ? gold.withOpacity(0.55) : softBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Checkbox(
              value: selected,
              activeColor: navy,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedRanges.add(range);
                  } else {
                    selectedRanges.remove(range);
                    controller.clear();
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
            width: 115,
            child: TextField(
              controller: controller,
              enabled: selected,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'السعر',
                suffixText: '₪',
                filled: true,
                fillColor: selected ? cream : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
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

  Widget _buildServicesSection() {
    return _dialogSection(
      title: 'الخدمات الإضافية',
      icon: Icons.auto_awesome_outlined,
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: widget.serviceOptions.map((service) {
          final selected = selectedServices.contains(service);

          return _selectableChip(
            text: service,
            selected: selected,
            onTap: () {
              setState(() {
                if (selected) {
                  selectedServices.remove(service);
                } else {
                  selectedServices.add(service);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOccasionsSection() {
    return _dialogSection(
      title: 'المناسبات والأسعار الخاصة',
      icon: Icons.celebration_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'اختر المناسبة وأدخل السعر الخاص بها.',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
              height: 1.5,
              fontFamily: 'LibertinusMath',
            ),
          ),
          const SizedBox(height: 12),
          ...widget.occasionOptions.map((occasion) {
            final selected = selectedOccasions.contains(occasion);
            final controller = occasionPriceControllers[occasion]!;

            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: selected ? gold.withOpacity(0.07) : Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: selected ? gold.withOpacity(0.55) : softBorder,
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        if (selected) {
                          selectedOccasions.remove(occasion);
                          controller.clear();
                        } else {
                          selectedOccasions.add(occasion);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: selected ? navy : Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: selected ? navy : softBorder,
                              width: 1.3,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check, color: gold, size: 17)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            occasion,
                            style: TextStyle(
                              color: selected ? navy : textDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'LibertinusMath',
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_circle, color: green, size: 19),
                      ],
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'السعر الخاص',
                        hintText: 'أدخل السعر',
                        suffixText: '₪',
                        prefixIcon: const Icon(
                          Icons.payments_outlined,
                          color: navy,
                          size: 19,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: softBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: softBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: gold, width: 1.4),
                        ),
                      ),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHospitalitySection() {
    return _dialogSection(
      title: 'الضيافة',
      icon: Icons.local_cafe_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hospitalityItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'لم تتم إضافة ضيافة بعد.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textGrey,
                  fontSize: 11,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            )
          else
            ...List.generate(
              hospitalityItems.length,
              (index) {
                final item = hospitalityItems[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  decoration: BoxDecoration(
                    color: cream,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name']?.toString() ?? '',
                          style: const TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LibertinusMath',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result = await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (_) => HospitalityEditorDialog(
                              capacityRanges: widget.capacityRanges,
                              existingItem: item,
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              hospitalityItems[index] = result;
                            });
                          }
                        },
                        icon: const Icon(Icons.edit_outlined, color: gold, size: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            hospitalityItems.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete_outline, color: red, size: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 7),
          OutlinedButton.icon(
            onPressed: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (_) => HospitalityEditorDialog(
                  capacityRanges: widget.capacityRanges,
                ),
              );

              if (result != null) {
                setState(() {
                  hospitalityItems.add(result);
                });
              }
            },
            icon: const Icon(Icons.add, size: 18, color: navy),
            label: const Text(
              'إضافة ضيافة',
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.bold,
                fontFamily: 'LibertinusMath',
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: softBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectableChip({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? navy : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? navy : softBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check_circle, color: gold, size: 15),
              const SizedBox(width: 5),
            ],
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : textDark,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'LibertinusMath',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: navy, size: 19),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          child,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

  Widget _buildDialogActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: navy,
                side: const BorderSide(color: softBorder),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              ),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'LibertinusMath', fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              ),
              child: Text(
                isEditing ? 'حفظ التعديلات' : 'إضافة القاعة',
                style: const TextStyle(fontFamily: 'LibertinusMath', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال اسم الخدمة', textAlign: TextAlign.right),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final pricing = <Map<String, dynamic>>[];

    for (final range in selectedRanges) {
      final value = pricingControllers[range]!.text.trim();

      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى إدخال سعر لفئة "$range"', textAlign: TextAlign.right),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      pricing.add({'peopleRange': range, 'price': value});
    }

    if (pricing.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تحديد فئة واحدة على الأقل وإدخال سعرها', textAlign: TextAlign.right),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final occasions = <Map<String, dynamic>>[];

    for (final occasion in selectedOccasions) {
      final price = occasionPriceControllers[occasion]!.text.trim();

      if (price.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى إدخال سعر مناسبة "$occasion"', textAlign: TextAlign.right),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      occasions.add({'name': occasion, 'price': price});
    }

    final hallData = HallShape.normalize({
      'id': widget.existingHall?['id'] ?? widget.existingHall?['Id'],
      'name': name,
      'pricing': pricing,
      'includedItems': List<String>.from(selectedIncludedItems),
      'services': List<String>.from(selectedServices),
      'occasions': occasions,
      'hospitality': hospitalityItems,
    });

    Navigator.pop(context, hallData);
  }
}