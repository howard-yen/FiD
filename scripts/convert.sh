for r in "dpr-nq-open-bm25-v10_short" "dpr-nq-open-bm25-v10_medium" "dpr-nq-open-bm25-v10_long" "dpr-nq-open-bm25-v10_yesno" "dpr-nq-open-bm25-v10_all"; do
    PRED_DIR="/projects/DANQIC/hyen/DPR/preds/$r/pred"
    for s in "train" "dev" "test"; do
        for t in short medium long yesno; do
            make convert-data PRED_FILE="$PRED_DIR/$s\_$t.json" OUTPUT_FILE="$s\_$t.json" RETRIEVER=$r
        done
    done
    make merge-data RETRIEVER=$r
done
