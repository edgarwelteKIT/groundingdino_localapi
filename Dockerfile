FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-devel
ARG DEBIAN_FRONTEND=noninteractive

ENV CUDA_HOME=/usr/local/cuda \
     TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
     SETUPTOOLS_USE_DISTUTILS=stdlib

RUN conda update conda -y

# Install libraries in the brand new image. 
RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         build-essential \
         git \
         python3-opencv \
         ca-certificates \
         cmake \
         python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory for all the subsequent Dockerfile instructions.
WORKDIR /opt/program

RUN git clone https://github.com/IDEA-Research/GroundingDINO.git

RUN cd GroundingDINO; mkdir weights ; cd weights ; wget -q https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth ; cd ..

#RUN conda install -c "nvidia/label/cuda-12.1.1" cuda -y
#ENV CUDA_HOME=$CONDA_PREFIX
ENV CUDA_HOME=/usr/local/cuda

ENV PATH=/usr/local/cuda/bin:$PATH

WORKDIR /opt/program/GroundingDINO
RUN python setup.py build develop

RUN pip install fastapi pillow uvicorn  python-multipart


COPY dino_api.py dino_api.py

CMD [ "python", "dino_api.py" ]