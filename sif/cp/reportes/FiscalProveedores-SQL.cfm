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
<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
<cfset TIT_RepFiscal	= t.Translate('TIT_RepFiscal','Reporte Fiscal - Proveedores')>
<cfset LB_CxP 		= t.Translate('LB_CxP','Cuentas por Pagar')>
<cfset LB_Periodo 	= t.Translate('LB_Periodo','Periodo')>
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset CMB_Mes = t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset MSG_FinRep 	= t.Translate('MSG_FinRep','Fin del Reporte')>
<cfset LB_Total 	= t.Translate('LB_Total','Total')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_FechaOper 	= t.Translate('LB_FechaOper','Fecha Operación')>
<cfset LB_RFC 	= t.Translate('LB_RFC','RFC')>
<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_Concepto = t.Translate('LB_Concepto','Concepto','/sif/generales.xml')>
<cfset LB_Domicilio = t.Translate('LB_Domicilio','Domicilio Fiscal')>
<cfset LB_Impuestos = t.Translate('LB_Impuestos','Impuestos')>
<cfset LB_Importe = t.Translate('LB_Importe','Importe')>
<cfset LB_Iporcentaje = t.Translate('LB_Iporcentaje','%Imp')>






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
	where a.Ecodigo =  #session.Ecodigo# 
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		b.Dfecha,
		c.SNidentificacion,
		c.SNnombre,
		ct.CPTcodigo #_Cat# ' - ' #_Cat# ct.CPTdescripcion as Concepto,
		b.Ddocumento,
		b.Dtipocambio,
		m.Miso4217,
		coalesce (rtrim(d.direccion1), d.direccion2) as direccion1,
		a.SubTotalFac as SubTotalFac,
		a.MontoCalculado as MontoCalculado,
		a.TotalFac as TotalFac,
		a.SubTotalFac*b.Dtipocambio as Importe,
        im.Iporcentaje 
	from ImpDocumentosCxP a
		inner join EDocumentosCP b
			inner join CPTransacciones ct
				on ct.CPTcodigo = b.CPTcodigo
 			   and ct.Ecodigo   = b.Ecodigo
			on a.IDdocumento = b.IDdocumento
			and a.Ecodigo = b.Ecodigo 
		inner join SNegocios c
			on  b.Ecodigo = c.Ecodigo
			and b.SNcodigo = c.SNcodigo
		left outer join DireccionesSIF  d
			on   d.id_direccion  = b.id_direccion 
		inner join Monedas m
			on  b.Ecodigo = m.Ecodigo
			and b.Mcodigo = m.Mcodigo
        inner join Impuestos im on a.Icodigo = im.Icodigo
	where   a.Periodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and a.Periodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
		and ((a.Periodo * 100 + a.Mes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">))
		and a.Ecodigo =  #session.Ecodigo# 
        <cfif url.Ocodigo GTE 0>
        	and b.Ocodigo = #url.Ocodigo#
        </cfif>
        order by b.Dfecha,c.SNnombre,b.Ddocumento,m.Miso4217
</cfquery>

<cfif rsReporte.recordcount GT 10000>
<cfset MSG_LimRep 	= t.Translate('MSG_LimRep','Se genero un reporte más grande de lo permitido.  Se abortó el proceso')>
	<br><br>
	<div align="center">*************<cfoutput>#MSG_LimRep#</cfoutput>**************</div>
	<br><br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
<cfset MSG_SinDatos 	= t.Translate('MSG_SinDatos','No hay datos para generar el reporte.  Se abortó el proceso')>
	<br><br>
	<div align="center">*************<cfoutput>#MSG_SinDatos#</cfoutput>**************</div>
	<cfabort>
</cfif>

<!--- Define cual reporte va a llamar --->
<cfset archivo = "FiscalProveedores.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo =  #session.Ecodigo# 
</cfquery>

<!--- INVOCA EL REPORTE --->
<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and url.formato EQ "excel">
	  <cfset typeRep = 1>
	  <cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.#FiscalProveedores#"
		headers = "empresa:#rsEmpresa.Edescripcion#"/>
<cfelse>
	<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
		<cfreportparam name="Edescripcion" 	value="#rsEmpresa.Edescripcion#">
		<cfreportparam name="periodo" 		value="#url.periodo#">
		<cfreportparam name="mes" 			value="#NombMes#">
		<cfreportparam name="periodo2" 		value="#url.periodo2#">
		<cfreportparam name="mes2" 			value="#NombMes2#">
		<cfreportparam name="Mlocal" 		value="#rsMonloc.Mnombre#">
		<cfreportparam name="TIT_RepFiscal" 	value="#TIT_RepFiscal#">
		<cfreportparam name="LB_CxP" 			value="#LB_CxP#">
		<cfreportparam name="LB_Periodo" 		value="#LB_Periodo#">
		<cfreportparam name="LB_Hora" 			value="#LB_Hora#">
		<cfreportparam name="LB_Fecha" 			value="#LB_Fecha#">
		<cfreportparam name="CMB_Mes" 			value="#CMB_Mes#">
		<cfreportparam name="MSG_FinRep" 		value="#MSG_FinRep#">
		<cfreportparam name="LB_Total" 			value="#LB_Total#">
		<cfreportparam name="LB_Totales" 		value="#LB_Totales#">
		<cfreportparam name="LB_Moneda" 		value="#LB_Moneda#">
		<cfreportparam name="LB_Iporcentaje" 	value="#LB_Iporcentaje#"> 
		<cfreportparam name="LB_Documento" 		value="#LB_Documento#">
		<cfreportparam name="LB_FechaOper" 		value="#LB_FechaOper#">
		<cfreportparam name="LB_RFC" 			value="#LB_RFC#">
		<cfreportparam name="LB_PROVEEDOR" 		value="#LB_PROVEEDOR#">
		<cfreportparam name="LB_Concepto" 		value="#LB_Concepto#">
		<cfreportparam name="LB_Domicilio" 		value="#LB_Domicilio#">
		<cfreportparam name="LB_Impuestos" 		value="#LB_Impuestos#">
		<cfreportparam name="LB_Importe" 		value="#LB_Importe#">
		
	</cfreport>
</cfif>