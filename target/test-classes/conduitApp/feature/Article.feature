Feature: Testing post articles

Background: Define URL
    Given url apiUrl
    #Getting token
    #Given path 'users/login'
    #And request {"user": {"email": "rommel@rommel.com","password": "rommelrommel"}}
    #When method Post
    #Then status 200
    # almaceno el token en una variable
    #* def token = response.user.token
    * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')
    * def token = tokenResponse.authToken
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')

    @smoke
Scenario: Create a new article
    
    #Utilizamos el token en el header 
    Given header Authorization = 'Token ' + token
    And path 'articles'
    And request articleRequestBody
    When method Post
    Then status 201
    Then response.article.title == 'lolo'


Scenario: Create and Delete a new article
    Given header Authorization = 'Token ' + token
    #Create new article
    And path 'articles'
    And request articleRequestBody
    When method Post
    Then status 201
    Then response.article.title == 'lolo'
    #Store from response.articles[0].slug value in a variable
    * def slugValue = response.article.slug
    #Delete Article
    Given header Authorization = 'Token ' + token
    And path 'articles',slugValue
    When method Delete
    Then status 204
    #Checking article created is not present anymore
    Given params {limit:10, offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And response.articles[0].slug != slugValue


