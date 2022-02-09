# Compagnon_Virtuel


-----------------------------------
-- Compte rendu des rendez-vous  --
-----------------------------------


étudiants présents aux RDVs : Ruffieux Mathis et Dugaleix Nereis 
enseignante chercheuse : Mme. Lydie du Bousquet

Lieu des RDVs : bâtiment IMAG (le LIG) 

-----------------------------------
Lundi 20 septembre 2021 :

Ce projet est en partenariat avec l’université de Kobe au Japon.
Ils ont réalisé un compagnon virtuel surnommé Mei Chan, pour converser avec des personnes isolées, comme les personnes âgées mais aussi les jeunes isolés.
Ils utilisent l’application LINE et envoient tous les jours une question du type “How are you today?” 
L’application a pour but aussi de détecter d'éventuelles pathologies chez ces personnes, comme par exemple des pertes de mémoire. 
Notre but sera de créer une application qui s’en rapproche.

Mais parfois ce sont des données de santé, ce qui pose un problème si on passe par une application qui ne nous appartient pas. 
C’est pourquoi nous devons développer notre propre application mobile.

L’année dernière (en 2020/2021), un groupe d’étudiants de M1 a développé une première application fonctionnelle, sur laquelle une question est posée à l’utilisateur. 
Cependant, la question est toujours la même et il n’y a pas de système de notification. 
De plus, la réponse à la question n’est pas enregistrée. 

Notre travail consiste à reprendre ce projet en l’améliorant, en utilisant les technologies de Flutter et Dart. 

Notre idée est de changer l’interface en réalisant quelque chose qui se rapproche d’une messagerie afin d’effectuer un dialogue avec l’utilisateur. 

-----------------------------------
Lundi 27 septembre :

Exemple de fonctionnalités attendues :
-un système de notifications, une question est posée chaque jour
-après avoir posé une question du type ”Comment vas-tu aujourd'hui?" ou “As-tu bien mangé?”, s'ensuit un petit dialogue interactif avec des arbres de réponses.

Lors de la première utilisation de l’application, l’IA nous propose tout sous la forme d’un dialogue, comme le prénom, l'âge etc. 
De même si l'utilisateur souhaite effectuer une action ça sera sous la forme d’un dialogue 
exemple “Veux tu jouer?” , "Souhaites-tu ouvrir le journal de telle date ?” 

Il faudra implémenter un journal, de type calendrier. L’utilisateur aura des boutons sur lesquels appuyer qui feront demander à l’IA "Souhaites-tu ouvrir le journal de telle date ?” puis il cliquera sur “oui” ou “non” (toujours sur la forme d’arbre de dialogues)
Il pourra éditer ce journal pour y écrire ce qu’il souhaite (exemple : un événement important) et y enregistrer. 

Il faudra donc pouvoir enregistrer les informations sur le téléphone en local et pas en ligne pour des questions éthiques. 

+Pourquoi ne pas créer un avatar pour l’IA avec différentes expressions faciales ?
Il ne faut pas que ce soit trop humanisant, donc par exemple un avatar d’animal ou de robot. 

-----------------------------------
Lundi 4 octobre :

Liste des tâches “prioritaires” à effectuer :
-Pouvoir enregistrer les données sur le téléphone, le dialogue et le journal. 
-Pouvoir ensuite récupérer les données manuellement, si elles ont besoin d’être analysées par un spécialiste du médical.
-Mise à jour automatique en ligne : pouvoir télécharger de nouvelles questions 

tâches secondaires :
-paramétrage lors d’un dialogue de lancement
-rédiger le cahier des charges
-interface responsive 

idées :
calculer des états dans le dialogue en implémentant des variables (rond triangle carré) pour analyser l’état émotionnel de la personne et ainsi adapter les réponses de l’IA.

-----------------------------------
Mardi 19 octobre :

On a réussi à :
enregistrer un integer qui s’incrémente dans un fichier texte. 

On a discuté de l'éventuelle possibilité d’effectuer un voyage pour notre projet au Japon en fin d’année si les circonstances en conviennent (ouverture des frontières et intérêt du projet)

L’application MikouChan pourra reconnaître les activités journalières automatiquement 

Il faudra que notre application mobile passe la commission d'éthique pour être utilisable 
La commission d’éthique souhaite que les données ne soient pas stockées en ligne mais en local uniquement. (les questions peuvent être récupérées en ligne mais les réponses ne doivent pas y être sauvegardées) 
Possibilité donc d’utiliser un API. 


-----------------------------------
Lundi 25 octobre - premier RDV avec Damien Pellier :

On a discuté de l’évaluation de la ère soutenance, il faut rédiger un cahier des charges qui dira :
-voilà ce qu’on va faire, les différentes fonctionnalités
-définir les scénarios tests (par exemple une personne âgée qui s’enregistre, ou un praticien qui récupère les données sur le téléphone) 
-présenter le plan de développement

On a parlé de SQL Lite qui peut être utilisé sur mobile sans réseau afin d'enregistrer les réponses aux questions.
On a appris que le LIG a des serveurs sur lesquels il faut ouvrir un port.
De plus il faut rédiger les comptes rendu des RDVs 

De nouvelles questions se posent : 
Quelles technos pour définir les arbres de dialogues ? Il ne faut pas réinventer la roue 
Utilisation possible de dialogflow ? 

-----------------------------------
Mardi 9 novembre - RDV avec Lydie du Bousquet :

On a présenté SQLite : la possibilité d’enregistrer les données en local - bonne idée 
On a parlé de Dialogflow : ce n'est pas une bonne idée car ça nécessite d’envoyer les réponses en ligne sur un service Google (même si on ne les stockes pas). 
Par contre ça peut être utile pour récupérer et mettre à jour les questions, à voir. 

Les prochaines étapes d’implémentation seront : 
-de refactorer l’application existante avec SQL Lite 
-d’essayer de créer une première interface de dialogue 

Il y aura deux type de questions :
-des questions fermées (cliquer sur “Oui”, “Non” etc.) 
-des questions ouverte auxquelles l’utilisateur pourra répondre en écrivant (ce n’est pas prioritaire à implémenter) 

Nous avons présenté une image d’un robot qui pourra représenter l’IA 

Pour rédiger le cahier des charges, exemple de tests utilisateurs :
-demander à une personne âgée de télécharger l’application
-télécharger l’application sur des téléphones différents

Chercher dans l’ancien projet (celui de 2020/2021) si il y a des tests automatisés, sinon il faudra les implémenter.



-----------------------------------
Mardi 23 novembre - RDV avec Lydie du Bousquet :


On a discuté du cahier des charges pour avancer dans la rédaction 
Introduction d’un outil de développement : Flutterflow qui permet de créer des wigets en Flutter 

suggestions : faire un diagramme de classe du programme
et diagramme de classe du concepte de dialogue pour la BD 

pour l’interface, respecter les critères de Bastiens et Scapin 

On lui a montré un exemple de BDD avec les dialogues et des automates représentants différents scénarios, tel que le scénario de lancement 
Il faut que la BD respecte le format 3NF, pour éviter les répétitions 

Cet arbre de dialogue serait dans un module remplaçable, car par la suite on voudra peut etre améliorer l’application avec autre chose comme une reconnaissance vocale ou une interprétation des réponses ouvertes 

Pour les mises a jour, fichier en format csv

-----------------------------------
lundi 29 novembre - RDV avec Damien Pellier :

cahier de recettes : 3 acteurs
un utilisateur de l’application
un scientifique qui récupère les données
un informaticien qui met à jour la BDD 

diagrammes pour la bdd
expliquer les choix techniques
description des technos
architecture de l’appli

Plan de développement :
diagramme de gantt sur le semestre
sans oublier la dépendances entre les tâches 

-----------------------------------
lundi 6 décembre - RDV avec Lydie du Bousquet

Lors de ce rendez-vous, nous avons présenté des idées à mettre dans le cahier des charges.
Pour les nouveaux scénarios, Lydie ne souhaite pas qu’on poste les questions en ligne au travers d’une BDD mais plutôt avec un fichier brut en format CSV via un lien téléchargeable, car il n’est peut être pas possible de maintenir cette BDD dans le temps.

Nous avons discuté d’un processus de développement de type agile, avec des sprints. 
Dans le diagramme de Gantt, il y aura l’ordre et le temps passé pour chaque tâche à effectuer. Pour notre projet il n’y a pas forcément un ordre précis à respecter, mais seulement un ordre de priorité de tâches. 

Pour le diagramme de classes, il faut représenter les concepts que l’on va manipuler avant l’implémentation.

Nous avons proposé une idée de schéma de BDD, avec des bulles de dialogues, écrites soit par le robot soit par l’utilisateur. Ce dialogue sera enregistré dans un historique en local, pour ensuite pouvoir être visualisé dans la fenêtre de dialogue.


-----------------------------------
vendredi 17 décembre - Tournage d’une vidéo sur le projet SCUSI Kouno Tori

Ce jour-là nous avons participé au tournage d’une vidéo de l’UGA concernant notre projet.
Ce tournage avait pour but de montrer les relations internationales de l’UGA en montrant un exemple concret avec notre projet qui est en partenariat avec l’université de Kobe au Japon.

Nous leur avons montré notre maquette de l’application et une vidéo de démonstration de son utilisation, puis nous avons été filmés dans le bâtiment de l’Imag, en train de travailler sur la maquette et de discuter pendant une réunion. 
Il y a aussi eu des interviews individuelles de Lydie et de Mathis concernant nos motivations concernant le projet ainsi qu’un éventuel déplacement au Japon pour cet été si la situation sanitaire le permet.
Mais malheureusement Néréïs n’a pas pu être présent pour les interviews ce jour-là. 

Par ailleurs, Lydie a été filmée à titre individuelle en visioconférence avec un professeur de l’université de Kobe, et des plans de l’Imag ainsi que de l’UGA ont été filmés.

-----------------------------------
vendredi 7 janvier 2022 - RDV avec Lydie du Bousquet

Lors de ce RDV nous avons présenté les documents au brouillon avant de les rédiger, afin de vérifier leurs informations ensemble. 
Les documents concernés sont : le cahier des charges, le cahier de recettes et le plan de développement.

Dans la partie “Organisation des tâches”, Lydie nous a conseillé de parler des actions produites par l’application, c'est -à -dire les Use-cases.

Nous avons parlé d’exemples de Springs, tel que : un Spring pour la prise en main du sujet, un Spring pour l’élaboration des documents à rendre etc. 

Nous avons aussi parlé des critères de qualités, ils doivent être mesurables.
Par exemple, la pertinence des dialogues peut être mesurée grâce à un retour des utilisateurs comme un moyen de les évaluer. Par un système de “likes” ou sous la forme d’un sondage. 

Une autre idée de fonctionnalité a émergée : la possibilité de “skip” les dialogues avec un bouton. 

-----------------------------------
jeudi 27 janvier 2022 - RDV en visioconférence

Nous lui avons montré une implémentation de l’interface de dialogue avec le robot avec un exemple de conversation de réponses fermées. (scénario des fruits)
Nous avons discuté de la possibilité d’ajouter des “likes” ou des “dislikes” aux messages du robot. 
Les prochaines étapes sont la possibilité d’écrire des réponses ouvertes dans les bulles de dialogues et d’implémenter le scénario de premier lancement de l’application.

L’implémentation de la BD sur SQF lite ne viendra qu’une fois que nous pourrons écrire des réponses ouvertes pour les enregistrer dans des variables (tel que le genre, le nom et l'âge de la personne) car ces données devront être aussi enregistrées sur le téléphone. 

Pour nous aider au débogage, nous pouvons écrire ifdef pour l'affichage des print. 

Le prochain RDV sera le mercredi 9 février. 


-----------------------------------
mercredi 9 février 2022 - RDV en visioconférence 

Sur l’interface :
Nous lui avons montré des bulles de dialogues responsives avec 3 tailles différentes, ainsi que la possibilité de liker la dernière bulle affichée.  
Lydie souhaite, de la même manière que les likes, qu’on puisse passer une bulle en bulle “secrète” qui ne serait pas enregistrée dans les tables et donc illisibles sur les données du téléphones. 
Il faudrait aussi avoir la possibilité de liker ou non les messages qui précèdent la dernière bulle de dialogue.

Sur les BDD :
Nous lui avons montré un schéma relationnel des BDD des scénarios du robot et de l’utilisateur. Il faut effectuer un petit changement entre le lien de ces tables. 
Il faut notamment réfléchir à comment savoir si le robot attend une réponse ouverte ou fermée de la part de l'utilisateur, en étant plus clair dans les tables sans “hard coder”. 

Nous devons réfléchir aussi à comment passer d’un scénario à l’autre dans l’algorithme de discussion. 

Pour des cas particulier tel que récupérer la variable du prénom de l’utilisateur, réfléchir à savoir comment ne récupérer que son prénom et pas toute la phrase (“par exemple récupérer nom = “Jean” et pas nom = “Mon nom est Jean”). 

Nous avons brièvement parlé du Japon et les frontières sont toujours fermées. 

Le prochain RDV aura lieu le mardi 1er mars. 








eof
