<!--- Creado  por Rodolfo Jiménez Jara.
		Fecha: 11-2-2006.
		Motivo: Relacion de Docuentos de CxP
--->
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
<cfset LB_Todos 	= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset TIT_RelDoctos	= t.Translate('TIT_RelDoctos','Relación de Documentos')>
<cfset LB_CxP 		= t.Translate('LB_CxP','Cuentas por Pagar')>
<cfset LB_Periodo 	= t.Translate('LB_Periodo','Periodo')>
<cfset LB_PerHasta 	= t.Translate('LB_Periodo','Periodo Hasta')>
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset CMB_Mes = t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset LB_Socio_Desde = t.Translate('LB_Socio_Desde','Socio de Negocios Desde')>
<cfset LB_Socio_Hasta = t.Translate('LB_Socio_Hasta','Socio de Negocios Hasta')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Debitos 	= t.Translate('LB_Debitos','Débitos')>
<cfset LB_Creditos 	= t.Translate('LB_Creditos','Créditos')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Total 	= t.Translate('LB_Total','Total')>
<cfset LB_TotalMon 	= t.Translate('LB_TotalMon','Total Moneda')>
<cfset MSG_FinRep 	= t.Translate('MSG_FinRep','Fin del Reporte')>

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

<cfset SNnombreI = '#LB_Todos#' >
<cfset SNnombreF = '#LB_Todos#' >

<cfset NombMes = '#get_CualMes(url.mes)#'>

<cfset NombMes2 = '#get_CualMes(url.mes2)#'>

<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
		<cfquery name="rsSNnombre" datasource="#session.DSN#">
			select  s.SNnombre from SNegocios s
			where s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  			  and upper(s.SNnumero)  = <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
		</cfquery>
		<cfif isdefined("rsSNnombre") and rsSNnombre.RecordCount GT 0>
			<cfset SNnombreI = rsSNnombre.SNnombre >
		</cfif>
</cfif>

<cfif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
		<cfquery name="rsSNnombre" datasource="#session.DSN#">
			select  s.SNnombre from SNegocios s
			where s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  			  and upper(s.SNnumero)  = <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
		</cfquery>
		<cfif isdefined("rsSNnombre") and rsSNnombre.RecordCount GT 0>
			<cfset SNnombreF = rsSNnombre.SNnombre >
		</cfif>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
 select
				IDdocumento,
				ma.CPTcodigo as tipo,
				ma.Ddocumento,
				EDtref as CPTRcodigo,
				EDdocref as DRdocumento,
				s.SNcodigo,
				s.SNnumero,
				s.SNidentificacion,
				s.SNnombre,
				ma.Dfecha ,
				Dfechavenc,
				s.Mcodigo,
				(ma.Dtotal  *case when t.CPTtipo = 'D' then 1.00 else -1.00 end)  as Monto,
				EDsaldo,
				o.Oficodigo,
				ma.Ccuenta,
				m.Miso4217 as moneda,
				<cf_dbfunction name="concat" args="s.SNnumero,' - ',s.SNnombre,' ','(',s.SNidentificacion,')'"> as CorteNombre,
				 t.CPTtipo as tipomov,
				 m.Mnombre,
				 (ma.Dtotal  *case when t.CPTtipo = 'D' then 1.00  else 0 end)  as MontoDeb,
 				 (ma.Dtotal  *case when t.CPTtipo = 'C' then -1.00  else 0 end)  as MontoCre
			from HEDocumentosCP hd
				inner join SNegocios s
				  on hd.Ecodigo = s.Ecodigo
						 and hd.SNcodigo = s.SNcodigo
				inner join Oficinas o
				  on hd.Ecodigo = o.Ecodigo
						 and hd.Ocodigo = o.Ocodigo
				inner join Monedas m
				  on m.Ecodigo = hd.Ecodigo
				  and m.Mcodigo = hd.Mcodigo

				inner join BMovimientosCxP ma <!--- -- (index BMovimientos03) --->
				on ma.SNcodigo  = s.SNcodigo
						and ma.Ecodigo   = s.Ecodigo
						and ma.CPTcodigo = hd.CPTcodigo
						and ma.Ddocumento = hd.Ddocumento
						and ma.CPTRcodigo = hd.CPTcodigo
						and ma.DRdocumento = hd.Ddocumento
						<cfif isdefined ("url.periodo") and isdefined ("url.periodo2")>
							and ma.BMperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
							and ma.BMperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
						 </cfif>
						 <cfif isdefined ("url.periodo") and isdefined ("url.mes")>
						   and ((ma.BMperiodo * 100 + ma.BMmes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">))
						 </cfif>

				inner join CPTransacciones t
				     on    t.Ecodigo = hd. Ecodigo
					 and  t.CPTcodigo = hd.CPTcodigo

	where hd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<!---FILTRO DE SOCIOS DE NEGOCIOS --->

		<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			<cfif url.SNnumero gte SNnumerob2><!--- si el primero es mayor que el segundo. --->
					and upper(s.SNnumero) between <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumerob2)#">
					and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
			<cfelse>
					and upper(s.SNnumero) between <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumero)#">
					and <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumerob2)#">
			</cfif>
		<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
			and upper(s.SNnumero) >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
		<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			and upper(s.SNnumero) <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
		</cfif>

		<!--- (INICIO) NUEVOS FILTROS EDUARDO GONZÁLEZ 20/03/2018 --->
		<cfif isDefined("url.Transaccion") AND url.Transaccion NEQ -1>
			AND t.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Transaccion#">
		</cfif>

		<cfif isDefined("url.Usuario") AND url.Usuario NEQ -1>
			AND hd.EDusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Usuario#">
		</cfif>
		<!--- (FIN) NUEVOS FILTROS EDUARDO GONZÁLEZ 20/03/2018 --->

		order by hd.Mcodigo, ma.SNcodigo,  ma.Dfecha  desc

</cfquery>

<cfif rsReporte.recordcount GT 10000>
<cfset MSG_LimRep 	= t.Translate('MSG_LimRep','Se genero un reporte más grande de lo permitido.  Se abortó el proceso')>
	<br>
	<br>
	#MSG_LimRep#
	<br>
	<br>
	<cfabort>
</cfif>

<!--- Define cual reporte va a llamar --->

	<cfset archivo = "RelacionDocumentos.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
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
		fileName = "cp.consultas.reportes.RelacionDocumentos"
		headers = "empresa:#rsEmpresa.Edescripcion#"/>
<cfelse>
	<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">

		<cfreportparam name="periodo" value="#url.periodo#">
		<cfreportparam name="mes" value="#NombMes#">

		<cfreportparam name="periodo2" value="#url.periodo2#">
		<cfreportparam name="mes2" value="#NombMes2#">

		<cfreportparam name="SNnombre" value="#SNnombreI#">
		<cfreportparam name="SNnombre2" value="#SNnombreF#">
		<cfreportparam name="TIT_RelDoctos" value="#TIT_RelDoctos#">
		<cfreportparam name="LB_CxP" 		value="#LB_CxP#">
		<cfreportparam name="LB_Periodo" 	value="#LB_Periodo#">
		<cfreportparam name="LB_PerHasta" 	value="#LB_PerHasta#">
		<cfreportparam name="LB_Hora" 	value="#LB_Hora#">
		<cfreportparam name="LB_Fecha" 	value="#LB_Fecha#">
		<cfreportparam name="CMB_Mes" 	value="#CMB_Mes#">
		<cfreportparam name="LB_Socio_Desde" value="#LB_Socio_Desde#">
		<cfreportparam name="LB_Socio_Hasta" value="#LB_Socio_Hasta#">
		<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
		<cfreportparam name="LB_Documento" 	value="#LB_Documento#">
		<cfreportparam name="LB_Transaccion" value="#LB_Transaccion#">
		<cfreportparam name="LB_Debitos" 	value="#LB_Debitos#">
		<cfreportparam name="LB_Creditos"	 value="#LB_Creditos#">
		<cfreportparam name="LB_SocioNegocio" value="#LB_SocioNegocio#">
		<cfreportparam name="LB_Total" value="#LB_Total#">
		<cfreportparam name="LB_TotalMon" value="#LB_TotalMon#">
		<cfreportparam name="MSG_FinRep" value="#MSG_FinRep#">
	</cfreport>
</cfif>