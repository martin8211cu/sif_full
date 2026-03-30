<cfif isdefined('url.filtro_ESVcodigo') and not isdefined('form.filtro_ESVcodigo')>
	<cfset form.filtro_ESVcodigo = url.filtro_ESVcodigo>
</cfif>
<cfif isdefined('url.filtro_nombreVend') and not isdefined('form.filtro_nombreVend')>
	<cfset form.filtro_nombreVend = url.filtro_nombreVend>
</cfif>			
<cfif isdefined('url.filtro_ESVidentificacion') and not isdefined('form.filtro_ESVidentificacion')>
	<cfset form.filtro_ESVidentificacion = url.filtro_ESVidentificacion>
</cfif>

<cfset modo = 'ALTA' >
<cfif isdefined("form.ESVid") and len(trim(form.ESVid))>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		Select ESVid
			, Ecodigo
			, Ocodigo
			, ESVcodigo
			, NTIcodigo
			, ESVidentificacion
			, ESVnombre
			, ESVapellido1
			, ESVapellido2
			, ESVdireccion
			, ESVtelefono1
			, ESVtelefono2
			, ESVemail
			, ESVcivil
			, ESVfechanac
			, ESVsexo
			, ESVobs1
			, ESVobs2
			, Ppais
			, ESVfingresoLab
			, BMUsucodigo
			, BMfechaalta
			, ts_rversion
		from ESVendedores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and ESVid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.ESVid#">
	</cfquery>
</cfif>

<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
	select NTIcodigo, NTIdescripcion
	from NTipoIdentificacion
	order by NTIdescripcion
</cfquery>

<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
	order by Pnombre
</cfquery>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js" ></script>
<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfoutput>
	<form action="SQLVendedores.cfm" method="post" name="form1" >
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="ESVid" value="<cfif modo NEQ 'ALTA'>#rsForm.ESVid#</cfif>">
		<input type="hidden" name="filtro_ESVcodigo" value="<cfif isdefined('form.filtro_ESVcodigo') and form.filtro_ESVcodigo NEQ ''><cfoutput>#form.filtro_ESVcodigo#</cfoutput></cfif>">
		<input type="hidden" name="filtro_ESVidentificacion" value="<cfif isdefined('form.filtro_ESVidentificacion') and form.filtro_ESVidentificacion NEQ ''><cfoutput>#form.filtro_ESVidentificacion#</cfoutput></cfif>">
		<input type="hidden" name="filtro_nombreVend" value="<cfif isdefined('form.filtro_nombreVend') and form.filtro_nombreVend NEQ ''><cfoutput>#form.filtro_nombreVend#</cfoutput></cfif>">		
		
		<cfset ts = "">
		<cfif modo NEQ "ALTA">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"></cfinvoke>
			<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
		</cfif>				
	
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr> 
			  <td class="fileLabel"><strong>Nombre</strong></td>
			  <td class="fileLabel"><strong>Primer Apellido</strong></td>
			  <td class="fileLabel"><strong>Segundo Apellido</strong></td>
			</tr>
			<tr> 
			  <td><input name="ESVnombre" tabindex="1" type="text" id="ESVnombre" size="35" onfocus="this.select();" maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsForm.ESVnombre#</cfif>"></td>
			  <td><input name="ESVapellido1" tabindex="1" type="text" id="ESVapellido1" size="35" onfocus="this.select();" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsForm.ESVapellido1#</cfif>"></td>
			  <td><input name="ESVapellido2" tabindex="1" type="text" id="ESVapellido2" size="35" onfocus="this.select();" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsForm.ESVapellido2#</cfif>"></td>
			</tr>
			<tr> 
			  <td class="fileLabel"><strong>Tipo de Identificaci&oacute;n</strong></td>
			  <td class="fileLabel"><strong>Identificaci&oacute;n</strong></td>
			  <td class="fileLabel"><strong>Sexo</strong></td>
			</tr>
			<tr> 
			  <td>
				<select name="NTIcodigo" id="NTIcodigo" tabindex="1">
					<cfloop query="rsTipoIdent">
					  <option value="#rsTipoIdent.NTIcodigo#" <cfif modo NEQ 'ALTA' and rsForm.NTIcodigo EQ rsTipoIdent.NTIcodigo> selected</cfif>>#rsTipoIdent.NTIdescripcion#</option>
					</cfloop>
				</select>
			  </td>
			  <td>
				<input name="ESVidentificacion" tabindex="1" onfocus="this.select();" type="text" id="ESVidentificacion"  value="<cfif modo NEQ 'ALTA'>#rsForm.ESVidentificacion#</cfif>">
			  </td>
			  <td><select name="ESVsexo" id="ESVsexo" tabindex="1">
				<option value="M" <cfif modo NEQ 'ALTA' and rsForm.ESVsexo EQ 'M'> selected</cfif>>Masculino</option>
				<option value="F" <cfif modo NEQ 'ALTA' and rsForm.ESVsexo EQ 'F'> selected</cfif>>Femenino</option>
			  </select></td>
			</tr>
			<tr> 
			  <td class="fileLabel"><strong>Código del Vendedor </strong></td>
			  <td class="fileLabel"><strong>Estación de Servicio</strong></td>
			  <td class="fileLabel"><strong>Fecha Inicio de Laborares </strong></td>
			</tr>
			<tr> 
			  <td><input name="ESVcodigo" tabindex="1" onfocus="this.select();" type="text" id="ESVcodigo" size="15" maxlength="15" value="<cfif modo NEQ 'ALTA'>#rsForm.ESVcodigo#</cfif>" /></td>
			  <td>
					<cfif modo EQ "CAMBIO">
						<cf_sifoficinas form="form1" id="#rsForm.Ocodigo#" tabindex="1">
					<cfelse>
						<cf_sifoficinas form="form1" tabindex="1">
					</cfif>			  
			  </td>
			  <td>
				<cfif modo NEQ 'ALTA'>
					<cfset fechaLab = LSDateFormat(rsForm.ESVfingresoLab, "DD/MM/YYYY")>
				<cfelse>
					<cfset fechaLab = LSDateFormat(Now(), "DD/MM/YYYY")>
				</cfif>
				<cf_sifcalendario form="form1" value="#fechaLab#" name="ESVfingresoLab" tabindex="1">			  
			  </td>
			</tr>				
			<tr> 
			  <td class="fileLabel"><strong>Estado Civil</strong></td>
			  <td class="fileLabel"><strong>Fecha de Nacimiento</strong></td>
			  <td class="fileLabel"><strong>Pa&iacute;s de Nacimiento</strong></td>
			</tr>
			<tr> 
			  <td><select name="ESVcivil" id="ESVcivil" tabindex="1">
				  <option value="0" <cfif modo NEQ 'ALTA' and rsForm.ESVcivil EQ 0> selected</cfif>>Soltero(a)</option>
				  <option value="1" <cfif modo NEQ 'ALTA' and rsForm.ESVcivil EQ 1> selected</cfif>>Casado(a)</option>
				  <option value="2" <cfif modo NEQ 'ALTA' and rsForm.ESVcivil EQ 2> selected</cfif>>Divorciado(a)</option>
				  <option value="3" <cfif modo NEQ 'ALTA' and rsForm.ESVcivil EQ 3> selected</cfif>>Viudo(a)</option>
				  <option value="4" <cfif modo NEQ 'ALTA' and rsForm.ESVcivil EQ 4> selected</cfif>>Union Libre</option>
				  <option value="5" <cfif modo NEQ 'ALTA' and rsForm.ESVcivil EQ 5> selected</cfif>>Separado(a)</option>
				</select></td>
			  <td> 
				<cfif modo NEQ 'ALTA'>
					<cfset fecha = LSDateFormat(rsForm.ESVfechanac, "DD/MM/YYYY")>
				<cfelse>
					<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
				</cfif>
				<cf_sifcalendario form="form1" value="#fecha#" name="ESVfechanac" tabindex="1">
			    </td>
			  <td>
				<select name="Ppais" tabindex="1">
				  <option value="">(Seleccione un Pa&iacute;s)</option>
 				  	<cfloop query="rsPais">
				  		<option value="#rsPais.Ppais#"<cfif modo NEQ 'ALTA' and rsPais.Ppais EQ rsForm.Ppais> selected</cfif>>#Pnombre#</option>
				  	</cfloop>
				</select>
			  </td>
			</tr>
			<tr> 
			  <td class="fileLabel"><strong>Tel&eacute;fono de Residencia</strong></td>
			  <td class="fileLabel"><strong>Tel&eacute;fono Celular</strong></td>
			  <td class="fileLabel"><strong>Direcci&oacute;n electr&oacute;nica</strong></td>
			</tr>
			<tr> 
			  <td><input name="ESVtelefono1" tabindex="1" onfocus="this.select();" type="text" id="ESVtelefono1"  value="<cfif modo NEQ 'ALTA'>#rsForm.ESVtelefono1#</cfif>" size="30" maxlength="30"></td>
			  <td><input name="ESVtelefono2" tabindex="1" onfocus="this.select();" type="text" id="ESVtelefono2"  value="<cfif modo NEQ 'ALTA'>#rsForm.ESVtelefono2#</cfif>" size="30" maxlength="30"></td>
			  <td><input name="ESVemail" tabindex="1" onfocus="this.select();" type="text" id="ESVemail"  value="<cfif modo NEQ 'ALTA'>#rsForm.ESVemail#</cfif>" size="40" maxlength="120"></td>
			</tr>
			<tr> 
			  <td><strong>Observación 1</strong></td>
			  <td>&nbsp;</td>
			  <td><strong>Observación 2 </strong></td>
			</tr>
			<tr> 
			  <td colspan="2">
				  <span class="fileLabel">
					<textarea tabindex="1" name="ESVobs1" id="ESVobs1" onfocus="this.select();" rows="2" style="width: 100%;"><cfif modo NEQ 'ALTA'>#rsForm.ESVobs1#</cfif></textarea>
				  </span>
			  </td>
			  <td>
				  <span class="fileLabel">
					<textarea tabindex="1" name="ESVobs2" id="ESVobs2" onfocus="this.select();" rows="2" style="width: 100%;"><cfif modo NEQ 'ALTA'>#rsForm.ESVobs2#</cfif></textarea>
				  </span>
			  </td>
			</tr>								
			
			<tr>
			  <td class="fileLabel"><strong>Direcci&oacute;n</strong></td>
			  <td class="fileLabel">&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td colspan="3" class="fileLabel">
				<textarea tabindex="1" name="ESVdireccion" onfocus="this.select();" id="ESVdireccion" rows="2" style="width: 100%;"><cfif modo NEQ 'ALTA'>#rsForm.ESVdireccion#</cfif></textarea>
			  </td>
			</tr>
			<tr> 
			  <td colspan="3" align="center">&nbsp;</td>
			</tr>
			<tr> 
			  <td colspan="3" align="center">
					<cf_Botones modo="#modo#" include="Regresar" includevalues="Regresar" tabindex="1">				  
			  </td>
			</tr>
		</table>
	</form>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description="Estación de Servicio";
	objForm.ESVcodigo.required = true;
	objForm.ESVcodigo.description="Código de vendedor";	
	objForm.NTIcodigo.required = true;
	objForm.NTIcodigo.description="Tipo de Identificación";	
	objForm.ESVidentificacion.required = true;
	objForm.ESVidentificacion.description="Identificación";
	objForm.ESVnombre.required = true;
	objForm.ESVnombre.description="Nombre";
	
	function deshabilitarValidacion(){
		objForm.Ocodigo.required = false;
		objForm.ESVcodigo.required = false;
		objForm.NTIcodigo.required = false;
		objForm.ESVidentificacion.required = false;
		objForm.ESVnombre.required = false;
	}
	function funcRegresar(){
		deshabilitarValidacion();
	}
</script>
