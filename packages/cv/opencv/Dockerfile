#---
# name: opencv
# group: cv
# config: config.py
# depends: [cuda, cudnn, python, numpy, opengl, vulkan, video-codec-sdk, ffmpeg]
# test: test.py
# notes: install or build OpenCV (with CUDA) from Jetson pip server
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG OPENCV_VERSION \
    OPENCV_PYTHON \
    OPENCV_URL \
    CUDA_ARCH_BIN \
    FORCE_BUILD=off \
    TMP=/tmp/opencv

ENV OPENCV_VERSION=${OPENCV_VERSION} \
    OPENCV_URL=${OPENCV_URL}
    
COPY build.sh \
     install.sh \
     install_deps.sh \
     install_deb.sh \
     patches.diff \
     $TMP/

RUN cd $TMP && ./install.sh || ./build.sh || true

RUN if [ ! -f "$TMP/.opencv" ]; then \
      echo "FAILED to install OpenCV $OPENCV_VERSION"; \
      exit 1; \
    fi

# Intall TensorRT
RUN wget https://repo.download.nvidia.com/jetson/common/pool/main/n/nvidia-l4t-dla-compiler/nvidia-l4t-dla-compiler_36.4.1-20241119120551_arm64.deb -O nvidia-l4t-dla-compiler_36.4.1_arm64.deb

# Extract the data portion of the .deb file
RUN dpkg-deb --fsys-tarfile nvidia-l4t-dla-compiler_36.4.1_arm64.deb > dla_compiler.tar

# Extract the specific shared object from the tarball
RUN tar xv --strip-components=5 --directory=/usr/lib/aarch64-linux-gnu/nvidia/ -f dla_compiler.tar ./usr/lib/aarch64-linux-gnu/nvidia/libnvdla_compiler.so

# Update LD library links
ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/nvidia:$LD_LIBRARY_PATH

# 5. Add trtexec to path
ENV PATH=$PATH:/usr/src/tensorrt/bin

LABEL org.opencontainers.image.source=https://github.com/Greenroom-Robotics/jetson-containers

