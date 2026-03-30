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
		select * 
		from EmpresaArea
		where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
	</cfquery>
	<cfquery name="rsEmpPuesto" datasource="sifpublica">
		Select 1
		From EncuestaPuesto
		Where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EAid#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="sifpublica">
	select EAid
	from EmpresaArea
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
			objForm.EAid.required = false;
			objForm.EAdescripcion.required = false;
		}
	}
	
</script>

<form method="post" name="form1" action="SQLTEArea.cfm" onSubmit="return valida();">
	<table align="center" border="0">
    	<tr valign="baseline">
			<td nowrap align="right">Descripción:</td>
		  	<td colspan="3">
		  		<input type="text" name="EAdescripcion" 
					   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EAdescripcion#</cfoutput></cfif>" 
					   size="60" maxlength="60" onFocus="this.select();"  >
		  	</td>
    	</tr>
    	<tr valign="baseline">
			<td align="right">Empresa Encuestadora:</td>
			<td colspan="3">
			  <cfoutput>
				  <select name="EEid" id="EEid"
				  		<cfif isdefined("rsEmpPuesto") and rsEmpPuesto.RecordCount GT 0>
							disabled
						</cfif>>
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
      		<td colspan="4" align="right" nowrap>
				<div align="center"><cfinclude template="/sif/portlets/pBotones.cfm"></div>
      		</td>
		</tr>
  </table>
  <input type="hidden" name="EAid" 
		   value="<cfif modo neq "ALTA"><cfoutput>#rsform.EAid#</cfoutput></cfif>">
</form>

<script language="JavaScript">

	function valida(){
		document.form1.EAid.disabled = false;
		return true;
	}
	
	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.EAid)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modo neq "ALTA">
				&& "#Trim(rsForm.EAid)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "El código que intenta insertar ya existe";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.EAdescripcion.required = true;
	objForm.Eadescripcion.description="Descripción del Tipo de Organización";
	objForm.EEid.required = true;
	objForm.EEid.description="Empresa Encuestadora";
</script>