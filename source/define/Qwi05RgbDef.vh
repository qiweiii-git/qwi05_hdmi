//*****************************************************************************
// Qwi05RgbDef.vh.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 11, 2020     Initial Release
//*****************************************************************************

//*****************************************************************************
// reg defines
//*****************************************************************************
`define RGB_B 7:0
`define RGB_G 15:8
`define RGB_R 23:16

localparam RGB_RED = 0,
           RGB_ORA = 1,
           RGB_YEL = 2,
           RGB_GRE = 3,
           RGB_CYA = 4,
           RGB_BLU = 5,
           RGB_PUR = 6,
           RGB_WHI = 7,
           RGB_BLA = 8,
           RGB_CNT = 9;

//*****************************************************************************
// reg initialized value
//*****************************************************************************
wire [23:0] RGB_TABLE[0:RGB_CNT-1];

assign RGB_TABLE[RGB_RED] = 24'hFF0000;
assign RGB_TABLE[RGB_ORA] = 24'hFFA500;
assign RGB_TABLE[RGB_YEL] = 24'hFFFF00;
assign RGB_TABLE[RGB_GRE] = 24'h00FF00;
assign RGB_TABLE[RGB_CYA] = 24'h00FFFF;
assign RGB_TABLE[RGB_BLU] = 24'h0000FF;
assign RGB_TABLE[RGB_PUR] = 24'hA020F0;
assign RGB_TABLE[RGB_WHI] = 24'hFFFFFF;
assign RGB_TABLE[RGB_BLA] = 24'h000000;

