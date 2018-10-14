# ACC_project

#### Setup:
##### Test
###### 1. Download docker. See instructions from lab 2
###### 2. Clone directory and run "cd containerization && docker-compose up --build"
###### 3. curl @5000

##### Swarm
###### First, run docker swarm init
###### During development:
1. docker-compose build
2. docker service create --name registry --publish published=5000,target=5000 registry:2
3. docker-compose push
4. docker stack deploy --compose-file docker-compose.yml stackdemo

###### To quit:
1. docker stack rm stackdemo
2. docker service rm registry
3. docker swarm leave --force

#### Bugs:
###### 1. addpath in tasks 

#### Bugs:
###### 1. Run actual becnchop files instead of stupid dummy matlab file
