<style type="text/css">
	<!--
	.style1 {
		color: #FF0000;
		font-weight: bold;
		font-size: 16px;
	}
	.style2 {
		font-size: 14px;
		font-weight: bold;
	}
.style3 {
	font-family: "Times New Roman", Times, serif;
	font-size: 14px;
	font-weight: bold;
}
	-->
</style>

<cfoutput>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<cfif isdefined('Attributes.creaCTid') and Attributes.creaCTid>
		<input type="hidden" name="CTid#Attributes.sufijo#" id="CTid#Attributes.sufijo#" value="<cfif ExisteCuenta>#Attributes.CTid#</cfif>">
	</cfif>

  <table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
	  <td>
		<cf_web_portlet_start tipo="box">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>								
				<cfif (isdefined('rsTipos') and rsTipos.RecordCount eq 1 and rsTipos.FIDCOD eq 1 and rsGarant.permitecargofijo NEQ 'S')
						Or rsTipos.RecordCount eq 0>
						<td align="center">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
							  	<td align="center">
									<span class="style1">Atenci&oacute;n</span>: <span class="style2"><br>No existe un tipo de dep&oacute;sito para la transacci&oacute;n.</span>													  
							  	</td>
							  </tr>
							</table>						
						</td>
						<cfset session.saci.depositoGaranOK = false>
				
				<cfelseif rsGarant.montoPaga GTE 0>	
						<td>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
							  <td align="center"><span class="style3"> Dep&oacute;sito de Garant&iacute;a para #rsGarant.PQdescripcion#: #LSNumberFormat(rsGarant.montoPaga, ',9.00')#
								  #rsGarant.moneda#
								</span></td>
								<!---<td align="center">
									
									<!---<cfif Attributes.verOpciones and rsGarant.CTcondicion neq '0'>--->
									<!---	<a href="javascript: abrePago#Attributes.sufijo#();">
											Opciones
										</a>
									<cfelse>
										&nbsp;
									</cfif>--->
								</td>--->
							  </tr>
							</table>
						</td>
				<cfelse>
						<td align="center">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
							  	<td align="center">
									<span class="style1">Atenci&oacute;n</span>: <span class="style2"><br>No se encuentra disponible la interfaz (Dep&oacute;sito de Garant&iacute;a)</span>													  
							  	</td>
								<!---<td align="center">
									<a href="javascript: abrePago#Attributes.sufijo#();">
										Opciones
									</a>
								</td>--->
							  </tr>
							</table>						
						</td>
						<cfset session.saci.depositoGaranOK = false>
				</cfif>
				</tr>
			</table>
		<cf_web_portlet_end> 
	  </td>
	</tr>
	<tr id="cierra#Attributes.sufijo#">
	  <td>
		<input type="hidden" name="estadoCampos#Attributes.sufijo#" id="estadoCampos#Attributes.sufijo#" value="0">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <td align="right"><label>Paquete</label></td>
			  <td>
				#rsGarant.PQdescripcion#
			  </td>
			  <td align="right"><label>Tipo</label></td>
			  <td>
			  
			  <cfif rsGarant.montoPaga GT 0>
				 <select name="Gtipo#Attributes.sufijo#" id="Gtipo#Attributes.sufijo#" tabindex="1" onChange="javascript: cambioTipo#Attributes.sufijo#(this);">
					<cfloop query="rsTipos">
						<cfif rsTipos.FIDCOD EQ 1>
							<cfif isdefined('rsGarant') and rsGarant.permitecargofijo EQ 'S'>
								<option value="#rsTipos.FIDCOD#"<cfif rsGarant.Gtipo EQ rsTipos.FIDCOD> selected</cfif>>#rsTipos.FIDDES#</option>						
							</cfif>
						<cfelse>
							<cfif isdefined('rsGarant') and Len(Trim(rsGarant.Gid))>
								<option value="#rsTipos.FIDCOD#"<cfif rsGarant.Gtipo EQ rsTipos.FIDCOD> selected</cfif>>#rsTipos.FIDDES#</option>
							<cfelse>
								<option value="#rsTipos.FIDCOD#"<cfif rsTipos.FIDCOD EQ 2> selected</cfif>>#rsTipos.FIDDES#</option>
							</cfif>
																			
	
						</cfif>
					</cfloop>
				</select>
			  <cfelse>				
					<cfquery name="rsTiposDepoCero" datasource="#Attributes.Conexion#">
						select FIDCOD,FIDDES  
						from SSXFID
						where FIDCOD= 1 <!--- CARGOS FIJOS --->
					</cfquery>									
					<cfif isdefined('rsTiposDepoCero')>
						<input type="hidden" name="Gtipo#Attributes.sufijo#" id="Gtipo#Attributes.sufijo#" value="#rsTiposDepoCero.FIDCOD#">
						#rsTiposDepoCero.FIDDES#
					</cfif>
				
				<tr>
				  <td align="right"><label>Monto</label></td>
				  <td colspan="3">
						<input type="hidden" name="Gmonto#Attributes.sufijo#" id="Gmonto#Attributes.sufijo#" value="0">			  
					0.00
				  </td>
				</tr>			
			  </cfif>
			  </td>
			</tr>
			<cfif rsGarant.montoPaga GT 0>
				<tr>
				  <td align="right" width="15%"><label>Monto</label></td>
				  <td width="35%">
					<cfset monto = 0>
					<cfif Len(Trim(rsGarant.Gmonto)) and rsGarant.Gmonto GT 0>
						<cfset monto = LSNumberFormat(rsGarant.Gmonto, ',9.00')>
					</cfif>				  
					<cf_campoNumerico name="Gmonto#Attributes.sufijo#" decimales="2" size="18" maxlength="22" value="#monto#" tabindex="1">
				  </td>
				  <td align="right" width="15%"><label>Moneda</label></td>
				  <td width="35%">
						<cfset idmoneda = "">
						<cfif Len(Trim(rsGarant.Miso4217))>
							<cfset idmoneda = rsGarant.Miso4217>
						<cfelseif Len(Trim(rsGarant.moneda)) >
							<cfset idmoneda = rsGarant.moneda>
						</cfif>	  				
						<cfif isdefined('session.saci.depositoGaranOK') and session.saci.depositoGaranOK and idmoneda NEQ ''>
							<cfquery name="rsMonedasGaranOK" datasource="#Attributes.Conexion#">
								select a.Miso4217, a.Mnombre
								from Monedas a
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
									and a.Miso4217	= <cfqueryparam cfsqltype="cf_sql_char" value="#idmoneda#">
							</cfquery>				
						</cfif>	
							
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr id="monedaOK#Attributes.sufijo#">
							<td>
								
								<cf_moneda
									id = "#idmoneda#"
									sufijo = "#Attributes.sufijo#"
									form = "#Attributes.form#"
									Ecodigo = "#Attributes.Ecodigo#"
									Conexion = "#Attributes.Conexion#">				
							</td>
						  </tr>
						  <tr id="monReadonly#Attributes.sufijo#">
							<td>
								<cfif isdefined('rsMonedasGaranOK') and rsMonedasGaranOK.recordCount GT 0>
									#rsMonedasGaranOK.Mnombre#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						  </tr>
						</table>
				  </td>
				</tr>
				<tr id="bancoyReferencia#Attributes.sufijo#">
				  <td align="right"><label>Banco</label></td>
				  <td>
						<cfset identidad = "">
						<cfif Len(Trim(rsGarant.EFid))>
							<cfset identidad = rsGarant.EFid>
						</cfif>				  
						<cf_entidad
							id = "#identidad#"
							sufijo = "#Attributes.sufijo#"
							form = "#Attributes.form#"
							Ecodigo = "#Attributes.Ecodigo#"
							Conexion = "#Attributes.Conexion#"
							INSCOD = "true"
							>
				  </td>
				  <td align="right"><label>Referencia</label></td>
				  <td>
						<input name="Gref#Attributes.sufijo#" id="Gref#Attributes.sufijo#" type="text" maxlength="30" 
							onfocus="this.select()" style="width: 100%" 
							onblur="javascript: validaBlancos(this);"
							value="<cfif Len(Trim(rsGarant.Gref))>#HTMLEditFormat(rsGarant.Gref)#</cfif>" tabindex="1">
				  </td>
				</tr>
				<tr id="fechaycustodio#Attributes.sufijo#">
				  <td align="right"><label>Fecha</label></td>
				  <td>
					   <cfset finicio = "">
					   <cfif Len(Trim(rsGarant.Ginicio))>
							<cfset finicio = LSDateFormat(rsGarant.Ginicio, 'dd/mm/yyyy')>
					   </cfif>				  
					   <cf_sifcalendario form="#Attributes.form#" name="Ginicio#Attributes.sufijo#" value="#finicio#" tabindex="1">
				  </td>
				  <td style="display:none" align="right"><label>Custodio</label></td>
				  <td style="display:none">
						<input name="Gcustodio#Attributes.sufijo#" id="Gcustodio#Attributes.sufijo#" type="text" maxlength="50" 
							onfocus="this.select()" style="width: 100%" 
							value="<cfif Len(Trim(rsGarant.Gcustodio))>#HTMLEditFormat(rsGarant.Gcustodio)#</cfif>" tabindex="1">
				  </td>
				</tr>
				<tr id="tobservaciones#Attributes.sufijo#">
				  <td align="right"><label>Observaci&oacute;n</label></td>
				  <td colspan="3">
						<input name="Gobs#Attributes.sufijo#" id="Gobs#Attributes.sufijo#" type="text" maxlength="255" 
						onfocus="this.select()" style="width: 100%" 
						value="<cfif Len(Trim(rsGarant.Gobs))>#HTMLEditFormat(rsGarant.Gobs)#</cfif>" tabindex="1">
				  </td>
				</tr>
			</cfif>
		</table>
	  </td>		
	</tr>
  </table>
</cfoutput>
