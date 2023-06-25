LOGIN=xroman18

default: all

test: zip
	@./test.sh

zip:
	@zip $(LOGIN).zip uart_rx.vhd uart_rx_fsm.vhd zprava.pdf > /dev/null

all:
	@./uart.sh

clean:
	@rm -rf work/
	@rm -rf synth.vhd