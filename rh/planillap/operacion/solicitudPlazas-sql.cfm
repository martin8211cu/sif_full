
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<cfquery name="rsAG" datasource="#session.dsn#">
	select Pvalor from RHParametros where Pcodigo=2029
</cfquery>

<cfquery name="valTab" datasource="#session.dsn#">
	select Pvalor from RHParametros where Pcodigo=540
</cfquery>

<cfquery name="valTab1" datasource="#session.dsn#">
	select count(1) as cantidad from ComponentesSalariales where CSsalariobase=1 and CSusatabla=1
	and Ecodigo=#session.Ecodigo#
</cfquery>

<cffunction name="insComponenteBase" >
	<cfargument name="RHSPid" type="string" default="">
	<cfargument name="salario" type="string" default="0">
		
	<cfquery datasource="#session.DSN#">
		insert INTO RHCSolicitud( RHSPid, Ecodigo, CSid, Cantidad, Monto, BMfecha, BMUsucodigo)
		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHSPid#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			   CSid,
			   1,
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(arguments.salario, ',', '', 'all')#">,
			   <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		from ComponentesSalariales	   
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CSsalariobase = 1
	</cfquery>
</cffunction>

<cffunction name="insComponentes" >
	<cfargument name="RHSPid" type="string" default="0">
	<cfargument name="RHTTid" type="string" default="0">
	<cfargument name="RHCid" type="string" default="0">
	<cfargument name="RHMPPid" type="string" default="0">
	<cfquery name="rsCSid" datasource="#session.DSN#">
		select CSid
		from ComponentesSalariales
		where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CSsalariobase = 1
	</cfquery>
	<cfquery datasource="#session.DSN#">
		insert into RHCSolicitud( RHSPid, 
								  Ecodigo, 
								  CSid, 
								  Cantidad, 
								  Monto, 
								  CFformato, 
								  BMfecha, 
								  BMUsucodigo )
		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHSPid#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCSid.CSid#">, 
			   1,
			   b.RHMCmonto, 
			   null,
			   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		
		from RHCategoriasPuesto a
		
		inner join RHMontosCategoria b
		on b.RHCid=a.RHCid
		
		inner join RHVigenciasTabla c
		on c.RHVTid=b.RHVTid
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
		and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTTid#" >
		and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#" >
		and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPPid#" >
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between c.RHVTfecharige and c.RHVTfechahasta
		and RHVTestado = 'A'
		
		order by a.RHTTid, a.RHCid, a.RHMPPid
	</cfquery>
</cffunction>

<cffunction name="recalcularComponentes">
	<cfargument name="id" type="string" default="0">

	<cfquery name="rsComp" datasource="#Session.DSN#">
		select a.RHCSid, a.CSid, a.Cantidad, a.Monto, c.RHSPid, c.RHMPPid, c.RHTTid, c.RHCid, c.RHSPfdesde, c.RHMPnegociado
		from RHCSolicitud a		
		inner join ComponentesSalariales b
		  on b.CSid = a.CSid		
		inner join RHSolicitudPlaza c
		  on c.RHSPid = a.RHSPid		
		where a.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		order by b.CSorden, b.CScodigo, b.CSdescripcion
	 </cfquery>
	 
	<cfloop query="rsComp">
		<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
			<cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
			<cfinvokeargument name="fecha" value="#rsComp.RHSPfdesde#"/>
			<cfinvokeargument name="RHMPPid" value="#rsComp.RHMPPid#"/>
			<cfinvokeargument name="RHTTid" value="#rsComp.RHTTid#"/>
			<cfinvokeargument name="RHCid" value="#rsComp.RHCid#"/>
			<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
			<cfinvokeargument name="negociado" value="#rsComp.RHMPnegociado is 'N'#"/>
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="Unidades" value="#rsComp.Cantidad#"/>
			<cfinvokeargument name="MontoBase" value="0.00"/>
			<cfinvokeargument name="Monto" value="#rsComp.Monto#"/>
			<cfinvokeargument name="TablaComponentes" value="RHCSolicitud"/>
			<cfinvokeargument name="CampoLlaveTC" value="RHSPid"/>
			<cfinvokeargument name="ValorLlaveTC" value="#arguments.id#"/>
			<cfinvokeargument name="CampoMontoTC" value="Monto"/>
		</cfinvoke>
		
		<cfquery datasource="#session.DSN#">
			update RHCSolicitud
			set Cantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteRet.Unidades#">,
				Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.Monto#">
			where RHCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.RHCSid#" >
		</cfquery>
	</cfloop>
</cffunction> 

<cfparam name="form.RHTTid" default="0">
<cfparam name="form.RHMPPid" default="0">
<cfparam name="form.RHCid" default="0">

<cfset modo = "ALTA">
<cfset action = "/cfmx/rh/planillap/operacion/solicitudPlazas.cfm">

<cfif isdefined('form.modulo') and form.modulo NEQ ''>
	<cfif form.modulo EQ 'aut'>	<!--- Planilla Presupuestaria --->
		<cfset action = "/cfmx/rh/autogestion/operacion/solicitudPlazasAUT.cfm">
	</cfif>
</cfif>

<cfif isdefined('form.modulo') and form.modulo NEQ ''>
	<cfif form.modulo EQ 'rs'>	<!--- Planilla Presupuestaria --->
		<cfset action = "/cfmx/rh/Reclutamiento/operacion/solicitudPlaza.cfm">
	</cfif>
</cfif>


<cfif isdefined("form.cambio_negociado") and len(trim(cambio_negociado))>
<cftransaction>
	<cfquery datasource="#session.DSN#">
		update RHSolicitudPlaza
		set RHMPnegociado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cambio_negociado#">
		where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete RHCSolicitud
		where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
<!--- 	<cfif form.cambio_negociado eq 'N' >
 --->		<!--- INSERTA COMPONENTE BASE SI NO LO TIENE --->
		<cfquery name="rsBase" datasource="#session.DSN#">
			select a.RHCSid, a.CSid
			from RHCSolicitud a
			
			inner join ComponentesSalariales b
			on b.Ecodigo=a.Ecodigo
			and b.CSid=a.CSid
			and b.CSsalariobase=1
			
			where a.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsBase.recordcount eq 0 >
			<cfset insComponenteBase( form.RHSPid, form.salarioref ) >
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update RHCSolicitud
				set Monto = <cfqueryparam cfsqltype="cf_sql_money4" value="#replace(form.salarioref, ',', '', 'all')#">
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
				  and RHCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBase.RHCSid#">
			</cfquery>
		</cfif>
<!--- 	<cfelse>
		<!--- Para salario no negociado, inserta los componentes asociados a la tabla, categoria y puesto seleccionados --->	
		<cfif isdefined("form.RHTTid") and isdefined("form.RHCid") and  isdefined("form.RHMPPid") and  len(trim(form.RHTTid)) and len(trim(form.RHCid)) and len(trim(form.RHMPPid)) >
			<cfset insComponentes( form.RHSPid, form.RHTTid, form.RHCid, form.RHMPPid ) >
			<!--- Recalcular todos los componentes --->
			<cfset recalcularComponentes(form.RHSPid) >
		</cfif>
	</cfif> --->
</cftransaction>
	<cflocation url="#action#?RHSPid=#form.RHSPid#">
</cfif>

<!------------------------------------------------------------------Modo alta--------------------------------------------------------------------------------->
<cfif isdefined("Form.Alta")>	
	<cfquery name="ALTAtipoMov" datasource="#session.dsn#">
		Select (coalesce(max(RHSPconsecutivo),0) + 1) as prox
		from RHSolicitudPlaza 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif form.RHSPcantidad gt 0 and len(trim(form.RHSPcodigo)) lte 0>
    	<cfthrow message="El codigo de la plaza es requerido.">
	</cfif>
	<cftransaction>				
		<cfquery name="ALTASolPlaza" datasource="#session.dsn#">
			insert into RHSolicitudPlaza 
				(RHSPconsecutivo, RHMPPid, RHCid, RHTTid, Ecodigo, CFid, RHPcodigo, RHSPcantidad, saldo, RHSPestado, RHSPfdesde
					, RHSPfhasta, Mcodigo, salarioref, salariomax, Observaciones, BMfecha, BMUsucodigo, Usucodigorev, fecharev, RHMPnegociado, RHSPcodigo)
			values (
				<cfif isdefined('ALTAtipoMov') and ALTAtipoMov.recordCount GT 0>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ALTAtipoMov.prox#">
				<cfelse>
					1
				</cfif>

				<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))  and form.RHMPPid neq 0>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#" null="#len(trim(form.RHMPPid)) is 0#">
				<cfelseif isdefined ('form.LvarPid') and len(trim(form.LvarPid)) gt 0>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LvarPid#" null="#len(trim(form.LvarPid)) is 0#">
				<cfelse>
					,null
				</cfif>
				
				<cfif isdefined("form.RHCid") and len(trim(form.RHCid)) and form.RHCid neq 0>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#len(trim(form.RHCid)) is 0#">
				<cfelseif isdefined ('form.LvarCid') and len(trim(form.LvarCid)) gt 0>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LvarCid#" null="#len(trim(form.LvarCid)) is 0#">
				<cfelse>
					, null
				</cfif>

				<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid)) and form.RHTTid neq 0>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#" null="#len(trim(form.RHTTid)) is 0#">
				<cfelse>
					, null
				</cfif>

				, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
				
				<cfif isdefined("form.RHPcodigo")>
				, <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
				<cfelse>
				, null
				</cfif>
				
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHSPcantidad#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHSPcantidad#">
				<cfif form.modulo EQ 'pp'>	<!--- Planilla Presupuestaria --->
					, 10
				<cfelseif form.modulo EQ 'rs'>	<!--- Reclutamiento y Selección --->
					, 20
				<cfelse>
					, 0
				</cfif>				
				<cfif isdefined('form.RHSPfdesde') and form.RHSPfdesde NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHSPfdesde)#">
				<cfelse>
					, null
				</cfif>						
				<cfif isdefined('form.RHSPfhasta') and form.RHSPfhasta NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHSPfhasta)#">
				<cfelse>
					, null
				</cfif>							
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_money" value="#form.salarioref#">
				<cfif isdefined('form.salariomax') and form.salariomax NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_money" value="#form.salariomax#">
				<cfelse>
					, null
				</cfif>				
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">
				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				<cfif form.modulo EQ 'pp'>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				<cfelse>
					, null
					, null
				</cfif>
				
				,<cfif isdefined("form.RHMPnegociado")>'N'<cfelse>'T'</cfif>
				,<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#trim(form.RHSPcodigo)#" voidnull>
				)
		  <cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>					
		<cf_dbidentity2 datasource="#Session.DSN#" name="ALTASolPlaza">

		<!--- INSERTAR COMPONENTE BASE --->
		<cfif isdefined("form.RHMPnegociado")>
			<cfset insComponenteBase( ALTASolPlaza.identity, form.salarioref ) >
		<!--- inserta los componentes asociados a la categoria, tabla salarial y puesto presupuestario seleccionados --->
		<cfelse>
			<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid)) and 
				  isdefined("form.RHMPPid") and len(trim(form.RHMPPid)) and 
				  isdefined("form.RHCid") and len(trim(form.RHCid)) >				
				<cfset insComponentes( ALTASolPlaza.identity, form.RHTTid, form.RHCid, form.RHMPPid ) >
				<!--- Recalcular todos los componentes --->
				<cfset recalcularComponentes(ALTASolPlaza.identity) >
			</cfif>	
		</cfif>
	</cftransaction>
	
	<cfset form.RHSPid = ALTASolPlaza.identity>

<!---------------------------------------------------------------Modo BAJA----------------------------------------------------------------------------------------->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete RHCSolicitud
		where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
	</cfquery>		

	<cfquery datasource="#session.dsn#">
		delete RHSolicitudPlaza
		where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
	</cfquery>		


<!--------------------------------------------------------------Modo CAMBIO---------------------------------------------------------------------------------------->
<cfelseif IsDefined("form.Cambio") or isdefined("form.Aplicar") >
<cftransaction>
	<cfquery datasource="#session.dsn#">
		update 	RHSolicitudPlaza set		
			<cfif isdefined("form.RHCid") and len(trim(form.RHCid)) and form.RHCid neq 0>
				RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#len(trim(form.RHCid)) is 0#">
			<cfelseif isdefined ('form.LvarCid') and len(trim(form.LvarCid)) gt 0>
				RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LvarCid#" null="#len(trim(form.LvarCid)) is 0#">
			<cfelse>
				RHCid= null
			</cfif>			

			<cfif isdefined('form.RHTTid') and len(trim(form.RHTTid)) and form.RHTTid NEQ 0 >
				, RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
			<cfelse>
				, RHTTid = null
			</cfif>				
			, CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">

			<cfif isdefined("form.RHPcodigo")>
			, RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
			<cfelse>
			,RHPcodigo=null
			</cfif>

			<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))  and form.RHMPPid neq 0>
				,RHMPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#" null="#len(trim(form.RHMPPid)) is 0#">
			<cfelseif isdefined ('form.LvarPid') and len(trim(form.LvarPid)) gt 0>
				, RHMPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LvarPid#" null="#len(trim(form.LvarPid)) is 0#">
			<cfelse>
				,RHMPPid=null
			</cfif>		
					
			, RHSPcantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHSPcantidad#">
			, saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHSPcantidad#">
			<cfif isdefined('form.RHSPfdesde') and form.RHSPfdesde NEQ ''>
				, RHSPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHSPfdesde)#">
			<cfelse>
				, RHSPfdesde = null
			</cfif>						
			<cfif isdefined('form.RHSPfhasta') and form.RHSPfhasta NEQ ''>
				, RHSPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHSPfhasta)#">
			<cfelse>
				, RHSPfhasta = null
			</cfif>				
			, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			, salarioref = <cfqueryparam cfsqltype="cf_sql_money" value="#form.salarioref#">
			<cfif isdefined('form.salariomax') and form.salariomax NEQ ''>
				, salariomax = <cfqueryparam cfsqltype="cf_sql_money" value="#form.salariomax#">
			<cfelse>
				, salariomax = null
			</cfif>						
			, Observaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">
			
				<cfif isdefined('form.estado') and form.estado NEQ ''>
					, RHSPestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.estado#">
				<cfelseif form.modulo eq '´pp'>
					, RHSPestado = 10
				<cfelseif form.modulo EQ 'rs'>	<!--- Reclutamiento y Selección --->
					, 20				
				<cfelse>
					, RHSPestado = 0
				</cfif>		
            ,RHSPcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHSPcodigo#">
			<cfif form.modulo EQ 'pp' or form.modulo eq 'rs'>
				, Usucodigorev = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				, fecharev = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			<cfelse>
				, Usucodigorev = null
				, fecharev = null
			</cfif>
			, RHMPnegociado = <cfif isdefined("form.RHMPnegociado")>'N'<cfelse>'T'</cfif>
						
		where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
	</cfquery>
	
	<cfset vProcesar = 0 >

<cfset form.RHMPnegociado = 'on'>
	<cfif isdefined("form.RHMPnegociado")>
		<cfset vNegociado = true >
		<cfif isdefined("form._RHMPnegociado") and form._RHMPnegociado eq 0 >
			<cfquery datasource="#session.dsn#">
				delete RHCSolicitud
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		<cfelse>
			<cfset vProcesar = 1 >
		</cfif>
		<!--- INSERTA COMPONENTE BASE SI NO LO TIENE --->
		<cfquery name="rsBase" datasource="#session.DSN#">
			select a.RHCSid, a.CSid
			from RHCSolicitud a
			
			inner join ComponentesSalariales b
			on b.Ecodigo=a.Ecodigo
			and b.CSid=a.CSid
			and b.CSsalariobase=1
			
			where a.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsBase.recordcount eq 0 >
			<cfset insComponenteBase( form.RHSPid, form.salarioref ) >
		<!---<cfelse>
			<cfquery datasource="#session.DSN#">
				update RHCSolicitud
				set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.salarioref, ',', '', 'all')#">
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
				  and RHCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBase.RHCSid#">
			</cfquery>--->
		</cfif>
	<cfelse>
		<cfquery name="rsTieneComponentes" datasource="#session.DSN#">
			select 1
			from RHCSolicitud
			where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#" >
		</cfquery>
		<cfif rsTieneComponentes.recordcount eq 0>
			<cfset form._RHMPnegociado = 1 >
		</cfif>
		
		<cfset vNegociado = false >
		<cfif isdefined("form._RHMPnegociado") and form._RHMPnegociado eq 0 >
			<cfset vProcesar = 1 >
		<cfelse>
			<cfquery datasource="#session.dsn#">
				delete RHCSolicitud
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
	
			<!--- Para salario no negociado, inserta los componentes asociados a la tabla, categoria y puesto seleccionados --->	
			<cfif isdefined("form.RHTTid") and isdefined("form.RHCid") and  isdefined("form.RHMPPid") and  len(trim(form.RHTTid)) and len(trim(form.RHCid)) and len(trim(form.RHMPPid)) >
				<cfset insComponentes( form.RHSPid, form.RHTTid, form.RHCid, form.RHMPPid ) >
				<!--- Recalcular todos los componentes --->
				<cfset recalcularComponentes(form.RHSPid) >
			</cfif>
		</cfif>
	</cfif>
	

	<cfif vProcesar eq 1 and isdefined("form.cantcomp") and IsNumeric(form.cantcomp) >
		<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid)) and 
			  isdefined("form.RHMPPid") and len(trim(form.RHMPPid)) and 
			  isdefined("form.RHCid") and len(trim(form.RHCid)) >
			<!--- Valida los campos RHTTid, RHCid, RHMPPid para evitar nulos --->
			<cfset vRHTTid = form.RHTTid >
			<cfset vRHMPPid = form.RHMPPid >
			<cfset vRHCid = form.RHCid >
			
			<cfif len(trim(form.RHTTid)) eq 0 >
				<cfset vRHTTid = 0 >
			</cfif>
			<cfif len(trim(form.RHMPPid)) eq 0 >
				<cfset vRHMPPid = 0 >
			</cfif>
			<cfif len(trim(form.RHCid)) eq 0 >
				<cfset vRHCid = 0 >
			</cfif>
		</cfif>	
		
		<cfif isdefined('form.RHSPfdesde') and form.RHSPfdesde NEQ ''>
			<cfset desde = LSParseDateTime(form.RHSPfdesde) >
		<cfelse>
			<cfset desde = now() >
		</cfif>
		
		<cfloop from="1" to="#form.cantcomp#" index="i">
			<cfset vRHCSid = IIF( len(trim(form['RHCSid_#i#'])) is 0, DE(0), DE(form['RHCSid_#i#']) ) >
			<cfset vMonto =  replace( IIF( len(trim(form['MontoRes_#i#'])) is 0, DE(0), DE(form['MontoRes_#i#']) ), ',', '', 'all' ) >
			<cfset vMontoBase = replace( IIF( len(trim(form['MontoBase_#i#'])) is 0, DE(0), DE(form['MontoBase_#i#']) ), ',', '', 'all' ) >
			<cfset vCantidad = replace( IIF( len(trim(form['Cantidad_#i#'])) is 0, DE(0), DE(form['Cantidad_#i#']) ), ',', '', 'all' ) >

			<cfif vRHCSid neq 0>
				<!--- Obtener el salario base --->
				<cfquery name="rsSalarioBase" datasource="#Session.DSN#">
					select a.CSid, coalesce(a.Monto, 0.00) as Monto
					from RHCSolicitud a
					where a.RHCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHCSid#">
				</cfquery>
				<cfset vCSid = rsSalarioBase.CSid >
		
				<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#vRHCSid#"/>
					<cfinvokeargument name="fecha" value="#desde#"/>
					<cfinvokeargument name="RHMPPid" value="#vRHMPPid#"/>
					<cfinvokeargument name="RHTTid" value="#vRHTTid#"/>
					<cfinvokeargument name="RHCid" value="#vRHCid#"/>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#vNegociado#"/>
					<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
					<cfinvokeargument name="Unidades" value="#vCantidad#"/>
					<cfinvokeargument name="MontoBase" value="0.00"/>
					<cfinvokeargument name="Monto" value="#vMonto#"/>
					<cfinvokeargument name="TablaComponentes" value="RHCSolicitud"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHSPid"/>
					<cfinvokeargument name="ValorLlaveTC" value="#form.RHSPid#"/>
					<cfinvokeargument name="CampoMontoTC" value="Monto"/>
				</cfinvoke>
			<cfif calculaComponenteRet.recordcount gt 0>
				<cfquery datasource="#session.DSN#">
					update RHCSolicitud
					set Cantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteRet.Unidades#">,
						Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.Monto#">
					where RHCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHCSid#" >
				</cfquery>
			</cfif>
			</cfif>
		</cfloop>
		
	</cfif>
<!--------------------------------------------------------------MODO APLICAR--------------------------------------------------------------------------------------->
	<cfif IsDefined("form.Aplicar")>	
		<!--- tiene componentes --->	
		<cfif isdefined("form.modulo") and trim(form.modulo) eq 'pp'>
			<cfquery name="data" datasource="#session.DSN#">
				select 1
				from RHCSolicitud
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHSPid#">
			</cfquery>			
			<cfif data.recordcount eq 0>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ErrorDebeIncluirAlMenosUnComponenteSalarialEnLaDefinicionDeLaSolicitudDePlaza"
					Default="Error! Debe incluir al menos un Componente Salarial en la definici&oacute;n de la Solicitud de Plaza"
					returnvariable="MSG_ErrorDebeIncluirAlMenosUnComponenteSalarialEnLaDefinicionDeLaSolicitudDePlaza"/>

				<cf_throw message="#MSG_ErrorDebeIncluirAlMenosUnComponenteSalarialEnLaDefinicionDeLaSolicitudDePlaza#." errorcode="7030">
			</cfif>
		</cfif>
		<!---_________________________________________________INSERTAR CONCURSOS______________________________________________________--->
		<cfquery name="rsConc" datasource="#session.dsn#">
			select CFid, RHSPconsecutivo,RHMPPid,RHSPcantidad,RHSPfdesde,RHPcodigo,RHSPfhasta
			from 
			RHSolicitudPlaza
			where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
		</cfquery>
		
		<cfif valTab.Pvalor eq 1 or valTab1.cantidad eq 1>
			<cfquery name="busPuesto" datasource="#session.dsn#">
				select RHPcodigo from RHPuestos where RHMPPid = #rsConc.RHMPPid#
			</cfquery>
			<cfif isdefined ('form.modulo') and form.modulo eq 'pp' or form.modulo eq 'rs'>
				<cfif busPuesto.recordcount eq 0>
					<cfthrow message="No existe relación entre el Puesto de Planilla Presupuestaria y Recursos Humanos">
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="busPuesto" datasource="#session.dsn#">
				select RHPcodigo from RHPuestos where RHPcodigo = '#form.RHPcodigo#'
			</cfquery>
			<cfif busPuesto.recordcount eq 0>
				<cfthrow message="No se ha definido el puesto">
			</cfif>
		</cfif>						
		<cfif form.modulo eq 'rs' or (form.modulo eq 'pp' and rsAG.Pvalor eq 1)>
			<cfquery name="inConcurso" datasource="#session.dsn#">
				insert into RHConcursos 
					(Ecodigo,
					RHCcodigo,
					RHCdescripcion,
					CFid,
					RHCfecha,
					RHPcodigo,
					RHCcantplazas,
					RHCfcierre,
					Usucodigo,
					RHCestado,
					RHCfapertura,
					RHCmotivo) 
				values(
					#session.Ecodigo#,
					'CG'#LvarCNCT#'#rsConc.RHSPconsecutivo#',
					'Concurso generado por la Solicitud de plaza N°'#LvarCNCT#'#rsConc.RHSPconsecutivo#',
					#rsConc.CFid#,
					#now()#,
					'#busPuesto.RHPcodigo#',
					#rsConc.RHSPcantidad#,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsConc.RHSPfhasta#">,					
					#session.Usucodigo#,
					15,
					#now()#,
					5
					)
			</cfquery>
		</cfif>
			
		<!------>
		<cfquery datasource="#session.dsn#">
			update 	RHSolicitudPlaza 
			set	RHSPestado = 
				<cfif form.modulo EQ 'pp' and rsAG.Pvalor eq 0>20
				<cfelseif form.modulo EQ 'rs'>40
				<cfelseif form.modulo eq 'pp' and rsAG.Pvalor eq 1>40
				<cfelseif valTab.Pvalor eq 0>20
				<cfelse>10
				</cfif>
				<cfif form.modulo EQ 'pp'>
					, Usucodigorev = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					, fecharev = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				<cfelse>
					, Usucodigorev = null
					, fecharev = null
				</cfif>
			where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
		</cfquery>
		
		<cfif isdefined("form.modulo") and form.modulo EQ 'pp' or form.modulo eq 'rs'>
		<!----_____________________________________________ACTUALIZAR EL COMPLEMENTO (EN EL CAMPO CFformato)__________________________________________----->
			<cfquery name="rsUpdateCFormato" datasource="#session.DSN#">
				update RHCSolicitud 
					set CFformato = d.CIcuentac 
				from  RHCSolicitud b
					inner join ComponentesSalariales c
						on b.CSid = c.CSid
						and b.Ecodigo = c.Ecodigo
					
						inner join CIncidentes d
							on c.CIid = d.CIid
							and c.Ecodigo = d.Ecodigo
				
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and b.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
			</cfquery>
		</cfif>
		<!---_____________________________________________Envio de correo informando el estado de la solicitud___________________________________________--->
		<cfif isdefined ('form.modulo') and form.modulo EQ 'rs' or form.modulo EQ 'pp'>
			<cfquery name="selEmp" datasource="#session.dsn#">
				select BMUsucodigo,RHSPconsecutivo from RHSolicitudPlaza where RHSPid=#form.RHSPid#
			</cfquery>
			
			<cfquery name="empleado" datasource="#session.DSN#">
				select coalesce(llave, '0') as DEid 
				from UsuarioReferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#selEmp.BMUsucodigo#">
				  and STabla = 'DatosEmpleado'
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
				union
				select '0' as DEid from dual
			</cfquery>
			<cfquery name="mail" datasource="#session.dsn#">
				select DEemail ,DEnombre#LvarCNCT# ' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 as nombre,DEid,DEsexo from DatosEmpleado where DEid=#empleado.DEid#
			</cfquery>
			
			<cfif mail.DEsexo eq 'F'>
				<cfset etiqueta='Estimada'>
			<cfelse>
				<cfset etiqueta='Estimado'>
			</cfif>
			
			<cfif isdefined ('form.modulo') and form.modulo EQ 'pp'>
				<cfset modu='Planilla Presupuestaria'>
			<cfelseif  isdefined ('form.modulo') and form.modulo EQ 'rs'>
				<cfset modu='Reclutamiento y Selección'>
			</cfif>
			
			<cfquery name="valPlan" datasource="#session.dsn#">
				select Pvalor from RHParametros where Pcodigo=540
			</cfquery>
			
			<cfquery name="desc" datasource="#session.dsn#">
				select RHMPPcodigo#LvarCNCT#'-'#LvarCNCT# RHMPPdescripcion as puesto from RHMaestroPuestoP where RHMPPid=#form.RHMPPid#
			</cfquery>
			<cfif desc.recordcount eq 0>
				<cfquery name="desc" datasource="#session.dsn#">
					select RHPdescpuesto as puesto from RHPuestos where RHPcodigo='#form.RHPcodigo#'
				</cfquery>
			</cfif>

			<cfif len(trim(mail.DEemail)) gt 0>
				<cfset email_subject = "Información del solicitud de plaza. Puesto:#desc.puesto#">
				<cfset email_from = "Administrador del Portal">
				<cfset email_to = '#mail.DEemail#'>
				<cfset email_cc = ''>
				
				<cfsavecontent variable="email_body">
					<html>
					<head></head>
					<body>
						<!---Cuerpo del correo--->
						<table>				
							<cfoutput>			
							<tr bgcolor="CCCCCC">
								<td bgcolor="CCCCCC" align="center"><strong>Informaci&oacute;n Plaza</strong></td>
							</tr>
							<tr>
								<td><strong>Estimado(a): </strong>#mail.nombre#</td></br>
							</tr>
							<tr>
								<td>
									Se le informa que su solicitud de plaza para el puesto:<strong>#desc.puesto#</strong> correspondiente a la solicitud:#selEmp.RHSPconsecutivo#
									a sido aprobada en #modu#</br>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje. </br></td>
							</td>
							</cfoutput>							
						</table>
						<!------>
					</body>
					</html>
					</cfsavecontent>
					
					<cfquery datasource="minisif">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
					</cfquery>
			</cfif>
		</cfif>
		<!------>
	</cfif>
</cftransaction>		
	
<cfelseif IsDefined("form.Rechazar")>
	<!---Envio de correo en caso de que se rechace--->
	<cfif isdefined ('form.modulo') and form.modulo EQ 'rs' or form.modulo EQ 'pp'>
			<cfquery name="selEmp" datasource="#session.dsn#">
				select BMUsucodigo,RHSPconsecutivo from RHSolicitudPlaza where RHSPid=#form.RHSPid#
			</cfquery>
			
			<cfquery name="empleado" datasource="#session.DSN#">
				select coalesce(llave, '0') as DEid 
				from UsuarioReferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#selEmp.BMUsucodigo#">
				  and STabla = 'DatosEmpleado'
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			</cfquery>
			
			<cfquery name="mail" datasource="#session.dsn#">
				select DEemail ,DEnombre#LvarCNCT# ' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 as nombre,DEid,DEsexo from DatosEmpleado where DEid=#empleado.DEid#
			</cfquery>
			
			<cfif mail.DEsexo eq 'F'>
				<cfset etiqueta='Estimada'>
			<cfelse>
				<cfset etiqueta='Estimado'>
			</cfif>
			
			<cfif isdefined ('form.modulo') and form.modulo EQ 'pp'>
				<cfset modu='Planilla Presupuestaria'>
			<cfelseif  isdefined ('form.modulo') and form.modulo EQ 'rs'>
				<cfset modu='Reclutamiento y Selección'>
			</cfif>
			
			<cfquery name="valPlan" datasource="#session.dsn#">
				select Pvalor from RHParametros where Pcodigo=540
			</cfquery>
			
			<cfquery name="desc" datasource="#session.dsn#">
				select RHMPPcodigo#LvarCNCT#'-'#LvarCNCT# RHMPPdescripcion as puesto from RHMaestroPuestoP where RHMPPid=#form.RHMPPid#
			</cfquery>
			<cfif desc.recordcount eq 0>
				<cfquery name="desc" datasource="#session.dsn#">
					select RHPdescpuesto as puesto from RHPuestos where RHPcodigo=#form.RHPcodigo#
				</cfquery>
			</cfif>

			<cfif len(trim(mail.DEemail)) gt 0>
				<cfset email_subject = "Información del solicitud de plaza. Puesto:#desc.puesto#">
				<cfset email_from = "Administrador del Portal">
				<cfset email_to = '#mail.DEemail#'>
				<cfset email_cc = ''>
				
				<cfsavecontent variable="email_body">
					<html>
					<head></head>
					<body>
						<!---Cuerpo del correo--->
						<table>				
							<cfoutput>			
							<tr bgcolor="CCCCCC">
								<td bgcolor="CCCCCC" align="center"><strong>Informaci&oacute;n Plaza</strong></td>
							</tr>
							<tr>
								<td><strong>Estimado(a): </strong>#mail.nombre#</td></br>
							</tr>
							<tr>
								<td>
									Se le informa que su solicitud de plaza para el puesto:<strong>#desc.puesto#</strong> correspondiente a la solicitud:#selEmp.RHSPconsecutivo#
									a sido rechazada en #modu#</br>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje. </br></td>
							</td>
							</cfoutput>							
						</table>
						<!------>
					</body>
					</html>
					</cfsavecontent>
					
					<cfquery datasource="minisif">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
					</cfquery>
			</cfif>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update 	RHSolicitudPlaza 
			set RHSPestado = 30
			where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
		</cfquery>
		<!------>
	
<!-----------------------------------------------------------------APLICAR MASIVO--------------------------------------------------------------------------->
<cfelseif IsDefined("form.btnAplicar")>

	<cfif isdefined("form.chk") >
		<cfloop list="#form.chk#" delimiters="," index="i">
			<cfquery name="rsConc" datasource="#session.dsn#">
				select CFid, RHSPconsecutivo,RHMPPid,RHSPcantidad,RHSPfdesde,RHPcodigo
				from 
				RHSolicitudPlaza
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
						
			<cfif valTab.Pvalor eq 1 or valTab1.cantidad eq 1>
				
				<cfquery name="busPuesto" datasource="#session.dsn#">
					select RHPcodigo from RHPuestos where RHMPPid = #rsConc.RHMPPid#
				</cfquery>
				<cfif isdefined ('form.modulo') and form.modulo eq 'pp' or form.modulo eq 'rs'>
					<cfif busPuesto.recordcount eq 0>
						<cfthrow message="No existe relación entre el Puesto de Planilla Presupuestaria y Recursos Humanos">
					</cfif>
				</cfif>
			<cfelse>
			
				<cfquery name="busPuesto" datasource="#session.dsn#">
					select RHPcodigo from RHPuestos where RHPcodigo = '#rsConc.RHPcodigo#'
				</cfquery>
				<cfif busPuesto.recordcount eq 0>
					<cfthrow message="No se ha definido el puesto">
				</cfif>
			</cfif>					
		</cfloop>
		
		<cfloop list="#form.chk#" delimiters="," index="i">		
			<cfif isdefined("form.modulo") and trim(form.modulo) eq 'pp'>
				<cfquery name="data" datasource="#session.DSN#">
					select 1 
					from RHCSolicitud
					where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
				<cfif data.recordcount eq 0>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ErrorDebeIncluirAlMenosUnComponenteSalarialEnLaDefinicionDeLaSolicitudDePlaza"
						Default="Error! Debe incluir al menos un Componente Salarial en la definici&oacute;n de la Solicitud de Plaza"
						returnvariable="MSG_ErrorDebeIncluirAlMenosUnComponenteSalarialEnLaDefinicionDeLaSolicitudDePlaza"/>
					
						<cf_throw message="#MSG_ErrorDebeIncluirAlMenosUnComponenteSalarialEnLaDefinicionDeLaSolicitudDePlaza#." errorcode="7030">
				</cfif>
			</cfif>

			<!---_________________________________________________INSERTAR CONCURSOS______________________________________________________--->
			<cfquery name="rsConc" datasource="#session.dsn#">
				select CFid, RHSPconsecutivo,RHMPPid,RHSPcantidad,RHSPfdesde,RHPcodigo,RHSPfhasta
				from 
				RHSolicitudPlaza
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			
			<cfif valTab.Pvalor eq 1 or valTab1.cantidad eq 1>
				<cfquery name="busPuesto" datasource="#session.dsn#">
					select RHPcodigo from RHPuestos where RHMPPid = #rsConc.RHMPPid#
				</cfquery>
			<cfelse>
				<cfquery name="busPuesto" datasource="#session.dsn#">
					select RHPcodigo from RHPuestos where RHPcodigo = '#rsConc.RHPcodigo#'
				</cfquery>
			</cfif>		
				
			<cfif form.modulo eq 'rs' or (form.modulo eq 'pp' and rsAG.Pvalor eq 1)>
				<cfquery name="inConcurso" datasource="#session.dsn#">
					insert into RHConcursos 
						(Ecodigo,
						RHCcodigo,
						RHCdescripcion,
						CFid,
						RHCfecha,
						RHPcodigo,
						RHCcantplazas,
						RHCfcierre,
						Usucodigo,
						RHCestado,
						RHCfapertura,
						RHCmotivo) 
					values(
						#session.Ecodigo#,
						'CG'#LvarCNCT#'#rsConc.RHSPconsecutivo#',
						'Concurso generado por la Solicitud de plaza N°'#LvarCNCT#'#rsConc.RHSPconsecutivo#',
						#rsConc.CFid#,
						#now()#,
						'#busPuesto.RHPcodigo#',
						#rsConc.RHSPcantidad#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsConc.RHSPfhasta#">,					
						#session.Usucodigo#,
						15,
						#now()#,
						5
						)
				</cfquery>
			</cfif>
				
			<!------>
		
		<!---_____________________________________________Envio de correo informando el estado de la solicitud___________________________________________--->
		<cfif isdefined ('form.modulo') and form.modulo EQ 'rs' or form.modulo EQ 'pp'>
			<cfquery name="selEmp" datasource="#session.dsn#">
				select BMUsucodigo,RHSPconsecutivo,RHMPPid,RHPcodigo from RHSolicitudPlaza where RHSPid=#i#
			</cfquery>
			
			<cfquery name="empleado" datasource="#session.DSN#">
				select coalesce(llave, '0') as DEid 
				from UsuarioReferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#selEmp.BMUsucodigo#">
				  and STabla = 'DatosEmpleado'
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			</cfquery>
			
			<cfquery name="mail" datasource="#session.dsn#">
				select DEemail ,DEnombre#LvarCNCT# ' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 as nombre,DEid,DEsexo from DatosEmpleado where DEid=#empleado.DEid#
			</cfquery>
			
			<cfif mail.DEsexo eq 'F'>
				<cfset etiqueta='Estimada'>
			<cfelse>
				<cfset etiqueta='Estimado'>
			</cfif>
			
			<cfif isdefined ('form.modulo') and form.modulo EQ 'pp'>
				<cfset modu='Planilla Presupuestaria'>
			<cfelseif  isdefined ('form.modulo') and form.modulo EQ 'rs'>
				<cfset modu='Reclutamiento y Selección'>
			</cfif>
			
			<cfquery name="valPlan" datasource="#session.dsn#">
				select Pvalor from RHParametros where Pcodigo=540
			</cfquery>
			
			<cfif len(trim(selEmp.RHMPPid)) gt 0>
				<cfquery name="desc" datasource="#session.dsn#">
					select RHMPPcodigo#LvarCNCT#'-'#LvarCNCT# RHMPPdescripcion as puesto from RHMaestroPuestoP where RHMPPid=#selEmp.RHMPPid#
				</cfquery>
			<cfelse>
				<cfquery name="desc" datasource="#session.dsn#">
					select RHPdescpuesto as puesto from RHPuestos where RHPcodigo='#selEmp.RHPcodigo#'
				</cfquery>
			</cfif>			

			<cfif len(trim(mail.DEemail)) gt 0>
				<cfset email_subject = "Información del solicitud de plaza. Puesto:#desc.puesto#">
				<cfset email_from = "Administrador del Portal">
				<cfset email_to = '#mail.DEemail#'>
				<cfset email_cc = ''>
				
				<cfsavecontent variable="email_body">
					<html>
					<head></head>
					<body>
						<!---Cuerpo del correo--->
						<table>				
							<cfoutput>			
							<tr bgcolor="CCCCCC">
								<td bgcolor="CCCCCC" align="center"><strong>Informaci&oacute;n Plaza</strong></td>
							</tr>
							<tr>
								<td><strong>Estimado(a): </strong>#mail.nombre#</td></br>
							</tr>
							<tr>
								<td>
									Se le informa que su solicitud de plaza para el puesto:<strong>#desc.puesto#</strong> correspondiente a la solicitud:#selEmp.RHSPconsecutivo#
									a sido aprobada en #modu#</br>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje. </br></td>
							</td>
							</cfoutput>							
						</table>
						<!------>
					</body>
					</html>
					</cfsavecontent>
					
					<cfquery datasource="minisif">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
					</cfquery>
			</cfif>
		</cfif>
		<!------>
			<cfquery datasource="#session.dsn#">
				update 	RHSolicitudPlaza 
				set	RHSPestado = 
				<cfif form.modulo EQ 'pp' and rsAG.Pvalor eq 0>20
				<cfelseif form.modulo EQ 'rs'>40
				<cfelseif form.modulo eq 'pp' and rsAG.Pvalor eq 1>40
				<cfelseif valTab.Pvalor eq 0>20
				<cfelse>10
				</cfif>
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>					
			
			<cfif isdefined("form.modulo") and trim(form.modulo) eq 'pp'>
				<!----/////////////////////////// ACTUALIZAR EL COMPLEMENTO (EN EL CAMPO CFformato) ///////////////////////////////----->
				<cfquery name="rsUpdateCFormato" datasource="#session.DSN#">
					update RHCSolicitud 
						set CFformato = d.CIcuentac					
					from RHCSolicitud b					
						inner join ComponentesSalariales c
							on b.CSid = c.CSid
							and b.Ecodigo = c.Ecodigo
						
							inner join CIncidentes d
								on c.CIid = d.CIid
								and c.Ecodigo = d.Ecodigo
					
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and b.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
			</cfif>
		</cfloop>	
	</cfif>

	<cfif isdefined("form.modulo") and trim("form.modulo") eq 'aut'>
		<cflocation url="../../autogestion/operacion/solicitudPlazasAUT.cfm">
	</cfif>	
	<cfif isdefined("form.modulo") and trim("form.modulo") eq 'rs'>
		<cflocation url="../../Reclutamiento/operacion/solicitudplaza.cfm">
	</cfif>	
	
<!-------------------------------------------------------------------------------------------------------------------------------------------->
<cfelseif IsDefined("form.btnRechazar")>
	<cfif isdefined("form.chk") >
		<cfloop list="#form.chk#" delimiters="," index="i">
			<!---____________________Envio de Correo________________________________________--->
			<cfif isdefined ('form.modulo') and form.modulo EQ 'rs' or form.modulo EQ 'pp'>
			<cfquery name="selEmp" datasource="#session.dsn#">
				select BMUsucodigo,RHSPconsecutivo,RHMPPid,RHPcodigo from RHSolicitudPlaza where RHSPid=#i#
			</cfquery>
			
			<cfquery name="rsConc" datasource="#session.dsn#">
				select CFid, RHSPconsecutivo,RHMPPid,RHSPcantidad,RHSPfdesde,RHPcodigo
				from 
				RHSolicitudPlaza
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>

			<cfif valTab.Pvalor eq 1 or valTab1.cantidad eq 1>
				<cfquery name="busPuesto" datasource="#session.dsn#">
					select RHPcodigo from RHPuestos where RHMPPid = #rsConc.RHMPPid#
				</cfquery>
				<cfif isdefined ('form.modulo') and form.modulo eq 'pp' or form.modulo eq 'rs'>
					<cfif busPuesto.recordcount eq 0>
						<cfthrow message="No existe relación entre el Puesto de Planilla Presupuestaria y Recursos Humanos">
					</cfif>
				</cfif>
			<cfelse>
				<cfquery name="busPuesto" datasource="#session.dsn#">
					select RHPcodigo from RHPuestos where RHPcodigo = '#rsConc.RHPcodigo#'
				</cfquery>
			</cfif>					
						
			<cfquery name="empleado" datasource="#session.DSN#">
				select coalesce(llave, '0') as DEid 
				from UsuarioReferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#selEmp.BMUsucodigo#">
				  and STabla = 'DatosEmpleado'
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			</cfquery>
			
			<cfquery name="mail" datasource="#session.dsn#">
				select DEemail ,DEnombre#LvarCNCT# ' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 as nombre,DEid,DEsexo from DatosEmpleado where DEid=#empleado.DEid#
			</cfquery>
			
			<cfif mail.DEsexo eq 'F'>
				<cfset etiqueta='Estimada'>
			<cfelse>
				<cfset etiqueta='Estimado'>
			</cfif>
			
			<cfif isdefined ('form.modulo') and form.modulo EQ 'pp'>
				<cfset modu='Planilla Presupuestaria'>
			<cfelseif  isdefined ('form.modulo') and form.modulo EQ 'rs'>
				<cfset modu='Reclutamiento y Selección'>
			</cfif>
			
			<cfquery name="valPlan" datasource="#session.dsn#">
				select Pvalor from RHParametros where Pcodigo=540
			</cfquery>
			
			<cfif len(trim(selEmp.RHMPPid)) gt 0>
			<cfquery name="desc" datasource="#session.dsn#">
				select RHMPPcodigo#LvarCNCT#'-'#LvarCNCT# RHMPPdescripcion as puesto from RHMaestroPuestoP where RHMPPid=#selEmp.RHMPPid#
			</cfquery>
			<cfelse>
				<cfquery name="desc" datasource="#session.dsn#">
					select RHPdescpuesto as puesto from RHPuestos where RHPcodigo='#selEmp.RHPcodigo#'
				</cfquery>
			</cfif>

			<cfif len(trim(mail.DEemail)) gt 0>
				<cfset email_subject = "Información del solicitud de plaza. Puesto:#desc.puesto#">
				<cfset email_from = "Administrador del Portal">
				<cfset email_to = '#mail.DEemail#'>
				<cfset email_cc = ''>
				
				<cfsavecontent variable="email_body">
					<html>
					<head></head>
					<body>
						<!---Cuerpo del correo--->
						<table>				
							<cfoutput>			
							<tr bgcolor="CCCCCC">
								<td bgcolor="CCCCCC" align="center"><strong>Informaci&oacute;n Plaza</strong></td>
							</tr>
							<tr>
								<td><strong>Estimado(a): </strong>#mail.nombre#</td></br>
							</tr>
							<tr>
								<td>
									Se le informa que su solicitud de plaza para el puesto:<strong>#desc.puesto#</strong> correspondiente a la solicitud:#selEmp.RHSPconsecutivo#
									a sido rechazada en #modu#</br>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje. </br></td>
							</td>
							</cfoutput>							
						</table>
						<!------>
					</body>
					</html>
					</cfsavecontent>
					
					<cfquery datasource="minisif">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
					</cfquery>
			</cfif>
		</cfif>
		<!------>
		<cfquery datasource="#session.dsn#">
			update 	RHSolicitudPlaza 
			set RHSPestado = 30
			where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
		</cfloop>	
	</cfif>

<!--- ELIMINAR COMPONENTES --->	
<cfelseif isdefined("form.btnEliminar.X") and isdefined("form.CSid_Borrar") and len(trim(form.CSid_Borrar)) >
	<cfquery datasource="#session.DSN#">
		delete RHCSolicitud
		where RHCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid_Borrar#">
		  and RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
	</cfquery>
	
	<!--- Recalcular todos los componentes --->
	<cfset recalcularComponentes(form.RHSPid) >

	<cfif isdefined("form.modulo") and trim(form.modulo) eq 'aut'>
		<cflocation url="solicitudPlazasAUT.cfm?RHSPid=#form.RHSPid#">
	<cfelse>
		<cflocation url="solicitudPlazas.cfm?RHSPid=#form.RHSPid#">
	</cfif>	
</cfif>

<!---
<cfif isdefined("form.Cambio") and isdefined("form.RHMPnegociado")>
	<cfquery datasource="#session.DSN#">
		delete  RHCSolicitud 
		from ComponentesSalariales a
		where RHCSolicitud.RHSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
		and a.CSsalariobase != 1
		and a.CSid=RHCSolicitud.CSid
		and RHCSolicitud.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<!--- Se hace sin filtro (RHCSid) porque se supone que para este punto, solo hay un registro --->
	<cfquery datasource="#session.DSN#">
		update RHCSolicitud 
		set Monto =  a.salarioref
		from RHSolicitudPlaza a
		where RHCSolicitud.RHSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
		and RHCSolicitud.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.RHSPid=RHCSolicitud.RHSPid
	</cfquery>
</cfif>
--->

<cfoutput>


<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
	<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
		<cfif not isdefined('form.Baja') and (isdefined('form.RHSPid') and form.RHSPid NEQ '')>
			<input name="RHSPid" type="hidden" value="#form.RHSPid#"> 
		</cfif> 
	<cfelseif isdefined('form.Nuevo')>
		<input name="btnNuevo" type="hidden" value="btnNuevo"> 		
	</cfif>
	<input type="hidden" name="dummy" value="1">
</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>



