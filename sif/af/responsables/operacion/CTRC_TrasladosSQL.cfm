<cf_dbfunction name="now" returnvariable="hoy">
<cfif isDefined("form.Agregar")>

	<cfquery name="rsVerificaInsert" datasource="#session.DSN#">
			Select 1
			from AFResponsables a
				 	inner join Activos b
						on a.Aid = b.Aid
							and a.Ecodigo = b.Ecodigo
			where CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and #hoy# between AFRfini and AFRffin 
			<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))> 
				and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
			</cfif>
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				and a.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
			<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid))>
				and a.CRTDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">
			</cfif>	
			and AFRid not in (
				select AFRid 
				from AFTResponsables 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				<!---
					and AFTRestado in (30,50)
					no requiere validar porque no debería agregarse 
					para si mismo mas de un traslado para el mismo vale
				--->
				and AFTRtipo = 2) 

	</cfquery>

	<cfif rsVerificaInsert.recordcount gt 0> 

		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into AFTResponsables(AFRid,Usucodigo,AFTRestado,AFTRtipo,AFTRfini,Ulocalizacion,BMUsucodigo,CRCCid)
				select
					AFRid,#Session.Usucodigo#,30,2,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
					'00',
					#session.Usucodigo#,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.DESTINO#">
				from AFResponsables a
						inner join Activos b
							on a.Aid = b.Aid
								and a.Ecodigo = b.Ecodigo
				where CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and #hoy# between AFRfini and AFRffin 
				<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))> 
					and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
				</cfif>
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				</cfif>
				<cfif isdefined("form.CFid") and len(trim(form.CFid))>
					and a.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
				</cfif>
				<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid))>
					and a.CRTDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">
				</cfif>	
				and AFRid not in (
					select AFRid 
					from AFTResponsables 
					where Usucodigo = #Session.Usucodigo#
					<!---
						and AFTRestado in (30,50)
						no requiere validar porque no debería agregarse 
						para si mismo mas de un traslado para el mismo vale
					--->
				and AFTRtipo = 2) 
					and not exists (
					Select 1 
					from ADTProceso ADT 
					where ADT.Ecodigo = b.Ecodigo 
					and ADT.Aid = b.Aid)
		</cfquery>
	
	<cfelse>
		<cfset noinserta = 1>
	</cfif>
	
<cfelseif isDefined("form.EliminarT")>
	<cfquery name="rsdeleteT" datasource="#session.DSN#">
		delete from AFTResponsables
		where Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and AFTRtipo = 2
	</cfquery>	
<cfelseif isDefined("form.Eliminar")>
	<cfif isdefined("form.CHK")>
		<cfquery name="rsdeleteSel" datasource="#session.DSN#">
			delete from AFTResponsables
			where Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and AFTRtipo = 2
				and AFTRid in (#form.CHK#)
		</cfquery>	
	</cfif>
<cfelseif isdefined ("form.Importar")>
	<cflocation url="ImportadorTrasladoCF.cfm">
<cfelseif isDefined("form.Aplicar")>
	 <cfif isdefined("form.CHK")>
		<cftransaction>
			<!--- *********** PASO 1 CAMBIAR ESTADO			***********--->
			 <cfquery name="rsBITACORA" datasource="#session.DSN#">
				Update AFTResponsables set AFTRestado = 40
				where Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					and AFTRtipo = 2
					and AFTRestado in (30,50)
					and AFTRid in (#form.CHK#) 
			 </cfquery>
		</cftransaction>
	</cfif>
<cfelseif isDefined("form.AplicarT")>
	<cftransaction>
		<!--- *********** PASO 1 CAMBIAR ESTADO			***********--->
		 <cfquery name="rsBITACORA" datasource="#session.DSN#">
			Update AFTResponsables set AFTRestado = 40
			where Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and AFTRtipo = 2
				and AFTRestado in (30,50)
		 </cfquery>
	</cftransaction>
<cfelseif	isdefined("url.EliminarError")>
	<cfif 	isdefined("url.AFTRid") and len(trim(url.AFTRid)) gt 0 and url.AFTRid gt 0>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="Anular">
			<cfinvokeargument name="AFTRid" value="#url.AFTRid#"/>
			<cfinvokeargument name="Tipo" value="2"/>
		</cfinvoke>
	<cfelseif isdefined("url.ErrorNum") and len(trim(url.ErrorNum)) gt 0 and url.ErrorNum gt 0>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="AnularByErrorNum">
			<cfinvokeargument name="ErrorNum" value="#url.ErrorNum#"/>
			<cfinvokeargument name="Tipo" value="2"/>
		</cfinvoke >
	</cfif>
</cfif>

<cfif isdefined("noinserta") and noinserta eq 1>
	<cflocation url="CTRC_Traslados.cfm?noinserta=#noinserta#">
<cfelse>
				<cfset urlParam="">
				<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))>
				     <cfset urlParam =urlParam & "&AplacaINI=#form.AplacaINI#">   
				</cfif>
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				    <cfset urlParam =urlParam & "&DEid_filtro=#form.DEid#">   
				</cfif>	
				<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				   <cfset urlParam =urlParam & "&CFid_filtro=#form.CFid#">   
				</cfif>
				<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid))>
				   <cfset urlParam =urlParam & "&CRCCidFT=#form.CRTDid#">   
				</cfif>	
				<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
				   <cfset urlParam =urlParam & "&CRCCid=#form.CRCCid#">   
				</cfif>	
				<cfif isdefined("form.Agregar") and len(trim(form.Agregar))>
				   <cfset urlParam =urlParam & "&Agregar=#form.Agregar#">   
				</cfif>	
				
	<cflocation url="CTRC_Traslados.cfm?Adv=3#urlParam#">
</cfif>