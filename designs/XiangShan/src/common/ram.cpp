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
#include <fstream>
#include <iostream>

#include "common.h"

#include <sys/mman.h>

static constexpr uint64_t EMU_RAM_SIZE = DEFAULT_EMU_RAM_SIZE;

class Ram final {
  uint64_t *mem;

  static void read_image(const char *filename, void *dest) {
    std::ifstream file{filename, std::ios::binary};

    if (!file.is_open()) {
      std::cerr << "Cannot open '" << filename << "'\n";
      assert(0);
    }

    // Get the size of the file
    file.seekg(0, std::ios::end);
    const uint64_t file_size = file.tellg();
    file.seekg(0, std::ios::beg);

    const uint64_t read_size = (file_size > EMU_RAM_SIZE) ? EMU_RAM_SIZE : file_size;
    file.read(static_cast<char*>(dest), read_size);
    file.close();
  }

public:
  Ram(const char *image) {
    // initialize memory using Linux mmap
    mem = (uint64_t *)mmap(NULL, EMU_RAM_SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);
    if (mem == (uint64_t *)MAP_FAILED) {
      printf("Error: Cound not mmap 0x%lx bytes for ram\n", EMU_RAM_SIZE);
      assert(0);
    }
    Info("Using simulated %luMB RAM\n", EMU_RAM_SIZE / (1024 * 1024));
    read_image(image, mem);
  }

  ~Ram() {
    munmap(mem, EMU_RAM_SIZE);
  }

  bool in_range_u64(uint64_t index) { return index < EMU_RAM_SIZE / sizeof(uint64_t); }
  uint64_t& at(uint64_t index) { return mem[index]; }
};

static Ram ram{"program.bin"};

extern "C" uint64_t ram_read(uint64_t rIdx) {
  rIdx %= EMU_RAM_SIZE / sizeof(uint64_t);
  return ram.at(rIdx);
}

extern "C" void ram_write(uint64_t wIdx, uint64_t wdata, uint64_t wmask) {
  if (!ram.in_range_u64(wIdx)) {
    printf("ERROR: mem wIdx = 0x%lx out of bound!\n", wIdx);
    assert(0);
  }
  ram.at(wIdx) = (ram.at(wIdx) & ~wmask) | (wdata & wmask);
}

