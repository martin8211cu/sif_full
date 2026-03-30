<cf_templateheader title="Reporte Detallado IETU">
	<cfset titulo = 'Reporte Resumido IETU'>
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
		
			<form name="repEITU" method="get" action="ReporteIETUresumen.cfm">
					<cfif isdefined("form.mes") and len(trim(form.mes))>
						<cfset mes= form.mes>
					<cfelse>
						<cfset mes=''>
					</cfif>
				<table width="100%">
					<tr>
						<td align="right"><strong>Mes Inicial:</strong></td>
						<td align="left">
							<select name="Mincial" size="1" tabindex="1">
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
						<td align="right"><strong>Mes Final:</strong></td>
						<td align="left">
							<select name="Mfinal" size="1" tabindex="1">
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
						<td align="right"><strong>Año Inicial:</strong></td>
						<td align="left">
								<select name="Ainicial" tabindex="1">
								<cfloop query = "rsPer">
									<cfif isdefined("form.anio") and len(trim(form.anio))>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>" <cfif rsPer.Eperiodo EQ form.anio>selected</cfif>><cfoutput>#rsPer.Eperiodo#</cfoutput></option>
									<cfelse>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option> <cfif isdefined('form.anio') and form.anio EQ "#rsPer.Eperiodo#">selected</cfif>></option>
									</cfif>
								</cfloop>
							</select>
						</td>
						<td align="right"><strong>Año Final:</strong></td>
						<td align="left">
								<select name="Afinal" tabindex="1">
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
						<td align="right"><strong>Formato:</strong>&nbsp;</td>
						<td align="left" colspan="4">
							<select name="formato" tabindex="1"  tabindex="1">
								<option value="flashpaper">flashpaper</option>
								<option value="pdf">pdf</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="4" align="center"><cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar"></td></tr>
				</table>
			<!---	<cfdump var="#form#">
				<cfif isdefined ('url.consul')>
					<cfdump var="#url#">
					hola
				</cfif>--->
			</form>
	
	<cf_web_portlet_end>
<cf_templatefooter>	


<!---
<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte IETU Resumido'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="ReporteIETUresumen.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td   align="right"width="45%"><strong>Año Incial:</strong>&nbsp;</td>
						<td align="left" width="45%"><strong>Año Final</strong>&nbsp;</td>
					</tr>
					<tr>
						<td   align="right"width="45%"><strong>Mes Inicia:</strong>&nbsp;</td>
						<td align="left" width="45%"><strong>Mes Final:</strong>&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><strong>Año:</strong>&nbsp;</td>
						<td align="left">años</td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Inicial:</strong>&nbsp;</td>
						<td ><cf_sifcalendario name="inicio"  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Final:</strong>&nbsp;</td>
						<td><cf_sifcalendario name="ffinal"  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Formato:</strong>&nbsp;</td>
						<td>
							<select name="formato" tabindex="1"  tabindex="1">
								<option value="flashpaper">flashpaper</option>
								<option value="pdf">pdf</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2" align="center"><cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
	<cf_web_portlet_end>

		<cf_qforms>--->
		<script type="text/javascript" language="javascript1.2">
			function limpiar(){
				document.form1.CBid.value=''; 
				document.form1.CBcodigo.value=''; 
				return false;
			}

			objForm.TESid.required = true;
			objForm.TESid.description = 'Tesorería';
			objForm.inicio.required = true;
			objForm.inicio.description = 'Fecha Inicial';
			objForm.ffinal.required = true;
			objForm.ffinal.description = 'Fecha Final';
			document.form1.TESid.focus();
		</script>

