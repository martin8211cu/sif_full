<!---
	Modificado por: Ana Villavicencio+
	Fecha: 10 de marzo del 2006
		Motivo: Se agrego la variable AplicaRel al URL para indicar que llega al proceso de Aplicacion de Doc. a Favor
				desde Registro de Notas de Crédito. Esto en el caso que se quiera Relacionar la nota de crédito.

	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Proceso para relacionar documentos a la nota de credito, se agrego el insert sobre la tabla de Documentos  a Favor.
			esto en el proceso de aplicar y relacionar.

	Modificado por: Ana Villavicencio
	Fecha: 22 de febrero del 2006
	Motivo: Corrección en la navegacion dentro de la pantalla de trabajo.
	- Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxC en los procesos de facturas y notas de crédito, para que seguridad sepa
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.
				- Se agrega el botón nuevo en el form para que no tenga que salir hasta la lista para hacer uno nuevo (CHAVA).

	Modificado por Gustavo Fonseca Hernández
		Fecha: 21-6-2005
		Motivo: Se agregó el campo SNidentificación al Form.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">

<cfset LBT_Titulo = t.Translate('LBT_Titulo','Facturas')>

<cfquery name="rsvalTolerancia" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200090 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset varCEDif = 0>
<cfif #rsvalTolerancia.RecordCount#  neq 0>
	<cfset varCEDif = rsvalTolerancia.Pvalor>
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="#LBT_Titulo#">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="<cfoutput>#LBT_Titulo#</cfoutput>">
			<cfif isdefined('Url.tipo') and not isdefined('Form.tipo')>
				<cfset form.tipo = url.tipo>
			</cfif>
			<cfif isdefined('LvarTipo') and not isdefined('Form.tipo')>
				<cfset form.tipo = LvarTipo>
			</cfif>

			<cfif isDefined("url.Filtro_CCTdescripcion") and not isdefined('form.Filtro_CCTdescripcion')>
				<cfset form.Filtro_CCTdescripcion = url.Filtro_CCTdescripcion>
			</cfif>
			<cfif isDefined("url.Filtro_EDdocumento") and not isdefined('form.Filtro_EDdocumento')>
				<cfset form.Filtro_EDdocumento = url.Filtro_EDdocumento>
			</cfif>
			<cfif isDefined("url.Filtro_EDFecha") and not isdefined('form.Filtro_EDFecha')>
				<cfset form.Filtro_EDFecha = url.Filtro_EDFecha>
			</cfif>
			<cfif isDefined("url.Filtro_EDUsuario") and not isdefined('form.Filtro_EDUsuario')>
				<cfset form.Filtro_EDUsuario = url.Filtro_EDUsuario>
			</cfif>
			<cfif isDefined("url.Filtro_Mnombre") and not isdefined('form.Filtro_Mnombre')>
				<cfset form.Filtro_Mnombre = url.Filtro_Mnombre>
			</cfif>
			<cfif isDefined("url.hFiltro_CCTdescripcion") and not isdefined('form.hFiltro_CCTdescripcion')>
				<cfset form.hFiltro_CCTdescripcion = url.hFiltro_CCTdescripcion>
			</cfif>
			<cfif isDefined("url.hFiltro_EDdocumento") and not isdefined('form.hFiltro_EDdocumento')>
				<cfset form.hFiltro_EDdocumento = url.hFiltro_EDdocumento>
			</cfif>
			<cfif isDefined("url.hFiltro_EDFecha") and not isdefined('form.hFiltro_EDFecha')>
				<cfset form.hFiltro_EDFecha = url.hFiltro_EDFecha>
			</cfif>
			<cfif isDefined("url.hFiltro_EDUsuario") and not isdefined('form.hFiltro_EDUsuario')>
				<cfset form.hFiltro_EDUsuario = url.hFiltro_EDUsuario>
			</cfif>
			<cfif isDefined("url.hFiltro_Mnombre") and not isdefined('form.hFiltro_Mnombre')>
				<cfset form.hFiltro_Mnombre = url.hFiltro_Mnombre>
			</cfif>
			<cfif isDefined("url.Filtro_FechasMayores") and not isdefined('form.Filtro_FechasMayores')>
				<cfset form.Filtro_FechasMayores = url.Filtro_FechasMayores>
			</cfif>
			<cfif isDefined("url.Pagina") and len(Trim(url.Pagina)) gt 0>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<cfif isdefined('url.Aplicar') and not isdefined('form.Aplicar')>
				<cfset form.Aplicar = url.Aplicar>
			</cfif>
			<cfif isdefined('url.AplicarRel') and not isdefined('form.AplicarRel')>
				<cfset form.AplicarRel = url.AplicarRel>
			</cfif>
			<cfif isdefined('url.EDid') and url.EDid GT 0 and not isdefined('form.EDid')>
				<cfset form.EDid = url.EDid>
			</cfif>
			<cfif isdefined('url.DDlinea') and url.DDlinea GT 0 and isdefined('form.EDid')>
				<cfset form.DDlinea = url.DDlinea>
			</cfif>
			<cfset params = '' >
			<cfif isdefined('form.tipo')>
				<cfset params = params & 'tipo=#form.tipo#'>
			</cfif>
			<cfif isdefined ("url.SNidentificacion") and len(trim(url.SNidentificacion))>
				<cfset form.SNidentificacion = url.SNidentificacion>
			</cfif>
			<cfif isdefined ("url.SNnumero") and len(trim(url.SNnumero))>
				<cfset form.SNnumero = url.SNnumero>
			</cfif>
			<cfif isdefined('form.SNnumero') and len(trim(form.SNnumero))>
				<cfset params = params & '&SNnumero=#form.SNnumero#'>
			<cfelseif isdefined('url.SNnumero') and len(trim(url.SNnumero))>
				<cfset params = params & '&SNnumero=#url.SNnumero#'>
			</cfif>
			<cfif isdefined('form.SNidentificacion') and len(trim(Form.SNidentificacion))>
				<cfset params = params & '&SNidentificacion=#form.SNidentificacion#'>
			</cfif>
			<cfif isdefined('form.Filtro_CCTdescripcion')>
				<cfset params = params & '&Filtro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
			</cfif>
			<cfif isdefined('form.Filtro_EDdocumento')>
				<cfset params = params & '&Filtro_EDdocumento=#form.Filtro_EDdocumento#'>
			</cfif>
			<cfif isdefined('form.Filtro_EDFecha')>
				<cfset params = params & '&Filtro_EDFecha=#form.Filtro_EDFecha#'>
			</cfif>
			<cfif isdefined('form.Filtro_EDUsuario')>
				<cfset params = params & '&Filtro_EDUsuario=#form.Filtro_EDUsuario#'>
			</cfif>
			<cfif isdefined('form.Filtro_Mnombre')>
				<cfset params = params & '&Filtro_Mnombre=#form.Filtro_Mnombre#'>
			</cfif>
			<cfif isdefined('form.hFiltro_CCTdescripcion')>
				<cfset params = params & '&hFiltro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
			</cfif>
			<cfif isdefined('form.Filtro_EDdocumento')>
				<cfset params = params & '&hFiltro_EDdocumento=#form.Filtro_EDdocumento#'>
			</cfif>
			<cfif isdefined('form.Filtro_EDFecha')>
				<cfset params = params & '&hFiltro_EDFecha=#form.Filtro_EDFecha#'>
			</cfif>
			<cfif isdefined('form.Filtro_EDUsuario')>
				<cfset params = params & '&hFiltro_EDUsuario=#form.Filtro_EDUsuario#'>
			</cfif>
			<cfif isdefined('form.Filtro_Mnombre')>
				<cfset params = params & '&hFiltro_Mnombre=#form.Filtro_Mnombre#'>
			</cfif>
			<cfif isdefined('form.Filtro_FechasMayores')>
				<cfset params = params & '&Filtro_FechasMayores=#form.Filtro_FechasMayores#'>
			</cfif>
			<cfif isdefined('form.Pagina')>
				<cfset params = params & '&Pagina=#form.Pagina#'>
			</cfif>
			<cfset modo = 'ALTA'>
			<cfset modoDet = 'ALTA'>
			<cfif isdefined('url.EDid') and not isdefined('form.EDid')>
				<cfset form.EDid = url.EDid>
			</cfif>
			<cfif isdefined('url.DDlinea') and url.DDlinea GT 0 and isdefined('form.EDid')>
				<cfset form.DDlinea = url.DDlinea>
			</cfif>
			<cfif isdefined('form.EDid') and form.EDid GT 0>
				<cfset modo="CAMBIO">
			</cfif>
			<cfif isdefined('form.EDid') and form.EDid GT 0
				and isdefined('form.DDlinea') and form.DDlinea GT 0>
				<cfset modoDet = 'CAMBIO'>
			</cfif>
			<cfif isDefined("Form.datos") and Form.datos NEQ "">
				<cfset arreglo = ListToArray(Form.datos,"|")>
				<cfset EDid = Trim(arreglo[1])>
				<cfset modo = "CAMBIO">
				<cfset modoDet = "ALTA">
			</cfif>
			<cfif not isdefined('form.EDid')>
				<cflocation addtoken="no" url="listaDocumentosCC.cfm?#params#">
			</cfif>
			<cfif isDefined("Form.Aplicar") or isdefined('form.AplicarRel') or isdefined('form.btnAplicar')>
				<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
				<cfif isDefined("Form.chk")>
					<cfset chequeados = ListToArray(Form.chk)>
					<cfset cuantos = ArrayLen(chequeados)>
					<cfloop index="CountVar" from="1" to="#cuantos#">
						<cfset valores = ListToArray(chequeados[CountVar],"|")>
						<cfquery name="rsRetencionMonto" datasource="#session.dsn#">
							select EDid, coalesce(r.Rporcentaje,0) / 100.0 *
						       coalesce(
						       (
						        select sum(DDtotallinea)
						          from DDocumentosCxC d
						         inner join Impuestos i
						          on i.Ecodigo = d.Ecodigo
						         and i.Icodigo = d.Icodigo
						         where d.EDid = e.EDid
						           and i.InoRetencion = 0
						       )
						      ,0.00) as Monto
						     from EDocumentosCxC e
						      left join Retenciones r
						       on r.Ecodigo = e.Ecodigo
						      and r.Rcodigo = e.Rcodigo
						     where e.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
						</cfquery>
						<cfquery name="rsDatos" datasource="#Session.Dsn#">
							select CCTcodigo as CXTcodigo, EDdocumento as Ddocumento, SNcodigo, TESRPTCid, TESRPTCietu  ,EDtotal
							from EDocumentosCxC
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
						</cfquery>
						<cfquery name="datosTimbre" datasource="#session.dsn#">
                            select * from CERepoTMP
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                            and Origen = 'CCFC'
                            and ID_Documento = <cfqueryparam cfsqltype="integer" value="#valores[1]#">
                         </cfquery>
                         <cfif isdefined('datosTimbre') and datosTimbre.RecordCount GT 0
                            and datosTimbre.TipoComprobante EQ 1 and datosTimbre.totalCFDI GT 0>
                            <cfset totalTimbre=datosTimbre.totalCFDI>
                            <cfset totalFactura=rsDatos.EDtotal>
							<cfset RetencionFactura=rsRetencionMonto.Monto>
							<cfif RetencionFactura GT 0>
								<cfset totalFactura = totalFactura - RetencionFactura>
							</cfif>
							<cfif RetencionFactura GT 0 and datosTimbre.xmlTimbrado EQ "">
								<cfset totalTimbre = totalTimbre - RetencionFactura>
							</cfif>
                            <cfif totalTimbre NEQ totalFactura>
                                <cfif totalFactura GT totalTimbre>
								<cfset difTotal = totalFactura -  totalTimbre>
                                <cfelse>
                                     <cfset difTotal =  totalTimbre - totalFactura>
                                </cfif>
								<cfif difTotal GT varCEDif>
                                   <cfthrow message="El monto  del CFDI #totalTimbre# no  corresponde con  el Monto de la Factura #totalFactura#">
                                    <cfabort>
                                </cfif>
                        	</cfif>
                        </cfif>
						<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
								  method="PosteoDocumento"
									EDid = "#valores[1]#"
									Ecodigo = "#Session.Ecodigo#"
									usuario = "#Session.usuario#"
									debug = "N"
									USA_tran = "true"
						/>

						<!--- INICIO Marca al socio de negocio para que se lo lleve la tarea programada
						      y Actualiza el saldo del socio --->
						<cfquery name="rsGetInfoSNegocios" datasource="#session.dsn#">
							SELECT TOP 1 SNcodigo,
							       SNid,
							       RTRIM(LTRIM(SNidentificacion)) AS SNidentificacion,
							       RTRIM(LTRIM(SNnumero)) AS SNnumero,
							       SNcodigoext
							FROM SNegocios
							WHERE Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
							<cfif isdefined("rsDatos.SNcodigo") AND #rsDatos.SNcodigo# NEQ "">
								AND RTRIM(LTRIM(SNcodigo)) = <cfqueryparam cfsqltype="varchar" value="#TRIM(rsDatos.SNcodigo)#">
							</cfif>
						</cfquery>

						<cfif isdefined("rsGetInfoSNegocios") AND #rsGetInfoSNegocios.RecordCount# GT 0>
							<!--- Se Obtiene el saldo del socio --->
							<cfquery name="rsGetSaldoSNegocios" datasource="#Session.Dsn#">
								SELECT COALESCE(SUM(ROUND(d.Dsaldo * d.Dtcultrev * CASE
								                                                       WHEN t.CCTtipo = 'D' THEN 1.00
								                                                       ELSE -1.00
								                                                   END, 2)), 0) AS Saldo
								FROM Documentos d
								INNER JOIN CCTransacciones t ON t.CCTcodigo = d.CCTcodigo
								AND t.Ecodigo = d.Ecodigo
								WHERE d.Dsaldo <> 0.00
								  AND d.Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
								  AND d.SNcodigo = <cfqueryparam cfsqltype="varchar" value="#TRIM(rsGetInfoSNegocios.SNcodigo)#">
							</cfquery>

							<!--- Marca actualizacion de saldo y activa al SN para que se lo lleve la interfaz --->
							<cfquery name="rsUpdateSnInterfaz" datasource="#Session.Dsn#">
								UPDATE SNegocios
								SET intfazLD = 2,
								    saldoCliente = <cfqueryparam cfsqltype="money" value="#rsGetSaldoSNegocios.Saldo#">
								WHERE SNcodigo = <cfqueryparam cfsqltype="varchar" value="#TRIM(rsGetInfoSNegocios.SNcodigo)#">
								  AND Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
							</cfquery>

							<!--- ACTUALIZA EL SALDO EN TRANSITO --->
							<cfquery name="rsUpdateSnInterfaz" datasource="#Session.Dsn#">
								UPDATE BTransito_CC
								SET Monto = Monto - <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.EDtotal#">
								WHERE Numero_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Ddocumento#">
								  AND SNcodigoExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetInfoSNegocios.SNcodigoext#">
								  AND Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
							</cfquery>

						</cfif>
						<!--- FIN Marca al socio de negocio para que se lo lleve la tarea programada
						      y Actualiza el saldo del socio --->

						<!--- INTERFAZ --->
						<!--- <cfset LobjInterfaz.fnProcesoNuevoSoin(110,"CXTcodigo=#rsDatos.CXTcodigo#&Ddocumento=#rsDatos.Ddocumento#&SNcodigo=#rsDatos.SNcodigo#&MODULO=CC","R")> --->
					</cfloop>
				<cfelseif isDefined("Form.EDid") and Len(Trim(Form.EDid)) GT 0 >
					<cfquery name="rsDatos" datasource="#Session.Dsn#">
						select a.CCTcodigo as CXTcodigo, a.EDdocumento as Ddocumento, a.SNcodigo,a.EDtotal,
								a.Mcodigo, a.EDtipocambio, a.Ccuenta, a.EDfecha,a.Interfaz, b.CCTnoflujoefe
						from EDocumentosCxC a, CCTransacciones b
						where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDid#">
						  and a.Ecodigo = b.Ecodigo
						  and a.CCTcodigo = b.CCTcodigo
					</cfquery>
					<cfquery name="rsRetencionMonto" datasource="#session.dsn#">
						select EDid, coalesce(r.Rporcentaje,0) / 100.0 *
					       coalesce(
					       (
					        select sum(DDtotallinea)
					          from DDocumentosCxC d
					         inner join Impuestos i
					          on i.Ecodigo = d.Ecodigo
					         and i.Icodigo = d.Icodigo
					         where d.EDid = e.EDid
					           and i.InoRetencion = 0
					       )
					      ,0.00) as Monto
					     from EDocumentosCxC e
					      left join Retenciones r
					       on r.Ecodigo = e.Ecodigo
					      and r.Rcodigo = e.Rcodigo
					     where e.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDid#">
					</cfquery>
                    <cfquery name="datosTimbre" datasource="#session.dsn#">
                        select * from CERepoTMP
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and Origen = 'CCFC'
                        and ID_Documento = <cfqueryparam cfsqltype="integer" value="#form.EDid#">
                     </cfquery>
                     <cfif isdefined('datosTimbre') and datosTimbre.RecordCount GT 0
                        and datosTimbre.TipoComprobante EQ 1 and datosTimbre.totalCFDI GT 0>
                        <cfset totalTimbre=datosTimbre.totalCFDI>
                        <cfset totalFactura=rsDatos.EDtotal>
						<cfset RetencionFactura=rsRetencionMonto.Monto>
						<cfif RetencionFactura GT 0>
							<cfset totalFactura = totalFactura - RetencionFactura>
						</cfif>
						<cfif RetencionFactura GT 0 and datosTimbre.xmlTimbrado EQ "">
							<cfset totalTimbre = totalTimbre - RetencionFactura>
						</cfif>
                        <cfif totalTimbre NEQ totalFactura>
                            <cfif totalFactura GT totalTimbre>
								<cfset difTotal = totalFactura -  totalTimbre>
                            <cfelse>
                                <cfset difTotal =  totalTimbre - totalFactura>
                            </cfif>
							<cfif difTotal GT varCEDif>
                                <cfthrow message="El monto  del CFDI #totalTimbre# no  corresponde con  el Monto de la Factura #totalFactura#">
                                <cfabort>
                            </cfif>
                        </cfif>
                     </cfif>
					<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
							  method="PosteoDocumento"
								EDid	= "#form.EDid#"
								Ecodigo = "#Session.Ecodigo#"
								usuario = "#Session.usuario#"
								USA_tran = "true"
								debug = "N"
					/>


						<!--- INICIO Marca al socio de negocio para que se lo lleve la tarea programada
						      y Actualiza el saldo del socio --->
						<cfquery name="rsGetInfoSNegocios" datasource="#session.dsn#">
							SELECT TOP 1 SNcodigo,
							       SNid,
							       RTRIM(LTRIM(SNidentificacion)) AS SNidentificacion,
							       RTRIM(LTRIM(SNnumero)) AS SNnumero,
							       SNcodigoext
							FROM SNegocios
							WHERE Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
							<cfif isdefined("form.SNidentificacion") AND #form.SNidentificacion# NEQ "">
								AND RTRIM(LTRIM(SNidentificacion)) = <cfqueryparam cfsqltype="varchar" value="#TRIM(form.SNidentificacion)#">
							</cfif>
							<cfif isdefined("form.SNnumero") AND #form.SNnumero# NEQ "">
								AND RTRIM(LTRIM(SNnumero)) = <cfqueryparam cfsqltype="varchar" value="#TRIM(form.SNnumero)#">
							</cfif>
						</cfquery>

						<cfif isdefined("rsGetInfoSNegocios") AND #rsGetInfoSNegocios.RecordCount# GT 0>
							<!--- Se Obtiene el saldo del socio --->
							<cfquery name="rsGetSaldoSNegocios" datasource="#Session.Dsn#">
								SELECT COALESCE(SUM(ROUND(d.Dsaldo * d.Dtcultrev * CASE
								                                                       WHEN t.CCTtipo = 'D' THEN 1.00
								                                                       ELSE -1.00
								                                                   END, 2)), 0) AS Saldo
								FROM Documentos d
								INNER JOIN CCTransacciones t ON t.CCTcodigo = d.CCTcodigo
								AND t.Ecodigo = d.Ecodigo
								WHERE d.Dsaldo <> 0.00
								  AND d.Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
								  AND d.SNcodigo = <cfqueryparam cfsqltype="varchar" value="#TRIM(rsGetInfoSNegocios.SNcodigo)#">
							</cfquery>

							<!--- Marca actualizacion de saldo y activa al SN para que se lo lleve la interfaz --->
							<cfquery name="rsUpdateSnInterfaz" datasource="#Session.Dsn#">
								UPDATE SNegocios
								SET intfazLD = 2,
								    saldoCliente = <cfqueryparam cfsqltype="money" value="#rsGetSaldoSNegocios.Saldo#">
								WHERE SNcodigo = <cfqueryparam cfsqltype="varchar" value="#TRIM(rsGetInfoSNegocios.SNcodigo)#">
								  AND Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
							</cfquery>

							<!--- ACTUALIZA EL SALDO EN TRANSITO --->
							<cfquery name="rsUpdateSnInterfaz" datasource="#Session.Dsn#">
								UPDATE BTransito_CC
								SET Monto = Monto - <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.EDtotal#">
								WHERE Numero_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Ddocumento#">
								  AND SNcodigoExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetInfoSNegocios.SNcodigoext#">
								  AND Ecodigo = <cfqueryparam cfsqltype="integer" value="#session.Ecodigo#">
							</cfquery>
						</cfif>
						<!--- FIN Marca al socio de negocio para que se lo lleve la tarea programada
						      y Actualiza el saldo del socio --->


					<!--- INTERFAZ --->
					<!--- <cfset LobjInterfaz.fnProcesoNuevoSoin(110,"CXTcodigo=#rsDatos.CXTcodigo#&Ddocumento=#rsDatos.Ddocumento#&SNcodigo=#rsDatos.SNcodigo#&MODULO=CC","R")> --->

					<!--- Proceso para relacionar documentos a la nota de credito, crea un nuevo documento a favor --->
					<cfif isdefined('form.AplicarRel')>
						<cftransaction>
							<cfquery name="rsInsertDocFavor" datasource="#session.DSN#">
								insert into EFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, EFtipocambio, EFtotal, EFselect, Ccuenta,
										EFfecha, EFusuario)
								values
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.CXTcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.Ddocumento#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.SNcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Mcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.EDtipocambio#">,
									0,
									0,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Ccuenta#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#lsParseDateTime(rsDatos.EDfecha)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">
								)
							</cfquery>
						</cftransaction>
						<cflocation addtoken="no" url="AplicaDocsAfavorCC.cfm?AplicaRel=true&modo=CAMBIO&CCTcodigo=#rsDatos.CXTcodigo#&Ddocumento=#rsDatos.Ddocumento#&#params#">
					</cfif>
				</cfif>
				<cflocation addtoken="no" url="listaDocumentosCC.cfm?#params#">
			</cfif>

			<cfif isdefined('form.EDid') and Len(Trim(EDid)) NEQ 0 >
				<cfquery name="rsLineas" datasource="#Session.DSN#">
					select
						a.EDid,
						a.DDlinea,
						a.Aid,
						a.Cid,
						a.DDdescripcion,
						a.DDdescalterna,
						a.DDcantidad,
						a.DDpreciou,
						a.DDdesclinea,
						a.DDporcdesclin,
						a.DDtotallinea,
						case
							when a.DDtipo = 'O' and oc.OCtipoIC='V' then 'OV' else a.DDtipo
						end as DDtipo,
						a.Ccuenta,
						a.Alm_Aid,
						a.Dcodigo,
						a.Icodigo,
						a.ts_rversion,
						isnull(a.DDMontoIEPS,0) DDMontoIEPS
					from EDocumentosCxC b
						inner join DDocumentosCxC a
							left outer join OCordenComercial oc
								on oc.OCid = a.CFid
							on a.EDid = b.EDid
					where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDid#">
					  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					order by DDlinea
				</cfquery>
				<cfquery name="rsTotalLineas" dbtype="query">
					select sum(DDpreciou) as PrecioUnit, sum(DDtotallinea)+sum(DDMontoIEPS) as TotalLinea
					from rsLineas
				</cfquery>
			</cfif>

<cfset LB_linea = t.Translate('LB_linea','Línea')>
<cfset LB_descripcion = t.Translate('LB_DESCRIPCION','Descripci&oacute;n','/sif/generales.xml')>
<cfset LB_cantidad = t.Translate('LB_Cantidad','Cantidad')>
<cfset LB_PrecioU = t.Translate('LB_PrecioU','Precio Unit')>
<cfset LB_Totales = t.Translate('LB_Totales','Totales')>

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td><cfinclude template="formRegistroDocumentosCC.cfm">&nbsp;</td></tr>
				<cfif isdefined('form.EDid') and Len(Trim(form.EDid)) NEQ 0 and not isDefined("Form.Aplicar")>
					<tr>
						<td class="subTitulo">

							<!--- registro seleccionado --->
							<cfif isDefined("DDlinea") and Len(Trim(DDlinea)) GT 0 >
								<cfset seleccionado = DDlinea ><cfelse><cfset seleccionado = "" >
							</cfif>
							<form action="RegistroDocumentosCC.cfm?tipo=<cfoutput>#form.tipo#</cfoutput>" method="post" name="form2">
								<input name="datos" type="hidden" value="">
								<cfif isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))>
									<input type="hidden" name="SNidentificacion" value="<cfoutput>#form.SNidentificacion#</cfoutput>">
								</cfif>
								<input name="tipo" type="hidden" value="<cfoutput>#form.tipo#</cfoutput>">
								<!--- Para Borrado desde la lista --->
								<input type="hidden" name="EDid" value="<cfoutput>#form.EDid#</cfoutput>">
								<input type="hidden" name="DDlinea" value="">
								<input type="hidden" name="BajaDet" value="BajaDet">
								<input type="hidden" name="SNcodigo" value="">
								<!--- --------------------------- --->

								<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                	<cfoutput>
									<tr bgcolor="E2E2E2" class="subTitulo">
										<td width="2%">&nbsp;</td>
										<td width="5%"><strong>&nbsp;#LB_linea#</strong></td>
										<td width="5%"><strong>&nbsp;Item&nbsp;</strong></td>
										<td width="18%"><strong>#LB_descripcion#</strong></td>
										<td width="13%"> <div align="Center"><strong>#LB_cantidad#</strong></div></td>
										<td width="13%"> <div align="right"><strong>#LB_PrecioU#.</strong></div></td>
										<td width="13%"> <div align="right"><strong>#LB_Desc#.</strong></div></td>
										<td width="13%"> <div align="right"><strong>#LB_IEPS#.</strong></div></td>
										<td width="16%"> <div align="right"><strong>Total</strong></div></td>
										<td width="3%">&nbsp;</td>
									</tr>
									</cfoutput>
									<cfoutput query="rsLineas">
										<tr style="cursor: pointer;"
											onClick="javascript:Editar('#rsLineas.EDid#','#rsLineas.DDlinea#','#params#');"
											onMouseOver="javascript: style.color = 'red'"
											onMouseOut="javascript: style.color = 'black'"
											<cfif rsLineas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td><div align="right">
												<cfif modoDet NEQ 'ALTA' and rsLineas.DDlinea EQ seleccionado>
													<img src="/cfmx/sif/imagenes/addressGo.gif" height="12" width="15" border="0">
												</cfif></div>
											</td>
											<td align="center">#rsLineas.CurrentRow#</td>
											<td align="center">#rsLineas.DDtipo#</td>
											<td>#rsLineas.DDdescripcion#</td>
											<td><div align="Center">#LSCurrencyFormat(rsLineas.DDcantidad,'none')#</div></td>
											<td><div align="right">#LSCurrencyFormat(rsLineas.DDpreciou,'none')#</div></td>
											<td><div align="right">#LSCurrencyFormat(rsLineas.DDdesclinea,'none')#</div></td>
											<td><div align="right">#LSCurrencyFormat(rsLineas.DDMontoIEPS,'none')#</div></td>
											<td><div align="right">#LSCurrencyFormat(rsLineas.DDtotallinea + rsLineas.DDMontoIEPS,'none')#</div></td>
											<td width="3%">&nbsp;
												<a href="javascript:borrar('#rsLineas.EDid#','#rsLineas.DDlinea#');">
												<img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar Detalle">
												</a>
											</td>

										</tr>
									</cfoutput>

									<cfif rsLineas.Recordcount GT 0>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td><font size="1">&nbsp;</font></td>
											<td><font size="1">&nbsp;</font></td>
											<td>&nbsp;</td>
											<td width="13%">&nbsp;</td>
											<td width="13%">&nbsp;</td>
											<td><div align="right"><font size="1"><strong><cfoutput>#LB_Totales#:</cfoutput></strong></font></div></td>
											<td>
												<div align="right"><font size="1"><strong>
												<cfoutput>#LSCurrencyFormat(rsTotalLineas.TotalLinea,'none')#</cfoutput>
												</strong></font></div>
											</td>
											<td width="3%">&nbsp;</td>
										</tr>
									</cfif>
								</table>
								<!--- ======================================================================= --->
								<!--- NAVEGACION --->
								<!--- ======================================================================= --->
								<cfoutput>
								<input type="hidden" name="Filtro_CCTdescripcion" value="<cfif isdefined('form.Filtro_CCTdescripcion') and len(trim(form.Filtro_CCTdescripcion)) >#form.Filtro_CCTdescripcion#</cfif>" />
								<input type="hidden" name="Filtro_EDdocumento" value="<cfif isdefined('form.Filtro_EDdocumento') and len(trim(form.Filtro_EDdocumento))>#form.Filtro_EDdocumento#</cfif>" />
								<input type="hidden" name="Filtro_EDfecha" value="<cfif isdefined('form.Filtro_EDfecha') and len(trim(form.Filtro_EDfecha))>#form.Filtro_EDfecha#</cfif>" />
								<input type="hidden" name="Filtro_EDusuario" value="<cfif isdefined('form.Filtro_EDusuario') and len(trim(form.Filtro_EDusuario))>#form.Filtro_EDusuario#</cfif>" />
								<input type="hidden" name="Filtro_Mnombre" value="<cfif isdefined('form.Filtro_Mnombre') and len(trim(form.Filtro_Mnombre))>#form.Filtro_Mnombre#</cfif>" />
								<cfif isdefined('form.Filtro_FechasMayores')>
								<input type="hidden" name="Filtro_FechasMayores" value="#form.Filtro_FechasMayores#" />
								</cfif>
								<input type="hidden" name="Pagina" value="<cfif isdefined('form.Pagina') >#form.Pagina#</cfif>" />
								</cfoutput>
								<!--- ======================================================================= --->
								<!--- ======================================================================= --->
							</form>
						</td>
					</tr>
				</cfif>
			</table>

<cfset MSG_BorrarReg = t.Translate('MSG_BorrarReg','Desea Eliminar el Registro')>
            <cfoutput>
			<script language="JavaScript1.2">
				function Editar(doc,linea,params) {
					if (doc!="" && linea != "") {
						<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> //<!--- Facturas --->
							location.href = 'RegistroFacturas.cfm?EDid=' + doc + '&DDlinea=' + linea + '&' + params;
						<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> //<!--- Notas de Crédito --->
							location.href = 'RegistroNotasCredito.cfm?EDid=' + doc + '&DDlinea=' + linea + '&' + params;
						</cfif>
					}
					return false;
				}

				function borrar(documento, linea){
					if ( confirm('¿#MSG_BorrarReg#?') ) {
						document.form2.action = "SQLRegistroDocumentosCC.cfm";
						document.form2.EDid.value = documento;
						document.form2.DDlinea.value = linea;
						document.form2.submit();
					}else{
						document.form2.DDlinea.value = '';
						document.form2.submit();
					}
				}
			</script>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>



