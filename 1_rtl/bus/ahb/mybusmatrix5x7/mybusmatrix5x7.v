//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2001-2013-2020 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2012-10-15 18:01:36 +0100 (Mon, 15 Oct 2012) $
//
//      Revision            : $Revision: 225465 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-01rel0
//
//-----------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//  Abstract            : BusMatrix is the top-level which connects together
//                        the required Input Stages, MatrixDecodes, Output
//                        Stages and Output Arbitration blocks.
//
//                        Supports the following configured options:
//
//                         - Architecture type 'ahb2',
//                         - 5 slave ports (connecting to masters),
//                         - 7 master ports (connecting to slaves),
//                         - Routing address width of 32 bits,
//                         - Routing data width of 32 bits,
//                         - xUSER signal width of 32 bits,
//                         - Arbiter type 'fixed',
//                         - Connectivity mapping:
//                             M0 -> S0, 
//                             M1 -> S0, 
//                             M2 -> S1, S2, S3, S4, S5, S6, 
//                             M3 -> S1, S2, S3, S4, S5, S6, 
//                             M4 -> S1, S2, S3, S4, S5, S6,
//                         - Connectivity type 'sparse'.
//
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module mybusmatrix5x7 (

    // Common AHB signals
    HCLK,
    HRESETn,

    // System address remapping control
    REMAP,

    // Input port SI0 (inputs from master 0)
    HSELM0,
    HADDRM0,
    HTRANSM0,
    HWRITEM0,
    HSIZEM0,
    HBURSTM0,
    HPROTM0,
    HMASTERM0,
    HWDATAM0,
    HMASTLOCKM0,
    HREADYM0,
    HAUSERM0,
    HWUSERM0,

    // Input port SI1 (inputs from master 1)
    HSELM1,
    HADDRM1,
    HTRANSM1,
    HWRITEM1,
    HSIZEM1,
    HBURSTM1,
    HPROTM1,
    HMASTERM1,
    HWDATAM1,
    HMASTLOCKM1,
    HREADYM1,
    HAUSERM1,
    HWUSERM1,

    // Input port SI2 (inputs from master 2)
    HSELM2,
    HADDRM2,
    HTRANSM2,
    HWRITEM2,
    HSIZEM2,
    HBURSTM2,
    HPROTM2,
    HMASTERM2,
    HWDATAM2,
    HMASTLOCKM2,
    HREADYM2,
    HAUSERM2,
    HWUSERM2,

    // Input port SI3 (inputs from master 3)
    HSELM3,
    HADDRM3,
    HTRANSM3,
    HWRITEM3,
    HSIZEM3,
    HBURSTM3,
    HPROTM3,
    HMASTERM3,
    HWDATAM3,
    HMASTLOCKM3,
    HREADYM3,
    HAUSERM3,
    HWUSERM3,

    // Input port SI4 (inputs from master 4)
    HSELM4,
    HADDRM4,
    HTRANSM4,
    HWRITEM4,
    HSIZEM4,
    HBURSTM4,
    HPROTM4,
    HMASTERM4,
    HWDATAM4,
    HMASTLOCKM4,
    HREADYM4,
    HAUSERM4,
    HWUSERM4,

    // Output port MI0 (inputs from slave 0)
    HRDATAS0,
    HREADYOUTS0,
    HRESPS0,
    HRUSERS0,

    // Output port MI1 (inputs from slave 1)
    HRDATAS1,
    HREADYOUTS1,
    HRESPS1,
    HRUSERS1,

    // Output port MI2 (inputs from slave 2)
    HRDATAS2,
    HREADYOUTS2,
    HRESPS2,
    HRUSERS2,

    // Output port MI3 (inputs from slave 3)
    HRDATAS3,
    HREADYOUTS3,
    HRESPS3,
    HRUSERS3,

    // Output port MI4 (inputs from slave 4)
    HRDATAS4,
    HREADYOUTS4,
    HRESPS4,
    HRUSERS4,

    // Output port MI5 (inputs from slave 5)
    HRDATAS5,
    HREADYOUTS5,
    HRESPS5,
    HRUSERS5,

    // Output port MI6 (inputs from slave 6)
    HRDATAS6,
    HREADYOUTS6,
    HRESPS6,
    HRUSERS6,

    // Scan test dummy signals; not connected until scan insertion
    SCANENABLE,   // Scan Test Mode Enable
    SCANINHCLK,   // Scan Chain Input


    // Output port MI0 (outputs to slave 0)
    HSELS0,
    HADDRS0,
    HTRANSS0,
    HWRITES0,
    HSIZES0,
    HBURSTS0,
    HPROTS0,
    HMASTERS0,
    HWDATAS0,
    HMASTLOCKS0,
    HREADYMUXS0,
    HAUSERS0,
    HWUSERS0,

    // Output port MI1 (outputs to slave 1)
    HSELS1,
    HADDRS1,
    HTRANSS1,
    HWRITES1,
    HSIZES1,
    HBURSTS1,
    HPROTS1,
    HMASTERS1,
    HWDATAS1,
    HMASTLOCKS1,
    HREADYMUXS1,
    HAUSERS1,
    HWUSERS1,

    // Output port MI2 (outputs to slave 2)
    HSELS2,
    HADDRS2,
    HTRANSS2,
    HWRITES2,
    HSIZES2,
    HBURSTS2,
    HPROTS2,
    HMASTERS2,
    HWDATAS2,
    HMASTLOCKS2,
    HREADYMUXS2,
    HAUSERS2,
    HWUSERS2,

    // Output port MI3 (outputs to slave 3)
    HSELS3,
    HADDRS3,
    HTRANSS3,
    HWRITES3,
    HSIZES3,
    HBURSTS3,
    HPROTS3,
    HMASTERS3,
    HWDATAS3,
    HMASTLOCKS3,
    HREADYMUXS3,
    HAUSERS3,
    HWUSERS3,

    // Output port MI4 (outputs to slave 4)
    HSELS4,
    HADDRS4,
    HTRANSS4,
    HWRITES4,
    HSIZES4,
    HBURSTS4,
    HPROTS4,
    HMASTERS4,
    HWDATAS4,
    HMASTLOCKS4,
    HREADYMUXS4,
    HAUSERS4,
    HWUSERS4,

    // Output port MI5 (outputs to slave 5)
    HSELS5,
    HADDRS5,
    HTRANSS5,
    HWRITES5,
    HSIZES5,
    HBURSTS5,
    HPROTS5,
    HMASTERS5,
    HWDATAS5,
    HMASTLOCKS5,
    HREADYMUXS5,
    HAUSERS5,
    HWUSERS5,

    // Output port MI6 (outputs to slave 6)
    HSELS6,
    HADDRS6,
    HTRANSS6,
    HWRITES6,
    HSIZES6,
    HBURSTS6,
    HPROTS6,
    HMASTERS6,
    HWDATAS6,
    HMASTLOCKS6,
    HREADYMUXS6,
    HAUSERS6,
    HWUSERS6,

    // Input port SI0 (outputs to master 0)
    HRDATAM0,
    HREADYOUTM0,
    HRESPM0,
    HRUSERM0,

    // Input port SI1 (outputs to master 1)
    HRDATAM1,
    HREADYOUTM1,
    HRESPM1,
    HRUSERM1,

    // Input port SI2 (outputs to master 2)
    HRDATAM2,
    HREADYOUTM2,
    HRESPM2,
    HRUSERM2,

    // Input port SI3 (outputs to master 3)
    HRDATAM3,
    HREADYOUTM3,
    HRESPM3,
    HRUSERM3,

    // Input port SI4 (outputs to master 4)
    HRDATAM4,
    HREADYOUTM4,
    HRESPM4,
    HRUSERM4,

    // Scan test dummy signals; not connected until scan insertion
    SCANOUTHCLK   // Scan Chain Output

    );


// -----------------------------------------------------------------------------
// Input and Output declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    input         HCLK;            // AHB System Clock
    input         HRESETn;         // AHB System Reset

    // System address remapping control
    input   [3:0] REMAP;           // REMAP input

    // Input port SI0 (inputs from master 0)
    input         HSELM0;          // Slave Select
    input  [31:0] HADDRM0;         // Address bus
    input   [1:0] HTRANSM0;        // Transfer type
    input         HWRITEM0;        // Transfer direction
    input   [2:0] HSIZEM0;         // Transfer size
    input   [2:0] HBURSTM0;        // Burst type
    input   [3:0] HPROTM0;         // Protection control
    input   [3:0] HMASTERM0;       // Master select
    input  [31:0] HWDATAM0;        // Write data
    input         HMASTLOCKM0;     // Locked Sequence
    input         HREADYM0;        // Transfer done
    input  [31:0] HAUSERM0;        // Address USER signals
    input  [31:0] HWUSERM0;        // Write-data USER signals

    // Input port SI1 (inputs from master 1)
    input         HSELM1;          // Slave Select
    input  [31:0] HADDRM1;         // Address bus
    input   [1:0] HTRANSM1;        // Transfer type
    input         HWRITEM1;        // Transfer direction
    input   [2:0] HSIZEM1;         // Transfer size
    input   [2:0] HBURSTM1;        // Burst type
    input   [3:0] HPROTM1;         // Protection control
    input   [3:0] HMASTERM1;       // Master select
    input  [31:0] HWDATAM1;        // Write data
    input         HMASTLOCKM1;     // Locked Sequence
    input         HREADYM1;        // Transfer done
    input  [31:0] HAUSERM1;        // Address USER signals
    input  [31:0] HWUSERM1;        // Write-data USER signals

    // Input port SI2 (inputs from master 2)
    input         HSELM2;          // Slave Select
    input  [31:0] HADDRM2;         // Address bus
    input   [1:0] HTRANSM2;        // Transfer type
    input         HWRITEM2;        // Transfer direction
    input   [2:0] HSIZEM2;         // Transfer size
    input   [2:0] HBURSTM2;        // Burst type
    input   [3:0] HPROTM2;         // Protection control
    input   [3:0] HMASTERM2;       // Master select
    input  [31:0] HWDATAM2;        // Write data
    input         HMASTLOCKM2;     // Locked Sequence
    input         HREADYM2;        // Transfer done
    input  [31:0] HAUSERM2;        // Address USER signals
    input  [31:0] HWUSERM2;        // Write-data USER signals

    // Input port SI3 (inputs from master 3)
    input         HSELM3;          // Slave Select
    input  [31:0] HADDRM3;         // Address bus
    input   [1:0] HTRANSM3;        // Transfer type
    input         HWRITEM3;        // Transfer direction
    input   [2:0] HSIZEM3;         // Transfer size
    input   [2:0] HBURSTM3;        // Burst type
    input   [3:0] HPROTM3;         // Protection control
    input   [3:0] HMASTERM3;       // Master select
    input  [31:0] HWDATAM3;        // Write data
    input         HMASTLOCKM3;     // Locked Sequence
    input         HREADYM3;        // Transfer done
    input  [31:0] HAUSERM3;        // Address USER signals
    input  [31:0] HWUSERM3;        // Write-data USER signals

    // Input port SI4 (inputs from master 4)
    input         HSELM4;          // Slave Select
    input  [31:0] HADDRM4;         // Address bus
    input   [1:0] HTRANSM4;        // Transfer type
    input         HWRITEM4;        // Transfer direction
    input   [2:0] HSIZEM4;         // Transfer size
    input   [2:0] HBURSTM4;        // Burst type
    input   [3:0] HPROTM4;         // Protection control
    input   [3:0] HMASTERM4;       // Master select
    input  [31:0] HWDATAM4;        // Write data
    input         HMASTLOCKM4;     // Locked Sequence
    input         HREADYM4;        // Transfer done
    input  [31:0] HAUSERM4;        // Address USER signals
    input  [31:0] HWUSERM4;        // Write-data USER signals

    // Output port MI0 (inputs from slave 0)
    input  [31:0] HRDATAS0;        // Read data bus
    input         HREADYOUTS0;     // HREADY feedback
    input   [1:0] HRESPS0;         // Transfer response
    input  [31:0] HRUSERS0;        // Read-data USER signals

    // Output port MI1 (inputs from slave 1)
    input  [31:0] HRDATAS1;        // Read data bus
    input         HREADYOUTS1;     // HREADY feedback
    input   [1:0] HRESPS1;         // Transfer response
    input  [31:0] HRUSERS1;        // Read-data USER signals

    // Output port MI2 (inputs from slave 2)
    input  [31:0] HRDATAS2;        // Read data bus
    input         HREADYOUTS2;     // HREADY feedback
    input   [1:0] HRESPS2;         // Transfer response
    input  [31:0] HRUSERS2;        // Read-data USER signals

    // Output port MI3 (inputs from slave 3)
    input  [31:0] HRDATAS3;        // Read data bus
    input         HREADYOUTS3;     // HREADY feedback
    input   [1:0] HRESPS3;         // Transfer response
    input  [31:0] HRUSERS3;        // Read-data USER signals

    // Output port MI4 (inputs from slave 4)
    input  [31:0] HRDATAS4;        // Read data bus
    input         HREADYOUTS4;     // HREADY feedback
    input   [1:0] HRESPS4;         // Transfer response
    input  [31:0] HRUSERS4;        // Read-data USER signals

    // Output port MI5 (inputs from slave 5)
    input  [31:0] HRDATAS5;        // Read data bus
    input         HREADYOUTS5;     // HREADY feedback
    input   [1:0] HRESPS5;         // Transfer response
    input  [31:0] HRUSERS5;        // Read-data USER signals

    // Output port MI6 (inputs from slave 6)
    input  [31:0] HRDATAS6;        // Read data bus
    input         HREADYOUTS6;     // HREADY feedback
    input   [1:0] HRESPS6;         // Transfer response
    input  [31:0] HRUSERS6;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    input         SCANENABLE;      // Scan enable signal
    input         SCANINHCLK;      // HCLK scan input


    // Output port MI0 (outputs to slave 0)
    output        HSELS0;          // Slave Select
    output [31:0] HADDRS0;         // Address bus
    output  [1:0] HTRANSS0;        // Transfer type
    output        HWRITES0;        // Transfer direction
    output  [2:0] HSIZES0;         // Transfer size
    output  [2:0] HBURSTS0;        // Burst type
    output  [3:0] HPROTS0;         // Protection control
    output  [3:0] HMASTERS0;       // Master select
    output [31:0] HWDATAS0;        // Write data
    output        HMASTLOCKS0;     // Locked Sequence
    output        HREADYMUXS0;     // Transfer done
    output [31:0] HAUSERS0;        // Address USER signals
    output [31:0] HWUSERS0;        // Write-data USER signals

    // Output port MI1 (outputs to slave 1)
    output        HSELS1;          // Slave Select
    output [31:0] HADDRS1;         // Address bus
    output  [1:0] HTRANSS1;        // Transfer type
    output        HWRITES1;        // Transfer direction
    output  [2:0] HSIZES1;         // Transfer size
    output  [2:0] HBURSTS1;        // Burst type
    output  [3:0] HPROTS1;         // Protection control
    output  [3:0] HMASTERS1;       // Master select
    output [31:0] HWDATAS1;        // Write data
    output        HMASTLOCKS1;     // Locked Sequence
    output        HREADYMUXS1;     // Transfer done
    output [31:0] HAUSERS1;        // Address USER signals
    output [31:0] HWUSERS1;        // Write-data USER signals

    // Output port MI2 (outputs to slave 2)
    output        HSELS2;          // Slave Select
    output [31:0] HADDRS2;         // Address bus
    output  [1:0] HTRANSS2;        // Transfer type
    output        HWRITES2;        // Transfer direction
    output  [2:0] HSIZES2;         // Transfer size
    output  [2:0] HBURSTS2;        // Burst type
    output  [3:0] HPROTS2;         // Protection control
    output  [3:0] HMASTERS2;       // Master select
    output [31:0] HWDATAS2;        // Write data
    output        HMASTLOCKS2;     // Locked Sequence
    output        HREADYMUXS2;     // Transfer done
    output [31:0] HAUSERS2;        // Address USER signals
    output [31:0] HWUSERS2;        // Write-data USER signals

    // Output port MI3 (outputs to slave 3)
    output        HSELS3;          // Slave Select
    output [31:0] HADDRS3;         // Address bus
    output  [1:0] HTRANSS3;        // Transfer type
    output        HWRITES3;        // Transfer direction
    output  [2:0] HSIZES3;         // Transfer size
    output  [2:0] HBURSTS3;        // Burst type
    output  [3:0] HPROTS3;         // Protection control
    output  [3:0] HMASTERS3;       // Master select
    output [31:0] HWDATAS3;        // Write data
    output        HMASTLOCKS3;     // Locked Sequence
    output        HREADYMUXS3;     // Transfer done
    output [31:0] HAUSERS3;        // Address USER signals
    output [31:0] HWUSERS3;        // Write-data USER signals

    // Output port MI4 (outputs to slave 4)
    output        HSELS4;          // Slave Select
    output [31:0] HADDRS4;         // Address bus
    output  [1:0] HTRANSS4;        // Transfer type
    output        HWRITES4;        // Transfer direction
    output  [2:0] HSIZES4;         // Transfer size
    output  [2:0] HBURSTS4;        // Burst type
    output  [3:0] HPROTS4;         // Protection control
    output  [3:0] HMASTERS4;       // Master select
    output [31:0] HWDATAS4;        // Write data
    output        HMASTLOCKS4;     // Locked Sequence
    output        HREADYMUXS4;     // Transfer done
    output [31:0] HAUSERS4;        // Address USER signals
    output [31:0] HWUSERS4;        // Write-data USER signals

    // Output port MI5 (outputs to slave 5)
    output        HSELS5;          // Slave Select
    output [31:0] HADDRS5;         // Address bus
    output  [1:0] HTRANSS5;        // Transfer type
    output        HWRITES5;        // Transfer direction
    output  [2:0] HSIZES5;         // Transfer size
    output  [2:0] HBURSTS5;        // Burst type
    output  [3:0] HPROTS5;         // Protection control
    output  [3:0] HMASTERS5;       // Master select
    output [31:0] HWDATAS5;        // Write data
    output        HMASTLOCKS5;     // Locked Sequence
    output        HREADYMUXS5;     // Transfer done
    output [31:0] HAUSERS5;        // Address USER signals
    output [31:0] HWUSERS5;        // Write-data USER signals

    // Output port MI6 (outputs to slave 6)
    output        HSELS6;          // Slave Select
    output [31:0] HADDRS6;         // Address bus
    output  [1:0] HTRANSS6;        // Transfer type
    output        HWRITES6;        // Transfer direction
    output  [2:0] HSIZES6;         // Transfer size
    output  [2:0] HBURSTS6;        // Burst type
    output  [3:0] HPROTS6;         // Protection control
    output  [3:0] HMASTERS6;       // Master select
    output [31:0] HWDATAS6;        // Write data
    output        HMASTLOCKS6;     // Locked Sequence
    output        HREADYMUXS6;     // Transfer done
    output [31:0] HAUSERS6;        // Address USER signals
    output [31:0] HWUSERS6;        // Write-data USER signals

    // Input port SI0 (outputs to master 0)
    output [31:0] HRDATAM0;        // Read data bus
    output        HREADYOUTM0;     // HREADY feedback
    output  [1:0] HRESPM0;         // Transfer response
    output [31:0] HRUSERM0;        // Read-data USER signals

    // Input port SI1 (outputs to master 1)
    output [31:0] HRDATAM1;        // Read data bus
    output        HREADYOUTM1;     // HREADY feedback
    output  [1:0] HRESPM1;         // Transfer response
    output [31:0] HRUSERM1;        // Read-data USER signals

    // Input port SI2 (outputs to master 2)
    output [31:0] HRDATAM2;        // Read data bus
    output        HREADYOUTM2;     // HREADY feedback
    output  [1:0] HRESPM2;         // Transfer response
    output [31:0] HRUSERM2;        // Read-data USER signals

    // Input port SI3 (outputs to master 3)
    output [31:0] HRDATAM3;        // Read data bus
    output        HREADYOUTM3;     // HREADY feedback
    output  [1:0] HRESPM3;         // Transfer response
    output [31:0] HRUSERM3;        // Read-data USER signals

    // Input port SI4 (outputs to master 4)
    output [31:0] HRDATAM4;        // Read data bus
    output        HREADYOUTM4;     // HREADY feedback
    output  [1:0] HRESPM4;         // Transfer response
    output [31:0] HRUSERM4;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    output        SCANOUTHCLK;     // Scan Chain Output


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    wire         HCLK;            // AHB System Clock
    wire         HRESETn;         // AHB System Reset

    // System address remapping control
    wire   [3:0] REMAP;           // REMAP signal

    // Input Port SI0
    wire         HSELM0;          // Slave Select
    wire  [31:0] HADDRM0;         // Address bus
    wire   [1:0] HTRANSM0;        // Transfer type
    wire         HWRITEM0;        // Transfer direction
    wire   [2:0] HSIZEM0;         // Transfer size
    wire   [2:0] HBURSTM0;        // Burst type
    wire   [3:0] HPROTM0;         // Protection control
    wire   [3:0] HMASTERM0;       // Master select
    wire  [31:0] HWDATAM0;        // Write data
    wire         HMASTLOCKM0;     // Locked Sequence
    wire         HREADYM0;        // Transfer done

    wire  [31:0] HRDATAM0;        // Read data bus
    wire         HREADYOUTM0;     // HREADY feedback
    wire   [1:0] HRESPM0;         // Transfer response
    wire  [31:0] HAUSERM0;        // Address USER signals
    wire  [31:0] HWUSERM0;        // Write-data USER signals
    wire  [31:0] HRUSERM0;        // Read-data USER signals

    // Input Port SI1
    wire         HSELM1;          // Slave Select
    wire  [31:0] HADDRM1;         // Address bus
    wire   [1:0] HTRANSM1;        // Transfer type
    wire         HWRITEM1;        // Transfer direction
    wire   [2:0] HSIZEM1;         // Transfer size
    wire   [2:0] HBURSTM1;        // Burst type
    wire   [3:0] HPROTM1;         // Protection control
    wire   [3:0] HMASTERM1;       // Master select
    wire  [31:0] HWDATAM1;        // Write data
    wire         HMASTLOCKM1;     // Locked Sequence
    wire         HREADYM1;        // Transfer done

    wire  [31:0] HRDATAM1;        // Read data bus
    wire         HREADYOUTM1;     // HREADY feedback
    wire   [1:0] HRESPM1;         // Transfer response
    wire  [31:0] HAUSERM1;        // Address USER signals
    wire  [31:0] HWUSERM1;        // Write-data USER signals
    wire  [31:0] HRUSERM1;        // Read-data USER signals

    // Input Port SI2
    wire         HSELM2;          // Slave Select
    wire  [31:0] HADDRM2;         // Address bus
    wire   [1:0] HTRANSM2;        // Transfer type
    wire         HWRITEM2;        // Transfer direction
    wire   [2:0] HSIZEM2;         // Transfer size
    wire   [2:0] HBURSTM2;        // Burst type
    wire   [3:0] HPROTM2;         // Protection control
    wire   [3:0] HMASTERM2;       // Master select
    wire  [31:0] HWDATAM2;        // Write data
    wire         HMASTLOCKM2;     // Locked Sequence
    wire         HREADYM2;        // Transfer done

    wire  [31:0] HRDATAM2;        // Read data bus
    wire         HREADYOUTM2;     // HREADY feedback
    wire   [1:0] HRESPM2;         // Transfer response
    wire  [31:0] HAUSERM2;        // Address USER signals
    wire  [31:0] HWUSERM2;        // Write-data USER signals
    wire  [31:0] HRUSERM2;        // Read-data USER signals

    // Input Port SI3
    wire         HSELM3;          // Slave Select
    wire  [31:0] HADDRM3;         // Address bus
    wire   [1:0] HTRANSM3;        // Transfer type
    wire         HWRITEM3;        // Transfer direction
    wire   [2:0] HSIZEM3;         // Transfer size
    wire   [2:0] HBURSTM3;        // Burst type
    wire   [3:0] HPROTM3;         // Protection control
    wire   [3:0] HMASTERM3;       // Master select
    wire  [31:0] HWDATAM3;        // Write data
    wire         HMASTLOCKM3;     // Locked Sequence
    wire         HREADYM3;        // Transfer done

    wire  [31:0] HRDATAM3;        // Read data bus
    wire         HREADYOUTM3;     // HREADY feedback
    wire   [1:0] HRESPM3;         // Transfer response
    wire  [31:0] HAUSERM3;        // Address USER signals
    wire  [31:0] HWUSERM3;        // Write-data USER signals
    wire  [31:0] HRUSERM3;        // Read-data USER signals

    // Input Port SI4
    wire         HSELM4;          // Slave Select
    wire  [31:0] HADDRM4;         // Address bus
    wire   [1:0] HTRANSM4;        // Transfer type
    wire         HWRITEM4;        // Transfer direction
    wire   [2:0] HSIZEM4;         // Transfer size
    wire   [2:0] HBURSTM4;        // Burst type
    wire   [3:0] HPROTM4;         // Protection control
    wire   [3:0] HMASTERM4;       // Master select
    wire  [31:0] HWDATAM4;        // Write data
    wire         HMASTLOCKM4;     // Locked Sequence
    wire         HREADYM4;        // Transfer done

    wire  [31:0] HRDATAM4;        // Read data bus
    wire         HREADYOUTM4;     // HREADY feedback
    wire   [1:0] HRESPM4;         // Transfer response
    wire  [31:0] HAUSERM4;        // Address USER signals
    wire  [31:0] HWUSERM4;        // Write-data USER signals
    wire  [31:0] HRUSERM4;        // Read-data USER signals

    // Output Port MI0
    wire         HSELS0;          // Slave Select
    wire  [31:0] HADDRS0;         // Address bus
    wire   [1:0] HTRANSS0;        // Transfer type
    wire         HWRITES0;        // Transfer direction
    wire   [2:0] HSIZES0;         // Transfer size
    wire   [2:0] HBURSTS0;        // Burst type
    wire   [3:0] HPROTS0;         // Protection control
    wire   [3:0] HMASTERS0;       // Master select
    wire  [31:0] HWDATAS0;        // Write data
    wire         HMASTLOCKS0;     // Locked Sequence
    wire         HREADYMUXS0;     // Transfer done

    wire  [31:0] HRDATAS0;        // Read data bus
    wire         HREADYOUTS0;     // HREADY feedback
    wire   [1:0] HRESPS0;         // Transfer response
    wire  [31:0] HAUSERS0;        // Address USER signals
    wire  [31:0] HWUSERS0;        // Write-data USER signals
    wire  [31:0] HRUSERS0;        // Read-data USER signals

    // Output Port MI1
    wire         HSELS1;          // Slave Select
    wire  [31:0] HADDRS1;         // Address bus
    wire   [1:0] HTRANSS1;        // Transfer type
    wire         HWRITES1;        // Transfer direction
    wire   [2:0] HSIZES1;         // Transfer size
    wire   [2:0] HBURSTS1;        // Burst type
    wire   [3:0] HPROTS1;         // Protection control
    wire   [3:0] HMASTERS1;       // Master select
    wire  [31:0] HWDATAS1;        // Write data
    wire         HMASTLOCKS1;     // Locked Sequence
    wire         HREADYMUXS1;     // Transfer done

    wire  [31:0] HRDATAS1;        // Read data bus
    wire         HREADYOUTS1;     // HREADY feedback
    wire   [1:0] HRESPS1;         // Transfer response
    wire  [31:0] HAUSERS1;        // Address USER signals
    wire  [31:0] HWUSERS1;        // Write-data USER signals
    wire  [31:0] HRUSERS1;        // Read-data USER signals

    // Output Port MI2
    wire         HSELS2;          // Slave Select
    wire  [31:0] HADDRS2;         // Address bus
    wire   [1:0] HTRANSS2;        // Transfer type
    wire         HWRITES2;        // Transfer direction
    wire   [2:0] HSIZES2;         // Transfer size
    wire   [2:0] HBURSTS2;        // Burst type
    wire   [3:0] HPROTS2;         // Protection control
    wire   [3:0] HMASTERS2;       // Master select
    wire  [31:0] HWDATAS2;        // Write data
    wire         HMASTLOCKS2;     // Locked Sequence
    wire         HREADYMUXS2;     // Transfer done

    wire  [31:0] HRDATAS2;        // Read data bus
    wire         HREADYOUTS2;     // HREADY feedback
    wire   [1:0] HRESPS2;         // Transfer response
    wire  [31:0] HAUSERS2;        // Address USER signals
    wire  [31:0] HWUSERS2;        // Write-data USER signals
    wire  [31:0] HRUSERS2;        // Read-data USER signals

    // Output Port MI3
    wire         HSELS3;          // Slave Select
    wire  [31:0] HADDRS3;         // Address bus
    wire   [1:0] HTRANSS3;        // Transfer type
    wire         HWRITES3;        // Transfer direction
    wire   [2:0] HSIZES3;         // Transfer size
    wire   [2:0] HBURSTS3;        // Burst type
    wire   [3:0] HPROTS3;         // Protection control
    wire   [3:0] HMASTERS3;       // Master select
    wire  [31:0] HWDATAS3;        // Write data
    wire         HMASTLOCKS3;     // Locked Sequence
    wire         HREADYMUXS3;     // Transfer done

    wire  [31:0] HRDATAS3;        // Read data bus
    wire         HREADYOUTS3;     // HREADY feedback
    wire   [1:0] HRESPS3;         // Transfer response
    wire  [31:0] HAUSERS3;        // Address USER signals
    wire  [31:0] HWUSERS3;        // Write-data USER signals
    wire  [31:0] HRUSERS3;        // Read-data USER signals

    // Output Port MI4
    wire         HSELS4;          // Slave Select
    wire  [31:0] HADDRS4;         // Address bus
    wire   [1:0] HTRANSS4;        // Transfer type
    wire         HWRITES4;        // Transfer direction
    wire   [2:0] HSIZES4;         // Transfer size
    wire   [2:0] HBURSTS4;        // Burst type
    wire   [3:0] HPROTS4;         // Protection control
    wire   [3:0] HMASTERS4;       // Master select
    wire  [31:0] HWDATAS4;        // Write data
    wire         HMASTLOCKS4;     // Locked Sequence
    wire         HREADYMUXS4;     // Transfer done

    wire  [31:0] HRDATAS4;        // Read data bus
    wire         HREADYOUTS4;     // HREADY feedback
    wire   [1:0] HRESPS4;         // Transfer response
    wire  [31:0] HAUSERS4;        // Address USER signals
    wire  [31:0] HWUSERS4;        // Write-data USER signals
    wire  [31:0] HRUSERS4;        // Read-data USER signals

    // Output Port MI5
    wire         HSELS5;          // Slave Select
    wire  [31:0] HADDRS5;         // Address bus
    wire   [1:0] HTRANSS5;        // Transfer type
    wire         HWRITES5;        // Transfer direction
    wire   [2:0] HSIZES5;         // Transfer size
    wire   [2:0] HBURSTS5;        // Burst type
    wire   [3:0] HPROTS5;         // Protection control
    wire   [3:0] HMASTERS5;       // Master select
    wire  [31:0] HWDATAS5;        // Write data
    wire         HMASTLOCKS5;     // Locked Sequence
    wire         HREADYMUXS5;     // Transfer done

    wire  [31:0] HRDATAS5;        // Read data bus
    wire         HREADYOUTS5;     // HREADY feedback
    wire   [1:0] HRESPS5;         // Transfer response
    wire  [31:0] HAUSERS5;        // Address USER signals
    wire  [31:0] HWUSERS5;        // Write-data USER signals
    wire  [31:0] HRUSERS5;        // Read-data USER signals

    // Output Port MI6
    wire         HSELS6;          // Slave Select
    wire  [31:0] HADDRS6;         // Address bus
    wire   [1:0] HTRANSS6;        // Transfer type
    wire         HWRITES6;        // Transfer direction
    wire   [2:0] HSIZES6;         // Transfer size
    wire   [2:0] HBURSTS6;        // Burst type
    wire   [3:0] HPROTS6;         // Protection control
    wire   [3:0] HMASTERS6;       // Master select
    wire  [31:0] HWDATAS6;        // Write data
    wire         HMASTLOCKS6;     // Locked Sequence
    wire         HREADYMUXS6;     // Transfer done

    wire  [31:0] HRDATAS6;        // Read data bus
    wire         HREADYOUTS6;     // HREADY feedback
    wire   [1:0] HRESPS6;         // Transfer response
    wire  [31:0] HAUSERS6;        // Address USER signals
    wire  [31:0] HWUSERS6;        // Write-data USER signals
    wire  [31:0] HRUSERS6;        // Read-data USER signals


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------

    // Bus-switch input SI0
    wire         i_sel0;            // HSEL signal
    wire  [31:0] i_addr0;           // HADDR signal
    wire   [1:0] i_trans0;          // HTRANS signal
    wire         i_write0;          // HWRITE signal
    wire   [2:0] i_size0;           // HSIZE signal
    wire   [2:0] i_burst0;          // HBURST signal
    wire   [3:0] i_prot0;           // HPROTS signal
    wire   [3:0] i_master0;         // HMASTER signal
    wire         i_mastlock0;       // HMASTLOCK signal
    wire         i_active0;         // Active signal
    wire         i_held_tran0;       // HeldTran signal
    wire         i_readyout0;       // Readyout signal
    wire   [1:0] i_resp0;           // Response signal
    wire  [31:0] i_auser0;          // HAUSER signal

    // Bus-switch input SI1
    wire         i_sel1;            // HSEL signal
    wire  [31:0] i_addr1;           // HADDR signal
    wire   [1:0] i_trans1;          // HTRANS signal
    wire         i_write1;          // HWRITE signal
    wire   [2:0] i_size1;           // HSIZE signal
    wire   [2:0] i_burst1;          // HBURST signal
    wire   [3:0] i_prot1;           // HPROTS signal
    wire   [3:0] i_master1;         // HMASTER signal
    wire         i_mastlock1;       // HMASTLOCK signal
    wire         i_active1;         // Active signal
    wire         i_held_tran1;       // HeldTran signal
    wire         i_readyout1;       // Readyout signal
    wire   [1:0] i_resp1;           // Response signal
    wire  [31:0] i_auser1;          // HAUSER signal

    // Bus-switch input SI2
    wire         i_sel2;            // HSEL signal
    wire  [31:0] i_addr2;           // HADDR signal
    wire   [1:0] i_trans2;          // HTRANS signal
    wire         i_write2;          // HWRITE signal
    wire   [2:0] i_size2;           // HSIZE signal
    wire   [2:0] i_burst2;          // HBURST signal
    wire   [3:0] i_prot2;           // HPROTS signal
    wire   [3:0] i_master2;         // HMASTER signal
    wire         i_mastlock2;       // HMASTLOCK signal
    wire         i_active2;         // Active signal
    wire         i_held_tran2;       // HeldTran signal
    wire         i_readyout2;       // Readyout signal
    wire   [1:0] i_resp2;           // Response signal
    wire  [31:0] i_auser2;          // HAUSER signal

    // Bus-switch input SI3
    wire         i_sel3;            // HSEL signal
    wire  [31:0] i_addr3;           // HADDR signal
    wire   [1:0] i_trans3;          // HTRANS signal
    wire         i_write3;          // HWRITE signal
    wire   [2:0] i_size3;           // HSIZE signal
    wire   [2:0] i_burst3;          // HBURST signal
    wire   [3:0] i_prot3;           // HPROTS signal
    wire   [3:0] i_master3;         // HMASTER signal
    wire         i_mastlock3;       // HMASTLOCK signal
    wire         i_active3;         // Active signal
    wire         i_held_tran3;       // HeldTran signal
    wire         i_readyout3;       // Readyout signal
    wire   [1:0] i_resp3;           // Response signal
    wire  [31:0] i_auser3;          // HAUSER signal

    // Bus-switch input SI4
    wire         i_sel4;            // HSEL signal
    wire  [31:0] i_addr4;           // HADDR signal
    wire   [1:0] i_trans4;          // HTRANS signal
    wire         i_write4;          // HWRITE signal
    wire   [2:0] i_size4;           // HSIZE signal
    wire   [2:0] i_burst4;          // HBURST signal
    wire   [3:0] i_prot4;           // HPROTS signal
    wire   [3:0] i_master4;         // HMASTER signal
    wire         i_mastlock4;       // HMASTLOCK signal
    wire         i_active4;         // Active signal
    wire         i_held_tran4;       // HeldTran signal
    wire         i_readyout4;       // Readyout signal
    wire   [1:0] i_resp4;           // Response signal
    wire  [31:0] i_auser4;          // HAUSER signal

    // Bus-switch SI0 to MI0 signals
    wire         i_sel0to0;         // Routing selection signal
    wire         i_active0to0;      // Active signal

    // Bus-switch SI1 to MI0 signals
    wire         i_sel1to0;         // Routing selection signal
    wire         i_active1to0;      // Active signal

    // Bus-switch SI2 to MI1 signals
    wire         i_sel2to1;         // Routing selection signal
    wire         i_active2to1;      // Active signal

    // Bus-switch SI2 to MI2 signals
    wire         i_sel2to2;         // Routing selection signal
    wire         i_active2to2;      // Active signal

    // Bus-switch SI2 to MI3 signals
    wire         i_sel2to3;         // Routing selection signal
    wire         i_active2to3;      // Active signal

    // Bus-switch SI2 to MI4 signals
    wire         i_sel2to4;         // Routing selection signal
    wire         i_active2to4;      // Active signal

    // Bus-switch SI2 to MI5 signals
    wire         i_sel2to5;         // Routing selection signal
    wire         i_active2to5;      // Active signal

    // Bus-switch SI2 to MI6 signals
    wire         i_sel2to6;         // Routing selection signal
    wire         i_active2to6;      // Active signal

    // Bus-switch SI3 to MI1 signals
    wire         i_sel3to1;         // Routing selection signal
    wire         i_active3to1;      // Active signal

    // Bus-switch SI3 to MI2 signals
    wire         i_sel3to2;         // Routing selection signal
    wire         i_active3to2;      // Active signal

    // Bus-switch SI3 to MI3 signals
    wire         i_sel3to3;         // Routing selection signal
    wire         i_active3to3;      // Active signal

    // Bus-switch SI3 to MI4 signals
    wire         i_sel3to4;         // Routing selection signal
    wire         i_active3to4;      // Active signal

    // Bus-switch SI3 to MI5 signals
    wire         i_sel3to5;         // Routing selection signal
    wire         i_active3to5;      // Active signal

    // Bus-switch SI3 to MI6 signals
    wire         i_sel3to6;         // Routing selection signal
    wire         i_active3to6;      // Active signal

    // Bus-switch SI4 to MI1 signals
    wire         i_sel4to1;         // Routing selection signal
    wire         i_active4to1;      // Active signal

    // Bus-switch SI4 to MI2 signals
    wire         i_sel4to2;         // Routing selection signal
    wire         i_active4to2;      // Active signal

    // Bus-switch SI4 to MI3 signals
    wire         i_sel4to3;         // Routing selection signal
    wire         i_active4to3;      // Active signal

    // Bus-switch SI4 to MI4 signals
    wire         i_sel4to4;         // Routing selection signal
    wire         i_active4to4;      // Active signal

    // Bus-switch SI4 to MI5 signals
    wire         i_sel4to5;         // Routing selection signal
    wire         i_active4to5;      // Active signal

    // Bus-switch SI4 to MI6 signals
    wire         i_sel4to6;         // Routing selection signal
    wire         i_active4to6;      // Active signal

    wire         i_hready_mux_s0;    // Internal HREADYMUXM for MI0
    wire         i_hready_mux_s1;    // Internal HREADYMUXM for MI1
    wire         i_hready_mux_s2;    // Internal HREADYMUXM for MI2
    wire         i_hready_mux_s3;    // Internal HREADYMUXM for MI3
    wire         i_hready_mux_s4;    // Internal HREADYMUXM for MI4
    wire         i_hready_mux_s5;    // Internal HREADYMUXM for MI5
    wire         i_hready_mux_s6;    // Internal HREADYMUXM for MI6


// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------

  // Input stage for SI0
  mybusmatrix5x7_ip u_mybusmatrix5x7_ip_0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELM0),
    .HADDRS     (HADDRM0),
    .HTRANSS    (HTRANSM0),
    .HWRITES    (HWRITEM0),
    .HSIZES     (HSIZEM0),
    .HBURSTS    (HBURSTM0),
    .HPROTS     (HPROTM0),
    .HMASTERS   (HMASTERM0),
    .HMASTLOCKS (HMASTLOCKM0),
    .HREADYS    (HREADYM0),
    .HAUSERS    (HAUSERM0),

    // Internal Response
    .active_ip     (i_active0),
    .readyout_ip   (i_readyout0),
    .resp_ip       (i_resp0),

    // Input Port Response
    .HREADYOUTS (HREADYOUTM0),
    .HRESPS     (HRESPM0),

    // Internal Address/Control Signals
    .sel_ip        (i_sel0),
    .addr_ip       (i_addr0),
    .auser_ip      (i_auser0),
    .trans_ip      (i_trans0),
    .write_ip      (i_write0),
    .size_ip       (i_size0),
    .burst_ip      (i_burst0),
    .prot_ip       (i_prot0),
    .master_ip     (i_master0),
    .mastlock_ip   (i_mastlock0),
    .held_tran_ip   (i_held_tran0)

    );


  // Input stage for SI1
  mybusmatrix5x7_ip u_mybusmatrix5x7_ip_1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELM1),
    .HADDRS     (HADDRM1),
    .HTRANSS    (HTRANSM1),
    .HWRITES    (HWRITEM1),
    .HSIZES     (HSIZEM1),
    .HBURSTS    (HBURSTM1),
    .HPROTS     (HPROTM1),
    .HMASTERS   (HMASTERM1),
    .HMASTLOCKS (HMASTLOCKM1),
    .HREADYS    (HREADYM1),
    .HAUSERS    (HAUSERM1),

    // Internal Response
    .active_ip     (i_active1),
    .readyout_ip   (i_readyout1),
    .resp_ip       (i_resp1),

    // Input Port Response
    .HREADYOUTS (HREADYOUTM1),
    .HRESPS     (HRESPM1),

    // Internal Address/Control Signals
    .sel_ip        (i_sel1),
    .addr_ip       (i_addr1),
    .auser_ip      (i_auser1),
    .trans_ip      (i_trans1),
    .write_ip      (i_write1),
    .size_ip       (i_size1),
    .burst_ip      (i_burst1),
    .prot_ip       (i_prot1),
    .master_ip     (i_master1),
    .mastlock_ip   (i_mastlock1),
    .held_tran_ip   (i_held_tran1)

    );


  // Input stage for SI2
  mybusmatrix5x7_ip u_mybusmatrix5x7_ip_2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELM2),
    .HADDRS     (HADDRM2),
    .HTRANSS    (HTRANSM2),
    .HWRITES    (HWRITEM2),
    .HSIZES     (HSIZEM2),
    .HBURSTS    (HBURSTM2),
    .HPROTS     (HPROTM2),
    .HMASTERS   (HMASTERM2),
    .HMASTLOCKS (HMASTLOCKM2),
    .HREADYS    (HREADYM2),
    .HAUSERS    (HAUSERM2),

    // Internal Response
    .active_ip     (i_active2),
    .readyout_ip   (i_readyout2),
    .resp_ip       (i_resp2),

    // Input Port Response
    .HREADYOUTS (HREADYOUTM2),
    .HRESPS     (HRESPM2),

    // Internal Address/Control Signals
    .sel_ip        (i_sel2),
    .addr_ip       (i_addr2),
    .auser_ip      (i_auser2),
    .trans_ip      (i_trans2),
    .write_ip      (i_write2),
    .size_ip       (i_size2),
    .burst_ip      (i_burst2),
    .prot_ip       (i_prot2),
    .master_ip     (i_master2),
    .mastlock_ip   (i_mastlock2),
    .held_tran_ip   (i_held_tran2)

    );


  // Input stage for SI3
  mybusmatrix5x7_ip u_mybusmatrix5x7_ip_3 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELM3),
    .HADDRS     (HADDRM3),
    .HTRANSS    (HTRANSM3),
    .HWRITES    (HWRITEM3),
    .HSIZES     (HSIZEM3),
    .HBURSTS    (HBURSTM3),
    .HPROTS     (HPROTM3),
    .HMASTERS   (HMASTERM3),
    .HMASTLOCKS (HMASTLOCKM3),
    .HREADYS    (HREADYM3),
    .HAUSERS    (HAUSERM3),

    // Internal Response
    .active_ip     (i_active3),
    .readyout_ip   (i_readyout3),
    .resp_ip       (i_resp3),

    // Input Port Response
    .HREADYOUTS (HREADYOUTM3),
    .HRESPS     (HRESPM3),

    // Internal Address/Control Signals
    .sel_ip        (i_sel3),
    .addr_ip       (i_addr3),
    .auser_ip      (i_auser3),
    .trans_ip      (i_trans3),
    .write_ip      (i_write3),
    .size_ip       (i_size3),
    .burst_ip      (i_burst3),
    .prot_ip       (i_prot3),
    .master_ip     (i_master3),
    .mastlock_ip   (i_mastlock3),
    .held_tran_ip   (i_held_tran3)

    );


  // Input stage for SI4
  mybusmatrix5x7_ip u_mybusmatrix5x7_ip_4 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELM4),
    .HADDRS     (HADDRM4),
    .HTRANSS    (HTRANSM4),
    .HWRITES    (HWRITEM4),
    .HSIZES     (HSIZEM4),
    .HBURSTS    (HBURSTM4),
    .HPROTS     (HPROTM4),
    .HMASTERS   (HMASTERM4),
    .HMASTLOCKS (HMASTLOCKM4),
    .HREADYS    (HREADYM4),
    .HAUSERS    (HAUSERM4),

    // Internal Response
    .active_ip     (i_active4),
    .readyout_ip   (i_readyout4),
    .resp_ip       (i_resp4),

    // Input Port Response
    .HREADYOUTS (HREADYOUTM4),
    .HRESPS     (HRESPM4),

    // Internal Address/Control Signals
    .sel_ip        (i_sel4),
    .addr_ip       (i_addr4),
    .auser_ip      (i_auser4),
    .trans_ip      (i_trans4),
    .write_ip      (i_write4),
    .size_ip       (i_size4),
    .burst_ip      (i_burst4),
    .prot_ip       (i_prot4),
    .master_ip     (i_master4),
    .mastlock_ip   (i_mastlock4),
    .held_tran_ip   (i_held_tran4)

    );


  // Matrix decoder for SI0
  mybusmatrix5x7_dec_M0 u_mybusmatrix5x7_dec_m0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI0
    .HREADYS    (HREADYM0),
    .sel_dec        (i_sel0),
    .decode_addr_dec (i_addr0[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans0),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active0to0),
    .readyout_dec0  (i_hready_mux_s0),
    .resp_dec0      (HRESPS0),
    .rdata_dec0     (HRDATAS0),
    .ruser_dec0     (HRUSERS0),

    .sel_dec0       (i_sel0to0),

    .active_dec     (i_active0),
    .HREADYOUTS (i_readyout0),
    .HRESPS     (i_resp0),
    .HRUSERS    (HRUSERM0),
    .HRDATAS    (HRDATAM0)

    );


  // Matrix decoder for SI1
  mybusmatrix5x7_dec_M1 u_mybusmatrix5x7_dec_m1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI1
    .HREADYS    (HREADYM1),
    .sel_dec        (i_sel1),
    .decode_addr_dec (i_addr1[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans1),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active1to0),
    .readyout_dec0  (i_hready_mux_s0),
    .resp_dec0      (HRESPS0),
    .rdata_dec0     (HRDATAS0),
    .ruser_dec0     (HRUSERS0),

    .sel_dec0       (i_sel1to0),

    .active_dec     (i_active1),
    .HREADYOUTS (i_readyout1),
    .HRESPS     (i_resp1),
    .HRUSERS    (HRUSERM1),
    .HRDATAS    (HRDATAM1)

    );


  // Matrix decoder for SI2
  mybusmatrix5x7_dec_M2 u_mybusmatrix5x7_dec_m2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI2
    .HREADYS    (HREADYM2),
    .sel_dec        (i_sel2),
    .decode_addr_dec (i_addr2[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans2),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active2to1),
    .readyout_dec1  (i_hready_mux_s1),
    .resp_dec1      (HRESPS1),
    .rdata_dec1     (HRDATAS1),
    .ruser_dec1     (HRUSERS1),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active2to2),
    .readyout_dec2  (i_hready_mux_s2),
    .resp_dec2      (HRESPS2),
    .rdata_dec2     (HRDATAS2),
    .ruser_dec2     (HRUSERS2),

    // Control/Response for Output Stage MI3
    .active_dec3    (i_active2to3),
    .readyout_dec3  (i_hready_mux_s3),
    .resp_dec3      (HRESPS3),
    .rdata_dec3     (HRDATAS3),
    .ruser_dec3     (HRUSERS3),

    // Control/Response for Output Stage MI4
    .active_dec4    (i_active2to4),
    .readyout_dec4  (i_hready_mux_s4),
    .resp_dec4      (HRESPS4),
    .rdata_dec4     (HRDATAS4),
    .ruser_dec4     (HRUSERS4),

    // Control/Response for Output Stage MI5
    .active_dec5    (i_active2to5),
    .readyout_dec5  (i_hready_mux_s5),
    .resp_dec5      (HRESPS5),
    .rdata_dec5     (HRDATAS5),
    .ruser_dec5     (HRUSERS5),

    // Control/Response for Output Stage MI6
    .active_dec6    (i_active2to6),
    .readyout_dec6  (i_hready_mux_s6),
    .resp_dec6      (HRESPS6),
    .rdata_dec6     (HRDATAS6),
    .ruser_dec6     (HRUSERS6),

    .sel_dec1       (i_sel2to1),
    .sel_dec2       (i_sel2to2),
    .sel_dec3       (i_sel2to3),
    .sel_dec4       (i_sel2to4),
    .sel_dec5       (i_sel2to5),
    .sel_dec6       (i_sel2to6),

    .active_dec     (i_active2),
    .HREADYOUTS (i_readyout2),
    .HRESPS     (i_resp2),
    .HRUSERS    (HRUSERM2),
    .HRDATAS    (HRDATAM2)

    );


  // Matrix decoder for SI3
  mybusmatrix5x7_dec_M3 u_mybusmatrix5x7_dec_m3 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI3
    .HREADYS    (HREADYM3),
    .sel_dec        (i_sel3),
    .decode_addr_dec (i_addr3[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans3),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active3to1),
    .readyout_dec1  (i_hready_mux_s1),
    .resp_dec1      (HRESPS1),
    .rdata_dec1     (HRDATAS1),
    .ruser_dec1     (HRUSERS1),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active3to2),
    .readyout_dec2  (i_hready_mux_s2),
    .resp_dec2      (HRESPS2),
    .rdata_dec2     (HRDATAS2),
    .ruser_dec2     (HRUSERS2),

    // Control/Response for Output Stage MI3
    .active_dec3    (i_active3to3),
    .readyout_dec3  (i_hready_mux_s3),
    .resp_dec3      (HRESPS3),
    .rdata_dec3     (HRDATAS3),
    .ruser_dec3     (HRUSERS3),

    // Control/Response for Output Stage MI4
    .active_dec4    (i_active3to4),
    .readyout_dec4  (i_hready_mux_s4),
    .resp_dec4      (HRESPS4),
    .rdata_dec4     (HRDATAS4),
    .ruser_dec4     (HRUSERS4),

    // Control/Response for Output Stage MI5
    .active_dec5    (i_active3to5),
    .readyout_dec5  (i_hready_mux_s5),
    .resp_dec5      (HRESPS5),
    .rdata_dec5     (HRDATAS5),
    .ruser_dec5     (HRUSERS5),

    // Control/Response for Output Stage MI6
    .active_dec6    (i_active3to6),
    .readyout_dec6  (i_hready_mux_s6),
    .resp_dec6      (HRESPS6),
    .rdata_dec6     (HRDATAS6),
    .ruser_dec6     (HRUSERS6),

    .sel_dec1       (i_sel3to1),
    .sel_dec2       (i_sel3to2),
    .sel_dec3       (i_sel3to3),
    .sel_dec4       (i_sel3to4),
    .sel_dec5       (i_sel3to5),
    .sel_dec6       (i_sel3to6),

    .active_dec     (i_active3),
    .HREADYOUTS (i_readyout3),
    .HRESPS     (i_resp3),
    .HRUSERS    (HRUSERM3),
    .HRDATAS    (HRDATAM3)

    );


  // Matrix decoder for SI4
  mybusmatrix5x7_dec_M4 u_mybusmatrix5x7_dec_m4 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI4
    .HREADYS    (HREADYM4),
    .sel_dec        (i_sel4),
    .decode_addr_dec (i_addr4[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans4),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active4to1),
    .readyout_dec1  (i_hready_mux_s1),
    .resp_dec1      (HRESPS1),
    .rdata_dec1     (HRDATAS1),
    .ruser_dec1     (HRUSERS1),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active4to2),
    .readyout_dec2  (i_hready_mux_s2),
    .resp_dec2      (HRESPS2),
    .rdata_dec2     (HRDATAS2),
    .ruser_dec2     (HRUSERS2),

    // Control/Response for Output Stage MI3
    .active_dec3    (i_active4to3),
    .readyout_dec3  (i_hready_mux_s3),
    .resp_dec3      (HRESPS3),
    .rdata_dec3     (HRDATAS3),
    .ruser_dec3     (HRUSERS3),

    // Control/Response for Output Stage MI4
    .active_dec4    (i_active4to4),
    .readyout_dec4  (i_hready_mux_s4),
    .resp_dec4      (HRESPS4),
    .rdata_dec4     (HRDATAS4),
    .ruser_dec4     (HRUSERS4),

    // Control/Response for Output Stage MI5
    .active_dec5    (i_active4to5),
    .readyout_dec5  (i_hready_mux_s5),
    .resp_dec5      (HRESPS5),
    .rdata_dec5     (HRDATAS5),
    .ruser_dec5     (HRUSERS5),

    // Control/Response for Output Stage MI6
    .active_dec6    (i_active4to6),
    .readyout_dec6  (i_hready_mux_s6),
    .resp_dec6      (HRESPS6),
    .rdata_dec6     (HRDATAS6),
    .ruser_dec6     (HRUSERS6),

    .sel_dec1       (i_sel4to1),
    .sel_dec2       (i_sel4to2),
    .sel_dec3       (i_sel4to3),
    .sel_dec4       (i_sel4to4),
    .sel_dec5       (i_sel4to5),
    .sel_dec6       (i_sel4to6),

    .active_dec     (i_active4),
    .HREADYOUTS (i_readyout4),
    .HRESPS     (i_resp4),
    .HRUSERS    (HRUSERM4),
    .HRDATAS    (HRDATAM4)

    );


  // Output stage for MI0
  mybusmatrix5x7_op_S0 u_mybusmatrix5x7_op_s0_0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .sel_op0       (i_sel0to0),
    .addr_op0      (i_addr0),
    .auser_op0     (i_auser0),
    .trans_op0     (i_trans0),
    .write_op0     (i_write0),
    .size_op0      (i_size0),
    .burst_op0     (i_burst0),
    .prot_op0      (i_prot0),
    .master_op0    (i_master0),
    .mastlock_op0  (i_mastlock0),
    .wdata_op0     (HWDATAM0),
    .wuser_op0     (HWUSERM0),
    .held_tran_op0  (i_held_tran0),

    // Port 1 Signals
    .sel_op1       (i_sel1to0),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAM1),
    .wuser_op1     (HWUSERM1),
    .held_tran_op1  (i_held_tran1),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTS0),

    .active_op0    (i_active0to0),
    .active_op1    (i_active1to0),

    // Slave Address/Control Signals
    .HSELM      (HSELS0),
    .HADDRM     (HADDRS0),
    .HAUSERM    (HAUSERS0),
    .HTRANSM    (HTRANSS0),
    .HWRITEM    (HWRITES0),
    .HSIZEM     (HSIZES0),
    .HBURSTM    (HBURSTS0),
    .HPROTM     (HPROTS0),
    .HMASTERM   (HMASTERS0),
    .HMASTLOCKM (HMASTLOCKS0),
    .HREADYMUXM (i_hready_mux_s0),
    .HWUSERM    (HWUSERS0),
    .HWDATAM    (HWDATAS0)

    );

  // Drive output with internal version
  assign HREADYMUXS0 = i_hready_mux_s0;


  // Output stage for MI1
  mybusmatrix5x7_op_S1 u_mybusmatrix5x7_op_s1_1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 2 Signals
    .sel_op2       (i_sel2to1),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAM2),
    .wuser_op2     (HWUSERM2),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to1),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAM3),
    .wuser_op3     (HWUSERM3),
    .held_tran_op3  (i_held_tran3),

    // Port 4 Signals
    .sel_op4       (i_sel4to1),
    .addr_op4      (i_addr4),
    .auser_op4     (i_auser4),
    .trans_op4     (i_trans4),
    .write_op4     (i_write4),
    .size_op4      (i_size4),
    .burst_op4     (i_burst4),
    .prot_op4      (i_prot4),
    .master_op4    (i_master4),
    .mastlock_op4  (i_mastlock4),
    .wdata_op4     (HWDATAM4),
    .wuser_op4     (HWUSERM4),
    .held_tran_op4  (i_held_tran4),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTS1),

    .active_op2    (i_active2to1),
    .active_op3    (i_active3to1),
    .active_op4    (i_active4to1),

    // Slave Address/Control Signals
    .HSELM      (HSELS1),
    .HADDRM     (HADDRS1),
    .HAUSERM    (HAUSERS1),
    .HTRANSM    (HTRANSS1),
    .HWRITEM    (HWRITES1),
    .HSIZEM     (HSIZES1),
    .HBURSTM    (HBURSTS1),
    .HPROTM     (HPROTS1),
    .HMASTERM   (HMASTERS1),
    .HMASTLOCKM (HMASTLOCKS1),
    .HREADYMUXM (i_hready_mux_s1),
    .HWUSERM    (HWUSERS1),
    .HWDATAM    (HWDATAS1)

    );

  // Drive output with internal version
  assign HREADYMUXS1 = i_hready_mux_s1;


  // Output stage for MI2
  mybusmatrix5x7_op_S2 u_mybusmatrix5x7_op_s2_2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 2 Signals
    .sel_op2       (i_sel2to2),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAM2),
    .wuser_op2     (HWUSERM2),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to2),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAM3),
    .wuser_op3     (HWUSERM3),
    .held_tran_op3  (i_held_tran3),

    // Port 4 Signals
    .sel_op4       (i_sel4to2),
    .addr_op4      (i_addr4),
    .auser_op4     (i_auser4),
    .trans_op4     (i_trans4),
    .write_op4     (i_write4),
    .size_op4      (i_size4),
    .burst_op4     (i_burst4),
    .prot_op4      (i_prot4),
    .master_op4    (i_master4),
    .mastlock_op4  (i_mastlock4),
    .wdata_op4     (HWDATAM4),
    .wuser_op4     (HWUSERM4),
    .held_tran_op4  (i_held_tran4),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTS2),

    .active_op2    (i_active2to2),
    .active_op3    (i_active3to2),
    .active_op4    (i_active4to2),

    // Slave Address/Control Signals
    .HSELM      (HSELS2),
    .HADDRM     (HADDRS2),
    .HAUSERM    (HAUSERS2),
    .HTRANSM    (HTRANSS2),
    .HWRITEM    (HWRITES2),
    .HSIZEM     (HSIZES2),
    .HBURSTM    (HBURSTS2),
    .HPROTM     (HPROTS2),
    .HMASTERM   (HMASTERS2),
    .HMASTLOCKM (HMASTLOCKS2),
    .HREADYMUXM (i_hready_mux_s2),
    .HWUSERM    (HWUSERS2),
    .HWDATAM    (HWDATAS2)

    );

  // Drive output with internal version
  assign HREADYMUXS2 = i_hready_mux_s2;


  // Output stage for MI3
  mybusmatrix5x7_op_S3 u_mybusmatrix5x7_op_s3_3 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 2 Signals
    .sel_op2       (i_sel2to3),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAM2),
    .wuser_op2     (HWUSERM2),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to3),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAM3),
    .wuser_op3     (HWUSERM3),
    .held_tran_op3  (i_held_tran3),

    // Port 4 Signals
    .sel_op4       (i_sel4to3),
    .addr_op4      (i_addr4),
    .auser_op4     (i_auser4),
    .trans_op4     (i_trans4),
    .write_op4     (i_write4),
    .size_op4      (i_size4),
    .burst_op4     (i_burst4),
    .prot_op4      (i_prot4),
    .master_op4    (i_master4),
    .mastlock_op4  (i_mastlock4),
    .wdata_op4     (HWDATAM4),
    .wuser_op4     (HWUSERM4),
    .held_tran_op4  (i_held_tran4),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTS3),

    .active_op2    (i_active2to3),
    .active_op3    (i_active3to3),
    .active_op4    (i_active4to3),

    // Slave Address/Control Signals
    .HSELM      (HSELS3),
    .HADDRM     (HADDRS3),
    .HAUSERM    (HAUSERS3),
    .HTRANSM    (HTRANSS3),
    .HWRITEM    (HWRITES3),
    .HSIZEM     (HSIZES3),
    .HBURSTM    (HBURSTS3),
    .HPROTM     (HPROTS3),
    .HMASTERM   (HMASTERS3),
    .HMASTLOCKM (HMASTLOCKS3),
    .HREADYMUXM (i_hready_mux_s3),
    .HWUSERM    (HWUSERS3),
    .HWDATAM    (HWDATAS3)

    );

  // Drive output with internal version
  assign HREADYMUXS3 = i_hready_mux_s3;


  // Output stage for MI4
  mybusmatrix5x7_op_S4 u_mybusmatrix5x7_op_s4_4 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 2 Signals
    .sel_op2       (i_sel2to4),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAM2),
    .wuser_op2     (HWUSERM2),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to4),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAM3),
    .wuser_op3     (HWUSERM3),
    .held_tran_op3  (i_held_tran3),

    // Port 4 Signals
    .sel_op4       (i_sel4to4),
    .addr_op4      (i_addr4),
    .auser_op4     (i_auser4),
    .trans_op4     (i_trans4),
    .write_op4     (i_write4),
    .size_op4      (i_size4),
    .burst_op4     (i_burst4),
    .prot_op4      (i_prot4),
    .master_op4    (i_master4),
    .mastlock_op4  (i_mastlock4),
    .wdata_op4     (HWDATAM4),
    .wuser_op4     (HWUSERM4),
    .held_tran_op4  (i_held_tran4),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTS4),

    .active_op2    (i_active2to4),
    .active_op3    (i_active3to4),
    .active_op4    (i_active4to4),

    // Slave Address/Control Signals
    .HSELM      (HSELS4),
    .HADDRM     (HADDRS4),
    .HAUSERM    (HAUSERS4),
    .HTRANSM    (HTRANSS4),
    .HWRITEM    (HWRITES4),
    .HSIZEM     (HSIZES4),
    .HBURSTM    (HBURSTS4),
    .HPROTM     (HPROTS4),
    .HMASTERM   (HMASTERS4),
    .HMASTLOCKM (HMASTLOCKS4),
    .HREADYMUXM (i_hready_mux_s4),
    .HWUSERM    (HWUSERS4),
    .HWDATAM    (HWDATAS4)

    );

  // Drive output with internal version
  assign HREADYMUXS4 = i_hready_mux_s4;


  // Output stage for MI5
  mybusmatrix5x7_op_S5 u_mybusmatrix5x7_op_s5_5 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 2 Signals
    .sel_op2       (i_sel2to5),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAM2),
    .wuser_op2     (HWUSERM2),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to5),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAM3),
    .wuser_op3     (HWUSERM3),
    .held_tran_op3  (i_held_tran3),

    // Port 4 Signals
    .sel_op4       (i_sel4to5),
    .addr_op4      (i_addr4),
    .auser_op4     (i_auser4),
    .trans_op4     (i_trans4),
    .write_op4     (i_write4),
    .size_op4      (i_size4),
    .burst_op4     (i_burst4),
    .prot_op4      (i_prot4),
    .master_op4    (i_master4),
    .mastlock_op4  (i_mastlock4),
    .wdata_op4     (HWDATAM4),
    .wuser_op4     (HWUSERM4),
    .held_tran_op4  (i_held_tran4),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTS5),

    .active_op2    (i_active2to5),
    .active_op3    (i_active3to5),
    .active_op4    (i_active4to5),

    // Slave Address/Control Signals
    .HSELM      (HSELS5),
    .HADDRM     (HADDRS5),
    .HAUSERM    (HAUSERS5),
    .HTRANSM    (HTRANSS5),
    .HWRITEM    (HWRITES5),
    .HSIZEM     (HSIZES5),
    .HBURSTM    (HBURSTS5),
    .HPROTM     (HPROTS5),
    .HMASTERM   (HMASTERS5),
    .HMASTLOCKM (HMASTLOCKS5),
    .HREADYMUXM (i_hready_mux_s5),
    .HWUSERM    (HWUSERS5),
    .HWDATAM    (HWDATAS5)

    );

  // Drive output with internal version
  assign HREADYMUXS5 = i_hready_mux_s5;


  // Output stage for MI6
  mybusmatrix5x7_op_S6 u_mybusmatrix5x7_op_s6_6 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 2 Signals
    .sel_op2       (i_sel2to6),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAM2),
    .wuser_op2     (HWUSERM2),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to6),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAM3),
    .wuser_op3     (HWUSERM3),
    .held_tran_op3  (i_held_tran3),

    // Port 4 Signals
    .sel_op4       (i_sel4to6),
    .addr_op4      (i_addr4),
    .auser_op4     (i_auser4),
    .trans_op4     (i_trans4),
    .write_op4     (i_write4),
    .size_op4      (i_size4),
    .burst_op4     (i_burst4),
    .prot_op4      (i_prot4),
    .master_op4    (i_master4),
    .mastlock_op4  (i_mastlock4),
    .wdata_op4     (HWDATAM4),
    .wuser_op4     (HWUSERM4),
    .held_tran_op4  (i_held_tran4),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTS6),

    .active_op2    (i_active2to6),
    .active_op3    (i_active3to6),
    .active_op4    (i_active4to6),

    // Slave Address/Control Signals
    .HSELM      (HSELS6),
    .HADDRM     (HADDRS6),
    .HAUSERM    (HAUSERS6),
    .HTRANSM    (HTRANSS6),
    .HWRITEM    (HWRITES6),
    .HSIZEM     (HSIZES6),
    .HBURSTM    (HBURSTS6),
    .HPROTM     (HPROTS6),
    .HMASTERM   (HMASTERS6),
    .HMASTLOCKM (HMASTLOCKS6),
    .HREADYMUXM (i_hready_mux_s6),
    .HWUSERM    (HWUSERS6),
    .HWDATAM    (HWDATAS6)

    );

  // Drive output with internal version
  assign HREADYMUXS6 = i_hready_mux_s6;


endmodule

// --================================= End ===================================--
