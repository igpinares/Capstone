import 'package:flutter/material.dart';
import '../../models/registration_data.dart';

class Step4HousingDetails extends StatefulWidget {
  final RegistrationData registrationData;
  final VoidCallback onPrevious;
  final Future<void> Function() onComplete;

  const Step4HousingDetails({
    super.key,
    required this.registrationData,
    required this.onPrevious,
    required this.onComplete,
  });

  @override
  State<Step4HousingDetails> createState() => _Step4HousingDetailsState();
}

class _Step4HousingDetailsState extends State<Step4HousingDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _specialInstructionsController =
      TextEditingController();

  String? _selectedHousingType;
  int? _selectedNumberOfFloors;
  String? _selectedConstructionMaterial;
  String? _selectedHousingCondition;

  final List<String> _housingTypes = [
    'Casa',
    'Departamento',
    'Cabaña',
    'Mediagua',
    'Otro',
  ];

  final List<int> _floorOptions = List.generate(62, (index) => index + 1);

  final List<String> _constructionMaterials = [
    'Hormigón armado',
    'Albañilería',
    'Madera',
    'Adobe',
    'Mixto',
    'Otro',
  ];

  final List<String> _housingConditions = [
    'Excelente',
    'Bueno',
    'Regular',
    'Malo',
    'Muy malo',
  ];

  @override
  void initState() {
    super.initState();
    _selectedHousingType = widget.registrationData.housingType;
    _selectedNumberOfFloors = widget.registrationData.numberOfFloors;
    _selectedConstructionMaterial =
        widget.registrationData.constructionMaterial;
    _selectedHousingCondition = widget.registrationData.housingCondition;
    _specialInstructionsController.text =
        widget.registrationData.specialInstructions ?? '';
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  String? _validateSelection(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor selecciona $fieldName';
    }
    return null;
  }

  void _handleComplete() {
    if (_formKey.currentState!.validate()) {
      widget.registrationData.housingType = _selectedHousingType;
      widget.registrationData.numberOfFloors = _selectedNumberOfFloors;
      widget.registrationData.constructionMaterial =
          _selectedConstructionMaterial;
      widget.registrationData.housingCondition = _selectedHousingCondition;
      widget.registrationData.specialInstructions =
          _specialInstructionsController.text.trim();

      // Mostrar resumen de los datos antes de enviar
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Registro'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¿Deseas registrar tu domicilio con la siguiente información?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSummaryItem('Email', widget.registrationData.email ?? ''),
                _buildSummaryItem('RUT', widget.registrationData.rut ?? ''),
                _buildSummaryItem(
                  'Teléfono del titular',
                  widget.registrationData.phoneNumber ?? '',
                ),
                _buildSummaryItem(
                  'Año de nacimiento',
                  widget.registrationData.birthYear?.toString() ?? '',
                ),
                _buildSummaryItem(
                  'Dirección',
                  widget.registrationData.address ?? '',
                ),
                _buildSummaryItem(
                  'Teléfono de emergencia',
                  widget.registrationData.mainPhone ?? '',
                ),
                _buildSummaryItem(
                  'Tipo de vivienda',
                  _selectedHousingType ?? '',
                ),
                _buildSummaryItem(
                  'Pisos',
                  _selectedNumberOfFloors?.toString() ?? '',
                ),
                _buildSummaryItem(
                  'Material',
                  _selectedConstructionMaterial ?? '',
                ),
                _buildSummaryItem('Estado', _selectedHousingCondition ?? ''),
                if (widget.registrationData.specialInstructions != null &&
                    widget.registrationData.specialInstructions!.isNotEmpty)
                  _buildSummaryItem(
                    'Instrucciones especiales',
                    widget.registrationData.specialInstructions ?? '',
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Revisar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitRegistration();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar y Registrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _submitRegistration() async {
    // Aquí iría la lógica para guardar en Supabase
    // Por ahora solo mostramos un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ ¡Registro completado exitosamente!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Llamar al callback de completado
    await widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles de la Vivienda',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Información adicional sobre la estructura de tu vivienda',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  // Tipo de vivienda
                  const Text(
                    'Tipo de vivienda *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedHousingType,
                    decoration: InputDecoration(
                      hintText: 'Selecciona el tipo de vivienda',
                      prefixIcon: const Icon(Icons.home_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) =>
                        _validateSelection(value, 'el tipo de vivienda'),
                    items: _housingTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedHousingType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Número de pisos
                  const Text(
                    'Número de pisos *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedNumberOfFloors,
                    decoration: InputDecoration(
                      hintText: 'Selecciona el número de pisos',
                      prefixIcon: const Icon(Icons.layers_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) => value == null
                        ? 'Por favor selecciona el número de pisos'
                        : null,
                    items: _floorOptions.map((floors) {
                      return DropdownMenuItem(
                        value: floors,
                        child: Text(
                          '$floors ${floors == 1 ? 'piso' : 'pisos'}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedNumberOfFloors = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Material de construcción
                  const Text(
                    'Material de construcción *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedConstructionMaterial,
                    decoration: InputDecoration(
                      hintText: 'Selecciona el material principal',
                      prefixIcon: const Icon(Icons.construction_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) => _validateSelection(
                      value,
                      'el material de construcción',
                    ),
                    items: _constructionMaterials.map((material) {
                      return DropdownMenuItem(
                        value: material,
                        child: Text(material),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedConstructionMaterial = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Estado de la vivienda
                  const Text(
                    'Estado de la vivienda *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedHousingCondition,
                    decoration: InputDecoration(
                      hintText: 'Selecciona el estado general',
                      prefixIcon: const Icon(Icons.star_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) =>
                        _validateSelection(value, 'el estado de la vivienda'),
                    items: _housingConditions.map((condition) {
                      return DropdownMenuItem(
                        value: condition,
                        child: Row(
                          children: [
                            Text(condition),
                            const SizedBox(width: 8),
                            _getConditionIcon(condition),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedHousingCondition = value;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // Instrucciones especiales
                  const Text(
                    'Instrucciones especiales (opcional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _specialInstructionsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Información adicional relevante para bomberos (accesos especiales, llaves, etc.)',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.info_outlined),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Información adicional
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Esta información ayuda a los bomberos a evaluar riesgos y planificar mejor la respuesta en caso de emergencia.',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Botones
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onPrevious,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Anterior', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Completar Registro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getConditionIcon(String condition) {
    IconData icon;
    Color color;

    switch (condition) {
      case 'Excelente':
        icon = Icons.star;
        color = Colors.green;
        break;
      case 'Bueno':
        icon = Icons.star_half;
        color = Colors.lightGreen;
        break;
      case 'Regular':
        icon = Icons.star_border;
        color = Colors.orange;
        break;
      case 'Malo':
        icon = Icons.warning;
        color = Colors.deepOrange;
        break;
      case 'Muy malo':
        icon = Icons.dangerous;
        color = Colors.red;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(icon, size: 18, color: color);
  }
}
