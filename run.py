import subprocess
import os

# CONFIG
TOP_MODULE = "testbench"

VERILOG_FILES = [
    "main/CPU.v",
    "components/PC.v",
    "components/IMEM.v",
    "components/IR.v",
    "components/ALU.v",
    "components/CU.v",
    "components/reg_file.v",
    "components/External_RAM.v",
    "main/testbench.v"
]

OUTPUT_FILE = "build/out.vvp"
WAVE_FILE = "build/cpu.vcd"


# ---------------- RUN HELPER ----------------
def run(cmd):
    print(f"\n>> {' '.join(cmd)}")

    result = subprocess.run(cmd, text=True, capture_output=True)

    if result.returncode != 0:
        print("ERROR:")
        print(result.stderr)
        exit(1)

    print(result.stdout)


# ---------------- COMPILE VERILOG ----------------
def compile_verilog():
    cmd = ["iverilog", "-DSIMULATION", "-o", OUTPUT_FILE] + VERILOG_FILES
    run(cmd)


# ---------------- ASSEMBLE ----------------
def assemble():
    os.makedirs("program/output", exist_ok=True)

    cmd = [
        "python",
        "program/assembler.py",
        "-f", "program/test.asm",
        "-o", "program/output/program.hex"
    ]

    print("\n>> assembling program...")

    result = subprocess.run(cmd, text=True, capture_output=True)

    if result.returncode != 0:
        print("ASSEMBLER ERROR:")
        print(result.stderr)
        exit(1)

    print(result.stdout)


# ---------------- SIMULATE ----------------
def simulate():
    run(["vvp", OUTPUT_FILE])


# ---------------- GTKWAVE ----------------
def open_gtkwave():
    if os.path.exists(WAVE_FILE):
        run(["gtkwave", WAVE_FILE])
    else:
        print("No VCD file found!")


# ---------------- MAIN ----------------
if __name__ == "__main__":
    compile_verilog()
    assemble()
    simulate()
    open_gtkwave()