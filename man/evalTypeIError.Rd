% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/benchmark.R
\name{evalTypeIError}
\alias{evalTypeIError}
\title{Evaluation of the type I error rate of enrichment methods}
\usage{
evalTypeIError(methods, exp.list, gs, alpha = 0.05, ea.perm = 1000,
  tI.perm = 1000, perm.block.size = -1, parallel = NULL,
  save2file = FALSE, out.dir = NULL, ...)
}
\arguments{
\item{methods}{Methods for enrichment analysis.  A character vector with
method names chosen from \code{\link{sbeaMethods}} and
\code{\link{nbeaMethods}}, or user-defined functions
implementing methods for enrichment analysis.}

\item{exp.list}{Experiment list.  A \code{list} of datasets, each being of
class \code{\linkS4class{SummarizedExperiment}}.}

\item{gs}{Gene sets, i.e. a list of character vectors of gene IDs.}

\item{alpha}{Numeric. Statistical significance level. Defaults to 0.05.}

\item{ea.perm}{Integer. Number of permutations of the sample group assignments 
during enrichment analysis. Defaults to 1000. Can also be an integer vector 
matching the length of 'methods' to assign different numbers of permutations
for different methods.}

\item{tI.perm}{Integer. Number of permutations of the sample group assignments 
during type I error rate evaluation. Defaults to 1000. Can also be an integer
vector matching the length of \code{methods} to assign different numbers of
permutations for different methods.}

\item{perm.block.size}{Integer. When running in parallel, splits \code{tI.perm}
into blocks of the indicated size. Defaults to -1, which indicates to not  
partition \code{tI.perm}.}

\item{parallel}{Parallel computation mode.  An instance of class
\code{\linkS4class{BiocParallelParam}}.  See the vignette of the
\code{BiocParallel} package for switching between serial, multi-core, and
grid execution.  Defaults to \code{NULL}, which then uses the first element
of \code{BiocParallel::registered()} for execution.  If not changed by the
user, this accordingly defaults to multi-core execution on the local host.}

\item{save2file}{Logical. Should results be saved to file for subsequent
benchmarking?  Defaults to \code{FALSE}.}

\item{out.dir}{Character.  Determines the output directory where results are
saved to.  Defaults to \code{NULL}, which then writes to
\code{rappdirs::user_data_dir("GSEABenchmarkeR")} in case \code{save2file}
is set to \code{TRUE}.}

\item{...}{Additional arguments passed to the selected enrichment methods.}
}
\value{
A list with an entry for each method applied.  Each method entry is
a list with an entry for each dataset analyzed.  Each dataset entry is a
list of length 2, with the first element being the runtime and the second
element being the gene set ranking, as obtained from applying the respective
method to the respective dataset.
}
\description{
This function evaluates the type I error rate of selected methods for 
enrichment analysis when applied to one or more expression datasets.
}
\examples{

    # loading three datasets from the GEO2KEGG compendium
    geo2kegg <- loadEData("geo2kegg", nr.datasets=3)

    # only considering the first 1000 probes for demonstration
    geo2kegg <- lapply(geo2kegg, function(d) d[1:1000,]) 

    # preprocessing and DE analysis for two of the datasets
    geo2kegg <- maPreproc(geo2kegg[2:3])
    geo2kegg <- runDE(geo2kegg)

    # getting a subset of human KEGG gene sets
    gs.file <- system.file("extdata", package="EnrichmentBrowser")
    gs.file <- file.path(gs.file, "hsa_kegg_gs.gmt") 
    kegg.gs <- EnrichmentBrowser::getGenesets(gs.file)

    # evaluating type I error rate of two methods on two datasets
    # NOTE: using a small number of permutations for demonstration;
    #       for a meaningful evaluation tI.perm should be >= 1000   
    res <- evalTypeIError(geo2kegg, methods=c("ora", 
             "camera"), gs=kegg.gs, ea.perm=0, tI.perm=3)
    

}
\seealso{
\code{\link{sbea}} and \code{\link{nbea}}
for carrying out set- and network-based enrichment analysis.

\code{\linkS4class{BiocParallelParam}} and \code{\link{register}} for
configuration of parallel computation.
}
\author{
Ludwig Geistlinger <Ludwig.Geistlinger@sph.cuny.edu>
}
