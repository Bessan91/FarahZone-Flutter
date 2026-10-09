class HallShape {
  static Map<String, dynamic> normalize(Map<String, dynamic> hall) {
    final rawPrices = hall['prices'] ?? hall['Prices'] ?? hall['hallPrices'] ?? hall['HallPrices'] ?? hall['pricing'] ?? [];
    final pricing = (rawPrices as List).map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return {
        'peopleRange': map['peopleRange'] ?? map['PeopleRange'] ?? map['capacityRange'] ?? map['CapacityRange'] ?? map['dayOrSeason'] ?? map['DayOrSeason'] ?? '',
        'price': map['price'] ?? map['Price'] ?? 0,
      };
    }).toList();

    final rawHospitality = hall['hospitalities'] ?? hall['Hospitalities'] ?? hall['hospitality'] ?? [];
    final hospitality = (rawHospitality as List).map((item) {
      return Map<String, dynamic>.from(item as Map);
    }).toList();

    final rawOccasions = hall['occasions'] ?? hall['Occasions'] ?? hall['hallOccasions'] ?? [];
    final occasions = (rawOccasions as List).map((o) {
      if (o is Map) {
        final m = Map<String, dynamic>.from(o);
        return {
          'name': m['name'] ?? m['Name'] ?? m['occasionName'] ?? m['OccasionName'] ?? '',
          'price': m['price'] ?? m['Price'] ?? '',
        };
      }
      return {'name': o.toString(), 'price': ''};
    }).toList();

    return {
      'id': hall['id'] ?? hall['Id'],
      'name': hall['name'] ?? hall['Name'] ?? '',
      'pricing': pricing,
      'prices': pricing,
      'includedItems': List<String>.from(hall['includedItems'] ?? hall['IncludedItems'] ?? []),
      'services': List<String>.from(hall['services'] ?? hall['Services'] ?? []),
      'occasions': occasions,
      'hospitality': hospitality,
      'hospitalities': hospitality,
    };
  }

  static List<Map<String, dynamic>> normalizeList(List<dynamic> rawList) {
    return rawList.map((item) => normalize(Map<String, dynamic>.from(item as Map))).toList();
  }
}