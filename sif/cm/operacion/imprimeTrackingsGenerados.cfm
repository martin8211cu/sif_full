<html>
<head>
<title>Lista de Trackings Generados</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfset title = "Lista de Trackings Generados">
<form name="form1">
	<cfif isdefined("url.ListaTG")>
		
		<cfoutput>
		
		<!--- Tabla con el titulo --->
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="1">
			  <tr><td colspan="4">&nbsp;</td></tr>
			  <tr><td colspan="4" align="center" class="Subtitulo"><strong><font size="3">#session.enombre#</font></strong></td></tr>
			  <tr><td nowrap colspan="4">&nbsp;</td></tr>  
			  <tr><td colspan="4" class="tituloAlterno"><strong><font size="2">Lista de Trackings Generados</font></strong></td></tr>
			  <tr><td colspan="4" nowrap>&nbsp;</td></tr>
		</table>
		
		<!--- Tabla con los encabezados --->
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="1">
			<tr class="titulolistas">
				<td nowrap><strong>N° Documento</strong></td>
				<td nowrap><strong>Fecha </strong></td>
				<td nowrap><strong>Socio de Negocio </strong></td>
				<td nowrap><strong>Tracking Generado </strong></td>
			</tr>
			<cfinclude template="../../Utiles/sifConcat.cfm">
			<!--- Loop de la variable que trae los ID de las transacciones con el ID del tracking
				  que generó --->
			<cfloop list="#url.ListaTG#" index="Documento">
			
				<cfset EDIid = GetToken(Documento, 1, "-")>
				<cfset ETidtracking = GetToken(Documento, 2, "-")>
				
				<cfquery name="rsDocumento" datasource="#session.dsn#">
					select edi.Ddocumento, edi.EDIfecha,
						   sn.SNnumero #_Cat# ' ' #_Cat# sn.SNnombre as Socio
					from EDocumentosI edi
						inner join SNegocios sn
							on sn.SNcodigo = edi.SNcodigo
							and sn.Ecodigo = edi.Ecodigo
					where edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						and edi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIid#">
				</cfquery>
				
				<!--- Para cada ID que viene en la variable selecciona los datos  ---->	
				<cfquery name="rsTracking" datasource="#session.dsn#">
					select et.ETconsecutivo
					from ETracking et
					where et.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtracking#">
						and et.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				
				<!--- Detalles --->
				<tr>
					<td>#rsDocumento.Ddocumento#</td>
					<td>#LSDateFormat(rsDocumento.EDIfecha,'dd/mm/yyyy')#</td>
					<td>#rsDocumento.Socio#</td>
					<td>#rsTracking.ETconsecutivo#</td>							
				</tr>
			</cfloop>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
		</table>	
		</cfoutput>					
	</cfif>

	<cf_botones values="Cerrar" functions="window.close();">
</form>

</body>
</html>
