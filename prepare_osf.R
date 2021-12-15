prepare_dates <- function(raw){
  dplyr::select(raw, analytics_key, date_modified, date_created, date_registered) %>% 
    dplyr::mutate(dplyr::across(dplyr::starts_with("date"), lubridate::as_datetime))
}

prepare_registration_ <- function(registration_responses){
  registration_responses %>%
    dplyr::select(-matches(".*uploader.*")) %>% 
    purrr::map_dfc(clinch_character)
}

concenate_questions <- function(questions){
  purrr::map(questions, stringr::str_replace_na, "") %>% 
    purrr::pmap_chr(stringr::stringr::str_c, sep = "\n", collapse = "\n") %>% 
    stringr::str_squish()
}

prepare_registration <- function(registration_responses){
  concenate_questions(prepare_registration_(registration_responses))
}

clinch_character <- function(x){
  all_vector <- purrr::map_lgl(x, ~is.vector(.x) | is.null(.x))
  if(any(!all_vector))x[!all_vector] <- NA_character_
  x <- purrr::map_chr(x, stringr::str_c, collapse = "\n")
  if_else(x == "", NA_character_, x)
}

prepare_files <- function(registration_responses){
  uploads <- select(registration_responses, matches("upload"))
  if(ncol(uploads) == 0L)return(rep(list(NA_character_), nrow(registration_responses)))
  uploads %>% 
    purrr::map(prepare_files_) %>% 
    purrr::pmap(function(...)flatten_chr(list(...)))
}

prepare_files_ <- function(upload){
  upload %>% purrr::map("file_name") %>% purrr::map_if(is.null, function(x)NA_character_)
}

extract_keep <-
  . %>% mutate(
    registration_text = prepare_registration(registration_responses),
    files = prepare_files(registration_responses),
    date_registered = lubridate::as_datetime(date_registered),
    date_created = lubridate::as_datetime(date_created)
  )
extract <- . %>%
  extract_keep() %>%
  select(
    title,
    description,
    registration_text,
    files,
    date_created,
    date_registered,
    withdrawn
  )

preregistrations <- fs::dir_ls("data") %>%
  purrr::map_dfr(~jsonlite::read_json(.x, simplifyVector = TRUE) %>% 
            keep(~"registration_responses" %in% names(.x)) %>% 
            purrr::map_dfr(extract))


test <- fs::dir_ls("data")[[3]] %>% 
  jsonlite::read_json(simplifyVector = TRUE) %>% 
  .[[1]]

file_endings <- preregistrations %>% 
  as_tibble() %>% 
  mutate(registration_length = stringi::stri_count_words(registration_text),
         file_endings = purrr::map(files, fs::path_ext) %>% 
           purrr::map(discard, is.na) %>% 
           purrr::map(unique) %>% 
           purrr::map_if(~length(.x) == 0L, function(x)NA_character_)) %>% 
  unnest(file_endings)

file_endings <- file_endings %>%
  mutate(
    file_endings = file_endings %>% stringr::str_to_lower() %>% stringr::str_replace_na(),
    file_endings_coded = fct_collapse(
      file_endings,
      document = c("pdf", "docx", "doc", "rtf", "html", "htm", "odt", "gdoc", "md"),
      dynamic_document = c("rmd", "ipynb"),
      script = c("r", "sps", "cpp", "py", "m", "sas"),
      data = c("xlsx", "xls", "sav", "rdata", "mat", "csv", "ods", "json"),
      media = c(
        "jpg",
        "jpeg",
        "png",
        "pptx",
        "mpeg",
        "eps",
        "mov",
        "gif",
        "wav",
        "mp3",
        "mp4",
        "tiff",
        "tif"
      ),
      nothing = "NA",
      other_level = "other"
    )
  )
  

top_file_endings <- file_endings %>% 
  group_by(file_endings) %>% 
  tally() %>% 
  slice_max(n,  n = 10) %>% 
  arrange(n)

top_file_endings %>% 
  mutate(file_endings = factor(file_endings, levels = top_file_endings$file_endings)) %>% 
  ggplot(aes(file_endings, n)) + geom_col()

file_endings %>% 
  filter(file_endings %in% top_file_endings$file_endings,
         registration_length > 50 | !is.na(file_endings),
         registration_length < 5000) %>% 
  ggplot(aes(file_endings, registration_length)) +
  geom_violin() +
  theme_minimal()

file_endings %>% 
  filter(file_endings %in% c("docx", "pdf", "rmd", "r", "NA"),
         registration_length < 6000) %>% 
  ggplot(aes(file_endings, registration_length)) +
  geom_boxplot(width = .1, outlier.shape = NA, notch = TRUE) +
  theme_minimal()

file_endings %>% 
  filter(file_endings %in% c("docx", "pdf", "rmd", "r", "NA"),
         registration_length < 6000) %>% 
  ggplot(aes(registration_length, color = file_endings)) +
  geom_density() +
  theme_minimal()

file_endings %>% 
  group_by(file_endings) %>% 
  summarise(median = median(registration_length)) %>% 
  arrange(median)

file_endings %>% 
  filter(file_endings %in% c("docx", "pdf", "rmd", "r", "NA"),
         registration_length < 6000) %>% 
  ggplot(aes(registration_length)) +
  geom_density() +
  facet_grid(rows = vars(file_endings), scales = "free") +
  theme_minimal() +
  NULL

file_endings %>%
  filter(registration_length < 6000) %>% 
  ggplot(aes(registration_length, color = file_endings_coded)) +
  geom_density() +
  theme_minimal() +
  NULL

file_endings %>% 
  group_by(file_endings_coded) %>% 
  rename(words = registration_length,
         attachement = file_endings_coded) %>% 
  summarise(n = n(), median(words), mad(words)) %>% 
  arrange(desc(n)) %>% 
  mutate(`%` = round(n/sum(n)*100, 2)) %>% 
  select(attachement, n, `%`, everything()) %>% 
  knitr::kable()

file_endings %>% 
  mutate(year = lubridate::year(date_created)) %>% 
  group_by(year) %>% 
  summarise(scripts = mean(file_endings_coded %in% c("script")),
            dynamic_documents = mean(file_endings_coded %in% c("dynamic_document")))
