<cfparam name="url.tipoimg" default="gif">
<cfparam name="url.codigo" default="temp">
<cfcontent 
   type = "image/#url.tipoimg#" 
   file = "#gettempdirectory()##url.codigo#.#url.tipoimg#" 
   deleteFile = "no">
