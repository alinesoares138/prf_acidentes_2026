
#Fonte de dados
Site público da Polícia Rodoviária Federal: https://www.gov.br/prf/pt-br/acesso-a-informacao/dados-abertos/dados-abertos-da-prf
    
#Tratamento de dados

SELECT DISTINCT 
    -- 1. IDENTIFICAÇÃO E TEMPO
    id,
    data_inversa,
    horario,
    UPPER(dia_semana) AS dia_semana,
    UPPER(fase_dia) AS fase_dia,

    -- 2. LOCALIZAÇÃO
    uf,
    br,
    km,
    UPPER(municipio) AS municipio,
    regional,
    delegacia,
    latitude,
    longitude,

    -- 3. CLASSIFICAÇÃO E REGRAS DE NEGÓCIO
    CASE 
        WHEN tipo_acidente LIKE '%Colis%' 
          OR tipo_acidente LIKE '%Atropelamento%' 
          OR tipo_acidente LIKE '%Engavetamento%' THEN 'ACIDENTE'
        WHEN tipo_acidente LIKE '%Tombamento%' 
          OR tipo_acidente LIKE '%Capotamento%' THEN 'TOMBAMENTO'
        WHEN tipo_acidente LIKE '%Inc%ndio%' 
          OR tipo_acidente LIKE '%carga%' 
          OR tipo_acidente LIKE '%Queda%' 
          OR tipo_acidente LIKE '%objeto%' THEN 'AVARIA'
        WHEN tipo_acidente LIKE '%Roubo%' THEN 'ROUBO'
        ELSE 'OUTROS'
    END AS agrupamento_acidente,

    CASE
        WHEN classificacao_acidente LIKE '%V%timas%' THEN 'TRUE'
        ELSE 'FALSE' 
    END AS flag_tem_vitima,

    -- 4. CONDIÇÕES AMBIENTAIS
    UPPER(sentido_via) AS sentido_via,
    CASE 
        WHEN UPPER(condicao_metereologica) LIKE '%C%U CLARO%' THEN 'CEU CLARO'
        WHEN UPPER(condicao_metereologica) LIKE '%NUVENS%' THEN 'NUVENS'
        ELSE UPPER(condicao_metereologica)
    END AS condicao_metereologica,
    UPPER(tipo_pista) AS tipo_pista,

    -- 5. DADOS QUANTITATIVOS (CONTAGENS)
    veiculos,
    pessoas,
    mortos,
    feridos,
    feridos_leves,
    feridos_graves,
    ilesos,
    ignorados

FROM datatran2026 d;
