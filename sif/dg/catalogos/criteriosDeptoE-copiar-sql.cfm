	<!--- Validaciones --->  
	<!--- 1. (Periodo + Mes) Origen <> (Periodo + Mes) Destino --->
	<cfif url.periodo_origen eq url.periodo_destino and url.mes_origen eq url.mes_destino>
		<cflocation url="criteriosDeptoE-copiar.cfm?error=1">		<!--- error 1: mismo origen y destino--->
	</cfif>
	
	<!--- 2. Deben existir registros para Corporacion, periodo y mes origen --->

	<cfquery name="data" datasource="#session.DSN#">
		select count(1) as registros
		from DGDCriterioDeptoE b
			inner join DGCriteriosDeptoE a
				on 	a.PCEcatid 	= b.PCEcatid  
				and a.PCDcatid 	= b.PCDcatid
				and a.DGCDid 	= b.DGCDid
				and a.Periodo 	= b.Periodo
				and a.Mes		= b.Mes
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">  <!--- Corporacion --->
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_origen #"> <!--- origen --->
		  		and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_origen #">         <!--- origen --->				

		where b.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_origen #"> <!--- origen --->
		  and b.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_origen #">         <!--- origen --->
	</cfquery>
	<cfif data.recordcount eq 0 or data.registros eq 0 >
		<cflocation url="criteriosDeptoE-copiar.cfm?error=2&periodo_origen=#url.periodo_origen#&periodo_destino=#url.periodo_destino#&mes_origen=#url.mes_origen#&mes_destino=#url.mes_destino#">		<!--- error 2: no hay datos --->
	</cfif>

	<!--- check de borrado --->
	<cfif isdefined("url.chkBorrar")>
		<cfquery datasource="#session.DSN#">
			delete from DGDCriterioDeptoE
			where(select count(1) 
					from DGCriteriosDeptoE a
			      where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">   					<!--- Corporacion --->
			        and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_destino#"> 					<!--- Destino --->
			        and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_destino#">        					<!--- Destino --->
			        and DGDCriterioDeptoE.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_destino#"> 	<!--- Destino --->
			        and DGDCriterioDeptoE.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_destino#">        	<!--- Destino --->
				 ) > 0
		</cfquery>			  
		
		<cfquery datasource="#session.DSN#">
			delete from DGCriteriosDeptoE
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">   <!--- Corporacion --->
				  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_destino#"> <!--- Destino --->
				  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_destino#">        	<!--- Destino --->
		</cfquery>			  
	</cfif>

		<cfquery datasource="#session.DSN#">
			insert into DGCriteriosDeptoE (PCEcatid, PCDcatid, DGCDid, Periodo, Mes, CEcodigo, BMfechaalta, BMUsucodigo)
			select 	PCEcatid, 
					PCDcatid, 
					DGCDid, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_destino#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_destino#">, 
					CEcodigo, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					1
			from DGCriteriosDeptoE e
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">   <!--- Corporacion --->
			  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_origen #"> <!--- origen --->
			  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_origen #">         <!--- origen --->
			  and not exists(
					select 1
					from DGCriteriosDeptoE exis
					where exis.PCEcatid = e.PCEcatid
					  and exis.PCDcatid = e.PCDcatid
					  and exis.DGCDid   = e.DGCDid
					  and exis.Periodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_destino#">   <!--- Nuevo periodo --->
					  and exis.Mes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_destino#">      	<!--- Nuevo mes --->
				)
		</cfquery>			  				

		<cfquery datasource="#session.DSN#">
			insert into DGDCriterioDeptoE (PCEcatid, PCDcatid, DGCDid, Periodo, Mes, Ecodigo, Ocodigo, Valor, BMfechaalta, BMUsucodigo)
			select 	v.PCEcatid, 
					v.PCDcatid, 
					v.DGCDid, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_destino#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_destino#">, 
					v.Ecodigo, 
					v.Ocodigo, 
					v.Valor, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					1
			from DGCriteriosDeptoE e
				inner join DGDCriterioDeptoE v
						 on v.PCEcatid  = e.PCEcatid
						and v.PCDcatid  = e.PCDcatid
						and v.DGCDid    = e.DGCDid
						and v.Periodo   = e.Periodo
						and v.Mes       = e.Mes
			where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">   <!--- Corporacion --->
			  and e.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_origen #"> <!--- origen --->
			  and e.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_origen #">         <!--- origen --->
			  and not exists(
					select 1
					from DGDCriterioDeptoE exis
					where exis.PCEcatid = v.PCEcatid
					  and exis.PCDcatid = v.PCDcatid
					  and exis.DGCDid   = v.DGCDid
					  and exis.Periodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo_destino#">   <!--- Nuevo periodo --->
					  and exis.Mes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes_destino#">      	<!--- Nuevo mes	--->
					  and exis.Ecodigo  = v.Ecodigo
					  and exis.Ocodigo  = v.Ocodigo
				)
		</cfquery>

		<cflocation url="criteriosDeptoE-copiar.cfm?proceso=ok&periodo_origen=#url.periodo_origen#&periodo_destino=#url.periodo_destino#&mes_origen=#url.mes_origen#&mes_destino=#url.mes_destino#">		<!--- proceso terminado --->