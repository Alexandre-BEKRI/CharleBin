install:
	php bin/composer install

start:
	php -S localhost:8080

test:
	# cd tst && ../vendor/bin/phpunit
	php vendor/bin/phpunit tst

lint:
	echo "Vérification de la syntaxe PHP ..."
	php -l cfg/conf.sample.php
	
	echo "Analyse du style de code..."
	php vendor/bin/phpcs --extensions=php ./lib/
	
	echo "Détection des problèmes potentiels..."
	php vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
	
	echo "Vérifications terminées !"