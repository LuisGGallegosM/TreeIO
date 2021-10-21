#ifndef TREEREADER
#define TREEREADER

#include"TTree.h"

class TreeReader
{
    TTree* tree;

    public:

    TreeReader(TTree* tree);

    void addInput(const std::string& varName,void* address);
    void readEntry(Long64_t entry) {  tree->GetEntry(entry);}
    Long64_t getEntries() const {return tree->GetEntries();}

};

#endif