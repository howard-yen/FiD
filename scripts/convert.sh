RETRIEVER=""
PRED_DIR="/n/fs/nlp-hyen/DensePhrases/outputs/$RETRIEVER/pred"

for s in "train" "dev" "test"; do
    for t in short medium long yesno; do
        make convert-data PRED_FILE="$PRED_DIR/$s\_$t.json" OUTPUT_FILE="$s\_$t.json" RETRIEVER=$RETRIEVER
    done
done

make merge-data RETRIEVER=$RETRIEVER
