<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Gestionar Tarjetas" returnvariable="LB_Title"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescuentoInicial" Default="% Descuento Inicial" returnvariable="LB_DescuentoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PenalizacionDia" Default="% Penalizacion por dia" returnvariable="LB_PenalizacionDia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Orden" Default="Orden" returnvariable="LB_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripcion" returnvariable="LB_Descripcion"/>

<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/crc/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/crc/generales.xml"/>

<cfset strFIltro = " and (1=1 or s.disT = 1 or s.TarjH = 1 or s.Mayor = 1)">
<cfif isdefined("Form.BFiltrar")>
	<cfif isdefined('form.NumeroSN') and form.NumeroSN neq ""><cfset strFIltro = "#strFIltro# and c.Numero like '%#form.NumeroSN#%'"></cfif>
	<cfif isdefined('form.NumeroTC') and form.NumeroTC neq ""><cfset strFIltro = "#strFIltro# and tc.Numero like '%#form.NumeroTC#%'"></cfif>
	<cfif isdefined('form.SNnumero') and form.SNnumero neq ""><cfset strFIltro = "#strFIltro# and s.SNnumero like '%#form.SNnumero#%'"></cfif>
	<cfif isdefined('form.TipoTC') and form.TipoTC neq ""><cfset strFIltro = "#strFIltro# and c.Tipo like '%#form.TipoTC#%'"></cfif>
	<cfif isdefined('form.EstadoTC') and form.EstadoTC neq ""><cfset strFIltro = "#strFIltro# and tc.Estado like '%#form.EstadoTC#%'"></cfif>
</cfif>

<cfset parentEntrancePoint = "GestionTarjeta.cfm">
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
					<cfinclude template="GestionTarjeta_lista.cfm">
				</td>
				<td width="50%" align="center" valign="top">
					<cfinclude template="GestionTarjeta_form.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>