<cfoutput>

<form action="clonacion-sql.cfm" method="post" name="goSQL">
	<input type="hidden" name="ACCION" 			value= "1">
	<input type="hidden" name="Usucodigo" 		value= "#session.Usucodigo#">
	<input type="hidden" name="CEcodigoD" 		value= "#form.CEcodigoD#">
	<input type="hidden" name="CEcodigoO" 		value= "#form.CEcodigoO#">
	<input type="hidden" name="DSND" 			value= "#form.DSND#">
	<input type="hidden" name="DSNO" 			value= "#form.DSNO#">
	<input type="hidden" name="EcodigoD" 		value= "#form.EcodigoD#">
	<input type="hidden" name="EcodigoO" 		value= "#form.EcodigoO#">
	<input type="hidden" name="SScodigoO" 		value= "#form.SScodigoO#">
	<input type="hidden" name="DEid" 			value= "#form.DEid#">
	<input type="hidden" name="AddEmpleado" 	value= "#form.AddEmpleado#">
	
	<input name="fEmpresa" type="hidden" value="<cfif isdefined("form.fEmpresa")>#form.fEmpresa#</cfif>">
	<cfif isdefined("form.accion") and form.accion eq 1 >
		<input name="Usucodigo" type="hidden" value="<cfif isdefined("Form.Usucodigo")>#Form.Usucodigo#</cfif>">
	</cfif>	
</form>
</cfoutput>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Avance de insertado de datos en para DEMOS
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cargando datos en la empresa'>
			<table width="95%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>				
				<tr><td align="center"><strong>
					<font color="#000099" style="font-family: Tahoma; font-size:12px">Por favor, espere unos minutos mientras se cargan los datos para la empresa: &nbsp;<cfoutput><!---#session.EnombreNuevo#---></cfoutput></font></strong>
				</td></tr>
				<tr><td align="center" style="vertical-align:top">
					<iframe name="ifrAvance" style="vertical-align:top;" 
						width ="700"
						height="900"
						frameborder="0"						
						src="barra.cfm?usuario=<cfoutput>#session.usuario#</cfoutput>"
					</iframe>
				</td></tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
