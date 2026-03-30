<cfif isdefined("url.RHFid") and not isdefined("form.RHFid")>
	<cfset form.RHFid = url.RHFid>
</cfif>
<cfquery name="rsFactores" datasource="#session.DSN#">
	select RHFid,RHFdescripcion,RHFponderacion,Puntuacion 
	from RHFactores
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.RHFid") and len(trim(form.RHFid))>
		and RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
	</cfif>
</cfquery>
<cfset CantMaxGrados = 0>
<cfif rsFactores.recordCount GT 0>
	<cfquery name="rsGradosMaximos" datasource="#session.DSN#">
		select count(RHGid) as grados
		from RHGrados a 
		inner join RHFactores b
			on  a.RHFid  = b.RHFid 
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		group by a.RHFid
	</cfquery>
	<cfif rsGradosMaximos.recordCount GT 0>
		<cfquery name="rsGradosM"  dbtype="query">
			select max(grados) as grados from rsGradosMaximos
		</cfquery>	
		<cfset CantMaxGrados = rsGradosM.grados>
	</cfif>
</cfif>
<cfset columnas = 4 + CantMaxGrados >
<cfset totalRHFponderacion = 0>
<cfset totalPuntuacion = 0>

<cfoutput>
<cfset LvarFileName = "GradosXFactor#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="Puntuación de Grados por Factor" 
	filename="#LvarFileName#"
	irA="GradosXFactorFiltro.cfm" 
	>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr><td  colspan="#columnas#" align="center"><strong>#Session.Enombre#</strong></td></tr>
	<tr><td  colspan="#columnas#" align="center"><strong><cf_translate  key="LB_ReportePuntuacioDeGradosPorFactor">Reporte Puntuación de Grados por Factor</cf_translate></strong></td></tr>
	<tr><td  colspan="#columnas#" >&nbsp;</td></tr>	
	<cfif rsFactores.recordCount GT 0 and CantMaxGrados GT 0> 
	<tr>
		<td  bgcolor="##CCCCCC"><strong><cf_translate  key="LB_Factores">Factores</cf_translate></strong></td>
		<td bgcolor="##CCCCCC" align="right"><strong><cf_translate  key="LB_Porcentaje">Porcentaje</cf_translate></strong></td>
		<td bgcolor="##CCCCCC" align="right"><strong><cf_translate  key="LB_Puntaje">Puntaje</cf_translate></strong></td>
		<td bgcolor="##CCCCCC" align="right"><strong><cf_translate  key="LB_CantidadDeGrados">Cantidad de grados</cf_translate></strong></td>
		<cfloop from="1" to ="#CantMaxGrados#" index="i">
			<td align="right" bgcolor="##CCCCCC"><strong><cf_translate  key="LB_Grado">Grado</cf_translate>&nbsp;#i#</strong></td>
		</cfloop>
	</tr>	
	<cfif rsFactores.recordCount GT 0>
		<cfset llavefactor = -1>
		<cfloop query="rsFactores">
			<cfset llavefactor = rsFactores.RHFid>
			<cfquery name="rsGrados" datasource="#session.DSN#">
				select RHGporcvalorfactor  from RHGrados
				where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llavefactor#">
			</cfquery>

			<tr>
				<td>#rsFactores.RHFdescripcion#</td>
				<td align="right">#LSNumberFormat(rsFactores.RHFponderacion,',.__')# %</td>
				<td align="right">#LSNumberFormat(rsFactores.Puntuacion,',.__')#</td>
			
			<cfset totalRHFponderacion = totalRHFponderacion + rsFactores.RHFponderacion>
			<cfset totalPuntuacion = totalPuntuacion + rsFactores.Puntuacion>

			<cfif rsGrados.recordCount GT 0>
				<td  align="center" > #LSNumberFormat(rsGrados.recordCount,',')#</td>
				<cfloop query="rsGrados">
					<td  align="right"   <cfif rsGrados.recordCount lt 3> style="color:##FF0000"</cfif> > #LSNumberFormat(rsGrados.RHGporcvalorfactor,',.__')#</td>
				</cfloop>
				<cfif rsGrados.recordCount lt CantMaxGrados>
					<cfloop from="1" to ="#CantMaxGrados-rsGrados.recordCount#" index="i">
						<td align="right"   <cfif rsGrados.recordCount lt 3> style="color:##FF0000"</cfif>  >0</td>
					 </cfloop>
				</cfif>	
			<cfelse>
				<td  align="center" >0</td>
				<cfloop from="1" to ="#CantMaxGrados#" index="i">
					<td align="right"   <cfif rsGrados.recordCount lt 3> style="color:##FF0000"</cfif> >0</td>
				 </cfloop>
			</cfif>
			</tr>
		</cfloop>
	</cfif>
	<tr>
		<td bgcolor="##CCCCCC">&nbsp;</td>
		<td bgcolor="##CCCCCC" align="right">#LSNumberFormat(totalRHFponderacion,',.__')# %</td>
		<td bgcolor="##CCCCCC" align="right">#LSNumberFormat(totalPuntuacion,',.__')#</td>
		<td bgcolor="##CCCCCC" colspan="#CantMaxGrados+1#">&nbsp;</td>
	</tr>
	<tr><td colspan="#columnas+1#" align="center">&nbsp;</td></tr>

	<tr><td colspan="#columnas+1#"><cf_translate  key="LB_FactoresConMenosDe3GradosAparecenEnRojo">Factores con menos de 3 grados aparecen en rojo</cf_translate></td></tr>

	
	<cfelse>
		<tr><td colspan="#columnas+1#" align="center">------- <cf_translate  key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> -------</td></tr>
	</cfif>
</table>	
</cfoutput>	

