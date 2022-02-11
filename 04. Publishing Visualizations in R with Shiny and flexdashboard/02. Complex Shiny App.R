library(shiny)
library(tidyverse)
library(plotly)
library(DT)

#####Import Data

dat<-read_csv(url("https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"))
dat<- dat %>% select(c("pid7","ideo5","newsint","gender","educ","CC18_308a","region"))
dat<-drop_na(dat)

#####Make your app

ui <- navbarPage(
  title="My Application",
  tabPanel("Page 1",
             sidebarLayout(
               sidebarPanel(
                 sliderInput("my_ideo5",
                             "Select Five Point Ideology (1=Very liberal, 5=Very conservative)",
                             min=1,
                             max=5,
                             value=3)
               ),
               
               mainPanel(
                 tabsetPanel(
                   tabPanel("Tab1", plotOutput("plot1")), 
                   tabPanel("Tab2", plotOutput("plot2"))
                 )
               )
             )
  ),
  tabPanel("Page 2",
            sidebarLayout(
              sidebarPanel(
                checkboxGroupInput(inputId="my_gender",
                                   label="Select Gender",
                                   choices=c("1","2"),
                                   selected="1")
              ),
             
              mainPanel(
                plotlyOutput("plot3")

                )
              )
  ),
  tabPanel("Page 3",
           sidebarLayout(
             sidebarPanel(
               selectInput(inputId="my_region",
                           label="Select Region",
                           choices=c("1","2","3","4"),
                           multiple=TRUE)
             ),
             mainPanel(
               dataTableOutput(outputId = "table1")
             )
           )
  )
)


server<-function(input,output){
  
  output$plot1 <- renderPlot({
    
    ggplot(
      filter(dat,ideo5==input$my_ideo5),
      aes(x=pid7)) +
      geom_bar() +
      xlab("7 Point Party ID, 1=Very D, 7=Very R") +
      ylab("Count") +
      scale_x_continuous(limits=c(0,8)) +
      scale_y_continuous(limits=c(0,100))
    
  })
  
  output$plot2 <- renderPlot({
    
    ggplot(
      filter(dat,ideo5==input$my_ideo5),
      aes(x=CC18_308a)) +
      geom_bar() +
      xlab("Trump Support") +
      ylab("count") +
      scale_x_continuous(limits=c(0,5))
  
  })
  
  output$plot3 <- renderPlotly({
    
    print(ggplotly(
      ggplot(
        filter(dat,gender==input$my_gender),
        aes(x=educ,y=pid7)) +
        geom_jitter() +
        geom_smooth(method=lm)))
    
    
  })
  
  output$table1 <- renderDataTable({
    filter(dat,region %in% input$my_region)})
}

shinyApp(ui,server)