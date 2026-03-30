<!--- El Ecodigo de la session se mete en una variable para poder cancelar ordenes de diversas empresas que no se en la que estoy actualmente, para eso el ecodigo debe de ser pasado --->
<cfparam name="form.Ecodigo_f" default="#session.Ecodigo#">
<cfif isdefined("form.btnAnular")>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfset form.EOidorden = form.chk>
	</cfif>

	<cfquery name="rsOrden" datasource="#session.DSN#">
		Select 	DOcantsurtida,
				coalesce(DOcantidad,0) as DOcantidad,
				esc.ESidsolicitud,
				DScantsurt,
				EOestado,
				ESestado,
				eor.EOfecha,
				so.DSlinea,
				dor.Aid,
				dor.Cid,
				dor.ACcodigo,
				dor.ACid,				
				eor.SNcodigo,
				(coalesce(dor.DOcantidad,0) - coalesce(dor.DOcantsurtida,0)) as DOcantDisponible,
				eor.EOidorden, 	
				dor.DOlinea
		from EOrdenCM eor
			left outer join DOrdenCM dor
				on dor.Ecodigo=eor.Ecodigo
					and dor.EOidorden=eor.EOidorden
		
			left outer join ESolicitudCompraCM esc
				on esc.Ecodigo=dor.Ecodigo
					and esc.ESidsolicitud=dor.ESidsolicitud
		
			left outer join DSolicitudCompraCM so
					on so.Ecodigo=esc.Ecodigo
					and so.ESidsolicitud=esc.ESidsolicitud
					and so.DSlinea=dor.DSlinea
		where eor.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo_f#">
			and eor.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
			and EOestado in (-8,0,5,7,8,10,9) 		/* =10*/
	</cfquery>
	<cfif isdefined('rsOrden') and rsOrden.recordCount EQ 0>
		<cf_errorCode	code = "50282" msg = "La orden de compra no se encontró en la base de datos !. Proceso cancelado">
	<cfelse>
		<cftransaction>
		<!---///////////////////////////// ACTUALIZAR LA CANTIDAD SURTIDA DEL CONTRATO //////////////////////////---->
			<!---<cfif rsOrden.EOestado EQ 8><!---Si la orden de compra fue generada por un contrato---->---->
				<cfloop query="rsOrden">
					<cfif len(trim(rsOrden.DOlinea)) and len(trim(rsOrden.SNcodigo))>
						<cfquery name="rsContratos" datasource="#session.DSN#"><!---Verificar para c/bien de la linea de la orden si esta en un contrato---->
							select 	dc.DClinea, dc.ECid, dc.Aid, dc.Cid, dc.ACid, ec.SNcodigo,
									coalesce(dc.DCcantsurtida,0) as DCcantsurtida,
									coalesce(dc.DCcantcontrato,0) as DCcantcontrato
							from CMOCContrato cmoc
	
								inner join DContratosCM dc
									on dc.ECid = cmoc.ECid
									and dc.Ecodigo = cmoc.Ecodigo
									<cfif len(trim(rsOrden.Aid))>
										and dc.Aid = #rsOrden.Aid#
									<cfelseif len(trim(rsOrden.Cid))>
										and dc.Cid = #rsOrden.Cid#
									<cfelse>
										and dc.ACid = #rsOrden.ACid#
									</cfif>
									
								inner join EContratosCM ec
									on ec.ECid = cmoc.ECid
									and ec.Ecodigo = cmoc.Ecodigo
									and ec.SNcodigo = cmoc.SNcodigo
	
							where cmoc.Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo_f#">
								and cmoc.DOlinea 	= #rsOrden.DOlinea#
								and cmoc.EOidorden 	= #rsOrden.EOidorden#
								and cmoc.SNcodigo 	= #rsOrden.SNcodigo#
						</cfquery>
						<cfif rsContratos.RecordCount NEQ 0><!---Si la línea esta en un contrato actualiza la cantidad surtida del contrato---->
							<cfquery datasource="#session.DSN#">
								update DContratosCM
								set DCcantsurtida = #rsContratos.DCcantsurtida# - (#rsOrden.DOcantDisponible#)
								where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo_f#">
									and ECid 	  = #rsContratos.ECid#
									and DClinea   = #rsContratos.DClinea#
							</cfquery>
							<!----Inserta en CMOCContrato---->
							<cfquery datasource="#session.DSN#">
								insert into CMOCContrato (DOlinea,
														EOidorden,
														Ecodigo,
														SNcodigo,
														ECid,
														CMOCCcantidad,
														BMUsucodigo,
														fechaalta)	
								values (#rsOrden.DOlinea#,
										#rsOrden.EOidorden#,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo_f#">,
										#rsContratos.SNcodigo#,
										#rsContratos.ECid#,
										- (#rsOrden.DOcantDisponible#),
										#session.Usucodigo#,
										<cf_dbfunction name="now">
										)														
							</cfquery>		
						</cfif><!---======= Fin del if de contratos ========== ------>
					</cfif><!----========== Fin del if de si hay detalles ==========------>
				</cfloop>
		
			<!--- El estado 70 es ANULADA ---->
			<cfquery datasource="#session.DSN#">
				update EOrdenCM
					set EOestado = 70
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo_f#">
					and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
					and EOestado in (-8,0,5,7,8,10,9)
			</cfquery>
		</cftransaction>
	</cfif>	
</cfif>	
<cflocation url="anulaOrden.cfm">