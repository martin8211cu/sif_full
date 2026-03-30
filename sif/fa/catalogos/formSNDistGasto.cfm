<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Socio" default="Socio" returnvariable="LB_Socio" xmlfile = "formSNDistGasto.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Markup" default="Markup" returnvariable="LB_Markup" xmlfile = "formSNDistGasto.xml">

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
	<cfquery name="rsSNDG" datasource="#Session.DSN#">
		select  SNid,
                 Ecodigo,
                 DistGasto,
                 markup                 
        from SNGastosDistribucion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		      and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNid#">	
	</cfquery>	
    
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="SQLSNDistGasto.cfm" method="post" name="form1">
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
                 <td nowrap>#form.Snnombre#</td>
            </cfif>    
    	</cfif>
	</td>
  </tr>	
  <tr>
  <td align="right" nowrap>#LB_Markup#:&nbsp;</td>
  <td ><input  size="3"type="textbox" name="txtMarkup" id="txtMarkup" align="right" <cfif (modo neq 'ALTA' )> value="#rsSNDG.markup#"</cfif>/>%</td>  <!---<cfif modo neq 'ALTA'  > <cfthrow message="#rsSNDG.markup#"> </cfif>---></tr>
  <tr>
  	<td nowrap colspan="2">
		
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="SNid" value="#rsSNDG.SNid#">
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

	objForm.SNid.required = true;
	objForm.DistGasto.required = true;
</script>
