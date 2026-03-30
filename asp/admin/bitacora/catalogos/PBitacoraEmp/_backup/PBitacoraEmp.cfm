<cf_templateheader title="Mantenimiento de Parámetros de Bitácora por empresa">
<cf_web_portlet_start titulo="Selección de Bitácora por Empresa">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cfquery datasource="asp" name="empresas_asp">
	select ce.CEcodigo, ce.CEnombre, e.Ecodigo, e.Enombre
	from Empresa e join CuentaEmpresarial ce
		on ce.CEcodigo = e.CEcodigo
	order by ce.CEnombre, e.Enombre
</cfquery>
<cfparam name="url.la_empresa" default="#session.EcodigoSDC#">

<cfquery datasource="asp" name="lista">
	select t.PBtabla, case when e.PBinactivo = 1 then ' ' else 'X' end as activo,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.la_empresa#"> as la_empresa
	from PBitacoraEmp e
		right join PBitacora t
			on e.PBtabla = t.PBtabla
			and e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.la_empresa#">
	order by t.PBtabla
</cfquery>

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td width="50%" valign="top">Empresa:<form action="PBitacoraEmp.cfm" method="get"><select name="la_empresa" onChange="this.form.submit()">
	<cfoutput query="empresas_asp" group="CEcodigo">
	<optgroup label="#empresas_asp.CEnombre#">
	<cfoutput>
	<option value="#empresas_asp.Ecodigo#" <cfif empresas_asp.Ecodigo is url.la_empresa>selected</cfif>>#HTMLEditFormat(empresas_asp.Enombre)#</option>
	</cfoutput>
	</optgroup>
	</cfoutput>
	</select></form> </td>
    <td width="50%" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">
      <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="PBtabla,activo"
			etiquetas="Tabla,Activo"
			formatos="S,S"
			align="left,left"
			ira="PBitacoraEmp.cfm"
			form_method="get"
			keys="PBtabla,la_empresa"
		/>
      
    </td>
    <td valign="top">
	<cfparam name="url.PBtabla" default="">
	<cfif Len(url.PBtabla)><cfinclude template="PBitacoraEmp-form.cfm">
	</cfif>
    </td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter> 