# Completes major version to full version
version_complete <- function(minor) {
  versions <- list(
    "5" = "5.0.0",
    "4" = "4.13.0"
  )
  
  version <- versions[[as.character(minor)]]
  
  if (is.null(version))
    stop("Version ", minor, " is currently unsupported.")

  version
}