# Contribuer à CharleBin
Merci de l'intérêt que vous portez à CharleBin ! Toutes les contributions sont les bienvenues.

## Signaler un bug ou proposer une idée
Avant d'ouvrir une issue, merci de vérifier qu'elle n'existe pas déjà.

Si vous ouvrez une nouvelle issue pour un bug, merci de préciser :
- Le contexte et les étapes pour reproduire le bug.
- La version de l'environnement utilisée.

## Linters
Pour maintenir la qualité du code, ce projet utilise des outils d'analyse (linters).
- Assurez-vous de lancer le linter avant chaque commit : ```bash make lint ```

### Installations

#### PHP Lint
Sert à vérifier la syntaxe du fichier PHP, sans l’exécuter.

    ```
        Rien à faire, inclus dans php
    ``` 
##### Utilisation en commande

    ```bash 
        php -l fichier.php
    ```

#### PHP Code Sniffer
<br>Permet de détécter les violations de style du code selon les standards recommendée de PHP.

    ```bash 
        composer require --dev "squizlabs/php_codesniffer=3.*"
    ```
##### Utilisation en commande

    ```bash
        ./vendor/bin/phpcs --extensions=php ./lib/
    ```
- `--extensions=php` : analyse uniquement les fichiers `.php`
- `./lib/` : dossier cible à analyser

#### PHP Mess Detector
<br>Identifie les problèmes potentiels : code trop complexe, variables inutilisées, nommage incorrect.

    ```bash
        composer require --dev "phpmd/phpmd=@stable"
    ```
##### Utilisation en commande

    ```bash
        ./vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
    ```
- `ansi` : format de sortie colorée dans le terminal
- `codesize` : détecte les méthodes/classes trop longues
- `unusedcode` : repère les méthodes non appelée ou des variables inutilisés.
- `naming` : vérifie les conventions de nommage

#### PHP CS Fixer
<br>Corrige automatiquement le style de code pour respecter les standards.

```bash
composer require --dev "friendsofphp/php-cs-fixer"
```
##### Utilisation en commande

```bash
./vendor/bin/php-cs-fixer fix ./lib --dry-run --diff
```
- `fix` : commande pour corriger le code
- `--dry-run` : simule les corrections sans modifier les fichiers (retirer pour appliquer)
- `--diff` : affiche les changements qui seront effectués

### Exécution regroupée (dans un seul Makefile)
<br>Regroupement des commandes de linting avec les options que je recommande.

```makefile
lint:
	echo "Vérification de la syntaxe PHP ..."
	php -l cfg/conf.sample.php
	
	echo "Analyse du style de code..."
	./vendor/bin/phpcs --extensions=php ./lib/
	
	echo "Détection des problèmes potentiels..."
	./vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
	
	echo "Vérifications terminées !"
```

## Processus de Pull Request (Workflow)
<br>Pour toute modification, veuillez respecter ce processus :

1. **Etablir un Fork**
    <br>Consistant à créer une copie du dépôt officiel sur votre propre dépot GitHub.
    
    Situez-vous sur le dépôt officiel, et modifier le remote 'origin' :
    ```bash
        # S'assurer d'être sur la branche principale à jour
        git switch main
        git pull

        # Changer l'adresse 'origin' pour qu'elle pointe vers votre fork
        git remote set-url origin [URL_DE_VOTRE_DEPOT] 
        
        # Pousser le contenu sur votre nouveau dépôt distant
        git push -u origin main
    ```

    Situez-vous à présent sur le vôtre :
    ```bash
        git fetch
    ```

2. **Création de branche**
    <br>Créez une branche avec un nom descriptif de la feature ou fix.
    ```bash
        git switch -c nom-explicite
    ```
   > *"Name Well; Rename When Needed"* — Utilisez des noms de branches clair et identifiable.

3. **Commits atomiques** 
    <br>Faites des commits petits et focalisés sur une seule chose.
    ```bash
        git add fichier_modifié.php
        git commit -m "Add: description courte et claire"
    ```
    > *"Don't Repeat Yourself"* — Un commit = une modification logique. Évitez les commits fourre-tout.

4. **Vérification avant push** 
    <br>Lancez les linters et tests avant de pousser.
   ```bash
        make lint
   ```
   > *"Test Early, Test Often, Test Automatically"*

5. **Envoi vers votre dépôt (Push)**
    <br>Une fois votre travail terminé et testé en local, envoyez votre branche sur votre fork GitHub.
    ```bash
        git push origin nom-explicite
    ```

6. **Ouverture de la Pull Request (PR)**
   <br>Dans la PR, précisez :
   - **Quoi** : Ce que vous avez modifié
   - **Pourquoi** : La raison de ce changement
   - **Comment tester** : Les étapes pour vérifier

    Remarque : Assurez-vous que la "base repository" est bien le dépôt officiel et que la "head repository" est bien votre fork.

7. **Code Review** 
    <br>Attendez la relecture d'un mainteneur.
    > *"Critically Analyze What You Read and Hear"* — La review améliore la qualité et partage les connaissances.
   
    Répondez aux commentaires et apportez les modifications demandées si nécessaire.

8. **Merge par les mainteneurs**  
    <br>Une fois approuvée, un admin mergera votre PR.
   
    Après le merge, vous pouvez supprimer votre branche locale :
    ```bash
        git switch main
        git pull origin main
        git branch -d nom-explicite
    ```