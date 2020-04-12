
`timescale 1ns/1ns
module t_hdmi();

reg clk_74p25m = 1;
wire [11:0] vid_ppl;
wire [11:0] vid_lpf;


always #2 clk_74p25m = ~clk_74p25m;


hdmi_vtg u_hdmi_vtg
(
   .clk                    ( clk_74p25m ),
   .gen_ce                 ( 1'b1 ),
   .fmt_def                ( 2 ),

   .ppl                    ( vid_ppl ),
   .lpf                    ( vid_lpf ),
   .hsync                  ( ),
   .vsync                  ( ),
   .hblank                 ( ),
   .vblank                 ( ),
   .active                 ( )
);

hdmi_tpg u_hdmi_tpg
(
   .clk                    ( clk_74p25m ),

   .fmt_def                ( 2 ),
   .ppl                    ( vid_ppl ),
   .lpf                    ( vid_lpf ),

   .rgb                    ( )
);

endmodule
