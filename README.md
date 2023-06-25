# uart-rx
Implementation of UART RX for VUT INC course.

## Building
`ghdl` and `gtk-wave` are required. Works on everything (Windows remain untested, sorry).
`make` is optional, just simplifies some commands.
1) Clone this repo
2) `cd uart-rx`
3) `make` / `./uart.sh`

## Running
```
./uart.sh
```
Or manually launch `gtk-wave` and open generated `sim.ghw` with `wave.tcl` file in it.

## Testing

### Remaks
File `zprava.pdf` is not actually required, you can replace it with just empty file with `pdf` extension and same name, because test script just checks for it's presence.

#### If `make` is present
```
make test
```
#### If you don't have `make` installed
1) ```
   zip xroman18.zip uart_rx.vhd uart_rx_fsm.vhd zprava.pdf > /dev/null
   ```
2) ```
   ./test.sh
   ```
