<cfparam name="url.selCEcodigo" default="" >
<cfparam name="url.selEcodigo" default="" >
<cfparam name="url.tabla" default="" >
<cfquery datasource="asp" name="cuentas">
	select CEcodigo,CEnombre
	from CuentaEmpresarial
	where CEcodigo in(select CEcodigo from Empresa)
	order by CEnombre
</cfquery>
<cfif Len(url.selCEcodigo)>
<cfquery datasource="asp" name="empresas">
	select Ecodigo,Enombre
	from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.selCEcodigo#">
	order by Enombre
</cfquery></cfif>
<cfif Len(url.selEcodigo) And ListFind(ValueList(empresas.Ecodigo), url.selEcodigo) EQ 0>
	<cfset url.selEcodigo = ''>
</cfif>
<cfif Len(url.selEcodigo)>
<cfquery datasource="asp" name="lista">
	select ed.tabla, ed.descripcion,
	case
		when ce.modalidad = 1 then 'Alta/Importa'
		when ce.modalidad = 2 then 'Alta Corporativa/Importa'
		when ce.modalidad = 3 then 'Alta/Alta Corporativa/Importa'
		else 'No Aplica'
	end as modalidad
	from CatalogoEditable ed
		left join CatalogoEmpresa ce
		on ce.tabla = ed.tabla
		and ce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.selEcodigo#">
	order by ed.tabla
</cfquery></cfif><cf_templateheader title="Mantenimiento de CatalogoEmpresa">
<cf_web_portlet_start titulo="Catálogos Editables">
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td width="52%" colspan="2" valign="top">
	<form action="" method="get" name="formLista" id="formLista"><table width="406" border="0">
      <tr>
        <td width="44%" valign="top">Cuenta Empresarial:
</td>
        <td width="50%" valign="top"><select name="selCEcodigo" id="selCEcodigo" onChange="form.submit()">
		<cfif Len(url.selCEcodigo) eq 0>
			<option value=""> - Seleccione una - </option>
		</cfif>
		<cfoutput query="cuentas">
			<option value="#CEcodigo#" <cfif url.selCEcodigo EQ CEcodigo>selected</cfif>>#HTMLEditFormat(CEnombre)#</option>
		</cfoutput>
        </select></td>
        </tr>
	  <cfif Len(url.selCEcodigo)>
      <tr>
        <td valign="top">Empresa:</td>
        <td valign="top"><select name="selEcodigo" id="selEcodigo" onChange="form.submit()">
		<cfif Len(url.selEcodigo) eq 0 or not ListFind(ValueList(empresas.Ecodigo),url.selEcodigo)>
			<option value=""> - Seleccione una - </option>
		</cfif>
		<cfoutput query="empresas">
			<option value="#Ecodigo#" <cfif url.selEcodigo EQ Ecodigo>selected</cfif>>#HTMLEditFormat(Enombre)#</option>
		</cfoutput>
        </select></td>
        </tr></cfif>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        </tr>
    </table>
      <cfif Len(url.selEcodigo)>
            <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="tabla, descripcion, modalidad"
			etiquetas="Tabla, Nombre, Modalidad"
			formatos="S,S,S"
			align="left,left,left"
			ira="CatalogoEmpresa.cfm"
			form_method="get"
			incluye_form="no"
			formname="formLista"
			keys="tabla"
		/>         </cfif> </form></td>
  <td width="48%" valign="top">
  	<cfif Len(url.selEcodigo) and Len(url.tabla)>
		<cfinclude template="CatalogoEmpresa-form.cfm"></cfif>
	</td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter>


