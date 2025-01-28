
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
