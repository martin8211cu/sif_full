
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
	<cfquery name="rsZonaVenta" datasource="#Session.DSN#">
		select   id_zona,
                 codigo_zona,
	             pais,
                 nombre_zona,
                 ts_rversion
        from ZonaVenta
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		      and id_zona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_zona#">
	</cfquery>
</cfif>

<!---- Combo paises --->
<cfquery name="rsPaises" datasource="asp">
	select Ppais,Pnombre
	from Pais
</cfquery>

<!--- Codigos de zona existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select codigo_zona
	from ZonaVenta
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq "ALTA">
		and codigo_zona != <cfqueryparam cfsqltype="cf_sql_char" value="#rsZonaVenta.codigo_zona#">
	</cfif>
</cfquery>

<!--- Pais por defecto de la empresa --->
<cfquery name="rsPais" datasource="asp">
	select  d.Ppais,
			c.Pnombre
	from Empresa e
	     join Direcciones d
		    on e.id_direccion = d.id_direccion
		 join Pais c
			on d.Ppais = c.Ppais
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>Código:&nbsp;</td>
    <td nowrap>
		<input name="codigo_zona" type="text"  value="<cfif isdefined("rsZonaVenta.codigo_zona") and len(trim(rsZonaVenta.codigo_zona))>#trim(rsZonaVenta.codigo_zona)#</cfif>">
    </td>
  </tr>
  <tr>
    <td align="right" nowrap>Nombre Zona:&nbsp;</td>
    <td nowrap><input name="nombre_zona" type="text" value="<cfif isdefined("rsZonaVenta.nombre_zona") and len(trim(rsZonaVenta.nombre_zona))>#rsZonaVenta.nombre_zona#</cfif>">
  </tr>
  <tr>
    <td align="right" nowrap>País:&nbsp;</td>
	<td>
		<select name="pais" id="pais">
			<option value="" selected>- No especificado -</option>
				<cfloop query="rsPaises">
          			<option value="#rsPaises.Ppais#" <cfif modo NEQ 'ALTA' and (trim(rsPaises.Ppais) EQ trim(rsZonaVenta.pais))>selected<cfelseif modo EQ'ALTA' and (trim(rsPaises.Ppais) EQ trim(rsPais.Ppais))>selected</cfif>>#HTMLEditFormat(rsPaises.Pnombre)#</option>
				</cfloop>
		</select>
  </tr>
  <tr>
  	<td nowrap colspan="2">
		<cfif modo NEQ "ALTA">
			<cfset ts = "">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsZonaVenta.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="id_zona" value="#rsZonaVenta.id_zona#">
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
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#">
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
		var valor = "#Trim(rsCodigos.codigo_zona)#".toUpperCase( );
		if ( valor == trim(this.value.toUpperCase( ))
		<cfif modo neq "ALTA">
		&& "#Trim(rsZonaVenta.codigo_zona)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
		</cfif>
		) {
		this.error = "El código que intenta insertar ya existe";
		}
		</cfoutput>
	}

	objForm.codigo_zona.required = true;
	objForm.nombre_zona.required = true;

	_addValidator("isCodeExists", __CodeExists);

	objForm.codigo_zona.validateCodeExists();
 	objForm.codigo_zona.validate = true;

	objForm.codigo_zona.description="Código Zona";
	objForm.nombre_zona.description="Nombre Zona";

	function deshabilitarValidacion(){
		objForm.codigo_zona.required = false;
		objForm.nombre_zona.required = false;
	}

</script>
