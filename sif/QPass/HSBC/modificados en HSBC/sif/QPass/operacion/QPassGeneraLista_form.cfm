<cfif isdefined('url.temp') and len(trim(url.temp)) GT 0>
	<cfif FileExists(#url.temp#)>
        <cfheader name="Content-Disposition"	value="attachment;filename=#url.temp#">
        <cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
        <cfcontent type="application/x-zip-compressed" reset="yes" file="#url.temp#" deletefile="yes">
    <cfelse>
        <cf_templatecss>
        <cf_templateheader>
        <form name="form1" action="QPassGeneraLista.cfm" method="post">
            <p>El Archivo temporal no existe.  Presione Regresar para volver a la generacion de las listas</p>
                <p><input type="submit" name="Regresar" value="Regresar" /></p>
        </form>
        <cf_templatefooter>
    </cfif>
	<cfabort>
</cfif>

<cfsetting requesttimeout="3600" enablecfoutputonly="yes">
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Exportacion de Archivos</title>
</head>
<body>
</body>
</html>
</cfoutput>

<cfset fullpath = GetDirectoryFromPath(GetTemplatePath()) & "txt">
<cfset zipfile = "#fullpath#/Listas.zip" >

<cfflush>
<cfflush interval="20">

<cfset This.ListaColor = createobject("component","/sif/QPass/Componentes/QPListaColor")>

<cftransaction>
	<cfset LvarLista = This.ListaColor.fnActualizaTags()>
    <cfset LvarLista = This.ListaColor.fnTagPromotores()>
    <cfset LvarLista = This.ListaColor.fnVentasPrepago()>
    <cftransaction action="commit"/>
</cftransaction>

<cfset This.Lista = createobject("component","InsertaLista")><!---Inicializa el componente---->

<cfoutput>Generacion de Archivos Planos en el servidor...<br /></cfoutput>
<cfoutput>Generando el archivo plano Lista Blanca.....<br /></cfoutput>
<cfset LvarControl=This.Lista.fnGeneraArchivo(session.Ecodigo, session.dsn, 'B', fullpath)>

<cfoutput>Generacion de Archivos Planos en el servidor...<br /></cfoutput>
<cfoutput>Generando el archivo plano Lista Gris.....<br /></cfoutput>
<cfset LvarControl=This.Lista.fnGeneraArchivo(session.Ecodigo, session.dsn, 'G', fullpath)>

<cfoutput>Generacion de Archivos Planos en el servidor...<br /></cfoutput>
<cfoutput>Generando el archivo plano Lista Negra.....<br /></cfoutput>
<cfset LvarControl=This.Lista.fnGeneraArchivo(session.Ecodigo, session.dsn, 'N', fullpath)>

<cfoutput>Compactando Archivo Plano Listas en formato .zip.....<br /></cfoutput>
<cfinvoke component="jarListas" method="jar"
	fullpath="#fullpath#"
	zipfile="#zipfile#" 
/>

<cfoutput>
	<form name="form1" action="QPassGeneraLista.cfm" method="post">
		<p>El Archivo fue generado.  Presione <strong><a href="QPassGeneraLista_form.cfm?Temp=#zipfile#">AQUI</a></strong> para descargarlo</p>
		<p><input type="submit" name="Regresar" value="Regresar" /></p>
	</form>
</cfoutput>

