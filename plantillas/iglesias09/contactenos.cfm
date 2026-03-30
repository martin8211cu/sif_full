<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<cfquery name="rsEmpresa" datasource="asp">
	select CEnombre, CEtelefono1, CEtelefono2, CEfax, Ppais, ciudad, estado, direccion1, direccion2
	from CuentaEmpresarial, Direcciones
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.cliente_empresarial#">
	and CuentaEmpresarial.id_direccion = Direcciones.id_direccion
</cfquery>
<cf_template>
	<cf_templatearea name="title">
		Contáctenos<
	</cf_templatearea>	
	<cf_templatearea name="left">
		<cfinclude template="pMenu.cfm">
	</cf_templatearea>	
	<cf_templatearea name="body">
		<cfinclude template="pNavegacion.cfm">
		<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr><td class="right">&nbsp;</td></tr>
		  <tr><td class="right">&nbsp;</td></tr>
		  <tr><td class="right">&nbsp;</td></tr>
		  <tr>
		  	<td class="right">
				<strong><cfoutput>#rsEmpresa.CEnombre#</cfoutput></strong>
			</td>
		  </tr>
  		  <tr>
		  	<td class="right">
				<strong><cfoutput>Direcci&oacute;n:&nbsp;
					<cfif len(trim(rsEmpresa.Ppais)) gt 0>#rsEmpresa.Ppais# </cfif>
					<cfif len(trim(rsEmpresa.ciudad)) gt 0>,#rsEmpresa.ciudad# </cfif>
					<cfif len(trim(rsEmpresa.estado)) gt 0>,#rsEmpresa.estado# </cfif>
					<cfif len(trim(rsEmpresa.direccion1)) gt 0>,#rsEmpresa.direccion1#</cfif>
					</cfoutput></strong>
			</td>
		  </tr>
		  <tr>
		  	<td class="right">
				<strong><cfoutput>Teléfonos:&nbsp;
				#rsEmpresa.CEtelefono1#
				<cfif len(trim(rsEmpresa.CEtelefono2)) gt 0>, #rsEmpresa.CEtelefono2#</cfif>
				</cfoutput></strong>
			</td>
		  </tr>
		  <tr>
		  	<td class="right">
				<strong><cfoutput>Fax:&nbsp;#rsEmpresa.CEfax#</cfoutput></strong>
			</td>
		  </tr>
		  <tr><td class="right">&nbsp;</td></tr>
		  <tr><td class="right">&nbsp;</td></tr>
		  <tr><td class="right">&nbsp;</td></tr>
		</table>
	</cf_templatearea>
</cf_template>