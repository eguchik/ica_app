library(shiny)

shinyUI(
  fluidPage(
    titlePanel("Independent component analysis"),
    sidebarLayout(
      sidebarPanel(
        fileInput("file", "csvファイルを選択してください",
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv")
        ),
        tags$hr(),
        htmlOutput("nc"),
        htmlOutput("xlim_bottom"),
        htmlOutput("xlim_top"),
        htmlOutput("ylim_bottom"),
        htmlOutput("ylim_top"),
        actionButton("submit", "プロット"),
        downloadButton("downloadData1", "Download independent components"),
        downloadButton("downloadData2", "Download mixing matrix")
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
        　　　　　　 tabPanel("Plot", plotOutput("plot")),
                    tabPanel("Table", tableOutput('table')),                   
        )
      )
    )
  )
)
