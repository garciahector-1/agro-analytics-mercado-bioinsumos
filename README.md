# Agro-Analytics: Inteligencia Predictiva y Estrategia Comercial de Bioinsumos en el Mercosur

Este proyecto desarrolla un modelo predictivo y analítico en **PostgreSQL** enfocado en el mercado de soja del Mercosur para la campaña **2026/27**. El objetivo central es cruzar datos macroeconómicos oficiales, registros meteorológicos históricos de la NASA y ensayos de respuesta biológica para diseñar estrategias comerciales eficientes y maximizar el Retorno de la Inversión (ROI) del productor ante escenarios de estrés climático extremo.

---

## 📊 Descubrimientos Clave del Modelo (Data Insights)

### 1. La Paradoja de El Niño en Zona Núcleo (Pergamino)
* El rendimiento oficial por hectárea suele enmascarar pérdidas reales en años húmedos. El verdadero daño de El Niño no está en el rinde de los lotes cosechados, sino en las **hectáreas perdidas por anegamiento**.
* Ante este escenario de asfixia radicular, el modelo demuestra que los bioestimulantes foliares (aminoácidos de shock) actúan como un turbocompresor metabólico, logrando una respuesta de **+350 kg/ha**.

### 2. Eficiencia de Uso del Agua (EUA): Argentina vs. Brasil
Mediante un análisis en espejo interprovincial, se determinó que los sistemas sobre suelos pesados (como Chacabuco, Chaco) logran duplicar la eficiencia de conversión de milímetros de lluvia en grano frente a los suelos permeables y lixiviables del Cerrado Brasileño (Mato Grosso) en años secos:
* **Chaco (Campaña Seca):** EUA de **6.30 kg/mm** (con soplete térmico de 32.5°C).
* **Mato Grosso (Campaña Seca):** EUA de **3.67 kg/mm** (con soplete térmico de 33.1°C).

---

## 💵 Inteligencia de Negocios y Matriz de Decisión (ROI Predictivo)

El algoritmo automatizado en la base de datos calcula los costos logísticos variables (bloqueo de aplicaciones terrestres y uso obligatorio de avión por falta de piso en años con lluvias > 600 mm) para proyectar márgenes netos reales considerando un precio de soja de $300 USD/tn:

* **Año Niño Extremo (Zona Núcleo):** Costo tecnológico de $32.0 USD/ha (Insumo + Avión). Ingreso extra de $105.0 USD/ha. **Margen Neto Limpio: +$73.0 USD/ha** con un **ROI de 3.28**.
* **Año Seco / Soplete (Chaco):** Costo tecnológico de $25.0 USD/ha (Insumo + Mosquito). Ingreso extra de $63.0 USD/ha. **Margen Neto Limpio: +$38.0 USD/ha** con un **ROI de 2.52**.

---

## 🛠️ Tecnologías Utilizadas
* **Base de Datos:** PostgreSQL / pgAdmin 4
* **Lógica Avanzada:** Consultas con Expresiones Comunes de Tabla (CTEs), uniones analíticas (`UNION ALL`), funciones de agregación condicional (`CASE WHEN`) y control de división por cero (`NULLIF`).

---

## 🇧🇷 Resumo Executivo para o Mercado Brasileiro (Estratégia de Conquista)

**Objetivo:** Direcionar as equipes de Marketing e Vendas para o desembarque estratégico de bioinsumos em Mato Grosso (Cerrado) e Paraná (Sul) com base nas vulnerabilidades climáticas identificadas no modelo.

### 🎯 Diretrizes Estratégicas por Região:

* **1. Foco Cerrado (Mato Grosso - Cenário El Niño Extremo):**
    * **Diagnóstico:** A Eficiência do Uso da Água (EUA) cai para os níveis mais baixos do modelo (**2.48 kg/mm**) devido ao alto volume de chuvas monçônicas ($1320\text{ mm}$) que lavam os nutrientes nos solos arenosos (Oxisolos).
    * **Abordagem Comercial:** O argumento de vendas não deve focar em "tolerância à seca", mas sim em **eficiência nutricional e retenção**. A estratégia ideal é posicionar solubilizadores biológicos de fósforo e fixadores de nitrogênio para mitigar a lixiviação do investimento químico do produtor. Projeção de **ROI de 2.29**.

* **2. Foco Sul (Paraná - Cenário Excessos Hídricos):**
    * **Diagnóstico:** Assim como na Zona Núcleo argentina, o excesso de umidade e o estresse por asfixia radicular travam os tetos produtivos no enchimento de grãos.
    * **Abordagem Comercial:** Posicionamento agressivo de aminoácidos foliares para a **recuperação metabólica pós-alagamento**. O argumento técnico foca em salvar os nós reprodutivos da planta quando as condições de solo impedem a entrada de maquinário terrestre convencional.
