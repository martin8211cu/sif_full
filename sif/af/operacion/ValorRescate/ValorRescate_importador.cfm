<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErrICVR_c1" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * 
  from #table_name# 
</cfquery>


<cfquery name="rsSQL" datasource="#session.dsn#">
	select AFTRtipo, AFTRaplicado
	  from AFTRelacionCambio
	 where AFTRid = #form.AFTRid#
</cfquery>

<cfif isdefined("rsSQL") and rsSQL.recordcount eq 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		Insert into #errores# (Error)
		values ('No existe el Encabezado de la relación')
	</cfquery>
</cfif>

<cfif rsSQL.AFTRaplicado EQ "1">
	<cf_errorCode	code = "50102" msg = "El documento de Cambio ya fue aplicado">
</cfif>

<cfset LvarAFTRtipo = rsSQL.AFTRtipo>

<cfset session.Importador.SubTipo = "2">

<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select Pvalor
		from Parametros 
		where Ecodigo = #session.Ecodigo#
			and Pcodigo = 50
	</cfquery>
	
	<cfquery name="rsMes" datasource="#session.dsn#">
		select Pvalor
		from Parametros 
		where Ecodigo = #session.Ecodigo#
			and Pcodigo = 60
	</cfquery>
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
				#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush interval="64">
	</cfif>

	<cfquery name="rsACTIVOS" datasource="#session.dsn#">
		select 
				Aid, 
				Adescripcion, 
				Avalrescate,
				Aplaca,
				Afechainidep
		  from Activos
		 where Aplaca = '#rsImportador.Aplaca#'
		 and Ecodigo= #session.Ecodigo#
	</cfquery>
	<cfif rsACTIVOS.Aid EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('No existe el activo a relacionar (#rsImportador.Aplaca#)')
		</cfquery>
		
	<cfelse>	
		<cfquery name="rsMontoAV" datasource="#session.dsn#">
			select AFSvaladq, AFSdepacumadq
			from AFSaldos
			where Aid=#rsACTIVOS.Aid#
			and AFSperiodo = #rsPeriodo.Pvalor#
			and AFSmes     = #rsMes.Pvalor#
			and Ecodigo =#session.Ecodigo#
		</cfquery>

		<cfset LvarAdq=0>
		<cfset LvarAdq= rsMontoAV.AFSvaladq>
		
		<cfset LvarDep=0>
		<cfset LvarDep= rsMontoAV.AFSdepacumadq>
		
		<cfset LvarMotoFinal=0>

		<cfif rsMontoAV.recordcount eq 0>
        	<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #errores# (Error)
				values ('El Activo Placa:(#rsImportador.Aplaca#) no tiene saldos para el perido #rsPeriodo.Pvalor#, mes #rsMes.Pvalor#')
			</cfquery>
            <cfset LvarAdq = 0> <!--- Se pone 0 para que continue el importador pero va a detenerce para presentar los errores. --->
            <cfset LvarDep = 0> <!--- Se pone 0 para que continue el importador pero va a detenerce para presentar los errores. --->
        <cfelse>
        	<cfif not IsValid('numeric',LvarAdq)>
                <cfquery name="ERR" datasource="#session.DSN#">
                    Insert into #errores# (Error)
                    values ('El Activo Placa:(#rsImportador.Aplaca#) esta generando un valor para la variable LvarAdq que no es numerico')
                </cfquery>
                <cfset LvarAdq = 0> <!--- Se pone 0 para que continue el importador pero va a detenerce para presentar los errores. --->
            </cfif>
            <cfif not IsValid('numeric',LvarDep)>
                <cfquery name="ERR" datasource="#session.DSN#">
                    Insert into #errores# (Error)
                    values ('El Activo Placa:(#rsImportador.Aplaca#) esta generando un valor para la variable LvarDep que no es numerico')
                </cfquery>
                <cfset LvarDep = 0> <!--- Se pone 0 para que continue el importador pero va a detenerce para presentar los errores. --->
            </cfif>
        </cfif>        

		<cfset LvarMotoFinal= LvarAdq-LvarDep>
		
		<cfif rsImportador.AFTDvalrescate gt LvarMotoFinal>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #errores# (Error)
				values ('El Activo Placa:(#rsImportador.Aplaca#) un Valor de Rescate mayor al de Adquisición')
			</cfquery>
		<cfelseif rsImportador.AFTDvalrescate LT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #errores# (Error)
				values ('El Activo Placa:(#rsImportador.Aplaca#) tiene negativo el Valor de Rescate')
			</cfquery>
		</cfif>
	</cfif>
	
</cfloop>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	<cfif rsErrores.cantidad gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
		</cfquery>
		<cfreturn>
	<cfelse>
	
		<cfloop query="rsImportador">
		
	<cfquery name="rsACTIVOS" datasource="#session.dsn#">
		select 
				Aid, 
				Adescripcion, 
				Avalrescate,
				Aplaca,
				Afechainidep,
                AFMid,
                AFMMid,
                AFCcodigo
		  from Activos
		 where Aplaca = '#rsImportador.Aplaca#'
		 and Ecodigo=#session.Ecodigo#
	</cfquery>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select AFTDid
			  from AFTRelacionCambioD
			  where AFTRid	= #form.AFTRid#
			   and Aid 		= #rsACTIVOS.Aid#
			   and Ecodigo	= #session.Ecodigo#
		</cfquery>
		<cfif rsSQL.AFTDid EQ "">			
			<cfquery datasource="#session.dsn#">
				insert into AFTRelacionCambioD
					(
					 AFTRid, 
					 Ecodigo, 
					 Aid, 
					 Avalrescate, 
					 Adescripcion, 
					 Usucodigo, 
					 AFTDtipo, 
					 AFTDvalrescate, 
					 AFTDdescripcion,
					 AFTDfechainidep,
                     AFMid,
                     AFMMid,
                     AFCcodigo
					 )
				values(
					 #form.AFTRid#
					,#session.Ecodigo#
					,<cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsACTIVOS.Aid#">
					,<cfqueryparam cfsqltype="cf_sql_money"		value="#rsACTIVOS.Avalrescate#">
					,<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsACTIVOS.Adescripcion#">
					,#session.usucodigo#
					,#LvarAFTRtipo#<!--- debería ser LvarAFTDtipo --->
					
					<cfif LvarAFTRtipo eq "1">
						,<cfqueryparam cfsqltype="cf_sql_money"		value="#rsImportador.AFTDvalrescate#">
						,<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsACTIVOS.Adescripcion#">
						,<cfqueryparam cfsqltype="cf_sql_date" 		value="#rsACTIVOS.Afechainidep#">
					<cfelseif LvarAFTRtipo eq "2">
						,<cfqueryparam cfsqltype="cf_sql_money"		value="#rsACTIVOS.Avalrescate#">
						,<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsImportador.AFTDdescripcion#">
						,<cfqueryparam cfsqltype="cf_sql_date" 		value="#rsACTIVOS.Afechainidep#">
					<cfelseif LvarAFTRtipo eq "3">
						,<cfqueryparam cfsqltype="cf_sql_money"		value="#rsImportador.AFTDvalrescate#">
						,<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsImportador.AFTDdescripcion#">
						,<cfqueryparam cfsqltype="cf_sql_date" 		value="#rsACTIVOS.Afechainidep#">
					<cfelseif LvarAFTRtipo eq "4">
						,<cfqueryparam cfsqltype="cf_sql_money"		value="#rsACTIVOS.Avalrescate#">
						,<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsACTIVOS.Adescripcion#">
						,<cfqueryparam cfsqltype="cf_sql_date" 		value="#rsImportador.Afechainidep#">
                    <cfelseif LvarAFTRtipo eq "5"><!---Se agrega para cambio por garantía RVD 04/06/2014--->
                    	,<cfqueryparam cfsqltype="cf_sql_money"		value="#rsACTIVOS.Avalrescate#">
                    	,<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsACTIVOS.Adescripcion#">
						,<cfqueryparam cfsqltype="cf_sql_date" 		value="#rsACTIVOS.Afechainidep#">
						,<cfqueryparam cfsqltype="cf_sql_integer"		value="#rsACTIVOS.AFMid#">
						,<cfqueryparam cfsqltype="cf_sql_integer"		value="#rsACTIVOS.AFMMid#">
						,<cfqueryparam cfsqltype="cf_sql_integer" 		value="#rsACTIVOS.AFCcodigo#">
					</cfif>
				)
			</cfquery>
		
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update AFTRelacionCambioD
					set AFTDtipo		= #LvarAFTRtipo#
					<cfif LvarAFTRtipo eq "1" or LvarAFTRtipo eq "3">
					  , AFTDvalrescate  = <cfqueryparam cfsqltype="cf_sql_money" value="#rsImportador.AFTDvalrescate#">
					</cfif>
					<cfif LvarAFTRtipo eq "2" or LvarAFTRtipo eq "3">
					  , AFTDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.AFTDdescripcion#">
					</cfif>
					<cfif LvarAFTRtipo eq "4">
					  , AFTDfechainidep = <cfqueryparam cfsqltype="cf_sql_date" value="#rsImportador.Afechainidep#">
					</cfif>
                    <cfif LvarAFTRtipo eq "5"><!---Se agrega para cambio por garantía RVD 04/06/2014--->
					  ,<cfqueryparam cfsqltype="cf_sql_integer"		value="#rsACTIVOS.AFMid#">
					  ,<cfqueryparam cfsqltype="cf_sql_integer"		value="#rsACTIVOS.AFMMid#">
					  ,<cfqueryparam cfsqltype="cf_sql_integer" 		value="#rsACTIVOS.AFCcodigo#">
					</cfif>
				where AFTDid = #rsSQL.AFTDid#
			</cfquery>
		</cfif>
	</cfloop>
	</cfif>
		
<cfset session.Importador.SubTipo = 3>

