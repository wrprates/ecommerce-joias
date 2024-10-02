# Carregar pacotes necessários
library(dplyr)
library(readr)
library(lubridate)
library(stats)

# Carregar os dados
df_carrinhos <- read_csv("_data/clean/e_commerce_carrinhos.csv")
df_clientes <- read_csv("_data/clean/e_commerce_clientes.csv")
df_pedidos <- read_csv("_data/clean/e_commerce_pedidos.csv")

# Análise de tipos
str(df_pedidos)

# Ver colunas
names(df_pedidos)

head(df_pedidos)

# Convertendo data - string para datetime
df_pedidos$data <- dmy_hms(df_pedidos$data)

# Obter apenas a data, sem o horário
df_pedidos$data_aux <- as.Date(df_pedidos$data)

# Agrupar por ID do pedido e obter a primeira ocorrência de cada data para cada pedido
df_pedidos_unicos <- df_pedidos %>% 
  group_by(id) %>% 
  slice(1) %>%
  ungroup()

# Contar pedidos por data
contagem_por_data <- df_pedidos_unicos %>% 
  group_by(data_aux) %>% 
  summarise(contagem = n()) %>% 
  arrange(desc(contagem))

print(contagem_por_data)

# Criando nova coluna - dia da semana
df_pedidos$dia_semana <- weekdays(df_pedidos$data)

head(df_pedidos)

# Agrupar por ID do pedido e obter a primeira ocorrência de cada data para cada pedido
df_pedidos_unicos <- df_pedidos %>% 
  group_by(id) %>% 
  slice(1) %>%
  ungroup()

# Agrupar por 'dia_semana' e contar o número de pedidos únicos
contagem_por_dia <- df_pedidos_unicos %>% 
  group_by(dia_semana) %>% 
  summarise(contagem = n()) %>% 
  arrange(desc(contagem))

print(contagem_por_dia)

# Frequência esperada se os pedidos fossem uniformemente distribuídos
frequencia_esperada <- nrow(df_pedidos_unicos) / 7
print(frequencia_esperada)

# Extrair a lista de contagens observadas e a lista de dias da semana
contagens_observadas <- contagem_por_dia$contagem
dias_da_semana <- contagem_por_dia$dia_semana

# Calcular a frequência esperada (assumindo uma distribuição uniforme)
frequencia_esperada <- sum(contagens_observadas) / length(dias_da_semana)
frequencias_esperadas <- rep(frequencia_esperada, length(dias_da_semana))

# Realizar o teste qui-quadrado
chi2_test <- chisq.test(contagens_observadas, p = frequencias_esperadas / sum(frequencias_esperadas))

# Exibir os resultados
print(paste("Estatística qui-quadrado:", chi2_test$statistic))
print(paste("Valor-p:", chi2_test$p.value))

if (chi2_test$p.value < 0.05) {
  print("Rejeitamos a hipótese nula: há evidência de sazonalidade nos dias da semana.")
} else {
  print("Não rejeitamos a hipótese nula: não há evidência de sazonalidade nos dias da semana.")
}
