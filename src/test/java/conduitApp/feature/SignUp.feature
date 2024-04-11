Feature: Create new User

Background:
    Given url 'https://api.realworld.io/api/'
    #Se invoca al archivo de esta manera
    * def datagenerator = Java.type('helpers.DataGenerator')
    # Se obtiene los valores de esta manera
        
Scenario Outline: Validate Signup messages
        
    * def username = datagenerator.getRandomUsername()
    * def email = datagenerator.getRandomEmail()
   
    And path 'users'
    And request 
    """
        {
            "user": {
                "email": <email>,
                "password": <password>,
                "username": <username>
            }
        }

    """    
    When method Post
    Then status 422
    And match response == <errorResponse>
        
    Examples:
    |email             |password      |username   |errorResponse|
    |#(email)          |rommel1rommel1|rommel1    |{ "errors":{"username": [ "has already been taken" ]}}|
    |rommel5@rommel.com|rommel1rommel1|#(username)|{ "errors":{"email": [ "has already been taken" ]}}|
    |#(email)          |rommel1rommel1|     ""      |{ "errors":{"username": [  "can't be blank" ]}}|

Scenario: Create new user
    
    * def username = datagenerator.getRandomUsername()
    * def email = datagenerator.getRandomEmail()
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