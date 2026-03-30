<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Categorias de Distribuidor" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="C&oacute;digo" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto Vale Blanco" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescuentoInicial" Default="% Descuento Inicial" returnvariable="LB_DescuentoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PenalizacionDia" Default="% Penalizaci&oacute;n por d&iacute;a" returnvariable="LB_PenalizacionDia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PorcientoSeguro" Default="% Seguro" returnvariable="LB_PorcientoSeguro"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Orden" Default="Orden" returnvariable="LB_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoMin" Default="Monto Min." returnvariable="LB_MontoMin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoMax" Default="Monto Max." returnvariable="LB_MontoMax"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EmisorQ1" Default="Emisor Q1" returnvariable="LB_EmisorQ1"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EmisorQ2" Default="Emisor Q2" returnvariable="LB_EmisorQ2"/>



<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr> 
			<tr>
				<td width="65%" valign="top">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCCategoriaDist"
						columnas="id,Orden,Titulo,Descripcion,DescuentoInicial,PenalizacionDia,PorcientoSeguro,MontoMin,MontoMax,emisorq1,emisorq2"
						desplegar="Orden,Titulo,Descripcion,DescuentoInicial,PenalizacionDia,PorcientoSeguro,MontoMin,MontoMax,emisorq1,emisorq2"
						etiquetas="#LB_Orden#,#LB_Titulo#,#LB_Descripcion#,#LB_DescuentoInicial#,#LB_PenalizacionDia#,#LB_PorcientoSeguro#,#LB_MontoMin#,#LB_MontoMax#,#LB_EmisorQ1#,#LB_EmisorQ2#"
						formatos="S,S,S,M,M,M,M,M,S,S"
						filtro="Ecodigo=#session.Ecodigo# order by Orden"
						align="left,left,left,center,center,center,center,center,right,right"
						checkboxes="N"
						ira="CategoriaDistribuidor.cfm"
						keys="id">
					</cfinvoke>
					
					<cf_exportarCatalogo tableName="CRCCategoriaDist" keyColumnName="Orden">
				</td>
				<td width="35%">
					<cfinclude template="CategoriaDistribuidor_form.cfm">
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

