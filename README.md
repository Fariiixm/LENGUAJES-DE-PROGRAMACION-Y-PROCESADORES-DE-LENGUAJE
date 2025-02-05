# Lenguajes de Programación y Procesadores de Lenguaje

Este repositorio contiene los materiales y prácticas desarrolladas durante la asignatura "Lenguajes de Programación y Procesadores de Lenguaje".l enfoque principal es el estudio y aplicación de técnicas de análisis léxico y sintáctico, así como la implementación de procesadores de lenguaje utilizando herramientas como **JFlex** y **Java**.
## Contenido del Repositorio

- **Análisis Léxico**: Implementaciones de analizadores léxicos utilizando **JFlex**, una herramienta para generar analizadores léxicos en Java.
- **Análisis Sintáctico**: Desarrollo de analizadores sintácticos que procesan la estructura gramatical de los lenguajes definidos.
- **Autómatas**: Estudio y aplicación de autómatas finitos y otras máquinas de estado para el reconocimiento de patrones en cadenas de texto.
- **Implementaciones en Java**: Código fuente en Java que integra los analizadores léxicos y sintácticos para procesar y compilar lenguajes específicos.
## Requisitos del Sistema

- **Java Development Kit (JDK)**: ersión 8 o superior.
- **JFlex**: erramienta para generar analizadores léxicos en Java.
- **Entorno de Desarrollo Integrado (IDE)**: Se recomienda el uso de Eclipse para facilitar el desarrollo y la ejecución del código.
## Instalación y Ejecución

1. **Clonar el Repositorio**:
   
   git clone https://github.com/Fariiixm/LENGUAJES-DE-PROGRAMACION-Y-PROCESADORES-DE-LENGUAJE.git
   cd LENGUAJES-DE-PROGRAMACION-Y-PROCESADORES-DE-LENGUAJE/LPPL
   
2. **Generar el Analizador Léxico con JFlex**:
   - Ubica el archivo `.flex` correspondiente en el proyecto.   
   - Ejecuta JFlex para generar el analizador léxico:    
     java -jar jflex-full-X.Y.Z.jar path/to/lexer.flex
          (Reemplaza `X.Y.Z` con la versión de JFlex y `path/to/lexer.flex` con la ruta al archivo `.flex`).
3. **Compilar el Código Java**:
  
   javac -d bin src/*.java
  
4. **Ejecutar el Procesador de Lenguaje**:
   
   java -cp bin Main
   
## Uso

Este proyecto está diseñado para analizar y procesar lenguajes definidos mediante gramáticas específicas. Los analizadores léxicos y sintácticos trabajan en conjunto para interpretar y compilar el código fuente proporcionado. Para utilizar el procesador de lenguaje:
- Ejecuta el programa principal (`Main`), que leerá el archivo de entrada con el código fuente a analizar.
- El analizador léxico tokenizará el código, y el analizador sintáctico validará la estructura gramatical.
- Si el código es válido, se procederá a la etapa de compilación o interpretación según lo definido en el proyecto.

