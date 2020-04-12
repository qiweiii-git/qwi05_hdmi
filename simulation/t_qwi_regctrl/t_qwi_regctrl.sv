
`timescale 1ns/1ns
`include "Define.vh"
module t_qwi_regctrl();

reg  [12:0] reg_ctrl_addr;
reg         reg_ctrl_clk = 0;
reg  [31:0] reg_ctrl_din;
wire [31:0] reg_ctrl_dout;
reg         reg_ctrl_en;
reg         reg_ctrl_rst = 1;
reg  [3:0]  reg_ctrl_we;
reg         reg_init;

wire [31:0] reg_fw_ver;
wire [31:0] reg_fmt_def;

initial #500 reg_ctrl_rst = ~reg_ctrl_rst;
always  #2 reg_ctrl_clk = ~reg_ctrl_clk;

always @(posedge reg_ctrl_clk)
begin
   if(reg_ctrl_rst)
   begin
      reg_ctrl_addr <= 0;
      reg_ctrl_din <= 0;
      reg_ctrl_en <= 0;
      reg_ctrl_we <= 0;
      reg_init <= 0;
   end
   else if(!reg_init)
   begin
      reg_ctrl_addr <= FMT_DEF << 2;
      reg_ctrl_din <= 3;
      reg_ctrl_en <= 1;
      reg_ctrl_we <= 4'hf;
      reg_init <= 1;
   end
   else
   begin
      reg_ctrl_addr <= 0;
      reg_ctrl_din <= 0;
      reg_ctrl_en <= 0;
      reg_ctrl_we <= 0;
   end
end

qwi_regctrl
#(
   .REGCNT                 ( REG_CNT ),
   .AWID                   ( 11 ),
   .DWID                   ( 32 )
)
u_qwi_regctrl
(  
   .sys_rst                ( 1'b0 ),
   .reg_ce                 ( reg_ctrl_en ),
   .reg_rst                ( reg_ctrl_rst ),
   .reg_clk                ( reg_ctrl_clk ),
   .reg_we                 ( reg_ctrl_we ),
   .reg_addr               ( reg_ctrl_addr[12:2] ),
   .reg_wrd                ( reg_ctrl_din ),
   .reg_rdd                ( reg_ctrl_dout ),

   .reg_out                ( {{ reg_fmt_def },
                              { reg_fw_ver }} ),
   .reg_in                 ( {{ reg_fmt_def },
                              { reg_fw_ver }} )
);

endmodule
