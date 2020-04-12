//*****************************************************************************
// qwi05_hdmi.v
//
// This module is the top wrapper of qwi05_hdmi project.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 11, 2020     Initial Release
//*****************************************************************************

module qwi05_hdmi
(
   //DDR interface
   inout     [14:0]   DDR_addr         ,
	inout     [2:0]    DDR_ba           ,
	inout              DDR_cas_n        ,
	inout              DDR_ck_n         ,
	inout              DDR_ck_p         ,
	inout              DDR_cke          ,
	inout              DDR_cs_n         ,
	inout     [3:0]    DDR_dm           ,
	inout     [31:0]   DDR_dq           ,
	inout     [3:0]    DDR_dqs_n        ,
	inout     [3:0]    DDR_dqs_p        ,
	inout              DDR_odt          ,
	inout              DDR_ras_n        ,
	inout              DDR_reset_n      ,
	inout              DDR_we_n         ,
   //fixed_io interface
	inout              FIXED_IO_ddr_vrn ,
	inout              FIXED_IO_ddr_vrp ,
	inout     [53:0]   FIXED_IO_mio     ,
	inout              FIXED_IO_ps_clk  ,
	inout              FIXED_IO_ps_porb ,
	inout              FIXED_IO_ps_srstb,
   //clock
   input              sys_clk_50m      ,

   //HDMI interface
   input     [0:0]    hdmi_hpd_tri_i   ,
   inout              hdmi_ddc_scl     ,
   inout              hdmi_ddc_sda     ,
	output    [0:0]    HDMI_OEN         ,
	output             TMDS_clk_n       ,
	output             TMDS_clk_p       ,
   output    [2:0]    TMDS_data_n      ,
	output    [2:0]    TMDS_data_p      ,

   //LED
   output             led_indc
);

//*****************************************************************************
// Includes
//*****************************************************************************
`include "Define.vh"

//*****************************************************************************
// Signals
//*****************************************************************************
wire        clk_100m;
(* keep="true" *)wire        vid_active;
(* keep="true" *)wire [23:0] vid_data;
wire        vid_field;
(* keep="true" *)wire        vid_hblank;
(* keep="true" *)wire        vid_hsync;
(* keep="true" *)wire        vid_vblank;
(* keep="true" *)wire        vid_vsync;
(* keep="true" *)wire [11:0] vid_ppl;
(* keep="true" *)wire [11:0] vid_lpf;
wire        mmcm_locked;
wire        clk_148p5m;
wire        clk_742p5m;

//*****************************************************************************
// Reg control
//*****************************************************************************
wire [12:0] reg_ctrl_addr;
wire        reg_ctrl_clk;
wire [31:0] reg_ctrl_din;
wire [31:0] reg_ctrl_dout;
wire        reg_ctrl_en;
wire        reg_ctrl_rst;
wire [3:0]  reg_ctrl_we;

wire [31:0] reg_fw_ver;
wire [31:0] reg_fmt_def;

//*****************************************************************************
// Maps
//*****************************************************************************
clk_wiz_1 m100_mmcm
(
   .clk_100m               ( clk_100m ),
   .reset                  ( 1'b0 ),
   .locked                 ( ),
   .clk_50m                ( sys_clk_50m )
);

clk_wiz_0 vid_mmcm
(
   .clk_148p5m             ( clk_148p5m ),
   .clk_742p5m            ( clk_742p5m ),
   .reset                  ( 1'b0 ),
   .mmcm_locked            ( mmcm_locked ),
   .clk_100m               ( clk_100m )
);

system u_system
(
   //DDR interface
   .DDR_addr               ( DDR_addr ),
   .DDR_ba                 ( DDR_ba ),
   .DDR_cas_n              ( DDR_cas_n ),
   .DDR_ck_n               ( DDR_ck_n ),
   .DDR_ck_p               ( DDR_ck_p ),
   .DDR_cke                ( DDR_cke ),
   .DDR_cs_n               ( DDR_cs_n ),
   .DDR_dm                 ( DDR_dm ),
   .DDR_dq                 ( DDR_dq ),
   .DDR_dqs_n              ( DDR_dqs_n ),
   .DDR_dqs_p              ( DDR_dqs_p ),
   .DDR_odt                ( DDR_odt ),
   .DDR_ras_n              ( DDR_ras_n ),
   .DDR_reset_n            ( DDR_reset_n ),
   .DDR_we_n               ( DDR_we_n ),
   //fixed_io interface
   .FIXED_IO_ddr_vrn       ( FIXED_IO_ddr_vrn ),
   .FIXED_IO_ddr_vrp       ( FIXED_IO_ddr_vrp ),
   .FIXED_IO_mio           ( FIXED_IO_mio ),
   .FIXED_IO_ps_clk        ( FIXED_IO_ps_clk ),
   .FIXED_IO_ps_porb       ( FIXED_IO_ps_porb ),
   .FIXED_IO_ps_srstb      ( FIXED_IO_ps_srstb ),

   //FCLK
   .FCLK_100M              ( /*clk_100m*/ ),

   //Reg control
   .REG_CTRL_addr          ( reg_ctrl_addr ),
   .REG_CTRL_clk           ( reg_ctrl_clk ),
   .REG_CTRL_din           ( reg_ctrl_din ),
   .REG_CTRL_dout          ( reg_ctrl_dout ),
   .REG_CTRL_en            ( reg_ctrl_en ),
   .REG_CTRL_rst           ( reg_ctrl_rst ),
   .REG_CTRL_we            ( reg_ctrl_we )
);

//*****************************************************************************
// Reg control
//*****************************************************************************
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

//*****************************************************************************
// HDMI generate
//*****************************************************************************
hdmi_vtg u_hdmi_vtg
(
   .clk                    ( clk_148p5m ),
   .gen_ce                 ( 1'b1 ),
   .fmt_def                ( reg_fmt_def[2:0] ),

   .ppl                    ( vid_ppl ),
   .lpf                    ( vid_lpf ),
   .hsync                  ( vid_hsync ),
   .vsync                  ( vid_vsync ),
   .hblank                 ( vid_hblank ),
   .vblank                 ( vid_vblank ),
   .active                 ( vid_active )
);

hdmi_tpg u_hdmi_tpg
(
   .clk                    ( clk_148p5m ),

   .fmt_def                ( reg_fmt_def[2:0] ),
   .ppl                    ( vid_ppl ),
   .lpf                    ( vid_lpf ),

   .rbg                    ( vid_data )
);

//*****************************************************************************
// HDMI OUT
//*****************************************************************************
assign HDMI_OEN = 1'b1;
rgb2dvi u_rgb2dvi
(
   .PixelClk               ( clk_148p5m ),
   .SerialClk              ( clk_742p5m ),
   .aRst                   ( ),
   .aRst_n                 ( mmcm_locked ),
   .vid_pData              ( vid_data[23:0] ),
   .vid_pVDE               ( vid_active ),
   .vid_pHSync             ( vid_hsync ),
   .vid_pVSync             ( vid_vsync ),
   .TMDS_Clk_p             ( TMDS_clk_p ),
   .TMDS_Clk_n             ( TMDS_clk_n ),
   .TMDS_Data_p            ( TMDS_data_p ),
   .TMDS_Data_n            ( TMDS_data_n )
);

//*****************************************************************************
// LED indicator
//*****************************************************************************
led_indicator	
#(
   .SET_TIME_1S            ( 74_250_000 ),
   .LED_NUM                ( 1 )
)
u_led_indicator							
(
	.clk                    ( clk_148p5m ),
   .rst                    ( 1'b0 ),
	.led                    ( led_indc )
);

endmodule
