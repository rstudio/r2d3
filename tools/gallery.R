
library(whisker)

whisker_template <- readLines("tools/gallery-template.Rmd")
code_partial <- readLines("tools/code-partial.Rmd")

gallery_dirs <- list.dirs("vignettes/gallery", recursive = FALSE)
gallery_dirs_list <- iteratelist(basename(gallery_dirs), value="dir")

for (dir in gallery_dirs) {
  
  # base name
  name <- basename(dir)
  
  # preview args
  d3_script <- file.path(dir, paste0(name, ".js"))
  script_preview <- readLines(d3_script)[[1]]
  preview_args <- strsplit(script_preview, "!preview\\s+r2d3\\s+")[[1]][[2]]
  
  # code files
  list_files <- function(lang, mask = NULL) {
    files <- list.files(dir, pattern = glob2rx(paste0("*.", lang)))
    if (!is.null(mask))
      files <- files[!grepl(mask, files)]
    lapply(files, function(file) list(lang = lang, file = file))
  }
  code_files <- c(
    list_files("js", mask = glob2rx("*.min.js")),
    list_files("css")
  )
  
  # prime data
  data <- list(
    name = name,
    dirs = gallery_dirs_list,
    preview_args = preview_args,
    code_files = code_files
  )
  
  # render template
  gallery_rmd <- file.path(dir, paste0(name, ".Rmd"))
  output <- whisker.render(whisker_template, data = data, partials = list(
    code_partial = code_partial
  ))  
  cat(output, file = gallery_rmd)
}



