library(shiny)
library(tidyverse)

#####Import Data

dat<-read_csv(url("https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"))
dat<- dat %>% select(c("pid7","ideo5"))
dat<-drop_na(dat)

ui<- fluidPage(
  
  titlePanel("Plot of Political Party ID by Ideology"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("my_ideo5",
                  "Ideology (1=very liberal, 5=very conservative):",
                  min=1,
                  max=5,
                  value=1)
    ),
    
    mainPanel(plotOutput("ideo5_barplot")
    )
  )
)
  

server<-function(input,output){
  
  output$ideo5_barplot <- renderPlot({
    
    ggplot(
      filter(dat,ideo5==input$my_ideo5),
      aes(x=pid7))+geom_bar()+xlab("7 Point Party ID (1=Strong Democrat, 7=Strong Republican)")+ylab("Count")+scale_x_continuous(breaks = seq(1, 7, 1))
    
  })
  
}

shinyApp(ui,server)
