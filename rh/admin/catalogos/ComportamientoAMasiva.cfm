<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Comportamiento de Acci&oacute;n Masiva">
<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="Comportamiento de Acci&oacute;n Masiva">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="40%" valign="top">
						<cfinvoke 
							component="rh.Componentes.pListas" 
							method="pListaRH" 
							returnvariable="Lvar_Lista" 
							columnas="a.CAMid,a.CAMAcodigo,a.CAMdescripcion,a.CAMcomponente"
							tabla="ComportamientoAMasiva a"
							filtro=""
							desplegar="CAMAcodigo,CAMdescripcion,CAMcomponente"
							etiquetas="C&oacute;digo,Descripci&oacute;n,Componente"
							filtrar_por="a.CAMAcodigo,a.CAMdescripcion,a.CAMcomponente"
							maxrows="10"
							formatos="S,S,S"
							align="left,left,left"
							ajustar="S,S,S"
							mostrar_filtro="true"
							filtrar_automatico="true"
							showemptylistmsg="true"
							emptylistmsg=" --- No se Encontraron Registros --- "
							ira="#CurrentPage#"
							checkboxes="N"
							conexion="asp"
							keys="CAMid" />
					</td>
					<td width="1%" valign="top">&nbsp;</td>
					<td width="59%" valign="top">
						<cfinclude template="ComportamientoAMasiva-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
