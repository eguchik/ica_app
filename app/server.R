library(ica)
library(colorspace)

server = function(input, output, session) {
  observeEvent(input$file, {

    csv_file <- reactive(read.csv(input$file$datapath, fileEncoding="UTF-8-BOM"))

    output$nc <- renderUI({ 
      selectInput("nc", "分解する成分の数", choices=1:5, selected=3)
    })
    output$xlim_bottom <- renderUI({ 
      selectInput("xlim_bottom", "xlim_bottom", choices=190:900, selected=325)
    })
    output$xlim_top <- renderUI({ 
      selectInput("xlim_top", "xlim_top", choices=190:900, selected=700)
    })
    output$ylim_bottom <- renderUI({ 
      textInput("ylim_bottom", "y-axis limit (bottom)", value=-5)
    })
    output$ylim_top <- renderUI({ 
      textInput("ylim_top", "y-axis limit (top)", value=5)
    })
  })

  observeEvent(input$submit, {
    csv_file <- reactive(read.csv(input$file$datapath, fileEncoding="UTF-8-BOM"))
    xlim_bottom <- as.numeric(input$xlim_bottom)
    xlim_top <- as.numeric(input$xlim_top)
    data <- csv_file()[csv_file()[, 1] >= 325 & csv_file()[, 1] <= 700,]
    wavelength <- data[, 1]
    spectra <- data[, 2:ncol(data)]
    nc <- as.numeric(input$nc)
    ylim_bottom <- as.numeric(input$ylim_bottom)
    ylim_top <- as.numeric(input$ylim_top)

    # execute indepent component analysis
    a <- icafast(spectra, nc)
    ics <- cbind(wavelength, a$S)
    m <- a$M

    output$table <- renderTable(ics, digits=10)
    output$plot <- renderPlot({
      palette <- rainbow_hcl(ncol(ics), c=90, l=60)
      for (i in seq(1:ncol(ics))) {
        plot(wavelength, ics[, i], type='l', xlim=c(xlim_bottom, xlim_top), ylim=c(ylim_bottom, ylim_top), xlab='x', ylab='y', col=palette[i], lwd=2)
        par(new=T)
      }
    })  

    output$downloadData1 <- downloadHandler(
      filename = function() {
        name <- substr(input$file, start=1, stop=nchar(input$file)-4)
        paste0(name, '_ics.csv', sep="")
      },
      content = function(file) {
        write.csv(ics, file, row.names=FALSE)
      }
    )
    output$downloadData2 <- downloadHandler(
      filename = function() {
        name <- substr(input$file, start=1, stop=nchar(input$file)-4)
        paste0(name, '_m.csv', sep="")
      },
      content = function(file) {
        write.csv(m, file, row.names=FALSE)
      }
    )
  })
}
