#!/bin/bash

export BASE=${PWD}
export TUTO_HOME=${PWD}/tesstutorial
export TESS_HOME=/disk1/src/tess/tesseract
export TESS_DATA=${PWD}/tesseract/tessdata
export TRAIN_FILE=${BASE}/training.txt
export FONT_LIST='NanumMyeongjo'
export LANG=kor
mkdir -p ${TUTO_HOME}


rm -rf ${TUTO_HOME}/${LANG}train
rm -rf ${TUTO_HOME}/${LANG}eval

echo -e "\n***** Making training data for ${LANG}train set for scratch and impact training."
echo -e "\n***** This uses the fontlist for LATIN script fonts from src/training/language-specific.sh\n"

bash ${TESS_HOME}/src/training/tesstrain.sh \
  --fonts_dir /usr/share/fonts\
  --lang ${LANG} \
  --linedata_only \
  --noextract_font_properties \
  --langdata_dir ${BASE}/langdata \
  --tessdata_dir ${TESS_DATA} \
  --output_dir ${BASE}/${LANG}train  \
  --training_text ${TRAIN_FILE} \
  --fontlist ${FONT_LIST}
## 마지막 두줄은 나중에 제거한다.

echo -e "\n***** Making evaluation data for engeval set for scratch and impact training using Impact font."
bash ${TESS_HOME}/src/training/tesstrain.sh \
    --fonts_dir /usr/share/fonts \
    --lang ${LANG}\
    --linedata_only \
    --noextract_font_properties \
    --langdata_dir ${BASE}/langdata \
    --tessdata_dir ${TESS_DATA} \
    --fontlist "Nanum Pen Script" \
    --output_dir ${TUTO_HOME}/${LANG}eval \
    --training_text ${TRAIN_FILE} \
  
rm -rf  ${TUTO_HOME}/${LANG}output
mkdir ${TUTO_HOME}/${LANG}output

rm -rf ${TUTO_HOME}/impact_from_small
mkdir ${TUTO_HOME}/impact_from_small

rm -rf  ${TUTO_HOME}/impact_from_full
mkdir ${TUTO_HOME}/impact_from_full

echo -e "\n***** Extract LSTM model from best traineddata. \n"
combine_tessdata -e ${TESS_DATA}/best/${LANG}.traineddata \
  ${TUTO_HOME}/impact_from_full/${LANG}.lstm

rm -rf ${TUTO_HOME}/${LANG}_from_chi
mkdir  ${TUTO_HOME}/${LANG}_from_chi

echo -e "\n***** Extract LSTM model from best traineddata for chi_sim. \n"
combine_tessdata -e ${TESS_DATA}/best/chi_sim.traineddata \
  ${TUTO_HOME}/${LANG}_from_chi/${LANG}.lstm
  