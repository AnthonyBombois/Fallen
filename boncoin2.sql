#------------------------------------------------------------
#        Script MySQL.
#------------------------------------------------------------


#------------------------------------------------------------
# Table: civilite
#------------------------------------------------------------

CREATE TABLE civilite(
        id_civilite      Int  Auto_increment  NOT NULL ,
        civilite_libelle Varchar (50) NOT NULL
	,CONSTRAINT civilite_PK PRIMARY KEY (id_civilite)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: profil
#------------------------------------------------------------

CREATE TABLE profil(
        id_profil      Int  Auto_increment  NOT NULL ,
        profil_libelle Varchar (50) NOT NULL
	,CONSTRAINT profil_PK PRIMARY KEY (id_profil)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: utilisateur
#------------------------------------------------------------

CREATE TABLE utilisateur(
        id_utilisateur       Int  Auto_increment  NOT NULL ,
        utilisateur_pseudo   Varchar (50) NOT NULL ,
        utilisateur_nom      Varchar (50) NOT NULL ,
        utilisateur_prenom   Varchar (50) NOT NULL ,
        utilisateur_mail     Varchar (100) NOT NULL ,
        utilisateur_password Varchar (25) NOT NULL ,
        utilisateur_ville    Varchar (50) NOT NULL ,
        id_civilite          Int NOT NULL ,
        id_profil            Int NOT NULL
	,CONSTRAINT utilisateur_PK PRIMARY KEY (id_utilisateur)

	,CONSTRAINT utilisateur_civilite_FK FOREIGN KEY (id_civilite) REFERENCES civilite(id_civilite)
	,CONSTRAINT utilisateur_profil0_FK FOREIGN KEY (id_profil) REFERENCES profil(id_profil)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: categorie
#------------------------------------------------------------

CREATE TABLE categorie(
        id_categorie      Int  Auto_increment  NOT NULL ,
        categorie_libelle Varchar (50) NOT NULL
	,CONSTRAINT categorie_PK PRIMARY KEY (id_categorie)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: annonce
#------------------------------------------------------------

CREATE TABLE annonce(
        id_annonce               Int  Auto_increment  NOT NULL ,
        annonce_titre            Varchar (50) NOT NULL ,
        annonce_description      Text NOT NULL ,
        annonce_date_publication Date NOT NULL ,
        id_categorie             Int NOT NULL ,
        id_utilisateur           Int NOT NULL
	,CONSTRAINT annonce_PK PRIMARY KEY (id_annonce)

	,CONSTRAINT annonce_categorie_FK FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
	,CONSTRAINT annonce_utilisateur0_FK FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: note
#------------------------------------------------------------

CREATE TABLE note(
        id_note        Int  Auto_increment  NOT NULL ,
        note_compteur  Int NOT NULL ,
        id_utilisateur Int NOT NULL ,
        id_annonce     Int NOT NULL
	,CONSTRAINT note_PK PRIMARY KEY (id_note)

	,CONSTRAINT note_utilisateur_FK FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur)
	,CONSTRAINT note_annonce0_FK FOREIGN KEY (id_annonce) REFERENCES annonce(id_annonce)
)ENGINE=InnoDB;

/* Sélection de tous les annonces */

select * from annonce;

select annonce_titre from annonce order by annonce_titre;

select annonce_titre from annonce order by annonce_date_publication desc;

/* Sélection de toutes les annonces publiées après le 02 mars 2019 */

select annonce_titre,annonce_date_publication
from annonce
where annonce_date_publication > '2019-03-02';

/* Sélection de tous les utilisateurs de sexe masculin */

select utilisateur_pseudo
from utilisateur,civilite
where utilisateur.id_civilite = civilite.id_civilite
and civilite_libelle = 'Monsieur';

/* Sélection de toutes les catégories représentées par au moins une annonce */

select categorie_libelle
from categorie,annonce
where annonce.id_categorie = categorie.id_categorie;

/* Sélection de toutes les annonces rangées dans la catégorie « Ameublement » et de type « Particulier » */

select annonce_titre
from categorie,annonce,utilisateur,profil
where categorie_libelle = 'Ameublement'
and categorie.id_categorie = annonce.id_categorie
and annonce.id_utilisateur = utilisateur.id_utilisateur
and utilisateur.id_profil = profil.id_profil
and profil_libelle = 'Particulier';

/* Sélection de tous les pseudos ayant mis une note supérieure à 4 pour les annonces de catégorie « Aménagement d’intérieur » */

select utilisateur_pseudo
from utilisateur,note,annonce,categorie
where utilisateur.id_utilisateur = note.id_utilisateur
and note.id_annonce = annonce.id_annonce
and annonce.id_categorie = categorie.id_categorie
and note_compteur >= 4
and categorie_libelle = 'Aménagement d\'intérieur'
order by utilisateur_pseudo;

/* Ajout d’un internaute : pseudo : « OKLM », ville : « Paris » */

insert into utilisateur(utilisateur_pseudo,utilisateur_ville)
values ('OKLM','Paris');

/* Ajout d’une annonce : titre : « Cours de soutien SQL », descriptif : « Me contacter », date de publication : « 10/04/2019 », catégorie : « Formation » */

select id_categorie from categorie
where categorie_libelle = 'Formation'; /* 181 */

select id_utilisateur from utilisateur
where utilisateur_prenom = 'Pierre' and utilisateur_nom = 'Vélon'; /* 5 */

insert into annonce
values (NULL,'Cours de soutien SQL','Me contacter','2019-04-10',181,5);

/* Ajout d'un utilisateur ayant pour pseudo eemi, nom Dupont, prénom Marie, mail marie.dupont@eemi.com, profil Professionnel */

select id_civilite from civilite
where civilite_libelle = 'Madame'; /* 3 */

select id_profil from profil
where profil_libelle = 'Professionnel'; /* 50 */

insert into utilisateur 
values (NULL,'eemi','Dupont','Marie','marie.dupont@eemi.com','','',3,50);

insert into utilisateur(utilisateur_pseudo,utilisateur_nom,utilisateur_prenom,utilisateur_mail,id_civilite,id_profil)
values('eemi','Dupont','Marie','marie.dupont@eemi.com',3,50);

/* Modification du mot de passe de Mme Petit : « secret » */

update utilisateur set utilisateur_password = 'secret'
where utilisateur_nom = 'Petit'
and id_civilite in (select id_civilite from civilite where civilite_libelle = 'Madame');

/* Modification de la note de l’internaute ayant comme pseudo « classe1 » pour l’annonce « SQL » rangée dans la catégorie « Cours / soutien » : la note passe à 5 */

update note set note_compteur = 5
where id_utilisateur in (select id_utilisateur from utilisateur where utilisateur_pseudo = 'classe1')
and id_annonce in (select id_annonce from annonce,categorie where annonce.id_categorie = categorie.id_categorie and annonce_titre = 'SQL' and categorie_libelle = 'Cours / soutien');

/* Modification de la date de publication (15/05/2020) pour les annonces de la catégorie 'Rencontres' et postées par des professionnels */

update annonce
set annonce_date_publication = '2020-05-15'
where id_categorie in (select id_categorie from categorie where categorie_libelle = 'Rencontres')
and id_utilisateur in (select id_utilisateur from utilisateur,profil where utilisateur.id_profil = profil.id_profil and profil_libelle = 'Professionnel');

/* Suppression de la catégorie « Bien-être » */

delete from categorie where categorie_libelle = 'Bien-être';

/*  Suppression des notes du pseudo « Soo » */

delete from note where id_utilisateur in (select id_utilisateur from utilisateur where utilisateur_pseudo = 'Soo');

/* Sélection des catégories pour lesquelles les annonces de type « Professionnel » ont eu une note supérieure à 3 par des internautes domiciliés à « Lyon » */

select distinct(categorie_libelle)
from categorie,annonce,note,utilisateur,profil
where categorie.id_categorie = annonce.id_categorie
and annonce.id_annonce = note.id_annonce
and note.id_utilisateur = utilisateur.id_utilisateur
and utilisateur.id_profil = profil.id_profil
and note_compteur > 3
and utilisateur_ville = 'Lyon'
and profil_libelle = 'Professionnel'
order by categorie_libelle;