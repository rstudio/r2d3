## R CMD check results

0 errors | 0 warnings | 1 note

This fixes the bug caused by the lines `is.null(script) || length(script) == 0 || !file.exists(script)` in the `script_read()` function within `script.R`. The
potentially length > 1 vector of booleans is now reduced to a single with `any()`.
