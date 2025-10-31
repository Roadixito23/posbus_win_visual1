import 'package:intl/intl.dart';

class CurrencyHelper {
  /// Formatea un valor como moneda chilena (CLP)
  static String formatearCLP(double valor) {
    final formatter = NumberFormat.currency(
      locale: 'es_CL',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(valor);
  }

  /// Formatea un valor como moneda con símbolo personalizado
  static String formatearMoneda(
    double valor, {
    String simbolo = '\$',
    int decimales = 0,
    String locale = 'es_CL',
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: simbolo,
      decimalDigits: decimales,
    );
    return formatter.format(valor);
  }

  /// Formatea un valor numérico sin símbolo de moneda
  static String formatearNumero(double valor, {int decimales = 0}) {
    final formatter = NumberFormat.decimalPattern('es_CL');
    if (decimales == 0) {
      return formatter.format(valor.round());
    }
    return valor.toStringAsFixed(decimales);
  }

  /// Formatea un valor como porcentaje
  static String formatearPorcentaje(double valor, {int decimales = 1}) {
    return '${valor.toStringAsFixed(decimales)}%';
  }

  /// Parsea una cadena a double, retorna 0.0 si falla
  static double parsearDouble(String valor) {
    try {
      // Eliminar símbolos de moneda y espacios
      String cleaned = valor.replaceAll(RegExp(r'[^\d.,\-]'), '');
      // Reemplazar coma por punto si es necesario
      cleaned = cleaned.replaceAll(',', '.');
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  /// Calcula el porcentaje de cambio entre dos valores
  static double calcularCambioPorcentual(double valorAnterior, double valorActual) {
    if (valorAnterior == 0) return 0.0;
    return ((valorActual - valorAnterior) / valorAnterior) * 100;
  }

  /// Retorna true si el cambio es positivo
  static bool esCambioPositivo(double valorAnterior, double valorActual) {
    return valorActual > valorAnterior;
  }

  /// Formatea el cambio con signo + o -
  static String formatearCambio(double cambio) {
    final signo = cambio >= 0 ? '+' : '';
    return '$signo${formatearCLP(cambio)}';
  }

  /// Formatea el cambio porcentual con signo + o -
  static String formatearCambioPorcentual(double cambio) {
    final signo = cambio >= 0 ? '+' : '';
    return '$signo${formatearPorcentaje(cambio)}';
  }
}
