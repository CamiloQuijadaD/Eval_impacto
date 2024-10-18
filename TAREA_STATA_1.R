options(scipen = 999)
pacman::p_load('haven','tidyverse','Matching','lmtest','survey','sjmisc')

datos <- read_dta("Data-tarea-2024.dta")


# a. Test de balance ---------------------------------------------------------
## Variables línea base: edad, género, curso, idioma, educación de los padres

glimpse(datos)

# La variable edad está en formato sin estructura
frq(datos$edad)
unique(datos$edad)
class(datos$`_stu_RegDate`)

## Creación de un diccionario manual para convertir palabras a números
# Cabe señalar que se tuvo que poner en distinto orden, para que se reconozcan los
## números compuestos en el código. También, se pusieron en formato character para
## reemplazar con string_r

diccionario_numeros <- c(
  "twenty years" = '20', "twenty one" = '21', "twenty two" = '22', "twenty three" = '23', 
  "nineteen" = '19', "eighteen" = '18', "seventeen" = '17', "sixteen" = '16',
  "fifteen" = '15', "fourteen" = '14', "thirteen" = '13', "twelve" = '12',
  "eleven" = '11', "ten" = '10', "nine" = '9', "eight" = '8', "seven" = '7',
  "six" = '6', "five" = '5', "four" = '4', "three" = '3', "two" = '2', "one" = '1'
)


datos <- datos |>
  mutate(edad_limpia = tolower(edad)) |> 
  mutate(edad_limpia = str_replace_all(edad_limpia, diccionario_numeros))

frq(datos$edad_limpia) # Se verifica que los números compuestos hayan sido reemplazados correctamente

# Ahora, se extraen los números de las respuestas utilizando expresiones regulares

datos <- datos |> 
  mutate(edad_limpia = str_extract(edad_limpia, "\\d+")) |> 
  mutate(edad_limpia = as.numeric(edad_limpia))

frq(datos$edad_limpia)
frq(datos$edad)
