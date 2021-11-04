
library(whisker)

whisker_template <- readLines("tools/gallery-template.Rmd")
code_partial <- readLines("tools/code-partial.Rmd")

gallery_dirs <- list.dirs("vignettes/gallery", recursive = FALSE)
gallery_dirs_list <- iteratelist(basename(gallery_dirs), value="dir")

create_thumbnail <- function(data) {
  current_dir <- getwd()
  on.exit(setwd(current_dir))
  
  setwd(file.path("vignettes/gallery", data$name))
  
  render_script <- paste(data$name, ".js", sep = "")

  render_command <- paste(
    "r2d3::r2d3(",
    data$preview_args,
    ", script = \"",
    render_script,
    "\", sizing = htmlwidgets::sizingPolicy(browser.fill = TRUE, padding = 0)",
    ")",
    sep = ""
  )
  
  renderer <- parse(text = render_command)
  
  widget <- eval(renderer)
  
  render_dir <- tempfile()
  dir.create(render_dir)
  render_file <- file.path(normalizePath(render_dir), "index.html")
  
  htmlwidgets::saveWidget(widget, render_file)
  
  webshot_url <- paste("file://", render_file, sep = "")
  webshot_target <-  paste("../../images/", data$name, "_thumbnail.png", sep = "")
  webshot::webshot(
    webshot_url,
    webshot_target,
    vwidth = 692,
    vheight = 474,
    delay = 3
  )
  
  root_target <- paste("../../../docs/articles/images/", data$name, "_thumbnail.png", sep = "")
  file.copy(
    webshot_target,
    root_target,
    overwrite = TRUE
  )
}

for (dir in gallery_dirs) {
  message("Processing: ", basename(dir))
  
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
    main_js <- paste0(name, ".js")
    if (main_js %in% files)
      files <- unique(c(main_js, files))
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
  gallery_rmd <- file.path(dir, "index.Rmd")
  output <- whisker.render(whisker_template, data = data, partials = list(
    code_partial = code_partial
  ))
  cat(output, "\n", file = gallery_rmd)

  # create thumbnail
  create_thumbnail(data)
}



