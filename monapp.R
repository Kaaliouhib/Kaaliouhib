# App pour la modélisation des séries temporelles
# Auteur : ALIOU KA - Novembre 2025
library(rsconnect)
#rsconnect::deployApp('path/to/your/app')
# --- Packages nécessaires ---
packages <- c(
  "shiny", "shinydashboard", "shinyWidgets", "plotly",
  "forecast", "tseries", "ggplot2", "dplyr", "tidyr",
  "DT", "writexl", "readxl"
)

# Installer les packages manquants
missing_pkgs <- packages[!(packages %in% rownames(installed.packages()))]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs, dependencies = TRUE)
}

# Charger les packages
invisible(lapply(packages, library, character.only = TRUE))

# --- Interface utilisateur ---
ui <- dashboardPage(
  dashboardHeader(title = "Modélisation automatique des séries temporelles"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Aperçu", tabName = "aperçu", icon = icon("dashboard")),
      menuItem("🏠 Accueil", tabName = "accueil", icon = icon("home")),
      menuItem("📊 Importation de la base de données", tabName = "import", icon = icon("file-upload")),
      menuItem("📉 Tendance & Saisonnalité", tabName = "stationnarite", icon = icon("chart-area")),
      menuItem("⚙️ Estimation des modèles", tabName = "modele", icon = icon("cogs")),
      menuItem("✅ Tests de significativité", tabName = "importance", icon = icon("check-circle")),
      menuItem("📅 Prévisions", tabName = "prevision", icon = icon("chart-bar")),
      menuItem("🤖 Agent IA", tabName = "robot", icon = icon("robot")),
      menuItem("💾 Exportation des résultats", tabName = "export", icon = icon("download"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        body {
          font-family: 'Poppins', 'Inter', sans-serif;
          background: linear-gradient(130deg, #f5f5f5, #ffffff);
          color: #2c3e50;
          margin: 0;
        }

        .main-header {
          background: linear-gradient(90deg, #6a11cb, #2575fc);
          color: #ffffff;
          box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
          height: 60px;
          line-height: 70px;
          font-weight: 600;
          font-size: 22px;
          padding-left: 20px;
        }

        .main-sidebar {
          background: #ffffff;
          box-shadow: 0px 4px 8px rgba(0,0,0,0.05);
          border-right: 1px solid #ddd;
        }

        .sidebar-menu > li > a {
          font-weight: 500;
          font-size: 16px;
          padding: 12px 20px;
          color: #555555;
          transition: background 0.3s, color 0.3s;
        }

        .sidebar-menu > li.active > a,
        .sidebar-menu > li:hover > a {
          background: linear-gradient(90deg, #6a11cb, #2575fc);
          color: #ffffff;
          border-radius: 8px;
        }

        .content-wrapper {
          background: #f0f2f5;
          padding: 20px;
          min-height: calc(100vh - 70px);
        }

        /* Boxes */
        .box {
          background: white;
          border: none;
          box-shadow: 0 2px 8px rgba(0,0,0,0.05);
          border-radius: 12px;
          padding: 20px;
          margin-bottom: 30px;
          transition: box-shadow 0.3s ease;
        }
        .box:hover {
          box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }

        /* Titres dans les boîtes */
        .box-title {
          font-size: 20px;
          font-weight: 500;
          margin-bottom: 15px;
          color: #4a4a4a; 
        }

        /* Boutons */
        .btn {
          border-radius: 8px;
          font-weight: 600;
          font-size: 16px;
          padding: 10px 20px;
          transition: background 0.3s, box-shadow 0.3s;
        }
        .btn-primary {
          background: linear-gradient(90deg, #00c6ff, #0072ff);
          border: none;
          color: white;
        }
        .btn-primary:hover {
          background: linear-gradient(90deg, #0072ff, #00c6ff);
          box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .btn-success {
          background: linear-gradient(90deg, #56ab2f, #a8e063);
          border: none;
          color: white;
        }
        .btn-success:hover {
          background: linear-gradient(90deg, #a8e063, #56ab2f);
          box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        /* Inputs */
        .form-control {
          border-radius: 8px;
          border: 1px solid #ccc;
          box-shadow: none;
          transition: border-color 0.3s;
        }
        .form-control:focus {
          border-color: #6a11cb;
          box-shadow: 0 0 5px rgba(106,17,203,0.3);
        }

        /* Notifications */
        .shiny-notification {
          border-radius: 8px;
          background: #ffffff;
          box-shadow: 0 2px 10px rgba(0,0,0,0.15);
          animation: fadeInUp 0.6s ease;
        }

        @keyframes fadeInUp {
          0% { opacity: 0; transform: translateY(20px); }
          100% { opacity: 1; transform: translateY(0); }
        }

        /* Plotly */
        .plotly {
          background: white;
          border-radius: 12px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.08);
          padding: 15px;
        }

        /* Mobile */
        @media (max-width: 768px) {
          .main-sidebar { width: 100%; height: auto; position: relative; }
          .content-wrapper { margin-left: 0; }
        }
      "))
    ),
    
      
   
    
    tabItems(
      tabItem(tabName = "aperçu", h3("BIENVENUE DANS L'APPLICATION DE MODÉLISATION DE SÉRIES TEMPORELLES" , style = "color: blue;")),
      tabItem(tabName = "accueil",
              fluidRow(
                box(width = 12, status = "primary", solidHeader = TRUE,
                    h1("MODÉLISATION AUTOMATIQUE DES SÉRIES TEMPORELLES", align = "center", style = "color: blue;"),
                    div(style = "text-align: center; margin: 30px 0;",
                        img(src = "img.JPG", width = "70%", height = "auto")),
                    h5("Cette application constitue un outil méthodologique complet pour la modélisation de séries temporelles, quelle que soit leur nature. Elle intègre un ensemble de procédures rigoureuses permettant de structurer, d’analyser et d’interpréter les données chronologiques selon les standards scientifiques en vigueur.", align = "center"),
                    fluidRow(
                      column(width = 6, p("Aliou KA,Student in a Economic and Financial Statistical Analysis CREFDES FASEG UCAD", align = "center")),
                      column(width = 6, p("Septembre-Octobre-Novembre 2025", align = "center"))
                    )
                )
              )
      ),
      
      tabItem(tabName = "import", 
              h3("Chargement et visualisation des Données", align = "center"),
              tabBox(width = 12,
                     tabPanel("Chargement de la base",
                              fluidRow(
                                column(width = 6,
                                       box(width = NULL, title = "Choisissez la base qui contient le fichier à modéliser", status = "primary", solidHeader = T,
                                           fileInput("import_data", "Charger votre fichier",
                                                     accept = c(".csv", ".xls", ".xlsx", ".dta")),
                                           uiOutput("sheet_selector_ui")
                                     
                                              )
                                ),
                                
                                column(width = 6,
                                       box(width = NULL, title = "Choisissez la variable à modéliser", status = "warning", solidHeader = TRUE,
                                           uiOutput("var_selector"),
                                           conditionalPanel(
                                             condition = "input.choix_var_col != null && input.choix-var_col != ''",
                                             numericInput("freq_series", "Fréquence de la série temporelle:",
                                                          value = 12, min = 1, max = 365)
                                           )
                                       )
                                )
                              ),
                              fluidRow(
                                box(width = 12, title = "Aperçu des données",
                                    DT::dataTableOutput("data_preview")
                                )
                              )
                     ),
                     tabPanel("Visualisation de la série",
                              plotlyOutput("graph_serie", height = "500px")
                     ),
                     tabPanel("Visualisation de l'acf",
                              fluidRow(
                                column(width = 6,
                                       box(width = NULL, title = "Nombre maximal d'écarts",
                                           sliderInput("lag_acf", "Lag maximum:", min = 1, max = 40, value = 20, step = 1)
                                       )
                                ),
                                column(width = 6,
                                       box(width = NULL, title = "Niveau de risque",
                                           sliderInput("alpha_acf", "Alpha:", min = 0, max = 0.1, value = 0.05, step = 0.01)
                                       )
                                )
                              ),
                              plotlyOutput("graph_acf", height = "500px")
                     ),
                     tabPanel("Visualisation du pacf",
                              fluidRow(
                                column(width = 6,
                                       box(width = NULL, title = "Nombre maximal d'écarts",
                                           sliderInput("lag_pacf", "Lag maximum:", min = 1, max = 25, value = 20, step = 1)
                                       )
                                ),
                                column(width = 6,
                                       box(width = NULL, title = "Niveau de risque",
                                           sliderInput("alpha_pacf", "Alpha:", min = 0, max = 0.1, value = 0.05, step = 0.01)
                                       )
                                )
                              ),
                              plotlyOutput("graph_pacf", height = "500px")
                     ),
                     tabPanel("Informations",
                              box(width = 12,
                                  h4("Visualisation de la série"),
                                  p("La visualisation graphique de la série temporelle permet d’appréhender l’évolution de la variable dans le temps, en révélant les tendances, les effets saisonniers et les anomalies éventuelles. Cette étape, essentielle en statistique, facilite l’identification de structures internes et guide le choix des méthodes d’analyse ou de modélisation."),
                                  h4("La fonction d'autocorrelation"),
                                  p("La fonction d'autocorrélation (ACF) mesure la dépendance entre les valeurs d'une série temporelle à différents décalages (lags). Elle est essentielle pour détecter des structures internes comme des effets de mémoire ou des cycles."),
                                  h4("La fonction d'autocorrelation partielle"),
                                  p("La fonction d’autocorrélation partielle (PACF) mesure la corrélation entre une observation et une valeur passée, en neutralisant l’effet des décalages intermédiaires. Elle est essentielle pour identifier la structure autorégressive d’une série temporelle.")
                              )
                     )
              )
      ),
      
              
     
              
      tabItem(tabName = "stationnarite", 
              h3("Evaluation de la tendance et de la saisonnalité de la série", align = "center"),
              tabBox(width = 12,
                     tabPanel("Stationnarité",
                              fluidRow(
                                column(width = 8,
                                       fluidRow(
                                         column(width = 6,
                                                box(width = NULL, title = "Type de test",
                                                    selectInput("test_stationnarite", "Choisir un test:",
                                                                choices = c("ADF", "PP", "KPSS"),
                                                                selected = "ADF")
                                                )
                                         ),
                                         column(width = 6,
                                                box(width = NULL, title = "Niveau de risque",
                                                    sliderInput("alpha_stationnarite", "Alpha:",
                                                                min = 0, max = 0.1, value = 0.05, step = 0.01)
                                                )
                                         )
                                       ),
                                       box(width = NULL, title = "Résultats des tests",
                                           verbatimTextOutput("stationnarite_results")
                                       )
                                ),
                                column(width = 4,
                                       box(width = NULL, title = "Explications",
                                           h5("Définition"),
                                           p("La tendance à long terme ou trend représente l'évolution à long terme de la série étudiée. Elle traduit le comportement « moyen » de la variable, une orientation. Elle peut être de plusieurs types : linéaire, logarithmique, exponentielle, parabolique, etc. Elle sera notée 𝑍𝑡."),
                                           h5("Détection de la tendance"),
                                           p("Détection de la tendance (choix entre les différentes tests que sont ADF, PP et KPSS"),
                                           p("Les tests ADF et PP ont pour hypothèse nulle, la non stationnarité de la série étudiée alors que le test de Kpss c'est le contraire( H0: La stationnarité")
                                       )
                                )
                              )
                     ),
                     tabPanel("Saisonnalité",
                              fluidRow(
                                column(width = 8,
                                       fluidRow(
                                         column(width = 6,
                                                box(width = NULL, title = "Méthode de décomposition",
                                                    selectInput("decomp_method", "Méthode de décomposition:",
                                                                choices = c("Additive" = "additive",
                                                                            "Multiplicative" = "multiplicative"),
                                                                selected = "additive")
                                                )
                                         ),
                                         column(width = 6,
                                                box(width = NULL, title = "Test de saisonnalité",
                                                    checkboxInput("test_seasonality", "Effectuer un test de saisonnalité",
                                                                  value = TRUE)
                                                )
                                         )
                                       ),
                                       box(width = NULL, title = "Décomposition de la série",
                                           plotOutput("seasonality_decomp", height = "500px")
                                       ),
                                       conditionalPanel(
                                         condition = "input.test_seasonality == true",
                                         box(width = NULL, title = "Résultats du test de saisonnalité",
                                             verbatimTextOutput("seasonality_test_results")
                                         )
                                       )
                                ),
                                column(width = 4,
                                       box(width = NULL, title = "Explications",
                                           h5("Saisonnalité"),
                                           p("La saisonnalité ou composante saisonnière correspond à un phénomène qui se répète périodiquement (à intervalles de temps réguliers) avec une forme à peu près constante. En général, le phénomène est dû au rythme des saisons et elle est noté 𝑆𝑡. Les variations saisonnières se déclinent comme des mouvements de pics et de creux successifs qui se répètent presque à l'identique de période en période. La période p des variations saisonnières est la longueur exprimée en unité de temps, séparant deux variations saisonnières dues à un même phénomène ; 𝑆𝑡 = 𝑆𝑡+𝑝 = 𝑆𝑡+2𝑝 = ⋯ =𝑆𝑡+𝑛𝑝,∀𝑛 ∈ ℕ Le facteur saisonnier est donné par la donnée des p termes (𝑆1,𝑆2,…,𝑆𝑝)."),
                                           h5("Décomposition"),
                                           p("La décomposition permet de séparer la série temporelle en plusieurs composantes: tendance, saisonnalité et résidus."),
                                           h5("Méthodes de décomposition"),
                                           p("Additive: On utilise le modèle additif pour modéliser des données où les effets des facteurs sont séparés et additionnés, notamment dans les séries chronologiques(quand les mouvements saisonniers ont une amplitude constante) et en statistique pour représenter des relations non linéaires de manière flexible et interprétable, comme avec les modèle additifs généralisés.Il est aussi utilisé dans le contexte de la prise de décision pour évaluer des alternatives en additionnant les scores de chaque caractéristique."),
                                           p("Multiplicative: Utilisée lorsque l'amplitude des fluctuations saisonnières varie proportionnellement au niveau de la série.")
                                       )
                                )
                              )
                     ),
                     tabPanel("Différenciation",
                              fluidRow(
                                column(width = 8,
                                       fluidRow(
                                         column(width = 6,
                                                box(width = NULL, title = "Paramètres de différenciation",
                                                    numericInput("diff_order", "Ordre de différenciation (d):",  value = 1, min = 0, max = 3),
                                                    numericInput("diff_seasonal_order", "Ordre de différenciation saisonnière (D):",  value = 0, min = 0, max = 2),
                                                    actionButton("apply_diff", "Appliquer la différenciation",
                                                                 class = "btn-primary")
                                                )
                                         ),
                                         column(width = 6,
                                                box(width = NULL, title = "Tests sur série différenciée",
                                                    checkboxInput("test_diff_adf", "Test ADF sur série différenciée", value = TRUE),
                                                    checkboxInput("test_diff_kpss", "Test KPSS sur série différenciée", value = TRUE)
                                                )
                                         )
                                       ),
                                       box(width = NULL, title = "Série différenciée",
                                           plotlyOutput("diff_series_plot")
                                       ),
                                       box(width = NULL, title = "Résultats des tests sur série différenciée",
                                           verbatimTextOutput("diff_test_results")
                                       )
                                ),
                                column(width = 4,
                                       box(width = NULL, title = "Explications",
                                           h5("Différenciation"),
                                           p("La différenciation c'est transformation pour rendre une série temporelle stationnaire en éliminant les tendances et les saisonnalités."),
                                           h5("Différenciation simple (d)"),
                                           p("La différation simple (d) d'une série temporelle consiste à calculer la différence entre deux observations consécutives pour la rendre stationnaire, c'est à dire éliminer la tendance."),
                                           h5("Différenciation saisonnière (D)"),
                                           p("Par contre La différenciation (D) est une opération appliquée aux séries temporelles pour éliminer les cycles saisonniers récurrents et rendre la sériie stationnaire.Elle consiste à calculer la différence entre une observation et l'observation de la même saison précédente(par exemple, la différention entre un mois et le même mois de l'année précédente).")
                                       )
                                )
                              )
                     )
              )
      ),
              
      tabItem(tabName = "modele", h3("Estimation des modèles")),
      tabItem(tabName = "importance", h2("Tests de significativité")),
      tabItem(tabName = "prevision", h2("Prévisions")),
      tabItem(tabName = "robot",
              h3("Assistant Robot Intelligent 🤖", align = "center"),
              box(width = 12, status = "primary", solidHeader = TRUE,
                  title = "Agent conversationel de l'appli",
                  textInput("user_input", "Entrez votre message :","Qu'est-ce qu'une série temporelle?", placeholder = "Tapez ici..."),
                  actionButton("send_btn", "Envoyer", icon = icon("paper-plane"), class = "btn-primary"),
                  br(), br(),
                  verbatimTextOutput("robot_response")
              )
      ),
      
      tabItem(tabName = "export", h2("Exportation des résultats"))
    )
  )
)

# --- Serveur ---
server <- function(input, output, session) {
  observeEvent(input$send_btn, {
    req(input$user_input)
    
    msg <- tolower(input$user_input)
    response <- ""
    
    if (grepl("bonjour", msg)) {
      response <- "Bonjour 👋 ! Comment puis-je vous aider ?"
    } else if (grepl("aide", msg)) {
      response <- "Je peux vous aider à explorer vos données, créer des graphiques ou ajuster des modèles !"
    } else if (grepl("merci", msg)) {
      response <- "Avec plaisir 😄"
    } else {
      response <- "Je suis un petit robot 💡 en développement... posez-moi une question simple !"
    }
    
    output$robot_response <- renderText({ response })
  })
}



# --- Lancement de l'application ---
shinyApp(ui = ui, server = server)
