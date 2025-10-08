class RegistrationData {
  // Paso 1: Crear Cuenta
  String? email;
  String? password;

  // Paso 2: Datos del Titular
  String? fullName;
  String? rut;
  String? phoneNumber;
  int? birthYear;
  int? age;
  List<String> medicalConditions = [];

  // Paso 3: Información de la Residencia
  String? address;
  double? latitude;
  double? longitude;
  String? mainPhone;
  String? alternatePhone;

  // Paso 4: Detalles de la Vivienda
  String? housingType;
  int? numberOfFloors;
  String? constructionMaterial;
  String? housingCondition;
  String? specialInstructions;

  RegistrationData();

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'rut': rut,
      'phone_number': phoneNumber,
      'birth_year': birthYear,
      'age': age,
      'medical_conditions': medicalConditions,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'main_phone': mainPhone,
      'alternate_phone': alternatePhone,
      'housing_type': housingType,
      'number_of_floors': numberOfFloors,
      'construction_material': constructionMaterial,
      'housing_condition': housingCondition,
      'special_instructions': specialInstructions,
    };
  }
}
