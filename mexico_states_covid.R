### COVID Cases Map of Mexican States ###
### Written by Lance R. Owen (c)
### Originally written January 31, 2021; Revised June 24, 2021

#install.packages(c("tmap", "sp", "geojsonio", "stringr"))
library(tmap)
library(sp)
library(geojsonio)
library(stringr)

font <- "serif"

mex <- geojson_read('https://raw.githubusercontent.com/lancerowen23/R_User_Group/main/Estados_Mexico.json', what = "sp")
df <- read.csv('https://raw.githubusercontent.com/lancerowen23/R_User_Group/main/Mexico_Cases_June22.csv')
state_codes <- read.csv('https://raw.githubusercontent.com/lancerowen23/R_User_Group/main/mexico_states_abbrv.csv')
world <- topojson_read('https://raw.githubusercontent.com/lancerowen23/R_User_Group/main/world_admin0.json')

#Convert state names from all caps to proper case and rename field Estado for clarity.
df$nombre <- str_to_title(df$nombre)
#Create new field of total cases
df$Total_Cases <- rowSums(df[,4:543])
#Import and merge csv of state abbreviations.
df_merge <- merge(df, state_codes, by.x="nombre", by.y="Estado")
#Subset to have only name and total cases in the data frame.
df_final <- df_merge[c("nombre", "Abbrev", "Total_Cases")]
#fix NA in abbreviation for Nayarit
df_final[18,2] <- "NA"

#merge data to Mexico geojson
mex_data <- merge(mex, df_final, by.x="ADMIN_NAME", by.y="nombre")

#subset background countries
bg <- world[world$GEOUNIT %in% c("United States of America", 
                                 "Belize", 
                                 "Guatemala", 
                                 "Honduras", 
                                 "Nicaragua"),]

#create background layer in light grey
background <- tm_shape(bg, 
                       bbox = st_bbox(mex_data) + 
  tm_fill(palette = "grey60")  +
  tm_borders(col = "grey90",
             lwd = .5)

#set variable for bounding box dimension matching data extent
bbox_mex <- st_bbox(mex_data)

#compile final map
final_map <- tm_shape(mex_data) + 
  tm_fill("Total_Cases",
          n=6, 
          style = "jenks", 
          palette = c("#FFE7CF", "#F03B20"),
          title = "Cumulative Cases")  +
  tm_borders(col = "grey90",
            lwd = .5)+
  tm_layout(title = "   MEXICO | COVID-19 Cases ",
          bg.color = "#BBD7E5",
          title.fontfamily = font,
          title.fontface = "plain",
          title.color = "grey90",
          title.bg.color = "#324C63",
          title.bg.alpha = .8,
          title.position = c('.57','.96'),
          title.size = 1.5,
          legend.format = list(text.separator = "-"),
          legend.text.fontfamily = font,
          legend.text.size = .8,
          legend.text.color = "grey20",
          legend.text.fontface = "plain",
          legend.title.fontfamily = font,
          legend.title.fontface = "plain",
          legend.title.size = 1.25,
          legend.title.color = "grey10",
          legend.position = c(.02, .1)) +
    tm_credits("Source: Secretaría de Salud de Mexico | Data as of 22 June 2021.", 
          position=c(".02", ".01"),
          fontfamily = font,
          col = "Grey30",
          size = .8) +
    tm_text("Abbrev",
          fontfamily = font,
          fontface = "bold",
          size = .7,
          col = "grey40",
          shadow = FALSE,
          auto.placement = FALSE,
          remove.overlap = TRUE) +
    tm_compass(north = 0,
          type = "arrow",
          text.size = 1,
          show.labels = 0,
          size = 1,
          text.color = "grey40",
          color.dark = "grey40",
          color.light = "grey90",
          position = c(.02, .90)) +
  tm_scale_bar(width = .25,
          text.size = 0.7,
          text.color = "grey30",
          color.dark = "grey40",
          color.light = "grey90",
          lwd = .5,
          position = c(.62, .005)) +
  background

final_map
