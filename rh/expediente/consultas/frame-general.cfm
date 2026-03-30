<cfquery name="rsEtiquetas" datasource="#Session.DSN#">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from RHEtiquetasEmpresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.Ecodigo#">
	and RHdisplay = 1
	and RHEcol like 'DE%'
</cfquery>
<cfquery name="rsNac" datasource="#Session.DSN#">
	select de.DGid
	from DEmpleado de
		left outer join <cf_dbdatabase table="DistribucionGeografica" datasource="asp"> dg
			on dg.DGid = de.DGid
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and DIEMtipo = 1 <!---0-Direccion de Residencia 1-Direccion de Nacimiento--->
</cfquery>
<cfoutput>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td width="10%" rowspan="9" align="center" valign="top" style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap>
	<cfinclude template="/rh/expediente/catalogos/frame-foto.cfm">
	</td> 
	<td class="fileLabel" width="10%" nowrap><cf_translate key="LB_NombreCompleto">Nombre Completo</cf_translate>: </td>
	<td><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="CedulaExp">#rsEmpleado.NTIdescripcion#</cf_translate>:</td>
	<td>#rsEmpleado.DEidentificacion#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="Sexo">Sexo</cf_translate>:</td>
	<td>#rsEmpleado.Sexo#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="EstadoCivil">Estado Civil</cf_translate>:</td>
	<td>#rsEmpleado.EstadoCivil#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="FecNacimiento">Fecha de Nacimiento</cf_translate>:</td>
	<td>#LSDateFormat(rsEmpleado.FechaNacimiento,'dd/mm/yyyy')#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="Edad">Edad</cf_translate>:</td>
	<td>#DATEDIFF("yyyy", rsEmpleado.FechaNacimiento ,now())# <cf_translate key="Edad">Años</cf_translate></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="Direccion">Direccion</cf_translate>:</td>
	<td>#rsEmpleado.DEdireccion#</td>
  </tr>
  <cfif isdefined('rsNac') and len(trim(rsNac.DGid)) neq 0>
		<cfset CURP = fnGetCURP(rsNac.DGid)>
	<cfelse>
		<cfset CURP = "***No Definido***">
	</cfif>
  <tr>
    <td class="fileLabel" nowrap>Lugar Nacimiento:</td>
	<td>#CURP#</td>
  </tr>
  <cfif isdefined("rsDependientes") and  rsDependientes.recordCount GT 0>	
	  <tr>
		<td class="fileLabel" nowrap><cf_translate key="NoDeDependietes">No. de Dependientes</cf_translate>:</td>
		<td>#rsDependientes.DEcantdep#</td>
	  </tr>
  </cfif>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="Banco">Banco</cf_translate>:</td>
    <td>#rsEmpleado.Bdescripcion#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="CuentaCliente">Cuenta Cliente</cf_translate>:</td>
	<td>#rsEmpleado.CBcc# (#rsEmpleado.Mnombre#)</td>
  </tr>
  <cfif rsEtiquetas.recordCount GT 0>
	  <cfloop query="rsEtiquetas">
		  <cfif isdefined("rsEmpleado.#rsEtiquetas.RHEcol#")>
			  <tr>
				<td class="fileLabel" nowrap>&nbsp;</td> 
				<td class="fileLabel" nowrap>#rsEtiquetas.RHEtiqueta#:</td>
				<td>#Evaluate("rsEmpleado.#rsEtiquetas.RHEcol#")#</td>
			  </tr>
		  </cfif>
	  </cfloop>
  </cfif>
</table>
</cfoutput>
<cffunction name="fnGetCURP" access="private" output="true" returntype="string">
	<cfargument name='DGid'		type='numeric' 	required='true'>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsPadreDist">
		<cfinvokeargument name="DGid"   	value="#Arguments.DGid#">
	</cfinvoke>
	<cfloop query="rsPadreDist">
		<cfif rsPadreDist.CURP eq '1'>
			<cfreturn rsPadreDist.DGDescripcion>
		<cfelseif  len(trim(rsPadreDist.DGidPadre)) gt 0>
			<cfreturn fnGetCURP(rsPadreDist.DGidPadre)>
		<cfelse>
			<cfreturn "***No Definido***">
		</cfif>
	</cfloop>
</cffunction>
