library(tmap)
library(tmaptools)

County files are here:
  
https://www2.census.gov/geo/tiger/TIGER2010/COUNTY/2010/tl_2010_28_county10.zip

Code is here:
  
https://github.com/mtennekes/tmap/blob/master/demo/USChoropleth/US_choropleth.R


# load county files
dir <- tempdir()
download.file("https://www2.census.gov/geo/tiger/TIGER2010/COUNTY/2010/tl_2010_28_county10.zip", destfile = file.path(dir, "tl_2010_28_county10.zip"))
unzip(file.path(dir, "tl_2010_28_county10.zip"), exdir = dir)
MS_counties <- read_shape(file.path(dir, "tl_2010_28_county10.shp"))

# need a data column that shows difference between b-w ratio. Low value: more whites are stopped than blacks high value: more blacks are stopped than whites
# append_data() from tmaptools to join with %
# create FIPS variable
MS_counties$FIPS <- paste0(US$STATE, US$COUNTY)

MS_counties <- append_data(US, ***_data_w_ratios_**, key.shp = "FIPS", key.data = "FIPS", ignore.duplicates = TRUE)

# should not have under or over coverage

# plot
tm_shape(MS_counties) +
  tm_polygons("_the ratio var", title="over/underrepresentation of black stops")