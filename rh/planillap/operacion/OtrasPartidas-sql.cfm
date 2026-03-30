<cfset params = 'RHEid=#form.RHEid#'>
<cfif not isdefined("form.Nuevo")>
	<cfset vn_monto = 0>			<!---Variable con el monto calculado según el criterio y el valor de incremento---->
	<cfset incrementaxmto = false>	<!---Variable para indicar si se incrementa por monto o por porcentaje---->	
	<cfset porcentajemayor = false>	<!---Variable para indicar si el porcentaje recibido para incrementar es mayor a 0---->

	<cfif isdefined("form.PeriodoHasta") and len(trim(form.PeriodoHasta))>
		<cfset vd_fechadesde = CreateDate(form.Periodo, form.Mes, 1)>			<!---Variable con el periodo desde--->
		<cfset vd_fechahasta = CreateDate(form.PeriodoHasta, form.MesHasta, 1)>	<!---Variable con el periodo hasta--->
	</cfif>	

	<cfif isdefined("form.opt_incremento") and form.opt_incremento EQ 'POR'><!----Si el incremento es por porcentaje---->
		<cfif form.PorcIncremento GT 0><!----Si el porcentaje es mayor que cero---->
			<cfset porcentajemayor = true>
		</cfif>
	<cfelse><!---Si el incremento es por monto--->
		<cfset incrementaxmto = true>
	</cfif>
	
	<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
	<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
		update RHEscenarios
			set RHEcalculado = 0
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
	<cfif not isdefined("Form.Eliminar") and not isdefined('form.btnEliminar')>
		<cfquery name="rsPartida" datasource="#session.dsn#">
			select coalesce(RHPOPdistribucionCF,0) as xCF
			from RHPOtrasPartidas
			where RHPOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPOPid#">
		</cfquery>
	</cfif>
	<cftransaction>
		<!----INSERTAR---->
		<cfif isdefined("Form.Alta")>
			<!--- INSERTA EL ENCABEZADO --->
			<cfquery name="insertOP" datasource="#session.DSN#">
				insert into RHOtrasPartidas(RHEid,RHPOPid,Ecodigo,fechadesde,fechahasta,BMfecha,BMUsucodigo)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPOPid#">,	
					   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_date" value="#vd_fechadesde#">,
					   <cfqueryparam cfsqltype="cf_sql_date" value="#vd_fechahasta#">,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.USucodigo#">)
				<cf_dbidentity1 datasource="#session.DSN#">			
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertOP">
			<cfset form.RHOPid = insertOP.identity>

			<!--- INSERTA EL DETALLE --->
			<cfif vd_fechadesde EQ vd_fechahasta><!----Si las fechas son iguales se inserta un solo registro---->			
				<!---<cfif not incrementaxmto>
					<cfif porcentajemayor>
						<cfset vn_monto = Replace(form.Monto,',','','all') + (((Replace(form.Monto,',','','all'))*Replace(form.PorcIncremento,',','','all'))/100)>					
					<cfelse>
						<cfset vn_monto = Replace(form.Monto,',','','all')>
					</cfif>
				<cfelse>
					<cfset vn_monto = Replace(form.Monto,',','','all') + Replace(form.MontoIncremento,',','','all')>
				</cfif>--->
				<cfset vn_monto = Replace(form.Monto,',','','all')>
				<cfquery name="rsInsert" datasource="#session.DSN#">					
					insert into RHDOtrasPartidas(RHOPid, 
												Mes, 
												Periodo, 
												Monto, 
												BMfecha, 
												BMUsucodigo,
												CFid)												
					select 	distinct <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.RHOPid#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.Mes#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.Periodo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#vn_monto#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					<cfif rsPartida.xCF eq 1>
							,CFid
					from RHSituacionActual
					where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
					<cfelse>
							,null
					from dual
					</cfif>
				</cfquery>
			<cfelse><!---Si las fechas son diferentes se insertan N registros, los contenidos en el rango de periodos---->											
				<cfset vn_monto = Replace(form.Monto,',','','all')>
				<cfloop condition=" vd_fechadesde lte vd_fechahasta ">		
					<cfquery datasource="#session.DSN#">
						insert into RHDOtrasPartidas(RHOPid, 
												Mes, 
												Periodo, 
												Monto, 
												BMfecha, 
												BMUsucodigo,
												CFid)
						select 	distinct <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.RHOPid#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#datepart('m', vd_fechadesde)#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#datepart('yyyy', vd_fechadesde)#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#vn_monto#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						<cfif rsPartida.xCF eq 1>
								,CFid
						from RHSituacionActual
						where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						<cfelse>
						,null
						from dual
						</cfif>
					</cfquery>	
					<cfset vd_fechadesde = dateadd('m', 1, vd_fechadesde) >
					<cfif not incrementaxmto>
						<cfif porcentajemayor>
							<cfset vn_monto = Replace(form.Monto,',','','all') + (((Replace(form.Monto,',','','all'))* Replace(form.PorcIncremento,',','','all'))/100)>					
						<cfelse>
							<cfset vn_monto = Replace(form.Monto,',','','all')>
						</cfif>
					<cfelse>
						<cfset vn_monto = Replace(form.Monto,',','','all') + Replace(form.MontoIncremento,',','','all')>
					</cfif>
					<cfset form.Monto = vn_monto >
				 </cfloop>					
			</cfif>	<!----Fin de las fechas desde/hasta----->
			<cfset params = params &'&modo=CAMBIO&RHOPid=#form.RHOPid#'>
	<!----MODIFICAR---->
		<cfelseif isdefined("Form.Cambio")>
			<cfif not incrementaxmto>
				<cfif porcentajemayor>
					<cfset vn_monto = Replace(form.Monto,',','','all') + (((Replace(form.Monto,',','','all'))*Replace(form.PorcIncremento,',','','all'))/100)>					
				<cfelse>
					<cfset vn_monto = Replace(form.Monto,',','','all')>
				</cfif>
			<cfelse>
				<cfset vn_monto = Replace(form.Monto,',','','all') + Replace(form.MontoIncremento,',','','all')>
			</cfif>
			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update RHOtrasPartidas set 
					Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#vn_monto#">
					<!----<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.Monto,',','','all')#">---->
				where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEid#">
					and RHPOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPOPid#">
					and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
					and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Periodo#">
			</cfquery>
		<!----ELIMINAR---->
		<cfelseif isdefined("Form.Eliminar")>
			<cfif isdefined('form.chk')>
				<!--- BORRAR DATOS DEL CALCULO DEL ESCENARIO --->
				<cfquery name="deleteOP" datasource="#session.DSN#">
					delete RHOPDFormulacion
					from RHOPDFormulacion a
					inner join RHOPFormulacion b
						on b.RHOPFid = a.RHOPFid
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				</cfquery>
				<!--- ELIMINA LOS DATOS DE LAS OTRAS PARTIDAS --->
				<cfquery name="deleteOP" datasource="#session.DSN#">
					delete from RHOPFormulacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				</cfquery>
				<!--- BORRA EL DETALLE --->
				<cfquery name="deleteDOP" datasource="#session.DSN#">
					delete from RHDOtrasPartidas
					where RHOPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.chk#">)
				</cfquery>
				<!--- BORRA EL ENCABEZADO --->
				<cfquery name="rsDelete" datasource="#session.DSN#">
					delete from RHOtrasPartidas
					where RHOPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.chk#">)
				</cfquery>	
			</cfif>
		<cfelseif isdefined('form.btnEliminar')>
			<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
				<cfset registrosP = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
				<cfloop index="i" from="1" to="#ArrayLen(registrosP)#">
					<cfset Lvar_RHOPid = ListGetAt(registrosP[i],1,'|')>
					<cfset Lvar_Mes = ListGetAt(registrosP[i],2,'|')>
					<cfset Lvar_Periodo = ListGetAt(registrosP[i],3,'|')>
					<cfquery name="deleteReg" datasource="#session.DSN#">
						delete from RHDOtrasPartidas
						where RHOPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_RHOPid#">
						  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">
						  and Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
	</cftransaction>
<cfelse>
	<cfset params=params & '&modo=ALTA'>
</cfif>
<cflocation url="OtrasPartidas.cfm?#params#">
