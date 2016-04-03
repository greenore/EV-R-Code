# Load data
df.model <- read_csv("data/Electric Vehicles by model.csv")

# Variable names
names(df.model) <- tolower(names(df.model))
for(i in 1:10){
  names(df.model) <- sub(pattern=" ", replacement="_", x=names(df.model))
}

names(df.model)

# Data cleanup
df.model <- df.model[!is.na(df.model$fuel_economy_city), ]

# Type
df.model$type <- paste0(df.model$manufacturer, ": ", df.model$model, "\n", "(", df.model$engine_size, ")")

# Engine cleanup
df.model$engine_size <- sub(pattern="kW", replacement="", x=df.model$engine_size)
df.model$engine_size <- sub(pattern="L", replacement="", x=df.model$engine_size)
df.model$engine_size <- sub(pattern=" ", replacement="", x=df.model$engine_size)

# Individual replacement for Tesla
df.model$engine_size[df.model$engine_size == "193/193"] <- "193"
df.model$engine_size[df.model$engine_size == "193/375"] <- "284"
df.model$engine_size[df.model$engine_size == "350/285"] <- "318"
df.model$engine_size <- as.numeric(df.model$engine_size)

# Splitting of the dataset
df.model_kw <- df.model[df.model$engine_size > 6, ]
df.model_l <- df.model[df.model$engine_size <= 6, ]

# Visualization
treemap(df.model_kw,
        index=c("type"),
        vSize="fuel_economy_city",
        vColor="engine_size",
        type="dens",
        palette=brewer.pal(n=9, name="Purples"),
        range=c(0, max(df.model_kw$engine_size)),
        border.col="white",
        title="Fuel Economy (Miles per Gallon)",
        title.legend="Engine Size in kW")

# Visualization
treemap(df.model_l,
        index=c("type"),
        vSize="fuel_economy_city",
        vColor="engine_size",
        type="dens",
        palette=brewer.pal(n=9, name="Blues"),
        range=c(0, max(df.model_l$engine_size)),
        border.col="white",
        title="Fuel Economy (Miles per Gallon)",
        title.legend="Engine Size in Liter")
