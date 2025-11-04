import 'package:flutter/material.dart';
import '../data/models/cierre_caja.dart';
import '../data/models/transaccion.dart';
import '../services/api_service.dart';
import '../core/utils/logger.dart';

class CierresProvider extends ChangeNotifier {
  final _apiService = ApiService();
  final _logger = AppLogger();

  List<CierreCaja> _cierres = [];
  bool _isLoading = false;
  String? _error;
  CierreCaja? _cierreSeleccionado;
  List<Transaccion> _transaccionesCierreSeleccionado = [];

  // Getters
  List<CierreCaja> get cierres => _cierres;
  bool get isLoading => _isLoading;
  String? get error => _error;
  CierreCaja? get cierreSeleccionado => _cierreSeleccionado;
  List<Transaccion> get transaccionesCierreSeleccionado => _transaccionesCierreSeleccionado;

  /// Carga todos los cierres desde la API
  Future<void> cargarCierres() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _cierres = await _apiService.obtenerCierres();

      _isLoading = false;
      notifyListeners();
      _logger.info('${_cierres.length} cierres cargados desde API');
    } catch (e, stackTrace) {
      _error = 'Error al cargar cierres: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      _logger.error('Error al cargar cierres', e, stackTrace);
    }
  }

  /// Carga cierres por rango de fechas desde la API
  Future<void> cargarCierresPorRango(DateTime inicio, DateTime fin) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _cierres = await _apiService.obtenerCierresPorRangoFechas(
        fechaInicio: inicio,
        fechaFin: fin,
      );

      _isLoading = false;
      notifyListeners();
      _logger.info('${_cierres.length} cierres cargados en rango de fechas desde API');
    } catch (e, stackTrace) {
      _error = 'Error al cargar cierres por rango: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      _logger.error('Error al cargar cierres por rango', e, stackTrace);
    }
  }

  /// Carga cierres por dispositivo desde la API
  Future<void> cargarCierresPorDispositivo(String dispositivo) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _cierres = await _apiService.obtenerCierresPorDispositivo(dispositivo);

      _isLoading = false;
      notifyListeners();
      _logger.info('${_cierres.length} cierres cargados para dispositivo $dispositivo desde API');
    } catch (e, stackTrace) {
      _error = 'Error al cargar cierres por dispositivo: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      _logger.error('Error al cargar cierres por dispositivo', e, stackTrace);
    }
  }

  /// Selecciona un cierre y carga sus transacciones desde la API
  Future<void> seleccionarCierre(CierreCaja cierre) async {
    try {
      _cierreSeleccionado = cierre;
      _isLoading = true;
      notifyListeners();

      _transaccionesCierreSeleccionado = await _apiService.obtenerTransaccionesPorCierre(cierre.id);

      _isLoading = false;
      notifyListeners();
      _logger.info('${_transaccionesCierreSeleccionado.length} transacciones cargadas para cierre ${cierre.id} desde API');
    } catch (e, stackTrace) {
      _error = 'Error al cargar transacciones: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      _logger.error('Error al cargar transacciones', e, stackTrace);
    }
  }

  /// Limpia el cierre seleccionado
  void limpiarSeleccion() {
    _cierreSeleccionado = null;
    _transaccionesCierreSeleccionado = [];
    notifyListeners();
  }

  /// Refresca los datos
  Future<void> refresh() async {
    await cargarCierres();
  }
}
