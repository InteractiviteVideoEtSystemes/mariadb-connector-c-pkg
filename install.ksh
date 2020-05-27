#!/bin/bash
#Creation de l'environnement de packaging rpm

PROJET=mariadb-connector-c

function create_rpm
{
    #Cree l'environnement de creation de package
    #Creation des macros rpmbuild
    rm ~/.rpmmacros
    touch ~/.rpmmacros
    echo "%_topdir" $PWD"/rpmbuild" >> ~/.rpmmacros
    echo "%_tmppath %{_topdir}/TMP" >> ~/.rpmmacros
    echo "%_signature gpg" >> ~/.rpmmacros
    echo "%_gpg_name IVeSkey" >> ~/.rpmmacros
    echo "%_gpg_path" $PWD"/gnupg" >> ~/.rpmmacros
    echo "%vendor MariaDB" >> ~/.rpmmacros
    #Import de la clef gpg IVeS
    if [[ -z $1 || $1 -ne nosign ]]
        then svn export https://svn.ives.fr/svn-libs-dev/gnupg
    fi
    mkdir -p rpmbuild
    mkdir -p rpmbuild/SOURCES
    mkdir -p rpmbuild/SPECS
    mkdir -p rpmbuild/BUILD
    mkdir -p rpmbuild/SRPMS
    mkdir -p rpmbuild/TMP
    mkdir -p rpmbuild/RPMS
    mkdir -p rpmbuild/RPMS/noarch
    mkdir -p rpmbuild/RPMS/i386
    mkdir -p rpmbuild/RPMS/x86_64
    #Recuperation de la description du package 
    cd ./rpmbuild/SPECS/
    cp ../../${PROJET}.spec ${PROJET}.spec
    cd ../../
    cd ./rpmbuild/SOURCES
    wget https://downloads.mariadb.com/Connectors/c/connector-c-3.1.8/mariadb-connector-c-3.1.8-src.tar.gz
    cp ../../mariadb_config/libmariadb.pc.in .
    cp ../../mariadb_config/mariadb_config.c.in .
    cp ../../mariadb_version.h.in .
    cd ../../
    
    #Cree le package
    if [[ -z $1 || $1 -ne nosign ]]
        then rpmbuild -bb --sign $PWD/rpmbuild/SPECS/${PROJET}.spec
        else rpmbuild -bb  $PWD/rpmbuild/SPECS/${PROJET}.spec
    fi
    if [ $? == 0 ]
    then
        echo "************************* fin du rpmbuild ****************************"
        #Recuperation du rpm
		 #Recuperation du rpm
		cd -
	cd ../..
        #mv -f rpmbuild/RPMS/i386/*.rpm $PWD/.
        mv -f rpmbuild/RPMS/x86_64/*.rpm $PWD/.
    fi
    clean
}

function clean
{
  	# On efface les liens ainsi que le package precedemment créé
  	echo Effacement des fichiers et liens gnupg rpmbuild ${PROJET}.rpm ${TEMPDIR}/${PROJET}
  	rm -rf gnupg rpmbuild  ${TEMPDIR}/${PROJET}
}

case $1 in
  	"clean")
  		echo "Nettoyage des liens et du package crees par la cible dev"
  		clean ;;
  	"rpm")
		echo "Creation du rpm"
		create_rpm "$@";;
  	*)
  		echo "usage: install.ksh [options]" 
  		echo "options :"
  		echo "  rpm		Generation d'un package rpm"
  		echo "  clean		Nettoie tous les fichiers cree par le present script, liens, tar.gz et rpm";;
esac
