# Proyecto de Pruebas con Karate DSL

Este proyecto contiene una suite de pruebas automatizadas para la API de Usuarios de **ServeRest**, desarrollada con **Karate DSL**. El objetivo es garantizar la integridad de las operaciones CRUD y el cumplimiento del contrato de la API.


## 🚀 Tecnologías Utilizadas

*   **Java 21**: Lenguaje base para la ejecución de Maven.
*   **Karate DSL 1.4.1**: Framework de automatización de APIs (BDD).
*   **Maven**: Gestor de dependencias y ciclo de vida del proyecto.
*   **JavaScript**: Utilizado para la generación de datos dinámicos en los tests.


🛠️ Configuración e Instalación
Para preparar el entorno de desarrollo y ejecución, sigue estos pasos:

1. Prerrequisitos
Java JDK 21: Es necesario para la compilación y ejecución (compatible con versiones superiores a 11).

Apache Maven 3.8+: Para la gestión de dependencias.

Git: Para la clonación del repositorio.

2. Clonación y Preparación:

Bash    
    git clone https://github.com/sabricenos/PacSeg2026_retoBackend.git
    cd PacSeg2026_retoBackend

3. Instala las dependencias necesarias:

Bash
    mvn clean install -DskipTests


🧪 Ejecución de Pruebas
La suite está configurada para ejecutarse a través de Maven, lo que facilita su integración en pipelines de CI/CD.

Ejecución Total
Corre todos los escenarios definidos en los archivos .feature:

Bash
    mvn test

Ejecución por Entorno
Configurado en karate-config.js, puede alternarse entre entornos (la URL base cambiará automáticamente si se configura):

Bash
    mvn test -Dkarate.env=qa

Reportes de Resultados
Al finalizar, Karate genera un reporte interactivo en HTML. Estos pueden visualizarse abriendo el siguiente archivo en tu navegador:
target/karate-reports/karate-summary.html


## 🏗️ Estrategia de Automatización

La suite se diseñó siguiendo principios de **Clean Code** y **Robustez en Backend**:

1.  **Validación de Esquema (Contract Testing)**: No solo validamos datos, sino estructuras JSON completas mediante archivos `.json` externos para asegurar que la API no rompa el contrato.
2.  **Aislamiento de Datos**: Se utiliza un `DataGenerator.js` para crear correos y nombres únicos en cada ejecución, evitando errores por datos duplicados (400 Bad Request).
3.  **Flujo CRUD Completo**: El escenario principal valida el ciclo de vida de un usuario:
    *   Listado inicial (Snapshot).
    *   Creación (POST).
    *   Validación de persistencia (GET por ID).
    *   Actualización (PUT) con verificación de integridad de ID.
    *   Validación de estado intermedio (Listado total + 1).
    *   Eliminación (DELETE) y verificación de limpieza (GET 400 y Conteo final).
4.  **Manejo de Entornos**: Configuración centralizada en `karate-config.js` para soportar múltiples ambientes (Dev, QA, Prod).

## 📂 Estructura del Proyecto

```text
src/test/java/
├── helpers/
│   └── DataGenerator.js       # Utilidad JS para datos aleatorios
├── users/
│   ├── schemas/               # Definiciones de esquemas JSON
│   │   ├── user-item-schema.json
│   │   └── user-list-schema.json
│   ├── users.feature          # Escenarios de prueba (Gherkin)
│   └── UsersRunner.java       # Ejecutor JUnit 5 para Karate
└── karate-config.js           # Configuración global y Timeouts

También se ha incluido el archivo .gitignore donde especificamos no subir el DS_Store para los archivos Mac de configuración, Thumbs.db para los archivos generados por Windows, etc.


👤 Escenarios Cubiertos
La suite no solo verifica respuestas exitosas, sino que audita el ciclo de vida completo del recurso y el contrato de la API:

1. Gestión Integral de Usuarios (CRUD)
Se implementó un flujo secuencial que garantiza la integridad de los datos:

Listado Inicial: Captura del estado actual de la base de datos y validación de esquema global.

Registro Exitoso: Creación de usuario con datos dinámicos (usando DataGenerator.js).

Lectura y Persistencia: Validación de que el usuario creado existe y sus datos coinciden con el registro.

Actualización (PUT): Modificación de datos existentes y verificación de que el _id permanece inalterado.

Validación de Snapshot: Comprobación de que el conteo total de usuarios aumentó exactamente en 1 y que el nuevo nombre aparece en la lista global.

Eliminación: Borrado físico del usuario.

Verificación de Limpieza: Confirmación de que el GET por ID devuelve un error 400 y el conteo de usuarios vuelve al estado inicial.

2. Validación de Contrato (Schema Validation)
Se utilizan archivos .json externos para asegurar que la API cumpla con el tipo de datos esperado:

UserItemSchema: Valida que cada usuario tenga nome, email, password, administrador y _id como Strings, además de validar el formato del email mediante Regex.

UserListSchema: Valida que la respuesta de listado contenga el campo numérico quantidade y el array usuarios.

3. Casos Negativos
Validación de error 400 - Usuário não encontrado al intentar consultar un ID que ya fue eliminado o que es inexistente.


QA Automation Engineer: [Sergio Briceño]
Fecha: 2026