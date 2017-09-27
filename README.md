# fetcher-solution

// On any OS machine, make sure git, docker are installed.
git clone https://github.com/fadyberty/fetcher-solution
docker image build -t "fadyberty:jenkins"
docker run fadyberty:jenkins

you can open the website using http://localhost:8080/jenkins
add the groovy file into a pipeline job.
and did the build.

on the jenkins directory on the main machine, run the command
( or a new docker container could be created). 
mvn spring-boot:run
