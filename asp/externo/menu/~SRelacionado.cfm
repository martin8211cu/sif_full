
<cf_template>
<cf_templatearea name="title">
	Mantenimiento de Páginas Relacionadas
</cf_templatearea>
<cf_templatearea name="body">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		
		
		
		
			
			
			
			
		
			
			
			
			
		
		
		<cfquery datasource="asp" name="lista">
			select id_item,id_hijo
			from SRelacionado
			<!--- falta el where --->
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="id_item,id_hijo"
			etiquetas="id_item,id_hijo"
			formatos="S,S"
			align="left,left"
			ira="SRelacionado.cfm"
			form_method="get"
			keys="id_item,id_hijo"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="SRelacionado-form.cfm">
	</td>
  </tr>
</table>
</cf_templatearea>
</cf_template>


