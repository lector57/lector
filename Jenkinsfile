node('apache') {
	stage ('Download war from nexus whis ARG'){
		env.ver="1.0.10" //Version of WAR we wont to deploy on Tomcat (ARG=env.ver)
		dir('/root/test') {
        sh 'wget -O test.war http://192.168.0.10:8081/nexus/service/local/repositories/snapshots/content/task6/${ver}/test.war'
    }
}
	stage ('Increment version, build war '){
		dir('/opt/gradle') {
            sh './build_war.sh'
        }
    }
    stage ('Publish to nexus '){
        dir('/opt/gradle') {
            withCredentials([usernamePassword(credentialsId: '60bd7685-a103-40c4-a168-e84d7dca184d', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USER')]) {
                sh 'curl -XPOST -u ${NEXUS_USER}:${NEXUS_PASSWORD} -T ./build/libs/gradle.war "http://192.168.0.10:8081/nexus/content/repositories/snapshots/task7/test.war"'
            }
        }
    }
	stage('DOCKER'){
		sh 'mkdir -p /root/test/deploy'
		sh 'cp /root/test/build/libs/test.war /root/test/deploy/test.war'
		dir('/root/test'){
			sh 'echo "FROM tomcat" > Dockerfile'
			sh 'echo "ADD deploy /usr/local/tomcat/webapps" >> Dockerfile'
			sh 'docker build -t my-tomcat:1.0.10 .'
			sh 'docker tag my-tomcat 192.168.0.10:5000/my-tomcat:1.0.10'
			sh 'docker push 192.168.0.10:5000/my-tomcat:1.0.10'
			sh 'docker swarm init --advertise-addr 192.168.0.10'
			sh './run_service'
			sh 'curl http://192.168.0.10:8080/test/'
		}
	}
	stage ('Push to Git '){
		dir('/root/test') {
			git credentialsId: 'a70afc5e-862c-4ef5-8dc7-5c82cb3921d6', url: 'https://github.com/lector57/lector.git'
			sh 'git add .'
			sh 'git commit -m "task7 Docher'
			sh 'git branch task7'
			sh 'git checkout task7'
			sh 'git push -f origin task7'
			sh 'git merge master'
			sh "git push -f origin master"
        }
    }
}


  



