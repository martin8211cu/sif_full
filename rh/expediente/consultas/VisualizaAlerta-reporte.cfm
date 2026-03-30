<cfset params="">
<cfif isdefined("Url.RHTid") and not isdefined("form.RHTid")>
	<cfparam name="form.RHTid" default="#url.RHTid#">
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "RHTid=" & form.RHTid>	
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("form.DEid")>
	<cfparam name="form.DEid" default="#url.DEid#">
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "DEid=" & form.DEid>
</cfif>
<cfif isdefined("Url.fechaH") and not isdefined("form.fechaH")>
	<cfparam name="form.fechaH" default="#url.fechaH#">
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "fechaH=" & form.fechaH>
</cfif>
<cfif isdefined("Url.formato") and not isdefined("form.formato")>
	<cfparam name="form.formato" default="#url.formato#">
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "formato=" &  form.formato>
<cfelse >
	<cfparam name="Form.formato" default="flashpaper">
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "formato=flashpaper">
</cfif>

<!--- '/cfmx/rh/expediente/consultas/RecibirAlertas.cfm?RHAAid=' & query.RHAAid & '&RHTid=' & query.RHTid & '&formato=' 
& param.formato & '&fechaH=' & param.fechaH & '&Edescripcion=' & param.Edescripcion & '&DescRangoFechas=' 
& param.DescRangoFechas --->
<cfif isdefined("form.RHTid") >
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "RHTid=" & form.RHTid>	
</cfif>
<cfif isdefined("form.DEid")>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "DEid=" & form.DEid>
</cfif>
<cfif isdefined("form.fechaH")>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "fechaH=" & form.fechaH>
</cfif>

<cfif isdefined("params") and len(trim(params))>
	<cfset actionForm = 'RecibirAlertas.cfm?' & params >
	
<cfelse >
	<cfset actionForm = 'RecibirAlertas.cfm'>
</cfif>

<cf_templatecss>
<cfoutput>	
	<!--- <cf_templateheader title="Visualizar Alertas"> --->
	<form name="reporte" method="get" action="#actionForm#">
		<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
			<tr>
				<td nowrap class="fileLabel" align="center">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_AplicarAlertas"
					Default="Aplicar Alertas"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_AplicarAlertas"/>
					
					
					<input type="submit" name="btnAceptarAll" id="btnAceptarAll" value="#BTN_AplicarAlertas#" onclick="javascript: if (confirm('¿Esta seguro de aplicar todas las alertas?')) return true; else return false;">
				</td>
				<td nowrap class="filelable" align="center">		
					<cfset regresa=''>
				
					<cfset regresa ="VisualizaAlerta.cfm">
				
					<cf_botones regresar="#regresa#" exclude="Alta,Limpiar">
					<cfif isdefined("form.DEid")>
						<input name="DEid" type="hidden" value="#form.DEid#">
					</cfif>
					<cfif isdefined("form.RHTid")>
						<input name="RHTid" type="hidden" value="#form.RHTid#">
					</cfif>
					<cfif isdefined("form.fechaH")>
						<input name="fechaH" type="hidden" value="#form.fechaH#">
					</cfif>
					<cfif isdefined("form.formato") >
						<input name="formato" type="hidden" value="#form.formato#">
					</cfif>
				</td>
			</tr>
		</table>
	</form>

	<iframe src="VisualizaAlerta-reporte2.cfm?RHTid=#url.RHTid#&DEid=#url.DEid#&FechaH=#url.FechaH#&formato=#url.formato#&btnAceptarAll=btnAceptarAll" height="350" width="100%">
	</iframe>
</cfoutput>
<!--- <cf_templatefooter> --->