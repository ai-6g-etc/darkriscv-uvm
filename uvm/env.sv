class env extends uvm_env;
    agent       mst;
    refmod      rfm;
    agent_out   slv;
    comparator #(packet_darksocv) comp;  
    uvm_tlm_analysis_fifo #(packet_darksocv) to_refmod;
    virtual darksocv_if darksocv_vif;

    `uvm_component_utils(env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        to_refmod = new("to_refmod", this); 
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		
        mst = agent::type_id::create("mst", this);
        slv = agent_out::type_id::create("slv", this);
        rfm = refmod::type_id::create("rfm", this);
        comp = comparator#(packet_darksocv)::type_id::create("comp", this);

        // Set darksocv_vif for each component
        if (!uvm_config_db#(virtual darksocv_if)::get(this, "", "darksocv_vif", darksocv_vif))
            `uvm_fatal("NOVIF", "Could not get darksocv_vif from top module")
        uvm_config_db#(virtual darksocv_if)::set(this, "mst.drv", "darksocv_vif", darksocv_vif);
        uvm_config_db#(virtual darksocv_if)::set(this, "mst.mon", "darksocv_vif", darksocv_vif);
        uvm_config_db#(virtual darksocv_if)::set(this, "slv.drv_out", "darksocv_vif", darksocv_vif);
        uvm_config_db#(virtual darksocv_if)::set(this, "slv.mon_out", "darksocv_vif", darksocv_vif);
        uvm_config_db#(virtual darksocv_if)::set(this, "rfm.monitor", "darksocv_vif", darksocv_vif);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect MST to FIFO
        mst.item_collected_port.connect(to_refmod.analysis_export);
        
        // Connect FIFO to REFMOD
        rfm.in.connect(to_refmod.get_export);
        
        //Connect scoreboard
        rfm.out.connect(comp.from_refmod);
        slv.item_collected_port.connect(comp.from_dut);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction
  
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("Reporting matched %0d", comp.m_matches), UVM_NONE)
        if (comp.m_mismatches) begin
            `uvm_error(get_type_name(), $sformatf("Saw %0d mismatched samples", comp.m_mismatches))
        end
    endfunction
endclass