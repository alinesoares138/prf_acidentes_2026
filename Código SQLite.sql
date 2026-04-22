--------Limpeza  e Tratamento de dados
--Padronização dos campos
SELECT 
	CAST(veiculos AS INT) AS qt_veiculos,
    CAST(pessoas AS INT) AS qt_pessoas_envolvidas,
    CAST(feridos_leves AS INT) AS qt_feridos_leves,
    CAST(feridos AS INT) AS qt_total_feridos,
    CAST(feridos_graves AS INT) AS qt_feridos_graves,
    CAST(ilesos AS INT) AS qt_ilesos,
    CAST(ignorados AS INT) AS qt_ignorados 
FROM datatran2026 d 

--Verificação de dados zerados / nulos
SELECT COUNT(*)
FROM datatran2026 d 
WHERE 1=1
	AND (latitude  <= 0 
	OR longitude <= 0
	OR km <= 0)
--Output: 0

--Criação de flags
SELECT 
	CASE
	    WHEN classificacao_acidente LIKE '%V%timas%' THEN 'TRUE'
		ELSE 'FALSE' 
	END AS teve_vitima,
	CASE 
		WHEN mortos > 0 THEN 'TRUE' 
        ELSE 'FALSE'
	END AS acidente_fatal
FROM datatran2026 d 

--Agrupamentos
SELECT
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
        WHEN UPPER(condicao_metereologica) LIKE '%C%U CLARO%' THEN 'CEU CLARO'
        WHEN UPPER(condicao_metereologica) LIKE '%NUVENS%' THEN 'NUVENS'
        ELSE UPPER(condicao_metereologica)
    END AS condicao_metereologica
FROM datatran2026 d;

--Query final
SELECT DISTINCT 
    -- 1. IDENTIFICAÇÃO E TEMPO
    id,
    data_inversa AS data,
    horario AS hora,
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
	    WHEN feridos > 0 THEN 'TRUE'
		ELSE 'FALSE' 
	END AS teve_vitima,
    
	CASE 
		WHEN mortos > 0 THEN 'TRUE' 
        ELSE 'FALSE'
	END AS acidente_fatal

    -- 4. CONDIÇÕES AMBIENTAIS
    UPPER(sentido_via) AS sentido_via,
    CASE 
        WHEN UPPER(condicao_metereologica) LIKE '%C%U CLARO%' THEN 'CEU CLARO'
        WHEN UPPER(condicao_metereologica) LIKE '%NUVENS%' THEN 'NUVENS'
        ELSE UPPER(condicao_metereologica)
    END AS condicao_metereologica,
    UPPER(tipo_pista) AS tipo_pista,

    -- 5. DADOS QUANTITATIVOS
   	CAST(veiculos AS INT) AS qt_veiculos,
    CAST(pessoas AS INT) AS qt_pessoas_envolvidas,
    CAST(feridos_leves AS INT) AS qt_feridos_leves,
    CAST(feridos AS INT) AS qt_total_feridos,
    CAST(feridos_graves AS INT) AS qt_feridos_graves,
    CAST(ilesos AS INT) AS qt_ilesos,
    CAST(ignorados AS INT) AS qt_ignorados 

FROM datatran2026 d;

--Looker Studio 
--https://datastudio.google.com/u/0/reporting/28767fae-7217-44f8-a8b2-d11ab6a48d57/page/qX4vF/edit
