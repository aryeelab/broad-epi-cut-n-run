version 1.0

# TASK
# cutnrun-bam2bed

task cutnrun_bam2bed {
    meta {
        version: 'v0.1'
        author: 'Eugenio Mattei (emattei@broadinstitute.org) at Broad Institute of MIT and Harvard'
        description: 'Broad Institute of MIT and Harvard Cut-and-Run pipeline: bam2bed task'
    }

    input {
        # This task takes in input the preprocessed fastqs and align them to the genome.
        Int? cpus = 1
        Int? memory_gb = 32
        File bam
        String docker_image = "4dndcic/cut-and-run-pipeline:v1"
        String? prefix
    }

    Float input_file_size_gb = size(fastq_R1, "G")
    # This is almost fixed for either mouse or human genome
    Int mem_gb = memory_gb
    #Int disk_gb = round(20.0 + 4 * input_file_size_gb)
    Int disk_gb = 100


    command {
        bash run-trim.sh ${default="cutnrun" prefix} . ${bam}
    }

    output {
        File bedpe = glob('./*bedpe.gz')[0]
        File clean_bam = glob('./*dedup.sorted.tmp.bam')[0]
    }

    runtime {
        cpu : cpus
        memory : mem_gb+'G'
        disks : 'local-disk ${disk_gb} SSD'
        docker : docker_image
    }

    parameter_meta {
        bam: {
                description: 'Bam file',
                help: 'Output bam from alignment.',
                example: 'sample.align.bam',
            }
        prefix: {
                description: 'Prefix for output files',
                help: 'Prefix that will be used to name the output files',
                examples: 'MyExperiment'
            }
    }

}
