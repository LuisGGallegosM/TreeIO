#ifndef ONIAIO
#define ONIAIO

#include"TreeReader.h"
#include"TreeWriter.h"

template<typename InputData>
class Reader
{
    TreeReader reader;
    InputData in;

    public:
    Reader(TTree* treeInput): reader(treeInput)
    {
        in.registerInput(&reader);
    }

    Long64_t getEntries() const { return reader.getEntries(); }

    const InputData* readEntry(Long64_t entry)
    {
        reader.readEntry(entry);
        return &in;
    }
};

template<typename OutputData>
class Writer
{
    TreeWriter writer;
    OutputData output;

    public:

    Writer(TTree* treeInput) :  writer(treeInput)
    {
        output.registerOutput(&writer);
    }

    void writeEntry(const OutputData* out) { output=*out; writer.writeEntry();}
};

#endif