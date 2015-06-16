/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	
--Version:VERA.1.0.0
--Data modified:
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:2015/6/16 10:15:40
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module spi_model (
	output		cs_n		,
	output		mosi		,
	input		miso		,
	output		sck 		
);

int			bit_cnt;
int			byte_cnt;
logic[7:0]	read_data  [$];
logic[7:0]	write_data [$] = {8'h00,8'h01,8'h02,8'h03,8'h04,8'h01,8'h02,8'h03,8'h04};

spi_core #(
	.PHASE			(0		),
	.ACTIVE			(0		),
	.Freq			(16		)
)spi_core_inst(
	.cs_n			(cs_n	),	
	.mosi			(mosi	),
	.miso			(miso	),
	.sck 			(sck 	)
);


initial begin
	spi_core_inst.Burst_Write(write_data);
//	spi_core_inst.Burst_Read(3);
end

assign	bit_cnt		= spi_core_inst.bit_cnt;
assign	byte_cnt	= spi_core_inst.byte_cnt;
assign	read_data	= spi_core_inst.rd_seq;

endmodule





			
	
	
	
	
