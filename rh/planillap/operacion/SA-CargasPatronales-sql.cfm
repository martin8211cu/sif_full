<cfsetting requesttimeout="8400">
<!----////////////////////// PROCESO DE IMPORTACION DE PLAZAS PRESUPUESTARIAS //////////////////////------>
<cfoutput>
<cfif isdefined("form.Importar")>
	<cfif isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))
		and isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>		
		<cftransaction>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!----////////////////////// IMPORTACIÓN DE LAS CARGAS //////////////////// ---->				    
        	<cfquery datasource="#session.DSN#">
            	delete RHECargasPatronales
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
            </cfquery>
			<cfquery name="rsTEscenario" datasource="#session.DSN#">	
				select RHTTid
				from RHETablasEscenario
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			<cfset Lvar_TablasEscenario = Valuelist(rsTEscenario.RHTTid)>
			<!----///////////// INSERTA LAS CARGAS PATRONALES ///////////---->			
			<cfquery name="rsEncabezado" datasource="#session.DSN#">
				insert into RHECargasPatronales (Ecodigo,DClinea,RHEid,RHECPvalor,RHECPcuentac,RHECPmetodo,RHECPaplicaCargas,BMusucodigo,BMfecha)
					select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    		DClinea,
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
                    		DCvalorpat,DCcuentac,DCmetodo,
                            0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    from DCargas
                    where DCvalorpat > 0
                      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cftransaction>		
	</cfif>	
<cfelseif isdefined('form.Guardar')>
	<!--- MODIFICACION DE LOS VALORES DE LAS CARGAS --->
	<cftransaction>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
        <cfquery name="rsCargas" datasource="#session.DSN#">
            select DClinea
            from RHECargasPatronales
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
        </cfquery>
        <cfloop query="rsCargas">
        	<cfif isdefined('form.Valor'&rsCargas.DClinea)>
                <cfquery datasource="#session.DSN#">
                    update RHECargasPatronales
                    set RHECPvalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('Valor#rsCargas.DClinea#'),',','','all')#">, 
                    	RHECPaplicaCargas = <cfif isdefined('form.RHECPaplicaCargas'&rsCargas.DClinea)>1<cfelse>0</cfif>,
                        BMusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
                      and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.DClinea#">
                </cfquery>
            </cfif>
        </cfloop>
	</cftransaction>
</cfif>
<form action="SA-CargasPatronales.cfm" method="post" name="sql">
	<cfif isdefined("form.RHEid") and Len(Trim(form.RHEid))>
		<input name="RHEid" type="hidden" value="#Form.RHEid#">
	</cfif>
</form>
</cfoutput>
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>