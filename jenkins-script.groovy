node {
   def mvnHome
   stage('Preparation') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/talal-shobaita/hello-world'
      // Get the Maven tool.
      mvnHome = "/usr"
   }
   stage('checkout') {
       // Checkout the code
         sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore clean validate"
   }
   
   stage('build') {
       // Build the code
       sh "'${mvnHome}/bin/mvn' package"
   }
   
   stage('test'){
       // Testing the code
       sh "echo Testing"
   }
   
}
