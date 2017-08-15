# Shiny dashboard app UI code.

library(shinydashboard)
library(leaflet)

# Define the header.
header = dashboardHeader(title = "eusocial-viz")

# Define the sidebar.
sidebar = dashboardSidebar(hr(),
                           sidebarMenu(
                             id = "tabs",
                             menuItem(
                               "Coropleth plot",
                               tabName = "coroplot",
                               icon = icon("map"),
                               selected = TRUE
                             ),
                             menuItem(
                               "Timeseries plot",
                               tabName = "tsplot",
                               icon = icon("line-chart")
                             ),
                             menuItem(
                               "Model",
                               tabName = "model",
                               icon = icon("file-text-o")),
                             menuItem(
                               "Links and further info",
                               tabName = "links",
                               icon = icon("mortar-board")
                             ),
                             menuItem("About",
                                      tabName = "about",
                                      icon = icon("question"))
                           ))

# Define the body.
body = dashboardBody(
  tabItems(
    tabItem(tabName = "coroplot",
      fluidRow(
        column(width = 12,
          box(width = NULL,
              leafletOutput("coroplot",
                            height = "500px"),
              collapsible = FALSE,
              title = "Unemployment in the EU by NUTS 2013 regions",
              status = "primary",
              solidHeader = TRUE)
        )
      ),
      fluidRow(
        column(width = 4,
               box(width = NULL,
                   height = 230,
                   status = "warning",
                   h4("Age group"),
                   hr(),
                   radioButtons("radioage",
                                label = NULL,
                                choices = list(">= 25 years" = "Y_GE25",
                                               "15-24 years" = "Y15-24",
                                               "20-64 years" = "Y20-64",
                                               ">= 15 years" = "Y_GE15"),
                                selected = "Y_GE25"),
                   p (
                     class = "text-muted",
                     paste("Select the wanted age group.")
                   )
               )
        ),
        column(width = 4,
               box(width = NULL,
                   height = 230,
                   status = "warning",
                   h4("Gender"),
                   hr(),
                   radioButtons("radiosex",
                                label = NULL,
                                choices = list("Total" = "T",
                                               "Males" = "M",
                                               "Females" = "F"),
                                selected = "T"),
                   p (
                     class = "text-muted",
                     paste("Use this to select a gender, or 'Total' for a summary.")
                   )
               )
        ),
        column(width = 4,
               box(width = NULL,
                   height = 230,
                   status = "warning",
                   h4("Year"),
                   hr(),
                   # FIXME: Must be a more efficient way to generate this.
                   selectInput("year",
                               label = NULL,
                               choices = c(
                                 "1999" = "1999",
                                 "2000" = "2000",
                                 "2001" = "2001",
                                 "2002" = "2002",
                                 "2003" = "2003",
                                 "2004" = "2004",
                                 "2005" = "2005",
                                 "2006" = "2006",
                                 "2007" = "2007",
                                 "2008" = "2008",
                                 "2009" = "2009",
                                 "2010" = "2010",
                                 "2011" = "2011",
                                 "2012" = "2012",
                                 "2013" = "2013",
                                 "2014" = "2014",
                                 "2015" = "2015",
                                 "2016" = "2016"
                               ),
                               selected = "2010"
                   ),
                   p (
                     class = "text-muted",
                     paste("Note: Note all countries have made data available for all years.")
                   )
               )
        )
    )),

    tabItem(tabName = "tsplot",
      fluidRow(
        column(width = 12,
               box(width = NULL,
                   plotOutput("tsplot",
                              height = "500px"),
                   collapsible = FALSE,
                   title = "EU Unemployment Time Series Plots",
                   status = "primary",
                   solidHeader = TRUE)
                )
      ),
      fluidRow(
          column(width = 4,
                 box(width = NULL,
                     height = 230,
                     status = "warning",
                     h4("Age group"),
                     hr(),
                     radioButtons("radioage",
                                  label = NULL,
                                  choices = list(">= 25 years" = "Y_GE25",
                                                 "15-24 years" = "Y15-24",
                                                 "20-64 years" = "Y20-64",
                                                 ">= 15 years" = "Y_GE15"),
                                  selected = "Y_GE25"),
                     p (
                       class = "text-muted",
                       paste("Select the wanted age group.")
                     )
                 )
          ),
          column(width = 4,
                 box(width = NULL,
                     height = 230,
                     status = "warning",
                     h4("Gender"),
                     hr(),
                     radioButtons("radiosex",
                                  label = NULL,
                                  choices = list("Total" = "T",
                                                 "Males" = "M",
                                                 "Females" = "F"),
                                  selected = "T"),
                     p (
                       class = "text-muted",
                       paste("Use this to select a gender, or 'Total' for a summary.")
                     )
                 )
          ),
          column(width = 4,
                 box(width = NULL,
                     height = 230,
                     status = "warning",
                     h4("Year"),
                     hr(),
                     # FIXME: Must be a more efficient way to generate this.
                     selectInput("year",
                                 label = NULL,
                                 choices = c(
                                   "1999" = "1999",
                                   "2000" = "2000",
                                   "2001" = "2001",
                                   "2002" = "2002",
                                   "2003" = "2003",
                                   "2004" = "2004",
                                   "2005" = "2005",
                                   "2006" = "2006",
                                   "2007" = "2007",
                                   "2008" = "2008",
                                   "2009" = "2009",
                                   "2010" = "2010",
                                   "2011" = "2011",
                                   "2012" = "2012",
                                   "2013" = "2013",
                                   "2014" = "2014",
                                   "2015" = "2015",
                                   "2016" = "2016"
                                 ),
                                 selected = "2010"
                     ),
                     p (
                       class = "text-muted",
                       paste("Note: Note all countries have made data available for all years.")
                     )
                 )
          )
        )
    ),
    tabItem(tabName = "links",
            includeMarkdown("links.Rmd")),
    tabItem(tabName = "about",
            includeMarkdown("about.Rmd"))
  ))


# Build the dashboard app.
dashboardPage(header,
              sidebar,
              body
)