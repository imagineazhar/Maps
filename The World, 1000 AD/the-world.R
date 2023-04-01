library(tidyverse)
library(sf)
library(ggsn)
library(showtext)

# https://web.archive.org/web/20130728230041/http://library.thinkquest.org/C006628/data/1000.zip

AD <- read_sf("data/cntry1000.shp") |> 
  janitor::clean_names() |> 
  mutate(area = st_area(geometry)) |> 
  mutate(name2 = if_else(name == "unclaimed" & abbrevname != "", abbrevname, name))

# ------ Typography ------ 

font_add_google("Old Standard TT", "title_font")
font_add_google("Karma", "body_font")
showtext_auto()

title_font <- "title_font"
body_font <- "body_font"

ggplot(AD) +
  geom_sf(fill = NA, color = "#d2e5e1", linewidth = 5) +
  geom_sf(fill = NA, color = "#e4be8f", linewidth = 1) +
  geom_sf(fill = "#faf2e5", color = "grey40", linewidth = 0.1) +
  geom_sf_text(aes(label = name2, size = area),
               color="grey20",
               check_overlap = TRUE,
               family = body_font) +
  scale_size_continuous(range = c(3, 8)) +
  north(AD, symbol = 16, scale = 0.15, location = "bottomleft") +
  labs(
    title = "The World, 1000 AD",
    caption = "Graphic: Muhammad Azhar ? Source: thinkquest.org  ? Twitter: @imagineazhar"
  ) +
  theme_void(base_family = body_font) +
  theme(
    legend.position = "none",
    plot.background = element_rect(fill = "#edf0e5", color = NA),
    plot.title = element_text(family=title_font,
                              face = 'bold',
                              color = "grey30",
                              hjust = 0.5,
                              size = 30,
                              margin = margin(20, 0, 10, 0)),
    plot.caption = element_text(hjust = 0.5, color = "#696152",
                                margin = margin(10, 0, 20, 0), size = 11)
  )

# ------ Save Plot ------ 

showtext_opts(dpi = 320)
ggsave("world-1000AD.png",dpi=320,
       width = 10, height = 6)
showtext_auto(FALSE)
