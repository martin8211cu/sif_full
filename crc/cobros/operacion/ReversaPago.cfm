<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 					= t.Translate('LB_TituloH','Reversar Pagos')>
<cfset TIT_ConsultaTransacciones 	= t.Translate('TIT_ConsultaTransacciones','Reversar Pagos')>
<cfset LB_FiltrosConsulta 			= t.Translate('LB_FiltrosConsulta','Filtros de la Consulta')>
<cfset LB_Folio 					= t.Translate('LB_Folio','Folio')>
<cfset LB_FechaDesde				= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta				= t.Translate('LB_FechaHasta','Fecha hasta')>
<cfset LB_NumTarjeta				= t.Translate('LB_NumTarjeta','N&uacute;mero de Tarjeta')>
<cfset LB_Cuenta 					= t.Translate('LB_Cuenta', 'Cuenta')>
<cfset LB_Consultar 				= t.Translate('LB_Consultar', 'Consultar')>
<cfset LB_Numero 					= t.Translate('LB_Numero', 'N&uacute;mero')>
<cfset LB_Nombre 					= t.Translate('LB_Nombre', 'Nombre')>
<cfset LB_Tipo 						= t.Translate('LB_Tipo', 'Tipo')>
<cfset LB_Referencias  				= t.Translate('LB_Referencias', 'Referencias(Ticket)')>
<cfset LB_Seleccione  				= t.Translate('LB_Seleccione', 'Seleccione')>
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reversar Pagos')>
<cfset LB_Tienda		= t.Translate('LB_Tienda', 'Tienda')>
<cfset LB_Cliente		= t.Translate('LB_Cliente', 'Cliente')>
<cfset LB_Monto			= t.Translate('LB_Monto', 'Monto')>
<cfset LB_CURP			= t.Translate('LB_CURP', 'CURP')>
<cfset LB_Observacion	= t.Translate('LB_Observacion', 'Observaci&oacute;n')>
<cfset LB_TipoTransac	= t.Translate('LB_TipoTransac', 'Tipo Transacci&oacute;n')>
<cfset LB_Fecha 		= t.Translate('LB_Fecha', 'Fecha')>
<cfset LB_Parcialidades = t.Translate('LB_Parcialidades', 'Parcialidades')>
<cfset LB_TipoMov   	= t.Translate('LB_TipoMov', 'Tipo de Movimiento')>
<cfset LB_FolioTarjeta  = t.Translate('LB_FolioTarjeta', 'Folio/Tarjeta')>
<cfset BTN_Regresar   	= t.Translate('BTN_Regresar', 'Regresar')>
<cfset LB_SNnombre   	= t.Translate('LB_SNnombre', 'Socio de Negocio')>
<cfset LB_Referencias  	= t.Translate('LB_Referencias', 'Referencias(Ticket)')>
<cfset LB_Id 			= t.Translate('LB_Id', 'Id')>
<cfset LB_Corte			= t.Translate('LB_Corte', 'Corte')>


<cfset LB_SocioNegocio 				= t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ConsultaTransacciones#'>

<cfquery name="rsCorteActual" datasource="#session.DSN#">
	select top 1 * from CRCCortes 
		where Cerrado != 1
</cfquery>


<cfinclude template="../../../sif/Utiles/sifConcat.cfm">

<cfif isdefined("url.tran_id")>
	<cfinclude template="ReversaPago_form.cfm">
<cfelse>
	<cfinclude template="ReversaPago_lista.cfm">
</cfif>
<cf_web_portlet_end>			

<cf_templatefooter>


