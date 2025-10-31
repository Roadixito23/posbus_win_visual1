import 'package:intl/intl.dart';

class DateTimeHelper {
  /// Formatea una fecha completa (con hora)
  static String formatearFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return '-';
    try {
      final dt = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy HH:mm:ss', 'es').format(dt);
    } catch (e) {
      return fecha;
    }
  }

  /// Formatea una fecha corta (solo fecha, sin hora)
  static String formatearFechaCorta(String? fecha) {
    if (fecha == null || fecha.isEmpty) return '-';
    try {
      final dt = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy', 'es').format(dt);
    } catch (e) {
      return fecha;
    }
  }

  /// Formatea solo la hora
  static String formatearHora(String? hora) {
    if (hora == null || hora.isEmpty) return '-';
    try {
      // Si ya es solo hora (HH:mm:ss)
      if (hora.length <= 8 && hora.contains(':')) {
        return hora;
      }
      // Si es un DateTime completo
      final dt = DateTime.parse(hora);
      return DateFormat('HH:mm:ss', 'es').format(dt);
    } catch (e) {
      return hora;
    }
  }

  /// Formatea hora corta (HH:mm)
  static String formatearHoraCorta(String? hora) {
    if (hora == null || hora.isEmpty) return '-';
    try {
      if (hora.length <= 8 && hora.contains(':')) {
        return hora.substring(0, 5); // HH:mm
      }
      final dt = DateTime.parse(hora);
      return DateFormat('HH:mm', 'es').format(dt);
    } catch (e) {
      return hora;
    }
  }

  /// Formatea un DateTime a string
  static String formatearDateTime(DateTime? dateTime, {String formato = 'dd/MM/yyyy HH:mm:ss'}) {
    if (dateTime == null) return '-';
    return DateFormat(formato, 'es').format(dateTime);
  }

  /// Formatea fecha relativa (Hoy, Ayer, etc.)
  static String formatearFechaRelativa(DateTime fecha) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final fechaDia = DateTime(fecha.year, fecha.month, fecha.day);

    final diferencia = hoy.difference(fechaDia).inDays;

    if (diferencia == 0) {
      return 'Hoy ${formatearHoraCorta(fecha.toString())}';
    } else if (diferencia == 1) {
      return 'Ayer ${formatearHoraCorta(fecha.toString())}';
    } else if (diferencia < 7) {
      return '${_obtenerNombreDia(fecha)} ${formatearHoraCorta(fecha.toString())}';
    } else {
      return formatearFecha(fecha.toString());
    }
  }

  /// Obtiene el nombre del día en español
  static String _obtenerNombreDia(DateTime fecha) {
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return dias[fecha.weekday - 1];
  }

  /// Obtiene el nombre del mes en español
  static String obtenerNombreMes(int mes) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes - 1];
  }

  /// Verifica si una fecha es hoy
  static bool esHoy(DateTime fecha) {
    final ahora = DateTime.now();
    return fecha.year == ahora.year &&
           fecha.month == ahora.month &&
           fecha.day == ahora.day;
  }

  /// Verifica si una fecha es esta semana
  static bool esEstaSemana(DateTime fecha) {
    final ahora = DateTime.now();
    final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
    final finSemana = inicioSemana.add(const Duration(days: 6));
    return fecha.isAfter(inicioSemana) && fecha.isBefore(finSemana);
  }

  /// Verifica si una fecha es este mes
  static bool esEsteMes(DateTime fecha) {
    final ahora = DateTime.now();
    return fecha.year == ahora.year && fecha.month == ahora.month;
  }

  /// Obtiene el primer día del mes
  static DateTime primerDiaMes(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, 1);
  }

  /// Obtiene el último día del mes
  static DateTime ultimoDiaMes(DateTime fecha) {
    return DateTime(fecha.year, fecha.month + 1, 0);
  }

  /// Obtiene el primer día de la semana
  static DateTime primerDiaSemana(DateTime fecha) {
    return fecha.subtract(Duration(days: fecha.weekday - 1));
  }

  /// Obtiene el último día de la semana
  static DateTime ultimoDiaSemana(DateTime fecha) {
    return fecha.add(Duration(days: 7 - fecha.weekday));
  }

  /// Parsea una fecha string a DateTime
  static DateTime? parsearFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return null;
    try {
      return DateTime.parse(fecha);
    } catch (e) {
      return null;
    }
  }

  /// Calcula la diferencia en días entre dos fechas
  static int diferenciaEnDias(DateTime fecha1, DateTime fecha2) {
    final diff = fecha2.difference(fecha1);
    return diff.inDays.abs();
  }

  /// Formatea duración en texto legible
  static String formatearDuracion(Duration duracion) {
    if (duracion.inDays > 0) {
      return '${duracion.inDays} día${duracion.inDays > 1 ? 's' : ''}';
    } else if (duracion.inHours > 0) {
      return '${duracion.inHours} hora${duracion.inHours > 1 ? 's' : ''}';
    } else if (duracion.inMinutes > 0) {
      return '${duracion.inMinutes} minuto${duracion.inMinutes > 1 ? 's' : ''}';
    } else {
      return '${duracion.inSeconds} segundo${duracion.inSeconds > 1 ? 's' : ''}';
    }
  }

  /// Retorna texto de "hace X tiempo"
  static String tiempoTranscurrido(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inSeconds < 60) {
      return 'Hace ${diferencia.inSeconds} segundos';
    } else if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} minuto${diferencia.inMinutes > 1 ? 's' : ''}';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours} hora${diferencia.inHours > 1 ? 's' : ''}';
    } else if (diferencia.inDays < 30) {
      return 'Hace ${diferencia.inDays} día${diferencia.inDays > 1 ? 's' : ''}';
    } else {
      return formatearFecha(fecha.toString());
    }
  }

  /// Convierte string de fecha SQL a DateTime
  static DateTime? fechaSqlADateTime(String? fecha) {
    if (fecha == null || fecha.isEmpty) return null;
    try {
      // Maneja formato: 'YYYY-MM-DD HH:MM:SS'
      return DateTime.parse(fecha.replaceAll(' ', 'T'));
    } catch (e) {
      return null;
    }
  }

  /// Convierte DateTime a string formato SQL
  static String dateTimeAFechaSql(DateTime fecha) {
    return fecha.toIso8601String().replaceAll('T', ' ').split('.')[0];
  }
}
