version 1.0

# TASK
# cutnrun-peak

task cutnrun_peak {
    meta {
        version: 'v0.1'
        author: 'Eugenio Mattei (emattei@broadinstitute.org) at Broad Institute of MIT and Harvard'
        description: 'Broad Institute of MIT and Harvard Cut-and-Run pipeline: Peak calling step'
    }

    input {
        # This task takes in input the bedgraphs for input and ctrl and call peaks.
        Int? cpus = 1
        Int? memory_gb = 16
        File bedgraph_input
        File bedgraph_ctrl
        File chrom_sizes
        String? normalization = "norm"
        String? stringency = "relaxed"
        String docker_image = "4dndcic/cut-and-run-pipeline:v1"
        String? prefix
    }

    #Float input_file_size_gb = size(fastq_R1, "G")
    # This is almost fixed for either mouse or human genome
    Int mem_gb = memory_gb
    #Int disk_gb = round(20.0 + 4 * input_file_size_gb)
    Int disk_gb = 100


    command {
        bash run-peak.sh ${bedgraph_input} ${bedgraph_ctrl} ${normalization} ${stringency} ${default="cutnrun" prefix}.peak .
        /usr/local/bin/bedGraphToBigWig ${prefix}.bedgraph ${chr_sizes} ${prefix}.peak.bw
    }

    output {
        File bedgraph_peak_norm = glob('./*.bedgraph.gz')[0]
        File bw_peak_norm = glob('./*.bw')[0]
        File narrow_peak = glob('./*.bed.gz')[0]
    }

    runtime {
        cpu : cpus
        memory : mem_gb+'G'
        disks : 'local-disk ${disk_gb} SSD'
        docker : docker_image
    }

}
