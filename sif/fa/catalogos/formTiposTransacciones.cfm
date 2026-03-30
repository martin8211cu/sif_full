<cfif isdefined("Form.Cambio")  or ( isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo)) gt 0 )>
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
<cfif modo EQ "ALTA">
	<!-- 1. Transacciones -->
	<cfquery name="rsTransacciones" datasource="#Session.DSN#">
		select
			  CCTcodigo, CCTdescripcion
		from CCTransacciones
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        and CCTcodigo not in ( select CCTcodigo from FAtransacciones where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">)
	</cfquery>
<cfelse>
    <cfquery name="rsTransacciones" datasource="#Session.DSN#">
		select
			  a.*,  ct.CCTcodigo, ct.CCTdescripcion
		from FAtransacciones a inner join CCTransacciones ct on a.CCTcodigo = ct.CCTcodigo and a.Ecodigo = ct.Ecodigo
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        and a.CCTcodigo = <cfqueryparam value="#form.CCTcodigo#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cfif>
<form action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" name="form1" >

  <input type="hidden" value="<cfoutput>#modo#</cfoutput>" name="modo" />

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td align="right" nowrap>Transacci&oacute;n:</td>
      <td colspan="2" nowrap><select name="CCTcodigo">
          <cfoutput query="rsTransacciones">
            <cfif modo EQ 'ALTA'>
              <option value="#rsTransacciones.CCTcodigo#">#rsTransacciones.CCTcodigo# #rsTransacciones.CCTdescripcion#</option>
              <cfelse>
              <option value="#rsTransacciones.CCTcodigo#" <cfif #form.CCTcodigo# EQ #rsTransacciones.CCTcodigo#>selected</cfif>>#rsTransacciones.CCTcodigo# #rsTransacciones.CCTdescripcion#</option>
            </cfif>
          </cfoutput> </select></td>
    </tr>
     <tr>
  	<td colspan="2" nowrap align="center"> &nbsp;
 	</td>
  </tr>
  <tr>
  	<td colspan="2" nowrap align="center">
<!--- 		Copiado del portlet de botones para poner el botón Usuarios--->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>
	<!---	<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">--->
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript: return MM_validateReference(document.form1.registrosRef.value) && confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
<!---	document.form1.FCcodigo.alt =	"El campo código de caja"
	document.form1.FCcodigoAlt.alt ="El campo código Alterno"
	document.form1.FCdesc.alt =		"El campo descripción"
	document.form1.Aid.alt =		"El campo almacén"
	document.form1.Ocodigo.alt =	"El campo oficina"
	document.form1.Ccuenta.alt =	"El campo Cuenta contable"
	<cfif modo NEQ "ALTA">
		document.form1.EUcodigo.alt = "El campo Usuario"
		function Editar(Eulin) {
			document.form1.Eulin.value = Eulin;
		}
	</cfif>--->
</script>