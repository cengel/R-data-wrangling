# MS_policing_bw_age.csv

**Mississippi Traffic Stops by Police 2013-2016**

Data from https://openpolicing.stanford.edu

For the purpose of this tutorial I made the following changes:

- Selected Black, White, and unknown (empty string: "") "driver_race" only.
- Kept only the following columns "id", "stop_date", "county_name", "county_fips", "police_department", "driver_gender", "driver_age_raw", "driver_race",  "violation_raw", "officer_id"
- Renamed "driver_age_raw" to "driver_birthdate"
- Set all empty strings "" to NA for:
    - "driver_gender"
    - "driver_race"
    - "driver_birthdate"
    - "officer_id"
- Set "driver_birthdate" to NA if it is later or equal than "stop_date"
- Calculated age of driver at the time stopped and added a column with driver_age (in years)
- Removed `County` from "county_name"
- "driver_gender": Renamed M and F to male and female
- added violations, recoded, based on violations_raw and dropped violations_raw:
[1] Seat belt not used properly as required >> Seat belt
[2] Careless driving >> Carless driving
[3] Speeding - Regulated or posted speed limit and actual speed >> Speeding
[4] ?? >> Other or unknown
[5] Failure to obey sign or traffic control device >> Carless driving
[6] Driving while license suspended  >> License/Permit/Insurance
[7] Failure to maintain required liability insurance >> License/Permit/Insurance
[8] Other (non-mapped) >> Other or unknown
[9] Expired or no non-commercial driver license or permit >> License/Permit/Insurance
[10] Child or youth restraint not used properly as required >> Seat belt
[11] Improper turn >> Carless driving
[12] Driving wrong way >> Carless driving
[13] Operating without equipment as required by law >>  Breaks/Lights/etc
[14] Speeding  >> Speeding
[15] Following too closely >> Carless driving
[16] Reckless driving >> Carless driving
[17] Improper passing >> Carless driving
[18] Failure to yield right of way (FTY ROW) >> Carless driving
[19] Failure to comply with financial responsibility law >> License/Permit/Insurance

`traf <- read.csv("../R-intro/data/MS_trafficstops_bw.csv", na.strings=c("","NA"), stringsAsFactors = F)
traf$driver_birthdate[ymd(traf$driver_birthdate) >= ymd(traf$stop_date)] <- NA
traf$driver_age <- round((ymd(traf$stop_date) - ymd(traf$driver_birthdate))/365)
traf$driver_gender[traf$driver_gender == "F"] <- "female"
traf$driver_gender[traf$driver_gender == "M"] <- "male"

## recoding factor levels manually...

write.csv(traf, "data/MS_trafficstops_bw_age.csv", row.names=F)`

# MS_acs2015_bw.csv

Estimated values of the 5 year average of the 2011-2015 American Community Survey (ACS) for: B02001. Race: Black Black or African American alone and White alone.

`library(tidycensus)
#census_api_key("XXXXXX")

black_pop <- get_acs(geography = "county", variable = "B02001_003E", state="MS")
white_pop <- get_acs(geography = "county", variable = "B02001_002E", state="MS")

MS_pop <- data.frame(FIPS = as.numeric(black_pop$GEOID), black_pop = black_pop$estimate, white_pop = white_pop$estimate, total_pop = total_pop$estimate)

MS_pop %>% 
  mutate(County = str_remove(County, " County")) %>% # remove "County"
  write_csv("data/MS_acs2015_bw.csv")`
