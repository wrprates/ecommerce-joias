library("dplyr")

data_carrinhos <- read.csv("Projetos/Projeto Ecommerce/ecommerce-joias/_data/clean/e_commerce_carrinhos.csv")
data_clientes <- read.csv("Projetos/Projeto Ecommerce/ecommerce-joias/_data/clean/e_commerce_clientes.csv")
data_pedidos <- read.csv("Projetos/Projeto Ecommerce/ecommerce-joias/_data/clean/e_commerce_pedidos.csv")

#analise de tipos das colunas
glimpse(data_pedidos)


summary(data_pedidos)

#convertendo data char em datetime
df_pedidos <- data_pedidos %>% 
  mutate(data = as.POSIXct(data, format = "%d/%m/%Y %H:%M"))

#dia da semana
df_pedidos <- df_pedidos %>%
  mutate(dia_semana = weekdays(data))

glimpse(df)

# Contagem de registros por dia da semana
contagem_dia_semana <- df_pedidos %>%
  group_by(dia_semana) %>%
  summarise(quantidade = n()) %>%
  arrange(match(dia_semana, c("domingo", "segunda-feira", "terça-feira", 
                              "quarta-feira", "quinta-feira", 
                              "sexta-feira", "sábado")))

# Visualizando o resultado
print(contagem_dia_semana)


contagem_dia_semana <- contagem_dia_semana %>% 
  arrange((desc(quantidade)))

#ordenando por desc.
contagem_dia_semana

#frequencia esperada se a distribuição fosse uniforme
freq_esp = nrow(df_pedidos)/7
print(freq_esp)

# Realizar o teste qui-quadrado
resultado <- chisq.test(contagem_dia_semana$quantidade, p = rep(freq_esp, 7) / sum(contagem_dia_semana$quantidade))

resultado

if (resultado$p.value < 0.05) {
  cat("Rejeitamos a hipótese nula: há evidência de sazonalidade nos dias da semana.\n")
} else {
  cat("Não rejeitamos a hipótese nula: não há evidência de sazonalidade nos dias da semana.\n")
}