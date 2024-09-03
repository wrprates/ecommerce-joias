import pandas as pd
import scipy.stats as stats

#criando os dfs
df_carrinhos = pd.read_csv("_data\clean\e_commerce_carrinhos.csv")
df_clientes = pd.read_csv("_data\clean\e_commerce_clientes.csv")
df_pedidos = pd.read_csv("_data\clean\e_commerce_pedidos.csv")

#analise de tipos
print(df_pedidos.dtypes)

#vendo colunas
print(df_pedidos.columns)

#Listando valores únicos nas colunas
for coluna in df_pedidos.columns:
    valores_unicos = df_pedidos[coluna].unique()
    print(f'Coluna "{coluna}" - Valores únicos: {valores_unicos}')

#convertendo data - str > datetime
df_pedidos['data'] = pd.to_datetime(df_pedidos['data'], format='%d/%m/%Y %H:%M:%S')

#contando pedidos por data
contagem_por_data = df_pedidos.groupby('data').size().reset_index(name='contagem')
print(contagem_por_data.sort_values('contagem', ascending= False))

#criando nova coluna - dia da semana
df_pedidos['dia_semana'] = df_pedidos['data'].dt.day_name()

print(df_pedidos)

#contando pedidos por dia
contagem_por_dia = df_pedidos.groupby('dia_semana').size().reset_index(name='contagem')
print(contagem_por_dia.sort_values('contagem', ascending= False))

# Contagem dos pedidos por dia da semana
contagem_dias = df_pedidos['dia_semana'].value_counts()

print(contagem_dias)

# Frequência esperada se os pedidos fossem uniformemente distribuídos
frequencia_esperada = len(df_pedidos) / 7

print(frequencia_esperada)

# Realizar o teste qui-quadrado
chi2, p_valor = stats.chisquare(contagem_dias, [frequencia_esperada]*7)

# Exibir os resultados
print(f"Estatística qui-quadrado: {chi2}")
print(f"Valor-p: {p_valor}")

if p_valor < 0.05:
    print("Rejeitamos a hipótese nula: há evidência de sazonalidade nos dias da semana.")
else:
    print("Não rejeitamos a hipótese nula: não há evidência de sazonalidade nos dias da semana.")