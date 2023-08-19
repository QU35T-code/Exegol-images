#!/bin/bash

# Le dossier source où se trouvent les dossiers avec les binaires
SOURCE_DIR="/root/.local/pipx/venvs/"
# Le dossier destination pour les liens symboliques
DEST_DIR="/root/.local/bin/"

# Parcourir chaque dossier dans SOURCE_DIR
for folder in $SOURCE_DIR*; do
    # Extraire le nom du dossier (sans le chemin)
    folder_name=$(basename $folder)
    
    # Vérifier si le binaire du même nom que le dossier existe dans le sous-dossier 'bin'
    if [[ -f "$folder/bin/$folder_name" ]]; then
        # Créer un lien symbolique dans DEST_DIR
        ln -s "$folder/bin/$folder_name" "$DEST_DIR$folder_name"
    fi
done
