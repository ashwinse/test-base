node{
    
    docker.withRegistry('https://dtrnodednsitqp7hrth6jf2.westus.cloudapp.azure.com/', 'ddc-dtr-login') {
        git 'https://github.com/SattaRavi/example-voting-app.git'
    
        docker.build('admin/com.sysgain.voting-app.vote','./vote').push('latest')
    }
    
}
