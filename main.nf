#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { GUNZIP       } from './modules/nf-core/gunzip/main'
include { BUSCO        } from './modules/nf-core/busco/main'
include { FASTAWINDOWS } from './modules/nf-core/fastawindows/main'

workflow {

    Channel.fromPath ( params.fasta )
    | map { [ [ id: it.baseName.tokenize(".")[0..1].join(".") ], it ] }
    | set { ch_genome }

    GUNZIP ( ch_genome )

    BUSCO ( GUNZIP.out.gunzip, params.lineage, params.lineage_db, [] )

    FASTAWINDOWS ( GUNZIP.out.gunzip )
}
