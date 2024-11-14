from datasets import load_dataset

dataset = load_dataset ("imagefolder", data_dir="training_images")
dataset.push_to_hub("johnrizzo1/headshots")