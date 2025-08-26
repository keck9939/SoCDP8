
# SoCDP8   [![Badge Hardware]][Hardware]   [![Badge Software]][Software]

This fork of SoCDP8 adds a branch (2025.1) which is intended to allow the project to build with Vivado 2025.1.
In addition, it will add documentation to allow people who are not FPGA and Linux gurus to build it, as the original
project contains almost no documentation.

There are a couple of items of immediate interest:
1) The original author has completly built images that allow you to try SoCDP8 easily. They can be found at: https://folko.solhost.org/socdp8/ for either Zynqberry or Pynq-Z2. Note the username and password for these images is "socdp8". Unfortunately these images do not seem to be up to date with the repo.
2) The original author also has an incredible Antares logic simulation of the PDP-8/I that can be found at: https://github.com/fpw/antares-pdp-8i. I highly recommend checking this out.

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

In principle, you should be able to replace the .bit file in the /boot directory of the .wic image referenced above with the one generated here and it should work. I found my system locked up when I did this. This may be because the .wic image does not reflect the current rtl, but at this point I'm not sure. This was tested on Windows 11 with Vivado 2025.1. I would expect it to work on Linux as well.

Since Petalinux, the usual way to build Linux for Zynq, uses Yocto under the hood, it is unclear from the sources which the original author used to build his image. Judging from the running image, he used Yocto. However, I was unable to get anywhere with Yocto, in part due to versioning issues (Yocto builds depend on the underying OS version and Yocto version). In addition, AMD/Xilinx info on using Yocto to build are kind of sketchy (admitedly I'm not a Yocto expert, but then you shouldn't need to be to build a simple system). So I have decided to build the system with Petalinux. I ran into multiple issues getting this to work, in particular the system locked up when the server code was run. This ended up being due to axi_bram.vhd, which evidently is not fully axi compliant and locked up the bus when connected to the newer Xilinx IP. This was fixed by replacing it with the Xilinx block ram controller and generator IP.

Note that I am using Petalinux 2025.1 on Ubuntu 22.04 running on WSL 2. Create a Petalinux project using the XSA file generated from the Vivado build above. Be sure to check when you import the XSA file that Petalinux is configured to boot off the SD card. While you are doing this also add `uio_pdrv_genirq.of_id=generic-uio` to Extra Boot Args which enables the UIO driver. To add nodejs, edit `project-spec/meta-user/conf/user-rootfsconfig` and add the line `CONFIG_nodejs`. Then do a `petalinux-config -c rootfs`, go to `user packages` and enable nodejs. (https://adaptivesupport.amd.com/s/question/0D54U00007SIihbSAD/how-do-i-enable-install-nodejs-in-petalinux-20222).

In addition to node, the petalinux image needs modifications to the dts to specify that uio is to be used for the PL component drivers and also to define register names. Also, some aliases are added for future use. So replace the `system-user.dtsi` template in `project-spec\meta-user\recipes-bsp\device-tree\files` with the one in `src\petalinux` Finally, the kernel config needs to be modified to build the uio driver into the kernel rather than as a module.

Build the system and run it on your Zynq. You should be able to type `node -v` and see the node version.

The next task is to build the node package that runs the web server. Again versioning issues kick in. After a lot of messing around I discovered the Node Version Manager, nvm (https://github.com/nvm-sh/nvm). Using that, I installed node 20.18.2 (the version installed on the petalinux image). But I ran into issues with mmap-io, which is old and no longer maintained. Fortunately, there are forked maintained versions, so edit `server/package.json` and change the mmap-io dependency to `"mmap-io": "npm:@riaskov/mmap-io@^1.4.3"`. The package should now install, build and prepack on your system.

Since this package incorporates compiled C++ code, unfortunately it can't just be used on the Zynq as is. So it is going to need to be cross compiled. If you haven't already `petalinux-build -sdk` to build the sdk and `petalinux-package sysroot` to install the sdk. Source the sdk environment and then use `npm --target_arch=arm [command]` to run the npm commands to install and build the client and server. Now you have a package that will run on the Zynq.

Once the server is built, tar.gz the server code (which now has the client as well) and transfer it to the Zynq. Create a `/home/socdp8` directory and change the owner to petalinux. You should now be able to run the server `node lib/main.js`. You will find that if you try to access the web server, it will not load into the browser. This seems to be some cross site issue I don't currently understand.

Getting to this point was not easy. Documentation is fragmented, unclear, often out of date and sometimes wrong. There are a lot of pieces involved. So it is entirely possible, I've missed things in this description. If there is something wrong or unclear, raise it as an issue and I'll try and fix it.

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
