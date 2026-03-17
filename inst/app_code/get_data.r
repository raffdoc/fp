# get data
cat("Getting data from Google Sheets...\n")
set.seed(12345678)

# Google sheets authentification -----------------------------------------------
# Try to find credentials in various locations
json_path <- ".secrets/flightplan.json"

# Check in package installation directory too
pkg_json_path <- app_sys("flightplan.json")
pkg_secrets_json_path <- app_sys(".secrets/flightplan.json")

if (!file.exists(json_path)) {
  if (pkg_json_path != "" && file.exists(pkg_json_path)) {
    json_path <- pkg_json_path
  } else if (pkg_secrets_json_path != "" && file.exists(pkg_secrets_json_path)) {
    json_path <- pkg_secrets_json_path
  } else if (file.exists("inst/flightplan.json")) {
    json_path <- "inst/flightplan.json"
  } else if (file.exists("flightplan.json")) {
    json_path <- "flightplan.json"
  }
}

cat("Using credentials at:", json_path, "\n")

if (json_path == "" || !file.exists(json_path)) {
  stop("Credentials file 'flightplan.json' not found. Please ensure it is in 'inst/' or the current directory.")
}

# Explicitly use non-interactive authentication with the service account
# This avoids the need for a manual Google account login.
googlesheets4::gs4_auth(
  path = json_path
  )
cat("Authentication successful.\n")

url <- "https://docs.google.com/spreadsheets/d/1qYa-fR-t-GYrdLDabexe-FNUSMzxJyl09mv3bSz_-O8/edit?usp=sharing"
cat("Reading sheet...\n")

fp.df.web <- googlesheets4::read_sheet(ss = url,
                        sheet = "new_fp", range = "new_fp!A1:AA1000", na = "NA")
cat("Data read successfully. Rows:", nrow(fp.df.web), "\n")

cat("Processing data...\n")
fp <- fp.df.web %>%
  dplyr::select(ID:Admission_end) %>%
  tidyr::gather( key = Position,
          value = Date,
          Admission_start:Admission_end
  ) %>%
  dplyr::mutate(Level_of_Risk = dplyr::if_else(stringr::str_detect(Position, "OR"), "5",
                                 dplyr::if_else(stringr::str_detect(Position, "Intubated"), "4",
                                         dplyr::if_else(stringr::str_detect(Position, "ICU"), "3",
                                                 dplyr::if_else(stringr::str_detect(Position, "WARD"), "2",
                                                         dplyr::if_else(stringr::str_detect(Position, "Admission"), "1",
                                                                 Position
                                                         )
                                                 )
                                         )
                                 )
  )
  ) %>%
  dplyr::mutate(Date = as.POSIXct(Date, format = "%d/%m/%Y %H:%M"),
  Level_of_Risk = as.integer(Level_of_Risk))
cat("Data processing complete.\n")
