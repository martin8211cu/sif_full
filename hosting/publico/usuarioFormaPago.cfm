<cfparam name="form.VFPcodigo" default="">
<cfif form.VFPcodigo EQ "" OR isdefined("form.modo") and form.modo EQ "LISTA">
	<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
		<cfinclude template="usuarioFormaPago_form.cfm">
		<cfexit> 
	</cfif>
<cfelse>
	<cfparam name="form.modo" default="CAMBIO">
	<cfinclude template="usuarioFormaPago_form.cfm">
	<cfexit> 
</cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Formas de pago
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">


<cf_templatecss>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="40%" valign="top">
		<cfset checked = "'<img name=''checked'' src=''/cfmx/hosting/publico/images/checked.gif'' border=''0''>'">
		<cfset unchecked = "'<img name=''checked'' src=''/cfmx/hosting/publico/images/unchecked.gif'' border=''0''>'">
		<cfinvoke component="aspAdmin.Componentes.pListasASP" 
				  method="pLista" 
				  returnvariable="pListaTiposIdentif">
			<cfinvokeargument name="tabla" value="UsuarioFormaPago CFP, ValorFormaPago VFP
													, FormaPago fp"/>
			<cfinvokeargument name="Conexion" value="sdc">
			<cfinvokeargument name="columnas" value=
			"	convert(varchar,CFP.VFPcodigo) as VFPcodigo
				, convert(varchar,VFP.FPcodigo) as FPcodigo
				, VFPnombre
				, FPnombre
				, VFPdefault = case VFPdefault when 1 then #checked# else #unchecked# end
				"/>
			<cfinvokeargument name="desplegar" value="VFPnombre, FPnombre, VFPdefault"/>
			<cfinvokeargument name="etiquetas" value="Nombre,Forma Pago, Default"/>
			<cfinvokeargument name="formatos"  value=""/>
			<cfinvokeargument name="filtro" value=
				"	 CFP.Usucodigo = #session.Usucodigo#
				 and CFP.Ulocalizacion = '#session.Ulocalizacion#'
				 and CFP.VFPcodigo = VFP.VFPcodigo
				 and VFP.FPcodigo=fp.FPcodigo"/>
			<cfinvokeargument name="align" value="left,left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="keys" value="VFPcodigo"/>
			<cfinvokeargument name="irA" value="usuarioFormaPago.cfm"/>
			<cfinvokeargument name="formName" value="form_listaUsuarioFormaPago"/>
			<cfinvokeargument name="botones" value="Agregar"/>
		</cfinvoke>	
	</td>
<!---
    <td width="60%" valign="top">
		<cfinclude template="UsuarioFormaPago_form.cfm">
	</td>
--->
  </tr>
</table>


</cf_templatearea>
</cf_template>
