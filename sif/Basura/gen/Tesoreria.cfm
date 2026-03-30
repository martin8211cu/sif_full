
<cf_template>
<cf_templatearea name="title">
	Mantenimiento de Tesorería
</cf_templatearea>
<cf_templatearea name="body">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		
		
		
		
			
			
			
			
		
		
		<cfquery datasource="#session.dsn#" name="lista">
			select TESid
			from Tesoreria
			<!--- falta el where --->
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="TESid"
			etiquetas="ID Tesoreria"
			formatos="S"
			align="left"
			ira="Tesoreria.cfm"
			form_method="get"
			keys="TESid"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="Tesoreria-form.cfm">
	</td>
  </tr>
</table>
</cf_templatearea>
</cf_template>


