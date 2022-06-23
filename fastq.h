#ifndef FASTQ
#define FASTQ
#include <zlib.h>
#include <string.h>
#include <unordered_map>
#define _bufsize 4096
#define seq_size 1024
#define add_seq_size 512

typedef struct _ks_string{
    int cur_size;
    char *s;
}ks_string;

typedef struct _kstream{
    char *buf;
    int begin,end,is_eof;
    gzFile f;
}kstream;

typedef struct _kseq{
    ks_string name,comments,seq,qual;
    int last_char;
    kstream *f;
}kseq;
//初始化读取
kstream* ks_init(gzFile f);
void ks_destroy(kstream *ks);
//初始化序列
kseq* seq_init(gzFile f);
void seq_destroy(kseq *seq);
//初始化字符串
void ks_string_init(kseq* seq);

int my_getc(kstream *ks);
int seq_read(kseq* seq);
//
void Seq_Reverse_complementary(char *str);
void Cnt_Base_num(char *base_seq);
void Cnt_Read_len(char *base_seq,std::unordered_map<int,int>&read_len);
int Average_Qual(char *qual_seq,int &qual_greater_30);

#endif