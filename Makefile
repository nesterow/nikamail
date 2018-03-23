build:
	javac -cp ".:lib/*:lib/ext/*" -d lib/ext $$(find ./app/lib/java/* | grep .java)
	cd lib/ext && jar -cvf ../ext.jar *
	docker build -t nikamail .

console:
	docker run  -v $$(pwd):/data -p 25:25 -p 110:110 -p 587:587 -p 127.0.0.2:10080:10080 -p 127.0.0.2:12080:12080 -it nikamail:latest app/main.rb console

run:
	docker run -v $$(pwd):/data -p 25:25 -p 110:110 -p 587:587 -p 127.0.0.2:12080:12080 -it nikamail:latest app/main.rb

start:
	docker run  -d --restart=always --name=nikamail -v $$(pwd):/data -p 25:25 -p 110:110 -p 587:587 -p 127.0.0.2:12080:12080 -it nikamail:latest app/main.rb

stop:
	docker stop nikamail
	docker rm nikamail

restart: stop start