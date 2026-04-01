📝 Informe de Estrategia de Automatización: Backend API

1. Selección de Herramientas
Se eligió Karate DSL para el reto de backend debido a su naturaleza unificada: permite realizar pruebas de API, validación de esquemas y manejo de datos en un solo ecosistema sin necesidad de escribir código "boilerplate" en Java.

Eficiencia: Karate elimina la necesidad de librerías externas como RestAssured o Jackson/Gson para el mapeo de objetos.

BDD Nativo: Facilita la comprensión de las reglas de negocio en los endpoints sin sacrificar la potencia técnica.

2. Arquitectura y Patrones de Diseño
Para este proyecto se implementaron patrones de Clean Code adaptados a microservicios:

Contract Testing (Schema Validation): En lugar de validar campo por campo en el código, se desacoplaron los esquemas en archivos .json independientes.

Ventaja: Si la estructura de la API cambia, el test falla inmediatamente por contrato, protegiendo la integridad del ecosistema.

Data-Driven Testing (DDT): Se integró un DataGenerator.js para inyectar datos aleatorios y únicos en cada ejecución.

Mantenibilidad: Esto evita colisiones de datos en entornos compartidos y asegura que los tests sean idempotentes.

3. Estrategia de Validación: Ciclo de Vida CRUD
A diferencia de pruebas aisladas, se diseñó un Flujo de Integración End-to-End que valida el estado del sistema:

Snapshot inicial: Se captura el conteo de recursos para tener una línea base.

Transaccionalidad: Se encadenan peticiones (POST -> GET -> PUT -> DELETE) pasando variables de forma dinámica (como el _id generado).

Integridad Post-Ejecución: Se verifica que el sistema retorne a su estado original tras el borrado, asegurando que no queden "datos huérfanos" en la base de datos.

4. Estabilidad y Configuración (Environment Agnostic)
Para garantizar que la suite sea Senior Level y lista para producción:

Abstracción de Entornos: A través de karate-config.js, la suite es capaz de cambiar de localhost a QA o Staging mediante una simple bandera de Maven (-Dkarate.env).

Manejo de Errores: Se incluyeron validaciones de Casos Negativos (400 Bad Request, 404 Not Found), asegurando que la API maneje las excepciones según la documentación técnica.

5. Reportabilidad y Diagnóstico
Se utiliza el motor de reportes nativo de Karate que proporciona:

Trazabilidad completa: Detalle de Headers, Payloads de entrada y respuestas de salida en formato interactivo.

Integración CI/CD: El proyecto está listo para ser ejecutado en Jenkins o GitHub Actions, fallando el pipeline automáticamente si un contrato no se cumple.