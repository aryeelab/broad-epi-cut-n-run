version 1.0

# TASK
# cutnrun-viz

task cutnrun_viz {
    meta {
        version: 'v0.1'
        author: 'Eugenio Mattei (emattei@broadinstitute.org) at Broad Institute of MIT and Harvard'
        description: 'Broad Institute of MIT and Harvard Cut-and-Run pipeline: Create tracks for visualization'
    }

    input {
        # This task takes in input the bedped and create baedgraph and bigwig.
        Int? cpus = 1
        Int? memory_gb = 16
        File bedpe
    File chr_sizes
    String docker_image = "4dndcic/cut-and-run-pipeline:v1"
        String? prefix
    }

    Float input_file_size_gb = size(fastq_R1, "G")
    # This is almost fixed for either mouse or human genome
    Int mem_gb = memory_gb
    #Int disk_gb = round(20.0 + 4 * input_file_size_gb)
    Int disk_gb = 100


    command {
        bash run-viz.sh ${bedpe} ${chr_sizes} '' ${default="cutnrun" prefix} .
    }

    output {
        File bedgraph = glob('./*.bedgraph.gz')[0]
    File bigwig = glob('./*.bw')[0]
    }

    runtime {
        cpu : cpus
        memory : mem_gb+'G'
        disks : 'local-disk ${disk_gb} SSD'
        docker : docker_image
    }

}
