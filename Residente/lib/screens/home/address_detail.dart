import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import 'emergency_map.dart';

class AddressDetailScreen extends StatefulWidget {
  final String addressId;

  const AddressDetailScreen({super.key, required this.addressId});

  @override
  State<AddressDetailScreen> createState() => _AddressDetailScreenState();
}

class _AddressDetailScreenState extends State<AddressDetailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _searchAddress() {
    if (_searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un domicilio'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    // Realizar búsqueda
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    
    // Datos de ejemplo
    final addressData = {
      'address': 'Av. Libertador 1234, Depto 5B, Las Condes, Santiago',
      'main_phone': '+56 9 1234 5678',
      'alt_phone': '+56 9 8765 4321',
      'housing_type': 'Departamento',
      'floor': '5',
      'construction_material': 'Hormigón/Concreto',
      'housing_condition': 'Bueno',
      'special_instructions':
          'Llave de emergencia con portero. Puerta blindada requiere herramientas especiales.',
      'last_update': '2024-01-15',
      'people_count': 4,
      'pets_count': 2,
      'special_conditions_count': 4,
    };

    final people = [
      {
        'name': 'Titular del domicilio',
        'age': 45,
        'rut': '12.345.678-9',
        'is_owner': true,
        'conditions': ['Diabetes', 'Problemas cardíacos'],
      },
      {
        'name': 'Persona 1',
        'age': 47,
        'conditions': ['Movilidad reducida'],
      },
      {
        'name': 'Persona 2',
        'age': 16,
        'conditions': ['Enfermedades respiratorias'],
      },
      {
        'name': 'Persona 3',
        'age': 72,
        'conditions': [
          'Adulto mayor (65+)',
          'Discapacidad sensorial',
          'Dispositivos médicos (oxígeno, etc.)',
          'Necesita ayuda para caminar',
        ],
      },
    ];

    final pets = [
      {
        'name': 'Max',
        'type': 'Perro',
        'size': 'Grande',
        'breed': 'Golden Retriever',
        'weight': '35kg',
      },
      {
        'name': 'Mimi',
        'type': 'Gato',
        'size': 'Pequeño',
        'breed': 'Siamés',
        'weight': '4kg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        title: Text(
          'Sistema de Emergencias',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
        ),
        toolbarHeight: ResponsiveHelper.getAppBarHeight(context),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: Colors.white, 
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 13,
                  tablet: 15,
                  desktop: 17,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ALERTA DE MODO EMERGENCIA
              Container(
                width: double.infinity,
                margin: ResponsiveHelper.getResponsiveMargin(context),
                padding: EdgeInsets.all(isTablet ? 28 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.red.shade800],
                  ),
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚨 MODO EMERGENCIA ACTIVO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Text(
                      'Este sistema proporciona información crítica para operaciones de rescate. Verifica siempre la información y mantén comunicación con el centro de comando.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
            ),

              // BÚSQUEDA
              Container(
                margin: ResponsiveHelper.getResponsiveMargin(context),
                padding: EdgeInsets.all(isTablet ? 28 : 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Búsqueda de Domicilio',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 10 : 6),
                    Text(
                      'Ingresa la dirección para obtener información crítica del domicilio',
                      style: TextStyle(
                        color: Colors.grey, 
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                    TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on,
                          size: isTablet ? 24 : 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 16,
                          vertical: isTablet ? 20 : 16,
                        ),
                      ),
                      onSubmitted: (_) => _searchAddress(),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: isTablet ? 56 : 48,
                            child: ElevatedButton(
                              onPressed: _searchAddress,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
                                ),
                              ),
                              child: Text(
                                'Buscar',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                          child: SizedBox(
                            height: isTablet ? 56 : 48,
                            child: OutlinedButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
                                ),
                              ),
                              child: Text(
                                'Limpiar',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

              SizedBox(height: isTablet ? 20 : 16),

              // RESUMEN CRÍTICO
              Container(
                margin: ResponsiveHelper.getResponsiveMargin(context),
                padding: EdgeInsets.all(isTablet ? 28 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.red.shade800],
                  ),
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen Crítico',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 18,
                          tablet: 22,
                          desktop: 26,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCriticalStat(
                        addressData['people_count'].toString(),
                        'Personas',
                        Icons.people,
                      ),
                      _buildCriticalStat(
                        addressData['pets_count'].toString(),
                        'Mascotas',
                        Icons.pets,
                      ),
                      _buildCriticalStat(
                        addressData['special_conditions_count'].toString(),
                        'Con condiciones',
                        Icons.medical_services,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // INFORMACIÓN DEL DOMICILIO
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del Domicilio',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 24),

                  // Dirección
                  _buildInfoSection(
                    'Dirección',
                    addressData['address'] as String,
                    Icons.location_on,
                  ),
                  const SizedBox(height: 20),

                  // Detalles de la Vivienda
                  const Text(
                    'Detalles de la Vivienda',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Tipo de vivienda',
                    addressData['housing_type'] as String,
                  ),
                  _buildDetailRow(
                    'Piso del departamento',
                    addressData['floor'] as String,
                  ),
                  _buildDetailRow(
                    'Material de construcción',
                    addressData['construction_material'] as String,
                  ),
                  _buildDetailRow(
                    'Estado de la vivienda',
                    addressData['housing_condition'] as String,
                  ),

                  const SizedBox(height: 20),

                  // Instrucciones Especiales
                  _buildInfoSection(
                    'Instrucciones Especiales',
                    addressData['special_instructions'] as String,
                    Icons.warning_amber,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.update, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Última actualización: ${addressData['last_update']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botón Ver en Mapa
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmergencyMapScreen(addressData: addressData),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Ver en Mapa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // INFORMACIÓN DE CONTACTO
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información de Contacto',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 24),
                  _buildContactRow(
                    'Contacto Principal',
                    addressData['main_phone'] as String,
                    Icons.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(
                    'Contacto Alternativo',
                    addressData['alt_phone'] as String,
                    Icons.phone_android,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // OCUPANTES DEL DOMICILIO CON TABS
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ocupantes del Domicilio',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Información detallada de personas y mascotas en la residencia',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue.shade700,
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorColor: Colors.blue.shade700,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(text: 'Personas (${people.length})'),
                        Tab(text: 'Mascotas (${pets.length})'),
                      ],
                    ),
                  ),

                  // Tab Content
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab Personas
                        ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: people.length,
                          itemBuilder: (context, index) {
                            return _buildPersonCard(people[index]);
                          },
                        ),

                        // Tab Mascotas
                        ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: pets.length,
                          itemBuilder: (context, index) {
                            return _buildPetCard(pets[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildCriticalStat(String value, String label, IconData icon) {
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
          child: Icon(
            icon, 
            color: Colors.white, 
            size: isTablet ? 36 : 28,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 22,
              tablet: 28,
              desktop: 32,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70, 
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 10,
              tablet: 12,
              desktop: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 15, height: 1.4)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(String label, String phone, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          phone,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPersonCard(Map<String, dynamic> person) {
    final isOwner = person['is_owner'] as bool? ?? false;
    final conditions = person['conditions'] as List<String>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOwner ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOwner ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  person['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (person['rut'] != null) ...[
            const SizedBox(height: 6),
            Text(
              'RUT: ${person['rut']}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            '${person['age']} años',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          if (conditions.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              ' Condiciones Médicas/Especiales:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: conditions.map((condition) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Text(
                    condition,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade900,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    final isPet = pet['type'] as String;
    final icon = isPet == 'Perro' ? Icons.pets : Icons.emoji_nature;
    final color = isPet == 'Perro' ? Colors.brown : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pet['type']} • ${pet['size']} • ${pet['breed']} • ${pet['weight']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
