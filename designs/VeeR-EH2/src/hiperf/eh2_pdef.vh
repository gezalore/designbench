typedef struct packed {
    bit [4:0]      ATOMIC_ENABLE;
    bit [7:0]      BHT_ADDR_HI;
    bit [5:0]      BHT_ADDR_LO;
    bit [15:0]     BHT_ARRAY_DEPTH;
    bit [4:0]      BHT_GHR_HASH_1;
    bit [7:0]      BHT_GHR_SIZE;
    bit [16:0]     BHT_SIZE;
    bit [4:0]      BITMANIP_ZBA;
    bit [4:0]      BITMANIP_ZBB;
    bit [4:0]      BITMANIP_ZBC;
    bit [4:0]      BITMANIP_ZBE;
    bit [4:0]      BITMANIP_ZBF;
    bit [4:0]      BITMANIP_ZBP;
    bit [4:0]      BITMANIP_ZBR;
    bit [4:0]      BITMANIP_ZBS;
    bit [8:0]      BTB_ADDR_HI;
    bit [6:0]      BTB_ADDR_LO;
    bit [14:0]     BTB_ARRAY_DEPTH;
    bit [4:0]      BTB_BTAG_FOLD;
    bit [9:0]      BTB_BTAG_SIZE;
    bit [4:0]      BTB_BYPASS_ENABLE;
    bit [4:0]      BTB_FOLD2_INDEX_HASH;
    bit [4:0]      BTB_FULLYA;
    bit [8:0]      BTB_INDEX1_HI;
    bit [8:0]      BTB_INDEX1_LO;
    bit [8:0]      BTB_INDEX2_HI;
    bit [8:0]      BTB_INDEX2_LO;
    bit [8:0]      BTB_INDEX3_HI;
    bit [8:0]      BTB_INDEX3_LO;
    bit [7:0]      BTB_NUM_BYPASS;
    bit [7:0]      BTB_NUM_BYPASS_WIDTH;
    bit [16:0]     BTB_SIZE;
    bit [8:0]      BTB_TOFFSET_SIZE;
    bit [4:0]      BTB_USE_SRAM;
    bit            BUILD_AHB_LITE;
    bit [4:0]      BUILD_AXI4;
    bit [4:0]      BUILD_AXI_NATIVE;
    bit [5:0]      BUS_PRTY_DEFAULT;
    bit [35:0]     DATA_ACCESS_ADDR0;
    bit [35:0]     DATA_ACCESS_ADDR1;
    bit [35:0]     DATA_ACCESS_ADDR2;
    bit [35:0]     DATA_ACCESS_ADDR3;
    bit [35:0]     DATA_ACCESS_ADDR4;
    bit [35:0]     DATA_ACCESS_ADDR5;
    bit [35:0]     DATA_ACCESS_ADDR6;
    bit [35:0]     DATA_ACCESS_ADDR7;
    bit [4:0]      DATA_ACCESS_ENABLE0;
    bit [4:0]      DATA_ACCESS_ENABLE1;
    bit [4:0]      DATA_ACCESS_ENABLE2;
    bit [4:0]      DATA_ACCESS_ENABLE3;
    bit [4:0]      DATA_ACCESS_ENABLE4;
    bit [4:0]      DATA_ACCESS_ENABLE5;
    bit [4:0]      DATA_ACCESS_ENABLE6;
    bit [4:0]      DATA_ACCESS_ENABLE7;
    bit [35:0]     DATA_ACCESS_MASK0;
    bit [35:0]     DATA_ACCESS_MASK1;
    bit [35:0]     DATA_ACCESS_MASK2;
    bit [35:0]     DATA_ACCESS_MASK3;
    bit [35:0]     DATA_ACCESS_MASK4;
    bit [35:0]     DATA_ACCESS_MASK5;
    bit [35:0]     DATA_ACCESS_MASK6;
    bit [35:0]     DATA_ACCESS_MASK7;
    bit [6:0]      DCCM_BANK_BITS;
    bit [8:0]      DCCM_BITS;
    bit [6:0]      DCCM_BYTE_WIDTH;
    bit [9:0]      DCCM_DATA_WIDTH;
    bit [6:0]      DCCM_ECC_WIDTH;
    bit [4:0]      DCCM_ENABLE;
    bit [9:0]      DCCM_FDATA_WIDTH;
    bit [7:0]      DCCM_INDEX_BITS;
    bit [8:0]      DCCM_NUM_BANKS;
    bit [7:0]      DCCM_REGION;
    bit [35:0]     DCCM_SADR;
    bit [13:0]     DCCM_SIZE;
    bit [5:0]      DCCM_WIDTH_BITS;
    bit [6:0]      DIV_BIT;
    bit [4:0]      DIV_NEW;
    bit [6:0]      DMA_BUF_DEPTH;
    bit [8:0]      DMA_BUS_ID;
    bit [5:0]      DMA_BUS_PRTY;
    bit [7:0]      DMA_BUS_TAG;
    bit [4:0]      FAST_INTERRUPT_REDIRECT;
    bit [4:0]      ICACHE_2BANKS;
    bit [6:0]      ICACHE_BANK_BITS;
    bit [6:0]      ICACHE_BANK_HI;
    bit [5:0]      ICACHE_BANK_LO;
    bit [7:0]      ICACHE_BANK_WIDTH;
    bit [6:0]      ICACHE_BANKS_WAY;
    bit [7:0]      ICACHE_BEAT_ADDR_HI;
    bit [7:0]      ICACHE_BEAT_BITS;
    bit [4:0]      ICACHE_BYPASS_ENABLE;
    bit [17:0]     ICACHE_DATA_DEPTH;
    bit [6:0]      ICACHE_DATA_INDEX_LO;
    bit [10:0]     ICACHE_DATA_WIDTH;
    bit [4:0]      ICACHE_ECC;
    bit [4:0]      ICACHE_ENABLE;
    bit [10:0]     ICACHE_FDATA_WIDTH;
    bit [8:0]      ICACHE_INDEX_HI;
    bit [10:0]     ICACHE_LN_SZ;
    bit [7:0]      ICACHE_NUM_BEATS;
    bit [7:0]      ICACHE_NUM_BYPASS;
    bit [7:0]      ICACHE_NUM_BYPASS_WIDTH;
    bit [6:0]      ICACHE_NUM_WAYS;
    bit [4:0]      ICACHE_ONLY;
    bit [7:0]      ICACHE_SCND_LAST;
    bit [12:0]     ICACHE_SIZE;
    bit [6:0]      ICACHE_STATUS_BITS;
    bit [4:0]      ICACHE_TAG_BYPASS_ENABLE;
    bit [16:0]     ICACHE_TAG_DEPTH;
    bit [6:0]      ICACHE_TAG_INDEX_LO;
    bit [8:0]      ICACHE_TAG_LO;
    bit [7:0]      ICACHE_TAG_NUM_BYPASS;
    bit [7:0]      ICACHE_TAG_NUM_BYPASS_WIDTH;
    bit [4:0]      ICACHE_WAYPACK;
    bit [6:0]      ICCM_BANK_BITS;
    bit [8:0]      ICCM_BANK_HI;
    bit [8:0]      ICCM_BANK_INDEX_LO;
    bit [8:0]      ICCM_BITS;
    bit [4:0]      ICCM_ENABLE;
    bit [4:0]      ICCM_ICACHE;
    bit [7:0]      ICCM_INDEX_BITS;
    bit [8:0]      ICCM_NUM_BANKS;
    bit [4:0]      ICCM_ONLY;
    bit [7:0]      ICCM_REGION;
    bit [35:0]     ICCM_SADR;
    bit [13:0]     ICCM_SIZE;
    bit [4:0]      IFU_BUS_ID;
    bit [5:0]      IFU_BUS_PRTY;
    bit [7:0]      IFU_BUS_TAG;
    bit [35:0]     INST_ACCESS_ADDR0;
    bit [35:0]     INST_ACCESS_ADDR1;
    bit [35:0]     INST_ACCESS_ADDR2;
    bit [35:0]     INST_ACCESS_ADDR3;
    bit [35:0]     INST_ACCESS_ADDR4;
    bit [35:0]     INST_ACCESS_ADDR5;
    bit [35:0]     INST_ACCESS_ADDR6;
    bit [35:0]     INST_ACCESS_ADDR7;
    bit [4:0]      INST_ACCESS_ENABLE0;
    bit [4:0]      INST_ACCESS_ENABLE1;
    bit [4:0]      INST_ACCESS_ENABLE2;
    bit [4:0]      INST_ACCESS_ENABLE3;
    bit [4:0]      INST_ACCESS_ENABLE4;
    bit [4:0]      INST_ACCESS_ENABLE5;
    bit [4:0]      INST_ACCESS_ENABLE6;
    bit [4:0]      INST_ACCESS_ENABLE7;
    bit [35:0]     INST_ACCESS_MASK0;
    bit [35:0]     INST_ACCESS_MASK1;
    bit [35:0]     INST_ACCESS_MASK2;
    bit [35:0]     INST_ACCESS_MASK3;
    bit [35:0]     INST_ACCESS_MASK4;
    bit [35:0]     INST_ACCESS_MASK5;
    bit [35:0]     INST_ACCESS_MASK6;
    bit [35:0]     INST_ACCESS_MASK7;
    bit [4:0]      LOAD_TO_USE_BUS_PLUS1;
    bit [4:0]      LOAD_TO_USE_PLUS1;
    bit [4:0]      LSU_BUS_ID;
    bit [5:0]      LSU_BUS_PRTY;
    bit [7:0]      LSU_BUS_TAG;
    bit [8:0]      LSU_NUM_NBLOAD;
    bit [6:0]      LSU_NUM_NBLOAD_WIDTH;
    bit [8:0]      LSU_SB_BITS;
    bit [7:0]      LSU_STBUF_DEPTH;
    bit [4:0]      NO_ICCM_NO_ICACHE;
    bit [4:0]      NO_SECONDARY_ALU;
    bit [5:0]      NUM_THREADS;
    bit [4:0]      PIC_2CYCLE;
    bit [35:0]     PIC_BASE_ADDR;
    bit [8:0]      PIC_BITS;
    bit [7:0]      PIC_INT_WORDS;
    bit [7:0]      PIC_REGION;
    bit [12:0]     PIC_SIZE;
    bit [11:0]     PIC_TOTAL_INT;
    bit [12:0]     PIC_TOTAL_INT_PLUS1;
    bit [7:0]      RET_STACK_SIZE;
    bit [4:0]      SB_BUS_ID;
    bit [5:0]      SB_BUS_PRTY;
    bit [7:0]      SB_BUS_TAG;
    bit [4:0]      TIMER_LEGAL_EN;
} eh2_param_t;

