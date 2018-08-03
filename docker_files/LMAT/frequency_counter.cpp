#include "all_headers.hpp"
#include <iostream>
#include <fstream>
#include <cassert>
#include <map>
#include <string>
#include <stdint.h>
#include <version.h>
#include <getopt.h>

using namespace std;
using namespace metag;

#define TID_T uint32_t

void usage() {
  cout << "Usage (all are required, except for -h):\n"
       << "  -i tax_histo_input_fn (in binary format)\n"
       << "  -o output_basename\n"
       << "  -f 16|32 (determines tid size)\n"
       << "  -q <int> stop after processing this many entries (optional; for debugging)\n";
}

template<class T> void doit(string &input_fn, string &output_fn, int quit_early); 

int main(int argc, char **argv) {
  cout << "invocation: ";
  for (int j=0; j<argc; j++) {
    cout << argv[j] << " ";
  }
  cout << endl;

  bool prn_help = false;
  string input_fn, output_base_name;
  const string opt_string="i:o:h f:q:V";
  int which;
  int count = 0;
  char c;
  int quit_early = 0;
  while ((c = getopt(argc, argv, opt_string.c_str())) != -1) {
    switch (c) {
    case 'q':
      quit_early = atoi(optarg);
      break;
    case 'f':
      ++count;
      which = atoi(optarg);
      break;
    case 'h':
      prn_help = true;
      break;
    case 'i':
      ++count;
      input_fn = optarg;
      break;
    case 'o':
      ++count;
      output_base_name = optarg;
      break;
    case 'V':
      cout << "LMAT version " << LMAT_VERSION  << "\n";
      exit(0);
    default:
      cout << "Unrecognized option: "<<c<<", ignore."<<endl;
    }
  }

  bool failed = true;
  if (which == 32 || which == 16) {
    failed = false;
  }

  if (prn_help || count != 3 || failed) {
    usage();
    exit(1);
  }

  if (which == 16) {
    doit<uint16_t>(input_fn, output_base_name, quit_early);
  } else {
    doit<uint32_t>(input_fn, output_base_name, quit_early);
  }
}


template<class T> void doit(string &input_fn, string &output_fn, int quit_early) {
  map<TID_T,size_t> mp;
  FILE *fp = fopen(input_fn.c_str(), "r");
  assert(fp);

  KmerFileMetaData metadata;
  metadata.read(fp);
  assert(metadata.version() == TAX_HISTO_VERSION);
  cout << "kmer count: " << metadata.size() << endl;

  uint64_t test, sanity = ~0;
  kmer_t kmer;
  TID_T tid;
  uint16_t tid_count;

  size_t total_tid = 0;

  size_t singletons = 0;
  
  for (size_t j=0; j<metadata.size(); j++) {
    if (quit_early && quit_early == j) {
      break;
    }
    assert(fread(&kmer, sizeof(kmer_t), 1, fp) == 1);
    assert(fread(&tid_count, 2, 1, fp) == 1);
    for (uint16_t h=0; h<tid_count; h++) {
      assert(fread(&tid, sizeof(T), 1, fp) == 1);
      if (mp.find(tid) == mp.end()) {
        mp[tid] = 0;
      }
      mp[tid] += 1;
    }
    total_tid +=tid_count;

    if (tid_count == 1)
      singletons++;

    if (j % 1000000 == 0) cout << "kmers processed: " << j/1000000 << " M\n";

    if ((j+1) % TAX_HISTO_SANITY_COUNT == 0) {
      assert(fread(&test, 8, 1, fp) == 1);
      assert(test == sanity);
    }
  }
  fclose(fp);

  char buf[1024];
  sprintf(buf, "%s.par.kcnt", output_fn.c_str());
  cout << endl << "writing output to: " << buf << endl;
  ofstream out(buf);
  assert(out);
  for (map<TID_T,size_t>::const_iterator t = mp.begin(); t != mp.end(); t++) {
    out << t->first << " " << t->second << endl;
  }
  out.close();

  cout << "Total-tid: " << total_tid << endl;
  cout << "Singletons: " << singletons << endl;
}



