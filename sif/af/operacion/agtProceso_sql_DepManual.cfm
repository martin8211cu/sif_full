<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<cfsetting requesttimeout="36000">
<cfset IDtrans = 4>
<cfset session.debug = false>
<!---**************************--->
<!---********ENCABEZADO********--->
<!---**************************--->
<cfif isdefined("Alta")>
	<cfinvoke component="sif.Componentes.AF_DepreciacionManualActivos" method="AF_DepreciacionManualActivos"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="DEP. MANUAL - #form.AGTPdescripcion#">
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
	<cfset AGTPid = rsResultadosDA>
</cfif>
<!---**************************--->
<!---********IMPORTADOR********--->
<!---**************************--->
<cfif isdefined("Importar")>
	<cflocation url="../importar/importarDepManual#LvarPar#.cfm?AGTPid=#form.AGTPid#">
</cfif>
<!---*************************--->
<!---*********ASOCIAR*********--->
<!---*************************--->
<cfif isdefined("btnAsociar")>
	<cfif not isdefined("form.Aid") or form.Aid eq "">
		<cf_errorCode	code = "50093" msg = "Advertencia: Es necesario seleccionar o digitar una placa válida">
	</cfif>
	<cfinvoke component="sif.Componentes.AF_DepreciacionManualActivos" method="AF_GeneraDepManualActivos"
			returnvariable="rsResultadosRA">
		<cfinvokeargument name="AGTPid" value="#form.AGTPid#">
		<cfinvokeargument name="Aid" value="#form.Aid#">
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
		
	<cfset AGTPid = form.AGTPid>
	<cfset ADTPlinea = #rsResultadosRA#>
	<!--- Verifica que realmente la linea devuelta existe --->
	<cfquery name="rsVerLinea" datasource="#session.dsn#">
	Select count(1) 
	from ADTProceso 
	where ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ADTPlinea#">
	</cfquery>
	<cfif rsVerLinea.recordcount gt 0>
		<cfset ADTPlinea = -1>
	</cfif>
</cfif>
<!---*********************--->
<!---******ELIMINAR*******--->
<!---*********************--->
<cfif isdefined("Baja")>
	<cfquery name="rsDelete0" datasource="#session.dsn#">
		select count(1) as Registros
		from ADTProceso 
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCheckToDelete" datasource="#session.dsn#">
		select 1
		from AGTProceso 
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
		and AGTPestadp < 4
	</cfquery>
	<cfif (rsCheckToDelete.RecordCount eq 1)>
		<cfquery datasource="#session.dsn#">
			delete 
			from ADTProceso
			where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
		</cfquery>
		<!--- Estado = 5 > Borrado --->
		<cfquery name="rsDelete2" datasource="#session.dsn#">
			update AGTProceso
			set AGTPestadp = 5, 
				AGTPfecborrado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				AGTPusuborrado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				AGTPregborrado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDelete0.Registros#">
			where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
		</cfquery>
	</cfif>
	<cfset AGTPid = 0>
</cfif>

<!--- ********************************************************************************************** --->
<!--- ********************************************************************************************** --->
<!--- ******************************  MANEJO DE LAS LINEAS DE DETALLE ****************************** --->
<!--- ********************************************************************************************** --->
<!--- ********************************************************************************************** --->

<cfif isdefined("BajaDet")>
	<cfquery datasource="#session.dsn#">
		delete from ADTProceso
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
	</cfquery>
	<cfset ADTPlinea = 0>
</cfif>

<cfif isdefined("CambioDet")>
	
	<!--- OBTIENE EL PERIODO-MES DEL AUXILIAR --->
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select Pvalor as value
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Pcodigo = 50
			and Mcodigo = 'GN'
	</cfquery>

	<cfquery name="rsMes" datasource="#session.dsn#">
		select Pvalor as value
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Pcodigo = 60
			and Mcodigo = 'GN'
	</cfquery>	
	
	<cfif rsPeriodo.recordcount gt 0 and rsMes.recordcount gt 0>
		<cfset LvarPerAux = rsPeriodo.value>
		<cfset LvarMesAux = rsMes.value>		
	<cfelse>
		<cf_errorCode	code = "50094" msg = "No fue posible obtener el periodo-mes del auxiliar.">
	</cfif>	

	<!--- Verifica que todos los montos sean del mismo signo y que al menos uno de ellos tenga monto--->
	<cfif replace(form.TAmontolocadq,',','','all') eq 0 and replace(form.TAmontolocmej,',','','all') eq 0 and replace(form.TAmontolocrev,',','','all') eq 0>
		<cf_errorCode	code = "50095" msg = "No es posible modificar la transacción de depreciación porque todos los montos están en cero">
	</cfif>
	
	<!--- Revisa que los montos sean acordes a lo que falta por depreciar --->
	<!--- ************************* ADQUISICION ************************* --->	
	<cfif replace(form.TAmontolocadq,',','','all') gt 0>
	
		<cfquery name="VerificaMntsADQ" datasource="#session.dsn#">
		Select count(1) as Total
		from ADTProceso a
				inner join AFSaldos b
					 on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
					and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerAux#">
					and b.AFSmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">
				
				inner join Activos c
					 on c.Aid = a.Aid
					and c.Ecodigo = a.Ecodigo
					
		where a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
  		  and a.ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		  and a.IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
		  and round(((b.AFSvaladq - c.Avalrescate) - b.AFSdepacumadq),2) >= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontolocadq,',','','all')#">			
		</cfquery>
	
	<cfelse>
		
		<cfquery name="VerificaMntsADQ" datasource="#session.dsn#">
		Select count(1) as Total
		from ADTProceso a
				inner join AFSaldos b
					 on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
					and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerAux#">
					and b.AFSmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">
					
		where a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
  		  and a.ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		  and a.IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
		  and round(b.AFSdepacumadq,2) >= abs(<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontolocadq,',','','all')#">)
		</cfquery>
		
	</cfif>
	
	<!--- ************************* MEJORAS ************************* --->		
	<cfif replace(form.TAmontolocmej,',','','all') gt 0>
	
		<cfquery name="VerificaMntsMEJ" datasource="#session.dsn#">
		Select count(1) as Total
		from ADTProceso a
				inner join AFSaldos b
					 on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
					and b.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPerAux#">
					and b.AFSmes 	 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMesAux#">
					
		where a.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
  		  and a.ADTPlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		  and a.Ecodigo = #session.ecodigo#
		  and a.IDtrans = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDtrans#">
		  and round((b.AFSvalmej - b.AFSdepacummej),2) >= <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.TAmontolocmej,',','','all')#">			
		</cfquery>
	
	<cfelse>
		
		<cfquery name="VerificaMntsMEJ" datasource="#session.dsn#">
		Select count(1) as Total
		from ADTProceso a
				inner join AFSaldos b
					 on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
					and b.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPerAux#">
					and b.AFSmes 	 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMesAux#">
				
		where a.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
  		  and a.ADTPlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		  and a.Ecodigo = #session.ecodigo#
		  and a.IDtrans = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDtrans#">
		  and round(b.AFSdepacummej,2) >= abs(<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.TAmontolocmej,',','','all')#">)
		</cfquery>		
		
	</cfif>
	
	<!--- ************************* MEJORAS ************************* --->		
	<cfif replace(form.TAmontolocrev,',','','all') gt 0>
	
		<cfquery name="VerificaMntsREV" datasource="#session.dsn#">
		Select count(1) as Total
		from ADTProceso a
				inner join AFSaldos b
					 on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
					and b.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPerAux#">
					and b.AFSmes 	 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMesAux#">
				
				inner join Activos c
					 on c.Aid = a.Aid
					and c.Ecodigo = a.Ecodigo
					
		where a.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
  		  and a.ADTPlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		  and a.Ecodigo = #session.ecodigo#
		  and a.IDtrans = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDtrans#">
		  and round((b.AFSvalrev - b.AFSdepacumrev),2) >= <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.TAmontolocrev,',','','all')#">			
		</cfquery>
	
	<cfelse>
		
		<cfquery name="VerificaMntsREV" datasource="#session.dsn#">
		Select count(1) as Total
		from ADTProceso a
				inner join AFSaldos b
					 on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
					and b.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPerAux#">
					and b.AFSmes 	 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMesAux#">
				
				inner join Activos c
					 on c.Aid = a.Aid
					and c.Ecodigo = a.Ecodigo
					
		where a.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
  		  and a.ADTPlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		  and a.Ecodigo = #session.ecodigo#
		  and a.IDtrans = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDtrans#">
		  and round(b.AFSdepacumrev,2) >= abs(<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.TAmontolocrev,',','','all')#">)
		</cfquery>		
		
	</cfif>		
	
	
	<cfif VerificaMntsADQ.Total gt 0 and VerificaMntsMEJ.Total gt 0 and VerificaMntsREV.Total gt 0>
	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="ADTProceso"
				redirect="agtProceso_genera_DepManual#LvarPar#.cfm"
				timestamp="#form.ts_rversiondet#"
				field1="AGTPid,numeric,#form.AGTPid#" 
				field2="ADTPlinea,numeric,#form.ADTPlinea#" 
				field3="Ecodigo,numeric,#session.ecodigo#" 
				field4="IDtrans,numeric,#IDtrans#"
				>
		<cfquery datasource="#session.dsn#">
			update ADTProceso
			set IDtrans = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDtrans#">
			<cfif isdefined("Form.TAmontolocadq") and len(trim(Form.TAmontolocadq))
				and isdefined("Form.TAmontolocmej") and len(trim(Form.TAmontolocmej))
				and isdefined("Form.TAmontolocrev") and len(trim(Form.TAmontolocrev))>
	
				, TAmontolocadq = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.TAmontolocadq,',','','all')#">
				, TAmontolocmej = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.TAmontolocmej,',','','all')#">
				, TAmontolocrev = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.TAmontolocrev,',','','all')#">
				
			</cfif>
			where AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			and ADTPlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
			and Ecodigo = #session.ecodigo#
			and IDtrans = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDtrans#">
		</cfquery>	
	
	<cfelse>
		<script>
		alert("No es posible modificar este activo, ya que alguno o varios de los montos suministrados exceden lo permitido de Depreciación")
		history.go(-1)		
		</script>
		<cfabort>
	</cfif>
	
</cfif>


<cfif isdefined("AGTPid") and AGTPid GT 0>
	<cfif isdefined("ADTPlinea") and ADTPlinea GT 0 and not isdefined("form.NuevoDet")>
		<!--- Se modifica el detalle. Queda en el mantenimiento. --->
		<cflocation url="agtProceso_genera_DepManual#LvarPar#.cfm?AGTPid=#AGTPid#&ADTPlinea=#ADTPlinea#&#params#">
	<cfelseif not isdefined("form.Nuevo")>
		<!--- Se preciona nuevo en el detalle. Se regresa a la lista original. --->
		<cflocation url="agtProceso_genera_DepManual#LvarPar#.cfm?AGTPid=#AGTPid#&#params#">
	<cfelse>
		<cflocation url="agtProceso_genera_DepManual#LvarPar#.cfm?#params#">
	</cfif>	
<cfelse>
	<cflocation url="agtProceso_DEPRECIACION#LvarPar#.cfm?#params#">
</cfif>

