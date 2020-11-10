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
//  Abstract            : BusMatrixLite is a wrapper module that wraps around
//                        the BusMatrix module to give AHB Lite compliant
//                        slave and master interfaces.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module mybusmatrix5x7_lite (

    // Common AHB signals
    HCLK,
    HRESETn,

    // System Address Remap control
    REMAP,

    // Input port SI0 (inputs from master 0)
    HADDRM0,
    HTRANSM0,
    HWRITEM0,
    HSIZEM0,
    HBURSTM0,
    HPROTM0,
    HWDATAM0,
    HMASTLOCKM0,
    HAUSERM0,
    HWUSERM0,

    // Input port SI1 (inputs from master 1)
    HADDRM1,
    HTRANSM1,
    HWRITEM1,
    HSIZEM1,
    HBURSTM1,
    HPROTM1,
    HWDATAM1,
    HMASTLOCKM1,
    HAUSERM1,
    HWUSERM1,

    // Input port SI2 (inputs from master 2)
    HADDRM2,
    HTRANSM2,
    HWRITEM2,
    HSIZEM2,
    HBURSTM2,
    HPROTM2,
    HWDATAM2,
    HMASTLOCKM2,
    HAUSERM2,
    HWUSERM2,

    // Input port SI3 (inputs from master 3)
    HADDRM3,
    HTRANSM3,
    HWRITEM3,
    HSIZEM3,
    HBURSTM3,
    HPROTM3,
    HWDATAM3,
    HMASTLOCKM3,
    HAUSERM3,
    HWUSERM3,

    // Input port SI4 (inputs from master 4)
    HADDRM4,
    HTRANSM4,
    HWRITEM4,
    HSIZEM4,
    HBURSTM4,
    HPROTM4,
    HWDATAM4,
    HMASTLOCKM4,
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
    HWDATAS6,
    HMASTLOCKS6,
    HREADYMUXS6,
    HAUSERS6,
    HWUSERS6,

    // Input port SI0 (outputs to master 0)
    HRDATAM0,
    HREADYM0,
    HRESPM0,
    HRUSERM0,

    // Input port SI1 (outputs to master 1)
    HRDATAM1,
    HREADYM1,
    HRESPM1,
    HRUSERM1,

    // Input port SI2 (outputs to master 2)
    HRDATAM2,
    HREADYM2,
    HRESPM2,
    HRUSERM2,

    // Input port SI3 (outputs to master 3)
    HRDATAM3,
    HREADYM3,
    HRESPM3,
    HRUSERM3,

    // Input port SI4 (outputs to master 4)
    HRDATAM4,
    HREADYM4,
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

    // System Address Remap control
    input   [3:0] REMAP;           // System Address REMAP control

    // Input port SI0 (inputs from master 0)
    input  [31:0] HADDRM0;         // Address bus
    input   [1:0] HTRANSM0;        // Transfer type
    input         HWRITEM0;        // Transfer direction
    input   [2:0] HSIZEM0;         // Transfer size
    input   [2:0] HBURSTM0;        // Burst type
    input   [3:0] HPROTM0;         // Protection control
    input  [31:0] HWDATAM0;        // Write data
    input         HMASTLOCKM0;     // Locked Sequence
    input  [31:0] HAUSERM0;        // Address USER signals
    input  [31:0] HWUSERM0;        // Write-data USER signals

    // Input port SI1 (inputs from master 1)
    input  [31:0] HADDRM1;         // Address bus
    input   [1:0] HTRANSM1;        // Transfer type
    input         HWRITEM1;        // Transfer direction
    input   [2:0] HSIZEM1;         // Transfer size
    input   [2:0] HBURSTM1;        // Burst type
    input   [3:0] HPROTM1;         // Protection control
    input  [31:0] HWDATAM1;        // Write data
    input         HMASTLOCKM1;     // Locked Sequence
    input  [31:0] HAUSERM1;        // Address USER signals
    input  [31:0] HWUSERM1;        // Write-data USER signals

    // Input port SI2 (inputs from master 2)
    input  [31:0] HADDRM2;         // Address bus
    input   [1:0] HTRANSM2;        // Transfer type
    input         HWRITEM2;        // Transfer direction
    input   [2:0] HSIZEM2;         // Transfer size
    input   [2:0] HBURSTM2;        // Burst type
    input   [3:0] HPROTM2;         // Protection control
    input  [31:0] HWDATAM2;        // Write data
    input         HMASTLOCKM2;     // Locked Sequence
    input  [31:0] HAUSERM2;        // Address USER signals
    input  [31:0] HWUSERM2;        // Write-data USER signals

    // Input port SI3 (inputs from master 3)
    input  [31:0] HADDRM3;         // Address bus
    input   [1:0] HTRANSM3;        // Transfer type
    input         HWRITEM3;        // Transfer direction
    input   [2:0] HSIZEM3;         // Transfer size
    input   [2:0] HBURSTM3;        // Burst type
    input   [3:0] HPROTM3;         // Protection control
    input  [31:0] HWDATAM3;        // Write data
    input         HMASTLOCKM3;     // Locked Sequence
    input  [31:0] HAUSERM3;        // Address USER signals
    input  [31:0] HWUSERM3;        // Write-data USER signals

    // Input port SI4 (inputs from master 4)
    input  [31:0] HADDRM4;         // Address bus
    input   [1:0] HTRANSM4;        // Transfer type
    input         HWRITEM4;        // Transfer direction
    input   [2:0] HSIZEM4;         // Transfer size
    input   [2:0] HBURSTM4;        // Burst type
    input   [3:0] HPROTM4;         // Protection control
    input  [31:0] HWDATAM4;        // Write data
    input         HMASTLOCKM4;     // Locked Sequence
    input  [31:0] HAUSERM4;        // Address USER signals
    input  [31:0] HWUSERM4;        // Write-data USER signals

    // Output port MI0 (inputs from slave 0)
    input  [31:0] HRDATAS0;        // Read data bus
    input         HREADYOUTS0;     // HREADY feedback
    input         HRESPS0;         // Transfer response
    input  [31:0] HRUSERS0;        // Read-data USER signals

    // Output port MI1 (inputs from slave 1)
    input  [31:0] HRDATAS1;        // Read data bus
    input         HREADYOUTS1;     // HREADY feedback
    input         HRESPS1;         // Transfer response
    input  [31:0] HRUSERS1;        // Read-data USER signals

    // Output port MI2 (inputs from slave 2)
    input  [31:0] HRDATAS2;        // Read data bus
    input         HREADYOUTS2;     // HREADY feedback
    input         HRESPS2;         // Transfer response
    input  [31:0] HRUSERS2;        // Read-data USER signals

    // Output port MI3 (inputs from slave 3)
    input  [31:0] HRDATAS3;        // Read data bus
    input         HREADYOUTS3;     // HREADY feedback
    input         HRESPS3;         // Transfer response
    input  [31:0] HRUSERS3;        // Read-data USER signals

    // Output port MI4 (inputs from slave 4)
    input  [31:0] HRDATAS4;        // Read data bus
    input         HREADYOUTS4;     // HREADY feedback
    input         HRESPS4;         // Transfer response
    input  [31:0] HRUSERS4;        // Read-data USER signals

    // Output port MI5 (inputs from slave 5)
    input  [31:0] HRDATAS5;        // Read data bus
    input         HREADYOUTS5;     // HREADY feedback
    input         HRESPS5;         // Transfer response
    input  [31:0] HRUSERS5;        // Read-data USER signals

    // Output port MI6 (inputs from slave 6)
    input  [31:0] HRDATAS6;        // Read data bus
    input         HREADYOUTS6;     // HREADY feedback
    input         HRESPS6;         // Transfer response
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
    output [31:0] HWDATAS6;        // Write data
    output        HMASTLOCKS6;     // Locked Sequence
    output        HREADYMUXS6;     // Transfer done
    output [31:0] HAUSERS6;        // Address USER signals
    output [31:0] HWUSERS6;        // Write-data USER signals

    // Input port SI0 (outputs to master 0)
    output [31:0] HRDATAM0;        // Read data bus
    output        HREADYM0;     // HREADY feedback
    output        HRESPM0;         // Transfer response
    output [31:0] HRUSERM0;        // Read-data USER signals

    // Input port SI1 (outputs to master 1)
    output [31:0] HRDATAM1;        // Read data bus
    output        HREADYM1;     // HREADY feedback
    output        HRESPM1;         // Transfer response
    output [31:0] HRUSERM1;        // Read-data USER signals

    // Input port SI2 (outputs to master 2)
    output [31:0] HRDATAM2;        // Read data bus
    output        HREADYM2;     // HREADY feedback
    output        HRESPM2;         // Transfer response
    output [31:0] HRUSERM2;        // Read-data USER signals

    // Input port SI3 (outputs to master 3)
    output [31:0] HRDATAM3;        // Read data bus
    output        HREADYM3;     // HREADY feedback
    output        HRESPM3;         // Transfer response
    output [31:0] HRUSERM3;        // Read-data USER signals

    // Input port SI4 (outputs to master 4)
    output [31:0] HRDATAM4;        // Read data bus
    output        HREADYM4;     // HREADY feedback
    output        HRESPM4;         // Transfer response
    output [31:0] HRUSERM4;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    output        SCANOUTHCLK;     // Scan Chain Output

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    wire         HCLK;            // AHB System Clock
    wire         HRESETn;         // AHB System Reset

    // System Address Remap control
    wire   [3:0] REMAP;           // System REMAP signal

    // Input Port SI0
    wire  [31:0] HADDRM0;         // Address bus
    wire   [1:0] HTRANSM0;        // Transfer type
    wire         HWRITEM0;        // Transfer direction
    wire   [2:0] HSIZEM0;         // Transfer size
    wire   [2:0] HBURSTM0;        // Burst type
    wire   [3:0] HPROTM0;         // Protection control
    wire  [31:0] HWDATAM0;        // Write data
    wire         HMASTLOCKM0;     // Locked Sequence

    wire  [31:0] HRDATAM0;        // Read data bus
    wire         HREADYM0;     // HREADY feedback
    wire         HRESPM0;         // Transfer response
    wire  [31:0] HAUSERM0;        // Address USER signals
    wire  [31:0] HWUSERM0;        // Write-data USER signals
    wire  [31:0] HRUSERM0;        // Read-data USER signals

    // Input Port SI1
    wire  [31:0] HADDRM1;         // Address bus
    wire   [1:0] HTRANSM1;        // Transfer type
    wire         HWRITEM1;        // Transfer direction
    wire   [2:0] HSIZEM1;         // Transfer size
    wire   [2:0] HBURSTM1;        // Burst type
    wire   [3:0] HPROTM1;         // Protection control
    wire  [31:0] HWDATAM1;        // Write data
    wire         HMASTLOCKM1;     // Locked Sequence

    wire  [31:0] HRDATAM1;        // Read data bus
    wire         HREADYM1;     // HREADY feedback
    wire         HRESPM1;         // Transfer response
    wire  [31:0] HAUSERM1;        // Address USER signals
    wire  [31:0] HWUSERM1;        // Write-data USER signals
    wire  [31:0] HRUSERM1;        // Read-data USER signals

    // Input Port SI2
    wire  [31:0] HADDRM2;         // Address bus
    wire   [1:0] HTRANSM2;        // Transfer type
    wire         HWRITEM2;        // Transfer direction
    wire   [2:0] HSIZEM2;         // Transfer size
    wire   [2:0] HBURSTM2;        // Burst type
    wire   [3:0] HPROTM2;         // Protection control
    wire  [31:0] HWDATAM2;        // Write data
    wire         HMASTLOCKM2;     // Locked Sequence

    wire  [31:0] HRDATAM2;        // Read data bus
    wire         HREADYM2;     // HREADY feedback
    wire         HRESPM2;         // Transfer response
    wire  [31:0] HAUSERM2;        // Address USER signals
    wire  [31:0] HWUSERM2;        // Write-data USER signals
    wire  [31:0] HRUSERM2;        // Read-data USER signals

    // Input Port SI3
    wire  [31:0] HADDRM3;         // Address bus
    wire   [1:0] HTRANSM3;        // Transfer type
    wire         HWRITEM3;        // Transfer direction
    wire   [2:0] HSIZEM3;         // Transfer size
    wire   [2:0] HBURSTM3;        // Burst type
    wire   [3:0] HPROTM3;         // Protection control
    wire  [31:0] HWDATAM3;        // Write data
    wire         HMASTLOCKM3;     // Locked Sequence

    wire  [31:0] HRDATAM3;        // Read data bus
    wire         HREADYM3;     // HREADY feedback
    wire         HRESPM3;         // Transfer response
    wire  [31:0] HAUSERM3;        // Address USER signals
    wire  [31:0] HWUSERM3;        // Write-data USER signals
    wire  [31:0] HRUSERM3;        // Read-data USER signals

    // Input Port SI4
    wire  [31:0] HADDRM4;         // Address bus
    wire   [1:0] HTRANSM4;        // Transfer type
    wire         HWRITEM4;        // Transfer direction
    wire   [2:0] HSIZEM4;         // Transfer size
    wire   [2:0] HBURSTM4;        // Burst type
    wire   [3:0] HPROTM4;         // Protection control
    wire  [31:0] HWDATAM4;        // Write data
    wire         HMASTLOCKM4;     // Locked Sequence

    wire  [31:0] HRDATAM4;        // Read data bus
    wire         HREADYM4;     // HREADY feedback
    wire         HRESPM4;         // Transfer response
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
    wire  [31:0] HWDATAS0;        // Write data
    wire         HMASTLOCKS0;     // Locked Sequence
    wire         HREADYMUXS0;     // Transfer done

    wire  [31:0] HRDATAS0;        // Read data bus
    wire         HREADYOUTS0;     // HREADY feedback
    wire         HRESPS0;         // Transfer response
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
    wire  [31:0] HWDATAS1;        // Write data
    wire         HMASTLOCKS1;     // Locked Sequence
    wire         HREADYMUXS1;     // Transfer done

    wire  [31:0] HRDATAS1;        // Read data bus
    wire         HREADYOUTS1;     // HREADY feedback
    wire         HRESPS1;         // Transfer response
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
    wire  [31:0] HWDATAS2;        // Write data
    wire         HMASTLOCKS2;     // Locked Sequence
    wire         HREADYMUXS2;     // Transfer done

    wire  [31:0] HRDATAS2;        // Read data bus
    wire         HREADYOUTS2;     // HREADY feedback
    wire         HRESPS2;         // Transfer response
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
    wire  [31:0] HWDATAS3;        // Write data
    wire         HMASTLOCKS3;     // Locked Sequence
    wire         HREADYMUXS3;     // Transfer done

    wire  [31:0] HRDATAS3;        // Read data bus
    wire         HREADYOUTS3;     // HREADY feedback
    wire         HRESPS3;         // Transfer response
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
    wire  [31:0] HWDATAS4;        // Write data
    wire         HMASTLOCKS4;     // Locked Sequence
    wire         HREADYMUXS4;     // Transfer done

    wire  [31:0] HRDATAS4;        // Read data bus
    wire         HREADYOUTS4;     // HREADY feedback
    wire         HRESPS4;         // Transfer response
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
    wire  [31:0] HWDATAS5;        // Write data
    wire         HMASTLOCKS5;     // Locked Sequence
    wire         HREADYMUXS5;     // Transfer done

    wire  [31:0] HRDATAS5;        // Read data bus
    wire         HREADYOUTS5;     // HREADY feedback
    wire         HRESPS5;         // Transfer response
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
    wire  [31:0] HWDATAS6;        // Write data
    wire         HMASTLOCKS6;     // Locked Sequence
    wire         HREADYMUXS6;     // Transfer done

    wire  [31:0] HRDATAS6;        // Read data bus
    wire         HREADYOUTS6;     // HREADY feedback
    wire         HRESPS6;         // Transfer response
    wire  [31:0] HAUSERS6;        // Address USER signals
    wire  [31:0] HWUSERS6;        // Write-data USER signals
    wire  [31:0] HRUSERS6;        // Read-data USER signals


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
    wire   [3:0] tie_hi_4;
    wire         tie_hi;
    wire         tie_low;
    wire   [1:0] i_hrespM0;
    wire   [1:0] i_hrespM1;
    wire   [1:0] i_hrespM2;
    wire   [1:0] i_hrespM3;
    wire   [1:0] i_hrespM4;

    wire   [3:0]        i_hmasterS0;
    wire   [1:0] i_hrespS0;
    wire   [3:0]        i_hmasterS1;
    wire   [1:0] i_hrespS1;
    wire   [3:0]        i_hmasterS2;
    wire   [1:0] i_hrespS2;
    wire   [3:0]        i_hmasterS3;
    wire   [1:0] i_hrespS3;
    wire   [3:0]        i_hmasterS4;
    wire   [1:0] i_hrespS4;
    wire   [3:0]        i_hmasterS5;
    wire   [1:0] i_hrespS5;
    wire   [3:0]        i_hmasterS6;
    wire   [1:0] i_hrespS6;

// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------

    assign tie_hi   = 1'b1;
    assign tie_hi_4 = 4'b1111;
    assign tie_low  = 1'b0;


    assign HRESPM0  = i_hrespM0[0];

    assign HRESPM1  = i_hrespM1[0];

    assign HRESPM2  = i_hrespM2[0];

    assign HRESPM3  = i_hrespM3[0];

    assign HRESPM4  = i_hrespM4[0];

    assign i_hrespS0 = {tie_low, HRESPS0};
    assign i_hrespS1 = {tie_low, HRESPS1};
    assign i_hrespS2 = {tie_low, HRESPS2};
    assign i_hrespS3 = {tie_low, HRESPS3};
    assign i_hrespS4 = {tie_low, HRESPS4};
    assign i_hrespS5 = {tie_low, HRESPS5};
    assign i_hrespS6 = {tie_low, HRESPS6};

// BusMatrix instance
  mybusmatrix5x7 umybusmatrix5x7 (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .REMAP      (REMAP),

    // Input port SI0 signals
    .HSELM0       (tie_hi),
    .HADDRM0      (HADDRM0),
    .HTRANSM0     (HTRANSM0),
    .HWRITEM0     (HWRITEM0),
    .HSIZEM0      (HSIZEM0),
    .HBURSTM0     (HBURSTM0),
    .HPROTM0      (HPROTM0),
    .HWDATAM0     (HWDATAM0),
    .HMASTLOCKM0  (HMASTLOCKM0),
    .HMASTERM0    (tie_hi_4),
    .HREADYM0     (HREADYM0),
    .HAUSERM0     (HAUSERM0),
    .HWUSERM0     (HWUSERM0),
    .HRDATAM0     (HRDATAM0),
    .HREADYOUTM0  (HREADYM0),
    .HRESPM0      (i_hrespM0),
    .HRUSERM0     (HRUSERM0),

    // Input port SI1 signals
    .HSELM1       (tie_hi),
    .HADDRM1      (HADDRM1),
    .HTRANSM1     (HTRANSM1),
    .HWRITEM1     (HWRITEM1),
    .HSIZEM1      (HSIZEM1),
    .HBURSTM1     (HBURSTM1),
    .HPROTM1      (HPROTM1),
    .HWDATAM1     (HWDATAM1),
    .HMASTLOCKM1  (HMASTLOCKM1),
    .HMASTERM1    (tie_hi_4),
    .HREADYM1     (HREADYM1),
    .HAUSERM1     (HAUSERM1),
    .HWUSERM1     (HWUSERM1),
    .HRDATAM1     (HRDATAM1),
    .HREADYOUTM1  (HREADYM1),
    .HRESPM1      (i_hrespM1),
    .HRUSERM1     (HRUSERM1),

    // Input port SI2 signals
    .HSELM2       (tie_hi),
    .HADDRM2      (HADDRM2),
    .HTRANSM2     (HTRANSM2),
    .HWRITEM2     (HWRITEM2),
    .HSIZEM2      (HSIZEM2),
    .HBURSTM2     (HBURSTM2),
    .HPROTM2      (HPROTM2),
    .HWDATAM2     (HWDATAM2),
    .HMASTLOCKM2  (HMASTLOCKM2),
    .HMASTERM2    (tie_hi_4),
    .HREADYM2     (HREADYM2),
    .HAUSERM2     (HAUSERM2),
    .HWUSERM2     (HWUSERM2),
    .HRDATAM2     (HRDATAM2),
    .HREADYOUTM2  (HREADYM2),
    .HRESPM2      (i_hrespM2),
    .HRUSERM2     (HRUSERM2),

    // Input port SI3 signals
    .HSELM3       (tie_hi),
    .HADDRM3      (HADDRM3),
    .HTRANSM3     (HTRANSM3),
    .HWRITEM3     (HWRITEM3),
    .HSIZEM3      (HSIZEM3),
    .HBURSTM3     (HBURSTM3),
    .HPROTM3      (HPROTM3),
    .HWDATAM3     (HWDATAM3),
    .HMASTLOCKM3  (HMASTLOCKM3),
    .HMASTERM3    (tie_hi_4),
    .HREADYM3     (HREADYM3),
    .HAUSERM3     (HAUSERM3),
    .HWUSERM3     (HWUSERM3),
    .HRDATAM3     (HRDATAM3),
    .HREADYOUTM3  (HREADYM3),
    .HRESPM3      (i_hrespM3),
    .HRUSERM3     (HRUSERM3),

    // Input port SI4 signals
    .HSELM4       (tie_hi),
    .HADDRM4      (HADDRM4),
    .HTRANSM4     (HTRANSM4),
    .HWRITEM4     (HWRITEM4),
    .HSIZEM4      (HSIZEM4),
    .HBURSTM4     (HBURSTM4),
    .HPROTM4      (HPROTM4),
    .HWDATAM4     (HWDATAM4),
    .HMASTLOCKM4  (HMASTLOCKM4),
    .HMASTERM4    (tie_hi_4),
    .HREADYM4     (HREADYM4),
    .HAUSERM4     (HAUSERM4),
    .HWUSERM4     (HWUSERM4),
    .HRDATAM4     (HRDATAM4),
    .HREADYOUTM4  (HREADYM4),
    .HRESPM4      (i_hrespM4),
    .HRUSERM4     (HRUSERM4),


    // Output port MI0 signals
    .HSELS0       (HSELS0),
    .HADDRS0      (HADDRS0),
    .HTRANSS0     (HTRANSS0),
    .HWRITES0     (HWRITES0),
    .HSIZES0      (HSIZES0),
    .HBURSTS0     (HBURSTS0),
    .HPROTS0      (HPROTS0),
    .HWDATAS0     (HWDATAS0),
    .HMASTERS0    (i_hmasterS0),
    .HMASTLOCKS0  (HMASTLOCKS0),
    .HREADYMUXS0  (HREADYMUXS0),
    .HAUSERS0     (HAUSERS0),
    .HWUSERS0     (HWUSERS0),
    .HRDATAS0     (HRDATAS0),
    .HREADYOUTS0  (HREADYOUTS0),
    .HRESPS0      (i_hrespS0),
    .HRUSERS0     (HRUSERS0),

    // Output port MI1 signals
    .HSELS1       (HSELS1),
    .HADDRS1      (HADDRS1),
    .HTRANSS1     (HTRANSS1),
    .HWRITES1     (HWRITES1),
    .HSIZES1      (HSIZES1),
    .HBURSTS1     (HBURSTS1),
    .HPROTS1      (HPROTS1),
    .HWDATAS1     (HWDATAS1),
    .HMASTERS1    (i_hmasterS1),
    .HMASTLOCKS1  (HMASTLOCKS1),
    .HREADYMUXS1  (HREADYMUXS1),
    .HAUSERS1     (HAUSERS1),
    .HWUSERS1     (HWUSERS1),
    .HRDATAS1     (HRDATAS1),
    .HREADYOUTS1  (HREADYOUTS1),
    .HRESPS1      (i_hrespS1),
    .HRUSERS1     (HRUSERS1),

    // Output port MI2 signals
    .HSELS2       (HSELS2),
    .HADDRS2      (HADDRS2),
    .HTRANSS2     (HTRANSS2),
    .HWRITES2     (HWRITES2),
    .HSIZES2      (HSIZES2),
    .HBURSTS2     (HBURSTS2),
    .HPROTS2      (HPROTS2),
    .HWDATAS2     (HWDATAS2),
    .HMASTERS2    (i_hmasterS2),
    .HMASTLOCKS2  (HMASTLOCKS2),
    .HREADYMUXS2  (HREADYMUXS2),
    .HAUSERS2     (HAUSERS2),
    .HWUSERS2     (HWUSERS2),
    .HRDATAS2     (HRDATAS2),
    .HREADYOUTS2  (HREADYOUTS2),
    .HRESPS2      (i_hrespS2),
    .HRUSERS2     (HRUSERS2),

    // Output port MI3 signals
    .HSELS3       (HSELS3),
    .HADDRS3      (HADDRS3),
    .HTRANSS3     (HTRANSS3),
    .HWRITES3     (HWRITES3),
    .HSIZES3      (HSIZES3),
    .HBURSTS3     (HBURSTS3),
    .HPROTS3      (HPROTS3),
    .HWDATAS3     (HWDATAS3),
    .HMASTERS3    (i_hmasterS3),
    .HMASTLOCKS3  (HMASTLOCKS3),
    .HREADYMUXS3  (HREADYMUXS3),
    .HAUSERS3     (HAUSERS3),
    .HWUSERS3     (HWUSERS3),
    .HRDATAS3     (HRDATAS3),
    .HREADYOUTS3  (HREADYOUTS3),
    .HRESPS3      (i_hrespS3),
    .HRUSERS3     (HRUSERS3),

    // Output port MI4 signals
    .HSELS4       (HSELS4),
    .HADDRS4      (HADDRS4),
    .HTRANSS4     (HTRANSS4),
    .HWRITES4     (HWRITES4),
    .HSIZES4      (HSIZES4),
    .HBURSTS4     (HBURSTS4),
    .HPROTS4      (HPROTS4),
    .HWDATAS4     (HWDATAS4),
    .HMASTERS4    (i_hmasterS4),
    .HMASTLOCKS4  (HMASTLOCKS4),
    .HREADYMUXS4  (HREADYMUXS4),
    .HAUSERS4     (HAUSERS4),
    .HWUSERS4     (HWUSERS4),
    .HRDATAS4     (HRDATAS4),
    .HREADYOUTS4  (HREADYOUTS4),
    .HRESPS4      (i_hrespS4),
    .HRUSERS4     (HRUSERS4),

    // Output port MI5 signals
    .HSELS5       (HSELS5),
    .HADDRS5      (HADDRS5),
    .HTRANSS5     (HTRANSS5),
    .HWRITES5     (HWRITES5),
    .HSIZES5      (HSIZES5),
    .HBURSTS5     (HBURSTS5),
    .HPROTS5      (HPROTS5),
    .HWDATAS5     (HWDATAS5),
    .HMASTERS5    (i_hmasterS5),
    .HMASTLOCKS5  (HMASTLOCKS5),
    .HREADYMUXS5  (HREADYMUXS5),
    .HAUSERS5     (HAUSERS5),
    .HWUSERS5     (HWUSERS5),
    .HRDATAS5     (HRDATAS5),
    .HREADYOUTS5  (HREADYOUTS5),
    .HRESPS5      (i_hrespS5),
    .HRUSERS5     (HRUSERS5),

    // Output port MI6 signals
    .HSELS6       (HSELS6),
    .HADDRS6      (HADDRS6),
    .HTRANSS6     (HTRANSS6),
    .HWRITES6     (HWRITES6),
    .HSIZES6      (HSIZES6),
    .HBURSTS6     (HBURSTS6),
    .HPROTS6      (HPROTS6),
    .HWDATAS6     (HWDATAS6),
    .HMASTERS6    (i_hmasterS6),
    .HMASTLOCKS6  (HMASTLOCKS6),
    .HREADYMUXS6  (HREADYMUXS6),
    .HAUSERS6     (HAUSERS6),
    .HWUSERS6     (HWUSERS6),
    .HRDATAS6     (HRDATAS6),
    .HREADYOUTS6  (HREADYOUTS6),
    .HRESPS6      (i_hrespS6),
    .HRUSERS6     (HRUSERS6),


    // Scan test dummy signals; not connected until scan insertion
    .SCANENABLE            (SCANENABLE),
    .SCANINHCLK            (SCANINHCLK),
    .SCANOUTHCLK           (SCANOUTHCLK)
  );


endmodule
