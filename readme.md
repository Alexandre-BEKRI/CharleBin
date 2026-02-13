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