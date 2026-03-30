<form name="form1" action="/cfmx/sif/ad/Eventos/ControlEventos-sql.cfm" method="post">
	<input type="hidden" name="PaginaInicial" value="<cfoutput>#PaginaInicial#</cfoutput>">
	<input type="hidden" name="tab" value="<cfoutput>#url.tab#</cfoutput>">
	<cfif modo EQ 'CAMBIO'>
		<input type="hidden" name="CEVid" value="<cfoutput>#URL.CEVid#</cfoutput>"/>
	</cfif>
	<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		  	<td width="154"><cfoutput>#labelKey#:</strong></cfoutput></td>
	  	  <td align="left" colspan="2"><cfoutput>#inputKey#</cfoutput></td>
		</tr>	
		<tr>
			<td>Tipo de Evento:</strong></td>
			<td align="left" colspan="2"> 
				<select name="TEVid" <cfif readOnly> disabled="false"</cfif>>
					<cfif Modo NEQ 'CAMBIO'>
						<option value="">No hay Ningún Tipo de Evento</option>
					<cfelse>
						<option value="<cfoutput>#rsEvento.TEVid#</cfoutput>"><cfoutput>#rsEvento.TEVDescripcion#</cfoutput></option>
					</cfif>
						
				</select>
			</td>
		</tr>	
		<tr>
			<td>Descripcion del Evento:</strong></td>
			<td align="left" colspan="2">
<!---NO Identar--->
				<textarea name="CEVDescripcion" cols="35">
<cfoutput>#rtrim(ltrim(rsEvento.CEVDescripcion))#</cfoutput>
			    </textarea>
		    </td>
		</tr>	
		<tr>
			<td>Fecha y Hora del Evento:</strong></td>
			<td width="7" align="left">
		  <cf_sifcalendario form="form1" value="#LSDateFormat(rsEvento.FechaEvento,'dd/mm/yyyy')#" name="FechaEvento"> </td>
				<td width="169" align="left">
		  <cf_hora name="HoraEvento"  value="#rsEvento.HoraEvento#" form="form1"> </td>
			<td width="0"></td>
		</tr>
		<tr><td colspan="3"><cf_botones modo="#modo#"></tr></td>	
	</table>
</form>
<cf_qforms form="form1">
<cfif modo NEQ 'CAMBIO'>
	<cf_qformsRequiredField name="CEVidTabla" 	 	description="#labelKey#">
	<cf_qformsRequiredField name="TEVid" 		 	description="Tipo de Evento">
</cfif>
	<cf_qformsRequiredField name="CEVDescripcion" 	description="Descripcion del Evento">
	<cf_qformsRequiredField name="FechaEvento"      description="Fecha de Evento Evento">
</cf_qforms>	

<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
<cfif modo EQ 'CAMBIO'>
	<cf_tabs width="100%">
		<cf_tab text="Datos Especificos" selected="#url.tab EQ 1#">
			<cfinclude template="ControlEventos-Datos.cfm">
		</cf_tab>
		<cf_tab text="Seguimiento de Estado" selected="#url.tab EQ 2#">
			<cfinclude template="ControlEventos-Estado.cfm">
		</cf_tab>	
		<cf_tab text="Responsables" selected="#url.tab EQ 3#">
			<cfinclude template="ControlEventos-Responsable.cfm">
		</cf_tab>	
	</cf_tabs>
</cfif>							
<script language="javascript" type="text/javascript">
	function TraerTiposEventos(CEVidTabla)
	{
		var param= 'CEVidTabla='+CEVidTabla;
		document.getElementById('ifrCambioVal').src = '/cfmx/sif/ad/Eventos/ControlEventos-frame.cfm?'+param;
	}
</script>