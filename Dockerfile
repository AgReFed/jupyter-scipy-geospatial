# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Copyright 2023 AgReFed
ARG BASE_CONTAINER=jupyter/scipy-notebook:lab-3.5.3
FROM $BASE_CONTAINER

LABEL maintainer="AgReFed <r.archer@federation.edu.au>"

#ARG NB_USER="jovyan"
#ARG NB_UID="1000"
#ARG NB_GID="100"

# Fix DL4006
# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# install software-properties-common to enable add-apt-repository command
# install ubuntugis PPA, unstable required for 22.04 LTS packages.
# install required packages
# clean up
RUN apt-get update && \
#    apt-get upgrade -y && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ubuntugis/ubuntugis-unstable && \
    apt-get update && \
    apt-get install --no-install-recommends --yes \
    rclone \
    unrar \
#    lftp \
#    libproj-dev \
#    libgdal-dev \
    liblerc3 \
#    liblerc-dev \
    gdal-bin \
    proj-bin \
    proj-data && \
    apt-get remove pkg-config -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    fix-permissions "/home/${NB_USER}" && \
    chown -R "${NB_USER}" "/home/${NB_USER}/.launchpadlib"

USER $NB_UID

RUN arch=$(uname -m) && \
    if [ "${arch}" == "aarch64" ]; then \
        # Prevent libmamba from sporadically hanging on arm64 under QEMU
        # <https://github.com/mamba-org/mamba/issues/1611>
        export G_SLICE=always-malloc; \
    fi && \
    mamba install --yes \
    plotly_express \
    netcdf4 \
    basemap \
    ipywidgets \
    google-cloud-sdk \
    pyreadr \
    schema \
    termcolor \
    alive-progress \
    colour \
    ee_extra \
    eemont \
    gdown \
    geeadd \
    geedim \
    geemap \
    geocoder \
    geojson \
    grapheme \
    ipyfilechooser \
    jupyter_server \
    odc-stac \
    papermill \
    pystac \
    pystac-client \
    rich \
    twine \
    wxee \
    aiohttp \
    black \
    boto3 \
    cartopy \
    ciso8601 \
    dataclasses \
    datacube \
    earthengine-api \
    folium \
    GDAL \
    geopandas \
    geoplot \
    grpcio \
    httplib2shim \
    ipyleaflet \
    itsdangerous \
    libcxx \
    libgfortran \
    jupyter \
    jupyter-ui-poll \
    loguru \
    lxml \
    nltk \
    noise \
    odc-algo \
    olefile \
    openpyxl \
    OWSLib \
    pipreqs \
    pyshp \
    pytest-cov \
    pyu2f \
    pyvista \
    rasterio \
    rasterstats \
    rioxarray \
    shapely \
    toml \
    typed-ast \
    werkzeug \
    xarray \
    xarray-spatial \
    zarr && \
    mamba list --quiet && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    ls -al "/home/${NB_USER}"

RUN pip install dea-tools odc-ui p2j selectio xicor && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

ENV PROJ_LIB="/opt/conda/share/proj"
ENV GDAL_DATA="/opt/conda/share/gdal"

USER $NB_UID
WORKDIR $HOME
