package users;

import com.intuit.karate.junit5.Karate;

public class UsersTest {

    @Karate.Test
    Karate testUsers() {
        // Esto buscará el archivo .feature en la misma carpeta que este Runner
        return Karate.run("users").relativeTo(getClass());
    }

}