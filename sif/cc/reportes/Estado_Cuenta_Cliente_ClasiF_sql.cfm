<cfsetting requesttimeout="600">
<cfinclude template="Estado_Cuenta_funciones.cfm">

<cfif url.TipoReporte eq 0>
	<cfset LvarEstadoCuentaCliente = true>
	<cfset fnProcesaSalidaEstadoCuenta()>
<cfelse>
	<cfset socios          = CreaTemp1()>
	<cfset documentos      = CreaTemp3()>
	<cfset SaldosIniciales = CreaTemp4()>
	<cfset fnGeneraDatosInfoReporteAntiguedad()>
	
	<cfif url.TipoReporte EQ 2 >
		<cfset fnProcesaSalidaAntiguedadSaldos()>
	</cfif>
	<cfif url.TipoReporte EQ 1>
		<cfset fnProcesaSalidaAntiguedadSaldosR()>
	</cfif>
</cfif>

<cfif isdefined("rsReporte") and rsReporte.recordcount gt 20000>
	<cf_errorCode	code = "50198" msg = "Se han generado mas de 20000 registros para este reporte.">
	<cfabort>
</cfif>

<!--- Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
		from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!---Clasificaciones de SN--->
<cfif not isdefined('LvarEstadoCuentaCliente')>
	<cfquery name="rsSNCEdescripcion" datasource="#session.DSN#">
		select SNCEdescripcion
			from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
	</cfquery>
</cfif>
<!---Valores Clasificacion  de SN--->
<cfif not isdefined('LvarEstadoCuentaCliente')>
	<cfquery name="rsSNCDdescripcion1" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
	</cfquery>
	<cfquery name="rsSNCDdescripcion2" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
	</cfquery>
</cfif>
<!---Socios de Negocio--->
<cfquery name="rsSNnombre1" datasource="#session.DSN#">
	select SNnombre
		from  SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsSNnombre2" datasource="#session.DSN#">
	select SNnombre
		from  SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!---Orden Consulta Clasificación--->
<cfif not isdefined('LvarEstadoCuentaCliente')>
	<cfquery name="rsSNCEdescripcion_orden" datasource="#session.DSN#">
		select SNCEdescripcion
			from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid_orden#">
	</cfquery>
</cfif>
<!---Formato Impresion--->
<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
	<cfset formatos = "pdf">
</cfif>

<!--- Invocación del reporte --->
<cfset nombreReporteJR = "">
<cfif url.TipoReporte EQ 0>
	<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasF.cfr">
  <cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasF">
	<cfif chk_cod_Direccion NEQ -1>
		<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasFxid_direccion.cfr">
		<cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasFxid_direccion">
	</cfif>
</cfif>

<cfif url.TipoReporte EQ 1>
	<cfset LvarReporte = "AntiguedadSaldosxClasFecha.cfr">
	<cfset nombreReporteJR = "AntiguedadSaldosxClasFecha">
</cfif>
<cfif url.TipoReporte EQ 2>
	<cfset LvarReporte = "AntiguedadSaldosxClasClienteFecha.cfr">
	<cfset nombreReporteJR = "AntiguedadSaldosxClasClienteFecha">
</cfif>

<cfset LvarLeyendaCxC = ''>
<cfquery name="rsLeyendaCxC" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo = #session.Ecodigo#
    and Pcodigo = 921
    and Mcodigo = 'CC'
</cfquery>
<cfif rsLeyendaCxC.recordcount gt 0>
    <cfset LvarLeyendaCxC = rsLeyendaCxC.Pvalor>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_EdoCta = t.Translate('LB_EdoCta','Estado de Cuenta  del ')>
<cfset LB_Hasta = t.Translate('LB_Hasta','  al   ')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha ')>
<cfset LB_Hora = t.Translate('LB_Hora','Hora ')>
<cfset MSG_Codigo = t.Translate('MSG_Codigo','Código')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación')>
<cfset LB_LimCred = t.Translate('LB_LimCred','Limite Crédito')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio')>
<cfset LB_Telefono = t.Translate('LB_Telefono','Teléfono')>
<cfset LB_Cobrador = t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Dirección')>
<cfset LB_Apartado = t.Translate('LB_Apartado','Apartado')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Ref = t.Translate('LB_Ref','Ref.')>
<cfset LB_Sucursal = t.Translate('LB_Sucursal','Sucursal')>
<cfset LB_NRecl = t.Translate('LB_NRecl','N° Reclamo')>
<cfset LB_Debitos = t.Translate('LB_Debitos','Débitos')>
<cfset LB_Creditos = t.Translate('LB_Creditos','Créditos')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_AnaSaldo = t.Translate('LB_AnaSaldo','Análisis de Saldo')>
<cfset LB_VencSaldo = t.Translate('LB_VencSaldo','Vencimiento de Saldo')>
<cfset LB_Corriente = t.Translate('LB_Corriente','  Corriente')>
<cfset LB_SinVenc = t.Translate('LB_SinVenc','  Sin Vencer')>
<cfset LB_De = t.Translate('LB_De','De 0 a')>
<cfset LB_omas = t.Translate('LB_omas',' o mas')>
<cfset LB_Morosidad = t.Translate('LB_Morosidad','  Morosidad')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripción')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto')>
<cfset MSG_Pie = t.Translate('MSG_Pie','Hemos recibido las facturas originales de ordenes de compras correspondientes a este estado de cuenta y aceptamos como correcto y definitivo el saldo que refleja este estado de cuenta.')>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.#nombreReporteJR#"/>
	<cfelse>
<cfreport format="#formatos#" template="#LvarReporte#" query="#rsReporte#">	
	<cfreportparam name="Tipo" value="0">
	<cfreportparam name="LB_EdoCta" value="#LB_EdoCta#">
	<cfreportparam name="LB_Hasta" value="#LB_Hasta#">
	<cfreportparam name="LB_Fecha" value="#LB_Fecha#">
	<cfreportparam name="LB_Hora" value="#LB_Hora#">
	<cfreportparam name="MSG_Codigo" value="#MSG_Codigo#">	
	<cfreportparam name="LB_Identificacion" value="#LB_Identificacion#">	
	<cfreportparam name="LB_LimCred" value="#LB_LimCred#">	
	<cfreportparam name="LB_SocioNegocio" value="#LB_SocioNegocio#">	
	<cfreportparam name="LB_Telefono" value="#LB_Telefono#">	
	<cfreportparam name="LB_Cobrador" value="#LB_Cobrador#">	
	<cfreportparam name="LB_Direccion" value="#LB_Direccion#">	
	<cfreportparam name="LB_Apartado" value="#LB_Apartado#">
	<cfreportparam name="LB_Moneda" value="#LB_Moneda#">	
	<cfreportparam name="LB_Documento" value="#LB_Documento#">	
	<cfreportparam name="LB_Ref" value="#LB_Ref#">	
	<cfreportparam name="LB_Sucursal" value="#LB_Sucursal#">	
	<cfreportparam name="LB_NRecl" value="#LB_NRecl#">	
	<cfreportparam name="LB_Debitos" value="#LB_Debitos#">	
	<cfreportparam name="LB_Creditos" value="#LB_Creditos#">	
	<cfreportparam name="LB_Saldo" value="#LB_Saldo#">	
	<cfreportparam name="LB_AnaSaldo" value="#LB_AnaSaldo#">	
	<cfreportparam name="LB_VencSaldo" value="#LB_VencSaldo#">	
	<cfreportparam name="LB_Corriente" value="#LB_Corriente#">	
	<cfreportparam name="LB_SinVenc" value="#LB_SinVenc#">	
	<cfreportparam name="LB_De" value="#LB_De#">	
	<cfreportparam name="LB_omas" value="#LB_omas#">	
	<cfreportparam name="LB_Morosidad" value="#LB_Morosidad#">	
	<cfreportparam name="LB_Tipo" value="#LB_Tipo#">		
	<cfreportparam name="LB_Descripcion" value="#LB_Descripcion#">	
	<cfreportparam name="LB_Monto" value="#LB_Monto#">
	<cfreportparam name="MSG_Pie" value="#MSG_Pie#">
	
	<cfif isdefined("rsSNCEdescripcion") and rsSNCEdescripcion.recordcount eq 1>
		<cfreportparam name="SNCEdescripcion" value="#rsSNCEdescripcion.SNCEdescripcion#">
	</cfif> 
	<cfif isdefined("rsSNCDdescripcion1") and rsSNCDdescripcion1.recordcount eq 1>
		<cfreportparam name="SNCDdescripcion1" value="#rsSNCDdescripcion1.SNCDdescripcion#">
	</cfif>
	<cfif isdefined("rsSNCDdescripcion2") and rsSNCDdescripcion2.recordcount eq 1>
		<cfreportparam name="SNCDdescripcion2" value="#rsSNCDdescripcion2.SNCDdescripcion#">
	</cfif>
	<cfif isdefined("url.Cobrador") and len(trim(url.Cobrador)) eq 0>
		<cfset url.cobrador = 'Todos'>
	</cfif>
	<cfreportparam name="Cobrador" value="#url.Cobrador#">
	<cfif isdefined("rsSNnombre1") and rsSNnombre1.recordcount eq 1>
		<cfreportparam name="SNnombre" value="#rsSNnombre1.SNnombre#">
	</cfif>
	<cfif isdefined("rsSNnombre2") and rsSNnombre2.recordcount eq 1>
		<cfreportparam name="SNnombreb2" value="#rsSNnombre2.SNnombre#">
	</cfif>
	<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni))>
		<cfreportparam name="fechaDes" value="#LSDateFormat(url.fechaIni,"DD/MM/YYYY")#">
	</cfif>
	<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin))>
		<cfreportparam name="fechaHas" value="#LSDateFormat(url.fechaFin,"DD/MM/YYYY")#">
	</cfif>
	<cfif isdefined("rsSNCEdescripcion_orden") and rsSNCEdescripcion_orden.recordcount eq 1>
		<cfreportparam name="SNCEdescripcion_orden" value="#rsSNCEdescripcion_orden.SNCEdescripcion#">
	</cfif>
	<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
		<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
	</cfif>
	<cfif isdefined("P1")>
		<cfreportparam name="P1" value="#P1#">
	</cfif>		
	<cfif isdefined("P2")>
		<cfreportparam name="P2" value="#P2#">
	</cfif>		
	<cfif isdefined("P3")>
		<cfreportparam name="P3" value="#P3#">
	</cfif>
	<cfif isdefined("P4")>
		<cfreportparam name="P4" value="#P4#">
	</cfif>
    
     <cfif isdefined("LvarLeyendaCxC") and len(trim(LvarLeyendaCxC))>
			<cfreportparam name="LeyendaCxC" value="#LvarLeyendaCxC#">
		</cfif>
</cfreport>
</cfif>

<cffunction name="GetQueryString" returntype="string" output="no">
	<cfset var QueryString = "">
	<cfif UCase(CGI.REQUEST_METHOD) is 'POST' And IsDefined('form')>
		<!--- "form" no está definido cuando la invocación es hacia un Web Service --->
		<cfset keys = StructKeyArray(form)>
		<cfif ArrayLen(keys)>
			<cfset ArraySort(keys,'text')>
			<cfloop from="1" to="#ArrayLen(keys)#" index="ikey">
				<cfif IsSimpleValue(form[keys[ikey]]) And (ucase(keys[ikey]) neq 'FIELDNAMES')>
					<cfset QueryString = ListAppend(QueryString,
							keys[ikey] & "=" & URLEncodedFormat(form[keys[ikey]]), '&')>
				</cfif>
			</cfloop>
			<cfif Len(QueryString)>
				<cfreturn Mid(QueryString,1,255)>
			</cfif>
		</cfif>
	<cfelseif Len(CGI.QUERY_STRING)>
		<cfreturn CGI.QUERY_STRING>
	</cfif>
	<cfreturn ' '>
</cffunction>

<cffunction name="fnGeneraDatosInfoReporteAntiguedad" access="private" output="no" hint="Genera la información para los reportes de Antiguedad de Saldos">
	<cfset fechaInicial    = lsparsedatetime(url.fechaIni)>
	<cfset fechafinal      = createODBCdate(lsparsedatetime(url.fechaFin))>
	<cfset Lvarpa = fnObtenerPeriodosAntiguedad(fechafinal)>
	<cfset p1 = LvarAntiguedad1>
	<cfset p2 = LvarAntiguedad2>
	<cfset p3 = LvarAntiguedad3>
	<cfset p4 = LvarAntiguedad4>
	
	<!--- Inserto los socios que juegan en el proceso --->
	<cfif isdefined('url.SNnumero') and Len(trim(url.SNnumero)) and isdefined('url.SNnumerob2') and Len(trim(url.SNnumerob2)) and url.SNnumero eq url.SNnumerob2>
		<cfquery name="rsSocios" datasource="#session.DSN#">
			insert into #socios# (Ecodigo, SNcodigo, SNid, FechaIni, FechaFin, SNnumero, id_direccion, SNDcodigo, Mcodigo)
			select 
				s.Ecodigo, s.SNcodigo, s.SNid, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#"> as FechaIni, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#"> as FechaFin,
				s.SNnumero, 
				<cfif isdefined("chk_cod_Direccion")>
					snd.id_direccion, snd.SNDcodigo
				<cfelse>
					s.id_direccion, s.SNnumero
				</cfif>
				, s.Mcodigo
			from SNegocios s
				<cfif isdefined("chk_cod_Direccion")>
					inner join SNDirecciones snd
					on snd.SNid = s.SNid
				</cfif>
			
			where s.Ecodigo = #session.Ecodigo#
			  and s.SNnumero = '#url.SNnumero#'	
		</cfquery>
	<cfelse>
		<cfquery name="rsSocios" datasource="#session.DSN#">
			insert into #socios# (Ecodigo, SNcodigo, SNid, FechaIni, FechaFin, SNnumero, id_direccion, SNDcodigo, Mcodigo)
			select 
				s.Ecodigo, s.SNcodigo, s.SNid, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#"> as FechaIni, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#"> as FechaFin,
				s.SNnumero, 
				<cfif isdefined("chk_cod_Direccion")>
					snd.id_direccion, snd.SNDcodigo
				<cfelse>
					s.id_direccion, s.SNnumero
				</cfif>
				, s.Mcodigo
			from SNClasificacionD cd <!--- <cf_dbforceindex name="PCClasificacionD_02"> --->
				<cfif isdefined("chk_cod_Direccion")>
					inner join SNClasificacionSND cs
						on cs.SNCDid = cd.SNCDid
					inner join SNDirecciones snd
					   on cs.SNid = snd.SNid
					  and cs.id_direccion = snd.id_direccion
			
					<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
						  and snd.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
					</cfif>
				<cfelse>
					inner join SNClasificacionSN cs <!--- <cf_dbforceindex name="FKSNClasificacionSN_01"> --->
						on cs.SNCDid = cd.SNCDid
				</cfif>
							
					inner join SNegocios s <!--- <cf_dbforceindex name="AK_KEY_ID_SNEGOCIO"> --->
							on s.SNid = cs.SNid
							and s.Ecodigo = #session.Ecodigo#
			
					<cfif not isdefined('chk_cod_Direccion')>
							<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
								and s.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
							</cfif>
					</cfif>
			
					<cfif isdefined('url.SNnumero') and Len(trim(url.SNnumero)) and not isdefined('url.SNnumerob2')>
							and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
					</cfif>
			
					<cfif isdefined('url.SNnumerob2') and Len(trim(url.SNnumerob2)) and not isdefined('url.SNnumero')>
							and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumerob2#">
					</cfif>
			

					<cfif isdefined('url.SNnumero') and Len(trim(url.SNnumero)) and isdefined('url.SNnumerob2') and Len(trim(url.SNnumerob2))>
							<cfif url.SNnumero LTE url.SNnumerob2>
								   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
								   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumerob2#">
							<cfelse>
								   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
								   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumerob2#">
							</cfif>
					</cfif>
			where cd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">  
			  and (cd.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#"> 
				  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">)     <!--- Parametros de Valores de Clasificacion --->
			<cfif not isdefined('url.SaldoCero')>
			  and (
					 exists(
							select 1 
							from HDocumentos do 
							where do.SNcodigo = s.SNcodigo
							  and do.Ecodigo  = s.Ecodigo 
							  and do.Dfecha between 
									<cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#"> 
								and <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
								<cfif isdefined("chk_cod_Direccion")>
									and do.id_direccionFact = snd.id_direccion
								</cfif>
							 )
					or exists(
							select 1 
							from BMovimientos bm
								inner join HDocumentos do
									on do.Ecodigo = bm.Ecodigo
									and do.CCTcodigo = bm.CCTRcodigo
									and do.Ddocumento = bm.DRdocumento
							where bm.SNcodigo = s.SNcodigo
							  and bm.Ecodigo  = s.Ecodigo 
							  and bm.Dfecha between 
									<cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#"> 
								and <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
								<cfif isdefined("chk_cod_Direccion")>
									and do.id_direccionFact = snd.id_direccion
								</cfif>
							 )
				)
			</cfif>
		</cfquery>
	</cfif>
	
	<cfquery name="rsInsert2" datasource="#session.DSN#">
		insert into #documentos# (
			Ecodigo, SNid, Socio,  IDdireccion, Documento, TTransaccion,  CCTtipo, Moneda,
			FechaVencimiento, Fecha, Total, SaldoInicial, SaldoFinal)
		select 
			d.Ecodigo, so.SNid, d.SNcodigo, 
			<cfif isdefined("url.chk_cod_Direccion")>
			coalesce(d.id_direccionFact, so.id_direccion),  
			<cfelse>
			so.id_direccion,
			</cfif>
			d.Ddocumento, d.CCTcodigo, t.CCTtipo, d.Mcodigo,
			d.Dvencimiento, d.Dfecha, d.Dtotal as Total, 0.00 as SaldoInicial, 0.00 as SaldoFinal
		from #socios# so
			inner join HDocumentos d
						inner join CCTransacciones t
							on t.Ecodigo = d.Ecodigo
							and t.CCTcodigo = d.CCTcodigo
			on d.Ecodigo = so.Ecodigo
			and d.SNcodigo = so.SNcodigo
			<cfif isdefined("url.chk_cod_Direccion")>
			  and d.id_direccionFact = so.id_direccion
			</cfif>
		where d.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
	</cfquery> 
	
	<!--- 	
		Actualizar el saldo de todos los documentos a la fecha de inicio del análisis.
		Documentos tipo "Debito", se hace el join por las columnas DRdocumento, CCTRcodigo y Ecodigo
	--->
	<cfset LvarDiferenciaIniB = GetTickCount()>
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">		
		update #documentos#
		set SaldoInicial = Total - 
			coalesce((
				select sum(Dtotalref)
				from BMovimientos bm
				where bm.Ecodigo = #documentos#.Ecodigo
				  and bm.CCTRcodigo = #documentos#.TTransaccion
				  and bm.DRdocumento = #documentos#.Documento
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">
				  and bm.CCTcodigo <> bm.CCTRcodigo 
			) , 0.00)
		where #documentos#.CCTtipo = 'D'
		  and #documentos#.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">
	</cfquery>
		
	<!---
		Documentos tipo "Credito", se hace el join por las columnas Ecodigo, CCTcodigo, DDocumento
		Las aplicaciones de los documentos de credito se hacen a documentos de debito - de ahí el join con CCTransacciones t
	--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoInicial = Total - coalesce((
			select sum(Dtotalref)
			from BMovimientos bm
				inner join CCTransacciones t
				on t.Ecodigo = bm.Ecodigo
				and t.CCTcodigo = bm.CCTRcodigo
				and t.CCTtranneteo = 0
				and t.CCTtipo = 'D' 
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CCTcodigo = #documentos#.TTransaccion
			  and bm.Ddocumento = #documentos#.Documento
			  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">
			  and bm.CCTcodigo <> bm.CCTRcodigo 
			) , 0.00)
		where #documentos#.CCTtipo = 'C'
		  and #documentos#.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">
	</cfquery>
	
	<!---	NETEO
		Documentos tipo "Credito", cuando se usan como parte de un proceso de neteo, se genera el registro en BMovimientos
		en los campos CCTRcodigo y DRdocumento.
		El registro queda como esto:   NT  {documento}  NC {documento credito}
		SOLO aplica para transacciones de Credito involucradas en Neteos.  
	--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">	
		update #documentos#
		set SaldoInicial = SaldoInicial - coalesce((
			select sum(Dtotalref)
			from BMovimientos bm
				inner join CCTransacciones tt
					 on tt.Ecodigo   = bm.Ecodigo
					and tt.CCTcodigo = bm.CCTcodigo
					and tt.CCTtranneteo = 1
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CCTRcodigo = #documentos#.TTransaccion
			  and bm.DRdocumento = #documentos#.Documento
			  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">
			  and bm.CCTcodigo <> bm.CCTRcodigo 
			) , 0.00)
		where #documentos#.CCTtipo = 'C'
		  and #documentos#.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">
	</cfquery>
	
	<!--- 
		Eliminar los docmentos que tienen saldo inicial en cero con fecha anterior a Fecha Desde del reporte.  
		No se requiere procesarlos en el siguiente ciclo 
	--->
	<cfquery datasource="#session.DSN#">
		delete from #documentos#	
		where SaldoInicial = 0
		  and Fecha <  <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">
	</cfquery>
	
	<!--- 
		Actualizar el saldo de los documentos a la fecha de final del análisis. 
	--->		
	<cfquery datasource="#session.DSN#">
		update #documentos#	
		set SaldoFinal = Total - coalesce((
			select sum(Dtotalref)
			from BMovimientos bm
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CCTRcodigo = #documentos#.TTransaccion
			  and bm.DRdocumento = #documentos#.Documento
			  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
			  and bm.CCTcodigo <> bm.CCTRcodigo 
			) , 0.00)
		where CCTtipo = 'D'
		  and Fecha <=  <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
	</cfquery>
		
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoFinal = Total - coalesce((
			select sum(Dtotalref)
			from BMovimientos bm
				inner join CCTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CCTcodigo = bm.CCTRcodigo
						and t.CCTtranneteo = 0
						and t.CCTtipo = 'D'
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CCTcodigo = #documentos#.TTransaccion
			  and bm.Ddocumento = #documentos#.Documento
			  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
			  and bm.CCTcodigo <> bm.CCTRcodigo 
			) , 0.00)
		where CCTtipo = 'C'
		  and Fecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
	</cfquery>
	
	<!---
		Actualizar los neteos de documentos tipo credito que se graban al revés en BMovimientos
	--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoFinal = SaldoFinal - coalesce((
			select sum(Dtotalref)
			from BMovimientos bm
				inner join CCTransacciones tt
					on tt.Ecodigo = bm.Ecodigo
					and tt.CCTcodigo = bm.CCTcodigo
					and tt.CCTtranneteo = 1
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CCTRcodigo = #documentos#.TTransaccion
			  and bm.DRdocumento = #documentos#.Documento
			  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
			  and bm.CCTcodigo <> bm.CCTRcodigo 
			) , 0.00)
		where #documentos#.CCTtipo = 'C'
		  and #documentos#.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
	</cfquery>
	
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoInicial = -SaldoInicial, SaldoFinal = -SaldoFinal
		where CCTtipo = 'C'
	</cfquery>
	
	<cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mcodigo 
		from Empresas 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfset LvarMcodigoEmpresa = rsMonedas.Mcodigo>
	
	<!--- 
		Insertar registros de saldo inicial por cada socio y moneda posible a utilizar 
	--->
	
	<cfquery name="rsInsertSaldosIni" datasource="#session.DSN#">
		insert into #SaldosIniciales#(
			Ecodigo, Mcodigo, SNid, id_direccion,
			SfechaIni,
			SfechaFin,
			SIsI,SIsaldoFinal,
			SIsinvencer,SIcorriente,
			SIp1, SIp2, SIp3, SIp4, SIp5, SIp5p)
		select
			s.Ecodigo, d.Moneda, s.SNid, s.id_direccion,
			<cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicial#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">,
			sum(d.SaldoInicial), sum(d.SaldoFinal), 
			0.00, 0.00, 
			0.00, 0.00, 0.00, 0.00, 0.00, 0.00
		from #socios# s
			inner join #documentos# d
			on  d.SNid = s.SNid
			and d.Socio = s.SNcodigo
			and d.IDdireccion = s.id_direccion
		group by s.Ecodigo, d.Moneda, s.SNid, s.id_direccion
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set 
			SIcorriente = 
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid 				 = #SaldosIniciales#.SNid
					  and d.IDdireccion 		 = #SaldosIniciales#.id_direccion
					  and d.Moneda 				 = #SaldosIniciales#.Mcodigo
					  and d.Fecha 				<= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
					  and d.FechaVencimiento 	>= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
					  and <cf_dbfunction name="date_part"   args="MM,d.Fecha"> =<cf_dbfunction name="date_part"  args="MM,#fechafinal#"> 
				), 0.00),
				
			SIsinvencer = 
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid            = #SaldosIniciales#.SNid
					  and d.IDdireccion    = #SaldosIniciales#.id_direccion
					  and d.Moneda      	= #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
					  and <cf_dbfunction name="date_part"   args="MM,d.Fecha"> <> <cf_dbfunction name="date_part"  args="MM,#fechafinal#"> 
				), 0.00),
				
				SIp1 = 
					coalesce((
						select sum(d.SaldoFinal)
						from #documentos# d
						where d.SNid             = #SaldosIniciales#.SNid
						  and d.IDdireccion     = #SaldosIniciales#.id_direccion
						  and d.Moneda      	 = #SaldosIniciales#.Mcodigo
						  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #fechafinal#"> between 1 and #p1#
					), 0.00),
	
				SIp2 = 
					coalesce((
						select sum(d.SaldoFinal)
						from #documentos# d
						where d.SNid = #SaldosIniciales#.SNid
						  and d.IDdireccion = #SaldosIniciales#.id_direccion
						  and d.Moneda = #SaldosIniciales#.Mcodigo
						  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #fechafinal#"> between #p1+1# and #p2#
					), 0.00),
	
				SIp3 = 
					coalesce((
						select sum(d.SaldoFinal)
						from #documentos# d
						where d.SNid             = #SaldosIniciales#.SNid
						  and d.IDdireccion     = #SaldosIniciales#.id_direccion
						  and d.Moneda      	= #SaldosIniciales#.Mcodigo
						  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #fechafinal#"> between #p2+1# and #p3#
					), 0.00),
	
				SIp4 = 
					coalesce((
						select sum(d.SaldoFinal)
						from #documentos# d
						where d.SNid             = #SaldosIniciales#.SNid
						  and d.IDdireccion     = #SaldosIniciales#.id_direccion
						  and d.Moneda      	= #SaldosIniciales#.Mcodigo
						  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #fechafinal#"> between #p3+1# and #p4#
					), 0.00),
	
				SIp5 = 
					coalesce((
						select sum(d.SaldoFinal)
						from #documentos# d
						where d.SNid             = #SaldosIniciales#.SNid
						  and d.IDdireccion     = #SaldosIniciales#.id_direccion
						  and d.Moneda      	= #SaldosIniciales#.Mcodigo
						  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #fechafinal#"> between #p4+1# and 151 
					), 0.00),
	
				SIp5p = 
					coalesce((
						select sum(d.SaldoFinal)
						from #documentos# d
						where d.SNid             = #SaldosIniciales#.SNid
						  and d.IDdireccion     = #SaldosIniciales#.id_direccion
						  and d.Moneda      	= #SaldosIniciales#.Mcodigo
						  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechafinal#">
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #fechafinal#"> > 151 
					), 0.00)
	</cfquery>
</cffunction>

<cffunction name="fnProcesaSalidaEstadoCuenta" access="private" output="yes">
	<cfset fechainicio     = LSDateFormat(url.fechaIni)>
	<cfset fechafinal      = LSDateFormat(url.fechaFin)>	
	<cfset fechafinal      = dateadd('s', -1, dateadd('d', 1, fechafinal))>
	<cfset periodo         = datepart('yyyy', fechainicio)>
	<cfset mes             = datepart('m', fechainicio)>
	<cfset FechaInicioMes  = createdate(periodo, mes, 1)>
	<cfset DEidCobrador = -1>
    
	<cfset periodosig      = periodo>
	<cfset messig          = mes + 1>
	<cfif messig GT 12>
		<cfset messig = 1>
		<cfset periodosig = periodo +1>
	</cfif>

	<cfset fnObtenerTransaccionesNeteo()>


    <cfset Lvarpa = fnObtenerPeriodosAntiguedad(fechafinal)>
	<cfset p1 = LvarAntiguedad1>
	<cfset p2 = LvarAntiguedad2>
	<cfset p3 = LvarAntiguedad3>
	<cfset p4 = LvarAntiguedad4>

	
	<cfset movimientos = CreaTemp2()>
	<cfset documentos  = CreaTemp3()>
	<cfset SaldosIniciales = CreaTemp4()>
	<cfif not isdefined("chk_cod_Direccion")>
    	<cfset chk_cod_Direccion = -1>		
	</cfif>
	<cfset fnSeleccionarSocios(SNnumero, SNnumerob2, chk_cod_Direccion, DEidCobrador, SNCEid, SNCDvalor1, SNCDvalor2)>

	<!--- 
		Proceso:
			1. Saldos Iniciales del Socio y Direccion
			2. Incluir Documentos construidos entre las fechas del Estado de Cuenta
			3. Recibos de Dinero ( Cobros o Pagos de Socios )
			4. Notas de Credito del socio aplicadas a documentos de otros socios
			5. Notas de Credito de Otros socios aplicadas a documentos del socio en proceso
			6. Documentos Aplicados en Proceso de Neteo de Documentos ( contra CxP y CxC )
			7. Pagos hechos en Tesorería sobre documentos del socio
			8. Si es por Direccion, incluir las notas de credito de una direccion aplicadas a otra direccion
	--->
	<cfloop query="rsSocios">
		<cfset fnSaldosInicialesFechas (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion, FechaInicioMes)>
		<cfset fnIncluirDocumentos (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion)>
		<cfset fnIncluirRecibos (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion)>
		<cfset fnIncluirNCaOtrosSocios (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion)>
		<cfset fnIncluirNCdeOtrosSocios (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion)>
		<cfif len(trim(LvarTransNeteo)) GT 0>
			<cfset fnIncluirNeteos (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion)>
		</cfif>
		<cfset fnIncluirPagosTes (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion)>
		<cfif chk_cod_Direccion neq -1>
			<cfset fnIncluirNCdireccion (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, chk_cod_Direccion)>
		</cfif>
	</cfloop>

	<cfquery datasource="#session.DSN#">
		update #movimientos#
			set 
				Oficodigo  = coalesce((select o.Oficodigo from Oficinas o where o.Ecodigo = #movimientos#.Ecodigo and o.Ocodigo = #movimientos#.Ocodigo ), '  '),
				OrdenCompra = coalesce(OrdenCompra, ' '), 
				Reclamo = coalesce(Reclamo, ' ')
		where Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaIni)#">
	</cfquery>
	
	<cfif chk_cod_Direccion NEQ -1>
		<!--- Subreporte --->
		<cfset LvarDiferenciaIniB = GetTickCount()>
		<cfquery name="request.rsReporte2" datasource="#session.DSN#">
			select 
				m.IDdireccion as id_direccion,	
				m.Moneda as Moneda,
				mo.Mnombre,
				TRgroup as tipo,
				t.CCTdescripcion as CCTdescripcion,
				sum(m.Total) as Total
			from #movimientos# m
				inner join Monedas mo
					on mo.Ecodigo = m.Ecodigo
					and mo.Mcodigo = m.Moneda
				inner join CCTransacciones t
					on t.CCTcodigo = m.TTransaccion
					and t.Ecodigo = m.Ecodigo
					
			where m.TTransaccion is not null
			  and m.TTransaccion <> ' '
			  and m.Fecha between 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaIni)#"> 
				and
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaFin)#">
			group by 
				m.IDdireccion,	
				m.Moneda,
				mo.Mnombre,
				TRgroup,
				t.CCTdescripcion
	
			order by 
				m.IDdireccion,
				m.Moneda,
				TRgroup
		</cfquery>
		
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select 
				m.Ordenamiento as Ordenamiento, 
				sn.SNnumero as Socio,
				m.IDdireccion as IDdireccion,
				m.IDdireccion as id_direccion,
				mo.Mnombre as Mnombre, 
				m.Moneda as moneda,
				TRgroup as tipo,
				m.Documento as documento,
				m.Fecha as Fecha,
				m.FechaVencimiento as FechaVencimiento,
				m.OrdenCompra as DEordenCompra,
				m.Control,
				m.Reclamo as DEnumReclamo,
				m.Oficodigo as Oficodigo,
				case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaIni)#"> and Total >= 0 then Total else 0.00 end as Debitos,
				case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaIni)#">  and Total < 0 then -Total else 0.00 end as Creditos,
		
				m.Total as Total,  
		
				coalesce(si.SIsI, 0.00) as Saldo,
		
				coalesce(si.SIsinvencer, 0.00) as SinVencer, 
				coalesce(si.SIcorriente, 0.00) as Corriente,  
				coalesce(si.SIp1, 0.00) as P1,
				coalesce(si.SIp2, 0.00) as P2,
				coalesce(si.SIp3, 0.00) as P3,
				coalesce(si.SIp4, 0.00) as P4,
				coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus,
				coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad,
				
				case when ltrim(rtrim(snd.SNDcodigo)) = '' or snd.SNDcodigo is null then sn.SNnumero else snd.SNDcodigo end as SNnumero,
				sn.SNidentificacion as SNidentificacion,
				sn.SNmontoLimiteCC as SNmontoLimiteCC,
				sn.SNtelefono as SNtelefono,
				sn.SNemail as SNemail,
				case when ltrim(rtrim(snd.SNnombre)) = '' or snd.SNnombre is null then sn.SNnombre else snd.SNnombre end as SNnombre,
				di.direccion1 as direccion1,
				di.direccion2 as direccion2,
				di.codPostal as codPostal,
				coalesce(( 
						select 
							min(
								<cf_dbfunction name="concat" args="de.DEnombre +' '+ de.DEapellido1+' '+ de.DEapellido2" delimiters="+">
								)
						from SNDirecciones snd
						inner join DatosEmpleado de
						   on snd.DEidCobrador = de.DEid
						where snd.id_direccion = m.IDdireccion)
						,'No ha sido asignado')
						as Cobrador
			from #movimientos# m
			
				inner join SNegocios sn
					on sn.SNid = m.SNid
					
				inner join SNDirecciones snd
				   on snd.SNid = sn.SNid
				  and snd.id_direccion = m.IDdireccion
		
				inner join DireccionesSIF di
					on di.id_direccion = snd.id_direccion
				  
				inner join Monedas mo
					on mo.Mcodigo = m.Moneda
					
				inner join #SaldosIniciales# si
					 on si.SNid = m.SNid
					 and si.Mcodigo = m.Moneda
					 and si.id_direccion = m.IDdireccion
					 and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaIni)#">
					 and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaFin)#">
			order by 
				m.IDdireccion,
				sn.SNnombre, 
				sn.SNnumero, 
				m.Ordenamiento,
				m.Moneda,
				m.Control,				 
				<cfif isdefined("url.ordenado")>
				m.Reclamo,
				</cfif> 
				m.Fecha, 
				m.TTransaccion, 
				m.Documento	
		
		</cfquery>
	<cfelse>
		<!--- Subreporte --->
		<cfset LvarDiferenciaIniB = GetTickCount()>
		<cfquery name="request.rsReporte2" datasource="#session.DSN#">
			select 
				s.id_direccion,	
				m.Moneda as Moneda,
				mo.Mnombre,
				TRgroup as tipo,
				t.CCTdescripcion as CCTdescripcion,
				sum(m.Total) as Total
			from #movimientos# m
				inner join Monedas mo
					on mo.Ecodigo = m.Ecodigo
					and mo.Mcodigo = m.Moneda
				inner join SNegocios s
					on s.Ecodigo = m.Ecodigo
					and s.SNcodigo = m.Socio
				inner join CCTransacciones t
					on t.CCTcodigo = m.TTransaccion
					and t.Ecodigo = m.Ecodigo
			where m.TTransaccion is not null
			  and m.TTransaccion <> ' '
			  and m.Fecha between 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaIni)#"> 
				and
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaFin)#">
			group by 
				s.id_direccion,	
				m.Moneda,
				mo.Mnombre,
				TRgroup,
				t.CCTdescripcion
	
			order by 
				s.id_direccion,
				m.Moneda,
				TRgroup
		</cfquery>
		<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5501">
			select 
				  m.Ordenamiento as Ordenamiento 
				, m.SNnumero as Socio
				, sn.id_direccion as IDdireccion
				, sn.id_direccion as id_direccion
				, mo.Mnombre as Mnombre
				, m.Moneda as moneda
				, TRgroup as tipo
				, m.Documento as documento
				, m.Fecha as Fecha
				, m.FechaVencimiento as FechaVencimiento
				, m.OrdenCompra as DEordenCompra
				, m.Control
				, m.Reclamo as DEnumReclamo
				, m.Oficodigo as Oficodigo
				, case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaIni)#">  and Total >= 0 then Total else 0.00 end as Debitos
				, case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaIni)#">  and Total < 0 then -Total else 0.00 end as Creditos
				, m.Total as Total
	
				, coalesce(si.SIsI, 0.00) as Saldo
	
				, coalesce(si.SIsinvencer, 0.00) as SinVencer 
				, coalesce(si.SIcorriente, 0.00) as Corriente  
				, coalesce(si.SIp1, 0.00) as P1
				, coalesce(si.SIp2, 0.00) as P2
				, coalesce(si.SIp3, 0.00) as P3
				, coalesce(si.SIp4, 0.00) as P4
				, coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus
				, coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad
									
				, sn.SNnumero as SNnumero
				,  sn.SNidentificacion as SNidentificacion
				,  sn.SNmontoLimiteCC as SNmontoLimiteCC
				,  sn.SNtelefono as SNtelefono
				,  sn.SNemail as SNemail
				,  sn.SNnombre as SNnombre
				,  di.direccion1 as direccion1
				,  di.direccion2 as direccion2
				,  di.codPostal as codPostal
				,  coalesce(( 
					select 
						min(
							<cf_dbfunction name="concat" args="de.DEnombre +' '+ de.DEapellido1+' '+ de.DEapellido2" delimiters="+">
							)
					from DatosEmpleado de
					where de.DEid = sn.DEidCobrador), ' No ha sido Asignado') as Cobrador
	
			from #movimientos# m
				inner join SNegocios sn
					on sn.SNid = m.SNid
				inner join DireccionesSIF di
					on di.id_direccion = sn.id_direccion
				inner join Monedas mo
					on mo.Mcodigo = m.Moneda
					and mo.Ecodigo = m.Ecodigo
	
				inner join #SaldosIniciales# si
					 on si.SNid = m.SNid
					 and si.Mcodigo = m.Moneda
	
			order by 
				sn.SNnombre,
				sn.SNnumero, 
				m.Ordenamiento,
				sn.id_direccion,
				m.Moneda,
				
				m.Control,
				<cfif isdefined("url.ordenado")>
				m.Reclamo,
				</cfif> 
				m.Fecha, 
				m.TTransaccion, 
				m.Documento	
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnProcesaSalidaAntiguedadSaldos" access="private" output="no">
	<!--- Antiguedad de Saldos por Cliente --->
	<cfquery name="rsReporte" datasource="#Session.DSN#" maxrows="20001">
		select ' ' as Ordenamiento, 
			SNCEcodigo,
			SNCEdescripcion,
			SNCDvalor,
			SNCDdescripcion,
			mo.Miso4217 as CodigoMoneda, 
			mo.Mnombre as Mnombre, 
			mo.Mcodigo as moneda,

			<cfif isdefined("url.chk_cod_Direccion")>
				coalesce(snd.SNDcodigo,sn.SNnumero) as SNnumero, 
				coalesce(snd.SNnombre,sn.SNnombre) as SNnombre,
			<cfelse>
				sn.SNnumero as SNnumero, 
				sn.SNnombre as SNnombre,
			</cfif>				
			sum(coalesce(si.SIsaldoFinal, 0.00)) as Saldo,
			sum(coalesce(si.SIsinvencer, 0.00)) as SinVencer, 
			sum(coalesce(si.SIcorriente, 0.00)) as Corriente, 
			sum(coalesce(si.SIp1, 0.00)) as P1,
			sum(coalesce(si.SIp2, 0.00)) as P2,
			sum(coalesce(si.SIp3, 0.00)) as P3,
			sum(coalesce(si.SIp4, 0.00)) as P4,
			sum(coalesce(si.SIp5 + si.SIp5p, 0.00)) as P5Plus,
			sum(coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00)) as Morosidad
		from #SaldosIniciales# si
			inner join SNegocios sn
					on sn.SNid = si.SNid

			<cfif isdefined("url.chk_cod_Direccion")>
				inner join SNDirecciones snd
					on snd.SNid = si.SNid
					and snd.id_direccion = si.id_direccion
				inner join SNClasificacionSND cl
					on cl.SNid = snd.SNid
					and cl.id_direccion = snd.id_direccion
			<cfelse>
				inner join SNClasificacionSN cl
					on cl.SNid = si.SNid
			</cfif>

				inner join SNClasificacionD cld
					on cld.SNCDid = cl.SNCDid

				inner join SNClasificacionE cle
					on cle.SNCEid = cld.SNCEid
					and cle.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">

				inner join Monedas mo 
					 on mo.Mcodigo = si.Mcodigo
					and mo.Ecodigo = si.Ecodigo 
			
		group by
			mo.Miso4217, 
			mo.Mnombre, 
			mo.Mcodigo,
			SNCEcodigo,
			SNCEdescripcion,
			SNCDvalor,
			SNCDdescripcion,
			<cfif isdefined("url.chk_cod_Direccion")>
				coalesce(snd.SNDcodigo,sn.SNnumero), 
				coalesce(snd.SNnombre,sn.SNnombre)
			<cfelse>
				sn.SNnumero, 
				sn.SNnombre
			</cfif>				
		order by 
			mo.Miso4217, 
			mo.Mnombre, 
			SNCEcodigo,
			SNCEdescripcion,
			SNCDvalor,
			SNCDdescripcion
	</cfquery>
</cffunction>

<cffunction name="fnProcesaSalidaAntiguedadSaldosR" access="private" output="no">
	<!--- Antiguedad de Saldos Resumido por Clasificacion --->
	<cfquery name="rsReporte" datasource="#Session.DSN#" maxrows="20001">
		select ' ' as Ordenamiento, 
			SNCEcodigo,
			SNCEdescripcion,
			SNCDvalor,
			SNCDdescripcion,
			mo.Miso4217 as CodigoMoneda, 
			mo.Mnombre as Mnombre, 
			mo.Mcodigo as moneda,
			
			sum(coalesce(si.SIsaldoFinal, 0.00)) as Saldo,
			sum(coalesce(si.SIsinvencer, 0.00)) as SinVencer, 
			sum(coalesce(si.SIcorriente, 0.00)) as Corriente, 
			sum(coalesce(si.SIp1, 0.00)) as P1,
			sum(coalesce(si.SIp2, 0.00)) as P2,
			sum(coalesce(si.SIp3, 0.00)) as P3,
			sum(coalesce(si.SIp4, 0.00)) as P4,
			sum(coalesce(si.SIp5 + si.SIp5p, 0.00)) as P5Plus,
			sum(coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00)) as Morosidad

		from #SaldosIniciales# si
			inner join SNegocios sn
					on sn.SNid = si.SNid
			<cfif isdefined("url.chk_cod_Direccion")>
				inner join SNDirecciones snd
					on snd.SNid = si.SNid
					and snd.id_direccion = si.id_direccion
				inner join SNClasificacionSND cl
					on cl.SNid = snd.SNid
					and cl.id_direccion = snd.id_direccion
			<cfelse>
				inner join SNClasificacionSN cl
					on cl.SNid = si.SNid
			</cfif>
				inner join SNClasificacionD cld
					on cld.SNCDid = cl.SNCDid

				inner join SNClasificacionE cle
					on cle.SNCEid = cld.SNCEid
					and cle.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">

				inner join Monedas mo 
					 on mo.Mcodigo = si.Mcodigo
					and mo.Ecodigo = si.Ecodigo 
		group by
			mo.Miso4217, 
			mo.Mcodigo,
			mo.Mnombre, 
			SNCEcodigo,
			SNCEdescripcion,
			SNCDvalor,
			SNCDdescripcion
		order by 
			mo.Miso4217, 
			mo.Mnombre, 
			mo.Mcodigo,
			SNCEcodigo,
			SNCEdescripcion,
			SNCDvalor,
			SNCDdescripcion
	</cfquery>
</cffunction>


