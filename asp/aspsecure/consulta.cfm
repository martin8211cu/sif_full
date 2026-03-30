	<cf_templateheader title="Autorizadores por Empresa">

	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" 
		tituloalign="center" titulo="Autorizadores por Empresa">
		
		<cfquery datasource="aspsecure" name="datos">
			select ae.Ecodigosdc, a.nombre_autorizador, ca.moneda,
				ca.comisionporc, ca.comisionfija, ae.prioridad
			from AutorizadorEmpresa ae, Autorizador a, ComercioAfiliado ca
			where a.autorizador = ae.autorizador
			  and ca.autorizador = ae.autorizador
			  and ca.comercio = ae.comercio
		</cfquery>
		
		<cfquery datasource="asp" name="empresas">
			select Ecodigo, Enombre, ce.CEcodigo, ce.CEnombre
			from Empresa e, CuentaEmpresarial ce
			where e.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(datos.Ecodigosdc)#" list="yes">)
			  and ce.CEcodigo = e.CEcodigo
		</cfquery>
		
		<cfquery dbtype="query" name="consulta">
			select CEcodigo, CEnombre, Ecodigo, Enombre,
				nombre_autorizador, moneda, comisionporc, comisionfija, prioridad
			from empresas, datos
			where empresas.Ecodigo = datos.Ecodigosdc
			order by CEnombre, Enombre, prioridad
		</cfquery>
		
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr class="tituloListas">
    <td><strong>Cuenta</strong></td>
    <td><strong>Empresa</strong></td>
    <td><strong>Autorizador</strong></td>
    <td><strong>Moneda</strong></td>
    <td><strong>Comisi&oacute;n</strong></td>
    <td><strong>Prioridad</strong></td>
  </tr><cfoutput query="consulta" group="Ecodigo">
  <cfset inicio_grupo=true><cfoutput>
  <tr class='<cfif CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>'>
    <td><cfif inicio_grupo>#CEnombre#</cfif> &nbsp;</td>
    <td><cfif inicio_grupo>#Enombre#</cfif> &nbsp;</td>
    <td>#nombre_autorizador#</td>
    <td>#moneda#</td>
    <td><cfif (comisionporc Neq 0)>#NumberFormat(comisionporc,'0.00')# %</cfif>
	<cfif (comisionporc Neq 0) and (comisionfija Neq 0)> + </cfif>
	<cfif (comisionfija Neq 0)>#moneda# #NumberFormat(comisionfija,',0.00')#</cfif>
	</td>
    <td>#prioridad#</td>
  </tr>
      <cfset inicio_grupo=false>
	</cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</cfoutput>
</table>

		
	<cf_web_portlet_end><cf_templatefooter>