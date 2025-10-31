class Validators {
  /// Valida que el campo no esté vacío
  static String? requerido(String? valor, {String? mensaje}) {
    if (valor == null || valor.trim().isEmpty) {
      return mensaje ?? 'Este campo es requerido';
    }
    return null;
  }

  /// Valida email
  static String? email(String? valor) {
    if (valor == null || valor.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(valor)) {
      return 'Ingrese un email válido';
    }
    return null;
  }

  /// Valida número entero
  static String? numeroEntero(String? valor, {String? mensaje}) {
    if (valor == null || valor.isEmpty) return null;

    if (int.tryParse(valor) == null) {
      return mensaje ?? 'Debe ser un número entero';
    }
    return null;
  }

  /// Valida número decimal
  static String? numeroDecimal(String? valor, {String? mensaje}) {
    if (valor == null || valor.isEmpty) return null;

    if (double.tryParse(valor) == null) {
      return mensaje ?? 'Debe ser un número válido';
    }
    return null;
  }

  /// Valida que sea un número positivo
  static String? numeroPositivo(String? valor) {
    if (valor == null || valor.isEmpty) return null;

    final numero = double.tryParse(valor);
    if (numero == null) {
      return 'Debe ser un número válido';
    }
    if (numero <= 0) {
      return 'Debe ser un número positivo';
    }
    return null;
  }

  /// Valida longitud mínima
  static String? longitudMinima(String? valor, int minimo, {String? mensaje}) {
    if (valor == null || valor.isEmpty) return null;

    if (valor.length < minimo) {
      return mensaje ?? 'Debe tener al menos $minimo caracteres';
    }
    return null;
  }

  /// Valida longitud máxima
  static String? longitudMaxima(String? valor, int maximo, {String? mensaje}) {
    if (valor == null) return null;

    if (valor.length > maximo) {
      return mensaje ?? 'No debe exceder $maximo caracteres';
    }
    return null;
  }

  /// Valida rango de longitud
  static String? longitudEnRango(String? valor, int minimo, int maximo) {
    if (valor == null || valor.isEmpty) return null;

    if (valor.length < minimo || valor.length > maximo) {
      return 'Debe tener entre $minimo y $maximo caracteres';
    }
    return null;
  }

  /// Valida rango numérico
  static String? rangoNumerico(String? valor, double minimo, double maximo) {
    if (valor == null || valor.isEmpty) return null;

    final numero = double.tryParse(valor);
    if (numero == null) {
      return 'Debe ser un número válido';
    }

    if (numero < minimo || numero > maximo) {
      return 'Debe estar entre $minimo y $maximo';
    }
    return null;
  }

  /// Valida formato de IP
  static String? ip(String? valor) {
    if (valor == null || valor.isEmpty) return null;

    final ipRegex = RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
    );

    if (!ipRegex.hasMatch(valor)) {
      return 'Ingrese una IP válida';
    }

    // Validar que cada octeto esté entre 0 y 255
    final octetos = valor.split('.');
    for (var octeto in octetos) {
      final num = int.tryParse(octeto);
      if (num == null || num < 0 || num > 255) {
        return 'Ingrese una IP válida';
      }
    }

    return null;
  }

  /// Valida puerto
  static String? puerto(String? valor) {
    if (valor == null || valor.isEmpty) return null;

    final puerto = int.tryParse(valor);
    if (puerto == null) {
      return 'Debe ser un número entero';
    }

    if (puerto < 1 || puerto > 65535) {
      return 'El puerto debe estar entre 1 y 65535';
    }

    return null;
  }

  /// Valida nombre de host (puede ser IP o dominio)
  static String? host(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'El host es requerido';
    }

    // Intentar validar como IP
    if (ip(valor) == null) return null;

    // Validar como dominio
    final domainRegex = RegExp(
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$',
    );

    if (domainRegex.hasMatch(valor)) return null;

    // Permitir localhost
    if (valor.toLowerCase() == 'localhost') return null;

    return 'Ingrese un host válido (IP o dominio)';
  }

  /// Valida formato de fecha (dd/MM/yyyy)
  static String? fecha(String? valor) {
    if (valor == null || valor.isEmpty) return null;

    final fechaRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (!fechaRegex.hasMatch(valor)) {
      return 'Formato de fecha inválido (dd/MM/yyyy)';
    }

    try {
      final partes = valor.split('/');
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final anio = int.parse(partes[2]);

      final fecha = DateTime(anio, mes, dia);
      if (fecha.day != dia || fecha.month != mes || fecha.year != anio) {
        return 'Fecha inválida';
      }
    } catch (e) {
      return 'Fecha inválida';
    }

    return null;
  }

  /// Combina múltiples validadores
  static String? Function(String?) combinar(
    List<String? Function(String?)> validadores,
  ) {
    return (valor) {
      for (var validador in validadores) {
        final resultado = validador(valor);
        if (resultado != null) return resultado;
      }
      return null;
    };
  }
}
