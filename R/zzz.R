.onAttach <- function(...) {
  
  if (requireNamespace("knitr", quietly = TRUE)) {
    knit_engines <- get("knit_engines", envir = asNamespace("knitr"))
    knit_engines$set(d3 = knit_d3)
  }
  
  rstudio <- rstudio_version()
  if (!is.null(rstudio)) {
    
    # check for desktop mode on windows and linux (other modes are fine)
    if (!is_osx() && (rstudio$mode == "desktop")) {
      
      if (rstudio$version < "1.2.637")
        packageStartupMessage(
          "r2d3 should be run under RStudio v1.2 or higher. Please update at:\n",
          "https://www.rstudio.com/rstudio/download/preview/\n"
        )
    }
  }
}

# get the current rstudio version and mode (desktop vs. server)
rstudio_version <- function() {
  
  # Running at the RStudio console
  if (rstudioapi::isAvailable()) {
    
    rstudioapi::versionInfo()
    
    # Running in a child process
  } else if (!is.na(Sys.getenv("RSTUDIO", unset = NA))) {
    
    # detect desktop vs. server using server-only environment variable
    mode <- ifelse(is.na(Sys.getenv("RSTUDIO_HTTP_REFERER", unset = NA)),
                   "desktop", "server")
    
    # detect version using Rmd new env var added in 1.2.638
    version <- Sys.getenv("RSTUDIO_VERSION", unset = "1.1")
    
    # return version info
    list(
      mode = mode,
      version = version
    )
    
    # Not running in RStudio
  } else {
    NULL
  }
}

is_osx <- function() {
  Sys.info()["sysname"] == "Darwin"
}


