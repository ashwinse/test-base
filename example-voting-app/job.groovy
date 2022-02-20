node{
    
    docker.withRegistry('https://dtrnodednsitqp7hrth6jf2.westus.cloudapp.azure.com/', 'ddc-dtr-login') {
        git 'https://github.com/SattaRavi/example-voting-app.git'
        
         build 'Job-Result'
         build 'Job-Vote'
         build 'Job-Worker'
        
    }
    
}
