Feature: Create new User

@smoke
Scenario: Create new user
    #Se invoca al archivo de esta manera
    * def datagenerator = Java.type('helpers.DataGenerator')
    # Se obtiene los valores de esta manera
    * def username = datagenerator.getRandomUsername()
    * def email = datagenerator.getRandomEmail()
    
    Given url 'https://api.realworld.io/api/'
    And path 'users'
    And request 
    """
        {
            "user": {
                "email": #(email),
                "password": "rommel1rommel1",
                "username": #(username)
            }
        }

    """
    When method Post
    And status 201
    And match response ==
    """
        {
            "user": {
                "id": '#number',
                "email": #(email),
                "username": #(username),
                "bio": null,
                "image": '#string',
                "token": '#string'
            }
        }
    """
