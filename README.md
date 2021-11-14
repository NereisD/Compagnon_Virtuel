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

L’année dernière (en 2019/2020), un groupe d’étudiants de M1 a développé une première application fonctionnelle, sur laquelle une question est posée à l’utilisateur. 
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

Chercher dans l’ancien projet (celui de 2019/2020) si il y a des tests automatisés, sinon il faudra les implémenter.










eof
