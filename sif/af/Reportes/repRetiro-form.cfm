<cfif isdefined('url.imprimir')>
	<cfif isdefined('url.AGTPid') and not isdefined('form.AGTPid')>
		<cfset form.AGTPid = url.AGTPid>
	</cfif>					
	<cfif isdefined('url.FAplaca') and not isdefined('form.FAplaca')>
		<cfset form.FAplaca = url.FAplaca>
	</cfif>
</cfif>
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }

.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.style5 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 7px;
	font-weight: bold;
}
-->
</style>

<cfquery name="rsQuery" datasource="#session.dsn#" maxrows="15001">
	select a.AGTPid as LAGTPid, 
	coalesce(TAmontolocadq,0.00) as LTAmontolocadq, 
	coalesce(TAmontolocmej,0.00) as LTAmontolocmej, 
	coalesce(TAmontolocrev,0.00) as LTAmontolocrev, 
	b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, 
	rtrim(b.Adescripcion) as LAdescripcion, 
		  coalesce(TAmontolocadq,0)
		+ coalesce(TAmontolocmej,0) 
		+ coalesce(TAmontolocrev,0) 
		- coalesce(TAmontodepadq,0) 
		- coalesce(TAmontodepmej,0) 
		- coalesce(TAmontodeprev,0) 
	as LTAmontoloctot,
	coalesce(TAmontodepadq,0) as TAmontodepadq,
	coalesce(TAmontodepmej,0) as TAmontodepmej,
	coalesce(TAmontodeprev,0) as TAmontodeprev,
	(select ac.ACcodigodesc
		from ACategoria ac
		where ac.Ecodigo = b.Ecodigo
			and ac.ACcodigo = b.ACcodigo
		) as Categoria,
	(select cl.ACcodigodesc
		from AClasificacion cl
		where cl.Ecodigo = b.Ecodigo
			and cl.ACcodigo = b.ACcodigo
			and cl.ACid = b.ACid
		) as Clasificacion,
	(select CFdescripcion
		from CFuncional cf
			where cf.CFid = a.CFid
		) as CFdescripcion, 
		<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)); '-';ltrim(rtrim(o.Odescripcion))" delimiters= ";"> as Oficodigo,
		afrr.AFRdescripcion
		
	from ADTProceso a 
		inner join Activos b 
			on a.Aid = b.Aid 
		   and a.Ecodigo = b.Ecodigo
			
		inner join CFuncional cf
			on cf.CFid = a.CFid
		   and cf.Ecodigo = b.Ecodigo

		inner join Oficinas o
			on o.Ocodigo = cf.Ocodigo
		   and o.Ecodigo = cf.Ecodigo    			
		   
		inner join AGTProceso agt
			on agt.AGTPid  = a.AGTPid 
			  and agt.Ecodigo = a.Ecodigo						

		inner join AFRetiroCuentas afrr
			on afrr.AFRmotivo = agt.AFRmotivo
			  and afrr.Ecodigo = agt.Ecodigo				   
				
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	
	union all
	
	select a.AGTPid as LAGTPid, 
	TAmontolocadq as LTAmontolocadq, 
	TAmontolocmej as LTAmontolocmej, 
	TAmontolocrev as LTAmontolocrev, 
	b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, rtrim(b.Adescripcion) as LAdescripcion, 
		coalesce(TAmontolocadq,0.00)
	  + coalesce(TAmontolocmej,0.00) 
	  + coalesce(TAmontolocrev,0.00) 
	  - coalesce(TAmontodepadq,0.00) 
	  - coalesce(TAmontodepmej,0.00) 
	  - coalesce(TAmontodeprev,0.00) 
	as LTAmontoloctot,
	coalesce(TAmontodepadq,0) as TAmontodepadq,
	coalesce(TAmontodepmej,0) as TAmontodepmej,
	coalesce(TAmontodeprev,0) as TAmontodeprev,
	(select ac.ACcodigodesc
		from ACategoria ac
		where ac.Ecodigo = b.Ecodigo
			and ac.ACcodigo = b.ACcodigo
		) as Categoria,
	(select cl.ACcodigodesc
		from AClasificacion cl
		where cl.Ecodigo = b.Ecodigo
			and cl.ACcodigo = b.ACcodigo
			and cl.ACid = b.ACid
		) as Clasificacion,
	(select CFdescripcion
		from CFuncional cf
			where cf.CFid = a.CFid
		) as CFdescripcion,
		<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)); '-';ltrim(rtrim(o.Odescripcion))" delimiters= ";"> as Oficodigo,
		afrr.AFRdescripcion
		
	from TransaccionesActivos a 
		inner join Activos b 
			on a.Aid = b.Aid 
		   and a.Ecodigo = b.Ecodigo
				
		inner join CFuncional cf
			on cf.CFid = a.CFid
		   and cf.Ecodigo = b.Ecodigo

		inner join Oficinas o
			on o.Ocodigo = cf.Ocodigo
		   and o.Ecodigo = cf.Ecodigo  

		inner join AGTProceso agt
			on agt.AGTPid  = a.AGTPid 
			  and agt.Ecodigo = a.Ecodigo						

		inner join AFRetiroCuentas afrr
			on afrr.AFRmotivo = agt.AFRmotivo
			  and afrr.Ecodigo = agt.Ecodigo		
		   				
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
</cfquery>

<cfif rsQuery.recordcount GT 15000>
	<cf_errorCode	code = "50104" msg = "La cantidad de activos a desplegar sobrepasa los 15000 registros. Reduzca los rangos en los filtros ó descargue archivo. ">
	<cfabort>
</cfif>

<cfquery name="rsAGTProceso" datasource="#session.dsn#">
	select AGTPdescripcion
	from AGTProceso
	where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
</cfquery>
<cfset grupodesc = "">
<cfif isdefined('rsAGTProceso') and rsAGTProceso.recordCount GT 0>
	<cfset grupodesc = rsAGTProceso.AGTPdescripcion>
</cfif>
<cfset HoraReporte = Now()> 
<cf_htmlReportsHeaders 
	title="Impresion de Retiros" 
	filename="repRetiros.xls"
	irA="repRetiro.cfm?AGTPid="
	download="no"
	preview="no">

<table width="100%" border="0" cellspacing="3" cellpadding="0">
	<tr class="areaFiltro">
		<td colspan="14" align="center" bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
	</tr>			
	<tr>
		<td colspan="14" align="center"><span class="style1">Lista de Transacciones de Retiro</span></td>
	</tr>
	<tr>
		<td colspan="14" align="center"><span class="style1"><cfoutput>del grupo #grupodesc#</cfoutput></span></td>
	</tr>		
	<tr>
		<td colspan="14" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
	</tr>		
	<tr class="style6"><td colspan="14">&nbsp;</td></tr>
	<tr class="style5">
		<td align="left">Placa</td>
		<td align="left">Descripci&oacute;n</td>
		<td align="left">Motivo</td>
		<td align="left">Categor&iacute;a</td>
		<td align="left">Clasificaci&oacute;n</td>
		<td align="left">Centro Func.</td>
		<td align="left">Oficina</td>
		<td align="right">Adquisici&oacute;n</td>
		<td align="right">Mejoras</td>
		<td align="right">Revaluaci&oacute;n</td>
		<td align="right">Dep. Acum. Adq.</td>
		<td align="right">Dep. Acum. Mej.</td>
		<td align="right">Dep. Acum. Rev.</td>
		<td align="right">Totales</td>
	</tr>
	
	<cfset LvarLTAmontolocadqC1 = 0>
	<cfset LvarLTAmontolocmejC1 = 0>
	<cfset LvarLTAmontolocrevC1 = 0>
	<cfset LvarTAmontodepadqC1  = 0>
	<cfset LvarTAmontodepmejC1  = 0>
	<cfset LvarTAmontodeprevC1  = 0>
	<cfset LvarLTAmontoloctotC1 = 0>

	<cfflush interval="128">
	<cfoutput query="rsQuery">
		<tr nowrap="nowrap" class="style2">
			<td align="left">&nbsp;&nbsp;#LAplaca#</td>
			<td align="left" nowrap="nowrap">#LAdescripcion#</td>
			<td align="left" nowrap="nowrap">#AFRdescripcion#</td>
			<td align="left" nowrap="nowrap">#Categoria#</td>
			<td align="left" nowrap="nowrap">#Clasificacion#</td>
			<td align="left" nowrap="nowrap">#CFdescripcion#</td>
			<td align="left" nowrap="nowrap">#Oficodigo#</td>
			<td align="right">#NumberFormat(LTAmontolocadq,',_.__')#</td>
			<td align="right">#NumberFormat(LTAmontolocmej,',_.__')#</td>
			<td align="right">#NumberFormat(LTAmontolocrev,',_.__')#</td>
			<td align="right">#NumberFormat(TAmontodepadq,',_.__')#</td>
			<td align="right">#NumberFormat(TAmontodepmej,',_.__')#</td>
			<td align="right">#NumberFormat(TAmontodeprev,',_.__')#</td>
			<td align="right">#NumberFormat(LTAmontoloctot,',_.__')#</td>
		</tr>
		<cfset LvarLTAmontolocadqC1 = LvarLTAmontolocadqC1 + LTAmontolocadq>
		<cfset LvarLTAmontolocmejC1 = LvarLTAmontolocmejC1 + LTAmontolocmej>
		<cfset LvarLTAmontolocrevC1 = LvarLTAmontolocrevC1 + LTAmontolocrev>
		<cfset LvarTAmontodepadqC1  = LvarTAmontodepadqC1  + TAmontodepadq>
		<cfset LvarTAmontodepmejC1  = LvarTAmontodepmejC1  + TAmontodepmej>
		<cfset LvarTAmontodeprevC1  = LvarTAmontodeprevC1  + TAmontodeprev>
		<cfset LvarLTAmontoloctotC1 = LvarLTAmontoloctotC1 + LTAmontoloctot>
	</cfoutput>
	<cfoutput>
		<tr nowrap="nowrap">
			<td align="left" colspan="7" class="style5"><strong>Totales</strong></td>
			<td align="right" class="style4">#NumberFormat(LvarLTAmontolocadqC1,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarLTAmontolocmejC1,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarLTAmontolocrevC1,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarTAmontodepadqC1,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarTAmontodepmejC1,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarTAmontodeprevC1,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarLTAmontoloctotC1,',_.__')#</td>
		</tr>
	</cfoutput>
</table>

