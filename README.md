
# SoCDP8   [![Badge Hardware]][Hardware]   [![Badge Software]][Software]

This fork of SoCDP8 adds a branch (2025.1) which is intended to allow the project to build with Vivado 2025.1.
In addition, it will add documentation to allow people who are not FPGA and Linux gurus to build it, as the original
project contains almost no documentation.

There are a couple of items of immediate interest:
1) The original author has completly built images that allow you to try SoCDP8 easily. They can be found at: https://folko.solhost.org/socdp8/ for either Zynqberry or Pynq-Z2.
2) The original author also has an incredible Antares logic simulation of the SoCDP8 that can be found at: https://github.com/fpw/antares-pdp-8i. I highly recommend checking this out.

See the README.md file in the master branch for the original project description.

## Building

Create a working directory, e.g. zynqdp8, to hold the SoCDP8 files and the Vivado project. Put a clone of the 2025.1 branch of SoCDP8 in this directory. Copy `SoCDP8\src\fpga\boards\pynq-z2-project.tcl` to `zynqdp8\pynq-z2-project.tcl` and copy `SoCDP8\src\fpga\boards\blockdesign\pynq_z2_block.tcl` to `zynqdp8\pynq_z2_block.tcl`. Your directory should look like:
```
.
├── SoCDP8
│   ├── LICENSE
│   ├── LICENSE-HARDWARE
│   ├── README.md
│   ├── docs
│   ├── pictures
│   └── src
├── pynq-z2-project.tcl
└── pynq_z2_block.tcl
```

Open Vivado 2025.1 (other versions may work, but you will need to edit `pynq_z2_block.tcl` to reflect the version). In the Tcl console cd to the location of your working directory. Then `source pynq-z2-project.tcl`. At the `Invalid Top Module` prompt just choose `OK`. Once this is done, `source pynq_z2_block.tcl`. Now in the Vivado block design sources tab, right click on the `pynq_z2_block_i` entry and choose `Create HDL Wrapper`. Set the resulting wrapper as the design top.

In the Design Flow choose Generate Bitstream. The project should successfully build the bitstream file.

This was tested on Windows 11 with Vivado 2025.1. I would expect it to work on Linux as well.


<!----------------------------------------------------------------------------->

[PiDP-8/I Console]: https://obsolescence.wixsite.com/obsolescence/pidp-8
[DE0-Nano-SoC]: https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=163&No=941&PartNo=1
[DEC PDP-8/I]: https://en.wikipedia.org/wiki/PDP-8
[ZynqBerry]: https://shop.trenz-electronic.de/en/TE0726-03M-ZynqBerry-Zynq-7010-in-Raspberry-Pi-form-factor
[Pynq-Z2]: http://www.tul.com.tw/ProductsPYNQ-Z2.html

[Maintenance Manual]: docs/PDP8I_maintenance_manual_vol1.pdf
[Preview]: pictures/Preview.png
[Hardware]: LICENSE-HARDWARE
[Software]: LICENSE


<!--------------------------------[ Badges ]----------------------------------->

[Badge Software]: https://img.shields.io/badge/License-AGPL3-015d93.svg?style=for-the-badge&labelColor=blue
[Badge Hardware]: https://img.shields.io/badge/Open_Hardware-1.2-21214e?style=for-the-badge&labelColor=292961
