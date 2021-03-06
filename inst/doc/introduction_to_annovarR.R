## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)
library(BioInstaller)
library(annovarR)
library(data.table)

## ------------------------------------------------------------------------
# Show all annovarR supported database
download.database(show.all.names = TRUE)

# Show all supported version of database (e.g. db_annovar_avsnp)
download.database(download.name = "db_annovar_avsnp", show.all.version = TRUE)

# Show all supprted buildver of specific version database
download.database(download.name = "db_annovar_avsnp", version = "avsnp147", show.all.buildvers = TRUE)

# To reduce the download time, we use the local demo configuratin file to download demo file
demo.cfg <- system.file("extdata", "demo/demo.cfg", package = "annovarR")
download.database("download_demo", show.all.versions = T, download.cfg = demo.cfg)
download.database("download_demo", "demo", buildver = "GRCh37", database.dir = sprintf("%s/databases/", 
  tempdir()), download.cfg = demo.cfg)

# If you want to download other resource in BioInstaller,
# you can use function `install.bioinfo`
install.bioinfo(show.all.names = TRUE)


## ------------------------------------------------------------------------

# Get all supprted anno.name in annovarR
get.annotation.names()

# Get annotation name needed download.name and 
# you can use download.database to download database using the download.name.
download.name <- get.download.name('avsnp147')

# Database configuration file
database.cfg <- system.file('extdata', 'config/databases.toml', package = "annovarR")

# Get anno.name needed input cols
get.annotation.needcols('avsnp147')

# build sqlite database
for(i in c("hg19_ALL.sites.2015_08", "hg19_avsnp147")) {
  database <- system.file("extdata", sprintf("demo/%s.txt", i), package = "annovarR")
  sqlite.db <- sprintf("%s/%s.sqlite", tempdir(), i)
  file.copy(database, sprintf("%s/%s.txt", tempdir(), i))
  sqlite.build(database, sqlite.connect.params = list(dbname = sqlite.db, table.name = sprintf("%s", 
    i)))
}

# use the defined rule to annotate 1000 Genome Project frequency
database.dir <- tempdir()
chr <- c("chr1", "chr2", "chr1")
start <- c("10177", "10177", "10020")
end <- c("10177", "10177", "10020")
ref <- c("-", "A", "A")
alt <- c("C", "AC", "-")
dat <- data.table(chr = chr, start = start, end = end, ref = ref, alt = alt)
x <- annotation(dat = dat, anno.name = "1000g2015aug_all", database.dir = database.dir, db.type = "txt")
x
x <- annotation(dat = dat, anno.name = "1000g2015aug_all", database.dir = database.dir, db.type = "sqlite")
x

# Do annotation using full match function (default to use chr, start to select data 
# and use chr, start, end, ref, and alt to match data)
# Use `?annotation.cols.match` to see more detail about `annotation.cols.match`
chr <- c("chr1", "chr2", "chr1")
start <- c("10020", "10020", "10020")
end <- c("10020", "10020", "10020")
ref <- c("A", "A", "A")
alt <- c("-", "-", "-")
dat <- data.table(chr = chr, start = start, end = end, ref = ref, alt = alt)
x <- annotation.cols.match(dat, "avsnp147", database.dir = database.dir, 
  return.col.names = "avSNP147", db.type = "sqlite")
x

# Region match mode
bed.file <- system.file("extdata", "demo/example.bed", package = "annovarR")
chr <- c("chr10", "chr1")
start <- c("100188904", "100185955")
end <- c("100188904", "100185955")
dat <- data.table(chr = chr, start = start, end = end)

# format.cols.plus.chr will add "chr" in chr colum 
# if your input chr colum not contain string 'chr'
# format.db.region.tb will process the region matched data
#x <- annotation.region.match(dat = dat, database.dir = tempdir(), dbname.fixed = bed.file, 
#  table.name.fixed = "bed", db.type = "txt", format.dat.fun = "format.cols.plus.chr", 
#  format.db.tb.fun = "format.db.region.tb")
#x

# Convert snp rs number to genomic location
snp.id <- c("rs775809821", "rs768019142")
x <- annotation(dat = data.table(rs = rep(snp.id, 3)), database.dir = database.dir, anno.name = "rs2pos147", 
    buildver = "hg19", verbose = FALSE, db.type = "txt")

# Annotate avinput format R data using ANNOVAR
# set debug to TRUE will not to run command
chr = "chr1"
start = "123"
end = "123"
ref = "A"
alt = "C"
dat <- data.table(chr, start, end, ref, alt)
x <- annotation(dat, "perl_annovar_refGene", annovar.dir = "/opt/bin/annovar", 
             database.dir = "{{annovar.dir}}/humandb", debug = TRUE)

# Annotate VCF file using ANNOVAR
# set debug to TRUE will not to run command
x <- annotation(anno.name = "perl_annovar_ensGene", input.file = "/tmp/test.vcf",
             annovar.dir = "/opt/bin/annovar/", database.dir = "{{annovar.dir}}/humandb", 
             out = tempfile(), vcfinput = TRUE, debug = TRUE)

# Annotation VCF file use VEP
vep(debug = TRUE)
x <- annotation(anno.name = "vep_all", input.file = "/tmp/test.vcf",
             out = tempfile(), debug = TRUE)

# Annotation VCF file use vcfanno
vcfanno(debug = TRUE)
x <- annotation(anno.name = "vcfanno_demo", input.file = system.file("extdata", "demo/vcfanno_demo/query.vcf.gz", 
                   package = "annovarR"), out = "test.vcf", vcfanno = "/path/vcfanno", debug = TRUE)


# Annotate gene from BioConductor org.hs.eg.db
gene <- c("TP53", "NSD2")
annotation(dat = gene, anno.name = "bioc_gene2alias")

