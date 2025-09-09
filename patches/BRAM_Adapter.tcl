
################################################################
# This is a generated script based on design: topBlock
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source topBlock_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:inline_hdl:ilslice:1.0\
xilinx.com:inline_hdl:ilconstant:1.0\
xilinx.com:inline_hdl:ilreduced_logic:1.0\
xilinx.com:inline_hdl:ilconcat:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: BRAM_Adapter
proc create_hier_cell_BRAM_Adapter { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_BRAM_Adapter() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 Din
  create_bd_pin -dir I -from 16 -to 0 Din1
  create_bd_pin -dir O -from 14 -to 0 Dout
  create_bd_pin -dir I -from 31 -to 0 Din2
  create_bd_pin -dir O -from 11 -to 0 Dout1
  create_bd_pin -dir O Res
  create_bd_pin -dir I -from 11 -to 0 In0
  create_bd_pin -dir O -from 31 -to 0 dout2

  # Create instance: ilslice_0, and set properties
  set ilslice_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_WIDTH {4} \
  ] $ilslice_0


  # Create instance: ilconstant_2, and set properties
  set ilconstant_2 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_2 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {20} \
  ] $ilconstant_2


  # Create instance: ilslice_1, and set properties
  set ilslice_1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {16} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {17} \
  ] $ilslice_1


  # Create instance: ilslice_3, and set properties
  set ilslice_3 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_3 ]
  set_property CONFIG.DIN_FROM {11} $ilslice_3


  # Create instance: ilreduced_logic_0, and set properties
  set ilreduced_logic_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilreduced_logic:1.0 ilreduced_logic_0 ]
  set_property CONFIG.C_SIZE {2} $ilreduced_logic_0


  # Create instance: ilconcat_0, and set properties
  set ilconcat_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 ilconcat_0 ]

  # Create port connections
  connect_bd_net -net axi_bram_ctrl_0_bram_addr_a  [get_bd_pins Din1] \
  [get_bd_pins ilslice_1/Din]
  connect_bd_net -net axi_bram_ctrl_0_bram_we_a  [get_bd_pins Din] \
  [get_bd_pins ilslice_0/Din]
  connect_bd_net -net axi_bram_ctrl_0_bram_wrdata_a  [get_bd_pins Din2] \
  [get_bd_pins ilslice_3/Din]
  connect_bd_net -net blk_mem_gen_0_douta  [get_bd_pins In0] \
  [get_bd_pins ilconcat_0/In0]
  connect_bd_net -net ilconcat_0_dout  [get_bd_pins ilconcat_0/dout] \
  [get_bd_pins dout2]
  connect_bd_net -net ilconstant_2_dout  [get_bd_pins ilconstant_2/dout] \
  [get_bd_pins ilconcat_0/In1]
  connect_bd_net -net ilreduced_logic_0_Res  [get_bd_pins ilreduced_logic_0/Res] \
  [get_bd_pins Res]
  connect_bd_net -net ilslice_0_Dout  [get_bd_pins ilslice_0/Dout] \
  [get_bd_pins ilreduced_logic_0/Op1]
  connect_bd_net -net ilslice_1_Dout  [get_bd_pins ilslice_1/Dout] \
  [get_bd_pins Dout]
  connect_bd_net -net ilslice_3_Dout  [get_bd_pins ilslice_3/Dout] \
  [get_bd_pins Dout1]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_BRAM_Adapter parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
