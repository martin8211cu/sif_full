<!---<cfdump var="#form#">
<cf_dump var="#url#">--->
<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="rptActivosVU_Mes.cfm"
	FileName="Activos.xls"
	title="Activos cuya Vida Útil es diferente a la de Categoría-Clase">
	
<cfif isdefined("form.codigodesde") and form.codigodesde neq "">
	<cfquery name="rsCat1" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.codigodesde#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfset LvarCat1=rsCat1.ACdescripcion>
<cfelse>
<cfset LvarCat1="">
</cfif>

<cfif isdefined("form.codigohasta") and form.codigohasta neq "">
	<cfquery name="rsCat2" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.codigohasta#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfset LvarCat2=rsCat2.ACdescripcion>
<cfelse>
<cfset LvarCat2="">
</cfif>

<cfif isdefined("form.OficinaIni") and form.OficinaIni neq "">
	<cfquery name="rsOfi1" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OficinaIni#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
<cfset LvarOfi1=rsOfi1.Odescripcion>
<cfelse>
<cfset LvarOfi1="">
</cfif>

<cfif isdefined("form.OficinaFin") and form.OficinaFin neq "">
	<cfquery name="rsOfi2" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OficinaFin#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
<cfset LvarOfi2=rsOfi2.Odescripcion>
<cfelse>
<cfset LvarOfi2="">
</cfif>

<cfquery name="consulta" datasource="#session.dsn#">
	select  
	count(1) as cantidad
		from Activos act
			inner join ACategoria cat
			on cat.ACcodigo=act.ACcodigo
			and cat.Ecodigo=act.Ecodigo
			<cfif isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde)) gt 0 and LEN(TRIM(form.codigohasta)) gt 0>
			and act.ACcodigo between #form.codigodesde# and #form.codigohasta#	
			</cfif>
				inner join AClasificacion clas
				on clas.ACcodigo=act.ACcodigo
				and clas.Ecodigo=act.Ecodigo
				and clas.ACid = act.ACid
	where act.Ecodigo  = #session.ecodigo#
	and (act.Avutil - clas.ACvutil) <> 0
	</cfquery>
<cfif consulta.cantidad gt 50000>
	<cf_errorCode	code = "50110" msg = "Los registros superan los 50000, agregue mas filtros">
<cfelse>
<cfquery name="rsConsulta" datasource="#session.dsn#">
	<cfoutput>
select  
distinct (d.Oficodigo),d.Odescripcion,
	Aplaca as Placa,
	cat.ACcodigo, 
	Adescripcion as Descripcion, 
	(cat.ACcodigodesc) as categoria, 
	(clas.ACcodigodesc) as clase, 
	act.Avutil as VidaUtil,
	clas.ACvutil as VidaUC,
	(act.Avutil - clas.ACvutil) as Saldo 
		from Activos act
			inner join ACategoria cat
			on cat.ACcodigo=act.ACcodigo
			and cat.Ecodigo=act.Ecodigo
				<cfif isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde)) gt 0 and LEN(TRIM(form.codigohasta)) gt 0>
			and act.ACcodigo between #form.codigodesde# and #form.codigohasta#	
			</cfif>
				inner join AClasificacion clas
				on clas.ACcodigo=act.ACcodigo
				and clas.Ecodigo=act.Ecodigo
				and clas.ACid = act.ACid
				<cfif isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde)) gt 0 and LEN(TRIM(form.codigohasta)) eq 0>
					and cat.ACcodigo >= #form.codigodesde#
				</cfif>
				<cfif isdefined('form.codigohasta') and LEN(TRIM(form.codigohasta)) gt 0 and isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde)) gt 0>
					and cat.ACcodigo <= #form.codigohasta#
				</cfif>
					inner join AFSaldos a
					on a.Aid=act.Aid
						inner join Oficinas d
						on d.Ecodigo = a.Ecodigo
						and d.Ocodigo = a.Ocodigo
				<cfif isdefined("form.oficinaIni") and Len(Trim(form.oficinaIni)) gt 0>
					and  d.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oficinaIni#">
				</cfif>
				<cfif isdefined("form.oficinaFin") and Len(Trim(form.oficinaFin)) gt 0>
					and  d.Oficodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oficinaFin#">
				</cfif>
		where act.Ecodigo  = #session.ecodigo#
		and (act.Avutil - clas.ACvutil) <> 0
	</cfoutput>
</cfquery>
</cfif>

<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<cfif isdefined("form.imprimir")>
	<tr>
		<td align="right">
			<table width="10%" align="right" border="0" height="25px">
				<tr><td>Usuario:</td><td>#session.Usulogin#</td></tr>
				<tr><td>Fecha:</td><td>#LSDateFormat(now(), 'dd/mm/yyyy')#</td></tr>
			</table>
		</td>
	</tr>
	</cfif>
	<tr><td align="center"><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Inconsistencias Vida Útil</strong></td></tr>
	<tr><td align="center"><strong>Categoría Inicial:</strong> #LvarCat1# <strong> Final </strong>#LvarCat2#</td></tr>	
	<tr><td align="center"><strong>Oficina Inicial:</strong>#LvarOfi1#<strong> Final </strong> #LvarOfi2#</td></tr>	
	<tr><td align="right" style="width:1%"><cfoutput><strong>Usuario:#session.usulogin#</strong></cfoutput></td>
</table>
<br />
</cfoutput>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	 <tr style="padding:10px;">
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Placa</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Descripci&oacute;n</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Categor&iacute;a</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Clase</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Vida Útil</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Saldo de Vida Útil</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Vida Útil Categoría-Clase</td>
	</tr>
	<cfif consulta.cantidad gt 0>
	<cfloop query="rsConsulta">
		<cfoutput>
			<tr>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Placa#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Descripcion#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Categoria#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Clase#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#VidaUtil#</td>
				<td align="right" style="padding:3px;font-size:9px">#Saldo#</td>
				<td align="right" style="padding:3px;font-size:9px">#VidaUC#</td>				
			</tr>		
		</cfoutput>
	</cfloop>

	<cfelse>
		<tr><td colspan="30" align="center">--- No se encontraron registros ---</td></tr>
	<tr><td>&nbsp;</td></tr>
	</cfif>
	<tr><td colspan="30" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	
</table>


