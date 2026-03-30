<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte de Vales')>
<cfset TIT_ReportVales 	= t.Translate('TIT_ReportVales','Reporte de Vales')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_SNegocio 		= t.Translate('LB_SNegocio','Socio de Negocio')>
<cfset LB_FechaDesde	= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta	= t.Translate('LB_FechaHasta','Fecha hasta')>
<cfset LB_Corte			= t.Translate('LB_Corte','Corte')>
<cfset LB_Cuenta 		= t.Translate('LB_Cuenta', 'Cuenta')>

<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ReportVales#'>


<cfquery name="rsCorte" datasource="#session.DSN#">
	select Codigo, FechaInicio, FechaFin 
	from CRCCortes
	where Ecodigo = #session.Ecodigo#
	and Tipo = 'D'
</cfquery>
 

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="reporteVales_sql.cfm?p=0" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_DatosReporte#</b>
			</fieldset>
			<table  width="50%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr align="left">
					<td>
						<strong>#LB_SNegocio#:&nbsp;</strong>
						<cfset tipoSN = "D">
						<cf_conlis
							title="#LB_SNegocio#"
							Campos="SNid,numCuenta,Nombre"
							Desplegables="N,S,S"
							Modificables="S,S,S"
							Size="0,15,30"
							tabindex="1"
							Tabla="SNegocios sn inner join CRCCuentas cc on cc.SNegociosSNid = sn.SNid"
							Columnas="
									cc.id as idCuenta
								, sn.SNnombre as Nombre
								, cc.Numero numCuenta
								, sn.SNidentificacion
								, sn.SNid"
							form="form1"
							Filtro="sn.Ecodigo = #Session.Ecodigo# and cc.Tipo = 'D'"
							Desplegar="numCuenta,SNidentificacion, Nombre"
							Etiquetas="Numero de Cuenta, Identificacion del Socio, Nombre del Socio"
							filtrar_por="cc.Numero,sn.SNidentificacion,sn.SNnombre"
							Formatos="S,S,S"
							Align="left,left,left"
							Asignar="idCuenta,SNid,Nombre,numCuenta"
							Asignarformatos="S,S,S"/>
					</td>
				</tr>

				
				<tr align="left">
					<td>
						<strong>#LB_FechaDesde#:&nbsp;</strong>
						<cfset fechaDes = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1">
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_FechaHasta#:&nbsp;</strong>
						<cfset fechaHas = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1">
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_Corte#:&nbsp;</strong>
					 	<select name="corte" id="corte" tabindex="1">
							<option selected="true" value="">Todos</option>
							<cfloop query="rsCorte"> 
							<option value="#Codigo#">#rsCorte.Codigo# (#LSDateFormat(rsCorte.FechaInicio,'dd/mm/yyyy')# - #LSDateFormat(rsCorte.FechaFin,'dd/mm/yyyy')#)</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td >&nbsp;</td>
				</tr>
				<tr align="center">
					<td>
					<cf_botones values="Generar" names="Generar"  tabindex="1">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
<cf_web_portlet_end>			

<cf_templatefooter>

 </cfoutput>


