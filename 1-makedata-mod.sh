#!/bin/bash
export TUTO_HOME=~/tesstutorial
export BASE=${PWD}
export TESS_HOME=/disk1/src/tess/tesseract
export TRAIN_FILE=${BASE}/training.txt
export FONT_LIST='NanumMyeongjo'
mkdir -p ${TUTO_HOME}
cd ${TESS_HOME}

rm -rf ${TUTO_HOME}/engtrain
rm -rf ${TUTO_HOME}/engeval

echo -e "\n***** Making training data for engtrain set for scratch and impact training."
echo -e "\n***** This uses the fontlist for LATIN script fonts from src/training/language-specific.sh\n"
bash src/training/tesstrain.sh \
  --fonts_dir /usr/share/fonts\
  --lang eng --linedata_only \
  --noextract_font_properties \
  --langdata_dir ../langdata \
  --tessdata_dir ./tessdata \
  --output_dir ${TUTO_HOME}/engtrain  \
  --training_text ${TRAIN_FILE} \
  --fontlist ${FONT_LIST}


echo -e "\n***** Making evaluation data for engeval set for scratch and impact training using Impact font."
bash src/training/tesstrain.sh --fonts_dir /usr/share/fonts --lang eng --linedata_only \
  --noextract_font_properties --langdata_dir ../langdata \
  --tessdata_dir ./tessdata \
  --fontlist "Impact Condensed" --output_dir ${TUTO_HOME}/engeval
  
rm -rf  ${TUTO_HOME}/engoutput
mkdir ${TUTO_HOME}/engoutput

rm -rf ${TUTO_HOME}/impact_from_small
mkdir ${TUTO_HOME}/impact_from_small

rm -rf  ${TUTO_HOME}/impact_from_full
mkdir ${TUTO_HOME}/impact_from_full

echo -e "\n***** Extract LSTM model from best traineddata. \n"
combine_tessdata -e tessdata/best/eng.traineddata \
  ${TUTO_HOME}/impact_from_full/eng.lstm

rm -rf ${TUTO_HOME}/eng_from_chi
mkdir  ${TUTO_HOME}/eng_from_chi

echo -e "\n***** Extract LSTM model from best traineddata for chi_sim. \n"
combine_tessdata -e tessdata/best/chi_sim.traineddata \
  ${TUTO_HOME}/eng_from_chi/eng.lstm
  