function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://api.realworld.io/api/'
  }
  if (env == 'dev') {
    
    config.userEmail = 'rommel@rommel.com'
    config.userPassword = 'rommelrommel'
  
  } else if (env == 'qa') {
    
    config.userEmail = 'rommelqa@rommel.com'
    config.userPassword = 'rommelqarommelqa'

  }
  return config;
}