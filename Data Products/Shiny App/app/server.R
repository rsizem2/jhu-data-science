library(shiny)
shinyServer(function(input, output) {
    
    # Always include the point (0,0)
    data <- reactiveValues(x=NULL,y=NULL,k=NULL)
    
    observeEvent(input$clear, {
        #Clear Points
        data$x <- NULL
        data$y <- NULL
    })
    
    observeEvent(input$plot_click, {
        # Add Clicked Point to Plot
        data$x <- c(data$x,input$plot_click$x)
        data$y <- c(data$y,input$plot_click$y)
    })
    
    observeEvent(input$toggle,{
        # Knot Toggle
        if(is.null(data$k)){
            data$k <-input$knot
        }else{
            data$k <- NULL
        }
    })
    
    output$plot1 <- renderPlot({
        if(is.null(data$x)){
            # No points
            plot(NULL, type="n", xlab="", ylab="", 
                 main = "Click Plot Window to Add Points",
                 xlim = c(-100, 100), ylim = c(-100, 100))
        } else if (is.null(data$k)) {
            # Knot Point not Toggled
            fit <- lm(data$y ~ data$x)
            main <- "Least Squares Regression Line"
            plot(x = data$x, y = data$y, 
                 xlab = "", ylab = "", main = main,
                 xlim = c(-100, 100), ylim = c(-100, 100))
            if(length(data$x)==1){
                abline(h=data$y)
            } else {
                abline(fit)
            }
        } else {
            data$k <- input$knot
            k <- data$k
            main <- "Least Squares Regression Line w/ Spline"
            z <- (data$x > k) * data$x
            fit <- lm(data$y ~ data$x + z)
            a <- fit$coefficients[1]
            b <- fit$coefficients[2]
            c <- fit$coefficients[3]
            plot(x = data$x, y = data$y, 
                 xlab = "", ylab = "", main = main,
                 xlim = c(-100, 100), ylim = c(-100, 100))
            ya = -100*b+a
            yk = k*b+a
            yb = yk + (b+c)*(100-k)
            segments(x0=-100,y0=ya,x1=k,y1=yk)
            segments(x0=k,y0=yk,x1=100,y1=yb)
        }
       
    })
})