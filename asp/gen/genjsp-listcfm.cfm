<cfoutput><!---
#'<'#cfset session.dsn='minisif'>--->
#'<'#cf_template>
#'<'#cf_templatearea name="title">
	Mantenimiento de #HTMLEditFormat(metadata.name)#
#'<'#/cf_templatearea>
#'<'#cf_templatearea name="body">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		<cfset keys = ''>
		<cfset keynames = ''>
		<cfset formatos = ''>
		<cfset align = ''>
		<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i">
			<cfset keys     = ListAppend (keys,     metadata.pk.cols[i].code)>
			<cfset keynames = ListAppend (keynames, metadata.pk.cols[i].name)>
			<cfset formatos = ListAppend (formatos, 'S')>
			<cfset align    = ListAppend (align,    'left')>
		</cfloop>
		
		#'<'#cfquery datasource="##session.dsn##" name="lista">
			select #keys#
			from #metadata.code#
			#'<'#!--- falta el where -#'-'#->
			
		#'<'#/cfquery>
		

		#'<'#cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="##lista##"
			desplegar="#keys#"
			etiquetas="#keynames#"
			formatos="#formatos#"
			align="#align#"
			ira="#metadata.code#.cfm"
			form_method="get"
			keys="#keys#"
		/>		
	</td>
    <td valign="top">
		#'<'#cfinclude template="#metadata.code#-form.cfm">
	</td>
  </tr>
</table>
#'<'#/cf_templatearea>
#'<'#/cf_template>
</cfoutput>
