<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte de Cobranza por Gestor')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_SNegocio 		= t.Translate('LB_SNegocio','Socio de Negocio')>
<cfset LB_FechaDesde	= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta	= t.Translate('LB_FechaHasta','Fecha hasta')>

<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>


 

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="reporteCobranzaGestor_sql.cfm?p=0" method="post">
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
					<strong>Gestor/Abogado:&nbsp;</strong>
					<cfset tipoSN = "D">
					<cf_conlis
						showEmptyListMsg="true"
						Campos="DEid,DEidentificacion,DEnombreC"
						Desplegables="N,S,S"
						Modificables="S,S,S"
						Size="0,10,30"
						tabindex="1"
						Tabla="DatosEmpleado"
						Columnas="
								DEid
							, DEidentificacion
							, DEnombre
							, DEapellido1
							, DEapellido2
							, concat(DEnombre,' ',DEapellido1,' ',DEapellido2) as DEnombreC
							, case isCobrador when 1 then 'X' else ' ' end as isCobrador
							, case isAbogado when 1 then 'X' else ' ' end as isAbogado
							"
						formName="form1"
						Filtro="Ecodigo = #Session.Ecodigo# and (isCobrador = 1 or isAbogado = 1)"
						Desplegar="DEidentificacion,DEnombre,DEapellido1,DEapellido2,isCobrador,isAbogado"
						Etiquetas="Identificacion,Nombre,Apellido P,Apellido M,Cobrador,Abogado"
						filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2,isCobrador,isAbogado"
						Formatos="S,S,S,S"
						Align="left,left,left,left"
						Asignar="DEid,DEidentificacion,DEnombreC"
						Asignarformatos="S,S,S"
						/>
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


