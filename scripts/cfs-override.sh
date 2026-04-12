# Part B: CPU Scheduling (Topic 1) Experimental Commands

# 1. Start the synthetic maximum-load task in the background
# This command maxes out a CPU core by piping infinite strings to /dev/null
yes > /dev/null & [cite: 73, 181, 182]

# 2. Check the baseline 'Niceness' (NI) and Priority (PR) of the process
# Standard processes usually start with an NI of 0
top -p $(pgrep yes) [cite: 73, 182]

# 3. Intervene with the kernel scheduler to lower the priority (increase NI by 10)
# This forces the kernel to yield hardware resources to other tasks
renice +10 -p $(pgrep yes) [cite: 36, 74, 183]

# 4. Verify the CFS has adjusted the Priority (PR) and Nice (NI) values
# You should now see the NI value reflect the +10 change
top -p $(pgrep yes) [cite: 74, 82, 183]

# 5. Clean termination of the synthetic workload to restore system stability
# Stops the high-load process to bring the CPU back to idle
killall yes [cite: 76, 184]