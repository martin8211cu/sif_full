<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset MSG_LimRep 	= t.Translate('MSG_LimRep','Se genero un reporte más grande de lo permitido.  Se abortó el proceso')>


<cffunction name="get_CualMes" access="public" returntype="string">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Nombre del mes --->">
		<cfswitch expression="#valor#">
			<cfcase value="1"> <cfset CualMes = '#CMB_Enero#'> </cfcase>
			<cfcase value="2"> <cfset CualMes = '#CMB_Febrero#'> </cfcase>
			<cfcase value="3"> <cfset CualMes = '#CMB_Marzo#'> </cfcase>
			<cfcase value="4"> <cfset CualMes = '#CMB_Abril#'> </cfcase>
			<cfcase value="5"> <cfset CualMes = '#CMB_Mayo#'> </cfcase>
			<cfcase value="6"> <cfset CualMes = '#CMB_Junio#'> </cfcase>												
			<cfcase value="7"> <cfset CualMes = '#CMB_Julio#'> </cfcase>
			<cfcase value="8"> <cfset CualMes = '#CMB_Agosto#'> </cfcase>
			<cfcase value="9"> <cfset CualMes = '#CMB_Septiembre#'> </cfcase>
			<cfcase value="10"> <cfset CualMes = '#CMB_Octubre#'> </cfcase>
			<cfcase value="11"> <cfset CualMes = '#CMB_Noviembre#'> </cfcase>
			<cfcase value="12"> <cfset CualMes = '#CMB_Diciembre#'> </cfcase>
			<cfdefaultcase> <cfset CualMes = '#CMB_Enero#'> </cfdefaultcase>
		</cfswitch>
	<cfreturn #CualMes#>
</cffunction>

<cfset NombMes = '#get_CualMes(url.mes)#'>
<cfset NombMes2 = '#get_CualMes(url.mes2)#'>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsMonloc" datasource="#session.DSN#">
	select Mnombre
	from Empresas a
	inner join Monedas m
		on  a.Ecodigo = m.Ecodigo
		and a.Mcodigo = m.Mcodigo
	where a.Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
	Select 
		b.Dfecha,
		c.SNidentificacion,
		c.SNnombre,
		ct.CCTcodigo #_Cat# ' - ' #_Cat# ct.CCTdescripcion as Concepto,
		b.Ddocumento,
		b.Dtipocambio,
		m.Miso4217,
		coalesce (rtrim(d.direccion1), d.direccion2) as direccion1,
		a.SubTotalFac as SubTotalFac,
		a.MontoCalculado as MontoCalculado,
		a.TotalFac as TotalFac,
		a.SubTotalFac*b.Dtipocambio as importe
	
	from ImpDocumentosCxC a
		inner join Documentos b
			inner join CCTransacciones ct
				on ct.CCTcodigo = b.CCTcodigo
			   and ct.Ecodigo   = b.Ecodigo
			on a.CCTcodigo = b.CCTcodigo
			and a.Ecodigo  = b.Ecodigo
			and a.Documento = b.Ddocumento 
		inner join SNegocios c
			on  b.Ecodigo = c.Ecodigo
			and b.SNcodigo = c.SNcodigo
		left outer join DireccionesSIF d
			on   d.id_direccion  = b.id_direccionFact
		inner join Monedas m
			on  b.Ecodigo = m.Ecodigo
			and b.Mcodigo = m.Mcodigo
	where   a.Periodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and a.Periodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
		and ((a.Periodo * 100 + a.Mes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">))
		and a.Ecodigo = #session.Ecodigo#
	order by b.Dfecha,c.SNnombre,b.Ddocumento,m.Miso4217
</cfquery>

<cfif rsReporte.recordcount GT 10000>
	<br><br><cfoutput>#MSG_LimRep#</cfoutput><br><br>
	<cfabort>
</cfif>

<!--- Define cual reporte va a llamar --->
<cfset archivo = "FiscalCliente.cfr">
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset TIT_RepFisc 	= t.Translate('TIT_RepFisc','Reporte Fiscal - Clientes')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Hora 		= t.Translate('LB_Hora','Hora')>
<cfset LB_CC 		= t.Translate('LB_CC','Cuentas por Cobrar')>
<cfset LB_Per_Desde = t.Translate('LB_Per_Desde','Periodo Desde','/sif/generales.xml')>
<cfset LB_Per_Hasta = t.Translate('LB_Per_Hasta','Periodo Hasta','/sif/generales.xml')>
<cfset LB_Per_Hasta = t.Translate('LB_Per_Hasta','Periodo Hasta','/sif/generales.xml')>
<cfset CMB_Mes 		= t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset LB_FecOper 	= t.Translate('LB_FecOper','Fecha Operación')>
<cfset LB_RFC	 	= t.Translate('LB_RFC','RFC')>
<cfset LB_CLIENTE 	= t.Translate('LB_CLIENTE','Cliente','/sif/generales.xml')>
<cfset LB_Concepto 	= t.Translate('LB_Concepto','Concepto','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_DomFiscal = t.Translate('LB_DomFiscal','Domicilio Fiscal')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Importe 	= t.Translate('LB_Importe','Importe')>
<cfset LB_Impuesto 	= t.Translate('LB_Impuesto','Impuesto')>
<cfset LB_Total 	= t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_FinRep 	= t.Translate('LB_FinRep','Fin del Reporte')>
<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
<cfset LB_Impuestos = t.Translate('LB_Impuestos','Impuestos')>
<!--- INVOCA EL REPORTE --->
<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.FiscalCliente"/>
	<cfelse>
<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
	<cfreportparam name="Edescripcion" 	value="#rsEmpresa.Edescripcion#">
	<cfreportparam name="periodo" 		value="#url.periodo#">
	<cfreportparam name="mes" 			value="#NombMes#">
	<cfreportparam name="periodo2" 		value="#url.periodo2#">
	<cfreportparam name="mes2" 			value="#NombMes2#">
	<cfreportparam name="Mlocal" 		value="#rsMonloc.Mnombre#">
	<cfreportparam name="TIT_RepFisc" 	value="#TIT_RepFisc#">
	<cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
	<cfreportparam name="LB_Hora" 		value="#LB_Hora#">
	<cfreportparam name="LB_CC" 		value="#LB_CC#">
	<cfreportparam name="LB_Per_Desde" 	value="#LB_Per_Desde#">
	<cfreportparam name="LB_Per_Hasta" 	value="#LB_Per_Hasta#">
	<cfreportparam name="CMB_Mes" 		value="#CMB_Mes#">
	<cfreportparam name="LB_FecOper"	value="#LB_FecOper#">
	<cfreportparam name="LB_RFC" 		value="#LB_RFC#">
	<cfreportparam name="LB_CLIENTE" 	value="#LB_CLIENTE#">
	<cfreportparam name="LB_Concepto" 	value="#LB_Concepto#">
	<cfreportparam name="LB_Documento" 	value="#LB_Documento#">
	<cfreportparam name="LB_DomFiscal" 	value="#LB_DomFiscal#">
	<cfreportparam name="LB_Moneda" 	value="#LB_Moneda#">
	<cfreportparam name="LB_Importe" 	value="#LB_Importe#">
	<cfreportparam name="LB_Impuesto" 	value="#LB_Impuesto#">
	<cfreportparam name="LB_Impuestos" 	value="#LB_Impuestos#">
	<cfreportparam name="LB_Total" 		value="#LB_Total#">
	<cfreportparam name="LB_FinRep" 	value="#LB_FinRep#">
	<cfreportparam name="LB_Totales" 	value="#LB_Totales#">
</cfreport>
</cfif>