#!/bin/bash

function Usage(){
    cat << USAGE 

Usage:

`basename $0` -o <outcsv> -f </freesurfer/path> -s <subject1> [... subjectN]
`basename $0` -o <outcsv> -s <subject1> [... subjectN]

N.B. the -s/--subjects flag must come last

Compulsory arguments:

    -o, --outcsv        Output file name

    -s, --subjects      Subjects to be included

Optional arguments:

    -h, --help          Prints help menu (this page) then exits

    -f, --fsdir         FreeSurfer directory if SUBJECTS_DIR isn't set

USAGE
    exit 1
}

if [[ $# -eq 0 ]]; then
    Usage >&2
fi

# Potentially add in the following option if this takes too long for the UKB 10k
#     -n, --nodes         If the dataset is large, then split and utilize n grid nodes

#################################
###    Parsing Inputs/Flags   ###
#################################

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
        Usage >&2
        exit 0
        ;;
    -s|--subjects)
        args=("$@")
        SUBJECTS=("${args[@]:1}")
        break
        ;;
    -f|--fsdir)
        SUBJECTS_DIR="$2"
        shift # past argument
        shift # past value
        ;;
    -o|--outcsv)
        outcsv="$2"
        shift # past argument
        shift # past value
        ;;
    *) # unknown option
        Usage >&2
        exit 1
        ;;
esac
done

##################################
###  Checking Input Arguments  ###
##################################

if [[ -z ${SUBJECTS_DIR} ]]; then
    echo "No FreeSurfer directory given. Please specify one"
    Usage >&2
fi

echo "Using ${SUBJECTS_DIR} as FreeSurfer directory"

#################################
### Setting Up Default Values ###
#################################

ROIs=( "bankssts" "caudalanteriorcingulate" "caudalmiddlefrontal" "cuneus" "entorhinal" "fusiform" "inferiorparietal" "inferiortemporal" "isthmuscingulate" "lateraloccipital" "lateralorbitofrontal" "lingual" "medialorbitofrontal" "middletemporal" "parahippocampal" "paracentral" "parsopercularis" "parsorbitalis" "parstriangularis" "pericalcarine" "postcentral" "posteriorcingulate" "precentral" "precuneus" "rostralanteriorcingulate" "rostralmiddlefrontal" "superiorfrontal" "superiorparietal" "superiortemporal" "supramarginal" "frontalpole" "temporalpole" "transversetemporal" "insula" )

measures=( thickavg surfavg grayvol thickstd numvert meancurv gauscurv foldind curvind )

#################################
###    Writing Header Line    ###
#################################

printf "%s" "SubjID" > ${outcsv}

for hemi in L R; do
    for measure in ${measures[@]}; do
        for roi in ${ROIs[@]}; do
            printf ",%s" "${hemi}_${roi}_${measure}" >> ${outcsv}
        done
    done
done

printf ",LThickness,RThickness,LSurfArea,RSurfArea,ICV" >> ${outcsv}

echo "" >> ${outcsv}

#############################
### Writing Subject Lines ###
#############################

for subj_id in ${SUBJECTS[@]}; do 

    printf "%s" ${subj_id} >> ${outcsv}
    echo ${subj_id}

    if [[ ! -f ${SUBJECTS_DIR}/${subj_id}/stats/lh.aparc.stats ]]; then
        echo "" >> ${outcsv}
        continue
    fi

    # REGIONAL MEASURES
    for hemi in lh rh; do
        stats_file="${SUBJECTS_DIR}/${subj_id}/stats/${hemi}.aparc.stats"
        printf ",%g" `awk 'NR > 53 {print $5}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $3}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $4}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $6}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $2}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $7}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $8}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $9}' ${stats_file}` >> ${outcsv}
        printf ",%g" `awk 'NR > 53 {print $10}' ${stats_file}` >> ${outcsv}
    done

    # GLOBAL MEASURES
    printf ",%g" `cat ${SUBJECTS_DIR}/${subj_id}/stats/lh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${outcsv}
    printf ",%g" `cat ${SUBJECTS_DIR}/${subj_id}/stats/rh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${outcsv}
    printf ",%g" `cat ${SUBJECTS_DIR}/${subj_id}/stats/lh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${outcsv}
    printf ",%g" `cat ${SUBJECTS_DIR}/${subj_id}/stats/rh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${outcsv}

    if [[ -f ${SUBJECTS_DIR}/${subj_id}/stats/aseg.stats ]]; then
        printf ",%f" `cat ${SUBJECTS_DIR}/${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${outcsv}
    fi

    echo "" >> ${outcsv}

done









