DENSEPHRASES_DIR="/n/fs/nlp-hyen/DensePhrases/outputs/dpr-single-adv-hn-natural/pred"

for s in "train" "dev" "test"; do
    for t in 1 2 3 4; do
        make convert-data PRED_FILE="$DENSEPHRASES_DIR/$s\_$t.json" OUTPUT_FILE="$s\_$t.json"
    done
done

make merge-data
