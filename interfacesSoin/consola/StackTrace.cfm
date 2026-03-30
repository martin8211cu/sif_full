<cf_dbfunction name="op_concat" returnvariable="_cat">
<cfquery name="rsProceso" datasource="sifinterfaces">
	select 	p.IdProceso, 
			<cf_dbfunction name="to_char" args="p.NumeroInterfaz" datasource="sifinterfaces"> #_cat# '=' #_cat# i.Descripcion as Interfaz,
			case when p.OrigenInterfaz = 'S' then 'Originado desde SOIN hacia #session.CEnombre#' else 'Originado desde #session.CEnombre# hacia SOIN' end as Origen,
		<cfif isdefined("url.mec")>
			p.MsgErrorCompleto as msg
		<cfelse>
			p.MsgErrorStack as msg
		</cfif>
	<cfif url.tp EQ 'C'>
	  from InterfazColaProcesos p
	<cfelse>
	  from InterfazBitacoraProcesos p
	</cfif>
			inner join Interfaz i
				on i.NumeroInterfaz = p.NumeroInterfaz
	 where p.CEcodigo 		= #session.CEcodigo#
	   and p.IdProceso		= #url.id#
	   and p.NumeroInterfaz 	= #url.ni#
	   and p.SecReproceso		= #url.sc#
</cfquery>

<cfoutput>
<html>
<head>
<cfif isdefined("url.mec")>
	<title>Mensaje de Error Completo</title>
<cfelse>
	<title>Stack Trace de un Error de Ejecución</title>
</cfif>
<link href="/cfmx/plantillas/login02/login02.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>
<body>
<table class="contenido-lbrborder" style=" background-color:##CCCCCC;" align="center">
	<tr>
		<td>
			Id&nbsp;Proceso:
		</td>
		<td>&nbsp;
			
		</td>
		<td>
			#rsProceso.IdProceso#
		</td>
	</tr>
	<tr>
		<td>
			Interfaz:
		</td>
		<td>&nbsp;
			
		</td>
		<td>
			#rsProceso.Interfaz#
		</td>
	</tr>
	<tr>
		<td valign="top">
		<cfif isdefined("url.mec")>
			Mensaje de Error:
		<cfelse>
			Pila de Errores:
		</cfif>
		</td>
		<td>&nbsp;
			
		</td>
		<td>
			#rsProceso.msg#
		</td>
	</tr>
</table>
</cfoutput>
</body>
</html>
