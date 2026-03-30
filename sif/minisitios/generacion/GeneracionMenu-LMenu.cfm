<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >

<html>
<link type='text/css' rel='stylesheet' href='shared/minisitio.css' >
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body bgcolor="#e7e7e7" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">

<cfquery datasource="sdc" name="rs">
	Select MSMpadre, MSMmenu, MSMtexto, MSMlink as rsMSMlink, MSMhijos, 
	( select max (MSPGcodigo) 
		from MSPaginaGenerada 
		where MSPaginaGenerada.Scodigo = MSMenu.Scodigo 
		and MSPaginaGenerada.Scodigo = #Scodigo#
		and MSPaginaGenerada.MSPcodigo = MSMenu.MSPcodigo) as MSPGcodigo,
	MSMprofundidad, replicate('&nbsp;', MSMprofundidad * 4) as espacios 
	from MSMenu 
	where Scodigo = #Scodigo #
	order by MSMpath,MSMprofundidad , MSMorden 
</cfquery>
    
<table bgcolor='#e7e7e7' class ='menuF' border='0' cellpadding='0' cellspacing='4' width='100%' >
<cfset menuPadre=''>
<cfset indicadorlinea = false>
<cfoutput query="rs">
	<cfset MSMlink = rsMSMlink>
	<cfif Len(MSPGcodigo) NEQ 0>
		<cfset MSMlink = "p" & MSPGcodigo & ".html">
	<cfelseif Len(MSMlink) EQ 0>
		<cfset MSMlink = "">
	</cfif>
	<tr>
	<td class='menu#MSMprofundidad#' >
	<cfif Len(MSMpadre) NEQ 0>
		<!--- es un submenu o un item --->
		<cfif menuPadre NEQ MSMpadre>
			<!--- estamos cambiando al siguiente padre --->
			<cfset menuPadre = MSMpadre>
		</cfif>
		<cfif MSMhijos EQ 0>
			<!--- no tiene hijos y es de otros niveles de profundidad --->
			#espacios#<a class='link#MSMprofundidad#' target='mainframe2' href='#MSMlink#'><li>#MSMtexto#</li></a>
			<cfset indicadorlinea = true>
		<cfelse>
			#espacios##MSMtexto#
		</cfif>
	<cfelse>
		<!--- boton en barra de menú principal --->
		<cfif MSMhijos EQ 0>
		   <cfif indicadorlinea EQ true >
				<tr><td colspan='3'><hr width='85%'></td></tr>
				<cfset indicadorlinea = false>
			</cfif>
			<tr>
			<td><a class='menu#MSMprofundidad#' target='mainframe2' href='#MSMlink#'>#MSMtexto#</a>
			</td>
			</tr>
			<cfif MSMprofundidad EQ 0>
				<tr><td colspan='3'><hr width='100%'></td></tr>
				<cfset indicadorlinea = false>
			</cfif>
		<cfelse>
			<cfif Len(espacios) EQ 0>&nbsp;	</cfif>
			#espacios##MSMtexto# <!--- // Nivel 0 --->
			<cfset indicadorlinea = false>
		</cfif>
	</cfif>
	</td>
	</tr>
</cfoutput>
</table>
</body>
</html>
