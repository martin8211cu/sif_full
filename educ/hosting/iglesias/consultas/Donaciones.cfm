<cfif not isdefined("form.fTipo") >
	<cfset form.fTipo = "mm">
</cfif>

<cfquery name="rs" datasource="#session.DSN#" >
	select 	datepart(#form.fTipo#, MEDfecha) as MEDfecha, b.MEDnombre, 
			sum(MEDimporte) as importe 
			<cfif isdefined("form.fTipo") and form.fTipo eq 'mm' >
				,case datepart(mm, MEDfecha) 
					when 1 then 'Enero' 
					when 2 then 'Febrero' 
					when 3 then 'Marzo' 
					when 4 then 'Abril' 
					when 5 then 'Mayo' 
					when 6 then 'Junio' 
					when 7 then 'Julio' 
					when 8 then 'Agosto' 
					when 9 then 'Setiembre' 
					when 10 then 'Octubre' 
					when 11 then 'Noviembre' 
					when 12 then 'Diciembre' 
				end as mes
			</cfif>
	from MEDDonacion a, MEDProyecto b
	where a.MEDproyecto=b.MEDproyecto
	  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0 >
		and b.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#">
	</cfif>
	<cfif isdefined("form.fMes") and len(trim(form.fMes)) gt 0 >
		and datepart(mm, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fMes#">
	</cfif>
	<cfif isdefined("form.fAno") and len(trim(form.fAno)) gt 0 >
		and datepart(yy, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fAno#">
	</cfif>
	group by datepart(#form.fTipo#, MEDfecha), MEDnombre
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Gr&aacute;fica de Donaciones
</cf_templatearea>
<cf_templatearea name="body">

	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">

	<table width="100%" cellpadding="5" cellspacing="0">
		<tr><td><cfinclude template="../pNavegacion.cfm"></td></tr>

		<tr>
			<td><cfinclude template="filtro.cfm"></td>
		</tr>
	
	
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center">
		Gráfica de Donaciones
		<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
			<cfoutput>del proyecto <strong>#rs.MEDnombre#</strong></cfoutput>
		</cfif>
		durante 
		<cfif isdefined("form.fMes") and len(trim(form.fMes)) gt 0 >
			<strong><cfswitch expression="#form.fMes#" >
				<cfcase value="1">Enero</cfcase>
				<cfcase value="2">Febrero</cfcase>
				<cfcase value="3">Marzo</cfcase>
				<cfcase value="4">Abril</cfcase>
				
				<cfcase value="5">Mayo</cfcase>
				<cfcase value="6">Junio</cfcase>
				<cfcase value="7">Julio</cfcase>
				<cfcase value="8">Agosto</cfcase>
				
				<cfcase value="9">Setiembre</cfcase>
				<cfcase value="10">Octubre</cfcase>
				<cfcase value="11">Noviembre</cfcase>
				<cfcase value="12">Diciembre</cfcase>
			</cfswitch></strong>
			del
		<cfelse>
			el
		</cfif>
		<cfoutput>
		<cfif isdefined("form.fAno") and len(trim(form.fAno)) gt 0 >
		  <strong>#form.fAno#</strong>.
		<cfelse>
		  <strong>#DatePart("yyyy", Now())#</strong>.
		</cfif>
		</cfoutput>
		</td></tr>
		<tr><td>&nbsp;</td></tr>

<!---
		<cfquery name="rs" datasource="#session.DSN#" >
			select datepart(#form.fTipo#, MEDfecha) as MEDfecha , sum(MEDimporte) as importe
			from MEDDonacion a, MEDProyecto b
			where a.MEDproyecto=b.MEDproyecto
			  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			
			  <cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0 >
				and b.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#">
			  </cfif>
			  <cfif isdefined("form.fMes") and len(trim(form.fMes)) gt 0 >
				and datepart(mm, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fMes#">
			  </cfif>
			  <cfif isdefined("form.fAno") and len(trim(form.fAno)) gt 0 >
				and datepart(yy, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fAno#">
			  </cfif>
			group by datepart(#form.fTipo#, MEDfecha)
		</cfquery>
--->		
		
		<cfif RS.RecordCount gte 1>
			<cfparam name="width" default="600">
			<cfparam name="height" default="300">
			 <tr>
				<td nowrap align="center">
					<cfif form.fTipo eq 'mm'>
						<cfset titulo = "Mes">
						<cfset itemcolumn = "mes">
					<cfelse>
						<cfset titulo = "Semana">
						<cfset itemcolumn = "MEDfecha">
					</cfif>

					<cfchart gridlines="5"
						 xaxistitle="#titulo#" 
						 yaxistitle="Importe" 
						 scalefrom="0" 
						 scaleto="100" 
						 show3d="yes" 
						 showborder="yes" 
						 showlegend="no"
						 chartwidth="#width#"
						 chartHeight="#height#"
						 xOffset="0.07"
						 yOffset="0.07" >
					<cfchartseries
						type="bar"
						query="rs" 
						valuecolumn="importe" 
						serieslabel="" 
						itemcolumn="#itemcolumn#"  >
					</cfchart>
				</td>
			</tr>  
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><em>Gráfica de Donaciones</em></td></tr>
			<tr><td>&nbsp;</td></tr>

		<cfelse>
			<tr><td align="center"><b>No se encontraron Resultados</b></td></tr>	
		</cfif>
		
	</table>


</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
</cf_template>
