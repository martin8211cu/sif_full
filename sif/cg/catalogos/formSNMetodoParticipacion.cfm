<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Socio" default="Socio" returnvariable="LB_Socio"
xmlfile = "formSNMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_CuentaC" default="Cuenta Credito" returnvariable="LB_CuentaC"
xmlfile = "formSNMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_CuentaD" default="Cuenta Debito" returnvariable="LB_CuentaD"
xmlfile = "formSNMetodoParticipacion.xml">

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

<cfif modo NEQ "ALTA">
	<cfquery name="rsSNMP" datasource="#Session.DSN#">
		select  SNid,
                 Ecodigo,
                 CuentaC,
                 CuentaD
        from SNMetodoParticipacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		      and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNid#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="../../cg/catalogos/SQLSNMetodoParticipacion.cfm" method="post" name="form1" onsubmit="
	if(form1.SNcodigo.value == ''){
alert('Es Necesario Indicar un Socio');
return false;
}else{
return true;
}
">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>#LB_Socio#:&nbsp;</td>
    <td>
		<cfif isdefined('form.SNcodigo') and LEN(trim(form.SNcodigo))>
            <cf_sifsociosnegocios2 tabindex="3" SNtiposocio="C"  size="55" idquery="#form.SNcodigo#">
        <cfelse>
        	<cfif modo EQ "ALTA">
                <cf_sifsociosnegocios2 tabindex="3" SNtiposocio="C" size="55" frame="frame2">
	        <cfelse>
            	<!---<cf_sifsociosnegocios2 tabindex="3" SNtiposocio="C"  size="55" idquery="#form.SNid#">--->
                 #form.Snnombre#
            </cfif>
    	</cfif>
	</td>
  </tr>
 <!--- <tr>
  <td align="right" nowrap>#LB_CuentaC#:&nbsp;</td>
  <td >
  	<cfif modo NEQ "ALTA">
    	<cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="20" tabindex="5">
    <cfelse>
    	<cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="20" tabindex="5">
	</cfif>
  </td>
  </tr>
  <tr>
   <tr>
  <td align="right" nowrap>#LB_CuentaD#:&nbsp;</td>
  <td >
  	<cfif modo NEQ "ALTA">
    	<cf_cuentas NoVerificarPres="yes" cformato="Cformato2" cdescripcion="Cdescripcion2" ccuenta="Ccuenta2" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta2" descwidth="20" tabindex="6">
    <cfelse>
    	<cf_cuentas NoVerificarPres="yes" cformato="Cformato2" cdescripcion="Cdescripcion2" ccuenta="Ccuenta2" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta2" descwidth="20" tabindex="6">
	</cfif>
  </td>
    </tr>--->
  <tr>
  	<td nowrap colspan="2">

		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="SNid" value="#rsSNMP.SNid#">
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

	objForm.SNid.required = true;

</script>
