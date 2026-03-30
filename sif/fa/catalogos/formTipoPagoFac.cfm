
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
	<cfquery name="rsTipoPagoFac" datasource="#Session.DSN#">
		select   id_TipoPago,
                 codigo_TipoPago,
                 nombre_TipoPago,
                 ts_rversion,
				 TipoPagoSAT,
				 MPid
        from FATipoPago
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		      and id_TipoPago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_TipoPago#">	
	</cfquery>
</cfif>
<cfquery name="rsMetPago" datasource="sifcontrol">
	select  CSATcodigo as Codigo, CSATdescripcion as Descripcion, MPid from CSATMetPago
</cfquery>
<cfquery name="rsTipoPagoSAT" datasource="#session.dsn#">
	select Id_MtdoPAgo,Clave,Concepto
		from CEMtdoPago
		where Ecodigo is null or Ecodigo = #Session.Ecodigo#
</cfquery>
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="SQLTipoPago.cfm" method="post" name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>Código:&nbsp;</td>
    <td nowrap>
		<input name="codigo_TipoPago" type="text"  onkeypress="return justNumbers(event);"
		value="<cfif isdefined("form.codigo_TipoPago") and len(trim(form.codigo_TipoPago))>#trim(form.codigo_TipoPago)#</cfif>">
    </td>
  </tr>	
  <tr>
    <td align="right" nowrap>Nombre Tipo Pago:&nbsp;</td>
    <td nowrap><input name="nombre_TipoPago" type="text" value="<cfif isdefined("form.nombre_TipoPago") and len(trim(form.nombre_TipoPago))>#form.nombre_TipoPago#</cfif>">
  </tr>
  <tr>
  	<td nowrap colspan="2">
		<cfif modo NEQ "ALTA">
			<cfset ts = "">	
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsTipoPagoFac.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="id_TipoPago" value="#rsTipoPagoFac.id_TipoPago#">
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfoutput>
		</cfif>
	</td>
  </tr>
  <tr>
	<td align="right" nowrap><cf_translate key="LB_tipoPagoSAT">Tipo Pago SAT</cf_translate>:&nbsp;</td>
		<td>
          <select name="tipoPagoSAT"  tabindex="1">
            <option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate>---</option>
            <cfloop query="rsTipoPagoSAT">
              <!---  --->
              <option value="#rsTipoPagoSAT.Clave#"
					<cfif (MODO neq "ALTA") and (trim(rsTipoPagoFac.TipoPagoSAT) eq trim(rsTipoPagoSAT.Clave))>selected</cfif>
						>#rsTipoPagoSAT.Clave# #rsTipoPagoSAT.Concepto#</option>
            </cfloop>
          </select>
		</td>
  </tr>
  <tr>
	<td align="right" nowrap>
		<cf_translate key="LB_MetPago">Metodo de Pago</cf_translate>
	</td>
	<td >
        <select name="metPago" tabindex="1" >
        	<option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate>---</option>
        <cfloop query="rsmetPago">
	        <option value="#rsMetPago.MPid#" 
	        		<cfif isdefined("rsTipoPagoFac") and rsTipoPagoFac.MPid EQ rsMetPago.MPid>selected</cfif>>
	        		#HTMLEditFormat(rsMetPago.descripcion)#
	        </option>
        </cfloop>
        </select>
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

	objForm.codigo_TipoPago.required = true;
	objForm.nombre_TipoPago.required = true;
	objForm.metPago.required = true;
	function justNumbers(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
        }
	
</script>
