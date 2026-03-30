<cfif isdefined("Form.Cambio")>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfif not isdefined("Form.modo")>    
    <cfset modo="ALTA">
  <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
  <cfelse>
    <cfset modo="ALTA">
  </cfif>  
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="sifpublica">
		select a.*,b.EAdescripcion
		from EncuestaPuesto a inner join EmpresaArea b
		  on a.EAid = b.EAid
		where EPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="sifpublica">
	select EPcodigo
	from EncuestaPuesto
</cfquery>

<cfquery  name="rsAreas" datasource="sifpublica">
	select *
	from EmpresaArea
	order by EAdescripcion
</cfquery>

<cfquery  name="rsEmpEnc" datasource="sifpublica">
	select *
	from EncuestaEmpresa
	order by EEnombre
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function deshabilitarValidacion(){
		if (document.form1.botonSel.value == 'Baja' || document.form1.botonSel.value == 'Nuevo' ){
			objForm.EPcodigo.required = false;
			objForm.EPdescripcion.required = false;
		}
	}
	
</script>

<form method="post" name="form1" action="SQLTEPuesto.cfm" onSubmit="return valida();">
	<table align="center" border="0">
    	<tr valign="baseline">
			<td nowrap align="right">Código:</td>
		  	<td colspan="3">
		  		<input type="text" name="EPcodigo" 
					   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EPcodigo#</cfoutput></cfif>" 
					   size="10" maxlength="10" onFocus="this.select();"  >
		  	</td>
    	</tr>
    	<tr valign="baseline">
			<td nowrap align="right">Descripción:</td>
		  	<td colspan="3">
		  		<input type="text" name="EPdescripcion" 
					   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EPdescripcion#</cfoutput></cfif>" 
					   size="60" maxlength="60" onFocus="this.select();"  >
		  	</td>
    	</tr>
		<tr valign="baseline">
			<td align="right">Empresa Encuestadora:</td>
			<td colspan="3">
				<cfoutput>
					<select name="listaEEid" id="EEid">
						<cfif rsEmpEnc.recordCount EQ 0>
						  	<option value="">--No Disponible--</option>
						</cfif>
						<cfloop query="rsEmpEnc">
						  	<option value="#rsEmpEnc.EEid#"
							<cfif modo NEQ 'ALTA' and rsForm.EEid EQ rsEmpEnc.EEid>selected</cfif>>#rsEmpEnc.EEnombre#</option>
						</cfloop>
					</select>
		    	</cfoutput>	
			</td>
    	</tr>
    	<tr valign="baseline">
			<td align="right">Area:</td>
			<td colspan="3">
				<cfif modo eq 'ALTA'>
					<!---cf_EArea EEid="EEid" EAdescripcion="EAdescripcion" EAid="EAid" form = "form1"--->
					<cf_EArea tabindex="1" size = "50">
				<cfelse>
					<!---cf_EArea EEid="EEid" EAdescripcion="EAdescripcion" EAid="EAid" form = "form1" query="#rsForm#"--->		
					<cf_EArea query="#rsForm#" tabindex="1" size = "60">
				</cfif>			  
			</td>
    	</tr>
		<tr valign="baseline">
      		<td colspan="4" align="right" nowrap>
				<div align="center"><cfinclude template="/sif/portlets/pBotones.cfm"></div>
      		</td>
		</tr>
  </table>
  <input type="hidden" name="EPid" 
		   value="<cfif modo neq "ALTA"><cfoutput>#rsform.EPid#</cfoutput></cfif>">
</form>

<script language="JavaScript">

	function valida(){
		document.form1.EPcodigo.disabled = false;
		return true;
	}
	
	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.EPcodigo)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modo neq "ALTA">
				&& "#Trim(rsForm.EPcodigo)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "El código que intenta insertar ya existe";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.EPcodigo.required = true;
	objForm.EPcodigo.description="Código del Puesto";
	objForm.EPdescripcion.required = true;
	objForm.EPdescripcion.description="Descripción del Puesto";
	objForm.EEid.required = true;
	objForm.EEid.description="Empresa Encuestadora";
	objForm.EAid.required = true;
	objForm.EAid.description="Area Profesional";
</script>