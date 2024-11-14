#!/usr/bin/env bash
# nix-shell -p bash --pure
# nix-shell -p bash accelerate
# This is not finished but that is ok for now, only run this from the dir that already has the dependencies

# accelerate config default

# MODEL_NAME="../../../johnrizzo_model"
# INSTANCE_DIR="../../../training_images"
# OUTPUT_DIR="../../../output_images"

# # accelerate launch train_dreambooth.py \
#   # --pretrained_model_name_or_path=$MODEL_NAME  \
# accelerate launch train_dreambooth_lora_sdxl.py \
#   --instance_data_dir=$INSTANCE_DIR \
#   --output_dir=$OUTPUT_DIR \
#   --instance_prompt="a photo of john rizzo" \
#   --resolution=512 \
#   --train_batch_size=1 \
#   --gradient_accumulation_steps=1 \
#   --learning_rate=5e-6 \
#   --lr_scheduler="constant" \
#   --lr_warmup_steps=0 \
#   --max_train_steps=400

export MODEL_NAME="stable-diffusion-v1-5/stable-diffusion-v1-5"
# export INSTANCE_DIR="./dog"
export INSTANCE_DIR="./training_images"
export OUTPUT_DIR="./model"

# accelerate launch train_dreambooth_lora_sdxl.py \
accelerate launch train_dreambooth.py \
  --pretrained_model_name_or_path=$MODEL_NAME  \
  --instance_data_dir=$INSTANCE_DIR \
  --output_dir=$OUTPUT_DIR \
  --instance_prompt="a photo of john rizzo" \
  --resolution=512 \
  --mixed_precision="bf16" \
  --snr_gamma=5.0 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=1 \
  --learning_rate=5e-6 \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --max_train_steps=400 \
  --gradient_checkpointing \
  --use_8bit_adam \
  --push_to_hub