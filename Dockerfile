FROM ubuntu:18.04
LABEL maintainer="Stéphane MOR <stephanemor@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
x11proto-core-dev make cmake libx11-dev git ca-certificates imagemagick gcc g++ \
exiv2 libimage-exiftool-perl libgeo-proj4-perl \ 
mesa-common-dev libgl1-mesa-dev libglapi-mesa libglu1-mesa opencl-headers && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/micmacIGN/micmac && \
    cd micmac && mkdir build && cd build && \
    cmake \
    	-DBUILD_POISSON=1 \
    	-DBUILD_RNX2RTKP=1 \
    	-DWITH_OPENCL=ON  \
    	-DWITH_ETALONPOLY=OFF \
    	../ && \
      make -j$(cat /proc/cpuinfo | grep processor | wc -l) && make install && \
      mkdir /opt/micmac && \
      cd .. && \
      cp -Rdp bin binaire-aux lib include /opt/micmac && \
      cd .. && rm -rf micmac

ENV PATH "$PATH:/opt/micmac/bin"
