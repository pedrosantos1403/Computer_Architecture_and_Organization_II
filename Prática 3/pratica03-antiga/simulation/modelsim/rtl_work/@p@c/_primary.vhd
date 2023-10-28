library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        parada          : in     vl_logic;
        pc              : out    vl_logic_vector(7 downto 0)
    );
end PC;
