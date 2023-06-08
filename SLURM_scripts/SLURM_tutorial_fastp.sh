#!/bin/bash --login

#SBATCH --job-name=slurm_tutorial_fastp
#SBATCH --partition=peb
#SBATCH --mem-per-cpu=10G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=4:00:00   
#SBATCH --export=NONE


# Start of job
echo $SLURM_JOB_NAME job started at  `date`

# To compile with the GNU toolchain
module load gcc/9.4.0
module load fastqc
module load Anaconda3/2020.11
conda activate /group/peb002/conda_environments/bioinfo

# leave in, it lists the environment loaded by the modules
module list

#  Note: SLURM_JOBID is a unique number for every job.
#  These are generic variables
JOBNAME=${SLURM_JOB_NAME}
SCRATCH=$MYSCRATCH/$JOBNAME/$SLURM_JOBID
RESULTS=$MYGROUP/$JOBNAME/$SLURM_JOBID
TRIMID="trimmedFastP"

###############################################
# Creates a unique directory in the SCRATCH directory for this job to run in.
if [ ! -d $SCRATCH ]; then 
    mkdir -p $SCRATCH 
fi 
echo SCRATCH is $SCRATCH

###############################################
# Creates a unique directory in your GROUP directory for the results of this job
if [ ! -d $RESULTS ]; then 
    mkdir -p $RESULTS 
fi
echo the results directory is $RESULTS


################################################
# declare the name of the output file or log file
OUTPUT=${JOBNAME}_${SLURM_JOBID}.log

#############################################
#   Copy input files to $SCRATCH
#   then change directory to $SCRATCH

mkdir -p ${SCRATCH}/fastq

### COPY files to scratch
cp fastq/*gz ${SCRATCH}/fastq


## IMPORTANT: change directory to scratch

cd $SCRATCH


## A little bit of bash variable fun


# 1. get the name of read1 fastq and remove all the folder names
ls fastq/*_R1*fastq.gz
R1=$(basename fastq/*_R1*fastq.gz )
echo ${R1}
echo

# 2. remove the file ending to create an "ID"
ID=${R1%_S[0-9]*}
echo ${ID}
echo

## Execute script/program

# FastqQC

mkdir -p ${ID}

fastqc -o ${ID} --threads ${SLURM_CPUS_PER_TASK} \
fastq/PL573_2019_08_02_S41_L001_R1_001.fastq.gz \
fastq/PL573_2019_08_02_S41_L001_R2_001.fastq.gz

# Adapter Trimming
fastp   -w ${SLURM_CPUS_PER_TASK} \
        -q 20 \
        -i fastq/PL573_2019_08_02_S41_L001_R1_001.fastq.gz \
        -I fastq/PL573_2019_08_02_S41_L001_R2_001.fastq.gz \
        -o PL573_2019_08_02_S41_L001_R1_001.${TRIMID}.fastq \
        -O PL573_2019_08_02_S41_L001_R2_001.${TRIMID}.fastq \
        -h ${ID}.html \
        -j ${ID}.json \
        -R ${ID}_fastp_report

#############################################

# Get an idea of the directory structure and files
ls -lR * >> ${OUTPUT}


#############################################
#    $OUTPUT file to the unique results dir
# note this can be a copy or move  
mv  $OUTPUT ${RESULTS}

cd $HOME

###########################
# Clean up $SCRATCH 

# Save files that were created
mv ${SCRATCH}/* ${RESULTS}

# Delete SRATCH
rm -r $SCRATCH

echo $JOBNAME job finished at  `date`