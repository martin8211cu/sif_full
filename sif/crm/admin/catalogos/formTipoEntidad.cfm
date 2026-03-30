<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
			select CRMTEid, CEcodigo, Ecodigo, CRMTEcodigo, CRMTEdesc, CRMTEapellido1, CRMTEapellido2, CRMTEdireccion, CRMTEapartado, CRMTEtel1, CRMTEtel2, CRMTEtel3, CRMTEemail, CRMTEidentificacion, CRMTEdonacion,CRMTEdonacionentidad,ts_rversion
			from CRMTipoEntidad
			where CRMTEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(CRMTEcodigo) as CRMTEcodigo
	from CRMTipoEntidad
	where CEcodigo = #session.CEcodigo#
	  and Ecodigo =  #session.Ecodigo#
	<cfif modo neq 'ALTA'>
		and CRMTEid <>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid#">
	</cfif>
</cfquery>

<form name="form1" style="margin:0;" action="SQLTipoEntidad.cfm" method="post" onSubmit="return validar();">
	<cfoutput>
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
			<td colspan="2" class="tituloAlterno">
				<cfif modo neq 'ALTA'>
					Modificaci&oacute;n de Tipo de Entidad
				<cfelse>
					Nuevo de Tipo de Entidad				
				</cfif>			
			</td>
		</tr>		
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>			
		<tr>
			<td align="right">Código:&nbsp;</td>
			<td>
				<input name="CRMTEcodigo" type="text" <cfif modo neq 'ALTA'>disabled</cfif> onFocus="javascript:this.select();" onBlur="javascript:codigos(this);" value="<cfif modo neq 'ALTA'>#trim(rsForm.CRMTEcodigo)#</cfif>" size="12" maxlength="10">
				<cfif modo neq 'ALTA'><input name="CRMTEid" type="hidden" value="<cfif modo neq 'ALTA'>#rsForm.CRMTEid#</cfif>" ></cfif>
			</td>
		</tr>

		<tr>
			<td align="right">Descripción:&nbsp;</td>
			<td><input name="CRMTEdesc" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMTEdesc#</cfif>" size="60" maxlength="80"></td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td nowrap><input type="checkbox" name="CRMTEdonacion" <cfif modo neq 'ALTA' and rsForm.CRMTEdonacion eq '1'>checked</cfif> value="chk1" >Acepta Donaciones</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td nowrap>
				<input type="checkbox" name="CRMTEdonacionentidad" <cfif modo neq 'ALTA' and rsForm.CRMTEdonacionentidad eq '1'>checked</cfif> value="chk1" >Siempre acepta donaciones
			</td>
		</tr>					
		<tr>
			<td colspan="2" align="center">
				<table width="95%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="center">	
						<fieldset><legend><b>Configuración</b></legend>
							<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
								<tr>
									<td nowrap><input type="checkbox" name="CRMTEapellido1" <cfif modo neq 'ALTA' and rsForm.CRMTEapellido1 eq '1'>checked</cfif> value="chk1" >Apellido 1</td>
									<td nowrap><input type="checkbox" name="CRMTEapellido2" <cfif modo neq 'ALTA' and rsForm.CRMTEapellido2 eq '1'>checked</cfif> value="chk2" >Apellido 2</td>
									<td nowrap><input type="checkbox" name="CRMTEidentificacion" <cfif modo neq 'ALTA' and rsForm.CRMTEidentificacion eq '1'>checked</cfif> value="chk3" >Identificaci&oacute;n</td>
								</tr>
								<tr>
									<td nowrap><input type="checkbox" name="CRMTEdireccion" <cfif modo neq 'ALTA' and rsForm.CRMTEdireccion eq '1'>checked</cfif> value="chk4" >Direcci&oacute;n</td>
									<td nowrap><input type="checkbox" name="CRMTEemail"     <cfif modo neq 'ALTA' and rsForm.CRMTEemail eq '1'>checked</cfif> value="chk5" >E-mail</td>
									<td nowrap><input type="checkbox" name="CRMTEapartado" <cfif modo neq 'ALTA' and rsForm.CRMTEapartado eq '1'>checked</cfif> value="chk6" >Apartado</td>
								</tr>
								<tr>
									<td nowrap><input type="checkbox" name="CRMTEtel1" <cfif modo neq 'ALTA' and rsForm.CRMTEtel1 eq '1'>checked</cfif> value="chk7" >Telefono 1</td>
									<td nowrap><input type="checkbox" name="CRMTEtel2" <cfif modo neq 'ALTA' and rsForm.CRMTEtel2 eq '1'>checked</cfif> value="chk8" >Telefono 2</td>
									<td nowrap><input type="checkbox" name="CRMTEtel3" <cfif modo neq 'ALTA' and rsForm.CRMTEtel3 eq '1'>checked</cfif> value="chk9" >Telefono 3</td>
								</tr>
							</table>
						</fieldset>
					</td></tr>
				</table			
			></td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><cfinclude template="/sif/portlets/pBotones.cfm"></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		
	</table>
	</cfoutput>
</form>

<script src="../../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CRMTEcodigo.required = true;
	objForm.CRMTEcodigo.description="Código";
	objForm.CRMTEdesc.required = true;
	objForm.CRMTEdesc.description="Descripción";
	
	function validar(){
		document.form1.CRMTEcodigo.disabled = false;
		return true;
	}
	
	function deshabilitarValidacion(){
		objForm.CRMTEcodigo.required = false;
		objForm.CRMTEdesc.required = false;
	}
	
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.CRMTEcodigo#</cfoutput>'
				if (dato == temp){
					alert('El Código de Tipo de Entidad ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}
		return true;
	}
</script>