
<cfset session.dsn='minisif'>

<cf_template>
<cf_templatearea name="title">
	Registro de Programas : Vigencia
</cf_templatearea>
<cf_templatearea name="body">


<script type="text/javascript" src="<c:out value="${param.code}"/>.js" >//</script>
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		
		
		<cfparam name="url.id_programa" type="numeric">
		<cfquery datasource="#session.dsn#" name="lista">
			select id_programa,id_vigencia, nombre_vigencia, fecha_desde
			from sa_vigencia
			where id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#">
			order by upper(nombre_vigencia)
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="nombre_vigencia, fecha_desde"
			etiquetas="[ Vigencia ],"
			formatos="S,D"
			align="left,left"
			ira="sa_vigencia.cfm"
			form_method="get"
			keys="id_programa,id_vigencia"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="sa_vigencia-form.cfm">
	</td>
  </tr>
</table>
</cf_templatearea>
</cf_template>


