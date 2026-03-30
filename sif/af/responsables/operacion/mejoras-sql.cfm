<cfif isdefined("form.alta")>
	<cfif len(trim(Form.CRDRfdocumento)) eq 0>
		<cfset form.CRDRfdocumento = dateformat(now(), 'DD/MM/YYYY')>
	</cfif>

	<cftransaction>	
		<cfquery name="rs_insert" datasource="#session.dsn#">
			insert into CRDocumentoResponsabilidad
				(AFRid, Ecodigo, CRTDid, DEid, CFid, ACcodigo, ACid, CRCCid, AFMid, AFMMid, CRDRplaca, CRDRdescripcion, CRDRdescdetallada, CRDRfdocumento, AFCcodigo, CRDRdocori, CRDRfalta, BMUsucodigo, CRDRestado,CRTCid,CRDRserie,AFCMejora,AFCMid)
			select 
			<!--- Requeridos --->
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFRid#">, 
			#Session.Ecodigo#, 
			afr.CRTDid, 
			afr.DEid, 
			afr.CFid, 
			act.ACcodigo, 
			act.ACid, 
			afr.CRCCid, 
			<!--- No Requeridos --->
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFMid1#">, 
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFMMid1#">, 
			act.Aplaca, 
			afr.CRDRdescripcion, 
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CRDRdescdetallada#" null="#len(Form.CRDRdescdetallada) eq 0#">, 
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CRDRfdocumento)#">,
			act.AFCcodigo, 
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CRDRdocori#" null="#len(Form.CRDRdocori) eq 0#">,
			<!--- Datos de Monitoreo --->
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
			#Session.Usucodigo#, 5,
			<cfif len(trim(Form.CRTCid))>
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CRTCid#">
			<cfelse>
				<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> 
			</cfif>,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CRDRserie#">,
            <cfif form.AFCMid gt 0>
            	<cf_jdbcquery_param cfsqltype="cf_sql_bit" value="1">,
            <cfelse>
            	<cf_jdbcquery_param cfsqltype="cf_sql_bit" value="0">,    
            </cfif>
            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFCMid#">
			from AFResponsables afr
				inner join Activos act
					on act.Ecodigo = afr.Ecodigo
					and act.Aid = afr.Aid
			where afr.AFRid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFRid#">
		</cfquery>
	</cftransaction>
	
<cfelseif isdefined("form.cambio")>
	<cf_dbtimestamp
		table="CRDocumentoResponsabilidad" 
		redirect="mejoras.cfm"
		timestamp="#Form.ts_rversion#"
		field1="CRDRid,numeric,#Form.CRDRid#">
	<cfquery name="rs_update" datasource="#session.dsn#">
		update CRDocumentoResponsabilidad
		set CRDRdescdetallada  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CRDRdescdetallada#" null="#len(Form.CRDRdescdetallada) eq 0#">, 
			CRDRfdocumento	   = <cfif len(trim(Form.CRDRfdocumento))>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CRDRfdocumento)#">
								<cfelse>
									#Now()#
								</cfif>,
		 <cfif len(trim(Form.CRTCid))>
			CRTCid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRTCid#">,
		 </cfif>
			CRDRdocori		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CRDRdocori#" null="#len(Form.CRDRdocori) eq 0#">,
			BMUsucodigo 	= #Session.Usucodigo#,
			AFMid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid1#">,
			AFMMid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid1#">,
		    CRDRserie 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRDRserie#">,
            <cfif form.AFCMid gt 0>
            	 AFCMejora    = <cfqueryparam cfsqltype="cf_sql_bit"     value="1">,
            <cfelse>
            	AFCMejora     = <cfqueryparam cfsqltype="cf_sql_bit"     value="0">,    
            </cfif>
            AFCMid          = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFCMid#">
		where CRDRid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRDRid#">
	</cfquery>
	
<cfelseif isdefined("form.baja")>
	
	<cfquery name="rs_delete" datasource="#session.dsn#">
		delete from CRDocumentoResponsabilidad
		where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRDRid#">
	</cfquery>
	
<cfelseif isdefined("form.aplicar") or isdefined("form.btnaplicar")>
	<cfif isdefined("form.chk")>
		<cfset lista = form.chk>
	<cfelseif isdefined("form.CRDRid")>
		<cfset lista = form.CRDRid>
	<cfelse>
		<cf_errorCode	code = "50132" msg = "No. de Documento no pudo ser determinado. Proceso Cancelado!">
	</cfif>
	<cfloop list="#lista#" index="item">
		<cfquery name="rsRegistro" datasource="#session.dsn#">
			select 
				rdr.CRDRfdocumento, 
				rdr.AFMid,
				rdr.AFMMid,
				rdr.CRDRserie,
				act.Aplaca,
				act.Aid,
				rdr.CRDRplaca
			from CRDocumentoResponsabilidad rdr
				left outer join Activos act
				 on act.Aplaca = rdr.CRDRplaca
				and act.Ecodigo = rdr.Ecodigo
			where rdr.CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
			  and act.Astatus = 0
		</cfquery>

		<cfif len(trim(rsRegistro.Aplaca)) EQ 0>
			<cf_errorCode	code = "50134"
							msg  = "La placa: @errorDat_1@ no corresponde con un activo en estado vigente. Proceso Cancelado!"
							errorDat_1="#rsRegistro.CRDRplaca#"
			>
		</cfif>
		
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" 	  Aid="#rsRegistro.Aid#" validamontos="false"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion"  Aid="#rsRegistro.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#rsRegistro.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" 	  Aid="#rsRegistro.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" 	  Aid="#rsRegistro.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#rsRegistro.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado"     Aid="#rsRegistro.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola"         Aid="#rsRegistro.Aid#"/> 
		

		<cfset LvarFechaIni  = createodbcdate(rsRegistro.CRDRfdocumento)>
		<cfset LVarAid       = rsRegistro.Aid>
		<cfset LVarAFMid     = rsRegistro.AFMid>
		<cfset LVarAFMMid    = rsRegistro.AFMMid>
		<cfset LVarCRDRserie = rsRegistro.CRDRserie>

		<cfquery name="rs" datasource="#session.dsn#">
			select max(AFRfini) as FechaInicialMaxima
			from AFResponsables
			where Aid = #LvarAid#
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfif rs.recordcount GT 0>
			<cfset LVarFechaIniAnterior = createodbcdate(rs.FechaInicialMaxima)>
			<cfif LVarFechaIniAnterior GT LvarFechaIni>
				<cfset LvarMensajeError = "La placa #rsRegistro.Aplaca# tiene un vale con una fecha de inicio: #DateFormat(LVarFechaIniAnterior, 'DD/MM/YYYY')# posterior a la fecha del documento: #DateFormat(LvarFechaIni, 'DD/MM/YYYY')#">
				<cfthrow message="#LvarMensajeError#">
			</cfif>
		</cfif>

		<cfset LvarFechaFinAnterior = dateadd('D', - 1, LvarFechaIni)>

		<cftransaction>
			<cfset fechaFinal= '01/01/6100'>
			<cfquery name="rs_update_afr" datasource="#session.dsn#">
				update AFResponsables
				set AFRffin = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinAnterior#">, 
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="00"> 
				where Aid     = #LvarAid#
				  and Ecodigo = #session.Ecodigo#
				  and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinAnterior#"> between AFRfini and AFRffin
			</cfquery>

			<cfquery name="rsinsertafr" datasource="#session.dsn#">
				select
						crdr.Ecodigo, crdr.DEid, afr.Alm_Aid, afr.Aid, 
						crdr.CFid, crdr.CRCCid, crdr.CRTDid, crdr.CRDRdescripcion, 
						crdr.CRDRdescdetallada, crdr.CRDRtipodocori, crdr.CRDRdocori, 
						crdr.CRDRfdocumento, afr.AFRdocumento, 
						crdr.CRTCid
					from CRDocumentoResponsabilidad crdr
						inner join AFResponsables afr
							on afr.AFRid = crdr.AFRid
						inner join Activos act
							on act.Aid = afr.Aid
					where crdr.CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
			</cfquery>
			
			
			<cfquery datasource="#session.dsn#" name="rs_insert_afr">
				insert into AFResponsables 
				(
					Ecodigo, 
					DEid, 
					Alm_Aid, 
					Aid, 
					CFid, 
					CRCCid, 
					CRTDid, 
					CRDRdescripcion, 
					CRDRdescdetallada, 
					CRDRtipodocori, 
					CRDRdocori, 
					AFRfini, 
					AFRffin, 
					AFRdocumento, 
					Usucodigo, 
					Ulocalizacion,
					BMUsucodigo,
					CRTCid
				)
				values
				(
					#rsinsertafr.Ecodigo#, 
					#rsinsertafr.DEid#, 
					<cfif isdefined("rsinsertafr.Alm_Aid") and len(trim(rsinsertafr.Alm_Aid))>
					#rsinsertafr.Alm_Aid#, 
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 			
					</cfif>
					#rsinsertafr.Aid#, 
					#rsinsertafr.CFid#, 
					#rsinsertafr.CRCCid#, 
					#rsinsertafr.CRTDid#, 
					'#rsinsertafr.CRDRdescripcion#', 
					'#rsinsertafr.CRDRdescdetallada#',
					<cfif isdefined("rsinsertafr.CRDRtipodocori") and len(trim(rsinsertafr.CRDRtipodocori))>
					#rsinsertafr.CRDRtipodocori#, 
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">, 			
					</cfif>
					'#rsinsertafr.CRDRdocori#', 
					#lsparsedatetime(rsinsertafr.CRDRfdocumento)#, 
					#lsparsedatetime(fechaFinal)#, 
					<cfif isdefined("rsinsertafr.AFRdocumento") and len(trim(rsinsertafr.AFRdocumento))>
					#rsinsertafr.AFRdocumento#, 
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">, 			
					</cfif>
					#Session.Usucodigo#, 
					'00', 
					#Session.Usucodigo#,
					#rsinsertafr.CRTCid#
				)
				<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="rs_insert_afr">
		
			
			<cfquery name="rs_update_act" datasource="#session.dsn#">
				Update Activos
				set 
					AFMid = #LVarAFMid#,
					AFMMid = #LVarAFMMid#,
					Aserie = '#LVarCRDRserie#'
				where Aid = #LVarAid#
			</cfquery>
		
			<!---******* Aqui se hace el alta a la tabla de bitacoras ******--->
			<cfquery datasource="#session.dsn#" name="rsinsertabitacora">
				insert into CRBitacoraTran(
					Ecodigo, 
					CRBfecha,
					Usucodigo,
					CRBmotivo,
					CRBPlaca,  
					AFRid,         
					Aid,               
					BMUsucodigo)
				select
					#Session.Ecodigo#,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
					#Session.Usucodigo#,
					5,
					act.Aplaca,
					afr.AFRid,
					afr.Aid,
					#Session.Usucodigo#
				from AFResponsables afr
					inner join Activos act
						on act.Aid = afr.Aid
				where afr.AFRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_insert_afr.identity#">	
			</cfquery>			


			<cfquery name="rs_update" datasource="#session.dsn#">
				delete from CRDocumentoResponsabilidad
				where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
			</cfquery>
			
		</cftransaction>
	</cfloop>
</cfif>

<cfif isdefined("form.BTNELIMINAR")>

	<cfif isdefined("form.chk")>
		<cfset lista = form.chk>
	<cfelseif isdefined("form.CRDRid")>
		<cfset lista = form.CRDRid>
	<cfelse>
		<cf_errorCode	code = "50132" msg = "No. de Documento no pudo ser determinado. Proceso Cancelado!">
	</cfif>

	<cfloop list="#lista#" index="item">
		<cftransaction>
			
			<cfquery name="rs_update" datasource="#session.dsn#">
				delete from CRDocumentoResponsabilidad
				where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
			</cfquery>
			
		</cftransaction>
	</cfloop>

</cfif>

<!--- variable para enviar parámetros por get a la pantalla--->
<cfset params = "">
<!--- envío de la llave --->
<cfif isdefined("form.alta")>
	<!--- <cfset params = params & iif(len(params),DE("&"),DE("?")) & "CRDRid=#rs_insert.identity#"> --->
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "btnnuevo=nuevo">
<cfelseif isdefined("form.cambio")>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "CRDRid=#form.CRDRid#">
<cfelseif isdefined("form.nuevo")>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "btnnuevo=nuevo">
</cfif>
<cflocation url="mejoras.cfm#params#">

