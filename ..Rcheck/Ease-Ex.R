pkgname <- "Ease"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('Ease')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("changeInitGenoFreq")
### * changeInitGenoFreq

flush(stderr()); flush(stdout())

### Name: changeInitGenoFreq
### Title: Changing the initial genotype frequencies of a population
### Aliases: changeInitGenoFreq

### ** Examples

# Definition of a population in its simplest form:
DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
mutations <- list(
  mutation(from = "a", to = "A", rate = 1e-3),
  mutation(from = "b", to = "B", rate = 1e-3)
)
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)
pop <- setPopulation(
  name = "A",
  size = 1000,
  dioecy = TRUE,
  genomeObj = genomeObj,
  selectionObj = setSelectNeutral(genomeObj),
  mutMatrixObj = setMutationMatrix(genomeObj, mutations = mutations)
)
pop = changeinitGenoFreq(pop, c(0, 0, 0, 0, 0, 0, 0, 0, 0, 1))




cleanEx()
nameEx("mutation")
### * mutation

flush(stderr()); flush(stdout())

### Name: mutation
### Title: Definition of a mutation
### Aliases: mutation

### ** Examples

### Example with two loci, each with two alleles ###

# Definition of the genome
DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)

# The mutation function allows each transition from one allele to
# another to be defined individually, to produce the mutation matrix
# as follows:
mutMatrixObj <- setMutationMatrix(genomeObj,
  mutations = list(
    mutation(from = "A", to = "a", rate = 0.1),
    mutation(from = "B", to = "b", rate = 0.1)
  )
)




cleanEx()
nameEx("setGenome")
### * setGenome

flush(stderr()); flush(stdout())

### Name: setGenome
### Title: Setting the genome
### Aliases: setGenome

### ** Examples

DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)




cleanEx()
nameEx("setMetapopulation")
### * setMetapopulation

flush(stderr()); flush(stdout())

### Name: setMetapopulation
### Title: Setting a metapopulation
### Aliases: setMetapopulation

### ** Examples

# Definition of a population in its simplest form:
DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
mutations <- list(
  mutation(from = "A", to = "a", rate = 1e-3),
  mutation(from = "B", to = "b", rate = 1e-3)
)
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)
pop <- setPopulation(
  name = "A",
  size = 1000,
  dioecy = TRUE,
  genomeObj = genomeObj,
  selectionObj = setSelectNeutral(genomeObj),
  mutMatrixObj = setMutationMatrix(genomeObj, mutations = mutations)
)
metapop <- setMetapopulation(populations = list(pop))
metapop <- simulate(metapop, nsim = 10, seed = 123)
# Other examples available in the documentation of the package




cleanEx()
nameEx("setMutationMatrix")
### * setMutationMatrix

flush(stderr()); flush(stdout())

### Name: setMutationMatrix
### Title: Setting the mutation matrix
### Aliases: setMutationMatrix

### ** Examples

### Example with two loci, each with two alleles ###

# Definition of the genome
DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)

# Three ways to define the same mutation matrix associated with the
# genome defined above:

# 1) Mutation matrix from matrices
mutHapLoci <- list(matrix(c(0.99, 0.01, 0.01, 0.99), 2))
mutDipLoci <- list(matrix(c(0.99, 0.01, 0.01, 0.99), 2))
# One can then define the MutationMatrix class object:
setMutationMatrix(genomeObj,
  mutHapLoci = mutHapLoci,
  mutDipLoci = mutDipLoci
)

# 2) Mutation matrix from mutation rates
mutMatrixObj <- setMutationMatrix(genomeObj, forwardMut = 0.1)
# or by adding a backward mutation rate:
mutMatrixObj <- setMutationMatrix(genomeObj,
  forwardMut = 1e-3,
  backwardMut = 1e-4
)

# 3) Mutation matrix from single mutation definition
mutMatrixObj <- setMutationMatrix(genomeObj,
  mutations = list(
    mutation(from = "A", to = "a", rate = 0.1),
    mutation(from = "B", to = "b", rate = 0.1)
  )
)




cleanEx()
nameEx("setPopulation")
### * setPopulation

flush(stderr()); flush(stdout())

### Name: setPopulation
### Title: Setting a population
### Aliases: setPopulation

### ** Examples

# Definition of a population in its simplest form:
DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
mutations <- list(
  mutation(from = "A", to = "a", rate = 1e-3),
  mutation(from = "B", to = "b", rate = 1e-3)
)
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)
pop <- setPopulation(
  name = "A",
  size = 1000,
  dioecy = TRUE,
  genomeObj = genomeObj,
  selectionObj = setSelectNeutral(genomeObj),
  mutMatrixObj = setMutationMatrix(genomeObj, mutations = mutations)
)




cleanEx()
nameEx("setSelectNeutral")
### * setSelectNeutral

flush(stderr()); flush(stdout())

### Name: setSelectNeutral
### Title: Setting the selection
### Aliases: setSelectNeutral

### ** Examples

### Example with two loci, each with two alleles ###
# Definition of the diploid locus
DL <- list(dl = c("A", "a"))
# Definition of the haploid locus
HL <- list(hl = c("B", "b"))
# Definition of the object of Genome class
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)
genomeObj

### Exemple with more diploid loci ###
# Definition of the diploid loci
DL <- list(
  dl1 = c("A", "a"),
  dl2 = c("B", "b"),
  dl3 = c("C", "c")
)
# Definition of the haploid locus
HL <- list(hl = c("D", "d"))
# Definition of the object of Genome class, with in addition the necessary
# definition of recombination rates between loci:
genomeObj <- setGenome(
  listHapLoci = HL, listDipLoci = DL,
  recRate = c(0.1, 0.5)
)
# Here we have a 0.1 recombination rate between dl1 and dl2 and a 0.5
# recombination rate between dl2 and dl3. It is as if dl1 and dl2 were linked,
# for example on the same chromosome, and that dl2 (and dl1 by consequence)
# and dl3 were independent, for example on different chromosomes.

genomeObj




cleanEx()
nameEx("setSelectOnGametes")
### * setSelectOnGametes

flush(stderr()); flush(stdout())

### Name: setSelectOnGametes
### Title: Setting the selection on gametes
### Aliases: setSelectOnGametes

### ** Examples

DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)
selectionObj <- setSelectOnGametes(
  genomeObj = genomeObj,
  gamFit = c(1, 1, 0.5, 0)
)




cleanEx()
nameEx("setSelectOnGametesProd")
### * setSelectOnGametesProd

flush(stderr()); flush(stdout())

### Name: setSelectOnGametesProd
### Title: Setting the selection on gamete production
### Aliases: setSelectOnGametesProd

### ** Examples

DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)
selectionObj <- setSelectOnGametesProd(
  genomeObj = genomeObj,
  indProdFit = c(1, 1, 1, 1, 0.5, 0)
)




cleanEx()
nameEx("setSelectOnInds")
### * setSelectOnInds

flush(stderr()); flush(stdout())

### Name: setSelectOnInds
### Title: Setting the selection on individuals
### Aliases: setSelectOnInds

### ** Examples

DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
genomeObj <- setGenome(listHapLoci = HL, listDipLoci = DL)
selectionObj <- setSelectOnInds(
  genomeObj = genomeObj,
  indFit = c(1, 1, 1, 1, 0.5, 0)
)




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
