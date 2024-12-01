
# biblioformat: Revise and Reformat Plain Text Bibliographies with R

This package aims to help with revising and reformatting reference lists
(bibliographies) in plain text format. It takes a reference list as
plain text, tries to retrieve DOIs and metadata from Crossref, and
reformat them according to a chosen style (e.g. BibTeX, or following a
particular journal citation style).

## Installation

``` r
install.packages("biblioformat", repos = c("https://pakillo.r-universe.dev", "https://cloud.r-project.org"))
```

## Motivation

The motivation for this package is the need to revise and/or reformat
reference lists (bibliographies) only available as plain text (e.g. at
the end of a manuscript or document). This happens e.g. when our
manuscript is rejected from a journal and we need to reformat the
bibliography and we don’t have the original bibliographic database (as
BibTeX, Mendeley, Zotero…) but only a plain text of references.

This package takes the text with references, tries to identify their
DOIs and metadata at Crossref, and outputs the revised citations in the
chosen format (BibTeX, a particular journal style…).

## Example

For example, if we have these references that we want to check (and
optionally reformat):

*Foster, G. et al. (2017) Future climate forcing potentially without
precedent in the last 420 million years.*

*Chen, I.-C. et al. (2011) Science 333, 1024-1026*

We can copy them to the clipboard or provide them as a character vector:

``` r
refs <- c(
  "Foster, G. et al. (2017) Future climate forcing potentially without precedent in the last 420 million years.",
  "Chen, I.-C. et al. (2011) Science 333, 1024-1026"
)
```

then

``` r
library(biblioformat)

newrefs <- biblioformat(refs, style = "global-ecology-and-biogeography")
#> Searching for DOIs...
#> Retrieving citation metadata...
newrefs
#> [1] "Foster, G.L., Royer, D.L. & Lunt, D.J. (2017) Future climate forcing potentially without precedent in the last 420 million years. Nature Communications, 8."                    
#> [2] "Chen, I.-C., Hill, J.K., Ohlemüller, R., Roy, D.B. & Thomas, C.D. (2011) Rapid Range Shifts of Species Associated with High Levels of Climate Warming. Science, 333, 1024–1026."
```

Note that missing titles and journals have now been corrected. We can
use \>9000 different citation styles.

The revised references are automatically copied to the clipboard, so
they can be directly pasted into the original document.

Alternatively, we can obtain the references in BibTeX format, for
further editing or importing into a reference manager

``` r
newrefs <- biblioformat(refs, format = "bibtex", filename = "myrefs.bib")
```

Note that some references may be changed and erroneously confounded with
others. Please check the output reference list.

## Acknowledgements

This package is just a wrapper of the excellent
[`rcrossref`](https://github.com/ropensci/rcrossref) package by
rOpenSci - big thanks to them!

## Related

See also <https://anystyle.io/> for an excellent free online parser of
bibliographic references (or
[Ranystyle](https://agoutsmedt.github.io/Ranystyle/) to run from R).
Also <http://cermine.ceon.pl/cermine/index.html>, and others…
