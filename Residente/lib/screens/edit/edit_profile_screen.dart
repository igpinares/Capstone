import 'package:flutter/material.dart';
import '../../models/registration_data.dart';
import '../../utils/validators.dart';
import '../../utils/responsive.dart';

class EditProfileScreen extends StatefulWidget {
  final RegistrationData registrationData;
  final Function(RegistrationData) onSave;

  const EditProfileScreen({
    super.key,
    required this.registrationData,
    required this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Controladores
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _otherConditionController =
      TextEditingController();

  List<String> _selectedConditions = [];
  bool _isLoading = false;

  final Map<String, List<String>> _conditionCategories = {
    'Enfermedades Crónicas': [
      'Diabetes',
      'Hipertensión',
      'Problemas cardíacos',
      'Enfermedades respiratorias',
      'Epilepsia o convulsiones',
      'Cáncer en tratamiento',
      'Enfermedades mentales',
    ],
    'Movilidad y Sentidos': [
      'Persona postrada',
      'Problemas de audición',
      'Problemas de visión',
      'Vértigo o pérdida de equilibrio',
      'Dificultad para moverse o caminar',
      'Asma o problemas para respirar',
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _rutController.text = widget.registrationData.rut ?? '';
    _phoneController.text = widget.registrationData.phoneNumber ?? '';
    _birthYearController.text =
        widget.registrationData.birthYear?.toString() ?? '';
    _selectedConditions = List.from(widget.registrationData.medicalConditions);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _rutController.dispose();
    _phoneController.dispose();
    _birthYearController.dispose();
    _otherConditionController.dispose();
    super.dispose();
  }

  void _addOtherCondition() {
    final condition = _otherConditionController.text.trim();
    if (condition.isNotEmpty && !_selectedConditions.contains(condition)) {
      setState(() {
        _selectedConditions.add(condition);
        _otherConditionController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Condición "$condition" agregada'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } else if (_selectedConditions.contains(condition)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta condición ya fue agregada'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      widget.registrationData.rut = _rutController.text.trim();
      widget.registrationData.phoneNumber = _phoneController.text.trim();
      widget.registrationData.birthYear = int.parse(_birthYearController.text);

      // Calcular edad aproximada
      final currentYear = DateTime.now().year;
      widget.registrationData.age =
          currentYear - widget.registrationData.birthYear!;

      widget.registrationData.medicalConditions = _selectedConditions;

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
            content: Text('Perfil actualizado correctamente'),
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
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        title: Text(
          'Editar Perfil',
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
            Tab(text: 'Datos Personales', icon: Icon(Icons.person)),
            Tab(text: 'Condiciones Médicas', icon: Icon(Icons.medical_services)),
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
                  _buildPersonalDataTab(),
                  _buildMedicalConditionsTab(),
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
                          vertical: isTablet ? 18 : 16,
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
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 18 : 16,
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

  Widget _buildPersonalDataTab() {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    final isTablet = ResponsiveHelper.isTablet(context) ||
        ResponsiveHelper.isDesktop(context);

    return SingleChildScrollView(
      padding: padding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos Personales',
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
              'Actualiza tu información personal',
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
            SizedBox(height: isTablet ? 32 : 24),

            // RUT
            TextFormField(
              controller: _rutController,
              validator: Validators.validateRut,
              decoration: InputDecoration(
                labelText: 'RUT *',
                hintText: '12.345.678-9',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),

            // Teléfono
            TextFormField(
              controller: _phoneController,
              validator: Validators.validatePhone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono *',
                hintText: '+56 9 1234 5678',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),

            // Año de nacimiento
            TextFormField(
              controller: _birthYearController,
              validator: Validators.validateBirthYear,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Año de nacimiento *',
                hintText: '1985',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),

            const SizedBox(height: 24),

            // Nota informativa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.purple.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Esta información será utilizada en caso de emergencia. Mantén tus datos actualizados.',
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
      ),
    );
  }

  Widget _buildMedicalConditionsTab() {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    final isTablet = ResponsiveHelper.isTablet(context) ||
        ResponsiveHelper.isDesktop(context);

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Condiciones Médicas',
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
            'Selecciona todas las condiciones que apliquen',
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
          SizedBox(height: isTablet ? 16 : 12),

          // Nota importante
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ingrese solo condiciones relevantes para el rescate; no registre enfermedades o datos sensibles que no sean útiles para la emergencia.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tabs de categorías
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.purple.shade700,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: Colors.purple.shade700,
                  tabs: const [
                    Tab(text: 'Enfermedades Crónicas'),
                    Tab(text: 'Movilidad y Sentidos'),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: _conditionCategories.entries.map((entry) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: entry.value.map((condition) {
                          final isSelected =
                              _selectedConditions.contains(condition);
                          return CheckboxListTile(
                            title: Text(condition),
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedConditions.add(condition);
                                } else {
                                  _selectedConditions.remove(condition);
                                }
                              });
                            },
                            activeColor: Colors.purple.shade700,
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Condiciones seleccionadas
          if (_selectedConditions.isNotEmpty) ...[
            const Text(
              'Condiciones seleccionadas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedConditions.map((condition) {
                return Chip(
                  label: Text(condition),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _selectedConditions.remove(condition);
                    });
                  },
                  backgroundColor: Colors.purple.shade50,
                  labelStyle: TextStyle(color: Colors.purple.shade700),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Otra condición especial
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _otherConditionController,
                  decoration: InputDecoration(
                    labelText: 'Otra condición especial (opcional)',
                    hintText: 'Ingrese otra condición no listada',
                    prefixIcon: const Icon(Icons.medical_services_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onFieldSubmitted: (_) => _addOtherCondition(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _addOtherCondition,
                  tooltip: 'Agregar condición',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Nota adicional
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ingrese solo condiciones relevantes para el rescate; no registre enfermedades o datos sensibles que no sean útiles para la emergencia.',
                    style: TextStyle(
                      fontSize: 12,
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

