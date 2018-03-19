build:
	docker build -t nikamail .

run:
	docker run -v $$(pwd):/data -p 25:25 -p 110:110 -p 587:587 -p 12080:12080 -it nikamail:latest app/main.rb

run-daemon:
	docker run -d -v $$(pwd):/data -p 25:25 -p 110:110 -p 587:587 -p 12080:12080 -it nikamail:latest app/main.rb

stop-daemon:
	echo "Implement It"