<cfif isdefined("Url.cliente_empresarial") and not isdefined("Form.cliente_empresarial")>
	<cfparam name="Form.cliente_empresarial" default="#Url.cliente_empresarial#">
</cfif>

<cfparam name="form.VFPcodigo" default="">
<cfif form.VFPcodigo EQ "" OR isdefined("form.modo") and form.modo EQ "LISTA">
	<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
		<cfinclude template="cuentaFormaPago_form.cfm">
		<cfexit> 
	</cfif>
<cfelse>
	<cfparam name="form.modo" default="CAMBIO">
	<cfinclude template="cuentaFormaPago_form.cfm">
	<cfexit> 
</cfif>

<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="40%" valign="top">
		<cfinvoke component="aspAdmin.Componentes.pListasASP" 
				  method="pLista" 
				  returnvariable="pListaTiposIdentif">
			<cfinvokeargument name="tabla" value="CuentaFormaPago CFP, ValorFormaPago VFP
													, FormaPago fp"/>
			<cfinvokeargument name="columnas" value="convert(varchar,cliente_empresarial) as cliente_empresarial
				, convert(varchar,CFP.VFPcodigo) as VFPcodigo
				, convert(varchar,VFP.FPcodigo) as FPcodigo
				, VFPnombre
				, FPnombre
				, case VFPdefault when 1 then '<img src=''../imagenes/checkMark.gif'' border=0>' end as VFPdefault"/>
			<cfinvokeargument name="desplegar" value="VFPnombre, FPnombre, VFPdefault"/>
			<cfinvokeargument name="etiquetas" value="Nombre,Forma Pago, Default"/>
			<cfinvokeargument name="formatos"  value=""/>
			<cfinvokeargument name="filtro" value=
				"	 CFP.cliente_empresarial = #form.cliente_empresarial#
				 and CFP.VFPcodigo = VFP.VFPcodigo
				 and VFP.FPcodigo=fp.FPcodigo"/>
			<cfinvokeargument name="align" value="left,left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="keys" value="VFPcodigo"/>
			<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
			<cfinvokeargument name="formName" value="form_listaCuentaFormaPago"/>
			<cfinvokeargument name="botones" value="Agregar"/>
		</cfinvoke>	
	</td>
<!---
    <td width="60%" valign="top">
		<cfinclude template="cuentaFormaPago_form.cfm">
	</td>
--->
  </tr>
</table>
<script language="JavaScript1.2" type="text/javascript">
	function funcAgregar(){
		document.form_listaCuentaFormaPago.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
	}
</script>
