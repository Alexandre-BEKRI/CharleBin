install:
	bin/composer install

start:
	php -S localhost:8080

test:
	# cd tst && ../vendor/bin/phpunit
	./vendor/bin/phpunit tst

lint:
	echo "Vérification de la syntaxe PHP ..."
	php -l cfg/conf.sample.php
	
	echo "Analyse du style de code..."
	./vendor/bin/phpcs --extensions=php ./lib/
	
	echo "Détection des problèmes potentiels..."
	./vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
	
	echo "Vérifications terminées !"