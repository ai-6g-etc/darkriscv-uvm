class sequence_in extends uvm_sequence #(packet_darksocv);
    `uvm_object_utils(sequence_in)

    function new(string name="sequence_in");
        super.new(name);
    endfunction: new

    task body;
        packet_darksocv tx;

        forever begin
            tx = packet_darksocv::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize());
            finish_item(tx);
        end
    endtask: body
endclass: sequence_in
