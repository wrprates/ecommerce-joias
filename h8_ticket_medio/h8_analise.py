#%% Carregando os dados necessários
from pandas import DataFrame, read_csv, to_datetime, concat
from os import path

datadir = 'C:/Users/User/Desktop/data_science/mentoria_data_mundo/projeto_ecommerce/_data/clean'

df_clientes = read_csv(path.join(datadir, 'e_commerce_clientes.csv'))
df_carrinhos = read_csv(path.join(datadir, 'e_commerce_carrinhos.csv'))
df_pedidos = read_csv(path.join(datadir, 'e_commerce_pedidos.csv'))

#%% Realizando os tratamentos dos dados necessários em df_pedidos
# Do dataframe 'df_pedidos' Iremos pegar a coluna 'total_pago' e a coluna 'id_cliente', assim teremos o valor total pago por cliente, além da data.
# A ideia é dividir em dois grupos, o ticket médio dos clientes em datas normais, e em datas especiais.

# Trocando as ',' por '.' para converter para float na coluna 'total_pago'
df_pedidos['total_pago'] = (df_pedidos['total_pago']
 .replace(',', '.', regex=True)
 .astype({'total_pago': float}))

# Trocando o tipo da coluna 'data' para datetime (formato do pandas para datas)
df_pedidos['data'] = to_datetime(df_pedidos['data'], format='%d/%m/%Y %H:%M:%S')
df_pedidos['data'] = df_pedidos['data'].apply(lambda x: x.strftime('%Y/%m/%d'))

# Filtrando apenas as colunas necessárias do dataframe 'df_pedidos'
df_pedidos = df_pedidos.filter(['id_cliente', 'total_pago', 'data'])

#%% Criando df_pedidos com datas especiais e não especiais
# Vamos criar a lista com as datas especiais
datas_especiais = ([
    '2024/01/01', '2024/01/06', '2024/01/25', '2024/02/10', '2024/02/11', 
    '2024/02/12', '2024/02/13', '2024/02/14', '2024/02/24', '2024/03/08', 
    '2024/03/10', '2024/03/19', '2024/03/29', '2024/04/01', '2024/04/21', 
    '2024/04/22', '2024/04/25', '2024/04/30', '2024/05/01', '2024/05/13', 
    '2024/05/31', '2024/06/05', '2024/06/12', '2024/06/24', '2024/07/02', 
    '2024/07/09', '2024/07/20', '2024/08/11', '2024/08/15', '2024/08/19', 
    '2024/09/07', '2024/09/29', '2024/10/12', '2024/10/15', '2024/10/28', 
    '2024/11/02', '2024/11/15', '2024/11/20', '2024/12/24', '2024/12/25', '2024/12/31'])

# Agora criaremos outro dataframe apenas com as datas_especiais e um com datas normais
df_pedidos_datas_especiais = df_pedidos[df_pedidos['data'].isin(datas_especiais)].reset_index(drop=True)
df_pedidos_datas_normais = df_pedidos[df_pedidos['data'].isin(datas_especiais) == False].reset_index(drop=True)

#%%
# Vamos criar os dois grupos com o ticket médio de cada cliente
ticket_medio_especiais = df_pedidos_datas_especiais.groupby('id_cliente')['total_pago'].mean() # Apenas 5 clientes
ticket_medio_normais = df_pedidos_datas_normais.groupby('id_cliente')['total_pago'].mean()
ticket_medio_total = df_pedidos.groupby('id_cliente')['total_pago'].mean()

## No df_pedidos_datas_especiais temos uma limitação, pois temos uma amostra relativamente pequena, contendo apenas 5 clientes de 43

#%%
# Agora, como queremos comparar a variável 'ticket médio' entre dois grupos, e ela é contínua.
# Com isso, iremos usar o teste t two sample se for normalmente distribuida (paramétrico), ou o teste de mann whitney u se não for paramétrico
# Primeiramente vamos testar a normalidade usando o teste de shapiro.
from scipy.stats import shapiro, mannwhitneyu

res_especiais = shapiro(ticket_medio_especiais)
res_normais = shapiro(ticket_medio_normais)
res_totais = shapiro(ticket_medio_total)



# --- OBS: ao verificarmos quantos clientes ativos temos através da colunas ativos usando df_clientes.query("ativo == 'sim'"),
# temos uma quantidade incorreta de clientes ativos, mostrando 83 de 84,
# sendo que, ao verificarmos a quantidade de clientes únicos através do dataset de pedidos
# temos 43 clientes que fizeram pedidos.
#%%
