---
title: 'Ease: An R Package for Efficient Population Genetics Simulations'
tags:
  - Biology
  - Population genetics
  - Simulations
authors:
  - name: Ehouarn {Le Faou}
    orcid: 0000-0001-7969-6490
    equal-contrib: true
    affiliation: 1
affiliations:
 - name: Department of Ecology and Evolution, University of Lausanne, 1015 Lausanne, Switzerland
   index: 1
date: 02 July 2023
bibliography: paper.bib
---

# Summary

`Ease` is an `R` package for efficient and reproducible population genetics simulations, designed to facilitate the implementation of theoretical models involving few to moderate numbers of loci with arbitrary epistasis and dominance patterns. The package implements efficient simulation of such models by tracking genotype frequencies using deterministic transition matrices for mutation, reproduction, and selection, while incorporating genetic drift through multinomial sampling. 

# Statement of need

Population genetics plays a crucial role in our understanding of the adaptation of species. Its methods are used, for example, to trace back speciation times, to understand the genetic diversity of species and the consequences of selection. This field has always been heavily influenced by theory, which, through simplified models of reality, has shed light on how evolution shapes biodiversity. Along with mathematical treatment of those models, simulations are essential, particularly for exploring analytically intractable models or for assessing their behaviour when their assumptions are relaxed. A wide range of simulation frameworks are available, e.g. coalescent simulators optimised for neutral genome-scale models (e.g. `msprime`; @baumdicker_2022), or forward-in-time individual-based simulators designed for biologically realistic representations of selection, demography and drift (e.g. `SLiM`; @Haller_2023). These tools are well suited to many applications, but they are not optimised for models in which the genetic architecture is deliberately simple while selection depends on complex epistasis and dominance relations between finite set of alleles in arbitrarily large populations. Many canonical models (see, for example, models described in @crow_introduction_1970; @burger_mathematical_2000; @ewens_mathematical_2004) fall into this category, which have not been the focus of efforts to produce an effective, flexible and easy-to-use simulator.

The `R` package `Ease` was developed to fill this gap. It is a lightweight and reproducible implementation of population genetics models that include only a few loci. `Ease` represents populations by genotype frequency vectors rather than by individual genomes, and updates these frequencies across generations under selection, mutation, recombination, migration, and genetic drift. This approach is computationally efficient when the number of loci and alleles is limited, and it closely matches the structure of many population genetics models that are formulated as recursions on genotype or haplotype frequencies.

# Software design

`Ease` incorporate both nuclear and cytoplasmic (homoplasmic) loci. The loci of the first type are diploid, with Mendelian transmission, while those of the second type are haploid with a strict maternal transmission. Any number of alleles can be defined for each locus. Unlike individual-based simulations, where each individual is explicitly defined (i.e. each with its own combination of alleles), `Ease` tracks the frequencies of allele combinations themselves. Allele combinations are defined as unique sets of alleles, and exist in two types: *haplotypes* and *genotypes*. A *haplotype* is defined as the allele combination of a gamete, which is composed of one *nuclear haplotype* and one *cytoplasmic haplotype*. Two *nuclear haplotypes* can be paired together to form a *nuclear genotype* and combined with a *cytoplasmic haplotype* to form a *genotype*. A *genotype* is therefore the allele combination of a zygote.

Once the user has defined how many loci (nuclear and cytoplasmic) and how many alleles per locus they want to simulate, `Ease` defines automatically a set of transition matrices which are used at each generation and constant throughout the simulation (\autoref{fig:LifeCycle}). These matrices allow, for example, the haplotype frequency vector of gametes to be calculated from the genotype frequencies of the parents by a simple matrix multiplication that incorporates recombination, random segregation of chromosomes, and mutation. Theoretically, no hard limit is imposed onto the number of loci and the number of alleles per locus the user can define, but the computational method `Ease` uses to track allele frequency changes imposes a practical limit to them. This is because the size of the transition matrices becomes exceedingly large when the number of haplotypes and the number of genotypes is large, and so when the number of loci exceeds a handful. One advantage of this approach is that as individuals are not explicitely modeled, populations can be of any size (up to millions or billions of individuals) without slowing down the simulation. Genetic drift can still be simulated realistically by multinomial sampling, whose performance is only marginally affected by sample size.

The primary use of `Ease` is to track the trajectories of genotypes, haplotypes and allele frequencies over generations. It does so through a canonical life cycle used in population genetics (\autoref{fig:LifeCycle}), in which diploid zygotes are first produced by the fusion of one male and one female haploid gametes resulting from independent meiosis. These zygotes then develop into adults, which then produce the gametes that will form the zygotes of the next generation before dying (generations do not overlap). Along this life cycle, selection can happen at three time points. Adult genotypes can be associated with absolute fecundity values for female and male gamete production. Gametes, depending on their haplotype and their sex, can be associated with survival probabilities. Finally, zygote genotypes can be associated with different survival probabilities, which occur before they become adults.

`Ease` assumes two types of gamete associated with two mating types, which are called male and female gametes for simplicity. For the sexual identity of adult individuals, there are two possible scenarios. In the default scenario, all individuals are hermaphrodites and therefore capable of producing both female and male gametes. A self-fertilisation rate can be define, as the probability for a zygote to be produced through the fusion of gametes produced by the same individual. In an alternative scenario, zygotes are assigned to develop into adults producing only male gametes or only female gametes, with a 50\% chance for each (i.e. separate sexes or dioecy). It is possible to simulate this alternative scenario from the default one by defining explicitly a sex-determining locus, which can be useful when simulating sex-linked loci or variable sex ratios. This can also help to simulate more complex sexual systems, such as gynodioecy or androdioecy, among others.

![Summary of the various steps implemented in `Ease` to run simulations with a number G of genotypes and H of haplotypes. All the transition matrices (reproduction, selection, migration, ...) are available for consultation using the `print` method, and can be defined in a variety of ways, depending on user's requirements. Selection on gamete survival occurs simultaneously in male and female gametes, with the possibility of assigning different gamete survival rates to each sex. This also applies to selection on fertility and zygote survival when dioecious reproduction is activated.\label{fig:LifeCycle}](LifeCycle.png)

Finally, the package supports the simulation of multiple populations with any migration pattern between them, e.g. island models, stepping stone models, or models with different population sizes.

# Example of use

Model implementation is standardised and involves defining the genome, allelic effects, population(s) and their interconnection within a metapopulation, before finally simulating and extracting the results of the simulation(s) (\autoref{fig:Process}). A model can be simulated multiple times (without parallelisation), their results are then combined in the result objects.

![Steps for implementing a model with `Ease` and associated functions, from defining the genome and the selective effect of alleles to extracting the results of the model simulation.\label{fig:Process}](EaseDiagram.png)

In the example below, each individual is represented by a genotype at two diallelic loci. One of these is nuclear with wildtype allele `"A"` and alternative allele `"a"`, and the other is cytoplasmic with wildtype allele `"B"` and alternative allele `"b"`. By default, when defining a population, the first allele named (here the wildtypes `"A"` and `"B"`, see below) is the one that is fixed in the population at the start of the simulation.
```r
library(Ease)
# Definition of a genome with 2 locus, 2 alleles each:
DL <- list(dl = c("A", "a"))
HL <- list(hl = c("B", "b"))
```

Next, a list of possible mutation events from one allele to another is defined, each associated with a mutation rate, defined as the proportion of copies that will be mutated at each meiosis event. 
```r
mutations <- list(
    mutation(from = "A", to = "a", rate = 1e-3),
    mutation(from = "B", to = "b", rate = 1e-3)
)
genomeObj <- Ease::setGenome(listHapLoci = HL, listDipLoci = DL)
mutMatrixObj <- Ease::setMutationMatrix(genomeObj, mutations = mutations)
```
The population is then defined, specifying its name (here `ExamplePop`), size (here 1,000 individuals), sexual system (here dioecy, i.e. 500 females and 500 males), genetic system and mutation pattern. In addition to this, it is necessary to define the type of selection. Here, for simplicity's sake, the alleles are defined as neutral.
```r
# Definition of a population of 1000 individuals, males and females
pop <- Ease::setPopulation(
    name = "ExamplePop",
    size = 1000,
    dioecy = TRUE,
    genomeObj = genomeObj,
    mutMatrixObj = mutMatrixObj,
    selectionObj = Ease::setSelectNeutral(genomeObj)
)
print(pop)
#> -=-=-=-=-= Population OBJECT =-=-=-=-=- 
#>               in details 
#> Population 'ExamplePop' of 1000 dioecious individuals
#> There is no demography. 
#> The initial genotype frequencies are:  
#> A/A||B A/a||B a/a||B A/A||b A/a||b a/a||b 
#>      1      0      0      0      0      0 
#> Selection:  
#> No selection defined. 
#> -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
```
Once the population has been defined, a metapopulation must be defined (here with only a single population). Below, its evolution is simulated over 2,000 generations with the genotype, haplotype and allele frequencies of each generation being recorded (by default when setting `recording = TRUE`).
```r
metapop <- Ease::setMetapopulation(populations = list(pop))
metapop <- simulate(metapop, threshold = 2000, seed = 123, recording = TRUE)
rec = Ease::getRecords(metapop)
print(which(rec$s1$ExamplePop$a == 1)[1])
#> [1] 1072
print(which(rec$s1$ExamplePop$b == 1)[1])
#> [1] 1481
```
The recorded frequencies of alleles `a` and `b` can then be extracted using the function `getRecords`. Here, having defined a (fairly high) directional mutation rate towards these alleles, each fixed after 1072 and 1481 generations, respectively.

For more details on how the package works and a more detailed view of the options, see the package vignette and documentation.

# Acknowledgements

I would like to thank Sylvain Glémin and Lucas Marie-Orleach for inspiring me to take this modelling approach, and Vitor Sudbrack for his valuable feedback. I am grateful to John Pannell and the Swiss National Science Foundation (grant 310030_185196) for funding.

# References
