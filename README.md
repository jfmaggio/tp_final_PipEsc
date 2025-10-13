# 🧬 Pipeline de Metagenómica Shotgun con Nextflow

Este pipeline automatiza el procesamiento de librería paired-end de **metagenómica shotgun** utilizando **Nextflow DSL2**.  
Integra tres etapas principales: control de calidad de lecturas, eliminación de secuencias del hospedador (humano) y perfilado taxonómico con **MetaPhlAn3**.

---

## Flujo de trabajo

El pipeline ejecuta los siguientes módulos:

### 🔹 1. FILTRADO_QC
- Realiza control de calidad y filtrado de las lecturas crudas usando **Trim Galore!**.  
- Elimina bases de baja calidad, recorta adaptadores y descarta lecturas cortas o con demasiadas bases ambiguas.  
- **Salida:** pares de lecturas filtradas  
```
*_R1.trimmed.fq.gz, *_R2.trimmed.fq.gz
```
### 🔹 2. REMOCION_HOSPEDADOR
- Mapea las lecturas filtradas contra el genoma de referencia del hospedador (**GRCh38**) utilizando **Bowtie2**.  
- Conserva únicamente las lecturas que **no se alinean** al hospedador.  
- **Salida:** pares de lecturas limpias   
```
*_R1.clean.fq.gz, *_R2.clean.fq.gz
```
### 🔹 3. METAPHLAN3
- Ejecuta **MetaPhlAn3** sobre las lecturas libres de hospedador para generar perfiles taxonómicos.  
- Utiliza la base de datos **mpa_v30_CHOCOPhlAn_201901**.  
- **Salida:**
```
*_profile.txt
```
```
*_bowtie2.bz2
```

---

## Estructura del proyecto
```
project/
├── main.nf
├── modules/
│   ├── filtrado_qc.nf
│   ├── remocion_hospedador.nf
│   └── MetaPhlAn3.nf
├── inputs/
│   ├── test/                    # Archivos fastq.gz de entrada
│   └── ref/                     # Índice Bowtie2 del hospedador
└── results/                     # Resultados generados
```

---

## Parámetros principales

Estos parámetros se definen en el archivo `nextflow.config` o se pueden pasar por línea de comando:

| Parámetro | Descripción | Ejemplo |
|------------|--------------|----------|
| `--input` | Patrón de archivos FASTQ de entrada | `"inputs/test/*_{1,2}.fastq.gz"` |
| `--outdir` | Directorio de salida | `"./results"` |
| `--host_index_dir` | Ruta al índice de Bowtie2 del hospedador | `"inputs/ref/GRCh38_noalt_as"` |
| `--metaphlan_db_path` | Ruta a la base de datos de MetaPhlAn3 | `"/path/to/metaphlan/db"` |
| `-profile` | Perfil de ejecución, standard (por defecto) o docker_profile | `standard/docker_profile` |
---
## Salidas principales

| Directorio              | Descripción                                        |
| ----------------------- | -------------------------------------------------- |
| `results/qc/`           | Lecturas filtradas y reportes de calidad           |
| `results/host_removed/` | Lecturas sin secuencias del hospedador             |
| `results/metaphlan/`    | Perfiles taxonómicos y alineamientos de MetaPhlAn3 |
---

## Ejecución

Ejecutar el pipeline con:

```
nextflow run main.nf --input "inputs/test/*_{1,2}.fastq.gz"
```
---
## Requisitos

- **Nextflow ≥ 24.10.0**
- **Trim Galore**
- **Bowtie2**
- **Samtools**
- **MetaPhlAn3**

(En el proyecto se proveen un entorno virtual Mamba y un un container Docker con todas las dependencias necesarias. Además, también la posibilidad de correr cada proceso en containers diferentes)

---
## Tutorial

Se ejecutará la prueba usando los parámetros por defecto cuyos set de datos se encuentran en el directorio `inputs/test/` . El pipeline se puede ejecutar sin usar el entorno Mamba o contenedores Docker, pero eso requiere que las herramientas sean descargadas por el usuario.

1. **Clonar repositorio**

