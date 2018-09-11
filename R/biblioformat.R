#' Revise and Reformat a Bibliography
#'
#' Revise and reformat a list of references provided as plain text. This function will try to identify their DOI (through Crossref), then formatting each following the chosen output format (e.g. BibTeX, or a particular journal style).
#'
#' @param refs A character vector with bibliographic references. If NULL (default), will read them from the clipboard.
#' @param format Output format. Default is "text". Alternatively, choose "bibtex" for extracting references that can e.g. be later imported in a reference manager. See \code{\link[rcrossref]{cr_cn}} for all output formats available.
#' @param style Output style for bibliography when \code{format} is "text". Default is "apa", but any of the >9000 styles available in \url{github.com/citation-style-language/styles} can be used. See \code{\link[rcrossref]{cr_cn}} for details.
#' @param filename Optional. Save formatted bibliography to a file.
#' @param ... Further arguments for \code{\link[rcrossref]{cr_cn}}.
#'
#' @return A character vector with revised and reformatted bibliographic references. These are automatically copied to the clipboard, so they can be directly pasted onto a document. Optionally, also a text file saved on disk.
#' @export
#' @importFrom clipr read_clip write_clip
#' @importFrom rcrossref cr_works cr_cn
#'
#' @note Some references may be changed and erroneously confounded with others. Please check the output reference list.
#'
#' @examples
#' \dontrun{
#' refs <- c(
#' "Hansen, J. et al. (2013) Climate sensitivity, sea level and atmospheric carbon dioxide. Phil. Trans. R. Soc. A. 371: 20120294.",
#' "Davis, M.B. and Shaw, R.G. (2001) Range shifts and adaptive responses to Quaternary climate change. Science 292(5517): 673-679."
#' )
#'
#' newrefs <- biblioformat(refs)
#' newrefs
#'
#' newrefs <- biblioformat(refs, style = "ecology-letters")
#' newrefs <- biblioformat(refs, format = "bibtex", filename = "myrefs.bib")
#'
#' }
#'
#'
biblioformat <- function(refs = NULL, format = "text", style = "apa", filename = NULL, ...) {

  if (is.null(refs)) {
    refs.in <- clipr::read_clip()
  } else refs.in <- refs

  stopifnot(is.character(refs.in))

  # Retrieve DOIs from Crossref
  refs.dois <- unlist(lapply(refs.in, function(x) {
    rcrossref::cr_works(query = x, limit = 1, sort = "score", select = "DOI")$data$doi
  }))

  stopifnot(is.character(refs.dois))

  # Retrieve citations for each DOI from Crossref
  refs.cit <- unlist(rcrossref::cr_cn(refs.dois, format = format, style = style, ...))

  if (!is.null(filename)) writeLines(refs.cit, filename)

  clipr::write_clip(refs.cit, object_type = "character")

  invisible(refs.cit)

}
