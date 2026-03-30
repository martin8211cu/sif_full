<cfif isdefined("url.IDERROR") and not isdefined("form.IDERROR")>
	<cfset form.IDERROR = url.IDERROR>
</cfif>
 <cf_templateheader title="Bitacora de Procesos"> 
	
	<cfif  isdefined("form.IDERROR") and len(form.IDERROR)>
		<cfquery name = "rsErrorDet" datasource="sifinterfaces">
			select * 
			from SIFLD_Errores
			where ID_Error = #form.IDERROR#
		</cfquery>
	</cfif>
	 
	<form method="post" name="frmError" style="margin:0 0 0 0">
	<cfoutput>	
		<hr>
			<table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="Errores del Documento">
				<table width="200" align="left">
					<tr>
						<td style="font-size:14;font-weight:bold">
							Mensaje de Error
						</td>
					</tr>
					<tr>
						<td style="font-size:10;font-weight:normal">
							#rsErrorDet.MsgError#
						</td>
					</tr>
					<cfif len(rsErrorDet.MsgErrorSQL)>
						<tr>
							<td style="font-size:14;font-weight:bold">
								Detalle de Error
							</td>
						</tr>
						<tr>
							<td style="font-size:10;font-weight:normal">
								#rsErrorDet.MsgErrorDet#
							</td>
						</tr>
					</cfif>
					<cfif len(rsErrorDet.MsgErrorSQL)>
						<tr>
							<td style="font-size:14;font-weight:bold">
								Error SQL
							</td>
						</tr>
						<tr>
							<td style="font-size:10;font-weight:normal">
								#rsErrorDet.MsgErrorSQL#
							</td>
						</tr>
					</cfif>
					<cfif len(rsErrorDet.MsgErrorParam)>
						<tr>
							<td style="font-size:14;font-weight:bold">
								Parametros Error SQL
							</td>
						</tr>
						<tr>
							<td style="font-size:10;font-weight:normal">
								#rsErrorDet.MsgErrorParam#
							</td>
						</tr>
					</cfif>
				</table>
			<cf_web_portlet_end>
		 	</td></tr></table>
		<hr>
	</form>
   	<!----------------------------------------------------  --->
	<cfoutput>
	<table align="center">
		<tr>	
			<td>
				<form action="consola-procesos-Registro.cfm" method="post" style="margin:0 0 0 0" name="sql">
				<input type="hidden" name="ID_Error" value="#rsErrorDet.ID_Error#">
				<input type="hidden" name="ID_Documento" value="#rsErrorDet.ID_Documento#">
				<input type="hidden" name="Tabla" value="#rsErrorDet.Tabla#">
				<input type="hidden" name="Interfaz" value="#rsErrorDet.Interfaz#">
				<input type="submit" name="btnRegresar" value="Regresar">
				</form>
			</td>
		</tr>
	</table>
	</cfoutput>
   <!----------------------------------------------------  --->
	</cfoutput>
	<cfset LvarFiltro = ""> 
	<cfset LvarNavegacion = "">

 <cf_templatefooter>