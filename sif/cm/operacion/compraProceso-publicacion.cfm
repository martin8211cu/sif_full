<cfif isdefined("Form.btnGuardar") and isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid))>

	<!--- estructura par aalmacenar los codigos de socios invitados --->
	<cfset correo = ArrayNew(1) >

	<cfquery name="rsDatosProcesoEncabezado" datasource="#Session.DSN#">
		select a.CMPid, a.CMPdescripcion, a.CMPfechapublica, a.CMPfmaxofertas, a.Usucodigo, a.CMIid, a.CMFPid, a.CMPnumero
		from CMProcesoCompra a
		where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfif rsDatosProcesoEncabezado.recordCount GT 0>
		<cfquery name="rsDatosProcesoDetalle" datasource="#Session.DSN#">
			select a.DSlinea, a.ESidsolicitud, b.DScant, b.DScant - b.DScantsurt as CantDisponible, b.Ucodigo, b.DSdescripcion, b.DSdescalterna, b.DSobservacion 
			from CMLineasProceso a, DSolicitudCompraCM b
			where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
			and a.ESidsolicitud = b.ESidsolicitud
			and a.DSlinea = b.DSlinea
		</cfquery>

		<cfquery name="rsDatosProveedoresCantidad" datasource="#Session.DSN#">
			select count(1) as cant
			from CMProveedoresProceso a
			where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfquery name="rsDatosNotas" datasource="#Session.DSN#">
			select CMNid, CMPid, CMNtipo, CMNnota, CMNresp, CMNtel, CMNemail
			from CMNotas
			where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
		</cfquery>
		
		<cfquery name="rsDatosAdjuntos" datasource="#Session.DSN#">
			select DDAid, CMPid, DSlinea, DDAnombre, DDAextension, DDAdocumento, Usucodigo, fechaalta
			from DDocumentosAdjuntos
			where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
		</cfquery>

		<!--- TODOS los proveedores fueron invitados --->
		<cfif rsDatosProveedoresCantidad.cant EQ 0>
			<cfquery name="rsDatosProveedores" datasource="asp">
				select distinct Usucodigo, llave as SNcodigo
				from UsuarioReferencia
				where STabla = 'SNegocios'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			</cfquery>
		<!--- Solamente fueron invitados ALGUNOS proveedores --->
		<cfelse>
			<cfquery name="rsDatosSocios" datasource="#Session.DSN#">
				select distinct b.SNcodigo
				from CMProveedoresProceso a, SNegocios b
				where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Ecodigo = b.Ecodigo
				and a.SNcodigo = b.SNcodigo
				and b.SNtiposocio <> 'C'
			</cfquery>
		
			<cfquery name="rsDatosProveedores" datasource="asp">
				select distinct Usucodigo, llave as SNcodigo
				from UsuarioReferencia
				where STabla = 'SNegocios'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
				and llave in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(rsDatosSocios.SNcodigo, ',')#" list="yes" separator=",">)
			</cfquery>
		</cfif>
		
		<cftransaction>
			<!--- Verifica si ya fue insertado el Proceso de Compra --->
			<cfquery name="selProcesoCompraPublica" datasource="sifpublica">
				select PCPid from ProcesoCompraProveedor
				where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
			</cfquery>
			<cfif selProcesoCompraPublica.RecordCount>
				<!---Actualiza el Encabezado del Proceso de Compra ---> 
				<cfquery name="updProcesoCompraPublica" datasource="sifpublica">
					update ProcesoCompraProveedor
						set CMPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoEncabezado.CMPdescripcion#">
						, CMPfechapublica = <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosProcesoEncabezado.CMPfechapublica#">
						, CMPfmaxofertas = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosProcesoEncabezado.CMPfmaxofertas#">
						, CMIid = <cfif isdefined("rsDatosProcesoEncabezado.CMIid") and Len(Trim(rsDatosProcesoEncabezado.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMIid#"><cfelse>null</cfif>
						, CMFPid = <cfif isdefined("rsDatosProcesoEncabezado.CMFPid") and Len(Trim(rsDatosProcesoEncabezado.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMFPid#"><cfelse>null</cfif>
						, CMPnumero = <cfif isdefined("rsDatosProcesoEncabezado.CMPnumero") and Len(Trim(rsDatosProcesoEncabezado.CMPnumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPnumero#"><cfelse>null</cfif>
						, cncache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.DSN#">
					where PCPid = #selProcesoCompraPublica.PCPid#
				</cfquery>
				<cfset PCPid = selProcesoCompraPublica.PCPid>
			<cfelse>
				<!--- Insercion del Encabezado del Proceso de Compra --->
				<cfquery name="insProcesoCompraPublica" datasource="sifpublica">
					insert into ProcesoCompraProveedor(CMPid, CMPdescripcion, CEcodigo, Ecodigo, EcodigoASP, UsucodigoC, CMPfechapublica, CMPfmaxofertas, cncache, Usucodigo, fechaalta, PCPestado, CMIid, CMFPid, CMPnumero)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoEncabezado.CMPdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosProcesoEncabezado.CMPfechapublica#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosProcesoEncabezado.CMPfmaxofertas#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.DSN#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						0,
						<cfif isdefined("rsDatosProcesoEncabezado.CMIid") and Len(Trim(rsDatosProcesoEncabezado.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMIid#"><cfelse>null</cfif>,
						<cfif isdefined("rsDatosProcesoEncabezado.CMFPid") and Len(Trim(rsDatosProcesoEncabezado.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMFPid#"><cfelse>null</cfif>,
						<cfif isdefined("rsDatosProcesoEncabezado.CMPnumero") and Len(Trim(rsDatosProcesoEncabezado.CMPnumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPnumero#"><cfelse>null</cfif>
					)
					<cf_dbidentity1 datasource="sifpublica">
				</cfquery>
				<cf_dbidentity2 datasource="sifpublica" name="insProcesoCompraPublica">
				<cfset PCPid = insProcesoCompraPublica.identity>
			</cfif>
			
			<!--- PUBLICACION DE LINEAS DE SOLICITUDES DE COMPRA EN UN PROCESO DE COMPRA NO PUBLICADO --->
			<cfif selProcesoCompraPublica.RecordCount eq 0>
				<cfloop query="rsDatosProcesoDetalle">
					<!--- Insercion de las lineas del Proceso de Compra --->
					<cfquery name="insProcesoCompraDetallePublica" datasource="sifpublica">
						insert into LineasProcesoCompras(PCPid, CEcodigo, Ecodigo, EcodigoASP, cncache, DSlinea, ESidsolicitud, DScant, Unidad, DSdescripcion, DSdescalterna, DSobservacion)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCPid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.DSN#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoDetalle.DSlinea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoDetalle.ESidsolicitud#">,
							<!---<cfqueryparam cfsqltype="cf_sql_float" 	 value="#rsDatosProcesoDetalle.DScant#">,---->
							<cfqueryparam cfsqltype="cf_sql_float" 	 value="#rsDatosProcesoDetalle.CantDisponible#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoDetalle.Ucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoDetalle.DSdescripcion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoDetalle.DSdescalterna#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoDetalle.DSobservacion#">
						)
						<cf_dbidentity1 datasource="sifpublica">
					</cfquery>
					<cf_dbidentity2 datasource="sifpublica" name="insProcesoCompraDetallePublica">
					<cfset LPCid = insProcesoCompraDetallePublica.identity>
					
					<!--- Insertar Documentos Adjuntos --->
					<cfquery name="docsAdjuntos" dbtype="query">
						select * from rsDatosAdjuntos
						where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
						and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoDetalle.DSlinea#">
					</cfquery>
					<cfif docsAdjuntos.recordCount>
						<!--- Falta DDAid --->
						<cfloop query="docsAdjuntos">
							<cfquery name="insDocs" datasource="sifpublica">
								insert into DDocumentosAdjuntos (DDAid, LPCid, CEcodigo, Ecodigo, EcodigoASP, DSlinea, Usucodigo, fechaalta, cncache)
								values (
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#docsAdjuntos.DDAid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#LPCid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#docsAdjuntos.DSlinea#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.DSN#">
								)
							</cfquery>
						</cfloop>
					</cfif>
					
				</cfloop>

			<!--- PUBLICACION DE LINEAS DE SOLICITUDES DE COMPRA EN UN PROCESO DE COMPRA YA PUBLICADO --->
			<cfelse>
				<cfloop query="rsDatosProcesoDetalle">
					<!--- Verifica si la linea de solicitud de compra ya había sido publicada --->
					<cfquery name="lineaProcesoCompra" datasource="sifpublica">
						select LPCid
						from LineasProcesoCompras
						where PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCPid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoDetalle.DSlinea#">
						and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoDetalle.ESidsolicitud#">
					</cfquery>
					<cfset LPCid = lineaProcesoCompra.LPCid>
					
					<!--- Modificacion de las lineas del Proceso de Compra --->
					<cfif Len(Trim(LPCid))>
						<cfquery name="insProcesoCompraDetallePublica" datasource="sifpublica">
							update LineasProcesoCompras set
								DSdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoDetalle.DSdescripcion#">,
								DSdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoDetalle.DSdescalterna#">,
								DSobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosProcesoDetalle.DSobservacion#">
							where LPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LPCid#">
						</cfquery>
	
						<!--- Actualización de Documentos Adjuntos --->
						<cfquery name="delAdjuntos" datasource="sifpublica">
							delete from DDocumentosAdjuntos
							where LPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LPCid#">
						</cfquery>
						<cfquery name="docsAdjuntos" dbtype="query">
							select * from rsDatosAdjuntos
							where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
							and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoDetalle.DSlinea#">
						</cfquery>
						<cfif docsAdjuntos.recordCount>
							<!--- Falta DDAid --->
							<cfloop query="docsAdjuntos">
								<cfquery name="insDocs" datasource="sifpublica">
									insert into DDocumentosAdjuntos (DDAid, LPCid, CEcodigo, Ecodigo, EcodigoASP, DSlinea, Usucodigo, fechaalta, cncache)
									values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#docsAdjuntos.DDAid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LPCid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#docsAdjuntos.DSlinea#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.DSN#">
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				
				</cfloop>
			</cfif>

			<!--- Insercion de los proveedores del Proceso de Compra invitados a participar --->
			<cfset index = 1 >
			<cfloop query="rsDatosProveedores">
				<cfquery name="selProveedoresProcesoCompra" datasource="sifpublica">
					select 1 from InvitadosProcesoCompra
					where PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCPid#">
					and UsuarioP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProveedores.Usucodigo#">
				</cfquery>
				<cfif selProveedoresProcesoCompra.RecordCount eq 0>
					<cfquery name="insProveedoresProcesoCompra" datasource="sifpublica">
						insert into InvitadosProcesoCompra(PCPid, UsuarioP)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCPid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProveedores.Usucodigo#">
						)
					</cfquery>
					
					<!--- estructura que guarda emails de proveedores invitados--->
					<cfset correo[index] = rsDatosProveedores.SNcodigo >
					<cfset index = index+1 >					
				</cfif>
			</cfloop>
			
			<!--- Insercion de las Notas asociadas al Proceso --->
			<cfquery name="insProcesoCompraNotas" datasource="sifpublica">
				delete from CMNotas
				where PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCPid#">
			</cfquery>
			<cfloop query="rsDatosNotas">
				<cfquery name="insProcesoCompraNotas" datasource="sifpublica">
					insert into CMNotas (PCPid, CMNtipo, CMNnota, CMNresp, CMNtel, CMNemail)
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCPid#">,
							<cf_dbfunction name="sPart"		args="'#RTRIM(rsDatosNotas.CMNtipo)#',1,100">,
							 <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#rsDatosNotas.CMNnota#" 	null="#NOT LEN(TRIM(rsDatosNotas.CMNnota))#">,
							 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#rsDatosNotas.CMNresp#" 	null="#NOT LEN(TRIM(rsDatosNotas.CMNresp))#">,
 							 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#rsDatosNotas.CMNtel#" 	null="#NOT LEN(TRIM(rsDatosNotas.CMNtel))#">,
							 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#rsDatosNotas.CMNemail#" null="#NOT LEN(TRIM(rsDatosNotas.CMNemail))#">)
				</cfquery>
			</cfloop>
		</cftransaction>
		<script language="javascript" type="text/javascript">
			<cfoutput>
				window.open('/cfmx/sif/cm/consultas/ProcesoCompra-email.cfm?CMPid=#rsDatosProcesoEncabezado.CMPid#','pagPrint','width=450,height=450,scrollbars=yes,resizable=yes');
			</cfoutput>
		</script>
        
		<!---<!--- Envia correo a proveedores invitados --->
		<cfif ArrayLen(correo) gt 0 >
			<cfinclude template="compraProceso-correo.cfm">
			<cfloop from="1" to="#ArrayLen(correo)#" index="i">
				<cfquery name="rsEmailProveedor" datasource="#session.DSN#">
					select SNemail 
					from SNegocios
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#correo[i]#">
				</cfquery>
                <cfquery name="rsContactoSN" datasource="#session.DSN#">
					select SNCemail 
					from SNContactos
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#correo[i]#">
                      and SNCarea = 1
				</cfquery>
                <cfset _mailBody = mailBody(correo[i])>
				<cfif len(trim(rsEmailProveedor.SNemail))>
					<cfquery datasource="asp">
						insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmailProveedor.SNemail#">,
								 'Invitación a Proceso de Compra',
								 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
					</cfquery>
				</cfif>
                <cfloop query="rsContactoSN">
                	<cfif len(trim(rsContactoSN.SNCemail))>
                        <cfquery datasource="asp">
                            insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                            values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
                                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsContactoSN.SNCemail#">,
                                     'Invitación a Proceso de Compra(Copia para Proveduría)',
                                     <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
                        </cfquery>
                    </cfif>
                </cfloop>
			</cfloop>
		</cfif>
--->		
		<cftransaction>
			<!--- Actualizacion del Estado de los proveedores publicados --->
			<cfloop query="rsDatosProveedores">
				<cfquery name="updProveedor" datasource="#Session.DSN#">
					update CMProveedoresProceso
						set CMPpublicado = 1
					where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosProveedores.SNcodigo#">
				</cfquery>
			</cfloop>
			<!--- Actualizacion del Estado del Proceso de Compra a Publicado --->
			<cfquery name="updProceso" datasource="#Session.DSN#">
				update CMProcesoCompra
				set CMPestado = 10
				where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosProcesoEncabezado.CMPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

		</cftransaction>
			
		<cfset StructDelete(Session.Compras, "ProcesoCompra")>
		<cfset Session.Compras.ProcesoCompra = StructNew()>
		<cfset Session.Compras.ProcesoCompra.Pantalla = "1">
		<cfset Session.Compras.ProcesoCompra.PrimeraVez = true>

	</cfif>

<cfelseif isdefined("form.btnAceptar") and isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid))>
	<!--- Actualizacion del Estado del Proceso de Compra --->
	<cfquery name="updProceso" datasource="#Session.DSN#">
		update CMProcesoCompra
		set CMPestado = 10
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfset proceso = Session.Compras.ProcesoCompra.CMPid >
	<cfset StructDelete(Session.Compras, "ProcesoCompra")>
	<cfset Session.Compras.ProcesoCompra = StructNew()>
	<cfset Session.Compras.ProcesoCompra.Pantalla = "1">
	<cfset Session.Compras.ProcesoCompra.PrimeraVez = true>
<cfelseif isdefined("form.btnSolicitante") and isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid))>
	<!--- Actualizacion del Estado del Proceso de Compra --->
    <cf_dbfunction name="to_char" args="de.DEid" isInteger="true" returnvariable="toCharDEid">
    <cfquery name="rsAprobador" datasource="#session.DSN#">
        select distinct de.DEid, de.DEemail as email
        from CMProcesoCompra pc
            inner join CMLineasProceso lp
                on lp.CMPid = pc.CMPid
            inner join ESolicitudCompraCM sc
                on sc.ESidsolicitud = lp.ESidsolicitud
            inner join WfxActivity xa
                inner join WfxActivityParticipant xap
                    inner join UsuarioReferencia ur
                    	inner join DatosEmpleado de
                        	on #toCharDEid# = ur.llave and de.Ecodigo = #session.Ecodigo#
                        on ur.Usucodigo  = xap.Usucodigo and ur.Ecodigo = #session.EcodigoSDC# and ur.STabla = 'DatosEmpleado'
                    on xap.ActivityInstanceId = xa.ActivityInstanceId and xap.HasTransition = 1
                on xa.ProcessInstanceId = sc.ProcessInstanceid 
        where pc.Ecodigo = 1
        and pc.CMPestado in (0,10)
        and pc.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
        and xa.FinishTime = (select max(sxa.FinishTime)
                            from WfxActivity sxa
                                inner join WfxActivityParticipant sxap
                                    on sxap.ActivityInstanceId = sxa.ActivityInstanceId
                            where sxa.ProcessInstanceId = sc.ProcessInstanceid)
   	</cfquery>
    <cfquery name="rsDatosProcesoEncabezado" datasource="#Session.DSN#">
        select CMPid, CMPdescripcion, CMPnumero
        from CMProcesoCompra
        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
        and Ecodigo = #Session.Ecodigo#
    </cfquery>
    <cftransaction>
    	<cftry>
            <cfquery name="updProceso" datasource="#Session.DSN#">
                update CMProcesoCompra
                set CMPestado = 79 <!--- Buscar un estado, por el momento este es temporal --->
                where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
                and Ecodigo = #Session.Ecodigo#
            </cfquery>
            <cfloop query="rsAprobador">
                <cfif len(trim(rsAprobador.email))>
                    <cfinclude template="compraProceso-correo.cfm">
                    <cfset _mailBody = mailBodyCotizacion(rsAprobador.DEid)>
                    <cf_jdbcquery_open datasource="asp" update="yes">
                        insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                        values ( <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
                                 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsAprobador.email#">,
                                 'Iniciar la Evaluación de Cotizaciones(Solicitante)',
                                 <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
                    </cf_jdbcquery_open>
                </cfif>
            </cfloop>
    	<cfcatch type="any">
       	 	<cftransaction action="rollback">
        	<cf_jdbcquery_close>
        </cfcatch>
        </cftry>
        <cf_jdbcquery_close>
    </cftransaction>
	<cfset proceso = Session.Compras.ProcesoCompra.CMPid >
    <cfset StructDelete(Session.Compras, "ProcesoCompra")>
    <cfset Session.Compras.ProcesoCompra = StructNew()>
    <cfset Session.Compras.ProcesoCompra.Pantalla = "1">
    <cfset Session.Compras.ProcesoCompra.PrimeraVez = true>
<cfelse>
	<cfset Session.Compras.ProcesoCompra.Pantalla = "4">
</cfif>

<cfoutput>
	<form action="compraProceso.cfm" method="post" name="sql">
		<input type="hidden" name="opt" value="#Session.Compras.ProcesoCompra.Pantalla#">
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
