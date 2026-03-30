<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="L&iacute;nea de Cr&eacute;dito" returnvariable="LB_Title"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescuentoInicial" Default="% Descuento Inicial" returnvariable="LB_DescuentoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PenalizacionDia" Default="% Penalizacion por dia" returnvariable="LB_PenalizacionDia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Orden" Default="Orden" returnvariable="LB_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripcion" returnvariable="LB_Descripcion"/>
<cfinvoke  key="BTN_Regresar" default="Regresar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Regresar" xmlfile="/crc/generales.xml"/>
<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/crc/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/crc/generales.xml"/>

<cfset strFIltro = " and (1=1 or s.disT = 1 or s.TarjH = 1 or s.Mayor = 1)">
<cfif isdefined("Form.BFiltrar")>
	<cfif isdefined('form.Numero') and form.Numero neq ""><cfset strFIltro = "#strFIltro# and c.Numero like '%#form.Numero#%'"></cfif>
	<cfif isdefined('form.SNid') and form.SNid neq ""><cfset strFIltro = "#strFIltro# and SNegociosSNid = #form.SNid#"></cfif>
	<cfif isdefined('form.AplicaVales') and isdefined('form.Categoria') and  form.Categoria neq ""><cfset strFIltro = "#strFIltro# and CRCCategoriaDistid = #form.Categoria#"></cfif>
	<cfif isdefined('form.Estado') and form.Estado neq "">
		<cfif IsNumeric(form.Estado)>
			<cfset strFIltro = "#strFIltro# and crcestatuscuentasid = '#form.Estado#'">
		<cfelse>
			<cfset strFIltro = "#strFIltro# and ec.Descripcion = '#form.Estado#'">
		</cfif>
	</cfif>
</cfif>
<cfsavecontent variable="strTipo">
	<cfif isdefined('form.AplicaVales')>
		or Tipo = 'D'
	</cfif>
	<cfif isdefined('form.AplicaTC')>
		or Tipo = 'TC'
	</cfif>
	<cfif isdefined('form.AplicaTM')>
		or Tipo = 'TM'
	</cfif>
</cfsavecontent>
<cfif trim(strTipo) neq ""> <cfset strFIltro="#strFIltro# and(1=2 #strTipo#)"></cfif>

<cfset parentEntrancePoint = "LineaCredito.cfm">
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
					<cfinclude template="Cuentas_lista.cfm">
				</td>
				<td width="50%">
					<cfinclude template="LineaCredito_form.cfm">
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