rm(list = ls())
df.map <- read_csv2("data/Plug-in_Electric_Light_Vehicle_Registrations_and_Population_by_State.csv")
df.states <- read_csv("data/states.csv")

# Variable names
names(df.map) <- tolower(names(df.map))
names(df.states) <- tolower(names(df.states))

## Left Join
df.map <- merge(df.map, df.states, by="state", all.x=TRUE)

i1 <- ichoropleth(percentage ~ abbreviation, data = df.map, ncuts = 5,
                  geographyConfig=list(popupTemplate="#!function(geo, data) {
                                       return '<div class=\"hoverinfo\"><strong>' +
                                       data.state +
                                       '</strong><br>' + data.percentage+' %'+
                                       '</div>';}!#"))
i1$show("iframesrc", cdn = TRUE)                                       
i1$save("html/choropleth_perc.html", cdn = TRUE)


i2 <- ichoropleth(population ~ abbreviation, data = df.map, ncuts = 5,pal = "Reds",
                  geographyConfig=list(popupTemplate="#!function(geo, data) {
                                       return '<div class=\"hoverinfo\"><strong>' +
                                       data.state +
                                       '</strong><br>' + data.population+' People'+
                                       '</div>';}!#"))
i2
i2$show("iframesrc", cdn = TRUE)                                       
i2$save("html/choropleth_people.html", cdn = TRUE)

