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

`powershell.exe -ep bypass -File "crear LNK de infeccion.ps1"`

## Explicación de Archivos

### MiInfeccion.ps1

Este es el archivo principal de "infección" del equipo, está en la carpeta "payloads". Este archivo es el que tiene toda la logica del cambio de nombre, y cualquier cambio que se requiera de esa lógica, se puede realizar en ese archivo.

Los puntos que se recomienda editar son los siguientes:
- La extensión final que deja, por defecto es ".palquelee"
- Las extensiones de archivos que va a renombrar, por defecto son: ".doc", ".docx", ".xls", ".xlsx", ".csv", ".ppt", ".pptx", ".msg", ".eml", ".pdf", ".txt", ".bat", ".com", ".zip", ".rar", ".7z", ".jpg", ".jpeg", ".png", ".gif"

A parte de esto, lo único que hace es un loop por las carpetas "Documents", "Desktop" y "Downloads" para "cifrar" todo los archivos con las extensiones definidas anteriormente.

### LNK - crear archivo de infeccion.ps1

El archivo "LNK - crear archivo de infeccion.ps1" es solamente el builder, el que termina generando el archivo .lnk final para el despliegue. 

Este generador toma el código de MiInfeccion.ps1 y lo coloca como argumento (en base64) para una ejecución de Powershell con la ventana oculta en el equipo.

Además, ejecuta el pylnk para crear el acceso directo con la opcion de crear el icono asociado a archivos PDF.

### Reporte Final.lnk

Este es el archivo encargado de la infeccion, el cual debería ser desplegado a las víctimas. Con este archivo, se ejecuta el binario de Powershell con argumento el código para el cifrado de los archivos.

Las etapas en la ejecución del archivo sería algo como:

| Fase 1 | Fase 2 | Fase 3 |
| --- | --- | --- |
| Click en .lnk | Ejecución Powershell | "Cifrado de archivos" |

# Archivo Excel con Macro

## Requerimientos

Para poder generar el archivo con macro necesitas una instancia de Excel en el equipo, porque el script de creación abre una instancia de Excel para poder crear el archivo malicioso.

## Uso

Para usar el código basta utilizar el archivo con algo como lo siguiente:

`powershell.exe -ep bypass -File "crear XLS de infeccion.ps1"`

## Explicación de Archivos

### MiInfeccion.vba

Este es el archivo principal de "infección" del equipo, está en la carpeta "payloads". Este archivo es el que tiene toda la lógica que va a usar Excel para cifrar los archivos, la lógica de infección ocurre cuando se cierra el archivo ("Workbook_BeforeClose").

El archivo final tiene definidas varias funciones internamente:
- ChangeFiles: este metodo es el que renombra los archivos y les cambia el nombre por su nombre original + extensión "palquelee".
- SetImage: este metodo es el que descarga (del mismo Excel) la imagen de fondo de pantalla y la configura como tal.
- Pacman: este método es el que dibuja un pacman de color aleatorio en las celdas.

Las demás definiciones del archivo son principalmente de apoyo para poder hacer la codificación más legible

### bg.jpg

Esta va a ser la imagen que se va a agregar al archivo Excel en la posicion 3000,3000 y finalmente va a quedar de fondo de pantalla. Se puede cambiar por cualquier imagen bmp, jpg, png (otros formatos no han sido probados).

### XLS - crear archivo de infeccion.ps1

El archivo "XLS - crear archivo de infeccion.ps1" es solamente el builder, el que termina generando el archivo .xlsm (Excel con macros) final para el despliegue. 

Este generador toma el código de MiInfeccion.vba y lo coloca como macro en un nuevo archivo .xlsm que crea con la instancia de la aplicación Excel recién abierta. Tiene que forzar el cerrado de la aplicación de Excel para que no se "auto-infecte".

### XLS - agregar payload a archivo.ps1

El archivo "XLS - agregar payload a archivo.ps1" es otro builder, que en vez de generar un archivo totalmente nuevo, se basa en un archivo actual que se tenga (.xlsx) y le agrega la macro y deja un archivo con el mismo nombre en la carpeta de "output".

Es el mismo payload de MiInfeccion.vba y lo coloca en este archivo, al igual que "XLS - crear archivo de infeccion.ps1".

## Warning!

Como este script de creación hace un cerrado forzoso de la aplicación de Excel, se recomienda no estar usando la aplicación en otro tipo de trabajo, porque podrías perder toda la información.

# Vacuna

## Requerimientos

Para poder ejecutar la vacuna solo se necesita usar el mismo equipo infectado y una terminal.

## Uso

Para usar el código de vacuna basta ejecutar el archivo con algo como lo siguiente:

`powershell.exe -ep bypass -File "MiVacuna.ps1"`

Con esto se recuperan todos los archivos que podrían estar infectados del equipo, de las miemas carpetas: "Desktop", "Documents", "Downlaods"
