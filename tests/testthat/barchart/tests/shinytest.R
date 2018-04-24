app <- ShinyDriver$new("../")
app$snapshotInit("shinytest")

app$setInputs(bar_max = 1)
app$snapshot()
app$setInputs(bar_max = 0.2)
app$snapshot()
