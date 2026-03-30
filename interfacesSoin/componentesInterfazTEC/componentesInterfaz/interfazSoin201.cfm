<!---
	Interfaz 201
	Interfaz de Intercambio de Información de Plazas
	Dirección de la Inforamción: Sistema Externo - RRHH
	Elaborado por: D.A.G. (dabarca@soin.co.cr)
	Fecha de Creación: 10/07/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar de la BD de Interfaces. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz201" datasource="sifinterfaces">
		SELECT 	ID, EcodigoSDC, Imodo, CodigoPlaza, DescripcionPlaza, CodigoPuesto, CodigoCentroFuncional, FechaActivacion, Estado, PlazaResp, 
				BMUsucodigo, ts_rversion
		FROM 	IE201
		WHERE 	ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz201.recordcount eq 0>
		<cfthrow message="Error en Interfaz 201. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Procesamiento de Interfaz 201. --->
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" Key="MSG_Error_de_Interfaz_201" returnvariable="MSG_Error_de_Interfaz_201"
	Default="Error de Interfaz 201" />
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" Key="MSG_Proceso_Cancelado" returnvariable="MSG_Proceso_Cancelado"
	Default="Proceso Cancelado" />
<!--- Validación 100: EcodigoSDC Existente --->
<cfif NOT fnDataExists("asp","Empresa","Ecodigo","#readInterfaz201.EcodigoSDC#")>
	<cfinvoke component="sif.Componentes.Translate" 
		method="Translate" Key="MSG_Error_Empresa" returnvariable="MSG_Error_Empresa"
		Default="La empresa no existe" />
	<cfthrow message="Error 100. #MSG_Error_de_Interfaz_201#. #MSG_Error_Empresa#. #MSG_Proceso_Cancelado#!">
</cfif>
<cfquery name="rsEmpresa" datasource="asp">
	select Ereferencia
	from Empresa
	where Ecodigo = #readInterfaz201.EcodigoSDC#
</cfquery>
<cfset Lvar_Ecodigo = rsEmpresa.Ereferencia>
<!--- Validación 200: Imodo IN (A,C) Esta interfaz solo permite Imodo A=Alta y C=Cambio  --->
<cfif NOT ListFind("A,C",readInterfaz201.Imodo)>
	<cfinvoke component="sif.Componentes.Translate" 
		method="Translate" Key="MSG_Error_Modo" returnvariable="MSG_Error_Modo"
		Default="Esta interfaz solo permite Imodo A=Alta y C=Cambio" />
	<cfthrow message="Error 200. #MSG_Error_de_Interfaz_201#. #MSG_Error_Modo#. #MSG_Proceso_Cancelado#!">
</cfif>
<!--- Validación 300: CodigoPuesto Exists --->
<cfif NOT fnDataExists("#session.dsn#","RHPuestos","Ecodigo,RHPcodigo","#Lvar_Ecodigo#,'#readInterfaz201.CodigoPuesto#'")>>
	<cfinvoke component="sif.Componentes.Translate" 
		method="Translate" Key="MSG_Error_Codigo_Puesto" returnvariable="MSG_Error_Codigo_Puesto"
		Default="El código de puesto No Existe" />
		<cfthrow message="Error 300. #MSG_Error_de_Interfaz_201#. #MSG_Error_Codigo_Puesto#. #MSG_Proceso_Cancelado#!">
</cfif>
<!--- Validación 400: CodigoCentroFuncional Exists --->
<cfif NOT fnDataExists("#session.dsn#","CFuncional","Ecodigo,CFcodigo","#Lvar_Ecodigo#,'#readInterfaz201.CodigoCentroFuncional#'")>>
	<cfinvoke component="sif.Componentes.Translate" 
		method="Translate" Key="MSG_Error_Codigo_Centro_Funcional" returnvariable="MSG_Error_Codigo_Centro_Funcional"
		Default="El código de centro funcional No Existe" />
		<cfthrow message="Error 400. #MSG_Error_de_Interfaz_201#. #MSG_Error_Codigo_Centro_Funcional#. #MSG_Proceso_Cancelado#!">
</cfif>
<!--- VERIFICA EL DATO DEL CENTRO FUNCIONAL --->
<cfquery name="rsCF" datasource="#session.dsn#">
	select CFid, Dcodigo, Ocodigo 
	from CFuncional 
	where Ecodigo = #session.ecodigo# 
	and CFcodigo = '#readInterfaz201.CodigoCentroFuncional#'
</cfquery>
<!--- Validación 500: CodigoPlaza Exists --->
<cfif ListFind("A",readInterfaz201.Imodo)>
	<cfif fnDataExists("#session.dsn#","RHPlazas","Ecodigo,CFid,RHPcodigo","#Lvar_Ecodigo#,'#rsCF.CFid#','#readInterfaz201.CodigoPlaza#'")>>
		<cfinvoke component="sif.Componentes.Translate" 
			method="Translate" Key="MSG_Error_Codigo_Plaza" returnvariable="MSG_Error_Codigo_Plaza"
			Default="El código de plaza Existe" />
		<cfthrow message="Error 500. #MSG_Error_de_Interfaz_201#. #MSG_Error_Codigo_Plaza#. #MSG_Proceso_Cancelado#!">
	</cfif>
<cfelseif ListFind("C",readInterfaz201.Imodo)>
	<cfif NOT fnDataExists("#session.dsn#","RHPlazas","Ecodigo,CFid,RHPcodigo","#Lvar_Ecodigo#,'#rsCF.CFid#','#readInterfaz201.CodigoPlaza#'")>>
		<cfinvoke component="sif.Componentes.Translate" 
			method="Translate" Key="MSG_Error_Codigo_Plaza" returnvariable="MSG_Error_Codigo_Plaza"
			Default="El código de plaza No Existe" />
		<cfthrow message="Error 500. #MSG_Error_de_Interfaz_201#. #MSG_Error_Codigo_Plaza#. #MSG_Proceso_Cancelado#!">
	</cfif>
</cfif>
<!--- VERIFICA EL DATO DE LA PLAZA --->
<cfquery name="rsRHP1" datasource="#session.dsn#">
	select RHPid 
	from RHPlazas 
	where Ecodigo = #session.ecodigo# 
	  and CFid =  #rsCF.CFid#
	  and RHPcodigo = '#readInterfaz201.CodigoPlaza#'
</cfquery>
<cfif rsRHP1.recordcount GT 0>
	<cfquery name="rsRHP2" datasource="#session.dsn#">
		select RHLTPfdesde, RHLTPid, RHPPid 
		from RHLineaTiempoPlaza 
		where RHPid = #rsRHP1.RHPid#
	</cfquery>
</cfif>
<cfif ListFind("A",readInterfaz201.Imodo)>
	<cfinvoke component="sif.rh.Componentes.RH_Plazas" method="Alta">
		<cfinvokeargument name="CFid" value="#rsCF.CFid#">
		<cfinvokeargument name="RHPcodigo" value="#readInterfaz201.CodigoPlaza#">
		<cfinvokeargument name="RHPdescripcion" value="#readInterfaz201.DescripcionPlaza#">
		<cfinvokeargument name="Dcodigo" value="#rsCF.Dcodigo#">
		<cfinvokeargument name="Ocodigo" value="#rsCF.Ocodigo#">
		<cfinvokeargument name="RHPpuesto" value="#readInterfaz201.CodigoPuesto#">
		<cfinvokeargument name="RHPactiva" value="#readInterfaz201.Estado#">
		<cfinvokeargument name="RHPresponsable" value="#readInterfaz201.PlazaResp#">
		<cfinvokeargument name="IDInterfaz" value="#GvarID#">
		<cfinvokeargument name="LTfecha" value="#readInterfaz201.FechaActivacion#">
	</cfinvoke>
<cfelseif ListFind("C",readInterfaz201.Imodo)>
	<cfinvoke component="sif.rh.Componentes.RH_Plazas" method="Cambio">
		<cfinvokeargument name="RHPid" value="#rsRHP1.RHPid#">
		<cfif rsRHP2.recordcount GT 0 and rsRHP2.RHPPid GT 0>
			<cfinvokeargument name="RHPPid" value="#rsRHP2.RHPPid#">
		</cfif>
		<cfif rsRHP2.recordcount GT 0 and rsRHP2.RHLTPid GT 0>
			<cfinvokeargument name="RHLTPid" value="#rsRHP2.RHLTPid#">
		</cfif>
		<cfif rsRHP2.recordcount GT 0 and len(trim(rsRHP2.RHLTPfdesde)) GT 0>
			<cfinvokeargument name="LTfecha" value="#rsRHP2.RHLTPfdesde#">
		</cfif>
		<cfinvokeargument name="CFid" value="#rsCF.CFid#">
		<cfinvokeargument name="RHPcodigo" value="#readInterfaz201.CodigoPlaza#">
		<cfinvokeargument name="RHPdescripcion" value="#readInterfaz201.DescripcionPlaza#">
		<cfinvokeargument name="Dcodigo" value="#rsCF.Dcodigo#">
		<cfinvokeargument name="Ocodigo" value="#rsCF.Ocodigo#">
		<cfinvokeargument name="RHPpuesto" value="#readInterfaz201.CodigoPuesto#">
		<cfinvokeargument name="RHPactiva" value="#readInterfaz201.Estado#">
		<cfinvokeargument name="RHPresponsable" value="#readInterfaz201.PlazaResp#">
	</cfinvoke>
</cfif>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>