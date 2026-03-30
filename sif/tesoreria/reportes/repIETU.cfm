<cf_templateheader title="Reporte Detallado IETU">
	<cfset titulo = 'Reporte Detallado IETU'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	
		<cfif isdefined("url.formatos") and not isdefined("form.formatos")>
			<cfset form.formatos = url.formatos>
		</cfif>
		
		<cfif isdefined("url.anio") and not isdefined("form.anio")>
			<cfset form.anio = url.anio>
		</cfif>
		
		<cfif isdefined("url.mes") and not isdefined("form.mes")>
			<cfset form.mes = url.mes>
		</cfif>
		
		<cfquery name="rsPer" datasource="#Session.DSN#">
			select distinct Speriodo as Eperiodo
			from CGPeriodosProcesados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by Eperiodo desc
		</cfquery>
		
			<form name="repEITU" method="get" action="repIETU_form.cfm">
					<cfif isdefined("form.mes") and len(trim(form.mes))>
						<cfset mes= form.mes>
					<cfelse>
						<cfset mes=''>
					</cfif>
				<table width="100%">
					<tr>
						<td align="right">Mes Inicial:</td>
						<td align="left">
							<select name="mesd" size="1" tabindex="1">
								<option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
								<option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
								<option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
								<option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
								<option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
								<option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
								<option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
								<option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
								<option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
								<option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
								<option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
								<option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
							</select> 
						</td>
						<td align="right">Mes Final:</td>
						<td align="left">
							<select name="mesh" size="1" tabindex="1">
								<option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
								<option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
								<option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
								<option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
								<option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
								<option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
								<option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
								<option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
								<option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
								<option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
								<option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
								<option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
							</select> 
						</td>
					</tr>
					<tr>
						<td align="right">Año Inicial:</td>
						<td align="left">
								<select name="aniod" tabindex="1">
								<cfloop query = "rsPer">
									<cfif isdefined("form.anio") and len(trim(form.anio))>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>" <cfif rsPer.Eperiodo EQ form.anio>selected</cfif>><cfoutput>#rsPer.Eperiodo#</cfoutput></option>
									<cfelse>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option> <cfif isdefined('form.anio') and form.anio EQ "#rsPer.Eperiodo#">selected</cfif>></option>
									</cfif>
								</cfloop>
							</select>
						</td>
						<td align="right">Año Final:</td>
						<td align="left">
								<select name="anioh" tabindex="1">
								<cfloop query = "rsPer">
									<cfif isdefined("form.anio") and len(trim(form.anio))>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>" <cfif rsPer.Eperiodo EQ form.anio>selected</cfif>><cfoutput>#rsPer.Eperiodo#</cfoutput></option>
									<cfelse>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option> <cfif isdefined('form.anio') and form.anio EQ "#rsPer.Eperiodo#">selected</cfif>></option>
									</cfif>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">Formato:</td>
						<td align="left">
							<select name="Formatos" id="Formatos" tabindex="1">
								<option value="1" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 1>selected</cfif>>Flashpaper</option>
								<option value="2" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 2>selected</cfif>>PDF</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="4"><input type="submit" value="Consultar" name="consul"></td>
					</tr>
				</table>
			<!---	<cfdump var="#form#">
				<cfif isdefined ('url.consul')>
					<cfdump var="#url#">
					hola
				</cfif>--->
			</form>
	
	<cf_web_portlet_end>
<cf_templatefooter>	


