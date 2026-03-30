<cfif isdefined("Form.btnParam")>
	<!--- Cuenta de Superavit --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 1141
	</cfquery>
	<cfif rsSQL.Pvalor NEQ "">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			update Parametros
			   set Pvalor = '#form.CFsuperavit#'
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 1141
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
			values (#session.Ecodigo#, 1141, 'CM', 'Cuenta Superávit para Cierre Contabilidad Presupuestaria',
					'#form.CFsuperavit#')
		</cfquery>
	</cfif>

	<!--- Cuenta de Deficit --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 1142
	</cfquery>
	<cfif rsSQL.Pvalor NEQ "">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			update Parametros
			   set Pvalor = '#form.CFdeficit#'
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 1142
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
			values (#session.Ecodigo#, 1142, 'CM', 'Cuenta Déficit para Cierre Contabilidad Presupuestaria',
					'#form.CFdeficit#')
		</cfquery>
	</cfif>

	<!--- Cuenta de ADEFAS --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 1143
	</cfquery>
    <!---SML. Validar si esta el check este activo, de lo contrario se eliminara el parametro--->
	<!--- <cf_dump var ="#form#"> --->
    <cfif isdefined('chkCadefas')>
		<cfif rsSQL.RecordCount NEQ 0>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update Parametros
			  		set Pvalor = '#form.CFadefas#'
			 	where Ecodigo = #session.Ecodigo#
			   		and Pcodigo = 1143
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
				values (#session.Ecodigo#, 1143, 'CM', 'Cuenta Adeudo Periodos Anteriores',
					'#form.CFadefas#')
			</cfquery>
		</cfif>
    <cfelse>
    	<cfquery name="rsSQL" datasource="#session.dsn#">
			delete
		  	from Parametros
			where Ecodigo = #session.Ecodigo#
		   		and Pcodigo = 1143
		</cfquery>
    </cfif>

	<cfquery name="rsparamEliminaMPC" datasource="#session.dsn#">
         select CPCompromiso
		 from CPparametros
		 where Ecodigo = #session.Ecodigo#
		 	and CPPid = #Form.hCPPid#
    </cfquery>

    <cfif rsparamEliminaMPC.recordCount EQ 0 >
        <cfquery name="CreaparamEliminaPC" datasource="#session.dsn#">
            insert into CPparametros (Ecodigo,CPPid,CPCompromiso,BMUsucodigo)
            values (#session.Ecodigo#, #Form.hCPPid#,
					<cfif isdefined("form.chkNoCP")>'True'<cfelse>'False'</cfif>,
					#session.usucodigo#
            )
        </cfquery>
    <cfelse>
        <cfquery name="rsparamEliminaPC" datasource="#session.dsn#">
            update CPparametros
            set CPCompromiso = <cfif isdefined("form.chkNoCP") >'True'<cfelse>'False'</cfif>,
				BMUsucodigo = #session.usucodigo#
            where Ecodigo = #session.Ecodigo#
            and CPPid = #Form.hCPPid#
        </cfquery>
    </cfif>
<cfelse>
	<cftransaction>
		<cfquery name="rsLimpiaTabla" datasource="#session.dsn#">
			delete from CPtipoMovContable
				where Ecodigo=#session.Ecodigo#
				and CPCCtipo =<cfqueryparam cfsqltype="cf_sql_char" value="#tipoTab#">
				and CPPid = #session.CPPid#
		</cfquery>
		<cfloop list="#form.CPTMid#" index="i"><cfoutput>#i#</cfoutput><br />
			 <cfif len(trim(#form[i]#)) gt 0 and #ListGetAt(i,2,"_")# eq #tipoTab# >
				<cfquery name="rsInsertar" datasource="#session.dsn#">
					insert into CPtipoMovContable(
					CPPid ,CPCCtipo, CPTMtipoMov,Ecodigo,Cmayor,BMUsucodigo
					)
					values(
					#session.CPPid#,
					<cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(i,2,"_")#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(i,3,"_")#">,
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form[i]#">,
					#session.Usucodigo#
					)
				</cfquery>
			 </cfif>
		</cfloop>

		<cfif isDefined("Form.hEliminaPC") and Len(Trim(form.hEliminaPC)) GT 0>
			<cfif isdefined("form.chkValidaXCPVal")>
				<cfset valor = 'S'>
			<cfelse>
				<cfset valor = 'N'>
			</cfif>

			<cfif form.hEliminaPC eq "1">
				<cfquery name="rsparamEliminaPC" datasource="#session.dsn#">
				            	update Parametros
							   	set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#valor#" len="100">
								where Ecodigo = #session.Ecodigo#
							    and Pcodigo = 1390
				 </cfquery>
			<cfelse>
				<cfquery name="CreaparamEliminaPC" datasource="#session.dsn#">
	            	insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					values (#session.Ecodigo#, 1390, 'CM', 'Eliminar Momento Presupuestal Pre Compromiso', 'N')
	            </cfquery>
			</cfif>
		</cfif>

        <cfquery name="rsparamEliminaMPC" datasource="#session.dsn#">
            	select Pvalor from Parametros
                where Ecodigo = #session.Ecodigo#
			    and Pcodigo = 1390
        </cfquery>

	</cftransaction>
</cfif>

<cflocation url="ParametrizaContaPres.cfm?tab=#form.tab#">

