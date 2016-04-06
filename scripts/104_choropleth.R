rm(list = ls())
df.map <- read_csv2("data/Plug-in_Electric_Light_Vehicle_Registrations_and_Population_by_State.csv")
df.states <- read_csv("data/states.csv")

# Variable names
names(df.map) <- tolower(names(df.map))
names(df.states) <- tolower(names(df.states))

## Left Join
df.map <- merge(df.map, df.states, by="state", all.x=TRUE)

i3 <- ichoropleth(percentage ~ abbreviation, data = df.map, ncuts = 5,
                  geographyConfig=list(popupTemplate="#!function(geo, data) {
                                       return '<div class=\"hoverinfo\"><strong>' +
                                       data.state +
                                       '</strong><br>' + data.percentage+' %'+
                                       '</div>';}!#"))
i3$show("iframesrc", cdn = TRUE)                                       
i3

