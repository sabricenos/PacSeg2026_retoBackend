function fn() {
  // 1. Detectar el entorno (si se pasa por consola con -Dkarate.env=qa)
  var env = karate.env; 
  karate.log('El entorno de ejecución es:', env || 'dev (por defecto)');

  // 2. Configuración base
  var config = {
    baseUrl: 'https://serverest.dev',
  };

  // 3. Sobreescribir configuración según el entorno
  if (env == 'qa') {
    config.baseUrl = 'https://serverest.dev'; // Esta sería la URL de QA, pero no existe
  } else if (env == 'prod') {
    config.baseUrl = 'https://serverest.dev'; // Esta es la URL de Producción
  }

  // 4. Consideraciones de timeout
  // connectTimeout: tiempo máximo para establecer conexión (ms)
  // readTimeout: tiempo máximo para esperar la respuesta de la API (ms)
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  // Esto imprime en la consola los requests y responses de forma bonita (pretty print)
  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  return config;
}