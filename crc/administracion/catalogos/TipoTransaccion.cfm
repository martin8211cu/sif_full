<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoMov" Default="Tipo Movimiento" returnvariable="LB_TipoMov"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Saldo" Default="Saldo" returnvariable="LB_Saldo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Interes" Default="Inter&eacute;s" returnvariable="LB_Interes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Compras" Default="Compras" returnvariable="LB_Compras"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Pagos" Default="Pagos" returnvariable="LB_Pagos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Condonaciones" Default="Condonaciones" returnvariable="LB_Condonaciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GastoCobranza" Default="Gasto Cobranza" returnvariable="LB_GastoCobranza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AfectaA" Default="Afecta A" returnvariable="LB_AfectaA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Seguro" Default="Seguro" returnvariable="LB_Seguro"/>

<cf_templateheader title='Tipo de Transaccion'>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipo de Transaccion'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td width="65%" valign="top">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCTipoTransaccion"
						columnas="id,Codigo,Descripcion,TipoMov, afectaSaldo, afectaInteres, afectaCompras, afectaPagos, afectaCondonaciones, afectaGastoCobranza,afectaSeguro"
						desplegar="Codigo,Descripcion,TipoMov,afectaSaldo,afectaInteres,afectaCompras,afectaPagos,afectaCondonaciones,afectaGastoCobranza,afectaSeguro"
						etiquetas=" #LB_Codigo# , #LB_Descripcion# , #LB_TipoMov# , #LB_Saldo# , #LB_Interes# , #LB_Compras# , #LB_Pagos# , #LB_Condonaciones# , #LB_GastoCobranza#, #LB_Seguro# "
						formatos="S,S,S,L,L,L,L,L,L,L"
						filtro="Ecodigo=#session.Ecodigo#"
						align="left,left,left,center,center,center,center,center,center,center"
						checkboxes="N"
						ira="TipoTransaccion.cfm"
						keys="id">
					</cfinvoke>

					<cfset tableName="CRCTipoTransaccion">
					<cfset keyColumnName="Codigo">
					<cfinclude template="Exportar_form.cfm">
										
				</td>
				<td width="50%">
					<cfinclude template="TipoTransaccion_form.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<cfoutput>

			<cfif isdefined("form.resultT") and form.resultT neq ""> 

				<script type="text/javascript">
					alert("#form.resultT#");
				</script> 
			</cfif>					

		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>