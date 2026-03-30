
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
	<cfquery name="rsObjetoImpuesto" datasource="#Session.DSN#">
		select  IdObjImp,
                 CSATcodigo,
	             CSATdescripcion,
                 CONVERT(VARCHAR(10),CSATfechaVigencia,103) AS CSATfechaVigencia,
				 CSATestatus,
				 ts_rversion,
				 CSATchekImp

        from CSATObjImpuesto
		where IdObjImp = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IdObjImp#">
	</cfquery>
</cfif>


<!--- Codigos de zona existentes AFGM --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select CSATcodigo
	from CSATObjImpuesto
	where 1=1
	<cfif modo neq "ALTA">
		and CSATcodigo != <cfqueryparam cfsqltype="cf_sql_char" value="#rsObjetoImpuesto.CSATcodigo#">
	</cfif>
</cfquery>


<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>Código Impuesto:&nbsp;</td>
    <td nowrap>
		<input name="codSAT" type="text" 
		value="<cfif isdefined("rsObjetoImpuesto.CSATcodigo") and len(trim(rsObjetoImpuesto.CSATcodigo))>#trim(rsObjetoImpuesto.CSATcodigo)#</cfif>">
    </td>
  </tr>
  <tr>
    <td align="right" nowrap>Descripción de Impuesto:&nbsp;</td>
    <td nowrap><input name="descSAT" type="text"
	value="<cfif isdefined("rsObjetoImpuesto.CSATdescripcion") and len(trim(rsObjetoImpuesto.CSATdescripcion))>#trim(rsObjetoImpuesto.CSATdescripcion)#</cfif>">
  </tr>
<tr>
    <td align="right" nowrap>Fecha de Vigencia:&nbsp;</td>
	<td>
	<cfif isdefined("rsObjetoImpuesto.CSATfechaVigencia") and len(trim(rsObjetoImpuesto.CSATfechaVigencia))>
	<cf_sifcalendario name="fechaVigencia" value="#rsObjetoImpuesto.CSATfechaVigencia#">
	<cfelseif modo EQ "ALTA">
	<cf_sifcalendario name="fechaVigencia">
	</cfif>
	</td>

</tr>
<tr>
    <td align="right" nowrap>Activo:&nbsp;</td>
	<td><input type="checkbox" id="estatus" name="estatus" <cfif isdefined("rsObjetoImpuesto.CSATestatus") and trim(rsObjetoImpuesto.CSATestatus) EQ 1> checked <cfelseif modo EQ "ALTA"> checked </cfif>></td>

</tr

  <tr>
  	<td nowrap colspan="2">
		<cfif modo NEQ "ALTA">
			<cfset ts = "">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsObjetoImpuesto.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="IdObjImp" value="#rsObjetoImpuesto.IdObjImp#">
				<input type="hidden" name="ts_rversion" value="#ts#">
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
		&& "#Trim(rsObjetoImpuesto.CSATcodigo)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
		</cfif>
		) {
		this.error = "El Código Impuesto que intenta insertar ya existe";
		}
		</cfoutput>
	}

	objForm.codSAT.required = true;
	objForm.descSAT.required = true;


	_addValidator("isCodeExists", __CodeExists);

	objForm.codSAT.validateCodeExists();
 	objForm.descSAT.validate = true;


	objForm.codSAT.description="Código Impuesto";
	objForm.descSAT.description="Descripcion de Impuesto";


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