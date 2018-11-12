node('master'){
    stage('Git Clone'){
       dir('d:\\gradle') {
        git branch: 'task6', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
        git checkout: 'task6', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
		git pull: 'task6', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
      }
    }
    stage('Increment and build war'){
    dir('d:\\gradle') {
      bat 'gradlew task increment'
      bat 'gradlew build'
    }   
}
    stage('Send war AND scriptsto NEXUS'){
      bat 'd:/curl/bin/curl.exe -XPOST -u admin:admin123 --upload-file d:/gradle/build/libs/gradle.war http://192.168.0.10:8081/nexus/content/repositories/snapshots/1.0.x/test.war'
      bat 'd:/curl/bin/curl.exe -XPOST -u admin:admin123 --upload-file d:/gradle/check_v_tomcat1.sh http://192.168.0.10:8081/nexus/content/repositories/snapshots/1.0.x/check_v_tomcat1.sh'
      bat 'd:/curl/bin/curl.exe -XPOST -u admin:admin123 --upload-file d:/gradle/check_v_tomcat2.sh http://192.168.0.10:8081/nexus/content/repositories/snapshots/1.0.x/check_v_tomcat2.sh'
    }     
}
node('tomcat1'){
    stage('Upgrade tomcat 1'){
      sh 'wget -r -O ~/check_v_tomcat1.sh http://192.168.0.10:8081/nexus/content/repositories/snapshots/1.0.x/check_v_tomcat1.sh'
      sh 'sudo chmod 755 ~/check_v_tomcat1.sh'
      sh '~/check_v_tomcat1.sh'
   }
}
node('tomcat2'){
    stage('Upgrade tomcat 2'){
      sh 'wget -r -O ~/check_v_tomcat2.sh http://192.168.0.10:8081/nexus/content/repositories/snapshots/1.0.x/check_v_tomcat2.sh'
      sh 'sudo chmod 755 ~/check_v_tomcat2.sh'
      sh '~/check_v_tomcat2.sh'
   }
}
node('master'){
    stage('Git merge'){
       dir('d:\\gradle') {
        git pull: 'task6', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
        git checkout: 'task6', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
        git push: 'task6', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
        git checkout: 'master', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
        git merge: 'task6', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
        git tag: 'v1.0.x', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git'
        git push: 'master', credentialsId: '821b0630-6fb3-4870-a67d-bdb43f87eb87', url: 'https://github.com/lector57/lector.git' 
       }
    }
}