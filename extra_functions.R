#Source the following project functions on startup
if (!require("pacman")) install.packages("pacman")
if (!require("XLConnectJars")) install.packages("XLConnectJars")
if (!require("RefManageR")) install.packages('RefManageR')
devtools::install_github(
    c("ramnathv/slidify@dev",
    "ramnathv/slidifyLibraries@dev",
    "rstudio/rmarkdown",
    "trinker/reports")
)
library(RefManageR)
library(reports)

knitr::knit2html("REPORT/curriculum_vitae_tyler_rinker.RMd", 
    "REPORT/curriculum_vitae_tyler_rinker.html")

x <- file.path(getwd(), "REPORT/curriculum_vitae_tyler_rinker.html")
convert <- function(html = x, open = TRUE, rm = FALSE) {
    html_in <- readLines(html)
    ## remove the old head
    headless <- html_in[which(grepl("</head>", html_in)): length(html_in)]
    ## Insert the new head
    new_head <- c("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">",
        "<html xmlns=\"http://www.w3.org/1999/xhtml\">", "<head>", 
        "<script src='C:/R/R-3.0.0/library/rCharts/libraries/polycharts/js/polychart2.standalone.js' type='text/javascript'></script>",
        "<script src='js/polychart2.standalone.js' type='text/javascript'></script>",
    	"<link rel=\"stylesheet\" href=\"css/reset.css\" />",
        "<link rel=\"stylesheet\" href=\"css/scianimator.css\" />",
        "<link rel=\"stylesheet\" href=\"css/shCore.css\" />",
        "<link rel=\"stylesheet\" href=\"css/shThemeDefault.css\" />",
        "<script src=\"js/jquery-1.4.4.min.js\"></script>",
        "<script src=\"js/jquery.scianimator.min.js\"></script>",
        "<script src=\"js/shCore.js\"></script>",
        "<script src=\"js/shAutoloader.js\"></script>",    			  
        "<link rel=\"stylesheet\" href=\"css/style.css\">")
    ## Switch out page dividers
	if (rm) {
	    out <- c( "", "", "", "", "", "", "", "")		
	} else {
	    out <- c( "<div class=\"hangingindent\">", "</div>", 
    	    "<div class=\"containertitle\">", "</div>", "</div>", 
    	    "<p class=\"tab\">", "<p class=\"block\">", "c")
	}
		
	
    headless <- reports:::mgsub(c("<p>\\RS</p>", "<p>\\RE</p>", 
    	    "<p>\\TS</p>", "<p>\\PE</p>", "<p>\\TE</p>", "<p>\\IN","<p>\\BL", 
    		"CCC"), out, headless)

   
    ## Count page numbers and insert running header
    reps <- which(grepl("<p>\\PS</p>", headless, fixed=TRUE))
    #lens <- seq_along(reps) + 1
    #headless[reps] <- paste0("<div class=\"container\"><p><br><br><br> REDESIGNING RESEARCH ", 
    #    paste(rep("&nbsp;", 124), collapse=""), lens, "</br></br></p>")
    headless[reps] <- "<div class=\"container\"><p><br><br><br></p>"
    	   	   
    ## Write it out to the html file
    cat(paste(c(new_head, headless), collapse="\n"), file=html)
    if (open) shell.exec(html)
    message("file converted!")
}

myloc <- switch(Sys.info()[["user"]],
        Tyler = "C:/Users/Tyler",
    	trinker = "C:/Users/trinker",
        message("Computer name not found")
    )

relocate <- function(theloc = myloc){
	loc1 <- file.path(theloc, "GitHub/trinker.github.com/curriculum_vitae")
    loc2 <- file.path(theloc, "GitHub/trinker.github.com/card")
	cv1 <- "REPORT/curriculum_vitae_tyler_rinker.html"
    cv2 <- "REPORT/curriculum_vitae_tyler_rinker.pdf"
	reports::delete(file.path(loc2, "curriculum_vitae_tyler_rinker.pdf"))
    file.copy(cv1, loc1)
	file.copy(cv1, loc2)
	file.copy(cv2, loc1)
	file.copy(cv2, loc2)
	file.copy("README.md", loc1)	
	file.copy("README.md", loc2)
	file.rename(file.path(loc1, "curriculum_vitae_tyler_rinker.html"),
		file.path(loc1, "index.html"))
	file.rename(file.path(loc2, "curriculum_vitae_tyler_rinker.html"),
		file.path(loc2, "curriculum_vitae.html"))	
    file.copy("icons", loc1,recursive = TRUE)
	file.copy("icons", loc2, recursive = TRUE)	
	
}

convert()
relocate()
