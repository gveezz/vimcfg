`ifdef DEF_NET_NONE
    `default_nettype none
`endif 

// Headers include

module $COMPONENT_NAME #(
    // Configurable parameters
    parameter DATA_W = 8
) (
    // System interface
    // -- inputs
    input wire sclk_i,
    input wire arst_i,
    input wire srst_i,
    // Data interface
    // --inputs
    input wire data_vld_i,
    input wire [DATA_W-1:0] data_i,
    // -- outputs
    output wire data_vld_o,
    output wire [DATA_W-1:0] data_o
);

// External functions and tasks includes

// Localparams

// Registered outputs

// Combinational regs

// Internal registers

// Internal wires

// Wires assignments

// Modules instantiations

endmodule 


