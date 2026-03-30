<!--- Proceso de Inserción y Aplicación --->
<cfif isdefined("Form.btnCalcular")>
	
	<cftransaction>
		
		<!--- Se pregunta si viene el ACDid para poder recalcular --->	
		<cfif isdefined("Form.ACDid")>
			<!--- Consulta que el ACDestado sea diferente a cero --->
			<cfquery name="rsEstado" datasource="#Session.DSN#">
				select 1 as ACDestado
				from ACDividendos
				where ACDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACDid#">
					and ACDestado = 1	
			</cfquery>
			
			<cfif rsEstado.RecordCount GT 0 and len(trim(rsEstado.ACDestado)) GT 0>
				<!--- Envia un mensaje que no puede aplicar nuevamente --->
				<cfthrow message="No puede aplicarse el c&aacute;lculo porque ya fue aplicado.">
			<cfelse>
				<!--- Elimina todos los registros de la tabla ACDividendosAsociados --->
				<cfquery name="deleteDividendosAsociados" datasource="#Session.DSN#">
					delete from ACDividendosAsociados
					where ACDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACDid#">
				</cfquery>
				<!--- Elimina el registro de la tabla ACDividendos --->
				<cfquery name="deleteDividendos" datasource="#Session.DSN#">
					delete from ACDividendos
					where ACDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACDid#">
				</cfquery>
			</cfif>
		</cfif> 
				
		<!--- Asignación de variables --->
		<cfset monto  = replace(Form.ACDmonto,',','','all')>
		<cfset factor = replace(Form.ACDfactor,',','','all')>
		
		<cfquery name="rsInsertDividendos" datasource="#Session.DSN#">
			insert into ACDividendos (
				ACDperiodo,			ACDmes,			ACDmonto, 
				ACDfactor,			ACDestado,		ACDfechaCalcula,
				ACDfechaAplica,		ACDfechaPago,	BMUsucodigo,
				BMfecha
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ACDperiodo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ACDmes#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#monto#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#factor#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACDfechaPago)#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertDividendos">
		
		<!--- Variables de Fechas --->
		<cfset fechaAnterior = createDate(#Form.ACDperiodo#-1, #Form.ACDmes#+1, 1)>
		<cfset ultimoDiasMes = DaysInMonth(createDate(#Form.ACDperiodo#,#Form.ACDmes#,1))>
		<cfset fechaActual   = createDate(#Form.ACDperiodo#,#Form.ACDmes#,#ultimoDiasMes#)>
	
		<cfquery name="rsInsertDividendosAsociados" datasource="#Session.DSN#">
			insert into ACDividendosAsociados (
				ACDid, 			ACAid, 			ACDAmonto, 
				ACDAfactor, 	BMUsucodigo, 	BMfecha
			)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertDividendos.identity#">,
				a.ACAid, 
				((#monto# / #factor#) * sum(PEcantdias)) as Monto, 
        			sum(PEcantdias) as Factor,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from ACAsociados a
      				inner join HPagosEmpleado b
      					on b.DEid = a.DEid
      					and b.PEdesde >= ACAfechaIngreso
      					and b.PEdesde >= #fechaAnterior#
			where ACAestado = 1
				and ACAfechaIngreso <= #fechaActual#
			group by a.ACAid			
		</cfquery>
	
	</cftransaction>

<cfelseif isdefined("Form.btnAplicar")>
	
	<cfquery name="rsUpdateDividendos" datasource="#Session.DSN#">
		update ACDividendos
		set ACDestado = 1
		where ACDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACDid#">
	</cfquery>

</cfif>

<cflocation url="liquidacionDividendos.cfm">
