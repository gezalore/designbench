/***************************************************************************************
* Copyright (c) 2020-2023 Institute of Computing Technology, Chinese Academy of Sciences
* Copyright (c) 2020-2021 Peng Cheng Laboratory
*
* DiffTest is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <cassert>
#include <cstdint>

#include <sys/mman.h>

#include "common.h"

static constexpr uint64_t EMU_FLASH_SIZE = DEFAULT_EMU_FLASH_SIZE;

struct Flash final {
  uint64_t *mem = nullptr;

  Flash() {
    mem = (uint64_t *)mmap(NULL, EMU_FLASH_SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);
    if (mem == (uint64_t *)MAP_FAILED) {
      printf("Error: Cound not mmap 0x%lx bytes for flash\n", EMU_FLASH_SIZE);
      assert(0);
    }
    Info("Using simulated %luB flash\n", EMU_FLASH_SIZE);

    // defualt 3 instructions:
    // addiw   t0,zero,1
    // slli    to,to,  0x1f
    // jr      t0
    mem[0] = 0x01f292930010029b;
    mem[1] = 0x00028067;
  }

  ~Flash() {
     munmap(mem, EMU_FLASH_SIZE);
  }
};

static Flash flash{};

extern "C" void flash_read(uint32_t addr, uint64_t *data) {
  //addr must be 8 bytes aligned first
  const uint32_t aligned_addr = addr & FLASH_ALIGH_MASK;
  const uint64_t rIdx = aligned_addr / sizeof(uint64_t);
  if (rIdx >= EMU_FLASH_SIZE / sizeof(uint64_t)) {
    printf("Error: flash read addr %x is out of bound\n",addr);
    assert(0);
  }
  *data = flash.mem[rIdx];
}
