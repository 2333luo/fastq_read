#!/bin/bash

BIN_VERSION=1.4.0
BIN_VERSION_GPU=${BIN_VERSION}-gpu

INPUT_DIR=/home/dell/wangzg
OUTPUT_DIR=/home/xiejw

MODEL_TYPE=WGS

TYPE=dp-${BIN_VERSION}
SAMPLE=HG002
#SAMPLE=HG003
#SAMPLE=HG004
BAM_NAME=${SAMPLE}.bwa-mem2.sort.md

SAMPLE=NA12878
SAMPLE=NA12878.mgiseq2000
SAMPLE=NA12878.bgiseq500
BAM_NAME=${SAMPLE}.mkdup

--make_examples_extra_args="--min_base_quality=6 --vsc_min_fraction_snps=0.13  \
  --vsc_min_fraction_indels=0.10" \
NSHARD=`nproc`

mkdir -p ${OUTPUT_DIR}/${TYPE}

docker run --rm \
  -v "${INPUT_DIR}":"/input" \
  -v "${OUTPUT_DIR}/${TYPE}":"/output" \
  -v "${OUTPUT_DIR}/log":"/log" \
  --gpus 1 \
  google/deepvariant:"${BIN_VERSION_GPU}" \
  /bin/bash -c \
  /"opt/deepvariant/bin/run_deepvariant \
  --model_type=${MODEL_TYPE} \
  --ref=/input/reference/Homo_sapiens_assembly38.fasta \
  --reads=/input/bam/${BAM_NAME}.bam \
  --output_vcf=/output/${SAMPLE}.vcf.gz \
  --output_gvcf=/output/${SAMPLE}.g.vcf.gz \
  --make_examples_extra_args="--min_base_quality=6 --vsc_min_fraction_snps=0.13  \
  --vsc_min_fraction_indels=0.10" \
  --num_shards=${NSHARD} >/log/${SAMPLE}.${TYPE}.g.log 2>&1"

  #--intermediate_results_dir /output/${SAMPLE}_intermediate_results_dir \
