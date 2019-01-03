//SW[6:0] data inputs
//SW[9:7] select signal

//LEDR[0] output display

module mux7to1(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    reg Out; // d e c l a r e the output s i g n a l f r o the always b l o c k

    always @(*) // d e c l a r e always b l o c k
    begin
        case (SW[9:7] ) // s t a r t case s tat ement
            3'b000: Out = SW[0]; // case 0
            3'b001: Out = SW[1]; // case 1
            3'b010: Out = SW[2]; // case 2
            3'b011: Out = SW[3]; // case 3
            3'b100: Out = SW[4]; // case 4
            3'b101: Out = SW[5];// case 5
            3'b110: Out = SW[6];// case 6
            default : Out = SW[0];// d e f a u l t case
        endcase
    end

    assign LEDR[0] = Out;
endmodule
