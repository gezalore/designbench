// Copyright © 2019-2023
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <algorithm>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <limits>
#include <memory>
#include <sstream>
#include <unordered_map>
#include <vector>

#include "svdpi.h"

//#include "VX_config.h"

#define IO_COUT_ADDR    0x00000040
#define IO_COUT_SIZE    64
#define MEM_BLOCK_SIZE  64
// Following code assumes these
static_assert(MEM_BLOCK_SIZE <= 64);
static_assert(IO_COUT_SIZE <= 64);

static constexpr size_t PAGE_BITS = 12;
static constexpr size_t PAGE_SIZE = 1 << PAGE_BITS;
static constexpr size_t PAGE_MASK = PAGE_SIZE - 1;

class Ram final {
  std::unordered_map<uint64_t, std::unique_ptr<uint8_t[]>> m_pages;
  uint8_t* m_pagep = nullptr;
  uint64_t m_page_index = std::numeric_limits<uint64_t>::max();

  uint8_t *get(uint64_t address)  {
    const uint64_t page_index = address >> PAGE_BITS;
    const uint64_t page_offset = address & PAGE_MASK;

    if (m_page_index != page_index) {
      const auto pair = m_pages.emplace(page_index, nullptr);
      if (pair.second) {
        uint8_t* const newp = new uint8_t[PAGE_SIZE];
        // set uninitialized data to "baadf00d"
        for (size_t i = 0; i < PAGE_SIZE; ++i) {
          newp[i] = (0xbaadf00d >> ((i & 0x3) * 8)) & 0xff;
        }
        pair.first->second.reset(newp);
      }
      m_pagep = pair.first->second.get();
      m_page_index = page_index;
    }

    return m_pagep + page_offset;
  }


public:

  Ram() = default;
  ~Ram() = default;

  void clear() {
    m_pages.clear();
    m_pagep = nullptr;
    m_page_index = std::numeric_limits<uint64_t>::max();
  }

  void read(uint8_t* dstp, uint64_t addr, uint64_t size) {
    for (uint64_t i = 0; i < size; ++i) {
      dstp[i] = *get(addr + i);
    }
  }

  void write(const uint8_t* srcp, uint64_t addr, uint64_t size) {
    for (uint64_t i = 0; i < size; ++i) {
      *get(addr + i) = srcp[i];
    }
  }

  void load(const char* fileName) {
    clear();

    std::ifstream ifs(fileName);
    if (!ifs) {
      printf("Error: cannot open '%s'\n", fileName);
      std::abort();
    }

    uint64_t addr = 0;
    uint64_t size = 0;
    std::vector<uint8_t> content;

    while (ifs.peek() != EOF) {
      ifs.read((char*)&addr, 8);
      ifs.read((char*)&size, 8);
      content.resize(size);
      ifs.read((char*)content.data(), size);
      write(content.data(), addr, size);
    }
  }

  bool check(const char* fileName, bool verbose) {
    std::ifstream ifs(fileName);
    if (!ifs) {
      printf("Error: cannot open '%s'\n", fileName);
      std::abort();
    }

    uint64_t addr = 0;
    uint64_t size = 0;
    std::vector<uint8_t> expected;
    std::vector<uint8_t> actual;

    while (ifs.peek() != EOF) {
      ifs.read((char*)&addr, 8);
      ifs.read((char*)&size, 8);

      expected.resize(size);
      ifs.read((char*)expected.data(), size);

      actual.resize(size);
      read(actual.data(), addr, size);

      for (uint64_t i = 0 ; i < size; ++i) {
        if (expected[i] != actual[i]) {
          if (verbose) {
            printf("Error: Memory check failed at address 0x%0llx, expected: 0x%02x, actual: 0x%02x\n",
                   (unsigned long long)(addr + i), expected[i], actual[i]);
          }
          return false;
        }
      }
    }

    return true;
  }

  void dump(const char* fileName) {
    std::ofstream ofs(fileName);
    if (!ofs) {
      printf("Error: cannot open '%s'\n", fileName);
      std::abort();
    }

    std::vector<std::pair<uint64_t, uint8_t*>> pages;
    for (const auto& pair : m_pages) {
      pages.emplace_back(pair.first, pair.second.get());
    }

    std::sort(pages.begin(), pages.end(), [](auto a, auto b) {
        return a.first < b.first;
    });

    std::vector<uint8_t> content(PAGE_SIZE);

    for (const auto& pair : pages) {
      uint64_t addr = pair.first << PAGE_BITS;
      read(content.data(), addr, PAGE_SIZE);
      ofs.write((char*)&addr, 8);
      uint64_t page_size = PAGE_SIZE;
      ofs.write((char*)&page_size, 8);
      ofs.write((char*)content.data(), PAGE_SIZE);
    }
  }
};

static Ram s_ram;
static std::stringstream s_print_bufs[IO_COUT_SIZE];

extern "C" void mem_load(const char* fileName) {
  s_ram.load(fileName);
}

extern "C" svBit mem_check(const char* fileName, svBit verbose) {
  s_ram.dump("check.bin");
  return s_ram.check(fileName, verbose);
}

extern "C" void mem_access(
    svBit req_rw,
    const uint64_t byteen,
    const uint64_t block_addr,
    const uint8_t* wdatap,
    uint8_t* rdatap
) {

  constexpr uint64_t IO_COUT_START = static_cast<uint64_t>(IO_COUT_ADDR);
  constexpr uint64_t IO_COUT_END = IO_COUT_START + IO_COUT_SIZE;

  const uint64_t addr = block_addr * MEM_BLOCK_SIZE;  // Byte address

  if (!req_rw) {
    // Read request
    s_ram.read(rdatap, addr, MEM_BLOCK_SIZE);
  } else if (IO_COUT_START <= addr && addr < IO_COUT_END) {
    // Write to special device printf location
    for (uint32_t i = 0; i < IO_COUT_SIZE; ++i) {
      if ((byteen >> i) & 1) {
        std::stringstream& buf = s_print_bufs[i];
        const char c = wdatap[i];
        buf << c;
        if (c == '\n') {
          printf("#%02u: %s", i, buf.str().c_str());
          buf.str("");
        }
      }
    }
  } else {
    // Write request
    for (size_t i = 0; i < MEM_BLOCK_SIZE; ++i) {
      if ((byteen >> i) & 1) {
        s_ram.write(wdatap + i, addr + i, 1);
      }
    }
  }
}

