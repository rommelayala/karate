
Feature: Home Work

    Background: Preconditions
        * url apiUrl 
        * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')
        * def token = tokenResponse.authToken
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        
    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
        Given path 'articles'
        And header Authorization = 'Token ' + token
        When method Get
        Then status 200
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def f_art_slug = response.articles[0].slug
        * def f_art_favCount = response.articles[0].favoritesCount
        * def article_count = response.articlesCount
        # * print 'El article count es: ',article_count
        # * print 'El first_article_slug es: ',f_art_slug
        # Obtiene un array con todos los elementos response.fav del response.favoritesCount
        # * def array_fav_count = karate.map(response.articles, function(x){return x.favoritesCount})
        # * print 'Los favoritesCount -> ', array_fav_count
        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles',f_art_slug,'favorite'
        And header Authorization = 'Token ' + token
        When method Post
        # Step 4: Verify response schema
        And match response.article ==
        """
            {
                    "id": "#number",
                    "slug": "#string",
                    "title": "#string",
                    "description": "#string",
                    "body": "#string",
                    "createdAt": "#? timeValidator(_)",,
                    "updatedAt": "#? timeValidator(_)",,
                    "authorId": "#number",
                    "tagList": "##array",
                    "author": {
                        "username": "#string",
                        "bio": "##string",
                        "image": "#string",
                        "following": "#boolean"
                    },
                    "favoritedBy": "#array",
                    "favorited": "#boolean",
                    "favoritesCount": "#number"
                }

        """
        # Step 5: Verify that favorites article incremented by 1
            #Example
            * def initialCount = 0
            * def response = {"favoritesCount": 1}
            * match response.favoritesCount == initialCount + 1

        # Step 6: Get all favorite articles
        Given path 'articles'
        And header Authorization = 'Token ' + token
        And params {favorited :"rommel"}
        When method Get
        Then status 200
        # Step 7: Verify response schema
        Then match each response.articles == 
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "tagList": "##array",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "favorited": "#boolean",
                "favoritesCount": "#number",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }

        """
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match f_art_slug == response.articles[0].slug

    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        Given path 'articles'
        And header Authorization = 'Token '+ token
        And method Get
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def slug_id = response.articles[0].slug
        * print 'El slug id es-> ', slug_id
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles',slug_id,'comments'
        And header Authorization = 'Token '+ token
        When method Get
        Then status 200
        # Step 4: Verify response schema
        And match response ==
        """
            {
                "comments": "#array"
            }
        """
        # Step 5: Get the count of the comments array lentgh and save to variable
            #Example
            #* def responseWithComments = [{"article": "first"}, {article: "second"}]
            #* def articlesCount = responseWithComments.length
            #* print 'Articles contador es -> ',articlesCount
        * def comments_length_before_any_op = response.comments.length
        * print 'Comments_length_before_any_op -> ',comments_length_before_any_op
        # Step 6: Make a POST request to publish a new comment
        Given path 'articles',slug_id,'/comments'
        And header Authorization = 'Token '+ token
        And request
        """
            {
                "comment": {
                    "body": "Lolo Fernandez"
                }
            }
        """
        When method Post
        Then status 200
        * def id_new_comment = response.comment.id
        ## Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles',slug_id,'comments'
        And header Authorization = 'Token '+ token
        When method Get
        Then status 200
        * def comments_length_after_post_new_message = response.comments.length
        * print 'comments_length_after_post_new_message ',comments_length_after_post_new_message
        And match comments_length_after_post_new_message == comments_length_before_any_op +1
        # Step 7: Verify response schema that should contain posted comment text
        And match each response.comments ==
        """   
            
            {
                "id": "#number",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "body": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
            
        """
        # Step 8: Get the list of all comments for this article one more time
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        # Step 10: Make a DELETE request to delete comment
        Given path 'articles',slug_id,'comments',id_new_comment
        And header Authorization = 'Token '+ token
        When method Delete
        Then status 200
        # Step 11: Get all comments again and verify number of comments decreased by 1
        ## Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles',slug_id,'comments'
        And header Authorization = 'Token '+ token
        When method Get
        Then status 200
        * def comments_length_after_delete = response.comments.length
        * print 'comments_length_after_delete ',comments_length_after_delete
        And match comments_length_after_delete == comments_length_after_post_new_message - 1