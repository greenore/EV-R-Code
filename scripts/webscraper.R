 install.packages("httr")
 install.packages("XML")
 install.packages("Rtools", type='source')
 install.packages("qdap")
install.packages("xml2")
 
library(httr)
library(XML)
library(xml2)
library(utils)
library(qdapRegex)
library(jsonlite)

statesList = readLines('states.txt')
finalString = "{"

for (i in 1:length(statesList)){
tempUrl = paste0("http://www.afdc.energy.gov/vehicles/electric_emissions_ajax.php?state=",statesList[i],collapse = NULL)
initialResponse = GET(tempUrl)
content = content(initialResponse,"text")

electricSources = rm_between(content,'var electricitySourcesData =',';',extract=TRUE , clean = true)
electricSources = gsub('"','\'',electricSources)
vehicleEmissionData = rm_between(content,'var electricVehicleEmissionsData =',';',extract=TRUE)
vehicleEmissionData = gsub('"','\'',vehicleEmissionData)
vehicleEmissionDataCat =  rm_between(content,'categories: [ ',' ],', extract=TRUE)
vehicleEmissionDataCat = paste('[' ,vehicleEmissionDataCat ,']');
vehicleEmissionDataCat = gsub('"','\'',vehicleEmissionDataCat)

tmpString  = paste0('"' ,statesList[i],'": {', '"electricSources" : "' , electricSources, '",' ,'"categories"',':"' , vehicleEmissionDataCat ,'",','"values"', ':"' , vehicleEmissionData,'"}')
finalString = paste0(finalString,tmpString)

if (i < length(statesList)){
  finalString = paste0(finalString,',')
}
}
finalString = paste0(finalString,'}')
write(finalString,'electric_emissions.txt')

