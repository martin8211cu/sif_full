<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Impresi&oacute;n de Cuestionario</title>
</head>
<body>

<cfif isdefined('url.PCid') and not isdefined('form.PCid')>
	<cfset form.PCid = url.PCid >
</cfif>

<cfquery name="data" datasource="sifcontrol">
	select pc.PCnombre, pc.PCdescripcion, pp.PPnumero, pp.PPpregunta, pp.PPtipo, pr.PRtexto
	from PortalCuestionario pc
	
	inner join PortalPregunta pp
	on pc.PCid=pp.PCid
	
	inner join PortalRespuesta pr
	on pp.PPid=pr.PPid
	
	where pc.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	
	order by PPnumero
</cfquery>

<cf_templatecss>
<cfif data.recordcount>
	<table width="100%" cellpadding="0" cellspacing="0">
		<cfoutput>
		<tr><td align="center" class="superTitulo">#data.PCnombre#</td></tr>
		<tr><td align="center" ><strong><font size="2">#data.PCdescripcion#</font></strong></td></tr>
		<tr><td align="center" >&nbsp;</td></tr>
		</cfoutput>
		<cfoutput query="data" group="PPnumero">
			<tr><td><font size="2">#data.PPnumero#.</font> #data.PPpregunta#</td></tr>
			<cfoutput>
				<tr>
					<td style="padding-left:20px;">
					<cfif listcontains('U,M', data.PPtipo) ><font size="2">( )</font><cfelse><font size="2">___</font></cfif>
					<font size="2">#data.PRtexto#</font>
					</td>
				</tr>
			</cfoutput>
			<tr><td>&nbsp;</td></tr>
		</cfoutput>
	</table>
<cfelse>
	<cfquery name="pcdata" datasource="sifcontrol">
		select pc.PCnombre, pc.PCdescripcion, pp.PPnumero, pp.PPpregunta, pp.PPtipo, pr.PRtexto
		from PortalCuestionario pc
		
		left join PortalPregunta pp
		on pc.PCid=pp.PCid
		
		left join PortalRespuesta pr
		on pp.PPid=pr.PPid
		
		where pc.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		
		order by PPnumero
	</cfquery>

	<table width="100%" cellpadding="0" cellspacing="0">
		<cfoutput>
		<tr><td align="center" class="superTitulo">#pcdata.PCnombre#</td></tr>
		<tr><td align="center" ><strong><font size="2">#pcdata.PCdescripcion#</font></strong></td></tr>
		<tr><td align="center" >&nbsp;</td></tr>
				<tr><td align="center" >-- <strong><font size="2">No ha sido definido el cuestionario</font></strong> --</td></tr>
		</cfoutput>
	</table>
</cfif>

</body>
</html>
