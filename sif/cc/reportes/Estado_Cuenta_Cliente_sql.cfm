<cfinclude template="Estado_Cuenta_funciones.cfm">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_NoHaSidoAsig 	= t.Translate('LB_NoHaSidoAsig','No ha sido Asignado')>

<cffunction name="Generar" output="no" access="private">
	<cfset fechafinal      = dateadd('s', -1, dateadd('d', 1, fechafinal))>
	<cfset periodo         = datepart('yyyy', fechainicio)>
	<cfset mes             = datepart('m', fechainicio)>
	<cfset FechaInicioMes  = createdate(periodo, mes, 1)>
	<cfset periodosig      = periodo>
	<cfset messig          = mes + 1>

	<cfif messig GT 12>
		<cfset messig = 1>
		<cfset periodosig = periodo +1>
	</cfif>

	<cfset fnObtenerTransaccionesNeteo()>

	<cfset fnObtenerPeriodosAntiguedad(fechafinal)>

	<cfset movimientos = CreaTemp2()>
	<cfset documentos  = CreaTemp3()>
	<cfset LvarSaldosIniciales = CreaTemp4()>

	<cfset fnSeleccionar1Socios(SNnumero, SNnumerob2, chk_cod_Direccion, DEidCobrador, SNCEid, SNCDvalor1, SNCDvalor2)>

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
	<cfset fnImprimirEstadoCuenta()>
</cffunction>

<cffunction name="fnImprimirEstadoCuenta" access="public" output="yes" hint="Imprimir el Estado de Cuenta del Socio">
	<cfquery datasource="#session.DSN#">
		update #movimientos#
			set
				Oficodigo  = coalesce((select o.Oficodigo from Oficinas o where o.Ecodigo = #movimientos#.Ecodigo and o.Ocodigo = #movimientos#.Ocodigo ), '  '),
				OrdenCompra = coalesce(OrdenCompra, ' '),
				Reclamo = coalesce(Reclamo, ' ')
	</cfquery>

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
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaInicio#">
			and
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaFinal#">
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

	<cfquery name="rsReporte" datasource="#session.dsn#">
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
			, case when Total >= 0 then Total else 0.00 end as Debitos
			, case when Total < 0 then -Total else 0.00 end as Creditos
			, m.Total as Total
            , sii.SIsI as Saldo
			, sii.SIsinvencer as SinVencer
			, sii.SIcorriente as Corriente
			, sii.SIp1 as P1
			, sii.SIp2 as P2
			, sii.SIp3 as P3
			, sii.SIp4 as P4
			, sii.SIp5 + sii.SIp5p as P5Plus
			, sii.SIp1 + sii.SIp2 + sii.SIp3 + sii.SIp4 + sii.SIp5 + sii.SIp5p as Morosidad

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
				where de.DEid = sn.DEidCobrador), ' #LB_NoHaSidoAsig#') as Cobrador

		from #movimientos# m
			inner join SNegocios sn
            	inner join DireccionesSIF di
				on di.id_direccion = sn.id_direccion
			on sn.SNid = m.SNid
			inner join Monedas mo
				 on mo.Mcodigo = m.Moneda
				and mo.Ecodigo = m.Ecodigo
			inner join #SaldosIniciales# sii
				on sii.SNid = m.SNid
                and sii.Mcodigo = m.Moneda
				<cfif chk_cod_Direccion NEQ -1>
					and sii.id_direccion = sn.id_direccion
				</cfif>
		order by
			sn.SNnombre,
			sn.SNnumero,
			m.Ordenamiento,
			sn.id_direccion,
			m.Moneda,

			m.Control,
			<cfif isdefined("ordenado")>
				m.Reclamo,
			</cfif>
			m.Fecha,
			m.TTransaccion,
			m.Documento
	</cfquery>

	<!--- Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif not isdefined('LvarEstadoCuentaCliente')>
	<cfquery name="rsSNCEdescripcion" datasource="#session.DSN#">
		select SNCEdescripcion
			from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNCEid#">
	</cfquery>
	</cfif>
	<cfif not isdefined('LvarEstadoCuentaCliente')>
	<cfquery name="rsSNCDdescripcion1" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNCDid1#">
	</cfquery>
	<cfquery name="rsSNCDdescripcion2" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNCDid2#">
	</cfquery>
	</cfif>
	<cfquery name="rsSNnombre1" datasource="#session.DSN#">
		select SNnombre
			from  SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsSNnombre2" datasource="#session.DSN#">
		select SNnombre
			from  SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigob2#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif not isdefined('LvarEstadoCuentaCliente')>
	<cfquery name="rsSNCEdescripcion_orden" datasource="#session.DSN#">
		select SNCEdescripcion
			from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNCEid_orden#">
	</cfquery>
	</cfif>

	<cfif isdefined("Formato") and len(trim(Formato)) and Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("Formato") and len(trim(Formato)) and Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>

    <cfset nombreReporteJR = "">
	<cfif isdefined("chk_cod_Direccion")>
		<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasFxid_direccion.cfr">
		<cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasFxid_direccion">
	<cfelse>
		<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasF.cfr">
		<cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasF">
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

<cfset TIT_EdoCta 	= t.Translate('TIT_EdoCta','Estado de Cuenta  del')>
<cfset LB_Hasta 	= t.Translate('LB_al','al')>
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset MSG_Codigo 	= t.Translate('MSG_Codigo','Código','/sif/generales.xml')>
<cfset LB_LimCred	= t.Translate('LB_LimCred','Límite Crédito')>
<cfset LB_EdoCta	= t.Translate('LB_EdoCta','Estado de Cuenta por Dirección')>
<cfset LB_Telefono 	= t.Translate('LB_Telefono','Teléfono','/sif/generales.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Dirección:','/sif/generales.xml')>
<cfset LB_Cobrador 	= t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_Apartado 	= t.Translate('LB_Apartado','Apartado')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Ref = t.Translate('LB_Ref','Ref.')>
<cfset LB_FecVenc = t.Translate('LB_FecVenc','Fecha Venc.')>
<cfset LB_Sucursal = t.Translate('LB_Sucursal','Sucursal')>
<cfset LB_OC = t.Translate('LB_OC','O/C')>
<cfset LB_NRecl = t.Translate('LB_NRecl','N° Reclamo')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Debitos = t.Translate('LB_Debitos','Débitos')>
<cfset LB_Creditos = t.Translate('LB_Creditos','Créditos')>
<cfset LB_AnaSaldo = t.Translate('LB_AnaSaldo','Análisis de Saldo')>
<cfset LB_VencSaldo = t.Translate('LB_VencSaldo','Vencimiento de Saldo')>
<cfset LB_Corriente = t.Translate('LB_Corriente','Corriente')>
<cfset LB_SinVenc = t.Translate('LB_SinVenc','Sin Vencer')>
<cfset LB_De = t.Translate('LB_De','De')>
<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad')>
<cfset MSG_Pie = t.Translate('MSG_Pie','Hemos recibido las facturas originales de ordenes de compras correspondientes a este estado de cuenta y aceptamos como correcto y definitivo el saldo que refleja este estado de cuenta.')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset Descripcion = t.Translate('Descripcion','Descripción','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_omas = t.Translate('LB_omas','o mas')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and formatos EQ "excel">
	  <cfset typeRep = 1>
	 
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.#nombreReporteJR#"/>
<cfelse>
<cfreport format="#formatos#" template="#LvarReporte#" query="#rsReporte#">
        <cfreportparam name="TIT_EdoCta" 	value="#TIT_EdoCta#">
        <cfreportparam name="LB_Hasta" 		value="#LB_Hasta#">
        <cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
        <cfreportparam name="LB_Hora" 		value="#LB_Hora#">
        <cfreportparam name="MSG_Codigo" 	value="#MSG_Codigo#">
        <cfreportparam name="LB_LimCred" 	value="#LB_LimCred#">
        <cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
        <cfreportparam name="LB_EdoCta" 	value="#LB_EdoCta#">
        <cfreportparam name="LB_Telefono" 	value="#LB_Telefono#">
        <cfreportparam name="LB_Direccion" 	value="#LB_Direccion#">
        <cfreportparam name="LB_Cobrador" 	value="#LB_Cobrador#">
        <cfreportparam name="LB_Apartado" 	value="#LB_Apartado#">
        <cfreportparam name="LB_Moneda" 	value="#LB_Moneda#">
        <cfreportparam name="LB_Documento" 	value="#LB_Documento#">
        <cfreportparam name="LB_Ref" 		value="#LB_Ref#">
        <cfreportparam name="LB_FecVenc" 	value="#LB_FecVenc#">
        <cfreportparam name="LB_Sucursal" 	value="#LB_Sucursal#">
        <cfreportparam name="LB_OC" 		value="#LB_OC#">
        <cfreportparam name="LB_NRecl" 		value="#LB_NRecl#">
        <cfreportparam name="LB_Debitos" 	value="#LB_Debitos#">
        <cfreportparam name="LB_Saldo" 		value="#LB_Saldo#">
        <cfreportparam name="LB_Creditos" 	value="#LB_Creditos#">
        <cfreportparam name="LB_AnaSaldo" 	value="#LB_AnaSaldo#">
        <cfreportparam name="LB_VencSaldo" 	value="#LB_VencSaldo#">
        <cfreportparam name="LB_Corriente" 	value="#LB_Corriente#">
        <cfreportparam name="LB_SinVenc" 	value="#LB_SinVenc#">
        <cfreportparam name="LB_De" 		value="#LB_De#">
        <cfreportparam name="MSG_Pie" 		value="#MSG_Pie#">
        <cfreportparam name="LB_Morosidad" 	value="#LB_Morosidad#">
        <cfreportparam name="LB_Tipo" 		value="#LB_Tipo#">
        <cfreportparam name="Descripcion" 	value="#Descripcion#">
        <cfreportparam name="LB_Monto" 		value="#LB_Monto#">
        <cfreportparam name="LB_Identificacion" 	value="#LB_Identificacion#">
        <cfreportparam name="LB_omas" 		value="#LB_omas#">
		<cfreportparam name="Tipo" 			value="0">
		<cfif isdefined("rsSNCEdescripcion") and rsSNCEdescripcion.recordcount eq 1>
			<cfreportparam name="SNCEdescripcion" value="#rsSNCEdescripcion.SNCEdescripcion#">
		</cfif>
		<cfif isdefined("rsSNCDdescripcion1") and rsSNCDdescripcion1.recordcount eq 1>
			<cfreportparam name="SNCDdescripcion1" value="#rsSNCDdescripcion1.SNCDdescripcion#">
		</cfif>
		<cfif isdefined("rsSNCDdescripcion2") and rsSNCDdescripcion2.recordcount eq 1>
			<cfreportparam name="SNCDdescripcion2" value="#rsSNCDdescripcion2.SNCDdescripcion#">
		</cfif>

		<cfif not isdefined("Cobrador") or len(trim(Cobrador)) eq 0>
			<cfset cobrador = 'Todos'>
		</cfif>
		<cfreportparam name="Cobrador" value="#Cobrador#">

		<cfif isdefined("rsSNnombre1") and rsSNnombre1.recordcount eq 1>
			<cfreportparam name="SNnombre" value="#rsSNnombre1.SNnombre#">
		</cfif>
		<cfif isdefined("rsSNnombre2") and rsSNnombre2.recordcount eq 1>
			<cfreportparam name="SNnombreb2" value="#rsSNnombre2.SNnombre#">
		</cfif>

		<cfif isdefined("FechaInicio") and len(trim(FechaInicio))>
			<cfreportparam name="fechaDes" value="#LSDateFormat(FechaInicio,"DD/MM/YYYY")#">
		</cfif>
		<cfif isdefined("FechaFinal") and len(trim(FechaFinal))>
			<cfreportparam name="fechaHas" value="#LSDateFormat(FechaFinal,"DD/MM/YYYY")#">
		</cfif>

		<cfif isdefined("rsSNCEdescripcion_orden") and rsSNCEdescripcion_orden.recordcount eq 1>
			<cfreportparam name="SNCEdescripcion_orden" value="#rsSNCEdescripcion_orden.SNCEdescripcion#">
		</cfif>


		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
		</cfif>

		<cfif isdefined("LvarAntiguedad1")>
			<cfreportparam name="P1" value="#LvarAntiguedad1#">
		</cfif>
		<cfif isdefined("LvarAntiguedad1")>
			<cfreportparam name="P2" value="#LvarAntiguedad2#">
		</cfif>
		<cfif isdefined("LvarAntiguedad3")>
			<cfreportparam name="P3" value="#LvarAntiguedad3#">
		</cfif>
		<cfif isdefined("LvarAntiguedad4")>
			<cfreportparam name="P4" value="#LvarAntiguedad4#">
		</cfif>
        <cfif isdefined("LvarLeyendaCxC") and len(trim(LvarLeyendaCxC))>
			<cfreportparam name="LeyendaCxC" value="#LvarLeyendaCxC#">
		</cfif>

	</cfreport>
	</cfif>
</cffunction>