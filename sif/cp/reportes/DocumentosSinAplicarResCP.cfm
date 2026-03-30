<!---     Modificado por: Rebeca Corrales Alfaro
		  Fecha: 01/06/05
		  Motivo: Se modifica el diseño de la pantalla y  de los
		  		  filtros, se deja un solo filtro para monedas,
				  transaccion, oficina y socio de negocios
				  para generar el reporte Documentos sin Aplicar
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">


<cfif isdefined("url.Generar")>
	<cfset fecha = "a.EDfecha">
    <cfset desc = "Fecha Fact.">
	<cfif isdefined("url.tipoFiltro") and url.tipoFiltro eq 2>
    	<cfset fecha = "a.EDfechaarribo">
        <cfset desc = "Fecha Arribo">
    </cfif>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select
        		'#desc#' as Descripcion,
        		f.Mnombre,
				a.EDdocumento,
				a.EDfecha,
				a.CPTcodigo as CCTcodigo,
				a.EDvencimiento,
				(a.EDtotal * case when tr.CPTtipo = 'D' then -1.00 else 1.00 end)  as EDtotal,
				b.SNnombre,
				b.SNnumero,
				b.SNidentificacion,
				c.Cformato,
				c.Cdescripcion,
				d.Odescripcion,
				a.IDdocumento,
				g.Edescripcion
		 from EDocumentosCxP a

			inner join CPTransacciones tr
				 on tr.Ecodigo   = a.Ecodigo
				and tr.CPTcodigo = a.CPTcodigo

			inner join SNegocios b
				on b.Ecodigo = a.Ecodigo
				and b.SNcodigo = a.SNcodigo

			inner join CContables c
				on c.Ecodigo = a.Ecodigo
				and c.Ccuenta = a.Ccuenta

			inner join Oficinas d
				on d.Ecodigo =a.Ecodigo
				and d.Ocodigo = a.Ocodigo

			inner join Monedas f
				on f.Ecodigo = a.Ecodigo
				and f.Mcodigo = a.Mcodigo

			inner join Empresas g
				on g.Ecodigo = a.Ecodigo

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

			<!---
				and c.Mcodigo = 3
				and c.Cmovimiento = 'S'
			--->

			<!--- Socio de negocios --->

			<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			</cfif>

			<!--- Moneda --->

			<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and url.Moneda NEQ '-1'>
				and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#">
			</cfif>

			<!--- Tipo de transacción --->
			 <cfif isdefined("url.Transaccion") and len(trim(url.Transaccion)) and url.Transaccion NEQ '-1'>
				and a.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
			</cfif>

			<!--- Oficina --->
			<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
				and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
			</cfif>

			<!--- Fechas Desde / Hasta --->
			 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfif datecompare(lsparsedatetime(url.fechaDes), lsparsedatetime(url.fechaHas)) eq -1>
					and #fecha# between #lsparsedatetime(url.fechaDes)#
						and #lsparsedatetime(url.fechaHas)#
				<cfelseif datecompare(lsparsedatetime(url.fechaDes), lsparsedatetime(url.fechaHas)) eq 1>
					and #fecha# between #lsparsedatetime(url.fechaHas)#
						and #lsparsedatetime(url.fechaDes)#
				<cfelseif datecompare(lsparsedatetime(url.fechaDes), lsparsedatetime(url.fechaHas)) eq 0>
					and #fecha# between #lsparsedatetime(url.fechaDes)#
						and #lsparsedatetime(url.fechaHas)#
				</cfif>
			<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				and #fecha# >= #lsparsedatetime(url.fechaDes)#
			<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				and #fecha# <= #lsparsedatetime(url.fechaHas)#
			</cfif>

			<!--- Usuario --->
				<cfif isdefined("url.usuario") and len(trim(url.usuario)) and url.usuario NEQ 'Todos'>
					and ltrim(rtrim(upper(a.EDusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.usuario))#">
				</cfif>


		order by f.Mnombre, b.SNnombre
	</cfquery>
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
   		<cfset MSG_RegLim = t.Translate('MSG_RegLim','Se han generado mas de 5000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_RegLim#">
		<cfabort>
	</cfif>
	<!---<cf_dump var="#rsReporte.fechaR#">--->
	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

	<!--- Busca el nombre de la Oficina Inicial --->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<cfquery name="rsOficinaIni" datasource="#session.DSN#">
			select Ocodigo, Odescripcion
			from Oficinas
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
		</cfquery>
	</cfif>


	<!--- Busca el nombre de la moneda inicial --->
	<cfif isdefined("url.moneda")	and len(trim(url.moneda))>
		<cfquery name="rsMonedaIni" datasource="#session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda#">
			order by Mcodigo
		</cfquery>
	</cfif>


	<!--- Busca el nombre de la Transacción Inicial --->
	<cfquery name="rsTransaccion" datasource="#session.DSN#">
		select CPTdescripcion
		from CPTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
		  and coalesce(CPTpago,0) != 1
	</cfquery>



	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 4>
		<cfset formatos = "Excel">
	</cfif>

<cfset LB_Hora 			= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha 		= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_NombreReporte = t.Translate('LB_NombreReporte','Documentos sin Aplicar (Resumido)')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Codigo 	= t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_FecFact = t.Translate('LB_FecFact','Fecha Fact.')>
<cfset LB_FecVenc = t.Translate('LB_FecVenc','Fecha Venc.')>
<cfset Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Cuenta = t.Translate(' LB_Cuenta','Cuenta ','/sif/generales.xml')>
<cfset LB_DesCuenta = t.Translate(' LB_DesCuenta','Desc. Cuenta ')>
<cfset LB_TotalDoc = t.Translate('LB_TotalDoc','Total Documento')>
<cfset LB_TotalMon = t.Translate('LB_TotalMon','Total Moneda')>
<cfset LB_Total 	= t.Translate('LB_Total','Total')>
<cfset LB_NumReg 	= t.Translate('LB_NumReg','Número de Registros')>
<cfset LB_FinRep = t.Translate('LB_FinRep','Fin del Reporte')>
<cfset LB_Criterio = t.Translate('LB_Criterio','Criterios de Selección')>
<cfset LB_Fecha_Inicial = t.Translate('LB_Fecha_Inicial','Fecha Inicial','/sif/generales.xml')>
<cfset LB_Fecha_Final 	= t.Translate('LB_Fecha_Final','Fecha Final','/sif/generales.xml')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Fecha Final','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Todos	= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_CxP 		= t.Translate('LB_CxP','Cuentas por Pagar')>
<cfset LB_TotalDoc = t.Translate('LB_TotalDoc','Total Documento')>

    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and  formatos eq "Excel">
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.DocumentosSinAplicarResCP"
		headers = "title:#LB_NombreReporte#"/>
	<cfelse>
		<cfreport format="#formatos#" template= "DocumentosSinAplicarResCP.cfr" query="rsReporte">
			<cfreportparam name="LB_NombreReporte" 	value="#LB_NombreReporte#">
			<cfreportparam name="LB_Fecha" 	value="#LB_Fecha#">
			<cfreportparam name="LB_Hora" 	value="#LB_Hora#">
			<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
			<cfreportparam name="LB_CxP" 	value="#LB_CxP#">
			<cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
			<cfreportparam name="LB_Codigo" value="#LB_Codigo#">
			<cfreportparam name="LB_Documento" value="#LB_Documento#">
			<cfreportparam name="LB_Transaccion" value="#LB_Transaccion#">
			<cfreportparam name="LB_FecFact"  value="#LB_FecFact#">
			<cfreportparam name="LB_FecVenc"  value="#LB_FecVenc#">
			<cfreportparam name="LB_Oficina" 	  value="#Oficina#">
			<cfreportparam name="LB_Cuenta"   value="#LB_Cuenta#">
			<cfreportparam name="LB_DesCuenta"   value="#LB_DesCuenta#">
			<cfreportparam name="LB_Total" value="#LB_Total#">
			<cfreportparam name="LB_TotalMon" value="#LB_TotalMon#">
			<cfreportparam name="LB_NumReg" 	value="#LB_NumReg#">
			<cfreportparam name="LB_FinRep" 	value="#LB_FinRep#">
			<cfreportparam name="LB_Criterio" value="#LB_Criterio#">
			<cfreportparam name="LB_Fecha_Inicial" value="#LB_Fecha_Inicial#">
			<cfreportparam name="LB_Fecha_Final" 	value="#LB_Fecha_Final#">
			<cfreportparam name="LB_USUARIO" 		value="#LB_USUARIO#">
			<cfreportparam name="LB_TotalDoc" value="#LB_TotalDoc#">

			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
			<cfelse>
				<cfreportparam name="SNcodigo" value="#LB_Todos#">
			</cfif>

			<cfif isdefined("rsOficinaIni") and rsOficinaIni.recordcount gt 0>
				<cfreportparam name="Oficina" value="#rsOficinaIni.Odescripcion#">
			<cfelse>
				<cfreportparam name="Oficina" value="#LB_Todos#">
			</cfif>

			<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				<cfreportparam name="fechaDes" value="#url.fechaDes#">
			</cfif>

			<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfreportparam name="fechaHas" value="#url.fechaHas#">
			</cfif>

			<cfif isdefined("rsMonedaIni") and rsMonedaIni.recordcount gt 0>
				<cfreportparam name="MonedaIni" value="#rsMonedaIni.Mnombre#">
			<cfelse>
				<cfreportparam name="MonedaIni" value="#LB_Todos#">
			</cfif>

			<cfif isdefined("rsTransaccion") and rsTransaccion.recordcount gt 0>
				<cfreportparam name="Transaccion" value="#rsTransaccion.CPTdescripcion#">
			<cfelse>
				<cfreportparam name="Transaccion" value="#LB_Todos#">
			</cfif>

			<cfif isdefined("url.usuario") and len(trim(url.usuario))>
				<cfreportparam name="Usuario" value="#url.usuario#">
			</cfif>

		</cfreport>
	</cfif>
</cfif>





