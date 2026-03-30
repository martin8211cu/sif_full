
<cfset session.dsn='minisif'>

<cf_template>
<cf_templatearea name="title">
	Registro de programas
</cf_templatearea>
<cf_templatearea name="body">

<cfset navegacion=ListToArray('javascript:void(0),Registro de Programas',';')>
<cfinclude template="../../pNavegacion.cfm">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		
		<cfquery datasource="#session.dsn#" name="lista">
			select id_programa,nombre_programa
			from sa_programas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by upper(nombre_programa)
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="nombre_programa"
			etiquetas="[ Todos los Programas ]"
			formatos="S"
			align="left"
			ira="sa_programas.cfm"
			form_method="get"
			keys="id_programa"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="sa_programas-form.cfm">
	</td>
  </tr>
</table>
</cf_templatearea>
</cf_template>


