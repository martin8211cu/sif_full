<cfinvoke key="LB_MsgError" default="No se han generado registros para este reporte"	returnvariable="LB_MsgError"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_Archivo" default="Reporte_De_OrdenesPago"	returnvariable="LB_Archivo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_MsgDemasiados" default="Su consulta posee demasiados registros, por favor defina de nuevo los filtros y vuelva a intentarlo."	returnvariable="LB_MsgDemasiados"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>

<cfinvoke key="LB_Tit_Rep" default="Reporte de Órdenes de Pago"	returnvariable="LB_Tit_Rep"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_FechaRep" default="Fecha de Reporte:"	returnvariable="LB_FechaRep"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_NOrden" default="N° Orden"	returnvariable="LB_NOrden"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_Cedula" default="Cédula"	returnvariable="LB_Cedula"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_Beneficiario" default="Beneficiario"	returnvariable="LB_Beneficiario"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_FecPago" default="Fecha Pago"	returnvariable="LB_FecPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_Estado" default="Estado"	returnvariable="LB_Estado"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_EmpresaPago" default="Empresa Pago"	returnvariable="LB_EmpresaPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_CtaPago" default="Cuenta Origen"	returnvariable="LB_CtaPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_Banco" default="Banco Origen"	returnvariable="LB_Banco"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_DocPago" default="Doc Pago"	returnvariable="LB_DocPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_MonPago" default="Moneda Pago"	returnvariable="LB_MonPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_MontoPagar" default="Monto Pagar"	returnvariable="LB_MontoPagar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_Pagina" default="Página:"	returnvariable="LB_Pagina"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_Pagina" default="Página:"	returnvariable="LB_Pagina"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>

<cfinvoke key="LB_EPreparacion" default="En Preparación"	returnvariable="LB_EPreparacion"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_EEnEmision" default="En Emisión"	returnvariable="LB_EEnEmision"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_ESAplicar" default="Sin Aplicar"	returnvariable="LB_ESAplicar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_EAplicada" default="Aplicada"	returnvariable="LB_EAplicada"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_EAnulado" default="Anulada"	returnvariable="LB_EAnulado"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_EAprobacion" default="Aprobación"	returnvariable="LB_EAprobacion"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_ERechazada" default="Rechazada"	returnvariable="LB_ERechazada"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>
<cfinvoke key="LB_EDesconocido" default="Estado desconocido"	returnvariable="LB_EDesconocido"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago-form.xml"/>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery datasource="#session.dsn#" name="lista">
		Select	count(1) as cantidad
		from TESordenPago op
			left join CuentasBancos cb
				inner join Bancos b
					on b.Bid = cb.Bid
				 on cb.CBid=CBidPago
			left join TESmedioPago mp
				 on mp.TESid 		= #session.Tesoreria.TESid#
				and mp.CBid			= op.CBidPago
				and mp.TESMPcodigo 	= op.TESMPcodigo
			left outer join Empresas e
				on e.Ecodigo=op.EcodigoPago
		where op.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
        	and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			<cfif len(trim(url.TESOPnumero_F))>
				and TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TESOPnumero_F#">
			</cfif>
			<cfif len(trim(url.Beneficiario_F))>
				and upper(TESOPbeneficiario #_Cat# ' ' #_Cat# TESOPbeneficiarioSuf) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.Beneficiario_F))#%">
			</cfif>
			<cfif len(trim(url.TESOPfechaPago_I))>
				and TESOPfechaPago >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(url.TESOPfechaPago_I)#">
			</cfif>
			<cfif len(trim(url.TESOPfechaPago_F))>
				and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(url.TESOPfechaPago_F)#">
			</cfif>

			<cfif len(trim(url.CBidPago_F)) and url.CBidPago_F NEQ '-1'>
				and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBidPago_F#">
			<cfelse>
				<cfif isdefined('url.EcodigoPago_F') and len(trim(url.EcodigoPago_F)) and url.EcodigoPago_F NEQ '-1'>
					and op.EcodigoPago=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoPago_F#">
				</cfif>
				<cfif isdefined('url.Miso4217Pago_F') and len(trim(url.Miso4217Pago_F)) and url.Miso4217Pago_F NEQ '-1'>
					and op.Miso4217Pago=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Miso4217Pago_F#">
				</cfif>
			</cfif>
			<cfif url.TESOPestado_F NEQ -1 AND url.TESOPestado_F NEQ "">
			  and TESOPestado = #url.TESOPestado_F#
			</cfif>
			<cfif url.docPago_F NEQ "">
				AND case mp.TESTMPtipo
					when 1 then <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
					when 2 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					when 3 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					when 4 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					when 5 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
				end = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.docPago_F#">
			</cfif>
</cfquery>
<cfif lista.cantidad GT 2000>
	<cf_errorCode	code = "50052" msg = "#LB_MsgDemasiados#">
<cfelseif lista.cantidad EQ 0>
	<cf_errorCode	code = "50349" msg = "#LB_MsgError#.">
</cfif>
		<cfquery datasource="#session.dsn#" name="lista">
			Select
					'#LB_Tit_Rep#' as Titulo,
					'#LB_FechaRep#' as Fecha,
					'#LB_NOrden#' as Orden,
					'#LB_Cedula#' as Cedula,
					'#LB_Beneficiario#' as Beneficiario,
					'#LB_FecPago#' as FecPago,
					'#LB_Estado#' as Estado,
					'#LB_EmpresaPago#' as EmpresaPag,
					'#LB_CtaPago#' as CtaPago,
					'#LB_Banco#' as Banco,
					'#LB_DocPago#' as DctoPago,
					'#LB_MonPago#' as MonedaPag,
					'#LB_MontoPagar#' as MontoPag,
					'#LB_Pagina#' as Pagina,
					op.TESOPid,
					TESOPnumero,
					TESOPbeneficiarioId,
					TESOPbeneficiario as TESOPbeneficiario,
					TESOPfechaPago,
					op.Miso4217Pago,
					Edescripcion as empPago,
					Bdescripcion as bcoPago,
					CBcodigo,
					isnull(TESOPtotalPago,0) as TESOPtotalPago,
					case mp.TESTMPtipo
						when 1 then 'CHK ' #_Cat# <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
						when 2 then 'TRI ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 3 then 'TRE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 4 then 'TRM ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 5 then 'TCE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					end as DocPago,
					TESOPmsgRechazo,
					10 as PASO,
					case op.TESOPestado
						when  10 then '#LB_EPreparacion#'
						when  11 then '#LB_EEnEmision#'
                        when  110 then '#LB_ESAplicar#'
						when  12 then '#LB_EAplicada#'
						when  13 then '#LB_EAnulado#'
						when 101 then '#LB_EAprobacion#'
						when 103 then '#LB_ERechazada#'
						else '#LB_EDesconocido#'
					end as TESOPestado,
					t.TESTPbanco,
					t.TESTPcuenta
			from TESordenPago op
				LEFT JOIN TEStransferenciaP t
				ON t.TESTPid = op.TESTPid
				left join CuentasBancos cb
					inner join Bancos b
						on b.Bid = cb.Bid
					 on cb.CBid=CBidPago
				left join TESmedioPago mp
					 on mp.TESid 		= #session.Tesoreria.TESid#
					and mp.CBid			= op.CBidPago
					and mp.TESMPcodigo 	= op.TESMPcodigo
				left outer join Empresas e
					on e.Ecodigo=op.EcodigoPago
			where op.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
            	and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				<cfif len(trim(url.TESOPnumero_F))>
					and TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TESOPnumero_F#">
				</cfif>
				<cfif len(trim(url.Beneficiario_F))>
					and upper(TESOPbeneficiario #_Cat# ' ' #_Cat# TESOPbeneficiarioSuf) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.Beneficiario_F))#%">
				</cfif>
				<cfif len(trim(url.TESOPfechaPago_I))>
					and TESOPfechaPago >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(url.TESOPfechaPago_I)#">
				</cfif>
				<cfif len(trim(url.TESOPfechaPago_F))>
					and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(url.TESOPfechaPago_F)#">
				</cfif>

				<cfif len(trim(url.CBidPago_F)) and url.CBidPago_F NEQ '-1'>
					and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBidPago_F#">
				<cfelse>
					<cfif isdefined('url.EcodigoPago_F') and len(trim(url.EcodigoPago_F)) and url.EcodigoPago_F NEQ '-1'>
						and op.EcodigoPago=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoPago_F#">
					</cfif>
					<cfif isdefined('url.Miso4217Pago_F') and len(trim(url.Miso4217Pago_F)) and url.Miso4217Pago_F NEQ '-1'>
						and op.Miso4217Pago=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Miso4217Pago_F#">
					</cfif>
				</cfif>
				<cfif url.TESOPestado_F NEQ -1 AND url.TESOPestado_F NEQ "">
				  and TESOPestado = #url.TESOPestado_F#
				</cfif>
				<cfif url.docPago_F NEQ "">
					AND case mp.TESTMPtipo
						when 1 then <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
						when 2 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 3 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 4 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 5 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					end = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.docPago_F#">
				</cfif>
		</cfquery>
		
<cfif url.formato NEQ "txt">
  <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and url.formato EQ "excel">
	  <cfset typeRep = 1>
	  <!--- <cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif> --->
	  <cf_js_reports_service_tag queryReport = "#lista#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "tesoreria.reportes.ReporteOrdenPago"
		headers = "empresa:#session.Enombre#"/>
	<cfelse>
		<cfset sumTotal = arraySum(lista['TESOPtotalPago'])>
		<cfreport format="#url.Formato#" template= "ReporteOrdenPago.cfr" query="#lista#">
			<cfreportparam name="Edescripcion" value="#session.Enombre#">
		    <cfreportparam name="Total" value="#sumTotal#">
		</cfreport>
	</cfif>
<cfelse>
	<cf_exportQueryToFile query="#lista#" separador="#chr(9)#" filename="#LB_Archivo#_#session.Usucodigo#_#LSDateFormat(Now(),'ddmmyyyy')#_#LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="false">
</cfif>


