
source('https://raw.githubusercontent.com/guertinlab/seqOutBias/master/docs/R/seqOutBias_functions.R')
library(ggseqlogo)

pswm.func.2 <- function(x.ligation, out = 'outfilename') {
    a = lapply(strsplit(as.character(x.ligation), ''), "[", 1)
    b = lapply(strsplit(as.character(x.ligation), ''), "[", 2)
    c = lapply(strsplit(as.character(x.ligation), ''), "[", 3)
    d = lapply(strsplit(as.character(x.ligation), ''), "[", 4)
    e = lapply(strsplit(as.character(x.ligation), ''), "[", 5)
    f = lapply(strsplit(as.character(x.ligation), ''), "[", 6)
    g = lapply(strsplit(as.character(x.ligation), ''), "[", 7)
    h = lapply(strsplit(as.character(x.ligation), ''), "[", 8)
    i = lapply(strsplit(as.character(x.ligation), ''), "[", 9)
    j = lapply(strsplit(as.character(x.ligation), ''), "[", 10)
    k = lapply(strsplit(as.character(x.ligation), ''), "[", 11)
    l = lapply(strsplit(as.character(x.ligation), ''), "[", 12)
    m = lapply(strsplit(as.character(x.ligation), ''), "[", 13)
    n = lapply(strsplit(as.character(x.ligation), ''), "[", 14)
    o = lapply(strsplit(as.character(x.ligation), ''), "[", 15)
    p = lapply(strsplit(as.character(x.ligation), ''), "[", 16)
    q = lapply(strsplit(as.character(x.ligation), ''), "[", 17)
    r = lapply(strsplit(as.character(x.ligation), ''), "[", 18)
    s = lapply(strsplit(as.character(x.ligation), ''), "[", 19)
    t = lapply(strsplit(as.character(x.ligation), ''), "[", 20)
    col.matrix = cbind(a,b,c,d,e,f, g,h,i,j,k,l,m,n,o,p,q,r,s,t)
    a.nuc = sapply(1:20, function(x) sum(col.matrix[,x] == "A"))
    t.nuc = sapply(1:20, function(x) sum(col.matrix[,x] == "T"))
    c.nuc = sapply(1:20, function(x) sum(col.matrix[,x] == "C"))
    g.nuc = sapply(1:20, function(x) sum(col.matrix[,x] == "G"))
    #pswm = cbind(a.nuc*(0.25/.2), c.nuc*(0.25/.3), g.nuc*(0.25/.3), t.nuc*(0.25/.2))
    pswm = cbind(a.nuc, c.nuc, g.nuc, t.nuc)
    print(pswm)
    outfile = file(paste0(out, '.txt'))
    on.exit(close(outfile))
    writeLines(c("MEME version 4", "ALPHABET= ACGT", "strands: + -", " ", 
                 "Background letter frequencies (from uniform background):", 
                 "A 0.20000 C 0.30000 G 0.30000 T 0.20000", paste("MOTIF", out), " ",
                 "letter-probability matrix: alength= 4 w= 20"), outfile)
    pswm = pswm/rowSums(pswm)
    write.table(pswm, file = paste0(out, '.txt'), append = TRUE, quote=FALSE, row.names =FALSE, col.names = FALSE)
#the followign line can be uncommented if ceqlogo is installed and in your $PATH    
#    system(paste('ceqlogo -i ', out, '.txt -m 1 > ', out, '.eps', sep=''))
    return(pswm)
}

plot.seqlogo.func <- function(x, outfile = "ATAC-kmer_optimization_all_test.pdf") {
    w =  0.663 + (ncol(x) + 1)*0.018 + (ncol(x)+2)* .336
    pdf(outfile, useDingbats=FALSE, width=w, height=2.695)
    print(ggseqlogo(x,  facet = "wrap", font = 'helvetica_bold'))
    dev.off()
}

dir = paste0(path.expand("~"),'/Desktop/atac_test/')
setwd(dir)

#I am running the same scripts on four files because it was easiest to copy and paste
#How can you clean this up by making a function and running this function on a list of input files?

pe1.minusATAC = read.table('CEM-C7_untreated_rep2_PE1_minus_not_scaled.fasta', 
                           comment.char = '>')
pe1.minusATAC[,1] = as.character(pe1.minusATAC[,1])
pe1.minusATAC = data.frame(lapply(pe1.minusATAC, function(v) {
if (is.character(v)) return(toupper(v))
else return(v)
}))

pe1.plusATAC = read.table('CEM-C7_untreated_rep2_PE1_plus_not_scaled.fasta', 
                          comment.char = '>')
pe1.plusATAC[,1] = as.character(pe1.plusATAC[,1])
pe1.plusATAC = data.frame(lapply(pe1.plusATAC, function(v) {
if (is.character(v)) return(toupper(v))
else return(v)
}))

pe2.minusATAC = read.table('CEM-C7_untreated_rep2_PE2_minus_not_scaled.fasta', 
                           comment.char = '>')
pe2.minusATAC[,1] = as.character(pe2.minusATAC[,1])
pe2.minusATAC = data.frame(lapply(pe2.minusATAC, function(v) {
if (is.character(v)) return(toupper(v))
else return(v)
}))

pe2.plusATAC = read.table('CEM-C7_untreated_rep2_PE2_plus_not_scaled.fasta', 
                          comment.char = '>')
pe2.plusATAC[,1] = as.character(pe2.plusATAC[,1])
pe2.plusATAC = data.frame(lapply(pe2.plusATAC, function(v) {
if (is.character(v)) return(toupper(v))
else return(v)
}))


pswm.pe1.minus = pswm.func.2(pe1.minusATAC[,1], 'ATAC_bias_pe1_minus')
pswm.pe1.plus = pswm.func.2(pe1.plusATAC[,1], 'ATAC_bias_pe1_plus')
pswm.pe2.minus = pswm.func.2(pe2.minusATAC[,1], 'ATAC_bias_pe2_minus')
pswm.pe2.plus = pswm.func.2(pe2.plusATAC[,1], 'ATAC_bias_pe2_plus')

save(pswm.pe1.minus, pswm.pe1.plus, pswm.pe2.minus, pswm.pe2.plus, file ='pswm.Rdata')



pswm.pe1.minus.trans = t(pswm.pe1.minus)
rownames(pswm.pe1.minus.trans) = c('A', 'C', 'G', 'T')

pswm.pe1.plus.trans = t(pswm.pe1.plus)
rownames(pswm.pe1.plus.trans) = c('A', 'C', 'G', 'T')

pswm.pe2.minus.trans = t(pswm.pe2.minus)
rownames(pswm.pe2.minus.trans) = c('A', 'C', 'G', 'T')

pswm.pe2.plus.trans = t(pswm.pe2.plus)
rownames(pswm.pe2.plus.trans) = c('A', 'C', 'G', 'T')



plot.seqlogo.func(pswm.pe1.minus.trans, outfile='pswm_pe1_minus_trans.pdf')
plot.seqlogo.func(pswm.pe1.plus.trans, outfile='pswm_pe1_plus_trans.pdf')

plot.seqlogo.func(pswm.pe2.minus.trans, outfile='pswm_pe2_minus_trans.pdf')
plot.seqlogo.func(pswm.pe2.plus.trans, outfile='pswm_pe2_plus_trans.pdf')
