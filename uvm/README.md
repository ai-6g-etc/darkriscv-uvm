readme.txt

->make 

->

<img width="854" alt="image" src="https://github.com/ai-6g-etc/darkriscv-uvm/assets/77096593/b4b53797-e601-46e8-8add-042e67a4330b">

This UVM project contains the following SystemVerilog source files:

1. agent_out.sv
   - Defines the `agent_out` class, which is a UVM agent component responsible for the slave-side of the DUT.
   - Includes a driver (`driver_out`), a monitor (`monitor_out`), and an analysis port to report collected items.

2. agent.sv
   - Defines the `agent` class, which is a UVM agent component responsible for the master-side of the DUT.
   - Includes a sequencer (`sequencer`), a driver (`driver`), a monitor (`monitor`), and an analysis port to report collected items.

3. comparator.sv
   - Defines the `comparator` class, which is a UVM scoreboard component that compares the output of the DUT with the expected output from the reference model.

4. darksocv_if.sv
   - Defines the `darksocv_if` interface, which represents the interface signals of the DUT.

5. driver_out.sv
   - Defines the `driver_out` class, which is a UVM driver component responsible for driving the slave-side of the DUT.

6. driver.sv
   - Defines the `driver` class, which is a UVM driver component responsible for driving the master-side of the DUT.

7. env.sv
   - Defines the `env` class, which is a UVM environment component that instantiates and connects the various agent, reference model, and scoreboard components.

8. monitor_out.sv
   - Defines the `monitor_out` class, which is a UVM monitor component responsible for monitoring the slave-side of the DUT.

9. monitor.sv
   - Defines the `monitor` class, which is a UVM monitor component responsible for monitoring the master-side of the DUT.

10. packet_darksocv.sv
    - Defines the `packet_darksocv` class, which is a UVM sequence item that represents the DUT's data packet.

11. refmod.sv
    - Defines the `refmod` class, which is a UVM component that serves as the reference model for the DUT.

12. sequence_in.sv
    - Defines the `sequence_in` class, which is a UVM sequence that generates input packets for the DUT.

13. sequencer.sv
    - Defines the `sequencer` class, which is a UVM sequencer component responsible for coordinating the execution of sequences.

14. simple_test.sv
    - Defines the `simple_test` class, which is a UVM test that instantiates the environment and runs the `sequence_in` sequence.

15. top.sv
    - Defines the top-level module that instantiates the DUT and the UVM testbench components, and runs the `simple_test`.

This UVM project is designed to verify the functionality of the `darksocv` DUT, which includes a UART, LED, and DEBUG interface. The project includes components for generating input packets, driving the DUT, monitoring the DUT's outputs, and comparing the DUT's outputs with the expected outputs from the reference model.import os
====================================================================================================
current_dir = os.getcwd()

v_files = [file for file in os.listdir(current_dir) if file.endswith(".sv")]

output_file = open("output.txt", "w")

for file in v_files:
    with open(file, "r") as f:
        content = f.read()
    
    content_with_name = "File Name: " + file + "\n" + content
    
    output_file.write(content_with_name + "\n\n")

output_file.close()
====================================================================================================
