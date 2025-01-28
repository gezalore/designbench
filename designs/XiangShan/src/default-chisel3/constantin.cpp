
#include <map>
#include <string>
#include <stdint.h>

static const std::map<std::string, uint64_t> constantinMap{
  {"always_update0", 1},
  {"enableL3StreamPrefetch0", 0},
  {"tp_throttleCycles0", 4},
  {"enableTP0", 1},
  {"tp_hitAsTrigger0", 1},
  {"StoreBufferThreshold_0", 7},
  {"isWriteFetchToIBufferTable0", 0},
  {"isWriteICacheTable0", 0},
  {"isWritePTWTable0", 0},
  {"isWriteBankConflictTable0", 0},
  {"CorrectMissTrain0", 0},
  {"isWriteL1MissQMissTable0", 0},
  {"nMaxPrefetchEntry0", 14},
  {"isWriteL2TlbMissQueueTable0", 0},
  {"isWriteInstInfoTable0", 0},
  {"enableDynamicPrefetcher0", 1},
  {"isFirstHitWrite0", 0},
  {"isWritePageCacheTable0", 0},
  {"StoreBufferBase_0", 4},
  {"depth0", 32},
  {"isWriteLoadAccessTable0", 0},
  {"ColdDownThreshold_0", 12},
  {"isWriteL2TlbPrefetchTable0", 0},
  {"ForceWriteUpper_0", 60},
  {"tp_trainOnL1PF0", 0},
  {"l2_stride_ratio0", 5},
  {"isWriteL1TlbTable0", 0},
  {"l2DepthRatio0", 2},
  {"tp_recordThres0", 16},
  {"isWriteLoadMissTable0", 0},
  {"l1_stride_ratio0", 2},
  {"tp_trainOnVaddr0", 0},
  {"isWriteFTQTable0", 0},
  {"ForceWriteLower_0", 55},
  {"enableL1StreamPrefetcher0", 1},
  {"isWritePrefetchPtrTable0", 0},
  {"isWriteIfuWbToFtqTable0", 0},
  {"StoreWaitThreshold_0", 0},
  {"tp_triggerThres0", 1},
  {"l3DepthRatio0", 3}
};

extern "C" uint64_t always_update0_constantin_read() {
  return constantinMap.at("always_update0");
}

extern "C" uint64_t enableL3StreamPrefetch0_constantin_read() {
  return constantinMap.at("enableL3StreamPrefetch0");
}

extern "C" uint64_t tp_throttleCycles0_constantin_read() {
  return constantinMap.at("tp_throttleCycles0");
}

extern "C" uint64_t enableTP0_constantin_read() {
  return constantinMap.at("enableTP0");
}

extern "C" uint64_t tp_hitAsTrigger0_constantin_read() {
  return constantinMap.at("tp_hitAsTrigger0");
}

extern "C" uint64_t StoreBufferThreshold_0_constantin_read() {
  return constantinMap.at("StoreBufferThreshold_0");
}

extern "C" uint64_t isWriteFetchToIBufferTable0_constantin_read() {
  return constantinMap.at("isWriteFetchToIBufferTable0");
}

extern "C" uint64_t isWriteICacheTable0_constantin_read() {
  return constantinMap.at("isWriteICacheTable0");
}

extern "C" uint64_t isWritePTWTable0_constantin_read() {
  return constantinMap.at("isWritePTWTable0");
}

extern "C" uint64_t isWriteBankConflictTable0_constantin_read() {
  return constantinMap.at("isWriteBankConflictTable0");
}

extern "C" uint64_t CorrectMissTrain0_constantin_read() {
  return constantinMap.at("CorrectMissTrain0");
}

extern "C" uint64_t isWriteL1MissQMissTable0_constantin_read() {
  return constantinMap.at("isWriteL1MissQMissTable0");
}

extern "C" uint64_t nMaxPrefetchEntry0_constantin_read() {
  return constantinMap.at("nMaxPrefetchEntry0");
}

extern "C" uint64_t isWriteL2TlbMissQueueTable0_constantin_read() {
  return constantinMap.at("isWriteL2TlbMissQueueTable0");
}

extern "C" uint64_t isWriteInstInfoTable0_constantin_read() {
  return constantinMap.at("isWriteInstInfoTable0");
}

extern "C" uint64_t enableDynamicPrefetcher0_constantin_read() {
  return constantinMap.at("enableDynamicPrefetcher0");
}

extern "C" uint64_t isFirstHitWrite0_constantin_read() {
  return constantinMap.at("isFirstHitWrite0");
}

extern "C" uint64_t isWritePageCacheTable0_constantin_read() {
  return constantinMap.at("isWritePageCacheTable0");
}

extern "C" uint64_t StoreBufferBase_0_constantin_read() {
  return constantinMap.at("StoreBufferBase_0");
}

extern "C" uint64_t depth0_constantin_read() {
  return constantinMap.at("depth0");
}

extern "C" uint64_t isWriteLoadAccessTable0_constantin_read() {
  return constantinMap.at("isWriteLoadAccessTable0");
}

extern "C" uint64_t ColdDownThreshold_0_constantin_read() {
  return constantinMap.at("ColdDownThreshold_0");
}

extern "C" uint64_t isWriteL2TlbPrefetchTable0_constantin_read() {
  return constantinMap.at("isWriteL2TlbPrefetchTable0");
}

extern "C" uint64_t ForceWriteUpper_0_constantin_read() {
  return constantinMap.at("ForceWriteUpper_0");
}

extern "C" uint64_t tp_trainOnL1PF0_constantin_read() {
  return constantinMap.at("tp_trainOnL1PF0");
}

extern "C" uint64_t l2_stride_ratio0_constantin_read() {
  return constantinMap.at("l2_stride_ratio0");
}

extern "C" uint64_t isWriteL1TlbTable0_constantin_read() {
  return constantinMap.at("isWriteL1TlbTable0");
}

extern "C" uint64_t l2DepthRatio0_constantin_read() {
  return constantinMap.at("l2DepthRatio0");
}

extern "C" uint64_t tp_recordThres0_constantin_read() {
  return constantinMap.at("tp_recordThres0");
}

extern "C" uint64_t isWriteLoadMissTable0_constantin_read() {
  return constantinMap.at("isWriteLoadMissTable0");
}

extern "C" uint64_t l1_stride_ratio0_constantin_read() {
  return constantinMap.at("l1_stride_ratio0");
}

extern "C" uint64_t tp_trainOnVaddr0_constantin_read() {
  return constantinMap.at("tp_trainOnVaddr0");
}

extern "C" uint64_t isWriteFTQTable0_constantin_read() {
  return constantinMap.at("isWriteFTQTable0");
}

extern "C" uint64_t ForceWriteLower_0_constantin_read() {
  return constantinMap.at("ForceWriteLower_0");
}

extern "C" uint64_t enableL1StreamPrefetcher0_constantin_read() {
  return constantinMap.at("enableL1StreamPrefetcher0");
}

extern "C" uint64_t isWritePrefetchPtrTable0_constantin_read() {
  return constantinMap.at("isWritePrefetchPtrTable0");
}

extern "C" uint64_t isWriteIfuWbToFtqTable0_constantin_read() {
  return constantinMap.at("isWriteIfuWbToFtqTable0");
}

extern "C" uint64_t StoreWaitThreshold_0_constantin_read() {
  return constantinMap.at("StoreWaitThreshold_0");
}

extern "C" uint64_t tp_triggerThres0_constantin_read() {
  return constantinMap.at("tp_triggerThres0");
}

extern "C" uint64_t l3DepthRatio0_constantin_read() {
  return constantinMap.at("l3DepthRatio0");
}
