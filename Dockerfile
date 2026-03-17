FROM rocker/verse:4.5.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    libcurl4-openssl-dev \
    libglpk-dev \
    libicu-dev \
    libssl-dev \
    libx11-dev \
    libxml2-dev \
    make \
    pandoc \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set R options for faster and reliable package installation
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" \
    > /usr/local/lib/R/etc/Rprofile.site

# Install remotes for package management
RUN R -e 'install.packages("remotes")'

# Pre-install specific versions of dependencies for reproducibility
# Note: These are listed in DESCRIPTION. Missing ones like readr and scales are added here.
RUN Rscript -e ' \
    remotes::install_version("rmarkdown", version = "2.29", upgrade="never"); \
    remotes::install_version("knitr", version = "1.50", upgrade="never"); \
    remotes::install_version("stringr", version = "1.5.1", upgrade="never"); \
    remotes::install_version("dplyr", version = "1.1.4", upgrade="never"); \
    remotes::install_version("tidyr", version = "1.3.1", upgrade="never"); \
    remotes::install_version("ggplot2", version = "3.5.2", upgrade="never"); \
    remotes::install_version("googledrive", version = "2.1.1", upgrade="never"); \
    remotes::install_version("shiny", version = "1.11.1", upgrade="never"); \
    remotes::install_version("config", version = "0.3.2", upgrade="never"); \
    remotes::install_version("DataExplorer", version = "0.8.4", upgrade="never"); \
    remotes::install_version("visdat", version = "0.6.0", upgrade="never"); \
    remotes::install_version("Hmisc", version = "5.2-3", upgrade="never"); \
    remotes::install_version("mice", version = "3.18.0", upgrade="never"); \
    remotes::install_version("googlesheets4", version = "1.1.2", upgrade="never"); \
    remotes::install_version("ggthemes", version = "5.1.0", upgrade="never"); \
    remotes::install_version("plotly", version = "4.11.0", upgrade="never"); \
    remotes::install_version("lubridate", version = "1.9.3", upgrade="never"); \
    remotes::install_version("golem", version = "0.5.1", upgrade="never"); \
    remotes::install_version("readr", version = "2.1.5", upgrade="never"); \
    remotes::install_version("scales", version = "1.3.0", upgrade="never"); \
    remotes::install_version("spelling", version = "2.3.2", upgrade="never"); \
    remotes::install_version("testthat", version = "3.2.3", upgrade="never")'

# Create build directory and install the package
WORKDIR /app
ADD . /app
RUN R -e 'remotes::install_local(upgrade="never")'

# Expose Shiny port
EXPOSE 3838

# Run the app
CMD ["R", "-e", "options('shiny.port'=3838,shiny.host='0.0.0.0');fp::run_app()"]
