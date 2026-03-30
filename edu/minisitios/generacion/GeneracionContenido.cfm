<cfquery datasource="sdc" name="rs__contenido__1">
	select MSPtexto from MSPlantilla where MSPplantilla = '1x1'
</cfquery>
<cfif rs__contenido__1.RecordCount EQ 0>
	Error interno: La plantilla '1x1' del sistema no existe.
	<cfabort>
</cfif>
<cfquery datasource="sdc" name="rs__contenido__2">
	select b.MSCtitulo, b.MSCtexto
	from MSContenido b
	where b.Scodigo = #Scodigo#
	  and b.MSCcontenido = #MSCcontenido#
	  and b.MSCexpira > getdate()
</cfquery>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cfoutput>#rs__contenido__2.MSCtitulo#</cfoutput></title>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<link type='text/css' rel='stylesheet' href='shared/minisitio.css' >
</head>
<body>

<cfset src= "AREA-1-">
<cfif Len(rs__contenido__2.MSCtitulo) GT 0 AND rs__contenido__2.MSCtitulo NEQ " ">
	<cfset dst = "<span class='titulo-contenido'>" & rs__contenido__2.MSCtitulo & "</span><br />">
<cfelse>
	<cfset dst = "">
</cfif>    
    
<cfquery datasource="sdc" name="rs__contenido__3">
	select MSIcodigo
	from MSImagen
	where Scodigo = #Scodigo#
	  and MSCcontenido =  #MSCcontenido#
</cfquery> 

<cfset imgcount = 0>
<cfset imgposition = "left">
<cfsavecontent variable="imagetags">
	<cfoutput query="rs__contenido__3">
        <img class='imagen-contenido' height='100px' 
        	src='/jsp/DownloadServlet/MiniSitios/MSIimagen?MSIcodigo=#MSIcodigo#'
            align='#imgposition#'>
		<cfif imgposition EQ "left">
			<cfset imgposition = "right">
		<cfelse>
			<cfset imgposition = "left">
		</cfif>
    </cfoutput>
</cfsavecontent>
<cfset dst = dst & imagetags>
<cfif Len(rs__contenido__2.MSCtexto) GT 0 AND rs__contenido__2.MSCtexto NEQ " ">
	<cfset dst = dst & "<span class='texto-contenido'>" & rs__contenido__2.MSCtexto & "</span>">
</cfif>
<cfoutput>#Replace(rs__contenido__1.MSPtexto, src, dst)#</cfoutput>
<p class='titulo-contenido'>
&lt; <a href='javascript:history.back();' class='titulo-contenido'>Regresar</a>
</p>

</body>
</html>