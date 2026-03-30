<!--- 
	Submodulo de Control de Vales.
	Proceso: Alta de Vale.
	Descripcion: Se da de alta una adquisicion de Activo en AFAdquisicion, tabla temporal de Adquisicion de Activos, 
		creada para poder capturar algunos datos del activos previo el registro de su adquisicion.
		Caso: ICE, Sistema de Control de Vales. Responsable: Mauricio Arias.
	Contexto: Usuario de Autogestion da de Alta un Vale.
	Otras Definiciones:
	Vale: Activo Fijo ligado a un responsable, es la manera en que se lleva el control de quien es el responsable de un 
		Activo Fijo, un vale se puede dar de Alta pero esto no lo combierte inmediatamente en un activo fijo, primero debe 
		ser aprobado por un usuario del sistema autorizado a ingresar al proceso de aprobacion de vales.
		Posteriormente un Vale puede ser traspasado entre Usuarios de Autogestion y / o Almacenes (Encargado del Almacén).
--->
<!--- RECORDATORIO: ESTAMOS EN CONTEXTO DE AUTOGESTION --->
<!--- Obtiene el Empleado Asociado al Usuario --->
<cfif isdefined("url.AFAid") and len(trim(url.AFAid))><cfset form.AFAid = url.AFAid></cfif>
<cfset modocambio = (isdefined("form.AFAid") and len(trim(form.AFAid)))>
<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
	select llave
	from UsuarioReferencia ur
	inner join Empresa em 
				on em.Ecodigo = ur.Ecodigo
				and em.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
				and em.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
	where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	and ur.STabla = 'DatosEmpleado'
</cfquery>
<cfif rsDatosEmpleado.recordcount and len(trim(rsDatosEmpleado.llave))>
	<cfset form.DEid = rsDatosEmpleado.llave>
<cfelse>
	<cf_errorCode	code = "50097" msg = "Error Cargando Adquisición de Activos Fijos por Empleado (Vales), No se encontró el Empleado Asociado a su Usuario.">
</cfif>
<!--- 
 Reglas a considerar:
 1. 1 empleado puede tener 1 o más Vales activos sin aprobar -
 		al mismo tiempo, debe poder seleccionar con cual quiere -
		trabajar o poder dar de Alta uno Nuevo.
--->
<!--- Si el empleado no tiene Vales lo lleva directamente a crear un nuevo vale --->
<cfset checked = "<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>">
<cfset unchecked = "<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>">
<cfquery name="rsValeList" datasource="#session.dsn#">
	select AFAid, Ecodigo, DEid, Aid, ACcodigo, ACid, AFMid, AFMMid, CFid, 
		SNcodigo, AFAdescripcion, AFAserie, AFAplaca, AFAdocumento, AFAmonto, 
		AFAfechainidep, AFAfechainirev, Usucodigo, Ulocalizacion, AFAstatus, 
		AFAfechaalta
		,case when coalesce(substring(AFAdescripcion,30,1),' ') = ' ' then substring(AFAdescripcion,1,30) 
		else substring(AFAdescripcion,1,27) +/*cat*/ '...' 
		end as AFAdescripcionshort
		,case AFAstatus when 0 then '#unchecked#' else '#checked#' end AFAstatusimg
	from AFAdquisicion 
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.llave#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>
<cfif modocambio>
	<!--- Vale en Consulta EL VALE SOLO DEBE PODER MODIFICARSE SI SU ESTADO ES 0 --->
	<cfquery name="rsVale" datasource="#session.dsn#">
		select AFAid, Ecodigo, DEid, Aid, ACcodigo, ACid, AFMid, AFMMid, CFid, 
			SNcodigo, AFAdescripcion, AFAserie, AFAplaca, AFAdocumento, AFAmonto, 
			AFAfechainidep, AFAfechainirev, Usucodigo, Ulocalizacion, AFAstatus, 
			AFAfechaalta,	BMUsucodigo, ts_rversion
		from AFAdquisicion 
		where AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="rsvale_ts" artimestamp="#rsVale.ts_rversion#"/>
</cfif>
<!--- Otras Consultas --->
<!--- Pintado de la Pantalla --->
<cf_templateheader title="Activos Fijos">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Adquisici&oacute;n de Activos Fijos con Vale'>
				<br>
				<cfinclude template="/sif/portlets/pEmpleado.cfm">
				<table width="98%" align="center" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" width="28%" align="left">
							<fieldset><legend>Mis Vales</legend>
							<cfinvoke component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaQueryRet"
								query="#rsValeList#"
								desplegar="AFAfechaalta, AFAdescripcionshort, AFAstatusimg"
								etiquetas="Fecha, Descripci&oacute;n, Terminado"
								formatos="D, S, S"
								align="left, left, right"
								irA="vales_adquisicion.cfm"
								showEmptyListMsg="true"
								botones="Nuevo"
								keys="AFAid"
								EmptyListMsg="--- No tiene vales registrados ---"
								/>
							</fieldset>
						</td>
						<td width="4%">&nbsp;</td>
						<td valign="top" width="68%" align="left">
							<fieldset><legend>Adquisici&oacute;n de Activos Fijos con Vale</legend>
							<cfif (not modocambio) or (modocambio and rsVale.AFAstatus EQ 0)>
								<cfinclude template="vales_adquisicion_form.cfm">
							<cfelse>
								<cfinclude template="vales_adquisicion_consulta.cfm">
							</cfif>
							</fieldset>
						</td>
					</tr>
				</table>
				<br>
			<cf_web_portlet_end>
	<cf_templatefooter>

