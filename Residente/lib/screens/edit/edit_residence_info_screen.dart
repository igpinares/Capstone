import 'package:flutter/material.dart';
import '../../models/registration_data.dart';
import '../../utils/validators.dart';
import '../../utils/responsive.dart';

class EditResidenceInfoScreen extends StatefulWidget {
  final RegistrationData registrationData;
  final Function(RegistrationData) onSave;

  const EditResidenceInfoScreen({
    super.key,
    required this.registrationData,
    required this.onSave,
  });

  @override
  State<EditResidenceInfoScreen> createState() =>
      _EditResidenceInfoScreenState();
}

class _EditResidenceInfoScreenState extends State<EditResidenceInfoScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Controladores de texto
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _mainPhoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();

  // Variables para la vivienda
  String? _selectedHousingType;
  String? _numberOfFloors;
  String? _selectedMaterial;
  String? _selectedCondition;

  bool _showManualCoordinates = false;
  bool _isLoading = false;

  final List<String> _housingTypes = [
    'Casa',
    'Departamento',
    'Empresa',
    'Local comercial',
    'Oficina',
    'Bodega',
    'Otro',
  ];

  final List<int> _floorOptions = List.generate(62, (index) => index + 1);

  final List<String> _materials = [
    'Hormigón/Concreto',
    'Ladrillo',
    'Madera',
    'Adobe',
    'Metal',
    'Material ligero',
    'Mixto',
    'Otro',
  ];

  final List<String> _conditions = [
    'Excelente',
    'Bueno',
    'Regular',
    'Malo',
    'Muy malo',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Inicializar controladores de domicilio
    _addressController.text = widget.registrationData.address ?? '';
    _latitudeController.text =
        widget.registrationData.latitude?.toString() ?? '';
    _longitudeController.text =
        widget.registrationData.longitude?.toString() ?? '';
    _mainPhoneController.text = widget.registrationData.mainPhone ?? '';
    _altPhoneController.text = widget.registrationData.alternatePhone ?? '';

    if (_latitudeController.text.isNotEmpty ||
        _longitudeController.text.isNotEmpty) {
      _showManualCoordinates = true;
    }

    // Inicializar variables de vivienda
    _selectedHousingType = widget.registrationData.housingType;
    _numberOfFloors = widget.registrationData.numberOfFloors?.toString();
    _selectedMaterial = widget.registrationData.constructionMaterial;
    _selectedCondition = widget.registrationData.housingCondition;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _mainPhoneController.dispose();
    _altPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Guardar datos del domicilio
      widget.registrationData.address = _addressController.text.trim();
      widget.registrationData.latitude = _latitudeController.text.isNotEmpty
          ? double.tryParse(_latitudeController.text)
          : null;
      widget.registrationData.longitude = _longitudeController.text.isNotEmpty
          ? double.tryParse(_longitudeController.text)
          : null;
      widget.registrationData.mainPhone = _mainPhoneController.text.trim();
      widget.registrationData.alternatePhone = _altPhoneController.text.trim();

      // Guardar datos de la vivienda
      widget.registrationData.housingType = _selectedHousingType;
      widget.registrationData.numberOfFloors = _numberOfFloors != null
          ? int.parse(_numberOfFloors!)
          : null;
      widget.registrationData.constructionMaterial = _selectedMaterial;
      widget.registrationData.housingCondition = _selectedCondition;

      // Simular guardado
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        widget.onSave(widget.registrationData);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Información actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context) || 
                      ResponsiveHelper.isDesktop(context);
    final padding = ResponsiveHelper.getResponsivePadding(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: Text(
          'Editar Información',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 16,
            ),
          ),
          tabs: const [
            Tab(text: 'Domicilio', icon: Icon(Icons.location_on)),
            Tab(text: 'Vivienda', icon: Icon(Icons.home)),
          ],
        ),
      ),
      body: ResponsiveContainer(
        maxWidth: isTablet ? 800 : null,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildResidenceTab(),
                  _buildHousingTab(),
                ],
              ),
            ),

            // Botones
            Container(
              padding: padding,
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
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveHelper.isTablet(context) ? 18 : 16,
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveHelper.isTablet(context) ? 18 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Guardar cambios',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 18,
                                ),
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
    );
  }

  Widget _buildResidenceTab() {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    
    return SingleChildScrollView(
      padding: padding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Domicilio',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Actualiza la dirección y contactos de emergencia',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 16,
                ),
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.isTablet(context) ? 32 : 24,
            ),

            // Dirección
            TextFormField(
              controller: _addressController,
              validator: Validators.validateAddress,
              decoration: InputDecoration(
                labelText: 'Dirección completa *',
                hintText: 'Calle, número, comuna, ciudad',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar/ocultar coordenadas manuales
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showManualCoordinates = !_showManualCoordinates;
                });
              },
              icon: Icon(
                _showManualCoordinates
                    ? Icons.expand_less
                    : Icons.expand_more,
              ),
              label: Text(
                _showManualCoordinates
                    ? 'Ocultar coordenadas manuales'
                    : 'Ingresar coordenadas manualmente (opcional)',
              ),
            ),

            if (_showManualCoordinates) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      validator: (value) =>
                          Validators.validateCoordinate(value, true),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Latitud',
                        hintText: '-33.4489',
                        prefixIcon: const Icon(Icons.location_searching),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      validator: (value) =>
                          Validators.validateCoordinate(value, false),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Longitud',
                        hintText: '-70.6693',
                        prefixIcon: const Icon(Icons.location_searching),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            const Text(
              'Teléfonos de emergencia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Teléfono principal
            TextFormField(
              controller: _mainPhoneController,
              validator: Validators.validatePhone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono principal *',
                hintText: '+56 9 1234 5678',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),

            // Teléfono alternativo
            TextFormField(
              controller: _altPhoneController,
              validator: Validators.validatePhoneOptional,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono alternativo (opcional)',
                hintText: '+56 9 8765 4321',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHousingTab() {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalles de la Vivienda',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Actualiza las características de tu vivienda',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 16,
              ),
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.isTablet(context) ? 32 : 24,
          ),

          // Tipo de vivienda
          DropdownButtonFormField<String>(
            initialValue: _selectedHousingType,
            decoration: InputDecoration(
              labelText: 'Tipo de vivienda *',
              hintText: 'Selecciona el tipo de vivienda',
              prefixIcon: const Icon(Icons.home_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: _housingTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedHousingType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona el tipo de vivienda';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Número de pisos
          DropdownButtonFormField<String>(
            initialValue: _numberOfFloors,
            decoration: InputDecoration(
              labelText: 'Número de pisos *',
              hintText: 'Indica la cantidad total de pisos de la vivienda',
              prefixIcon: const Icon(Icons.layers_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: _floorOptions.map((floors) {
              return DropdownMenuItem(
                value: floors.toString(),
                child: Text(
                  '$floors ${floors == 1 ? 'piso' : 'pisos'}',
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _numberOfFloors = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona el número de pisos';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Material de construcción
          DropdownButtonFormField<String>(
            initialValue: _selectedMaterial,
            decoration: InputDecoration(
              labelText: 'Material principal de construcción *',
              hintText: 'Selecciona el material',
              prefixIcon: const Icon(Icons.construction_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: _materials.map((material) {
              return DropdownMenuItem(
                value: material,
                child: Text(material),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMaterial = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona el material';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Estado de la vivienda
          DropdownButtonFormField<String>(
            initialValue: _selectedCondition,
            decoration: InputDecoration(
              labelText: 'Estado general de la vivienda *',
              hintText: 'Selecciona el estado',
              prefixIcon: const Icon(
                Icons.home_repair_service_outlined,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: _conditions.map((condition) {
              return DropdownMenuItem(
                value: condition,
                child: Text(condition),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCondition = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona el estado';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Nota informativa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Esta información ayudará a los bomberos a prepararse mejor para una emergencia en tu domicilio',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

