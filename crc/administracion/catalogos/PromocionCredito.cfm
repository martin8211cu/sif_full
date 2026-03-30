<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Aumento temporal de l&iacute;nea de cr&eacute;dito" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="T&iacute;tulo" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDesde" Default="Fecha Inicial" returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaHasta" Default="Fecha Final" returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Porciento" Default="Porcentaje" returnvariable="LB_Porciento"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo"/>
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
				<td width="65%" valign="top">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCPromocionCredito"
						columnas="id,Codigo,Descripcion,Monto,fechaDesde,FechaHasta,Porciento,aplicaVales,aplicaTC,aplicaTM"
						desplegar="Codigo,Descripcion,Monto,FechaDesde,FechaHasta,Porciento,aplicaVales,aplicaTC,aplicaTM"
						etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_Monto#,#LB_FechaDesde#,#LB_FechaHasta#,#LB_Porciento#,Vales,Tarjeta Credito, Tarjeta Mayorista"
						formatos="S,S,M,D,D,L,L,L,L"
						filtro="Ecodigo=#session.Ecodigo# order by FechaDesde desc"
						align="left,left,left,left,left,left,left,left,left"
						checkboxes="N"
						ira="PromocionCredito.cfm"
						keys="id">
					</cfinvoke>
					<cf_exportarCatalogo tableName="CRCPromocionCredito" keyColumnName="Codigo">
				</td>
				<td width="50%">
					<cfinclude template="PromocionCredito_form.cfm">
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