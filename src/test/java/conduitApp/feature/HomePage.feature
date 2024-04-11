Feature: Test for the Home Page

Scenario: Get all tags
    Given url apiUrl
    And path 'tags'
    When method Get
    Then status 200
    And match response.tags contains 'eos'
    And match response.tags contains ['eos','est']
    And match response.tags !contains 'lolo'
    And match response.tags !contains any ['lolo','eos']
    # El objeto array dentro del objeto response debe ser un array
    And match response.tags == '#array'
    # TODOS los valores de tag deben ser strings
    And match each response.tags == '#string'


Scenario: Get 10 articles
    
    Given params {limit: 10, offset: 0}
    Given url 'https://api.realworld.io/api/'
    And path 'articles'
    When method Get
    Then status 200
    #El numero de articulos es un array de size 10
    And match response.articles == '#[10]'
    #verifica el valor del elemnto articlesCount del json
    And match response.articlesCount == 251
    And match response.articlesCount != 501
    And match response == { "articles" : "##array" , "articlesCount": 251}
    #Comprueba del primer articulo el campo createdAt contenga determinado valor
    And match response.articles[0].createdAt contains '2024'
    #Comprueba que de todos los articulos por lo menmos alguno contenga 91 
    # $ | actual does not contain expected | actual array does not contain expected item - 1 (LIST:NUMBER)
    # [386,167,114,108,91,29,33,15,18,26]
    # And match response.articles[*].favoritesCount contains 91
    #Karate busca dentro del json no importa la profundida
    # response.articles[*].author.bio contains null => response..bio
    And match response..bio contains null
    And match response.articles !contains 'foo'

Scenario: Validatattion schema of the articles
    
    * def timeValidator = read('classpath:helpers/timeValidator.js')

    Given params {limit: 10, offset: 0}
    Given url 'https://api.realworld.io/api/'
    And path 'articles'
    When method Get
    Then status 200
    #El numero de articulos es un array de size 10
    And match response.articles == '#[10]'
    #verifica el valor del elemnto articlesCount del json
    And match response.articlesCount == 251
    And match response.articlesCount != 501
    And match response == { "articles" : "##array" , "articlesCount": 251}
    #Comprueba del primer articulo el campo createdAt contenga determinado valor
    And match each response.articles ==
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": "#boolean",
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            }
        }
    """