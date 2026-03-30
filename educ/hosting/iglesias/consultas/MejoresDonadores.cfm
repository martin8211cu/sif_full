<cfif isdefined("url.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>

<style type="text/css">
<!--
.style1 {font-size: medium}
-->
</style>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Mejores Donadores
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
<cfset navBarItems = ArrayNew(1)>
<cfset navBarLinks = ArrayNew(1)>
<cfset navBarStatusText = ArrayNew(1)>

<cfset ArrayAppend(navBarItems,'Donaciones')>
<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">

<table border="0" width="100%" cellpadding="5" cellspacing="0">
	<tr><td colspan="3"><cfinclude template="../pNavegacion.cfm"></td></tr>
	<tr>
		<td colspan="3"><cfinclude template="filtro.cfm"></td>
	</tr>

	<cfset maxRows = 10 >
	<cfif isdefined("form.fCantidad")>
		<cfset maxRows = form.fCantidad >
	</cfif>

	<cfquery name="rs" datasource="#session.DSN#" maxrows="#maxRows#">
		select a.MEpersona, coalesce(b.Pnombre,'Anónimo') + ' ' + coalesce(b.Papellido1, '') +  ' ' + coalesce(b.Papellido2,'') as Pnombre, sum(MEDimporte) as importe
		from MEDDonacion a, MEPersona b, MEDProyecto c
		where a.MEpersona*=b.MEpersona
		  and a.MEDproyecto=c.MEDproyecto
		  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
		  <cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0 >
			and a.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#">
		  </cfif>

		  and a.MEDfecha between <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(vfecha1, 'yyyymmdd')#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(vfecha2, 'yyyymmdd')#">

		  <cfif isdefined("form.fMoneda") and len(trim(form.fMoneda)) gt 0>
	  	  	and a.MEDmoneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fMoneda#">
		</cfif>	

		group by a.MEpersona, coalesce(b.Pnombre,'Anónimo') + ' ' + coalesce(b.Papellido1, '') +  ' ' + coalesce(b.Papellido2,'')
		having sum(MEDimporte) > 0
		order by importe desc
	</cfquery>

	<cfif RS.RecordCount gt 1>

		<tr class="tituloListas"><td width="1%"></td><td><b>Nombre</b></td><td align="right"><b>Monto</b></td></tr>
		<!--- Query para manejar resultados--->
		<cfset rsDatos = QueryNew("numero, importe")>


		<cfoutput query="rs">
			<tr class="<cfif rs.CurrentRow mod 2 eq 0>listaPar<cfelse>listaNon</cfif>">
				<td align="right">#rs.CurrentRow#</td>
				<td>#rs.Pnombre#</td>
				<td align="right">#LSNumberFormat(rs.importe,'9.,00')#</td>
			</tr>

			<cfset fila = QueryAddRow(rsDatos, 1)>
			<cfset tmp  = QuerySetCell(rsDatos, "numero",  rs.CurrentRow) >
			<cfset tmp  = QuerySetCell(rsDatos, "importe", rs.importe ) >

		</cfoutput>

		<tr><td colspan="2">&nbsp;</td></tr>

		<cfparam name="width" default="600">
		<cfparam name="height" default="300">
		 <tr>
			<td nowrap align="center" colspan="3">
				<cfchart showborder="yes" 
					format="flash"
					chartWidth="#width#" 
					chartHeight="#height#"
					scaleFrom=0 
					scaleTo=10 
					gridLines=3 
					labelFormat="number"
					xAxisTitle="Fecha"
					yAxisTitle="Salario"
					show3D="YES" 
					yOffset="0.1"
					url="">
					<cfchartseries
						type="bar" 
						query="rsDatos" 
						valueColumn="importe" 
						itemColumn="numero"
					/>
				</cfchart>
			</td>
		</tr>  

		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><em>Mejores Donadores</em></td></tr>
		<tr><td>&nbsp;</td></tr>

	<cfelse>
		<tr><td align="center" colspan="3"><b>No se encontraron Resultados</b></td></tr>	
	</cfif>

</table>

</cf_templatearea>
</cf_template>