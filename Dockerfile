FROM rocker/verse:4.5.0
RUN apt-get update && apt-get install -y  cmake libcurl4-openssl-dev libglpk-dev libicu-dev libssl-dev libx11-dev libxml2-dev make pandoc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.29")'
RUN Rscript -e 'remotes::install_version("knitr",upgrade="never", version = "1.50")'
RUN Rscript -e 'remotes::install_version("stringr",upgrade="never", version = "1.5.1")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.1.4")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.3.1")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.5.2")'
RUN Rscript -e 'remotes::install_version("googledrive",upgrade="never", version = "2.1.1")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.11.1")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.2")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.2.3")'
RUN Rscript -e 'remotes::install_version("spelling",upgrade="never", version = "2.3.2")'
RUN Rscript -e 'remotes::install_version("DataExplorer",upgrade="never", version = "0.8.4")'
RUN Rscript -e 'remotes::install_version("visdat",upgrade="never", version = "0.6.0")'
RUN Rscript -e 'remotes::install_version("Hmisc",upgrade="never", version = "5.2-3")'
RUN Rscript -e 'remotes::install_version("mice",upgrade="never", version = "3.18.0")'
RUN Rscript -e 'remotes::install_version("googlesheets4",upgrade="never", version = "1.1.2")'
RUN Rscript -e 'remotes::install_version("ggthemes",upgrade="never", version = "5.1.0")'
RUN Rscript -e 'remotes::install_version("plotly",upgrade="never", version = "4.11.0")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.5.1")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 3838
CMD R -e "options('shiny.port'=3838,shiny.host='0.0.0.0');library(fp);fp::run_app()"
