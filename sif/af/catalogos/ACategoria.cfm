<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo))>
	<cfset form.ACcodigo = url.ACcodigo>
</cfif>
<cf_templateheader title="Activos Fijos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Categor&iacute;as de Activos'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top" width="45%">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
						tabla="ACategoria"
						columnas="ACcodigo, ACcodigodesc, ACdescripcion, case ACmetododep when 1 then 'LR*' when 2 then 'SD*' end as ACmetododep, ACmascara, ACvutil"
						desplegar="ACcodigodesc, ACdescripcion, ACmetododep, ACmascara, ACvutil"
						etiquetas="C&oacute;digo, Categor&iacute;a, Método Dep., M&aacute;scara, Vida &Uacute;til"
						formatos="S,S,S,U,U"
						filtro="Ecodigo=#session.Ecodigo# Order By ACcodigodesc"
						align="left,left,left,left,right"
						checkboxes="N"
						keys="ACcodigo"
						MaxRows="25"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="ACcodigodesc, ACdescripcion, ACmetododep, &nbsp;, &nbsp;"
						ira="ACategoria.cfm"
						showEmptyListMsg="true">
						
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>&nbsp;<strong>*LR = Línea Recta</strong></td>
							</tr>
							<tr>
								<td>&nbsp;<strong>*SD = Suma de Dígitos</strong></td>
							</tr>
						</table>
				</td>					
				<td valign="top" width="55%">
						<cfinclude template="formACategoria.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>