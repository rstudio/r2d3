
library(htmltools)

# Generate HTML for a 3-wide bootstrap thumbnail
thumbnail <- function(title, img, href, caption = TRUE) {
  div(class = "col-sm-3",
      a(class = "thumbnail", title = title, href = href,
        img(src = img),
        div(class = ifelse(caption, "caption", ""),
          ifelse(caption, title, "")
        )
      )
  )
}

# Generate HTML for several rows of 4-wide bootstrap thumbnails 
thumbnails <- function(thumbs) {
  
  # capture arguments and setup rows to return
  numThumbs <- length(thumbs)
  fullRows <- numThumbs / 4
  rows <- tagList()
  
  # add a row of thumbnails
  addRow <- function(first, last) {
    rows <<- tagAppendChild(rows, div(class = "row", thumbs[first:last]))
  }
  
  # handle full rows
  for (i in 1:fullRows) {
    last <- i * 4
    first <- last-3
    addRow(first, last)
  }
  
  # check for leftovers
  leftover <- numThumbs %% 4
  if (leftover > 0) {
    last <- numThumbs
    first <- last - leftover + 1
    addRow(first, last)
  }
  
  # return the rows!
  rows
}

# Generate HTML for gallery
examples <- function(examples = "auto", caption = TRUE) {
  
  # read examples into data frame (so we can easily sort/filter/etc)
  if (examples == "auto")
    examples <- list.dirs("gallery", recursive = FALSE, full.names = FALSE)
  examples <- data.frame(
    title = examples,
    img = file.path("images", paste0(examples, "_thumbnail.png")),
    href = file.path("gallery", paste0(examples, "/")),
    stringsAsFactors = FALSE
  )
  
  # convert to list for thumbnail generation
  examples <- apply(examples, 1, function(r) { 
    list(title = r["title"],
         img = r["img"],
         href = r["href"]) 
  })
  
  thumbnails(lapply(examples, function(x) {
    thumbnail(title = x$title, 
              img = x$img, 
              href = x$href, 
              caption = caption)
  }))
}


