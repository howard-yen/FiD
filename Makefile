config:
	$(eval MODEL_SIZE=base)
	$(eval DATA_DIR=data)
	$(eval TRAIN_DATA=train.json)
	$(eval DEV_DATA=dev.json)
	$(eval TEST_DATA=test.json)
	$(eval NAME=draft)
	$(eval N_CONTEXT=100)
	$(eval MAIN_PORT=10001)
	$(eval OUTPUT_LENGTH=50)
	$(eval TOTAL_STEPS=10000)
	$(eval EVAL_STEPS=2000)
	$(eval SAVE_STEPS=4000)
	$(eval GA=1)

convert-data: config
	python scripts/convert_data.py \
		--pred_file $(PRED_FILE) \
		--output_file $(DATA_DIR)/$(OUTPUT_FILE)

merge-data: config
	python scripts/merge_data.py \
		--dir $(DATA_DIR) 

trim-data: config
	python scripts/trim_data.py \
		--input_file $(DATA_DIR)/train_4.json \
		--size 100

train-reader: config
	python train_reader.py \
		--model_size $(MODEL_SIZE) \
		--train_data $(DATA_DIR)/$(TRAIN_DATA) \
		--eval_data $(DATA_DIR)/$(DEV_DATA) \
		--per_gpu_batch_size 1 \
		--n_context $(N_CONTEXT) \
		--lr 0.0001 \
		--optim adamw \
		--scheduler fixed \
		--weight_decay 0.01 \
		--text_maxlength 250 \
		--total_step $(TOTAL_STEPS) \
		--accumulation_steps $(GA) \
		--eval_freq $(EVAL_STEPS) \
		--save_freq $(SAVE_STEPS) \
		--name $(NAME) \
		--use_checkpoint \
		--output_maxlength $(OUTPUT_LENGTH) \
		--main_port $(MAIN_PORT) # for multi-node/gpu distributed training
		#--checkpoint_dir pretrained_models \

train-reader-multi: config
	python -m torch.distributed.launch --nproc_per_node=$(NGPU) --master_port $(PORT_ID) \
		train_reader.py \
		--model_size $(MODEL_SIZE) \
		--train_data $(DATA_DIR)/$(TRAIN_DATA) \
		--eval_data $(DATA_DIR)/$(DEV_DATA) \
		--per_gpu_batch_size 1 \
		--n_context $(N_CONTEXT) \
		--lr 0.0001 \
		--optim adamw \
		--scheduler fixed \
		--weight_decay 0.01 \
		--text_maxlength 250 \
		--total_step $(TOTAL_STEPS) \
		--accumulation_steps $(GA) \
		--eval_freq $(EVAL_STEPS) \
		--save_freq $(SAVE_STEPS) \
		--name $(NAME) \
		--use_checkpoint \
		--output_maxlength $(OUTPUT_LENGTH) \
		--checkpoint_dir checkpoint \
		--main_port -1

test-reader: config
	python test_reader.py \
		--model_path checkpoint/$(NAME)/checkpoint/best_dev \
		--eval_data $(DATA_DIR)/$(TEST_DATA) \
		--per_gpu_batch_size 1 \
		--n_context $(N_CONTEXT) \
		--name $(NAME) \
		--output_maxlength $(OUTPUT_LENGTH) \
		--checkpoint_dir checkpoint/ \
		--main_port $(MAIN_PORT) # for multi-node/gpu distributed training #--write_results \

test-reader-multi: config
	python -m torch.distributed.launch --nproc_per_node=$(NGPU) --master_port $(PORT_ID) \
		test_reader.py \
		--model_path checkpoint/$(NAME)/checkpoint/best_dev \
		--eval_data $(DATA_DIR)/$(TEST_DATA) \
		--per_gpu_batch_size 1 \
		--n_context $(N_CONTEXT) \
		--name $(NAME) \
		--output_maxlength $(OUTPUT_LENGTH) \
		--checkpoint_dir checkpoint/ \
		--main_port -1 #--write_results
