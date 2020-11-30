# Completes major version to full version
version_complete <- function(minor) {
  versions <- list(
    "6" = "6.2.0",
    "5" = "5.9.2",
    "4" = "4.13.0",
    "3" = "3.5.17"
  )

  version <- versions[[as.character(minor)]]

  if (is.null(version))
    stop("Version ", minor, " is currently unsupported.")

  version
}