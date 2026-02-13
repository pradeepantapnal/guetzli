/*
 * Copyright 2016 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef GUETZLI_STATS_H_
#define GUETZLI_STATS_H_

#include <cstdio>
#include <cstdint>
#include <map>
#include <string>
#include <utility>
#include <vector>


namespace guetzli {

static const char* const  kNumItersCnt = "number of iterations";
static const char* const kNumItersUpCnt = "number of iterations up";
static const char* const kNumItersDownCnt = "number of iterations down";

struct ProcessStats {
  ProcessStats() {}
  std::map<std::string, int> counters;
  std::string* debug_output = nullptr;
  FILE* debug_output_file = nullptr;

  uint64_t butteraugli_compare_calls = 0;
  uint64_t butteraugli_tiled_compare_calls = 0;
  double butteraugli_compare_total_ms = 0.0;
  double butteraugli_color_convert_total_ms = 0.0;
  double butteraugli_diffmap_total_ms = 0.0;
  uint64_t butteraugli_dirty_tiles = 0;
  uint64_t butteraugli_tiles_recomputed = 0;
  double butteraugli_tile_compare_total_ms = 0.0;
  double select_frequency_masking_total_ms = 0.0;
  uint64_t select_frequency_masking_candidate_evals = 0;
  uint64_t select_frequency_masking_proxy_evals = 0;
  uint64_t select_frequency_masking_full_compare_calls = 0;
  uint64_t select_frequency_masking_proxy_rejects = 0;
  uint64_t select_frequency_masking_top_k = 0;
  uint64_t select_frequency_masking_fast_rejects = 0;
  double select_frequency_masking_sort_total_ms = 0.0;
  uint64_t jpeg_encode_calls = 0;
  double jpeg_encode_total_ms = 0.0;
  int thread_count = 1;

  std::string filename;
};

}  // namespace guetzli

#endif  // GUETZLI_STATS_H_
