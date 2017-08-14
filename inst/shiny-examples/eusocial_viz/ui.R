navbarPage(
  "EusocialViz",
  tabPanel("Coropleth map",
           sidebarLayout(
             sidebarPanel(radioButtons(
               "plotType", "Plot type",
               c("Scatter" = "p", "Line" = "l")
             )),
             mainPanel(plotOutput("plot"))
           )),
  tabPanel("Comparative plot",
           verbatimTextOutput("comparative plot")),
  tabPanel("Models",
           verbatimTextOutput("models")),
  navbarMenu(
    "More",
    tabPanel("Data sources and links",
             verbatimTextOutput("source")),
    tabPanel("About",
             verbatimTextOutput("source"))
  )
)
