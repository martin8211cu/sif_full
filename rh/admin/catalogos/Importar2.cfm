<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ArchivoVacio" Default="Archivo vacío" returnvariable="LB_ArchivoVacio" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_ArchivoIncorrecto" Default="Archivo incorrecto" returnvariable="LB_ArchivoIncorrecto" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif Not IsDefined('form.included')>
	<cffile action="read" variable="filecontents" file="#form.file#">
</cfif>
<cfif Len(filecontents) EQ 0><cfthrow message="#LB_ArchivoVacio#"></cfif>
<cfset xml=XMLParse(filecontents)>

<cfset varwddx=XMLSearch(xml,'/export/enc')>
<cfif ArrayLen(varwddx) NEQ 1><cfthrow message="#LB_ArchivoIncorrecto#"></cfif>
<cfwddx action="wddx2cfml" input="#varwddx[1].XmlText#" output="session.importar_enc">

<cfset varwddx=XMLSearch(xml,'/export/det')>
<cfif ArrayLen(varwddx) NEQ 1><cfthrow message="#LB_ArchivoIncorrecto#"></cfif>
<cfwddx action="wddx2cfml" input="#varwddx[1].XmlText#" output="session.importar_det">
<cfif Not IsDefined('form.included')>
	<cflocation url="Importar2a.cfm">
</cfif>

