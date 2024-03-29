# Creating objects with DiagrammeR, mermaid, and grViz")

test_that("htmlwidgets object can be created", {

  diagrammer_htmlwidget <-
    DiagrammeR("
  graph LR
    A-->B
    A-->C
    C-->E
    B-->D
    C-->D
    D-->F
    E-->F")

  # Expect that the object inherits
  # from `DiagrammeR` and `htmlwidget`
  expect_s3_class(
    diagrammer_htmlwidget, c("DiagrammeR", "htmlwidget"))

  mermaid_htmlwidget <-
    mermaid("
  graph LR
    A-->B
    A-->C
    C-->E
    B-->D
    C-->D
    D-->F
    E-->F")

  # Expect that the object inherits
  # from `DiagrammeR` and `htmlwidget`
  expect_s3_class(
    mermaid_htmlwidget, c("DiagrammeR", "htmlwidget"))
})
