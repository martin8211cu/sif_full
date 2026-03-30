<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio','DocumentosSinAplicarRes.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','DocumentosSinAplicarRes.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Hora = t.Translate('LB_Hora','Hora','DocumentosSinAplicarRes.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_CuentasporCobrar = t.Translate('LB_CuentasporCobrar','Cuentas por Cobrar','DocumentosSinAplicarRes.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocios','DocumentosSinAplicarRes.xml')>
<cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_TransaccionSA = t.Translate('LB_TransaccionSA','Transacción','DocumentosSinAplicarRes.xml')>
<cfset LB_FecFact = t.Translate('LB_FecFact','Fecha Fact.','DocumentosSinAplicarRes.xml')>
<cfset LB_FecVenc = t.Translate('LB_FecVenc','Fecha Venc.','DocumentosSinAplicarRes.xml')>
<cfset Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Cuenta = t.Translate(' LB_Cuenta','Cuenta ','/sif/generales.xml')>
<cfset LB_TotalDoc = t.Translate('LB_TotalDoc','Total Documento','DocumentosSinAplicarRes.xml')>
<cfset LB_TotalMon = t.Translate('LB_TotalMon','Total Moneda','DocumentosSinAplicarRes.xml')>
<cfset LB_NumReg = t.Translate('LB_NumReg','Número de Registros','DocumentosSinAplicarRes.xml')>
<cfset LB_FinRep = t.Translate('LB_FinRep','Fin del Reporte','DocumentosSinAplicarRes.xml')>
<cfset LB_Criterio = t.Translate('LB_Criterio','Criterios de Selección:','DocumentosSinAplicarRes.xml')>
<cfset LB_Fecha_Inicial = t.Translate('LB_Fecha_Inicial','Fecha Inicial','/sif/generales.xml')>
<cfset LB_Fecha_Final 	= t.Translate('LB_Fecha_Final','Fecha Final','/sif/generales.xml')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Fecha Final','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Cantidad = t.Translate('LB_Cantidad','Cantidad','DocumentosSinaplicarDet.xml')>
<cfset LB_Subtotal 	= t.Translate('LB_Subtotal','Subtotal','/sif/generales.xml')>
<cfset LB_Impuesto = t.Translate('LB_Impuesto','Impuesto','DocumentosSinaplicarDet.xml')>
<cfset LB_MontoDoc = t.Translate('LB_MontoDoc','Monto del Documento','/sif/generales.xml')>
<cfset LB_Linea = t.Translate('LB_Linea','Línea','DocumentosSinaplicarDet.xml')>
<cfset LB_Descripcion 	= t.Translate('MSG_Descripcion','Descripción','/sif/generales.xml')>
<cfset LB_PrecioU = t.Translate('LB_PrecioU','Precio Unitario','DocumentosSinaplicarDet.xml')>
<cfset LB_TotDoctCI = t.Translate('LB_TotDoctCI','Total del Documento (con impuestos)','DocumentosSinaplicarDet.xml')>
<cfset LB_TotSocio = t.Translate('LB_TotSocio','Total Socio','DocumentosSinaplicarDet.xml')>
<cfset LB_Obser = t.Translate('LB_Obser','Observaciones','DocumentosSinaplicarDet.xml')>
<cfset LB_TotLinea = t.Translate('LB_TotLinea','Total Línea','DocumentosSinaplicarDet.xml')>
<cfset LB_Todas = t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>


<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("url.Generar")>
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =  #session.Ecodigo#
	</cfquery>

	<cfset LvarEdescripcion = rsEmpresa.Edescripcion>

	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select
				f.Mnombre,
				a.EDdocumento,
				a.EDfecha,
				a.CCTcodigo,
				a.EDvencimiento,
				case when t.CCTtipo = 'C' then -a.EDtotal else a.EDtotal end as EDtotal,
				b.SNnombre,
				b.SNidentificacion,
				b.SNnumero,
				c.Cformato  #_Cat# c.Cdescripcion  as Cdescripcion,
				cc.Cformato #_Cat# cc.Cdescripcion as CdescripcionDetalle,
				d.Odescripcion,
				a.EDid,
				e.DDlinea,
				coalesce(e.DDdescripcion,'N/A') as DDdescripcion,
				e.DDdescalterna,
				case when t.CCTtipo = 'C' then - 1.00 else 1.00 end * coalesce(e.DDcantidad, EDtotal) as DDcantidad,
				coalesce(e.DDpreciou, EDtotal) as DDpreciou,
				case when t.CCTtipo = 'C' then - e.DDdesclinea else e.DDdesclinea end as DDdesclinea,
				case when t.CCTtipo = 'C' then - 1.00 else 1.00 end * coalesce(e.DDtotallinea,EDtotal) as DDtotallinea,
				e.Ccuenta,
				case when e.DDtipo ='A' then 'Articulo' else 'Concepto'end as DDtipo,
				'#LvarEdescripcion#' as Edescripcion,
				((
					select min(u.Usulogin)
					from Usuario u
					where u.Usucodigo = a.BMUsucodigo
				)) as Usulogin,
				a.DEobservacion,
				case when t.CCTtipo = 'C' then -EDimpuesto else EDimpuesto end as Impuesto,
				case when t.CCTtipo = 'C' then - 1.00 else 1.00 end * coalesce(EDtotal - EDimpuesto, EDtotal) as SubTotal
		 from EDocumentosCxC a
			 left outer join DDocumentosCxC e
				on e.EDid = a.EDid
			inner join CContables c
				on c.Ecodigo = a.Ecodigo
				and c.Ccuenta = a.Ccuenta
			left outer join CContables cc
				on cc.Ecodigo = e.Ecodigo
			   and cc.Ccuenta = e.Ccuenta

			inner join SNegocios b
				 on b.SNcodigo = a.SNcodigo
				and b.Ecodigo  = a.Ecodigo
			inner join Oficinas d
				 on d.Ecodigo = a.Ecodigo
				and d.Ocodigo = a.Ocodigo
			inner join Monedas f
				 on f.Mcodigo = a.Mcodigo
			inner join CCTransacciones t
				on t.CCTcodigo = a.CCTcodigo
				and t.Ecodigo = a.Ecodigo

		where a.Ecodigo =  #session.Ecodigo#
			<!--- Socio de negocios --->
			<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			</cfif>

			<!--- Monedas --->
			<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and url.Moneda NEQ '-1'>
				and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#">
			</cfif>

			<!--- Tipo de transacción --->
			<cfif isdefined("url.Transaccion") and len(trim(url.Transaccion)) and url.Transaccion NEQ '-1'>
				and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
			</cfif>

			<!--- Oficina --->
			<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
				and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
			</cfif>

			<!--- Fechas Desde / Hasta --->
			 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfif datecompare(url.fechaDes, url.fechaHas) eq -1>
					and a.EDfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
					and a.EDfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
					and a.EDfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				</cfif>
			<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				and a.EDfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
			<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				and a.EDfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
			</cfif>

			<!--- Usuario --->
			<cfif isdefined("url.Usuario") and len(trim(url.Usuario)) and url.Usuario NEQ '-1'>
				and rtrim(ltrim(upper(a.EDusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.Usuario))#">
			</cfif>

		order by f.Mnombre, b.SNnombre, a.EDid, e.DDlinea
	</cfquery>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
	<cfelseif isdefined("rsReporte") and rsReporte.recordcount LTE 0>
		<cf_errorCode code = "50571" msg = "No se encontraron registros según los parametros seleccionados">
	</cfif>

	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo =   #session.Ecodigo#
		</cfquery>
	</cfif>

	<!--- Busca el nombre de la Oficina Inicial --->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<cfquery name="rsOficinaIni" datasource="#session.DSN#">
			select Ocodigo, Odescripcion
			from Oficinas
			where Ecodigo  =  #session.Ecodigo#
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
		</cfquery>
	</cfif>

	<!--- Busca el nombre de la moneda inicial --->
	<cfif isdefined("url.moneda")	and len(trim(url.moneda))>
		<cfquery name="rsMonedaIni" datasource="#session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo =  #session.Ecodigo#
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda#">
		</cfquery>
	</cfif>

    <!--- Busca el nombre de la Transacción Inicial --->
	<cfquery name="rsTransaccion" datasource="#session.DSN#">
		select CCTdescripcion
		from CCTransacciones
		where Ecodigo =  #session.Ecodigo#
		  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
		  and coalesce(CCTpago,0) != 1
	</cfquery>

	<cfif url.Formato eq 3>
		<!--- Documentos Aplicados en HTML solo Resumido.  --->
		<script language="javascript" type="text/javascript">

			alert("Únicamente se puede visualizar el reporte resumido en formato HTML");
			window.location = "Documentos.cfm";
		</script>
		<cfabort>
	<cfelse>
		<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
			<cfset formatos = "flashpaper">
		<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
			<cfset formatos = "pdf">
		<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 4>
			<cfset formatos = "Excel">
		</cfif>
          
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
		fileName = "cc.reportes.DocumentosSinAplicarDet"/>
	<cfelse>
		  <cfreport format="#formatos#" template= "DocumentosSinAplicarDet.cfr" query="rsReporte">
    		<cfreportparam name="LB_CuentasporCobrar" value="#LB_CuentasporCobrar#">
            <cfreportparam name="LB_Fecha" 	value="#LB_Fecha#">
            <cfreportparam name="LB_Hora" 	value="#LB_Hora#">
    		<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
    		<cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
            <cfreportparam name="LB_Codigo" value="#LB_Codigo#">
            <cfreportparam name="LB_Identificacion" value="#LB_Identificacion#">
            <cfreportparam name="LB_Documento" value="#LB_Documento#">
            <cfreportparam name="LB_TransaccionSA" value="#LB_TransaccionSA#">
            <cfreportparam name="LB_FecFact"  value="#LB_FecFact#">
            <cfreportparam name="LB_FecVenc"  value="#LB_FecVenc#">
            <cfreportparam name="LB_Oficina" 	  value="#Oficina#">
            <cfreportparam name="LB_Cuenta"   value="#LB_Cuenta#">
            <cfreportparam name="LB_TotalDoc" value="#LB_TotalDoc#">
            <cfreportparam name="LB_TotalMon" value="#LB_TotalMon#">
            <cfreportparam name="LB_NumReg" 	value="#LB_NumReg#">
            <cfreportparam name="LB_FinRep" 	value="#LB_FinRep#">
            <cfreportparam name="LB_Criterio" 	value="#LB_Criterio#">
            <cfreportparam name="LB_Fecha_Inicial" 	value="#LB_Fecha_Inicial#">
            <cfreportparam name="LB_Fecha_Final" 	value="#LB_Fecha_Final#">
            <cfreportparam name="LB_USUARIO" 		value="#LB_USUARIO#">
			<cfreportparam name="NombreReporte" value="#LvarNombreReporte#">
            <cfreportparam name="LB_Cantidad"   value="#LB_Cantidad#">
            <cfreportparam name="LB_Subtotal"   value="#LB_Subtotal#">
            <cfreportparam name="LB_Impuesto"   value="#LB_Impuesto#">
            <cfreportparam name="LB_MontoDoc"   value="#LB_MontoDoc#">
            <cfreportparam name="LB_Linea"   	value="#LB_Linea#">
            <cfreportparam name="LB_Descripcion"   	value="#LB_Descripcion#">
            <cfreportparam name="LB_PrecioU"   	value="#LB_PrecioU#">
            <cfreportparam name="LB_TotDoctCI"  value="#LB_TotDoctCI#">
            <cfreportparam name="LB_TotSocio"   value="#LB_TotSocio#">
            <cfreportparam name="LB_Obser"   	value="#LB_Obser#">
            <cfreportparam name="LB_TotLinea"   value="#LB_TotLinea#">

			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
			</cfif>
			<cfif isdefined("rsOficinaIni") and rsOficinaIni.recordcount gt 0>
				<cfreportparam name="Oficina" value="#rsOficinaIni.Odescripcion#">
			<cfelseif isdefined("url.Ocodigo")	and len(trim(url.Ocodigo)) eq 0>
				<cfreportparam name="Oficina" value="#LB_Todas#">
			</cfif>
			<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				<cfreportparam name="fechaDes" value="#url.fechaDes#">
			</cfif>
			<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfreportparam name="fechaHas" value="#url.fechaHas#">
			</cfif>

			<cfif isdefined("rsMonedaIni") and rsMonedaIni.recordcount gt 0>
				<cfreportparam name="MonedaIni" value="#rsMonedaIni.Mnombre#">
			<cfelseif isdefined("url.moneda")	and len(trim(url.moneda)) and url.moneda EQ '-1'>
				<cfreportparam name="MonedaIni" value="#LB_Todas#">
			</cfif>

			<cfif isdefined("rsTransaccion") and rsTransaccion.recordcount gt 0>
				<cfreportparam name="Transaccion" value="#rsTransaccion.CCTdescripcion#">
			<cfelseif isdefined("url.Transaccion")	and len(trim(url.Transaccion)) and url.Transaccion EQ '-1'>
				<cfreportparam name="Transaccion" value="#LB_Todas#">
			</cfif>

			<cfif isdefined("url.Usuario") and url.Usuario NEQ '-1'>
				<cfreportparam name="Usuario" value="#url.Usuario#">
			<cfelseif isdefined("url.Usuario") and url.Usuario EQ '-1'>
				<cfreportparam name="Usuario" value="#LB_Todos#">
			</cfif>
		</cfreport>
		</cfif>
	</cfif>
</cfif>
