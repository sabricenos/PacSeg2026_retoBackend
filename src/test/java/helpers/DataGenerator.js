function() {
    //Genera un número entero aleatorio entre 0 y 9999
  var temp = Math.floor(Math.random() * 10000);
  return {
    //Retorna un objeto con un email y un nombre únicos basados en ese número
    email: "user_" + temp + "@test.com",
    name: "User " + temp
  };
}