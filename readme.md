# CharleBin 
> (Compte rendu en Qualité de développement - BEKRI Alexandre)

CharleBin est un gestionnaire d'extraits de texte et de code source (pastebin), minimaliste et open source. 
Il s'agit d'une version modifiée de PrivateBin adaptée pour l'IUT Charlemagne, garantissant que le serveur n'a aucune connaissance des données envoyées (chiffrement AES 256 bits).

## Pré-requis
Avant de commencer, assurez-vous d'avoir :
- Un environnement supportant PHP.
- Git installé sur votre machine.
- Un navigateur web moderne pour le déchiffrement local.

## Installation
Pour installer le projet en local pour le développement :

1. Clonez le dépôt :
   ```
   git clone git@github.com:Alexandre-BEKRI/CharleBin.git
   ```
2. Entrer dans le dépot :
    ```bash
    cd CharleBin
    ```
3. Puis installer les dépendances :
    ```bash
    make install
    ``` 

## Développement

### Lancer le serveur local
Pour démarrer le serveur de développement sur `localhost:8080` :
```bash
make start
```

### Exécuter les tests
Pour lancer les tests unitaires avec PHPUnit :
```bash
make test
```

### Configuration
Copiez le fichier de configuration d'exemple et adaptez-le à vos besoins :
```bash
cp cfg/conf.sample.php cfg/conf.php
```

## Structure du projet
- `lib/` - Classes PHP du backend (Controller, Model, View, etc.)
- `tpl/` - Templates d'affichage
- `js/` - Scripts JavaScript (chiffrement côté client)
- `css/` - Feuilles de style
- `tst/` - Tests unitaires
- `cfg/` - Fichiers de configuration
- `i18n/` - Fichiers de traduction 

## Déploiement
Le déploiement de CharleBin s'effectue en transférant les fichiers sur un serveur web standard supportant PHP (Apache) ou via un conteneur Docker dédié.

## Corrections de la qualité de code (Linters)

Les erreurs suivantes ont été détectées par les linters (`make lint`) et corrigées :

### Corrections manuelles (make lint)

1. **`cfg/conf.sample.php`** - Ajout de `*/` pour fermer le commentaire PHP
2. **`lib/View.php`** - Majuscules au début des descriptions PHPDoc
3. **`lib/Vizhash16x16.php`** - Préfixe `_` ajouté aux variables privées
4. **`lib/YourlsProxy.php`** - Paramètre `$conf` ajouté dans PHPDoc
5. **`lib/I18n.php`** - Placement du `else` sur la même ligne que `}`
6. **`lib/Model/I18n.php`** - Suppression d'un paramètre inutilisé dans la méthode `_()`

### Corrections automatiques (PHP CS Fixer)

Ce qui peut être corrigées automatiquement via PHP CS Fixer :
```bash
./vendor/friendsofphp/php-cs-fixer/php-cs-fixer fix "le répertoire ou fichier à corriger"
```

## Pre-commit hook (Automatisation)
Il s'agit d'un script exécuté automatiquement avant chaque commit Git, vérifiant que le code respecte certaines règles de qualité définies dans ce dernier (ex. linters, tests unitaires, etc.)

### Création du hook
Création d’un script `.git/hooks/pre-commit` :
```bash
    #!/usr/bin/env bash    

    # Fonction qui concatène une liste en une chaîne séparée par des virgules 
    function join_by {
        local d=${1-} f=${2-}
        if shift 2; then
            printf %s "$f" "${@/#/$d}"
        fi
    }

    # Si une commande échoue, on arrête tout et le commit est annulé
    set -eo pipefail

    # Récupèrer la liste des fichiers staged à ce commit (ACMR : Added, Copied, Modified, Renamed)
    CHANGED_FILES=$(git diff --name-only --cached --diff-filter=ACMR) # Format : "file1.php file2.php file3.php"

    # Transforme $CHANGED_FILES en une chaîne séparée par des virgules (utile en argument de PHPmd)
    CHANGED_FILES_JOINED=$(join_by , $CHANGED_FILES) # Format : "toto.php,titi.php,tata.php"

    if [[ -n "$CHANGED_FILES" ]]
    then
        echo "Des fichiers modifiés sont détéctés : $CHANGED_FILES"

        echo "Lancement des vérifications..."

        echo "Correction automatique avec PHP CS Fixer..."
        # On le lance pour le dossier lib
        ./vendor/friendsofphp/php-cs-fixer/php-cs-fixer fix $CHANGED_FILES

        # On ajoute les fichiers potentiellement modifiés par le fixer
        git add $CHANGED_FILES

        echo "Analyse avec PHP Mess Detector"
        # Si PHPmd trouve des erreurs, il renvoie un code d'erreur qui bloquera alors le commit
        ./vendor/bin/phpmd $CHANGED_FILES_JOINED ansi codesize,unusedcode,naming

        echo "Votre commit est validé !"
    else
        echo "Aucun fichier modifié, commit annulé."
        exit 0
    fi
```
Remarque : L’ajout de `| grep '\.php$'` à la commande de la variable $CHANGED_FILES permet de ne sélectionner que les fichiers PHP. Ce qui serait pertinent puisque les linters utilisés ne concernent que ce type de fichiers.

Veuillez bien donner les permissions d'exécution (si besoin):
```bash
    # Pour les utilisateurs de Linux / macOS :
    chmod +x .git/hooks/pre-commit
```

**Rappel :** Pour les utilisateurs de Windows (PowerShell / CMD), l’exécution via `./vendor/bin/...` n’est pas supportée. Préférez l’une des alternatives suivantes :
- Via PHP : `php vendor/bin/phpcs`, `php vendor/bin/phpmd`
- Via l'exécutable .bat : `vendor/bin/phpcs.bat`, `vendor/bin/phpmd.bat`

#### Contournement possible :
Si vous souhaitez faire un commit sans exécuter le hook (par exemple, pour des corrections rapides), vous pouvez utiliser l'option `--no-verify` :
```bash
    git commit -m "Votre message de commit" --no-verify
```

> **Attention** : Utiliser `--no-verify` peut entraîner l'introduction de code non conforme aux standards de qualité, il est donc recommandé de l'utiliser avec parcimonie.

## CI (Continuous Integration)
La CI (Continuous Integration) est un principe qui permet de lancer des outils de qualité de code sur chaque PR. Cela garantit que le code reste de haute qualité et permet d'interdire de la merger dans main si les attentes ne sont pas respectées.

### Mise en place d'un workflow GitHub Actions pour le linting
1. Créer le dossier `.github/workflows` à la racine du projet (s'il n'existe pas déjà) :
```bash
mkdir -p .github/workflows
```

2. Création d'un workflow GitHub Actions dans `.github/workflows/lint.yml` :
```yaml
name: Lint PHP

on:
  pull_request:
    branches: [ main ]

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
      # 1. Rapatrie le code source du dépôt sur le serveur GitHub (pour pouvoir l'analyser)
      - name: Checkout code
        uses: actions/checkout@v3

      # 2. Configure l'environnement PHP
      - name: Set up PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'

      # 3. Installe les linters via Composer
      - name: Install dependencies
        run: composer install

      # 4. Exécute les 3 linters d'un coup
      - name: Run lint via Makefile
        run: make lint
```
3. Poussez ce workflow sur votre branche :
```bash
git add .github/workflows/lint.yml
git commit -m "Ajout du workflow CI lint"
git push -u origin main
```

### Protéger la branche principale (`main`)
Afin de forcer l'utilisation des Pull Requests et rendre l'étape de linting obligatoire avant toute fusion, il faut configurer le dépôt distant :

1. Aller dans l'onglet **Settings** du dépôt GitHub.

2. Dans le menu de gauche, cliquer sur **Branches** puis sur **Add branch protection rule**.

3. Dans le champ **Branch name pattern**, indiquer `main`.

4. Cocher l'option **Require a pull request before merging** pour forcer la création de PR.

5. Cocher l'option **Require status checks to pass before merging** , puis après qu’une première Pull Request ait déclenché le workflow, sélectionner le nom de notre job (`lint`) pour le rendre strictement obligatoire.

> **Remarque Importante** : Si le nom de votre job (`lint`) n'apparaît pas dans la barre de recherche, vous pouvez sauvegarder la règle malgré tout. Il vous faudra ensuite créer une PR pour que le workflow s'exécute au moins une fois. Une fois ceci fait, le job sera référencé dans la liste des status checks requis. (cf. Processus de Pull Request - `contribution.md`)

6. Cliquer sur **Create** pour sauvegarder la règle.

Se rendre dans l'onglet "Actions" de votre dépôt GitHub pour voir le workflow en action à chaque PR. Ainsi, si le workflow échoue, la pull request ne pourra pas être mergée tant que les problèmes ne seront pas corrigés.