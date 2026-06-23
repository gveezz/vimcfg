`timescale 1ns/1ps
// Headers include

module $COMPONENT_NAME ();

// External functions and tasks

// Localparams

// Specparams

// Sequerntial logic

// Combinational logic

// Wires

// Wires assignments

// Integers, strings, reals ...

// Modules instantiations

// Testbench functionality

initial begin
    $dumpfile ("$COMPONENT_NAME.vcd");
    $dumpvars (0, $COMPONENT_NAME);
    #0 ;

    #1000 $finish();
end

endmodule

