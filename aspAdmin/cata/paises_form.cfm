<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select  Pnombre
			,rtrim(ltrim(Ppais)) as Ppais
		from Pais
		where Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">
	</cfquery>
</cfif>

<cfquery name="qryCodigos" datasource="#Session.DSN#">
	Select rtrim(ltrim(Ppais)) as Ppais
	from Pais
</cfquery>

<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<form action="paises_SQL.cfm" method="post" name="formPaises">
	
  <table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
    <tr> 
      <td class="tituloMantenimiento" colspan="3" align="center"> <cfif modo eq "ALTA">
          Nuevo Pa&iacute;s 
          <cfelse>
          Modificar Pa&iacute;s </cfif> </td>
    </tr>
    <tr> 
      <td align="right" valign="top"><strong>C&oacute;digo</strong>:&nbsp;</td>
      <td valign="baseline"><input name="Ppais" type="text" id="Ppais" onfocus="javascript:this.select();" <cfif modo neq 'ALTA'> readonly="true"</cfif> value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.Ppais#</cfoutput></cfif>" size="2" maxlength="2"></td>
    </tr>
    <tr> 
      <td align="right" valign="top"><strong>Nombre</strong>:&nbsp;</td>
      <td valign="baseline"><input name="Pnombre" type="text" id="Pnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.Pnombre#</cfoutput></cfif>" size="60" maxlength="60"></td>
    </tr>
    <tr> 
      <td align="center">&nbsp;</td>
      <td align="center">&nbsp;</td>
    </tr>
    <tr> 
      <td align="center" colspan="2"> <cfset mensajeDelete = "¿Desea Eliminar el Idioma ?"> 
        <cfinclude template="../portlets/pBotones.cfm"> </td>
    </tr>
  </table>
</form>	  

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.Ppais.required = false;
		objForm.Pnombre.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.Ppais.required = true;	
		objForm.Pnombre.required = true;		
	}	
//---------------------------------------------------------------------------------------	
	// Se aplica al codigo del idioma 
	function __isValidaCodigo() {
		if(btnSelected("Alta", this.obj.form) || btnSelected("Cambio", this.obj.form)) {
			var existeCodigo = false;
			var ordenList = "";
			var codigosArray = null;			
		
			if(this.value != '') {
				ordenList = "<cfoutput>#ValueList(qryCodigos.Ppais,'~')#</cfoutput>"
				codigosArray = ordenList.split("~");			
								
				// Para validar que no se repita el campo Ppais que ser[ia la llave de la tabla
				for (var i=0; i<codigosArray.length; i++) {
					<cfif modo NEQ "ALTA">
						if ((this.value == codigosArray[i]) && (codigosArray[i] != '<cfoutput>#rsForm.Ppais#</cfoutput>')) {
					<cfelse>
						if (codigosArray[i] == this.value) {
					</cfif>
						existeCodigo = true;
						break;
					}
				}
				
				if (existeCodigo){
					this.error = "El código del País ya existe, favor digitar uno diferente";				
					this.focus();
				}
			}else{
				if(btnSelected("Cambio",this.obj.form))
					this.value = "<cfif isdefined('rsForm')><cfoutput>#rsForm.Ppais#</cfoutput></cfif>";
			}
		}
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValidaCodigo", __isValidaCodigo);
	objForm = new qForm("formPaises");
//---------------------------------------------------------------------------------------
	objForm.Ppais.required = true;
	objForm.Ppais.description = "Código";		
	objForm.Pnombre.required = true;
	objForm.Pnombre.description = "Nombre";		
	objForm.Ppais.validateValidaCodigo();
</script>