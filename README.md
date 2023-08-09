# Ransom64

Es una prueba de concepto de una infección "controlada", para probar la reacción de tanto las víctimas (usuario final) como los equipos internos (o externos) de respuesta a incidentes.

Esta infección controlada tiene un solo objetivo:

> Renombrar los archivos con su nombre completo en Base64 y agregar la extensión "palquelee" al final

Para lograr este objetivo proponemos 2 modelos de infección:
- A través de acceso directo (archivo .lnk)
- A través de archivo Excel con Macro (archivo .xlsm)


# Acceso Directo (.LNK)

## Requerimientos

Para poder generar el archivo .lnk no sirve usar las interfaces que entrega Windows (ya sea la GUI o Powershell), porque pone límite en la cantidad de código que le puedes

Por lo anterior necesitamos usar la librería [pylnk3] (https://github.com/strayge/pylnk), la cual puede ser agregada de múltiples formas

### PIP
`pip install pylnk3`

### Ubuntu
`apt install python3-pylnk`

## Uso

Para usar el código basta utilizar el archivo con algo como lo siguiente:

`powershell.exe -ep bypass -File "crear LNK de infeccion.ps1`

## Explicación de Archivos

### MiInfeccion.ps1
El funcionamiento del código es tomar el powershell escrito en "MiInfeccion.ps1" y agregarlo como código a ejecutar por el acceso directo. Este archivo es el que tiene toda la logica del cambio de nombre, y cualquier cambio que se requiera de esa lógica, se puede realizar en ese archivo.

Los puntos que se recomienda editar son los siguientes:
- La extensión final que deja, por defecto es ".palquelee"
- Las extensiones de archivos que va a renombrar, por defecto son: ".doc", ".docx", ".xls", ".xlsx", ".csv", ".ppt", ".pptx", ".msg", ".eml", ".pdf", ".txt", ".bat", ".com", ".zip", ".rar", ".7z", ".jpg", ".jpeg", ".png", ".gif"

### crear LNK de infeccion.ps1

El archivo "crear LNK de infeccion.ps1" es solamente el builder, el que termina generando el archivo .lnk final para el despliegue. 

Este generador toma el código de MiInfeccion.ps1 y lo coloca como argumento (en base64) para una ejecución de Powershell con la ventana oculta en el equipo.

Además, ejecuta el pylnk para crear el acceso directo con la opcion de crear el icono asociado a archivos PDF.

### Reporte Final.lnk

Este es el archivo encargado de la infeccion, el cual debería ser desplegado a las víctimas. Con este archivo, se ejecuta el binario de Powershell con argumento el código para el cifrado de los archivos.

Las etapas en la ejecución del archivo sería algo como:

| Fase 1 | Fase 2 | Fase 3 |
| --- | --- | --- |
| Click en .lnk | Ejecución Powershell | "Cifrado de archivos" |

# Archivo Excel con Macro

TODO
