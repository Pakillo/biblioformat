#' Revise and Reformat a Bibliography
#'
#' Revise and reformat a list of references provided as plain text.
#' This function will try to identify their DOI (through Crossref),
#' then formatting each following the chosen output format
#' (e.g. BibTeX, or a particular journal style).
#'
#' @param refs A character vector with bibliographic references.
#' If NULL (default), will read them from the clipboard.
#' @param output Return references as plain text (output = "text") or as
#' a data.frame (output = "data.frame")
#' @param format Reference format. Either "text" (default) or
#' "bibtex" that can e.g. be later imported in a reference manager
#' @param style Output style for bibliography when \code{format} is "text".
#' Default is "apa", but any of the >9000 styles available in
#' \url{github.com/citation-style-language/styles} can be used.
#' See \code{\link[rcrossref]{cr_cn}} for details.
#' @param filename Optional. Save formatted bibliography to a text file.
#' @param ... Further arguments for \code{\link[rcrossref]{cr_cn}}.
#'
#' @return If output = "text", a character vector with revised and
#' reformatted bibliographic references. These are automatically copied to the
#' clipboard, so they can be directly pasted onto a document.
#' Optionally, if filename is provided, a text file is also saved on disk.
#' If output = "data.frame" a data.frame is returned with the input references,
#' identified DOI, and resulting citation metatada.
#' @export
#'
#' @note Some references may be changed and erroneously confounded with others.
#' Please check the output reference list.
#'
#' @examples
#' \dontrun{
#' refs <- c(
#' "Hansen et al. (2013) Climate sensitivity, sea level and atmospheric carbon dioxide",
#' "Davis, M.B. and Shaw, R.G. (2001) Science 292(5517): 673-679"
#' )
#'
#' biblioformat(refs)
#' biblioformat(refs, output = "data.frame")
#'
#' biblioformat(refs, style = "ecology-letters")
#' biblioformat(refs, format = "bibtex", filename = "myrefs.bib")
#' }
#'

biblioformat <- function(refs = NULL,
                         output = c("text", "data.frame"),
                         format = c("text", "bibtex"),
                         style = "apa",
                         filename = NULL,
                         ...) {

  output <- match.arg(output)
  format <- match.arg(format)

  if (is.null(refs)) {
    refs.in <- clipr::read_clip()
  } else {
    refs.in <- refs
  }
  stopifnot(is.character(refs.in))


  # Retrieve DOIs from Crossref
  message("Searching for DOIs...")
  refs.dois <- suppressWarnings(lapply(refs.in, function(x) {
    rcrossref::cr_works(query = x, limit = 1, sort = "score", select = "DOI")$data$doi
  }))
  ## change NULL to NA
  refs.dois <- unlist(lapply(refs.dois, function(x) {
    if (is.null(x)) {
      x <- NA_character_
    } else {
      x <- x
    }
  }))
  stopifnot(is.character(refs.dois))



  # Retrieve citations for each DOI from Crossref
  message("Retrieving citation metadata...")

  refs.cit <- unlist(lapply(refs.dois, function(x) {
      if (is.na(x)) {
        cit <- NA_character_
      } else {
        cit <- rcrossref::cr_cn(x, format = format, style = style, ...)
      }
  }))



  ## Save to disk or clipboard
  if (!is.null(filename)) {
      writeLines(refs.cit, filename)
  }
  clipr::write_clip(refs.cit, object_type = "character", allow_non_interactive = TRUE)


  if (output == "data.frame") {
    out <- data.frame(ref.in = refs.in, DOI = refs.dois, ref.out = refs.cit)
  }

  if (output == "text") {
    out <- refs.cit
  }

  out

}
