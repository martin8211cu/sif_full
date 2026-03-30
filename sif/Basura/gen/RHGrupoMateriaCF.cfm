
<cf_template>
<cf_templatearea name="title">
	Mantenimiento de RHGrupoMateriaCF
</cf_templatearea>
<cf_templatearea name="body">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		
		
		
		
			
			
			
			
		
			
			
			
			
		
		
		<cfquery datasource="#session.dsn#" name="lista">
			select CFid,RHGMid
			from RHGrupoMateriaCF
			<!--- falta el where --->
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="CFid,RHGMid"
			etiquetas="CFid,RHGMid"
			formatos="S,S"
			align="left,left"
			ira="RHGrupoMateriaCF.cfm"
			form_method="get"
			keys="CFid,RHGMid"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="RHGrupoMateriaCF-form.cfm">
	</td>
  </tr>
</table>
</cf_templatearea>
</cf_template>


