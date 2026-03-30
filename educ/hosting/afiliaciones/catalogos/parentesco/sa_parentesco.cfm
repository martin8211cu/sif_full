<cf_template>
<cf_templatearea name="title">
	Cat&aacute;logo de Parentescos
</cf_templatearea>
<cf_templatearea name="body">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		<cfquery datasource="#session.dsn#" name="lista">
			select parentesco.id_parentesco,
				parentesco.nombre_masc, inverso.nombre_masc as nombre_inverso
			from sa_parentesco parentesco
				left join sa_parentesco inverso
					on inverso.id_parentesco = parentesco.inverso
				    and inverso.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			where parentesco.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="nombre_masc,nombre_inverso"
			etiquetas="Parentesco,Inverso"
			formatos="S,S"
			align="left,left"
			ira="sa_parentesco.cfm"
			form_method="get"
			keys="id_parentesco"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="sa_parentesco-form.cfm">
	</td>
  </tr>
</table>
</cf_templatearea>
</cf_template>


