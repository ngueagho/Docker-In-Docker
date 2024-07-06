FROM robertolandry/ubuntu
RUN  apt update 


# installation du serveru ssh

RUN apt install openssh-server -y

# creation de l'utilisateur 

RUN useradd -m roberto

# installation de sudo 

RUN apt install sudo 

# suppression du mot de passe de l'utilisateur 

RUN sudo passwd -d roberto

# creation d'un groupe pour l'utilisateur 

RUN sudo groupadd roberto_group

# ajout de l'utlisateur au groupe creee et au groupe sudo 

RUN sudo usermod -aG sudo roberto

RUN sudo  usermod -aG roberto_group roberto

# specification du shell de l'utilisateur 

RUN usermod -s /bin/bash roberto

# creation du dossier .ssh pour le stockages de la cle publique 

RUN mkdir /home/roberto/.ssh

# creation du fichier de cle publique 

RUN touch /home/roberto/.ssh/authorized_keys

# copie de ma cle publique locale dans le fichier authorized_keys du dossier .ssh de mon conteneur 

COPY idkey.pub /home/roberto/.ssh/authorized_keys

# changement des droits et premissions du fichier authorized_keys quil soit manupulable par l'utilisateur roberto 

RUN sudo chown roberto:roberto_group /home/roberto/.ssh/authorized_keys

# NB partie optionnelle : vous pouvez decomenter la ligne suivante  pour vous assurer que votre cle a bien ete copie 

RUN cat /home/roberto/.ssh/authorized_keys

# exposition du port d'access en ssh 

EXPOSE 22

# lancement du service ssh 

RUN service ssh start

# configuration pour un lancement automatique de ce service apres chaques demarage de conteneur 

CMD ["/usr/sbin/sshd", "-D"]