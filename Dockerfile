FROM ubuntu:20.04

# --- Variables de entorno ---
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/conda/bin:$PATH"

# --- Instalar dependencias básicas ---
RUN apt-get update && apt-get install -y \
    wget curl unzip bzip2 build-essential git \
    python3 python3-pip python3-dev \
    r-base r-base-dev \
    && rm -rf /var/lib/apt/lists/*

# --- Instalar Miniconda ---

RUN curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && rm miniconda.sh && \
    /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    /opt/conda/bin/conda update -n base -c defaults conda

# --- Crear entorno con bioinformática ---
    # fastqc, cutadapt son necesarios para trim-galore
RUN conda install -y -c conda-forge mamba && \
    mamba install -y -c bioconda -c conda-forge \
        python=3.10 \
        fastqc=0.12.1 \
        cutadapt=5.1 \
        trim-galore=0.6.5 \
        bowtie2=2.5.4 \
        samtools=1.22 \
        metaphlan=3.0 && \
    conda clean -afy

# --- Directorio de trabajo
WORKDIR /inputs
    # --- Base de datos
RUN metaphlan --install --index mpa_v30_CHOCOPhlAn_201901 --bowtie2db ref/metaphlan


# --- Por defecto: bash ---
CMD ["/bin/bash"]