// Copyright 2025 designbench contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

#include <cstring>
#include <ctype.h>
#include <string>

#include "svdpi.h"


extern "C" const char* uppercase(const char* p) {
  static std::string buf;
  const size_t len = std::strlen(p);
  buf.resize(len, 'X');
  for (size_t i = 0; i < len; ++i) {
    buf[i] = toupper(p[i]);
  }
  return buf.c_str();
}
