class Data {
  static List<String> places = [
    'New Delhi',
    'Agra',
    'Jaipur',
    'Udaipur',
    'Panjim',
    'Almora',
    'Varanasi',
    'Jaisalmer',
    'Srinagar',
    'Leh',
    'Jodhpur',
    'Pune',
    'Aurangabad',
    'Darjeeling',
    'Nainital',
    'Manali',
    'Kolkata',
    'Munnar',
    'Bhopal',
    'Amritsar',
    'Mumbai',
    'Kanyakumari',
    'Alappuzha',
    'Kodaikanal',
    'Pondicherry',
    'Mysuru (Mysore)',
    'Ooty',
    'Madikeri',
    'Hampi',
    'Hyderabad'
  ];

  static List<String> categories = [
    'Nature',
    'Historical',
    'Religious',
    'Architectural'
  ];

  static List<String> ageGrps = ['Youngster', 'Adult', 'Kid', 'Senior Citizen'];

  static Map<String, String> getAgeGrp = {
    'Youngster': 'Y',
    'Adult': 'A',
    'Kid': 'K',
    'Senior Citizen' : 'S'
  };

  Data() {
    places.sort();
    categories.sort();
  }
}
