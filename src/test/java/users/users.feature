Feature: Gestión de Usuarios en ServeRest (API Backend)

Background:
    * url baseUrl
    * def userItemSchema = read('classpath:users/schemas/user-item-schema.json')
    * def userListSchema = read('classpath:users/schemas/user-list-schema.json')
    * def dataGenerator = read('classpath:helpers/DataGenerator.js')
    * def userData = call dataGenerator
    * def userPayload = 
    """
    {
      "nome": "#(userData.name)",
      "email": "#(userData.email)",
      "password": "pass123",
      "administrador": "true"
    }
    """

Scenario: Ciclo de vida completo del usuario con verificaciones intermedias

    # 1. LISTAR TODOS LOS USUARIOS
    # Validamos que la API responde y devuelve una lista (aunque esté vacía o tenga otros datos)
    Given path 'usuarios'
    When method get
    Then status 200
    # Validamos que el JSON completo coincida con la estructura definida en el archivo .json
    And match response == userListSchema
    # Validamos que CADA usuario dentro de la lista cumpla con el esquema de item (campos y tipos)
    And match each response.usuarios == userItemSchema
    # Verificamos que 'usuarios' sea un array (aunque esté vacío)
    And match response.usuarios == '#[]'
    
    # Guardamos la cantidad actual para validar la limpieza al final del test
    * def cantidadInicial = response.quantidade
    * karate.log('Cantidad inicial de usuarios detectada:', cantidadInicial)

    # 2. REGISTRAR USUARIO
    Given path 'usuarios'
    And request userPayload
    When method post
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    * def userId = response._id

    # 3. VERIFICAR POR ID (Post-Registro)
    Given path 'usuarios', userId
    When method get
    Then status 200
    # Validamos que el objeto completo debe seguir el esquema de un usuario individual
    And match response == userItemSchema
    # Validamos que el ID retornado debe ser el mismo que generó el POST
    And match response._id == userId
    # Validamos que el nombre retornado debe ser el mismo que se envió en el POST
    And match response.nome == userData.name

    # 4. ACTUALIZAR USUARIO
    * def updatedName = userData.name + " Editado"
    Given path 'usuarios', userId
    And request { nome: '#(updatedName)', email: '#(userData.email)', password: 'newpass123', administrador: 'true' }
    When method put
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

    # 5. VERIFICAR POR ID (Post-Actualización)
    Given path 'usuarios', userId
    When method get
    Then status 200
    # Validamos que tras el PUT, el esquema siga siendo íntegro
    And match response == userItemSchema
    # Validamos que el ID no debe haber cambiado tras la actualización
    And match response._id == userId
    # Verificamos que el cambio de nombre se haya persistido
    And match response.nome == updatedName

    # 6. LISTAR TOTAL ANTES DE ELIMINAR (Confirmación de persistencia)
    # Aquí validamos que el total aumentó en 1 respecto al inicio
    Given path 'usuarios'
    When method get
    Then status 200
    # Validamos que la estructura de la lista (quantidade y array usuarios) sea correcta
    And match response == userListSchema
    # Validamos que todos los usuarios existentes en la base de datos cumplan el contrato
    And match each response.usuarios == userItemSchema
    And match response.quantidade == cantidadInicial + 1
    # Buscamos que nuestro usuario editado esté presente en la lista total
    And match response.usuarios[*].nome contains updatedName

    # 7. ELIMINAR USUARIO
    Given path 'usuarios', userId
    When method delete
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

    # 8. VERIFICAR POR ID (Post-Eliminación - Validar que ya no existe)
    Given path 'usuarios', userId
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

    # 9. LISTAR AL FINAL (Validar limpieza del sistema)
    Given path 'usuarios'
    When method get
    Then status 200
    # Aseguramos que la estructura sigue siendo válida tras la eliminación
    And match response == userListSchema
    And match each response.usuarios == userItemSchema
    # Buscamos que nuestro usuario eliminado ya no esté presente en la lista total
    # El conteo debe haber vuelto a su estado original
    And match response.quantidade == cantidadInicial
    And match response.usuarios[*]._id !contains userId