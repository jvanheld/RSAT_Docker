# RSAT_Docker

## Contenu

CommandLineImage  
CreateImage  
Images  
InstallLog  
makefile  
RsatWebDockerOld.sh  
RsatWebDocker.sh  
StartContainer.txt


## CommandLineImage : Execution scripts rsat en ligne de commande

- Arborescence : 3 repertoires à la racine d'ou la commande docker est lancée (docker run) : DockerIn, DockerOut, DockerTodo
- DockerRun.sh : Contient la commande docker à lancer pour executer le script rsat
- DockerTodo.sh : Contient la commande rsat à lancer(repertoire DockerTodo)
- list.genes : Fichier d'entrée de la commande rsat(repertoire DockerTodo) 
- Sortie : output.txt

## CreateImage : Creation d'une image Docker de rsat depuis le shell linux

- RsatCreateImage.06.sh : script shell (tiré du script d'install de rsat que tu m'as passé et que j'ai adapté)
- Howto-RsatCreateImage.txt : mode d'emploi du script de création d'image
- Le mode d'emploi a été testé sous debian mais devrait fonctionner aussi sous centos ou ubuntu. De toute façon il a pour but de créer une image docker contenant rsat sous debian, laquelle image est indépendant du systeme
(l'usage du conteneur necessite seulement l'installation de docker sur un systeme hote). Le howto suppose un espace disque suffisant,la possibilité d'usage d'un compte root, d'une interface réseau(eth0), de ssh et d'une licence vmatch. Rien d'autre n'est nécessaire; l'installation occupera de l'espace sur la machine hote, installation de docker et curl c'est tout. Tout le reste sera installé sans interference avec le systeme hote dans un espace propre à docker. En fin, une image docker de rsat sera créée (docker commit) puis stockée sur la machine hôte (docker save). Cette image correspond à l'installation d'un système debian minimum puis l'installation traditionnelle de rsat sous ce système debian. Cette image stockée est un fichier (assez gros 3-4 gigas) qui peut se copier pour être joué sur toute machine ou docker est installé

## Images : Images docker de rsat sous debian dans diverses versions

## InstallLog : logs générés par la création d'image rsat (RsatCreateImage.06.sh)

## RsatWebDocker.sh : script de lancement d'un serveur web rsat à partir d'un conteneur docker rsat sous linux

Le mode d'emploi de RsatWebDocker.sh est contenu dans  StartContainer.txt
Le fichier makefile correspond à ce que tu as fait en make à partir de mon script RsatWebDocker.sh

