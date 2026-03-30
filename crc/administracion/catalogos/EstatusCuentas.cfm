<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Estatus de Cuentas de Cr&eacute;dito" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AplicaVales" Default="Vales" returnvariable="LB_AplicaVales"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AplicaTC" Default="Tarjeta de Cr&eacute;dito" returnvariable="LB_AplicaTC"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AplicaTM" Default="Tarjeta Mayorista" returnvariable="LB_AplicaTM"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Orden" Default="Orden" returnvariable="LB_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>



<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td width="50%" valign="top">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCEstatusCuentas"
						columnas="id,Orden,Descripcion,AplicaVales,AplicaTC,AplicaTM"
						desplegar="Orden,Descripcion,AplicaVales,AplicaTC,AplicaTM"
						etiquetas="#LB_Orden#,#LB_Descripcion#,#LB_AplicaVales#,#LB_AplicaTC#,#LB_AplicaTM#"
						formatos="S,S,L,L,L"
						filtro="Ecodigo=#session.Ecodigo# order by Orden"
						align="left,left,left,left,left"
						checkboxes="N"
						ira="EstatusCuentas.cfm"
						keys="id">
					</cfinvoke>
					<cf_exportarCatalogo tableName="CRCEstatusCuentas" keyColumnName="Orden">
				</td>
				<td width="50%">
					<cfinclude template="EstatusCuentas_form.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<cfoutput>
			<cfif isdefined("form.resultT") and #form.resultT# neq ""> 
				<script type="text/javascript">
					alert("#form.resultT#");
				</script> 
			</cfif>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>