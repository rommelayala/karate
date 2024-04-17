@smoke
Feature: Hooks

Background: 
    #Usando el callonce karate recordara el valor para ser usado en los otros scenarios
    #* def dummy_feature = callonce read('classpath:helpers/Dummy.feature')
    #* def username = dummy_feature.username

    * configure afterScenario = function(){karate.call('classpath:helpers/Dummy.feature')}
    * configure afterFeature = 
    """
        function(){
            karate.log('After Feature text ');
        }

    """

Scenario: First Scenario
    * print 'Hola desde el primer scenario'

Scenario: Second Scenario
    * print 'Hola desde el segundo scenario'