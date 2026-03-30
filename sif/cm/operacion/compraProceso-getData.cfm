<!--- Ingreso a Pantalla de Seleccion de Solicitudes, se cargan los itemes seleccionados despues de haber seleccionado el proceso de compra --->
<cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "1">

	<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid))>
		<cfquery name="rsItemsProceso" datasource="#Session.DSN#">
			select DSlinea
			from CMLineasProceso
			where CMPid = #Session.Compras.ProcesoCompra.CMPid#
			order by ESidsolicitud, DSlinea
		</cfquery>		
		<cfset Session.Compras.ProcesoCompra.DSlinea = ValueList(rsItemsProceso.DSlinea, ',')>
        <cfif lvarProvCorp and len(trim(Session.Compras.ProcesoCompra.DSlinea)) gt 0>
        	<cfquery name="rsSolEcodigo" datasource="#Session.DSN#">
                select Ecodigo
                from DSolicitudCompraCM
                where DSlinea in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.DSlinea#" list="yes">)
            </cfquery>
    		<cfset Session.Compras.ProcesoCompra.Ecodigo = rsSolEcodigo.Ecodigo>
            <cfset lvarFiltroEcodigo = Session.Compras.ProcesoCompra.Ecodigo>
        </cfif>
	</cfif>

<!--- Ingreso a Pantalla de proceso de compra, se actualiza en session las lineas seleccionadas en el paso 1--->
<cfelseif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "2">
	<cfif isdefined("Form.btnGuardar")>
		<cfset Items = "">
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("DSlinea_", i) NEQ 0>
				<cfset Items = Items & Iif(Len(Trim(Items)), DE(","), DE("")) & Trim(StructFind(Form, i))>
			</cfif>
		</cfloop>
		<cfif Len(Trim(Items))>
			<cfset StructInsert(Session.Compras.ProcesoCompra, "DSlinea", Items, true)>
		</cfif>
		<!--- Si ya hay un proceso de compras creado debe actualizarse los datos del detalle del proceso de compra --->
		<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid))>
			<cftransaction>
				<cfquery name="delDetalleCompras" datasource="#Session.DSN#">
					delete from CMLineasProceso
					where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
				</cfquery>
				<cfloop list="#Session.Compras.ProcesoCompra.DSlinea#" index="linea" delimiters=","><cfdump var="L:#linea#">
					<cfquery name="insDetalleCompras" datasource="#Session.DSN#">
						insert into CMLineasProceso(CMPid, DSlinea, ESidsolicitud, Usucodigo, fechaalta)
						select 
							#Session.Compras.ProcesoCompra.CMPid#,
							DSlinea,
							ESidsolicitud,
							#Session.Usucodigo#,
							<cf_dbfunction name="now">
						from DSolicitudCompraCM
						where DSlinea = #linea#
						and Ecodigo   =  #lvarFiltroEcodigo# 
					</cfquery>					
				</cfloop>
			</cftransaction>
		</cfif>
	</cfif>
	
<!--- Ingreso a Pantalla de Invitación de Proveedores, se Guardan los datos del Encabezado del Proceso de Compra --->
<cfelseif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "3">
	<cfif isdefined("Form.btnGuardar")>
		<cfif not isdefined("Session.Compras.ProcesoCompra.CMPid") or NOT Len(Trim(Session.Compras.ProcesoCompra.CMPid))>
			<cftransaction>
				<!--- Encabezado del Proceso de Compra --->
				<cfquery name="rsGetSiguiente" datasource="#session.DSN#">
					select coalesce(max(CMPnumero),0.00) + 1 as Siguiente
					from CMProcesoCompra
					where Ecodigo =  #Session.Ecodigo# 
				</cfquery>
				<cfset LCMPnumero = rsGetSiguiente.Siguiente>
				<!--- Calculo de Horas para la Fecha Maxima de Cotizacion --->
				<cfif Form.ampm EQ 'PM'>
					<cfif Form.hcotizacion EQ 12>
						<cfset hora = Form.hcotizacion>
					<cfelse>
						<cfset hora = Form.hcotizacion + 12>
					</cfif>
				<cfelse>
					<cfif Form.hcotizacion EQ 12>
						<cfset hora = 0>
					<cfelse>
						<cfset hora = Form.hcotizacion>
					</cfif>
				</cfif>
				<cfset segundos = DateDiff('s', CreateTime(0,0,0), CreateTime(hora, Form.mcotizacion, 0))>

				<cfquery name="insProcesoCompra" datasource="#Session.DSN#">
					insert into CMProcesoCompra(Ecodigo, CMPdescripcion, GCcritid, Usucodigo, fechaalta, CMPfechapublica, CMPfmaxofertas, CMCid, CMPnumero, CMFPid, CMIid, CMPestado,CMTPid,TGidP,TGidC,CMPcodigoProceso)
					values(
						 #Session.Ecodigo# ,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMPdescripcion#">,
						<cfif Form.GCcritid NEQ 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GCcritid#">,
						<cfelse>
							null,
						</cfif>
						 #Session.Usucodigo# ,
						<cf_dbfunction name="now">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CMPfechapublica)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', segundos, LSParseDateTime(Form.CMPfmaxofertas))#">,
						#Session.Compras.Comprador#,
						#LCMPnumero#,
						<cfif isdefined("form.CMFPid") and Len(Trim(form.CMFPid)) and form.CMFPid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
						<cfif isdefined("form.CMIid") and Len(Trim(form.CMIid)) and form.CMIid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
						0,
						<cfif isdefined("form.CMTPid") and Len(Trim(form.CMTPid)) and form.CMTPid NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMTPid#"> <cfelse> null </cfif>,
						<cfif isdefined("form.TipoP") and Len(Trim(form.TipoP)) and form.TipoP NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TipoP#"> <cfelse> null </cfif>,
						<cfif isdefined("form.TipoC") and Len(Trim(form.TipoC)) and form.TipoC NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TipoC#"> <cfelse> null </cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMPcodigoProceso#">
					)
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="insProcesoCompra">
				<cfset Session.Compras.ProcesoCompra.CMPid = insProcesoCompra.identity>
				<cfset Session.Compras.ProcesoCompra.CMPestado = 0>
				<cfset modo = "CAMBIO">
				
				<!--- Insercion de los criterios de la compra --->
				<cfloop collection="#Form#" item="i">
					<cfif FindNoCase("CCid_", i) NEQ 0 and Form[i] NEQ 0>
						<cfset codcriterio = Mid(i, 6, Len(i))>
						<cfquery name="insCriterio" datasource="#Session.DSN#">
							insert into CMCondicionesProceso(CMPid, CCid, CPpeso, Usucodigo, fechaalta)
							values (
								#Session.Compras.ProcesoCompra.CMPid#,
								#codcriterio#,
								<cfqueryparam cfsqltype="cf_sql_float" value="#Form[i]#">,
								 #Session.Usucodigo# ,
								<cf_dbfunction name="now">
							)
						</cfquery>
					</cfif>
				</cfloop>
				<!--- Insercion de las lineas del detalle de compra --->
				<cfloop list="#Session.Compras.ProcesoCompra.DSlinea#" index="linea" delimiters=",">
					<cfquery name="insDetalleCompras" datasource="#Session.DSN#">
						insert into CMLineasProceso(CMPid, DSlinea, ESidsolicitud, Usucodigo, fechaalta)
						select 
							#Session.Compras.ProcesoCompra.CMPid#,
							DSlinea,
							ESidsolicitud,
							#Session.Usucodigo#,
							<cf_dbfunction name="now">
						from DSolicitudCompraCM
						where DSlinea = #linea#
						and Ecodigo =  #lvarFiltroEcodigo# 
					</cfquery>
				</cfloop>
				<!----  Inclusion de Actividades en tabla de Notas cuando se crea el encabezado inicialmente------>
					<cfif isdefined('form.CMTPid')>
					   <cfquery name="rsActividadesProceso" datasource="#Session.DSN#">
					   select 
					          CMTPid,
						      CMTPAid,
    	                      CMTPAdescripcionActividad,
		                      CMTPAduracion 
						  from CMTPActividades
						    where CMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPid#">					      
					   </cfquery>
					   <cfloop query="rsActividadesProceso">
						   <cfquery name="insDetalleCompras" datasource="#Session.DSN#">
								insert into CMNotas(
								CMPid,   <!---ID del proceso---->
								CMTPAid, <!---ID de la  Actividad---->
								CMNtipo, <!---Descripcion de la Actividad---->
								Usucodigo,
								fechaalta,
								CMNdiasDuracion,
								CMNestado								
								)
								values(
								#Session.Compras.ProcesoCompra.CMPid#,
								#rsActividadesProceso.CMTPAid#,
								'#rsActividadesProceso.CMTPAdescripcionActividad#',
								#Session.Usucodigo#,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								#rsActividadesProceso.CMTPAduracion#,
								0
								)						
						    </cfquery>
					   </cfloop>					
				  </cfif>				
			</cftransaction>
	
		<cfelse>
			<cftransaction>
				<!--- Calculo de Horas para la Fecha Maxima de Cotizacion --->
				<cfif Form.ampm EQ 'PM'>
					<cfif Form.hcotizacion EQ 12>
						<cfset hora = Form.hcotizacion>
					<cfelse>
						<cfset hora = Form.hcotizacion + 12>
					</cfif>
				<cfelse>
					<cfif Form.hcotizacion EQ 12>
						<cfset hora = 0>
					<cfelse>
						<cfset hora = Form.hcotizacion>
					</cfif>
				</cfif>
				
				<cfset segundos = DateDiff('s', CreateTime(0,0,0), CreateTime(hora, Form.mcotizacion, 0))>
				<!--- Encabezado del Proceso de Compra --->
				<cfquery name="updProcesoCompra" datasource="#Session.DSN#">
					update CMProcesoCompra
					set
						CMPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMPdescripcion#">,
						<cfif Form.GCcritid NEQ 0>
							GCcritid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GCcritid#">,
						<cfelse>
							GCcritid = null,
						</cfif>
						Usucodigo =  #Session.Usucodigo# ,
						fechaalta = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						CMPfechapublica = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CMPfechapublica)#">,
						CMPfmaxofertas = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', segundos, LSParseDateTime(Form.CMPfmaxofertas))#">,
						CMFPid = <cfif isdefined("form.CMFPid") and Len(Trim(form.CMFPid)) and form.CMFPid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
						CMIid  = <cfif isdefined("form.CMIid") and Len(Trim(form.CMIid)) and form.CMIid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
						CMTPid = <cfif isdefined("form.CMTPid") and Len(Trim(form.CMTPid)) and form.CMTPid NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMTPid#"> <cfelse> null </cfif>,
						TGidP  = <cfif isdefined("form.TipoP") and Len(Trim(form.TipoP)) and form.TipoP NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TipoP#"> <cfelse> null </cfif>,
						TGidC	 = <cfif isdefined("form.TipoC") and Len(Trim(form.TipoC)) and form.TipoC NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TipoC#"> <cfelse> null </cfif>,
						CMPcodigoProceso=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMPcodigoProceso#">
					where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
					and Ecodigo =  #Session.Ecodigo# 
				</cfquery>
				
				<!--- Actualizacion de los criterios de compra --->
				<cfquery name="updCriterios" datasource="#Session.DSN#">
					delete from CMCondicionesProceso
					where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
				</cfquery>
				<cfloop collection="#Form#" item="i">
					<cfif FindNoCase("CCid_", i) NEQ 0 and Form[i] NEQ 0>
						<cfset codcriterio = Mid(i, 6, Len(i))>
						<cfquery name="insCriterio" datasource="#Session.DSN#">
							insert into CMCondicionesProceso(CMPid, CCid, CPpeso, Usucodigo, fechaalta)
							values (
								#Session.Compras.ProcesoCompra.CMPid#,
								#codcriterio#,
								#Form[i]#,
								 #Session.Usucodigo# ,
								<cf_dbfunction name="now">
							)
						</cfquery>
					</cfif>
				</cfloop>
				  <!----  Inclusion de Actividades en tabla de Notas cuando se creo el encabezado sin indicarle el tipo de proceso y si se da modo cambio se ingresan las actividades------>
					<cfif isdefined('form.CMTPid')>
					   <cfquery name="rsActividadesProceso" datasource="#Session.DSN#">
					   select 
					          CMTPid,
						      CMTPAid,
    	                      CMTPAdescripcionActividad,
		                      CMTPAduracion 
						  from CMTPActividades
						    where CMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPid#">	<!----Obtengo todas las actividades a partir del proceso que se eligió----->				      
					   </cfquery>
					   <cfloop query="rsActividadesProceso">
						   <cfquery name="insDetalleCompras" datasource="#Session.DSN#">
								insert into CMNotas(
								CMPid,   <!---ID del proceso---->
								CMTPAid, <!---ID de la  Actividad---->
								CMNtipo, <!---Descripcion de la Actividad---->
								Usucodigo,
								fechaalta,
								CMNdiasDuracion,
								CMNestado								
								)
								values(
								#Session.Compras.ProcesoCompra.CMPid#,
								#rsActividadesProceso.CMTPAid#,
								'#rsActividadesProceso.CMTPAdescripcionActividad#',
								#Session.Usucodigo#,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								#rsActividadesProceso.CMTPAduracion#,
								0
								)						
						    </cfquery>
					   </cfloop>					
				  </cfif>					
			</cftransaction>
		</cfif>
		
		<!--- Update de las observacione,descalternas del detalle de la solicitud de compra (DSolicitudCompraCM)--->
		<cfloop list="#form.DSlinea#" index="i" delimiters=",">
			<cfquery name="updSolicitudes" datasource="#session.DSN#">
				update DSolicitudCompraCM
				set DSobservacion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Mid(form['DSobservacion#i#'],1,255)#">,
					DSdescalterna = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Mid(form['DSdescalterna#i#'],1,1024)#">
				where DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				and Ecodigo =  #Session.Ecodigo# 
			</cfquery>
		</cfloop>
	</cfif>

<!--- Ingreso a Pantalla de Resumen de Proceso de Compra, Guardar los datos de la invitación de Proveedores --->
<cfelseif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "4">
	<cfif isdefined("Form.btnGuardar") or isdefined("Form.btnGuardarEsp")>
		<cftransaction>
			<!--- Buscar la manera de eliminar únicamente los proveedores mostrados --->
			<cfquery name="delProveedores" datasource="#Session.DSN#">
				delete from CMProveedoresProceso
				where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
				and Ecodigo =  #Session.Ecodigo# 
				<cfif isdefined("Form.prov") and Len(Trim(Form.prov))>
				and SNcodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.prov#" list="yes" separator=",">)
				</cfif>
				and CMPpublicado = 0
			</cfquery>
			<cfif isdefined("Form.chk")>
				<cfloop list="#Form.chk#" index="proveedor" delimiters=",">
					<cfquery name="insProveedor" datasource="#Session.DSN#">
						insert into CMProveedoresProceso (CMPid, Ecodigo, SNcodigo, Usucodigo, fechaalta, CMPpublicado)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">,
							 #Session.Ecodigo# ,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#proveedor#">,
							 #Session.Usucodigo# ,
							<cf_dbfunction name="now">,
							0
						)
					</cfquery>
				</cfloop>
			</cfif>
		</cftransaction>
	</cfif>
	<cfif isdefined("Form.btnGuardarEsp")>
		<cfset Session.Compras.ProcesoCompra.Pantalla = 3>
	</cfif>

<!--- Eliminación de Proceso de Compra desde pantalla de Lista de Procesos --->
<cfelseif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "0">
	<cfif isdefined("Form.btnEliminar") or isdefined('Form.btnAnular_Proceso')>
    	<cfinclude template="compraProceso-correo.cfm">
		<cftransaction>
        	<cftry>
			<cfloop list="#Form.CMPid#" index="proceso" delimiters=",">
            	<cfquery name="rsDatosProcesoEncabezado" datasource="#Session.DSN#">
					select CMPestado, CMPid, CMPdescripcion, CMPnumero
                    from CMProcesoCompra
					where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
				</cfquery>
                
                <!---►►Publicado,Pediente de Aprobación Solicitante,Aprobado por Solicitante,Rechazado por Solicitante◄◄--->
            	<cfif listfind("10,79,81,83",rsDatosProcesoEncabezado.CMPestado)>
                	<cfquery name="rsProveedores" datasource="#Session.DSN#">
                        select sn.SNemail, sn.SNid
                        	from CMProveedoresProceso pp
                            	inner join SNegocios sn
                                	on sn.Ecodigo = pp.Ecodigo and sn.SNcodigo = pp.SNcodigo
                        where pp.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                        and pp.Ecodigo =  #Session.Ecodigo# 
                    </cfquery>
                    <cfloop query="rsProveedores">
						<cfif len(trim(rsProveedores.SNemail)) gt 0>
                            <cfset _mailBody = mailProveedorCotizacion(rsProveedores.SNid)>
                            <cf_jdbcquery_open datasource="asp" update="yes">
                                insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                                values ( <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
                                         <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsProveedores.SNemail#">,
                                         'Anulacion de Proceso de Publicación de Compra',
                                         <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
                            </cf_jdbcquery_open>
                        </cfif>
                    </cfloop>
                    <cfquery datasource="#Session.DSN#">
                        update CMProcesoCompra
                        set CMPestado = 85 <!--- Buscar un estado, por el momento este es temporal --->
                        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                        and Ecodigo = #Session.Ecodigo#
                    </cfquery>
                <!---►►0-No publicado◄◄--->
                <cfelseif listfind("0",rsDatosProcesoEncabezado.CMPestado)>
                    <cfquery name="delProveedores" datasource="#Session.DSN#">
                        delete from CMProveedoresProceso
                        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                        and Ecodigo =  #Session.Ecodigo# 
                    </cfquery>
                    
                    <cfquery name="delCondiciones" datasource="#Session.DSN#">
                        delete from CMCondicionesProceso
                        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                    </cfquery>
                    
                    <cfquery name="delDocsAdjuntos" datasource="#Session.DSN#">
                        delete from DDocumentosAdjuntos
                        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                    </cfquery>
                    
                    <cfquery name="delLineasProceso" datasource="#Session.DSN#">
                        delete from CMLineasProceso
                        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                    </cfquery>
                    
                    <!----Se agregó delete de notas en DP el 22-Sep-2005--->
                    <cfquery name="delNotas" datasource="#Session.DSN#">
                        delete from CMNotas
                        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                    </cfquery>				
                    
                    <cfquery name="delProceso" datasource="#Session.DSN#">
                        delete from CMProcesoCompra
                        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proceso#">
                        and Ecodigo =  #Session.Ecodigo# 
                    </cfquery>
                <!---►►Orden de Compra y Anulados◄◄--->
                <cfelse>
                	<cfthrow message="El estado del Proceso no permite su anulación">
				</cfif>
			</cfloop>
            <cfcatch type="any">
                <cftransaction action="rollback">
                <cf_jdbcquery_close>
                <cfdump var="#cfcatch.message#"><br />
                <cfdump var="#cfcatch.detail#"><br />
                <cf_dump var="Ha Ocurrido un error, favor comuniquese con su proveedor del servicio. Fuente: CompraProceso-getData.cfm Linea: 409">
            </cfcatch>
            </cftry>
            <cf_jdbcquery_close>
		</cftransaction>

		<cfset StructDelete(Session.Compras, "ProcesoCompra")>
		<cfset Session.Compras.ProcesoCompra = StructNew()>
		<cfset Session.Compras.ProcesoCompra.Pantalla = "0">
		<cfset Session.Compras.ProcesoCompra.PrimeraVez = false>
        <cfif lvarProvCorp>
			<cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
            <cfset lvarFiltroEcodigo = Session.Compras.ProcesoCompra.Ecodigo>
        </cfif>	
	</cfif>
	
<!--- Nuevo Proceso de Compra --->	
<cfelseif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "9">
	<cfset StructDelete(Session.Compras, "ProcesoCompra")>
	<cfset Session.Compras.ProcesoCompra = StructNew()>
	<cfset Session.Compras.ProcesoCompra.Pantalla = "1">
	<cfset Session.Compras.ProcesoCompra.PrimeraVez = true>
    <cfif lvarProvCorp>
    	<cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
        <cfset lvarFiltroEcodigo = Session.Compras.ProcesoCompra.Ecodigo>
  	</cfif>	
</cfif>

<!--- Establecer el modo despues de carga de datos --->	
<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and LEN(TRIM(Session.Compras.ProcesoCompra.CMPid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!--- Establecer si el proceso está publicado --->
<cfset ProcesoPublicado = false>
<cfif (not isdefined("Session.Compras.ProcesoCompra.CMPid") OR NOT LEN(TRIM(Session.Compras.ProcesoCompra.CMPid)))  and isdefined("Form.CMPid")>
   <cfset Session.Compras.ProcesoCompra.CMPid = Form.CMPid>
<cfelseif isdefined("Session.Compras.ProcesoCompra.CMPid") and LEN(TRIM(Session.Compras.ProcesoCompra.CMPid))>
	<cfquery name="qryEstadoProceso" datasource="#session.dsn#">
		select CMPestado
		from CMProcesoCompra
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
	</cfquery>
	<cfset ProcesoPublicado = qryEstadoProceso.CMPestado gt 0>
</cfif>