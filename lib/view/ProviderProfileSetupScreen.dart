import 'package:flutter/material.dart';
import 'package:farah/services/api_service.dart';
import 'package:farah/utils/hall_shape.dart';
import '../widgets/provider_setup/hall_editor_dialog.dart';

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

  bool _isSaving = false;

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

    providerNameController = TextEditingController(text: widget.providerName);
    providerPhoneController =
        TextEditingController(text: widget.providerPhone);
    providerEmailController =
        TextEditingController(text: widget.providerEmail);
    serviceNameController =
        TextEditingController(text: widget.initialServiceName);
    addressController = TextEditingController(text: widget.initialAddress);
    descriptionController =
        TextEditingController(text: widget.initialDescription);
    licensedOperatorController =
        TextEditingController(text: widget.licensedOperatorNumber);

    selectedServiceType = serviceTypes.contains(widget.serviceType)
        ? widget.serviceType
        : serviceTypes.first;

    selectedLocation = locations.contains(widget.initialLocation)
        ? widget.initialLocation
        : null;

    halls = _normalizeHallsList(widget.initialHalls);
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

  List<Map<String, dynamic>> _normalizeHallsList(List<dynamic> rawList) {
    return HallShape.normalizeList(rawList);
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
            widget.isEditing ? 'تعديل الملف الشخصي' : 'مرحباً بك في فرح زون !',
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
            widget.providerName,
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
            widget.providerEmail,
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
                widget.initialLocation ?? 'اختر الموقع',
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 11,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
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
              onPressed: () => _showHallEditor(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'إضافة',
                style: TextStyle(fontFamily: 'LibertinusMath'),
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
            (index) => _buildHallSummaryCard(halls[index], index),
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
    final pricing = (hall['pricing'] as List? ??
            hall['prices'] as List? ??
            hall['Prices'] as List? ??
            [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final includedItems = List<String>.from(
      hall['includedItems'] as List? ?? hall['IncludedItems'] as List? ?? [],
    );

    final services = List<String>.from(
      hall['services'] as List? ?? hall['Services'] as List? ?? [],
    );

    final occasions = (hall['occasions'] as List? ??
        hall['Occasions'] as List? ??
        []);

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
                  hall['name']?.toString() ?? hall['Name']?.toString() ?? 'قاعة',
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
                            item['peopleRange']?.toString() ??
                                item['capacityRange']?.toString() ??
                                '',
                            style: const TextStyle(
                              color: textGrey,
                              fontSize: 11,
                              fontFamily: 'LibertinusMath',
                            ),
                          ),
                        ),
                        Text(
                          _formatPrice(item['price'] ?? item['Price']),
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
        return HallEditorDialog(
          capacityRanges: capacityRanges,
          includedOptions: includedOptions,
          serviceOptions: serviceOptions,
          occasionOptions: occasionOptions,
          existingHall: existingHall,
        );
      },
    );

    if (result == null) return;

    final hall = HallShape.normalize(result);

    setState(() {
      if (existingIndex != null) {
        halls[existingIndex] = hall;
      } else {
        halls.add(hall);
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
                child: Icon(icon, color: navy, size: 20),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      validator: validator,
      style: const TextStyle(
        color: textDark,
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
        prefixIcon: Icon(icon, color: navy, size: 20),
        filled: true,
        fillColor: cream.withOpacity(0.55),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: softBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: softBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: red),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cream.withOpacity(0.55),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: softBorder),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: navy,
          size: 24,
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
        style: const TextStyle(
          color: textDark,
          fontSize: 12,
          fontFamily: 'LibertinusMath',
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Icon(icon, color: navy, size: 20),
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
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : _saveProfile,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                widget.isEditing
                    ? Icons.save_outlined
                    : Icons.check_circle_outline,
                size: 21,
              ),
        label: Text(
          _isSaving
              ? 'جاري الحفظ...'
              : widget.isEditing
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
          disabledBackgroundColor: navy.withOpacity(0.55),
          disabledForegroundColor: Colors.white70,
          elevation: 4,
          shadowColor: navy.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final providerName = providerNameController.text.trim();
    final providerPhone = providerPhoneController.text.trim();
    final providerEmail = providerEmailController.text.trim();
    final businessName = serviceNameController.text.trim();
    final address = addressController.text.trim();
    final description = descriptionController.text.trim();
    final licensedOperatorNumber = licensedOperatorController.text.trim();

    final location = selectedLocation ?? '';
    final serviceType = selectedServiceType;

    final hallsCopy = HallShape.normalizeList(halls);

    try {
      await ApiService.saveProviderProfile(
        providerName: providerName,
        providerPhone: providerPhone,
        businessName: businessName,
        serviceType: serviceType,
        location: location,
        address: address,
        description: description,
        licenseNumber: licensedOperatorNumber,
        halls: hallsCopy,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: green, size: 26),
              SizedBox(width: 8),
              Text(
                'نجاح الحفظ',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),
          content: const Text(
            'تم حفظ البيانات والتعديلات بنجاح!',
            style: TextStyle(
              color: textDark,
              fontFamily: 'LibertinusMath',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'حسناً',
                style: TextStyle(
                  fontFamily: 'LibertinusMath',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (!mounted) return;

      Navigator.pop(context, {
        'providerName': providerName,
        'providerPhone': providerPhone,
        'providerEmail': providerEmail,
        'businessName': businessName,
        'serviceType': serviceType,
        'location': location,
        'address': address,
        'description': description,
        'licensedOperatorNumber': licensedOperatorNumber,
        'halls': hallsCopy,
      });
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message, textAlign: TextAlign.right),
            behavior: SnackBarBehavior.floating,
            backgroundColor: red,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر الحفظ في السيرفر. يرجى التأكد من تشغيل الباك إند',
              textAlign: TextAlign.right,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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