# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/base-notebook:357e75831bc9
FROM $BASE_CONTAINER
#FROM jupyter/base-notebook:357e75831bc9
LABEL maintainer="Emanuela Boros <emanuela.boros@univ-lr.fr>"

RUN python -m pip install --upgrade --force-reinstall pip

# Install Tensorflow
RUN pip install --quiet --no-cache-dir \
    'tensorflow==2.2.0' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Les actions de ce Dockerfile doivent être réalisées en tant que root
USER 0

# Default directory
WORKDIR /work

ADD requirements.txt /work/requirements.txt
ADD 1_text_classification /work/1_text_classification
ADD 2_images_classification /work/2_images_classification

# Installation des dépendances avec conda dans le Jupyter Notebook
RUN conda install -c anaconda curl && \ 
    pip install python-resize-image && \
    conda clean --yes --all

RUN pip install matplotlib && \ 
    pip install pandas && \ 
    pip install spacy==2.1.3 && \ 
    pip install seaborn && \ 
    pip install numpy && \ 
    pip install scipy && \ 
    pip install nltk && \ 
    pip install scikit_learn

# Téléchargement des ressources aditionnelles pour spacy et nltk
RUN python -m spacy download en_core_web_md && \
    python -m nltk.downloader punkt stopwords wordnet averaged_perceptron_tagger maxent_ne_chunker words

RUN chown -R 1000:1000 /work

USER 1000