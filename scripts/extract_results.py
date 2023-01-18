import subprocess

if __name__ == "__main__":
    jobid = "44998621"
    jobid = None
    if jobid is None:
        process_output = subprocess.run(["sbatch", "--wait", "slurm/test_reader.slurm"], capture_output=True, encoding="utf-8")
        slurm = process_output.stdout.strip()
        print(slurm)
        jobid = slurm.split(" ")[-1]
    print(f"job id: {jobid}")
    qtypes = ["short", "medium", "long", "yesno"]
    splits = ["dev", "test"]

    stats = {"dev": {"total": 0, "total_em": 0, "total_f1": 0, "output": ""}, 
        "test": {"total": 0, "total_em": 0, "total_f1": 0, "output": ""}}
    model_name = ""

    for i in range(8):
        split = splits[i % 2]
        qtype = qtypes[i // 2]

        with open(f"joblog/TEST_FID_READER-{jobid}_{i}.out") as f:
            for line in f:
                if line.startswith("Model name"):
                    model_name = line.split(" = ")[-1]
                pass
                if "EM" in line and "F1" in line and "Total number of example" in line:
                    break
        lastline = line.split(" - ")[-1]

        if "EM" not in lastline or "F1" not in lastline:
            print(i)
            print(lastline)
        assert "EM" in lastline
        assert "F1" in lastline
        assert "Total number of example" in lastline

        metrics = []
        for metric in lastline.split(", "):
            metrics.append(float(metric.split(" ")[-1]))
        if qtype != "yesno":
            stats[split]["output"] += f"{metrics[0]:.2f} {metrics[1]:.2f} "
        else:
            stats[split]["output"] += f"{metrics[0]:.2f} "

        stats[split]["total"] += int(metrics[2])
        stats[split]["total_em"] += metrics[0] * int(metrics[2])
        stats[split]["total_f1"] += metrics[1] * int(metrics[2])
    
    print("Model name:", model_name.strip())
    for split in splits:
        stats[split]["output"] += f"{stats[split]['total_em'] / stats[split]['total']:.2f} {stats[split]['total_f1'] / stats[split]['total']:.2f}"
        print(stats[split]["output"])
    