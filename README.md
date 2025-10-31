# 📊 POSBUS Suray - Visualizador de Cierres de Caja

Aplicación de escritorio para Windows desarrollada en Flutter que permite visualizar y analizar los cierres de caja sincronizados desde la aplicación móvil POSBUS.

## 🚀 Características

✅ Visualización de cierres de caja en tiempo real
📊 Dashboard con estadísticas y métricas principales
🔍 Filtros avanzados por fecha, dispositivo, ID
📑 Exportación a Excel y PDF
🎨 Interfaz Material Design 3 moderna
🔄 Sincronización automática con servidor PostgreSQL
🌓 Tema claro y oscuro
💾 Caché local para rendimiento óptimo
🔒 Almacenamiento seguro de credenciales

## 📋 Requisitos Previos

- Windows 10/11 (64-bit)
- Flutter SDK 3.2.0 o superior
- Visual Studio 2022 con "Desktop development with C++"
- Conexión a internet (para servidor remoto PostgreSQL)

## 🛠️ Instalación

### 1. Clonar el repositorio
```bash
git clone https://github.com/Roadixito23/posbus_win_visual1.git
cd posbus_win_visual1
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar conexión a base de datos

La aplicación se conecta a una base de datos PostgreSQL. La configuración inicial está en `assets/config/app_config.json`, pero también puede configurarse desde la pantalla de **Configuración** dentro de la aplicación.

Credenciales por defecto:
- **Host**: api.danteaguerorodriguez.work
- **Puerto**: 5432
- **Base de datos**: posbus_suray
- **Usuario**: posbus_user
- **Contraseña**: (configurar en la app)

### 4. Compilar para Windows
```bash
flutter build windows --release
```

### 5. Ejecutar en modo desarrollo
```bash
flutter run -d windows
```

## ⚙️ Configuración Inicial

1. Al iniciar por primera vez, ir a **Configuración** (menú lateral o desde el home)
2. Completar datos de conexión a PostgreSQL
3. Presionar **"Probar Conexión"** para verificar
4. Presionar **"Guardar"** para almacenar la configuración
5. La app se conectará automáticamente en próximos inicios

## 📖 Uso

### Dashboard (Pantalla Principal)
- Visualiza resumen de todos los cierres
- Métricas principales:
  - Total de ingresos
  - Número de cierres
  - Total de transacciones
- Lista de cierres recientes
- Botón de actualización manual

### Cierres de Caja
- Lista completa de todos los cierres
- Información mostrada:
  - ID del cierre
  - Fecha y hora de cierre
  - Total de ingresos
  - Cantidad de transacciones
  - Dispositivo de origen
- Click en cualquier cierre para ver el detalle completo

### Detalle de Cierre
- Información completa del cierre seleccionado
- Lista detallada de todas las transacciones
- Botones de exportación:
  - **Exportar a Excel**: Genera archivo .xlsx con resumen y transacciones
  - **Exportar a PDF**: Genera reporte en PDF

### Configuración
- **Conexión a Base de Datos**:
  - Configurar host, puerto, base de datos, usuario y contraseña
  - Probar conexión antes de guardar
- **Preferencias**:
  - Tema oscuro/claro
- **Información**:
  - Versión de la aplicación

## 📂 Estructura del Proyecto

```
lib/
├── app.dart                    # Configuración de la app
├── main.dart                   # Punto de entrada
├── config/                     # Archivos de configuración
│   ├── app_config.dart
│   ├── theme_config.dart
│   └── database_config.dart
├── core/                       # Constantes y utilidades
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── text_styles.dart
│   └── utils/
│       ├── currency_helper.dart
│       ├── date_time_helper.dart
│       ├── logger.dart
│       └── validators.dart
├── data/                       # Modelos y datos
│   └── models/
│       ├── cierre_caja.dart
│       ├── transaccion.dart
│       ├── tarifa.dart
│       ├── estadisticas.dart
│       └── configuracion.dart
├── providers/                  # Gestión de estado
│   ├── cierres_provider.dart
│   ├── configuracion_provider.dart
│   └── theme_provider.dart
├── screens/                    # Pantallas de la app
│   ├── home/
│   │   └── home_screen.dart
│   ├── cierres/
│   │   ├── cierres_list_screen.dart
│   │   └── detalle_cierre_screen.dart
│   ├── estadisticas/
│   │   └── estadisticas_screen.dart
│   └── configuracion/
│       └── configuracion_screen.dart
└── services/                   # Servicios
    ├── database_service.dart
    └── export_service.dart
```

## 🗄️ Base de Datos PostgreSQL

### Tablas Principales

#### cierres_caja
- `id` (SERIAL PRIMARY KEY)
- `fecha_cierre` (TEXT)
- `total_ingresos` (REAL)
- `total_transacciones` (INTEGER)
- `pdf_path` (TEXT)
- `dispositivo_origen` (TEXT)
- `sincronizado_en` (TIMESTAMP)

#### transacciones
- `id` (SERIAL PRIMARY KEY)
- `fecha` (TEXT)
- `hora` (TEXT)
- `nombre_pasaje` (TEXT)
- `valor` (REAL)
- `comprobante` (TEXT)
- `cierre_id` (INTEGER) → FK a cierres_caja
- `dispositivo_origen` (TEXT)
- `sincronizado_en` (TIMESTAMP)

## 🎨 Tecnologías Utilizadas

- **Flutter** 3.2.0+ (Framework UI)
- **Dart** 3.0+ (Lenguaje)
- **Provider** (Gestión de estado)
- **PostgreSQL** (Base de datos)
- **Excel** (Exportación a Excel)
- **PDF** (Generación de PDFs)
- **Window Manager** (Gestión de ventanas en Windows)

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # Gestión de estado
  postgres: ^3.0.0              # Cliente PostgreSQL
  excel: ^4.0.2                 # Exportación Excel
  pdf: ^3.10.7                  # Generación PDF
  google_fonts: ^6.1.0          # Fuentes
  intl: ^0.19.0                 # Internacionalización
  logger: ^2.0.2+1              # Logging
  flutter_secure_storage: ^9.0.0  # Almacenamiento seguro
  window_manager: ^0.3.7        # Gestión de ventanas
```

## 🔒 Seguridad

- Las contraseñas de base de datos se almacenan de forma segura usando `flutter_secure_storage`
- Todas las queries usan parámetros preparados para prevenir SQL injection
- Los logs se almacenan localmente en el directorio de documentos del usuario

## 📁 Exportaciones

Los archivos exportados (Excel y PDF) se guardan en:
```
C:\Users\{Usuario}\Documents\posbus_exports\
```

Los logs de la aplicación se guardan en:
```
C:\Users\{Usuario}\Documents\posbus_logs\
```

## 🐛 Solución de Problemas

### Error de conexión a PostgreSQL
- Verificar que el servidor esté accesible
- Comprobar credenciales (host, puerto, usuario, contraseña)
- Verificar firewall y conexión a internet

### La aplicación no compila
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter build windows
```

### Error al exportar archivos
- Verificar permisos de escritura en el directorio de documentos
- Asegurarse de tener espacio disponible en disco

## 📝 Licencia

Este proyecto es privado y de uso exclusivo para POSBUS Suray.

## 👤 Autor

Desarrollado para el sistema POSBUS de transporte público.

## 📧 Soporte

Para reportar problemas o solicitar funcionalidades, contactar al administrador del sistema POSBUS.

---

**Versión**: 1.0.0
**Última actualización**: 2025
