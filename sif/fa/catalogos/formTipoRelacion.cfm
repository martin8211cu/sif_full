
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


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

<!--- ConsultasEcodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		 and --->
<cfif modo NEQ "ALTA">
	<cfquery name="rsTipoRelacion" datasource="#Session.DSN#">
		select  empId,
                 CSATcodigo,
	             CSATdescripcion,
				 CSATDefault
        from CSATTipoRel
		where empId = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.empId#">
	</cfquery>
</cfif>


<!--- Codigos de zona existentes AFGM --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select CSATcodigo
	from CSATTipoRel
	where 1=1
	<cfif modo neq "ALTA">
		and CSATcodigo != <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoRelacion.CSATcodigo#">
	</cfif>
</cfquery>


<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>Código Tipo Relacion:&nbsp;</td>
    <td nowrap>
		<input name="codSAT" type="text" 
		value="<cfif isdefined("rsTipoRelacion.CSATcodigo") and len(trim(rsTipoRelacion.CSATcodigo))>#trim(rsTipoRelacion.CSATcodigo)#</cfif>">
    </td>
  </tr>
  <tr>
    <td align="right" nowrap>Descripción de Tipo Relacion:&nbsp;</td>
    <td nowrap><input name="descSAT" type="text"
	value="<cfif isdefined("rsTipoRelacion.CSATdescripcion") and len(trim(rsTipoRelacion.CSATdescripcion))>#trim(rsTipoRelacion.CSATdescripcion)#</cfif>">
  </tr>
<tr>
    <td align="right" nowrap>Activo:&nbsp;</td>
	<td><input type="checkbox" id="estatus" name="estatus" <cfif isdefined("rsTipoRelacion.CSATDefault") and trim(rsTipoRelacion.CSATDefault) EQ 1> checked <cfelseif modo EQ "ALTA"> checked </cfif>></td>

</tr

  <tr>
  	<td nowrap colspan="2">
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="empId" value="#rsTipoRelacion.empId#">
			</cfoutput>
		</cfif>
	</td>
  </tr>

 
  <tr><td>&nbsp;</td></tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
		<cf_templatecss>
		<cfoutput>

		<cfif modo EQ "ALTA">
			<input  type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input  type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
	</td>
  </tr>
</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function __CodeExists(){
		<cfoutput query="rsCodigos">
		var valor = "#Trim(rsCodigos.CSATcodigo)#".toUpperCase( );
		if ( valor == trim(this.value.toUpperCase( ))
		<cfif modo neq "ALTA">
		&& "#Trim(rsTipoRelacion.CSATcodigo)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
		</cfif>
		) {
		this.error = "El Código de Relacion que intenta insertar ya existe";
		}
		</cfoutput>
	}

	objForm.codSAT.required = true;
	objForm.descSAT.required = true;


	_addValidator("isCodeExists", __CodeExists);

	objForm.codSAT.validateCodeExists();
 	objForm.descSAT.validate = true;


	objForm.codSAT.description="Código de Relacion";
	objForm.descSAT.description="Descripcion de Relacion";


	function deshabilitarValidacion(){
		objForm.codSAT.required = false;
		objForm.descSAT.required = false;

	}

	function cambiar(){
		var checkbox = document.getElementById('estatus');
		checkbox.addEventListener( 'change', function() {
			if(this.checked) {
				document.getElementById('estatusID').value = '1'
			}else{
				document.getElementById('estatusID').value = '0'
			}
		});
	}

</script>