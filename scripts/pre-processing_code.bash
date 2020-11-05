for i in /home/mmeier/shared/data/2020_hamster_RRBS_Desaulniers/data/raw/*.fastq.gz
# Matt - addded hard trimming to remove first 3 bases
do trim_galore --illumina -o $HOME/shared/data/2020_hamster_RRBS_Desaulniers/data/raw/trim_galore --clip_R1 3 --rrbs --fastqc -j 8 $i
done

for i in $HOME/shared/data/2020_hamster_RRBS_Desaulniers/data/raw/trim_galore/*.fq.gz
do bismark --genome /home/mmeier/shared/dbs/hamster/MesAur1.0 -o /home/mmeier/shared/data/2020_hamster_RRBS_Desaulniers/data/processed/bismark_align $i &
done


for i in /home/mmeier/shared/data/2020_hamster_RRBS_Desaulniers/data/processed/bismark_align/*.bam
do bismark_methylation_extractor --multicore 4 --bedGraph --buffer_size 33G --cytosine_report  --genome_folder /home/mmeier/shared/dbs/hamster/MesAur1.0 --gzip $i &
done

multiqc \
-x *.temp \
-x *temp* \
-x *raw/fc1* \
-x *raw/fc2* \
-x */trimmed/* \
--cl_config "extra_fn_clean_exts: { '.fastp.json' }" \
--filename MultiQC_Report.RRBS_alignments.html \
--outdir ~/shared/data/2020_hamster_RRBS_Desaulniers/reports/ \
~/shared/data/2020_hamster_RRBS_Desaulniers/
