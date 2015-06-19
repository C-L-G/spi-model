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
--Data created:
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module tb_top_only_spi;

wire	cs_n		;
wire	mosi		;
wire	miso		;
wire	sck 		;


spi_model model(
	.cs_n			(cs_n		),		
	.mosi			(mosi		),
	.miso			(miso		),
	.sck 			(sck 		)
);

top top_inst(
	.spi_cs_n		(cs_n  		),
	.spi_mosi		(mosi       ),
	.spi_miso		(miso       ),
	.spi_sck 		(sck 	    )   
);

logic[7:0]	write_data [$] = {8'h2f,8'h01,8'h02,8'h03,8'h04,8'h01,8'h02,8'h03,8'h04};

initial begin
	model.write(write_data);
	model.read(8);
	model.cmd({8'hF0},1);
end

endmodule
