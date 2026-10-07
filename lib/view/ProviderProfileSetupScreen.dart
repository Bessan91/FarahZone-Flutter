import 'package:flutter/material.dart';
import 'package:farah/view/supplierDashboardScreen.dart';

class ProviderProfileSetupScreen extends StatefulWidget {
  final String providerName;
  final String providerPhone;
  final String providerEmail;
  final String serviceType;
  final String? initialLocation;
  final String initialServiceName;
  final String licensedOperatorNumber;

  final String initialAddress;
  final String initialDescription;
  final List<Map<String, dynamic>> initialHalls;
  final bool isEditing;

  const ProviderProfileSetupScreen({
    super.key,
    required this.providerName,
    required this.providerPhone,
    required this.providerEmail,
    required this.serviceType,
    required this.initialLocation,
    required this.initialServiceName,
    required this.licensedOperatorNumber,
    this.initialAddress = '',
    this.initialDescription = '',
    this.initialHalls = const [],
    this.isEditing = false,
  });

  @override
  State<ProviderProfileSetupScreen> createState() =>
      _ProviderProfileSetupScreenState();
}

class _ProviderProfileSetupScreenState
    extends State<ProviderProfileSetupScreen> {
  static const Color cream = Color(0xFFF3EDE2);
  static const Color navy = Color(0xFF1B2A4A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color textDark = Color(0xFF202020);
  static const Color textGrey = Color(0xFF777777);
  static const Color softBorder = Color(0xFFE6E0D5);
  static const Color green = Color(0xFF3E8E68);
  static const Color red = Color(0xFFB84C4C);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController providerNameController;
  late final TextEditingController providerPhoneController;
  late final TextEditingController providerEmailController;
  late final TextEditingController serviceNameController;
  late final TextEditingController addressController;
  late final TextEditingController descriptionController;
  late final TextEditingController licensedOperatorController;

  late String selectedServiceType;
  String? selectedLocation;

  late bool _signupInfoLocked;

  late List<Map<String, dynamic>> halls;

  final List<String> serviceTypes = [
    'قاعات الأفراح',
    'قاعات الفنادق',
    'صالونات التجميل',
    'التزيين والديكور',
    'تأجير السيارات',
  ];

  final List<String> locations = [
    'رام الله',
    'نابلس',
    'القدس',
    'بيت لحم',
    'الخليل',
  ];

  final List<String> capacityRanges = [
    'أقل من 50 شخص',
    '50–100 شخص',
    '100–250 شخص',
    '250–500 شخص',
    '500–1000 شخص',
    'أكثر من 1000 شخص',
  ];

  final List<String> includedOptions = [
    'الكيك',
    'الماء',
    'القهوة',
    'الكولا',
  ];

  final List<String> serviceOptions = [
    'التصوير',
    'الديكور',
    'الزفة',
  ];

  final List<String> occasionOptions = [
    'أعراس',
    'خطوبة',
    'تخرج',
    'أعياد ميلاد',
    'مؤتمرات',
  ];

  bool get supportsHalls =>
      selectedServiceType == 'قاعات الأفراح' ||
          selectedServiceType == 'قاعات الفنادق';

  @override
  void initState() {
    super.initState();

    providerNameController = TextEditingController(
      text: widget.providerName,
    );

    providerPhoneController = TextEditingController(
      text: widget.providerPhone,
    );

    providerEmailController = TextEditingController(
      text: widget.providerEmail,
    );

    serviceNameController = TextEditingController(
      text: widget.initialServiceName,
    );

    addressController = TextEditingController(
      text: widget.initialAddress,
    );

    descriptionController = TextEditingController(
      text: widget.initialDescription,
    );

    licensedOperatorController = TextEditingController(
      text: widget.licensedOperatorNumber,
    );

    selectedServiceType = serviceTypes.contains(widget.serviceType)
        ? widget.serviceType
        : serviceTypes.first;

    selectedLocation = locations.contains(widget.initialLocation)
        ? widget.initialLocation
        : null;

    halls = _deepCopyHalls(widget.initialHalls);

    _signupInfoLocked = !widget.isEditing;
  }

  @override
  void dispose() {
    providerNameController.dispose();
    providerPhoneController.dispose();
    providerEmailController.dispose();
    serviceNameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    licensedOperatorController.dispose();

    super.dispose();
  }

  List<Map<String, dynamic>> _deepCopyHalls(
      List<Map<String, dynamic>> source,
      ) {
    return source.map((hall) {
      return {
        ...hall,
        'pricing': (hall['pricing'] as List? ?? []).map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{};
        }).toList(),
        'includedItems': List<String>.from(
          hall['includedItems'] as List? ?? [],
        ),
        'hospitality': (hall['hospitality'] as List? ?? []).map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{};
        }).toList(),
        'services': List<String>.from(
          hall['services'] as List? ?? [],
        ),
        'occasions': (hall['occasions'] as List? ?? []).map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }

          return {
            'name': item.toString(),
            'price': '',
          };
        }).toList(),
      };
    }).toList();
  }

  void _cancelSignupEditing() {
    providerNameController.text = widget.providerName;
    providerPhoneController.text = widget.providerPhone;
    providerEmailController.text = widget.providerEmail;
    serviceNameController.text = widget.initialServiceName;
    licensedOperatorController.text = widget.licensedOperatorNumber;

    addressController.text = widget.initialAddress;
    descriptionController.text = widget.initialDescription;

    selectedServiceType = serviceTypes.contains(widget.serviceType)
        ? widget.serviceType
        : serviceTypes.first;

    selectedLocation = locations.contains(widget.initialLocation)
        ? widget.initialLocation
        : null;

    halls = _deepCopyHalls(widget.initialHalls);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cream,
        appBar: AppBar(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.isEditing
                ? 'تعديل الملف الشخصي'
                : 'مرحباً بك في فرح زون !',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildBasicInformationSection(),
                const SizedBox(height: 15),
                _buildServiceInformationSection(),
                if (supportsHalls) ...[
                  const SizedBox(height: 15),
                  _buildHallsSection(),
                ],
                const SizedBox(height: 24),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gold,
              border: Border.all(
                color: navy.withOpacity(0.08),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: navy.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline_rounded,
                color: navy,
                size: 42,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            providerNameController.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),

          const SizedBox(height: 5),

          Text(
            providerEmailController.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textGrey,
              fontSize: 12,
              fontFamily: 'LibertinusMath',
            ),
          ),

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: gold,
              ),
              const SizedBox(width: 4),
              Text(
                selectedLocation ?? 'اختر الموقع',
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 11,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            height: 42,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (_signupInfoLocked) {
                    _signupInfoLocked = false;
                  } else {
                    _cancelSignupEditing();
                    _signupInfoLocked = true;
                  }
                });
              },
              icon: Icon(
                _signupInfoLocked
                    ? Icons.edit_outlined
                    : Icons.lock_outline,
                size: 17,
              ),
              label: Text(
                _signupInfoLocked
                    ? 'تعديل الملف الشخصي'
                    : 'حفظ التعديل',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformationSection() {
    return _buildFormSection(
      title: 'معلومات مقدم الخدمة',
      icon: Icons.person_outline,
      children: [
        _fieldLabel('اسم مقدم الخدمة'),
        const SizedBox(height: 7),
        _buildTextField(
          controller: providerNameController,
          hint: 'أدخل اسم مقدم الخدمة',
          icon: Icons.person_outline,
          locked: _signupInfoLocked,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال اسم مقدم الخدمة';
            }
            return null;
          },
        ),

        const SizedBox(height: 14),

        _fieldLabel('رقم الهاتف'),
        const SizedBox(height: 7),
        _buildTextField(
          controller: providerPhoneController,
          hint: 'أدخل رقم الهاتف',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          locked: _signupInfoLocked,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال رقم الهاتف';
            }
            return null;
          },
        ),

        const SizedBox(height: 14),

        _fieldLabel('البريد الإلكتروني'),
        const SizedBox(height: 7),
        _buildTextField(
          controller: providerEmailController,
          hint: 'أدخل البريد الإلكتروني',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          locked: _signupInfoLocked,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال البريد الإلكتروني';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildServiceInformationSection() {
    return _buildFormSection(
      title: 'معلومات الخدمة',
      icon: Icons.business_outlined,
      children: [
        _fieldLabel('اسم النشاط / الخدمة'),
        const SizedBox(height: 7),
        _buildTextField(
          controller: serviceNameController,
          hint: 'مثال: قاعة ليالي الفرح',
          icon: Icons.storefront_outlined,
          locked: _signupInfoLocked,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال اسم النشاط';
            }
            return null;
          },
        ),

        const SizedBox(height: 14),

        _fieldLabel('نوع الخدمة'),
        const SizedBox(height: 7),
        _buildDropdown(
          value: selectedServiceType,
          items: serviceTypes,
          icon: Icons.category_outlined,
          locked: _signupInfoLocked,
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedServiceType = value;

              if (!supportsHalls) {
                halls.clear();
              }
            });
          },
        ),

        const SizedBox(height: 14),

        _fieldLabel('الموقع'),
        const SizedBox(height: 7),
        _buildDropdown(
          value: selectedLocation,
          items: locations,
          hint: 'اختر الموقع',
          icon: Icons.location_on_outlined,
          locked: _signupInfoLocked,
          onChanged: (value) {
            setState(() {
              selectedLocation = value;
            });
          },
        ),

        const SizedBox(height: 14),

        _fieldLabel('العنوان'),
        const SizedBox(height: 7),
        _buildTextField(
          controller: addressController,
          hint: 'أدخل العنوان بالتفصيل',
          icon: Icons.home_outlined,
          maxLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال العنوان';
            }
            return null;
          },
        ),

        const SizedBox(height: 14),

        _fieldLabel('الوصف'),
        const SizedBox(height: 7),
        _buildTextField(
          controller: descriptionController,
          hint: 'اكتب وصفاً مختصراً عن نشاطك',
          icon: Icons.description_outlined,
          maxLines: 4,
        ),

        const SizedBox(height: 14),

        _fieldLabel('رقم الترخيص'),
        const SizedBox(height: 7),
        _buildTextField(
          controller: licensedOperatorController,
          hint: 'أدخل رقم الترخيص',
          icon: Icons.verified_outlined,
          locked: _signupInfoLocked,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال رقم الترخيص';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHallsSection() {
    return _buildFormSection(
      title: 'أضف القاعات والخدمات المتوفرة',
      icon: Icons.home_work_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الخدمات التي تقدمها',
                    style: TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    halls.isEmpty
                        ? 'لم تتم إضافة أي خدمة بعد'
                        : '${halls.length} خدمات مضافة',
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 11,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showHallEditor,
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'إضافة',
                style: TextStyle(
                  fontFamily: 'LibertinusMath',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (halls.isEmpty)
          _buildEmptyHallCard()
        else
          ...List.generate(
            halls.length,
                (index) => _buildHallSummaryCard(
              halls[index],
              index,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyHallCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Icon(
            Icons.home_work_outlined,
            color: navy.withOpacity(0.45),
            size: 42,
          ),
          const SizedBox(height: 9),
          const Text(
            'لم تتم إضافة خدمة بعد',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'LibertinusMath',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'اضغط على إضافة لإدخال القاعة والأسعار.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHallSummaryCard(
      Map<String, dynamic> hall,
      int index,
      ) {
    final pricing = (hall['pricing'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final includedItems = List<String>.from(
      hall['includedItems'] as List? ?? [],
    );

    final services = List<String>.from(
      hall['services'] as List? ?? [],
    );

    final occasions = (hall['occasions'] as List? ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: softBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: navy.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  color: navy,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  hall['name']?.toString() ?? 'قاعة',
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
              ),

              IconButton(
                onPressed: () => _showHallEditor(
                  existingHall: hall,
                  existingIndex: index,
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: gold,
                  size: 20,
                ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    halls.removeAt(index);
                  });
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: red,
                  size: 20,
                ),
              ),
            ],
          ),

          if (pricing.isNotEmpty) ...[
            const SizedBox(height: 12),

            const Text(
              'الأسعار',
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'LibertinusMath',
              ),
            ),

            const SizedBox(height: 7),

            ...pricing.take(3).map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['peopleRange']?.toString() ?? '',
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 11,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                    ),
                    Text(
                      _formatPrice(item['price']),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (pricing.length > 3)
              Text(
                '+ ${pricing.length - 3} فئات أخرى',
                style: const TextStyle(
                  color: gold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
          ],

          if (includedItems.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: includedItems.map(
                    (item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: green.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: green,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],

          if (services.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: services.map(
                    (service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: green,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'LibertinusMath',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ],

          if (occasions.isNotEmpty) ...[
            const SizedBox(height: 10),

            const Text(
              'المناسبات والأسعار الخاصة',
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'LibertinusMath',
              ),
            ),

            const SizedBox(height: 7),

            ...occasions.map(
                  (item) {
                String name = '';
                String price = '';

                if (item is Map) {
                  name = item['name']?.toString() ?? '';
                  price = item['price']?.toString() ?? '';
                } else {
                  name = item.toString();
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: green,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: textGrey,
                            fontSize: 10,
                            fontFamily: 'LibertinusMath',
                          ),
                        ),
                      ),
                      if (price.isNotEmpty)
                        Text(
                          _formatPrice(price),
                          style: const TextStyle(
                            color: navy,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LibertinusMath',
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showHallEditor({
    Map<String, dynamic>? existingHall,
    int? existingIndex,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _HallEditorDialog(
          capacityRanges: capacityRanges,
          includedOptions: includedOptions,
          serviceOptions: serviceOptions,
          occasionOptions: occasionOptions,
          existingHall: existingHall,
        );
      },
    );

    if (result == null) return;

    setState(() {
      if (existingIndex != null) {
        halls[existingIndex] = result;
      } else {
        halls.add(result);
      }
    });
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: softBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 13,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: navy,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: navy,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'LibertinusMath',
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool locked = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: locked,
      enableInteractiveSelection: !locked,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      validator: validator,
      onChanged: (_) {
        setState(() {});
      },
      style: TextStyle(
        color: locked ? textGrey : textDark,
        fontSize: 13,
        fontFamily: 'LibertinusMath',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: textGrey,
          fontSize: 12,
          fontFamily: 'LibertinusMath',
        ),
        prefixIcon: Icon(
          icon,
          color: navy,
          size: 20,
        ),
        suffixIcon: locked
            ? const Icon(
          Icons.lock_outline,
          size: 18,
          color: textGrey,
        )
            : null,
        filled: true,
        fillColor: locked
            ? Colors.grey.shade200
            : cream.withOpacity(0.55),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: softBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: softBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: locked ? softBorder : gold,
            width: locked ? 1 : 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: red,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
    String? hint,
    bool locked = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: locked
            ? Colors.grey.shade200
            : cream.withOpacity(0.55),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: softBorder),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: Icon(
          locked
              ? Icons.lock_outline
              : Icons.keyboard_arrow_down_rounded,
          color: locked ? textGrey : navy,
          size: locked ? 18 : 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        hint: hint == null
            ? null
            : Text(
          hint,
          style: const TextStyle(
            color: textGrey,
            fontSize: 12,
            fontFamily: 'LibertinusMath',
          ),
        ),
        style: TextStyle(
          color: locked ? textGrey : textDark,
          fontSize: 12,
          fontFamily: 'LibertinusMath',
        ),
        items: items.map(
              (item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: navy,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 12,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        onChanged: locked ? null : onChanged,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _saveProfile,
        icon: Icon(
          widget.isEditing
              ? Icons.save_outlined
              : Icons.check_circle_outline,
          size: 21,
        ),
        label: Text(
          widget.isEditing
              ? 'حفظ التعديلات'
              : 'حفظ الملف الشخصي',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'LibertinusMath',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: navy.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final providerName = providerNameController.text.trim();
    final providerPhone = providerPhoneController.text.trim();
    final providerEmail = providerEmailController.text.trim();
    final businessName = serviceNameController.text.trim();
    final address = addressController.text.trim();
    final description = descriptionController.text.trim();
    final licensedOperatorNumber =
    licensedOperatorController.text.trim();

    final location = selectedLocation ?? '';
    final serviceType = selectedServiceType;

    final hallsCopy = _deepCopyHalls(halls);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SupplierDashboardScreen(
            providerName: providerName,
            providerPhone: providerPhone,
            providerEmail: providerEmail,
            businessName: businessName,
            serviceType: serviceType,
            location: location,
            address: address,
            description: description,
            halls: hallsCopy,
            licensedOperatorNumber: licensedOperatorNumber,
          );
        },
      ),
    );
  }

  String _formatPrice(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '—';
    }

    final number = double.tryParse(value.toString());

    if (number == null) {
      return '${value.toString()} ₪';
    }

    if (number == number.roundToDouble()) {
      return '${number.toInt()} ₪';
    }

    return '${number.toStringAsFixed(2)} ₪';
  }
}

// ===========================================================================
// HALL EDITOR
// ===========================================================================

class _HallEditorDialog extends StatefulWidget {
  final List<String> capacityRanges;
  final List<String> includedOptions;
  final List<String> serviceOptions;
  final List<String> occasionOptions;
  final Map<String, dynamic>? existingHall;

  const _HallEditorDialog({
    required this.capacityRanges,
    required this.includedOptions,
    required this.serviceOptions,
    required this.occasionOptions,
    this.existingHall,
  });

  @override
  State<_HallEditorDialog> createState() =>
      _HallEditorDialogState();
}

class _HallEditorDialogState
    extends State<_HallEditorDialog> {
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

  final Map<String, TextEditingController>
  occasionPriceControllers = {};

  final List<Map<String, dynamic>> hospitalityItems = [];

  bool get isEditing => widget.existingHall != null;

  @override
  void initState() {
    super.initState();

    final hall = widget.existingHall;

    nameController = TextEditingController(
      text: hall?['name']?.toString() ?? '',
    );

    final pricing = (hall?['pricing'] as List? ?? [])
        .whereType<Map>()
        .map(
          (item) => Map<String, dynamic>.from(item),
    )
        .toList();

    for (final range in widget.capacityRanges) {
      pricingControllers[range] =
          TextEditingController();

      final matching = pricing.where(
            (item) =>
        item['peopleRange']?.toString() == range,
      );

      if (matching.isNotEmpty) {
        selectedRanges.add(range);

        pricingControllers[range]!.text =
            matching.first['price']?.toString() ?? '';
      }
    }

    selectedIncludedItems.addAll(
      List<String>.from(
        hall?['includedItems'] as List? ?? [],
      ),
    );

    selectedServices.addAll(
      List<String>.from(
        hall?['services'] as List? ?? [],
      ),
    );

    final savedOccasions =
        hall?['occasions'] as List? ?? [];

    for (final occasion in widget.occasionOptions) {
      occasionPriceControllers[occasion] =
          TextEditingController();

      for (final item in savedOccasions) {
        if (item is Map) {
          final name = item['name']?.toString();

          if (name == occasion) {
            selectedOccasions.add(occasion);

            occasionPriceControllers[occasion]!.text =
                item['price']?.toString() ?? '';

            break;
          }
        } else if (item.toString() == occasion) {
          selectedOccasions.add(occasion);
          break;
        }
      }
    }

    hospitalityItems.addAll(
      (hall?['hospitality'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) =>
        Map<String, dynamic>.from(item),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();

    for (final controller
    in pricingControllers.values) {
      controller.dispose();
    }

    for (final controller
    in occasionPriceControllers.values) {
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
          horizontal: 12,
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: SizedBox(
          width: 650,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),

              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    10,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
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
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        16,
      ),
      decoration: const BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: gold,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_work_outlined,
              color: navy,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              isEditing
                  ? 'تعديل القاعة'
                  : 'إضافة القاعة وخدماتها',
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
            icon: const Icon(
              Icons.close,
              color: Colors.white70,
            ),
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
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
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
              border: Border.all(
                color: gold.withOpacity(0.25),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.groups_outlined,
                  color: navy,
                  size: 19,
                ),
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

          ...widget.capacityRanges
              .map(_buildCapacityRow),
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
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
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
            children: widget.includedOptions
                .map(
                  (item) {
                final selected =
                selectedIncludedItems
                    .contains(item);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        selectedIncludedItems
                            .remove(item);
                      } else {
                        selectedIncludedItems
                            .add(item);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 160,
                    ),
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? navy
                          : Colors.white,
                      borderRadius:
                      BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? navy
                            : softBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Icon(
                          selected
                              ? Icons.check_circle
                              : Icons
                              .add_circle_outline,
                          size: 15,
                          color: selected
                              ? gold
                              : textGrey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : textDark,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w600,
                            fontFamily:
                            'LibertinusMath',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityRow(String range) {
    final selected =
    selectedRanges.contains(range);

    final controller =
    pricingControllers[range]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: selected
              ? gold.withOpacity(0.55)
              : softBorder,
        ),
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
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'السعر',
                suffixText: '₪',
                filled: true,
                fillColor: selected
                    ? cream
                    : Colors.grey.shade100,
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 9,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(9),
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
        children: widget.serviceOptions.map(
              (service) {
            final selected =
            selectedServices.contains(service);

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
          },
        ).toList(),
      ),
    );
  }

  Widget _buildOccasionsSection() {
    return _dialogSection(
      title: 'المناسبات والأسعار الخاصة',
      icon: Icons.celebration_outlined,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
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

          ...widget.occasionOptions.map(
                (occasion) {
              final selected =
              selectedOccasions.contains(
                occasion,
              );

              final controller =
              occasionPriceControllers[
              occasion]!;

              return Container(
                margin: const EdgeInsets.only(
                  bottom: 9,
                ),
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: selected
                      ? gold.withOpacity(0.07)
                      : Colors.white,
                  borderRadius:
                  BorderRadius.circular(13),
                  border: Border.all(
                    color: selected
                        ? gold.withOpacity(0.55)
                        : softBorder,
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      borderRadius:
                      BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          if (selected) {
                            selectedOccasions
                                .remove(occasion);
                            controller.clear();
                          } else {
                            selectedOccasions
                                .add(occasion);
                          }
                        });
                      },
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration:
                            const Duration(
                              milliseconds: 180,
                            ),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: selected
                                  ? navy
                                  : Colors.white,
                              borderRadius:
                              BorderRadius.circular(
                                7,
                              ),
                              border: Border.all(
                                color: selected
                                    ? navy
                                    : softBorder,
                                width: 1.3,
                              ),
                            ),
                            child: selected
                                ? const Icon(
                              Icons.check,
                              color: gold,
                              size: 17,
                            )
                                : null,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              occasion,
                              style: TextStyle(
                                color: selected
                                    ? navy
                                    : textDark,
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w600,
                                fontFamily:
                                'LibertinusMath',
                              ),
                            ),
                          ),

                          if (selected)
                            const Icon(
                              Icons.check_circle,
                              color: green,
                              size: 19,
                            ),
                        ],
                      ),
                    ),

                    if (selected) ...[
                      const SizedBox(height: 10),

                      TextField(
                        controller: controller,
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.right,
                        decoration:
                        InputDecoration(
                          labelText: 'السعر الخاص',
                          hintText: 'أدخل السعر',
                          suffixText: '₪',
                          prefixIcon:
                          const Icon(
                            Icons.payments_outlined,
                            color: navy,
                            size: 19,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              11,
                            ),
                            borderSide:
                            const BorderSide(
                              color: softBorder,
                            ),
                          ),
                          enabledBorder:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              11,
                            ),
                            borderSide:
                            const BorderSide(
                              color: softBorder,
                            ),
                          ),
                          focusedBorder:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              11,
                            ),
                            borderSide:
                            const BorderSide(
                              color: gold,
                              width: 1.4,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          color: navy,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                          'LibertinusMath',
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalitySection() {
    return _dialogSection(
      title: 'الضيافة',
      icon: Icons.local_cafe_outlined,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          if (hospitalityItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cream,
                borderRadius:
                BorderRadius.circular(12),
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
                final item =
                hospitalityItems[index];

                return Container(
                  margin:
                  const EdgeInsets.only(bottom: 7),
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: cream,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name']
                              ?.toString() ??
                              '',
                          style: const TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight:
                            FontWeight.bold,
                            fontFamily:
                            'LibertinusMath',
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          final result =
                          await showDialog<
                              Map<String,
                                  dynamic>>(
                            context: context,
                            builder: (_) =>
                                _HospitalityEditorDialog(
                                  capacityRanges:
                                  widget
                                      .capacityRanges,
                                  existingItem: item,
                                ),
                          );

                          if (result != null) {
                            setState(() {
                              hospitalityItems[
                              index] =
                                  result;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: gold,
                          size: 18,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            hospitalityItems
                                .removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: red,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 7),

          OutlinedButton.icon(
            onPressed: () async {
              final result =
              await showDialog<
                  Map<String, dynamic>>(
                context: context,
                builder: (_) =>
                    _HospitalityEditorDialog(
                      capacityRanges:
                      widget.capacityRanges,
                    ),
              );

              if (result != null) {
                setState(() {
                  hospitalityItems.add(result);
                });
              }
            },
            icon: const Icon(
              Icons.add,
              size: 18,
              color: navy,
            ),
            label: const Text(
              'إضافة ضيافة',
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.bold,
                fontFamily: 'LibertinusMath',
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: softBorder,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
              padding:
              const EdgeInsets.symmetric(
                vertical: 11,
              ),
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
        duration:
        const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? navy : Colors.white,
          borderRadius:
          BorderRadius.circular(10),
          border: Border.all(
            color: selected ? navy : softBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(
                Icons.check_circle,
                color: gold,
                size: 15,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              text,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : textDark,
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
        borderRadius:
        BorderRadius.circular(17),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: navy,
                size: 19,
              ),
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
      prefixIcon: Icon(
        icon,
        color: navy,
        size: 19,
      ),
      filled: true,
      fillColor: cream.withOpacity(0.55),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: softBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: softBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: gold,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _buildDialogActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () =>
                  Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: navy,
                side: const BorderSide(
                  color: softBorder,
                ),
                padding:
                const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily:
                  'LibertinusMath',
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _save,
              style:
              ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor:
                Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(13),
                ),
              ),
              child: Text(
                isEditing
                    ? 'حفظ التعديلات'
                    : 'إضافة القاعة',
                style: const TextStyle(
                  fontFamily:
                  'LibertinusMath',
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final name =
    nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إدخال اسم الخدمة',
            textAlign: TextAlign.right,
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final pricing =
    <Map<String, dynamic>>[];

    for (final range in selectedRanges) {
      final value =
      pricingControllers[range]!
          .text
          .trim();

      if (value.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'يرجى إدخال سعر لفئة "$range"',
              textAlign: TextAlign.right,
            ),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
        return;
      }

      pricing.add({
        'peopleRange': range,
        'price': value,
      });
    }

    if (pricing.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى تحديد فئة واحدة على الأقل وإدخال سعرها',
            textAlign: TextAlign.right,
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final occasions =
    <Map<String, dynamic>>[];

    for (final occasion
    in selectedOccasions) {
      final price =
      occasionPriceControllers[
      occasion]!
          .text
          .trim();

      if (price.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'يرجى إدخال سعر مناسبة "$occasion"',
              textAlign: TextAlign.right,
            ),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
        return;
      }

      occasions.add({
        'name': occasion,
        'price': price,
      });
    }

    Navigator.pop(
      context,
      {
        'name': name,
        'pricing': pricing,
        'includedItems':
        List<String>.from(
          selectedIncludedItems,
        ),
        'hospitality':
        hospitalityItems
            .map(
              (item) =>
          Map<String, dynamic>
              .from(item),
        )
            .toList(),
        'services':
        List<String>.from(
          selectedServices,
        ),
        'occasions': occasions,
      },
    );
  }
}

// ===========================================================================
// HOSPITALITY EDITOR
// ===========================================================================

class _HospitalityEditorDialog
    extends StatefulWidget {
  final List<String> capacityRanges;
  final Map<String, dynamic>? existingItem;

  const _HospitalityEditorDialog({
    required this.capacityRanges,
    this.existingItem,
  });

  @override
  State<_HospitalityEditorDialog> createState() =>
      _HospitalityEditorDialogState();
}

class _HospitalityEditorDialogState
    extends State<_HospitalityEditorDialog> {
  static const Color cream =
  Color(0xFFF3EDE2);
  static const Color navy =
  Color(0xFF1B2A4A);
  static const Color gold =
  Color(0xFFD4AF37);
  static const Color textDark =
  Color(0xFF202020);
  static const Color textGrey =
  Color(0xFF777777);
  static const Color softBorder =
  Color(0xFFE6E0D5);

  late final TextEditingController
  nameController;

  final Map<String, TextEditingController>
  controllers = {};

  final Set<String> selected = {};

  bool get isEditing =>
      widget.existingItem != null;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(
          text: widget.existingItem?['name']
              ?.toString() ??
              '',
        );

    for (final range
    in widget.capacityRanges) {
      controllers[range] =
          TextEditingController();
    }

    final pricing =
    (widget.existingItem?['pricing']
    as List? ??
        [])
        .whereType<Map>()
        .map(
          (item) =>
      Map<String, dynamic>
          .from(item),
    )
        .toList();

    for (final item in pricing) {
      final range =
      item['peopleRange']?.toString();

      if (range != null &&
          controllers.containsKey(range)) {
        selected.add(range);

        controllers[range]!.text =
            item['price']?.toString() ??
                '';
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();

    for (final controller
    in controllers.values) {
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
        insetPadding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 25,
        ),
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(22),
        ),
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth: 520,
            maxHeight: 650,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Container(
                padding:
                const EdgeInsets.all(17),
                decoration:
                const BoxDecoration(
                  color: navy,
                  borderRadius:
                  BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .local_cafe_outlined,
                      color: gold,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        isEditing
                            ? 'تعديل الضيافة'
                            : 'إضافة ضيافة',
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                          fontFamily:
                          'LibertinusMath',
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () =>
                          Navigator.pop(
                            context,
                          ),
                      icon:
                      const Icon(
                        Icons.close,
                        color:
                        Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
                child:
                SingleChildScrollView(
                  padding:
                  const EdgeInsets.all(
                    15,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                    children: [
                      TextField(
                        controller:
                        nameController,
                        textAlign:
                        TextAlign.right,
                        decoration:
                        _inputDecoration(
                          hint:
                   'مثال : مكسرات ' ,
                          icon: Icons
                              .local_cafe_outlined,
                        ),
                        style:
                        const TextStyle(
                          color: textDark,
                          fontSize: 12,
                          fontFamily:
                          'LibertinusMath',
                        ),
                      ),

                      const SizedBox(
                          height: 15),

                      const Text(
                        'السعر حسب عدد الأشخاص',
                        style:
                        TextStyle(
                          color: navy,
                          fontSize: 13,
                          fontWeight:
                          FontWeight.bold,
                          fontFamily:
                          'LibertinusMath',
                        ),
                      ),

                      const SizedBox(
                          height: 8),

                      ...widget.capacityRanges
                          .map(
                        _buildRangeRow,
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding:
                const EdgeInsets.all(14),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child:
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(
                              context,
                            ),
                        style:
                        OutlinedButton
                            .styleFrom(
                          foregroundColor:
                          navy,
                          side:
                          const BorderSide(
                            color:
                            softBorder,
                          ),
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 12,
                          ),
                        ),
                        child:
                        const Text(
                          'إلغاء',
                          style:
                          TextStyle(
                            fontFamily:
                            'LibertinusMath',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        width: 10),

                    Expanded(
                      flex: 2,
                      child:
                      ElevatedButton(
                        onPressed: _save,
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          navy,
                          foregroundColor:
                          Colors.white,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 12,
                          ),
                        ),
                        child:
                        const Text(
                          'حفظ',
                          style:
                          TextStyle(
                            fontFamily:
                            'LibertinusMath',
                            fontWeight:
                            FontWeight.bold,
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

  Widget _buildRangeRow(
      String range) {
    final isSelected =
    selected.contains(range);

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 8,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? gold.withOpacity(0.6)
              : softBorder,
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
                    controllers[range]!
                        .clear();
                  }
                });
              },
            ),
          ),

          Expanded(
            child: Text(
              range,
              style:
              const TextStyle(
                color: textDark,
                fontSize: 10,
                fontWeight:
                FontWeight.w600,
                fontFamily:
                'LibertinusMath',
              ),
            ),
          ),

          SizedBox(
            width: 110,
            child: TextField(
              controller:
              controllers[range],
              enabled: isSelected,
              keyboardType:
              const TextInputType
                  .numberWithOptions(
                decimal: true,
              ),
              textAlign:
              TextAlign.center,
              decoration:
              InputDecoration(
                hintText: 'السعر',
                suffixText: '₪',
                filled: true,
                fillColor: isSelected
                    ? cream
                    : Colors
                    .grey
                    .shade100,
                contentPadding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 7,
                  vertical: 9,
                ),
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    9,
                  ),
                  borderSide:
                  BorderSide.none,
                ),
              ),
              style:
              const TextStyle(
                color: navy,
                fontSize: 11,
                fontWeight:
                FontWeight.bold,
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
      hintStyle:
      const TextStyle(
        color: textGrey,
        fontSize: 11,
        fontFamily:
        'LibertinusMath',
      ),
      prefixIcon: Icon(
        icon,
        color: navy,
        size: 19,
      ),
      filled: true,
      fillColor:
      cream.withOpacity(0.55),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: softBorder,
        ),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: softBorder,
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: gold,
          width: 1.4,
        ),
      ),
    );
  }

  void _save() {
    final name =
    nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إدخال اسم الضيافة',
            textAlign: TextAlign.right,
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final pricing =
    <Map<String, dynamic>>[];

    for (final range in selected) {
      final price =
      controllers[range]!
          .text
          .trim();

      if (price.isNotEmpty) {
        pricing.add({
          'peopleRange': range,
          'price': price,
        });
      }
    }

    if (pricing.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إضافة سعر لفئة واحدة على الأقل',
            textAlign: TextAlign.right,
          ),
          behavior:
          SnackBarBehavior.floating,
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