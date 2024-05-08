# Makefile variables
VERILOG_SOURCES = darksimv.v
VERILOG_SOURCES += ../rtl/darksocv.v
VERILOG_SOURCES += ../rtl/darkriscv.v
VERILOG_SOURCES += ../rtl/darkpll.v
VERILOG_SOURCES += ../rtl/darkuart.v
VERILOG_SOURCES += ../rtl/config.vh
FILES = $(VERILOG_SOURCES)

UVM_HOME=/home/uvm/uvm-1.1d
VCS_FLAGS = -sverilog -ntb_opts uvm-1.1 +plusarg_save -timescale=1ns/1ns -debug_access+all
UVM_FLAGS = +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv
all:clean vcs verdi 
# Targets
vcs: $(FILES)
	@if [ ! -e $(UVM_HOME)/src/uvm.sv ]; then \
		echo "*******************************************************"; \
		echo "Environment variable UVM_HOME is not set or points to incorrect path"; \
		echo "*******************************************************"; \
		exit 1; \
	fi
	vcs +v2k $(VCS_FLAGS) $(FILES) -full64 -sverilog  -timescale=1ns/1ps -l comp.log -debug_all -debug_pp \
		   -o simv		   
	./simv -l sim.log +notimingcheck +nospecify -k ucli.key

verdi: vcs
	@if [ ! -e $(UVM_HOME)/src/uvm_pkg.sv ]; then \
		echo "*******************************************************"; \
		echo "Environment variable UVM_HOME is not set or points to incorrect path"; \
		echo "*******************************************************"; \
		exit 1; \
	fi
	verdi -sv $(UVM_FLAGS) $(FILES) -ssf top.fsdb &

tops: simv_dbg
	simv_dbg -l simv_dbg.log -gui

simv_dbg: $(FILES)
	vcs $(VCS_FLAGS) $(FILES) -l comp_dbg.log -debug_all -debug_pp -o simv_dbg -Mdir=csrc_dbg -ssf *.fsdb

DIR = $(shell basename `pwd`)

tar: clean
	cd ..; \
	tar cvf $(DIR).tar $(DIR)

clean:
	@rm -rf simv* csrc* *.log *.key core* .__solver* *.vp *.vcd
	@rm -rf *~ .__snps* *.bck .vcsmx_rebuild vc_hdrs.h DVEfiles
	@rm -rf work vsim.wlf INCA_libs transcript simv.shm
	@rm -rf *.fsdb novas* verdi* verilog* 

.PHONY: vcs verdi tops simv_dbg tar clean
