
<!----////////////////////// PROCESO DE IMPORTACION DE PLAZAS PRESUPUESTARIAS //////////////////////------>
<cfoutput>
<cfif isdefined("form.btn_importar")>
	<cfif isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))
		and isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>		
		<!----//////////////// Eliminar el calculo del escenario //////////////////---->
		<!---Eliminar cortes del detalle(componentes) de la formulacion---->
		<!----//////////////// Eliminar la situacion actual //////////////////---->
		<!--- Eliminar los componentes de las plazas actuales importadas para escenario --->
		<cfquery datasource="#session.DSN#">
			delete from RHComponentesPlaza
			where RHPEid in (select RHPEid 
							from RHPlazasEscenario
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
								and RHPPid is not null
							)
		</cfquery>
		<!----Eliminar las plazas actuales importadas para el escenario---->
		<cfquery datasource="#session.DSN#">
			delete from RHPlazasEscenario
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
				and RHPPid is not null
		</cfquery>
		<!----////////////////////// Insertar de nuevo la situacion actual //////////////////// ---->				    
		<cftransaction>
			<!---- Insertar las plazas actuales del sistema con su correspondiente empleado que la ocupa actualmente---->			
<!---
			<cfquery name="x" datasource="#session.DSN#">
				select * from RHPlazasEscenario where RHEid=3
			</cfquery>
			<cfdump var="#x#">--->

			<cfquery name="rsEncabezado" datasource="#session.DSN#">
				insert into RHPlazasEscenario (RHEid, 
												RHPPid, 
												RHPEfinicioplaza, 
												RHPEffinplaza, 
												RHCid, 
												RHMPPid, 
												RHTTid, 
												RHSPid, 
												Ecodigo, 
												DEid, 
												BMfecha, 
												BMUsucodigo	)
												
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
							pp.RHPPid,
							ltp.RHLTPfdesde, 
							ltp.RHLTPfhasta,
							ltp.RHCid,
							ltp.RHMPPid,
							ltp.RHTTid,
							null,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							lt.DEid,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							
					from RHPlazaPresupuestaria pp
						inner join RHLineaTiempoPlaza ltp
							on ltp.Ecodigo = pp.Ecodigo
							and pp.RHPPid = ltp.RHPPid
							and ltp.RHLTPfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfhasta#">
							and ltp.RHLTPfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfdesde#">
							and ltp.RHMPestadoplaza = 'A'
					
						inner join LineaTiempo lt
							on lt.RHPid = ltp.RHPid 
							and lt.LTdesde <= ltp.RHLTPfhasta
							and lt.LThasta >= ltp.RHLTPfdesde
							and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfhasta#">
							and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfdesde#"> 
							
						inner join TiposNomina tn
							on tn.Ecodigo = lt.Ecodigo
							and tn.Tcodigo = lt.Tcodigo
								
					where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">									
			</cfquery>

			<cfquery name="rsDetalle" datasource="#session.DSN#">
				insert into RHComponentesPlaza (RHPEid, 
												CSid, 
												Ecodigo, 
												Cantidad, 
												Monto, 
												CFformato, 
												BMfecha, 
												BMUsucodigo)
					select 	e.RHPEid,
							d.CSid,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							d.Cantidad,
							d.Monto,
							d.CFformato,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">					 					 		
					from RHPlazaPresupuestaria b
		
						inner join RHLineaTiempoPlaza c
							on b.RHPPid = c.RHPPid
							and b.Ecodigo = c.Ecodigo
		
							inner join RHPlazasEscenario e
								on e.RHPPid=c.RHPPid
								and e.Ecodigo = c.Ecodigo
								and e.RHPEfinicioplaza = c.RHLTPfdesde
								and e.RHPEffinplaza = c.RHLTPfhasta
								and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							
							inner join RHCLTPlaza d
								on c.RHLTPid = d.RHLTPid
								and c.Ecodigo = d.Ecodigo
											
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cftransaction>		
	</cfif>	
</cfif>

<form action="ST-PPresupuestarias.cfm" method="post" name="sql">
	<cfif isdefined("form.RHEid") and Len(Trim(form.RHEid))>
		<input name="RHEid" type="hidden" value="#Form.RHEid#">
	</cfif>
	<cfif isdefined("form.RHEfhasta") and Len(Trim(form.RHEfhasta))>
		<input name="RHEfhasta" type="hidden" value="#Form.RHEfhasta#">
	</cfif>
	<cfif isdefined("form.RHEfdesde") and Len(Trim(form.RHEfdesde))>
		<input name="RHEfdesde" type="hidden" value="#Form.RHEfdesde#">
	</cfif>
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

</cfoutput>