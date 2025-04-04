# Proyecto Flutter con Firebase

Este proyecto es una aplicación desarrollada en Flutter que utiliza Firebase para la autenticación de usuarios, gestión de permisos y administración de registros de acceso.

## Características Principales

### 1. **Login/Registro**
- Los usuarios pueden registrarse e iniciar sesión usando su correo electrónico y contraseña.
- Autenticación implementada con Firebase Authentication.

### 2. **Panel de Administrador**
- Agregar, editar y eliminar usuarios.
- Asignar o revocar permisos de acceso a diferentes áreas.
- Visualización de registros de acceso.

### 3. **Panel de Usuario**
- Ver historial de acceso.

## Instalación y Configuración

### **1. Clonar el Repositorio**
```sh
  git clone https://github.com/JeffersonS69/prueba_tecnica_flutter.git
  cd mi_proyecto
```

### **2. Configurar Firebase**
1. Ir a [Firebase Console](https://console.firebase.google.com/).
2. Crear un nuevo proyecto.
3. Agregar una aplicación para Android e iOS.
4. Descargar `google-services.json` (Android) y colocarlo en `android/app/`.
5. Descargar `GoogleService-Info.plist` (iOS) y colocarlo en `ios/Runner/`.

Ejemplo de `google-services.json`:

```json
{
  "project_info": {
    "project_number": "",
    "project_id": "", 
    "storage_bucket": ""
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "",
        "android_client_info": {
          "package_name": "com.example.aplication"
        }
      },
      "oauth_client": [],
      "api_key": [
        {
          "current_key": ""
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

### **3. Configurar Variables de Entorno**

Se utiliza una carpeta `.env/` con un archivo `dev.json` para gestionar las credenciales de Firebase:

Ejemplo de `dev.json`:

```json
{
    "apiKey": "",
    "appId": "",
    "messagingSenderId": "",
    "projectId": "",
    "storageBucket": ""
}
```

Para cargar estas variables en tiempo de ejecución, se utiliza el archivo `launch.json` de VS Code con la configuración:

```json
{
    "name": "Development",
    "type": "dart",
    "request": "launch",
    "args": [
        "--dart-define-from-file=.env/dev.json"
    ]
}
```

### **4. Instalar Dependencias**
Ejecutar el siguiente comando en la terminal:
```sh
flutter pub get
```

### **5. Ejecutar la Aplicación**
Para probar la aplicación en un emulador o dispositivo físico:
```sh
flutter run
```

## Estructura del Proyecto

```
mi_proyecto/
│── .env/
│   ├── dev.json
│── .vscode/
│   ├── launch.json
│── lib/
│   ├── main.dart
│   ├── firebase.dart
│   ├── controllers/         
│   ├── models/        
│   ├── Views/
│   ├── Constants/
│   │   ├── envs.dart/           
│── android/
│── ios/
│── pubspec.yaml       
```

## Tecnologías Utilizadas
- **Flutter**: Framework para el desarrollo de la aplicación.
- **Firebase**: Base de datos y autenticación.
- **Firebase Cloud Messaging (FCM)**: Notificaciones push.
- **Cloud Firestore**: Almacenamiento de registros de acceso y datos de usuarios.


## Autores
- **Jefferson Garcia** - Desarrollador del proyecto.

---



