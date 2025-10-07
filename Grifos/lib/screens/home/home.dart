import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

// Modelo de Grifo
class Grifo {
  final String id;
  final String direccion;
  final String comuna;
  final String tipo;
  final String estado;
  final DateTime ultimaInspeccion;
  final String notas;
  final String reportadoPor;
  final DateTime fechaReporte;
  final double lat;
  final double lng;

  Grifo({
    required this.id,
    required this.direccion,
    required this.comuna,
    required this.tipo,
    required this.estado,
    required this.ultimaInspeccion,
    required this.notas,
    required this.reportadoPor,
    required this.fechaReporte,
    required this.lat,
    required this.lng,
  });
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final String? userEmail;

  const HomeScreen({Key? key, required this.onLogout, this.userEmail})
    : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filtroEstado = 'Todos';
  String busqueda = '';
  late String nombreUsuario;

  // Mock de datos
  List<Grifo> grifos = [
    Grifo(
      id: '1',
      direccion: 'Plaza Central',
      comuna: 'Maipú',
      tipo: 'Alto flujo',
      estado: 'Dañado',
      ultimaInspeccion: DateTime(2024, 1, 10),
      notas: 'Válvula dañada, requiere reparación urgente. No operativo.',
      reportadoPor: 'Teniente Silva',
      fechaReporte: DateTime(2024, 1, 10),
      lat: -33.5110,
      lng: -70.7580,
    ),
    Grifo(
      id: '2',
      direccion: 'Calle Los Aromos 123',
      comuna: 'Ñuñoa',
      tipo: 'Seco',
      estado: 'Sin verificar',
      ultimaInspeccion: DateTime(2023, 12, 20),
      notas:
          'Requiere inspección, reportado por vecinos como posiblemente dañado',
      reportadoPor: 'Llamada ciudadana',
      fechaReporte: DateTime(2024, 1, 8),
      lat: -33.4574,
      lng: -70.5945,
    ),
  ];

  List<Grifo> get grifosFiltrados {
    var resultado = grifos.where((grifo) {
      bool cumpleFiltro =
          filtroEstado == 'Todos' || grifo.estado == filtroEstado;
      bool cumpleBusqueda =
          busqueda.isEmpty ||
          grifo.direccion.toLowerCase().contains(busqueda.toLowerCase()) ||
          grifo.comuna.toLowerCase().contains(busqueda.toLowerCase());
      return cumpleFiltro && cumpleBusqueda;
    }).toList();
    return resultado;
  }

  Map<String, int> get estadisticas {
    return {
      'total': grifos.length,
      'operativos': grifos.where((g) => g.estado == 'Operativo').length,
      'dañados': grifos.where((g) => g.estado == 'Dañado').length,
      'mantenimiento': grifos.where((g) => g.estado == 'Mantenimiento').length,
      'sin_verificar': grifos.where((g) => g.estado == 'Sin verificar').length,
    };
  }

  Color getEstadoColor(String estado) {
    switch (estado) {
      case 'Operativo':
        return Colors.green;
      case 'Dañado':
        return Colors.red;
      case 'Mantenimiento':
        return Colors.orange;
      case 'Sin verificar':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void cambiarEstadoGrifo(String id, String nuevoEstado) {
    setState(() {
      final index = grifos.indexWhere((g) => g.id == id);
      if (index != -1) {
        final grifo = grifos[index];
        grifos.removeAt(index);
        grifos.insert(
          0,
          Grifo(
            id: grifo.id,
            direccion: grifo.direccion,
            comuna: grifo.comuna,
            tipo: grifo.tipo,
            estado: nuevoEstado,
            ultimaInspeccion: DateTime.now(),
            notas: grifo.notas,
            reportadoPor: grifo.reportadoPor,
            fechaReporte: grifo.fechaReporte,
            lat: grifo.lat,
            lng: grifo.lng,
          ),
        );
      }
    });
  }

  void navegarARegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RegistrarGrifoScreen(nombreUsuario: nombreUsuario),
      ),
    ).then((nuevoGrifo) {
      if (nuevoGrifo != null && nuevoGrifo is Grifo) {
        setState(() {
          grifos.insert(0, nuevoGrifo);
        });
      }
    });
  }

  void _cerrarSesion() {
    widget.onLogout();
  }

  @override
  void initState() {
    super.initState();
    nombreUsuario = widget.userEmail?.split('@').first ?? 'Usuario';
  }

  @override
  Widget build(BuildContext context) {
    final stats = estadisticas;
    final maxWidth = ResponsiveHelper.getMaxContentWidth(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sistema de Grifos',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con saludo
                Container(
                  width: double.infinity,
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: const EdgeInsets.all(20),
                    tablet: const EdgeInsets.all(30),
                    desktop: const EdgeInsets.all(40),
                  ),
                  color: Colors.blue[800],
                  child: Text(
                    'Bienvenido, $nombreUsuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 18,
                        tablet: 22,
                        desktop: 26,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Botón de registro
                Padding(
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: const EdgeInsets.all(16),
                    tablet: const EdgeInsets.all(20),
                    desktop: const EdgeInsets.all(24),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: navegarARegistro,
                      icon: Icon(
                        Icons.add,
                        size: ResponsiveHelper.getResponsiveIconSize(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                      ),
                      label: Text(
                        'Registrar Grifo',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            mobile: 16,
                            tablet: 20,
                            desktop: 24,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getResponsiveBorderRadius(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Estadísticas
                Padding(
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: const EdgeInsets.symmetric(horizontal: 16),
                    tablet: const EdgeInsets.symmetric(horizontal: 20),
                    desktop: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: ResponsiveHelper.isMobile(context)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Total',
                                    stats['total']!,
                                    Colors.blue,
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.getResponsiveSpacing(
                                    context,
                                    mobile: 8,
                                    tablet: 12,
                                    desktop: 16,
                                  ),
                                ),
                                Expanded(
                                  child: _buildStatCard(
                                    'Operativos',
                                    stats['operativos']!,
                                    Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Dañados',
                                    stats['dañados']!,
                                    Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.getResponsiveSpacing(
                                    context,
                                    mobile: 8,
                                    tablet: 12,
                                    desktop: 16,
                                  ),
                                ),
                                Expanded(
                                  child: _buildStatCard(
                                    'Mantenimiento',
                                    stats['mantenimiento']!,
                                    Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Sin verificar',
                                    stats['sin_verificar']!,
                                    Colors.grey,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: ResponsiveHelper.isTablet(context)
                              ? 3
                              : 5,
                          childAspectRatio: 1.2,
                          crossAxisSpacing:
                              ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                          mainAxisSpacing:
                              ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                          children: [
                            _buildStatCard(
                              'Total',
                              stats['total']!,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              'Operativos',
                              stats['operativos']!,
                              Colors.green,
                            ),
                            _buildStatCard(
                              'Dañados',
                              stats['dañados']!,
                              Colors.red,
                            ),
                            _buildStatCard(
                              'Mantenimiento',
                              stats['mantenimiento']!,
                              Colors.orange,
                            ),
                            _buildStatCard(
                              'Sin verificar',
                              stats['sin_verificar']!,
                              Colors.grey,
                            ),
                          ],
                        ),
                ),

                // Búsqueda y filtros
                Padding(
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: const EdgeInsets.all(16),
                    tablet: const EdgeInsets.all(20),
                    desktop: const EdgeInsets.all(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buscar y Filtrar Grifos',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 12,
                          tablet: 16,
                          desktop: 20,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar por dirección o comuna...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            busqueda = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 12,
                          tablet: 16,
                          desktop: 20,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: filtroEstado,
                        decoration: InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items:
                            [
                                  'Todos',
                                  'Operativo',
                                  'Dañado',
                                  'Mantenimiento',
                                  'Sin verificar',
                                ]
                                .map(
                                  (estado) => DropdownMenuItem(
                                    value: estado,
                                    child: Text(estado),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            filtroEstado = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Mapa placeholder
                Container(
                  margin: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: const EdgeInsets.all(16),
                    tablet: const EdgeInsets.all(20),
                    desktop: const EdgeInsets.all(24),
                  ),
                  height: ResponsiveHelper.getResponsiveHeight(
                    context,
                    mobile: 200,
                    tablet: 300,
                    desktop: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: ResponsiveHelper.getResponsiveIconSize(
                                context,
                                mobile: 60,
                                tablet: 80,
                                desktop: 100,
                              ),
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                            Text(
                              'Mapa Interactivo',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 16,
                                      tablet: 20,
                                      desktop: 24,
                                    ),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 4,
                                tablet: 8,
                                desktop: 12,
                              ),
                            ),
                            Text(
                              'Vista geográfica de todos los grifos registrados (${grifosFiltrados.length} mostrados)',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Row(
                          children: [
                            _buildLeyendaMapa('Operativo', Colors.green),
                            const SizedBox(width: 12),
                            _buildLeyendaMapa('Dañado', Colors.red),
                            const SizedBox(width: 12),
                            _buildLeyendaMapa('Mantenimiento', Colors.orange),
                            const SizedBox(width: 12),
                            _buildLeyendaMapa('Sin verificar', Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de grifos
                Padding(
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: const EdgeInsets.all(16),
                    tablet: const EdgeInsets.all(20),
                    desktop: const EdgeInsets.all(24),
                  ),
                  child: Text(
                    'Lista de Grifos (${grifosFiltrados.length})',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ...grifosFiltrados
                    .map((grifo) => _buildGrifoCard(grifo))
                    .toList(),

                SizedBox(
                  height: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    mobile: 20,
                    tablet: 30,
                    desktop: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
      ),
      child: Padding(
        padding: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: const EdgeInsets.all(12),
          tablet: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 4,
                tablet: 6,
                desktop: 8,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeyendaMapa(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildGrifoCard(Grifo grifo) {
    return Card(
      margin: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
      ),
      child: Padding(
        padding: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(20),
          desktop: const EdgeInsets.all(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${grifo.direccion}, ${grifo.comuna}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      mobile: 12,
                      tablet: 16,
                      desktop: 20,
                    ),
                    vertical: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      mobile: 6,
                      tablet: 8,
                      desktop: 10,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: getEstadoColor(grifo.estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getResponsiveBorderRadius(
                        context,
                        mobile: 12,
                        tablet: 15,
                        desktop: 18,
                      ),
                    ),
                    border: Border.all(color: getEstadoColor(grifo.estado)),
                  ),
                  child: Text(
                    grifo.estado,
                    style: TextStyle(
                      color: getEstadoColor(grifo.estado),
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
            Text(
              'Tipo: ${grifo.tipo}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
            ),
            Text(
              'Última inspección: ${grifo.ultimaInspeccion.year}-${grifo.ultimaInspeccion.month.toString().padLeft(2, '0')}-${grifo.ultimaInspeccion.day.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),
            Text(
              'Notas: ${grifo.notas}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),
            Text(
              'Reportado por ${grifo.reportadoPor} el ${grifo.fechaReporte.year}-${grifo.fechaReporte.month.toString().padLeft(2, '0')}-${grifo.fechaReporte.day.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
            ResponsiveHelper.isMobile(context)
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  cambiarEstadoGrifo(grifo.id, 'Operativo'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: const BorderSide(color: Colors.green),
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      ResponsiveHelper.getResponsiveSpacing(
                                        context,
                                        mobile: 8,
                                        tablet: 12,
                                        desktop: 16,
                                      ),
                                ),
                              ),
                              child: Text(
                                'Operativo',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        mobile: 12,
                                        tablet: 14,
                                        desktop: 16,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              mobile: 8,
                              tablet: 12,
                              desktop: 16,
                            ),
                          ),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  cambiarEstadoGrifo(grifo.id, 'Dañado'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      ResponsiveHelper.getResponsiveSpacing(
                                        context,
                                        mobile: 8,
                                        tablet: 12,
                                        desktop: 16,
                                      ),
                                ),
                              ),
                              child: Text(
                                'Dañado',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        mobile: 12,
                                        tablet: 14,
                                        desktop: 16,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 8,
                          tablet: 12,
                          desktop: 16,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              cambiarEstadoGrifo(grifo.id, 'Mantenimiento'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange),
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                          ),
                          child: Text(
                            'Mantenimiento',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              cambiarEstadoGrifo(grifo.id, 'Operativo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                          ),
                          child: Text(
                            'Operativo',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 8,
                          tablet: 12,
                          desktop: 16,
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              cambiarEstadoGrifo(grifo.id, 'Dañado'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                          ),
                          child: Text(
                            'Dañado',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 8,
                          tablet: 12,
                          desktop: 16,
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              cambiarEstadoGrifo(grifo.id, 'Mantenimiento'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange),
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 8,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                          ),
                          child: Text(
                            'Mantenimiento',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
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
    );
  }
}

// Pantalla de registro de grifo
class RegistrarGrifoScreen extends StatefulWidget {
  final String nombreUsuario;

  const RegistrarGrifoScreen({Key? key, required this.nombreUsuario})
    : super(key: key);

  @override
  State<RegistrarGrifoScreen> createState() => _RegistrarGrifoScreenState();
}

class _RegistrarGrifoScreenState extends State<RegistrarGrifoScreen> {
  double lat = -33.4489;
  double lng = -70.6693;
  String tipo = 'Estándar';
  String estado = 'Sin verificar';
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController comunaController = TextEditingController();
  final TextEditingController notasController = TextEditingController();

  void registrarGrifo() {
    if (direccionController.text.isEmpty || comunaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos obligatorios'),
        ),
      );
      return;
    }

    final nuevoGrifo = Grifo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      direccion: direccionController.text,
      comuna: comunaController.text,
      tipo: tipo,
      estado: estado,
      ultimaInspeccion: DateTime.now(),
      notas: notasController.text.isEmpty
          ? 'Sin notas adicionales'
          : notasController.text,
      reportadoPor: widget.nombreUsuario,
      fechaReporte: DateTime.now(),
      lat: lat,
      lng: lng,
    );

    Navigator.pop(context, nuevoGrifo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registrar Nuevo Grifo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Añade un nuevo punto de agua al sistema',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              const Text(
                'Selecciona la ubicación del grifo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Mapa placeholder con selector
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 60,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Nuevo grifo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Coordenadas: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                          ),
                          Text('Tipo: $tipo'),
                          Text('Estado: $estado'),
                          const SizedBox(height: 8),
                          Text(
                            'Haz clic en diferentes áreas del mapa para cambiar la ubicación',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Column(
                        children: [
                          FloatingActionButton.small(
                            onPressed: () {},
                            child: const Icon(Icons.add),
                          ),
                          const SizedBox(height: 4),
                          FloatingActionButton.small(
                            onPressed: () {},
                            child: const Icon(Icons.remove),
                          ),
                          const SizedBox(height: 4),
                          FloatingActionButton.small(
                            onPressed: () {},
                            child: const Icon(Icons.my_location),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Operativo',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Dañado', style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 12),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Nuevo grifo',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Seleccionado: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Haz clic en diferentes áreas del mapa para seleccionar la ubicación exacta del grifo',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              TextField(
                controller: direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: comunaController,
                decoration: InputDecoration(
                  labelText: 'Comuna *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: tipo,
                decoration: InputDecoration(
                  labelText: 'Tipo de grifo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Estándar', 'Alto flujo', 'Seco']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tipo = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: estado,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Sin verificar', 'Operativo', 'Dañado', 'Mantenimiento']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    estado = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextField(
                controller: notasController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notas adicionales',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Automáticamente asignado a tu usuario: ${widget.nombreUsuario}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: registrarGrifo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Registrar Grifo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
