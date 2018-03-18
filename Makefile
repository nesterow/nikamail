build:
	sudo docker build -t nikamail .

run:
	sudo docker run -v $$(pwd):/data -p 4025:25 -p 4110:110 -p 4587:587 -it nikamail:latest app/main.rb
