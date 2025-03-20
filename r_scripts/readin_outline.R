library(factcuratoR)
library(facthelpeR)

data_folder <- here::here("data")

files <- list.files(data_folder)

sheetinfo <- list_sheetnames(data_folder, files) |> 
  mutate(header_end = if_else(str_detect(sheets, "^IWC"), NA, 1),
         list_names = if_else(!is.na(header_end), sheets, NA))

wpg_info <- read_multsheets(data_folder, 
                            sheetinfo, 
                            na = c("NA", ""), 
                            col_names = TRUE, 
                            guess_max = 100, 
                            complete_cases = TRUE)

wpg_info$outline <- wpg_info$outline |> 
  filter(!is.na(section_id))

wpg_info2 <- wpg_info |> 
  map(\(x) set_names(x, tolower) |> 
        select(-starts_with("...")))
      
outline <- wpg_info2$outline |> 
  tidyr::fill(chapters, .direction = "down")

