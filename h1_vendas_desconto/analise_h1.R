# Carregar pacotes
library(readr)

# Importando datasets
df_carrinhos <- read_csv(file ="_data/clean/e_commerce_carrinhos.csv")
df_clientes <- read_csv(file ="_data/clean/e_commerce_clientes.csv")
df_pedidos <- read_csv(file ="_data/clean/e_commerce_pedidos.csv")

# H1 - Há uma maior quantidade de vendas devido a ações de desconto progressivo
# H1 - As ações de desconto progressivo aumentam o faturamento

df_h1 <- 