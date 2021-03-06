
library(shiny)
library(tidyverse)
library(rfishbase)

ui <- navbarPage("A very crappie fish app",
      tabPanel("fish lengths",
      sidebarLayout(
      sidebarPanel(selectInput(inputId = "fishChoices",label = "chose some fish",choices = c("Walleye","Lake trout","Yellow perch","Northern pike","Muskellunge","Burbot", "Lake sturgeon"))),
      mainPanel(plotOutput("lengthPlot"),img(src = "length.png", align = "center")))),
      tabPanel("fish weights",sidebarLayout(sidebarPanel(selectInput(inputId = "fishChoices2",label = "chose some fish",choices = c("Walleye","Lake trout",
      "Yellow perch","Northern pike","Muskellunge","Burbot","Lake sturgeon"))),mainPanel(plotOutput("weightPlot"),img(src = "mass.png", align = "center")))))
server <- function(input, output) {
  output$lengthPlot <- renderPlot({
              List <- data.frame(Species = c("Sander vitreus","Salvelinus namaycush","Perca flavescens", "Esox lucius","Esox masquinongy","Lota lota","Acipenser fulvescens"),
              Common_Name = c("Walleye","Lake trout","Yellow perch","Northern pike","Muskellunge", "Burbot","Lake sturgeon")) 
              fish <- popgrowth()
              numbers <-  List %>%left_join(fish, by = "Species") %>%group_by(Species) %>%
              mutate(lAsym = mean(TLinfinity, na.rm = TRUE),k = mean(K, na.rm = TRUE),t0 = mean(to, na.rm = TRUE),tmax = round(mean(tmax, na.rm = TRUE))) %>%select(Species, Common_Name, lAsym, k, t0, tmax) %>%distinct()
              Walleye <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Walleye"]), Common_Name = "Walleye")
              Walleye$Length <- numbers$lAsym[numbers$Common_Name == "Walleye"]*(1-exp(-numbers$k[numbers$Common_Name == "Walleye"]*(Walleye$Age - numbers$t0[numbers$Common_Name == "Walleye"])))
              Perch <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Yellow perch"]), Common_Name = "Yellow perch")
              Perch$Length <- numbers$lAsym[numbers$Common_Name == "Yellow perch"]*(1-exp(-numbers$k[numbers$Common_Name == "Yellow perch"]*(Perch$Age - numbers$t0[numbers$Common_Name == "Yellow perch"])))
              Trout <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Lake trout"]), Common_Name = "Lake trout")
              Trout$Length <- numbers$lAsym[numbers$Common_Name == "Lake trout"]*(1-exp(-numbers$k[numbers$Common_Name == "Lake trout"]*(Trout$Age - numbers$t0[numbers$Common_Name == "Lake trout"])))
              Pike <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Northern pike"]), Common_Name = "Northern pike")
              Pike$Length <- numbers$lAsym[numbers$Common_Name == "Northern pike"]*(1-exp(-numbers$k[numbers$Common_Name == "Northern pike"]*(Pike$Age - numbers$t0[numbers$Common_Name == "Northern pike"])))
              Muskellunge <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Muskellunge"]), Common_Name = "Muskellunge")
              Muskellunge$Length <- numbers$lAsym[numbers$Common_Name == "Muskellunge"]*(1-exp(-numbers$k[numbers$Common_Name == "Muskellunge"]*(Muskellunge$Age - numbers$t0[numbers$Common_Name == "Muskellunge"])))
              Burbot <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Burbot"]), Common_Name = "Burbot")
              Burbot$Length <- numbers$lAsym[numbers$Common_Name == "Burbot"]*(1-exp(-numbers$k[numbers$Common_Name == "Burbot"]*(Burbot$Age - numbers$t0[numbers$Common_Name == "Burbot"])))
              Sturgeon <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Lake sturgeon"]), Common_Name = "Lake sturgeon")
              Sturgeon$Length <- numbers$lAsym[numbers$Common_Name == "Lake sturgeon"]*(1-exp(-numbers$k[numbers$Common_Name == "Lake sturgeon"]*(Sturgeon$Age - numbers$t0[numbers$Common_Name == "Lake sturgeon"])))
              fish <- do.call(rbind, list(Walleye, Perch, Trout, Pike, Muskellunge, Burbot, Sturgeon)) 
              graphFish <- fish %>% filter(Common_Name == input$fishChoices)
              ggplot(graphFish) +geom_line(aes(x = Age, y = Length, group = Common_Name, color = Common_Name)) +theme_bw()})
              output$weightPlot <- renderPlot({List <- data.frame(Species = c("Sander vitreus","Salvelinus namaycush","Perca flavescens", "Esox lucius","Esox masquinongy","Lota lota","Acipenser fulvescens"),
              Common_Name = c("Walleye","Lake trout","Yellow perch","Northern pike","Muskellunge", "Burbot","Lake sturgeon")) 
              fish <- popgrowth() %>% select(Species,TLinfinity,K,to,tmax)
              fish2 <- length_weight() %>% select(Species,a,b)
              numbers <-  List %>%left_join(fish) %>% left_join(fish2) %>%group_by(Species) %>%
              mutate(lAsym = mean(TLinfinity,na.rm=TRUE),k=mean(K,na.rm=TRUE),t0=mean(to,na.rm=TRUE),tmax = round(mean(tmax,na.rm=TRUE)),a=mean(a,na.rm=TRUE),b=mean(b,na.rm=TRUE))%>%
              select(Species, Common_Name, lAsym, k, t0, tmax, a, b) %>%distinct()
              Walleye <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Walleye"]), Common_Name = "Walleye")
              Walleye$Length <- numbers$lAsym[numbers$Common_Name == "Walleye"]*(1-exp(-numbers$k[numbers$Common_Name == "Walleye"]*(Walleye$Age - numbers$t0[numbers$Common_Name == "Walleye"])))
              Walleye$mass <- numbers$a[numbers$Common_Name == "Walleye"]*Walleye$Length^numbers$b[numbers$Common_Name == "Walleye"]
              Perch <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Yellow perch"]), Common_Name = "Yellow perch")
              Perch$Length <- numbers$lAsym[numbers$Common_Name == "Yellow perch"]*(1-exp(-numbers$k[numbers$Common_Name == "Yellow perch"]*(Perch$Age - numbers$t0[numbers$Common_Name == "Yellow perch"])))
              Perch$mass <- numbers$a[numbers$Common_Name == "Yellow perch"]*Perch$Length^numbers$b[numbers$Common_Name == "Yellow perch"]
              Trout <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Lake trout"]), Common_Name = "Lake trout")
              Trout$Length <- numbers$lAsym[numbers$Common_Name == "Lake trout"]*(1-exp(-numbers$k[numbers$Common_Name == "Lake trout"]*(Trout$Age - numbers$t0[numbers$Common_Name == "Lake trout"])))
              Trout$mass <- numbers$a[numbers$Common_Name == "Lake trout"]*Trout$Length^numbers$b[numbers$Common_Name == "Lake trout"]
              Pike <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Northern pike"]), Common_Name = "Northern pike")
              Pike$Length <- numbers$lAsym[numbers$Common_Name == "Northern pike"]*(1-exp(-numbers$k[numbers$Common_Name == "Northern pike"]*(Pike$Age - numbers$t0[numbers$Common_Name == "Northern pike"])))
              Pike$mass <- numbers$a[numbers$Common_Name == "Northern pike"]*Pike$Length^numbers$b[numbers$Common_Name == "Northern pike"]
              Muskellunge <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Muskellunge"]), Common_Name = "Muskellunge")
              Muskellunge$Length <- numbers$lAsym[numbers$Common_Name == "Muskellunge"]*(1-exp(-numbers$k[numbers$Common_Name == "Muskellunge"]*(Muskellunge$Age - numbers$t0[numbers$Common_Name == "Muskellunge"])))
              Muskellunge$mass <- numbers$a[numbers$Common_Name == "Muskellunge"]*Muskellunge$Length^numbers$b[numbers$Common_Name == "Muskellunge"]
              Burbot <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Burbot"]), Common_Name = "Burbot")
              Burbot$Length <- numbers$lAsym[numbers$Common_Name == "Burbot"]*(1-exp(-numbers$k[numbers$Common_Name == "Burbot"]*(Burbot$Age - numbers$t0[numbers$Common_Name == "Burbot"])))
              Burbot$mass <- numbers$a[numbers$Common_Name == "Burbot"]*Burbot$Length^numbers$b[numbers$Common_Name == "Burbot"]
              Sturgeon <- data.frame(Age = seq(0:numbers$tmax[numbers$Common_Name == "Lake sturgeon"]), Common_Name = "Lake sturgeon")
              Sturgeon$Length <- numbers$lAsym[numbers$Common_Name == "Lake sturgeon"]*(1-exp(-numbers$k[numbers$Common_Name == "Lake sturgeon"]*(Sturgeon$Age - numbers$t0[numbers$Common_Name == "Lake sturgeon"])))
              Sturgeon$mass <- numbers$a[numbers$Common_Name == "Lake sturgeon"]*Sturgeon$Length^numbers$b[numbers$Common_Name == "Lake sturgeon"]
              fish <- do.call(rbind, list(Walleye, Perch, Trout, Pike, Muskellunge, Burbot, Sturgeon)) 
              graphFish <- fish %>% filter(Common_Name == input$fishChoices)
              ggplot(graphFish) +geom_line(aes(x = Length, y = mass, group = Common_Name, color = Common_Name)) +theme_bw()})}
shinyApp(ui = ui, server = server)
