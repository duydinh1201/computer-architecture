

int counter = 0;
int star_rd=0;
int  ena_star=0;
int a=0;
#define MAX_SIM 50000
void set_random(Vtop* dut, vluint64_t sim_unit) {
int arr[1000];
    if(counter%20) a=a;
    	else a=!a;
	dut->st_en_i=a;
	 star_rd++;
	if(star_rd>=40) star_rd=0;
	if(star_rd>=20) dut->addr_i=arr[star_rd-20];
	else if(star_rd>=10) {
		 arr[star_rd]=rand();
		 dut->addr_i=arr[star_rd];		
			}
   else  {
   		arr[star_rd]=1024+star_rd*16;
   	    dut->addr_i=arr[star_rd];	
   		}
   if(star_rd>=30) 	dut->sw_i=rand();
    else 	dut->sw_i=262143*(rand()%11);
	dut->st_i=rand();
	counter++;
	dut->rst_ni = (sim_unit % 10000 == 0) ? 0 : 1;
}
/*
//brcomp
#define MAX_SIM 50000
int counter = 0;
int a=0;
void set_random(Vtop* dut, vluint64_t sim_unit) {	
	dut->rs1_d_i=2952790015-rand()%4294967295;
	if(!(sim_unit%23))	dut->rs2_d_i=dut->rs1_d_i;
	else 	dut->rs2_d_i=2952790015-rand()%4294967295;
	if(sim_unit<=2000) dut->br_signed=0;
	else	dut->br_signed=1;

}



/*
//soda
#define MAX_SIM 50000
int counter = 0;
int a=0;
void set_random(Vtop* dut, vluint64_t sim_unit) {	
	dut->nickle_i=rand()%2;
	if(!(dut->nickle_i))	dut->dime_i=(!(rand()%4))?1:0;
	if(!(dut->nickle_i)&&!(dut->dime_i)) dut->quater_i=rand()%2;
	else dut->quater_i=0;
 	dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;

}

/*
//regfile
#define MAX_SIM 50000
int counter = 0;
int a=0;
void set_random(Vtop* dut, vluint64_t sim_unit) {	
	dut->rd_data_i=rand();
	dut->rd_addr_i=rand();
    dut->rs1_addr_i=rand();
   	dut->rs2_addr_i=rand();
   	counter++;
   	if(counter%1000) a=a;
    else a=!a;
	dut->rd_wr=a;

   dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;

}

/*
//decoder
#include <iostream>
#include <string>
#define MAX_SIM 50000

int counter = 0;


void set_random(Vtop* dut, vluint64_t sim_unit) {
    char hexString[] = "1a15266f1a15296f1a1522131a152300fa152d631a152f171a1528371a152933ad1527231a152a37adefd667"; // chuỗi hex
    char hex_arr[9]; // Kích thước của hex_arr cần phải là 9 để có chỗ lưu kí tự null ('\0').
        strncpy(hex_arr, &hexString[counter*8], 8);
        hex_arr[8] = '\0'; // Thêm kí tự null ('\0') vào cuối chuỗi.
        dut->instr_i = std::stoul(hex_arr, nullptr, 16);
        counter++;
        if(counter==11) counter=0;
   
    // dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;
}

//alu
/*#define MAX_SIM 50000

int counter = 0;
int value = 1;
int position = 0;

void set_random(Vtop* dut, vluint64_t sim_unit) {

	
	dut->operand0_i=2952790015-rand()%4294967295;
	dut->operand1_i=2952790015-rand()%4294967295;
    dut->alu_op_i=3;	
	counter++;
	if(counter>15) counter=rand()%2+2;
	 //   dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;

}/*/
/*#define MAX_SIM 1000000
//sha-256

void set_random(Vtop *dut, vluint64_t sim_unit) {
        			for(int i=0;i<16;i++){
        			if(i==0) dut->m_i[i]=rand(); 
        			else if(i==15) dut->m_i[i]=16;
        			else dut->m_i[i]=0;	
        				}
        	            dut->rst_i=(sim_unit>4&&rand()%1000!=0);
}
/*/
/*
//UARTs
#include <cstdlib> // for rand() function
#define MAX_SIM 1000000

int w = 0, r = 1;
int* ptr_w = &w;
int* ptr_r = &r;
void set_random(Vtop* dut, vluint64_t sim_unit) {
 if((sim_unit%60000)<20000){
 	*ptr_w =0;
    *ptr_r =1;
 	
 }
    else if((sim_unit % 434 == 0) && (sim_unit > 436)){
     
        if (*ptr_w == 0) {
            *ptr_r = 0;
        } else if (*ptr_w == 9) {
            *ptr_r = 1;
        } else {
            *ptr_r = rand() % 2;
        }
        *ptr_w = (*ptr_w + 1) % 10;
    }
	dut->clk_rd_i=sim_unit%2;
	dut->clk_wr_i=sim_unit%2;
    dut->Rx_i = r;
    dut->ena_wr_i = (!(sim_unit%20000)) ? rand()%2 : dut->ena_wr_i;
    dut->wr_i = rand() % 256;
 //   dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;
}
/*
//Async_FIFO
#define MAX_SIM 10000
int w = 0, r = 1;
int *ptr_w = &w;
int *ptr_r = &r;

void set_random(Vtop *dut, vluint64_t sim_unit) {
    if (!(sim_unit%150)) {
        *ptr_r =!r;
    } else {
        *ptr_r = *ptr_r;
    }
	*ptr_r=(!(sim_unit%15))?rand()%2:*ptr_r;
//	*ptr_w=(!(sim_unit%15))?rand()%2:*ptr_w;
    dut->ena_wr = r;
    dut->ena_rd = !r;
    dut->clk_wr =sim_unit%2;
    dut->clk_rd = !(sim_unit % 8) ? 1 : 0;
    dut->wr_i = rand() % 256;
   dut->rst_i = !((sim_unit - 4) % 500) ? 0 : 1;
}
/*
//mining
#include <stdio.h>
#include <string.h>

#define MAX_SIM 100000000

int counter = 0;
int value = 1;
int position = 0;
//char arr[81] = {"eb94f2c7d51e989940129ab5f49ffff001d3ae24b1822515151651561516516515545465ghjh25gh"};//80byte
char hex_arr[]={"01000000c39aa0fa65b6c0f6bdae75dd5fe2b934d155235c01f0b6c1b55c664fe98ee8d33af57b65c7f5d74df2b944195d266450dc2309cc190e2dbc00000000f6eaa79f06f42942045a5d5b00000001"}; // chuỗi kí	 tự cần chuyển sang hex
char hex[3]; // biến lưu giá trị hex tạm thời

// chuyển từng bit theo chuẩn UART 10bit
void set_random(Vtop* dut, vluint64_t sim_unit) {
    if (sim_unit < 20000 || position > 79) {
        value = 1;
        if ((dut->fl_end) == 0) position = 0;
    } else if (sim_unit % 434 == 0 && sim_unit > 434 * 2) {
        if (counter == 0) {
            value = 0; // bit start UART
        } else if (counter == 9) {
            value = 1; // bit stop UART
            position++;
        } else {
            int bit_index =8-counter; // vị trí bit cần gửi
            if (position >= 80) {
                value = 1; // đã gửi hết dữ liệu
            } else {
                // chuyển kí tự thành hex và gán bit tương ứng vào value
              //  sprintf(hex, "%02x", arr[79 - position]);
      				  strncpy(hex,&hex_arr[158-position*2], 2);
                int hex_val = hex[bit_index / 4] - (hex[bit_index / 4] >= 'a' ? 'a' - 10 : '0'); // lấy giá trị hex từ kí tự hex tương ứng
                value = (hex_val >> (3-bit_index % 4)) & 1; // lấy bit tương ứng từ giá trị hex
            }
        }
        counter = (counter + 1) % 10;
    }
    dut->Rx_i = value;
}
/*
#define MAX_SIM 5000000

int counter = 0;
int value = 1;
int position = 0;

void set_random(Vtop* dut, vluint64_t sim_unit) {

	
	dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;
}
*/
