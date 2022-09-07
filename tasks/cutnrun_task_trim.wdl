version 1.0

# TASK
# cutnrun-trim

task cutnrun_trim {
    meta {
        version: 'v0.1'
        author: 'Eugenio Mattei (emattei@broadinstitute.org) at Broad Institute of MIT and Harvard'
        description: 'Broad Institute of MIT and Harvard Cut-and-Run pipeline: trim task using trimmomatic'
    }

    input {
        # This task takes in input the preprocessed fastqs and align them to the genome.
        Int? cpus = 8
        Int? memory_gb = 64
        File fastq_R1
        File fastq_R2
        String docker_image = "4dndcic/cut-and-run-pipeline:v1"
        String? prefix
    }

    Float input_file_size_gb = size(fastq_R1, "G")
    # This is almost fixed for either mouse or human genome
    Int mem_gb = memory_gb
    #Int disk_gb = round(20.0 + 4 * input_file_size_gb)
    Int disk_gb = 100


    command {
        bash run-trim.sh ${fastq_R1} ${fastq_R2} ${cpus} ${default="cutnrun" prefix} .
    }

    output {
        File trimmed_R1 = glob('./*1P.fastq.gz')[0]
        File untrimmed_R1 = glob('./*1U.fastq.gz')[0]
        File trimmed_R2 = glob('./*2P.fastq.gz')[0]
        File untrimmed_R2 = glob('./*2U.fastq.gz')[0]
    }

    runtime {
        cpu : cpus
        memory : mem_gb+'G'
        disks : 'local-disk ${disk_gb} SSD'
        docker : docker_image
    }

    parameter_meta {
        fastq_R1: {
                description: 'Read1 fastq',
                help: 'Processed fastq for read1.',
                example: 'processed.atac.R1.fq.gz',
            }
        fastq_R2: {
                description: 'Read2 fastq',
                help: 'Processed fastq for read2.',
                example: 'processed.atac.R2.fq.gz'
            }
        prefix: {
                description: 'Prefix for output files',
                help: 'Prefix that will be used to name the output files',
                examples: 'MyExperiment'
            }
        cpus: {
                description: 'Number of cpus',
                help: 'Set the number of cpus useb by bowtie2',
                default: 16
            }
    }

}
