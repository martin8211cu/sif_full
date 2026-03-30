<cfset LvarParamRetro = 0>            <!--- Asiento normal --->
<cfset LvarPeriodoActualConta = 0>
<cfset LvarMesActualConta = 0>
<cfset intercomp=0>
<cfif IsDefined("form.intercompany") and (form.intercompany EQ 0 or form.intercompany EQ 1)>
	<cfset intercomp=form.intercompany>
</cfif>

<cfquery name="rsLecturaParametros" datasource="#Session.DSN#">
	select Pvalor as Periodo 
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 30
</cfquery>

<cfif rsLecturaParametros.recordcount EQ 1>
	<cfset LvarPeriodoActualConta = rsLecturaParametros.Periodo>
</cfif>

<cfquery name="rsLecturaParametros" datasource="#Session.DSN#">
	select Pvalor as Mes 
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 40
</cfquery>

<cfif rsLecturaParametros.recordcount EQ 1>
	<cfset LvarMesActualConta = rsLecturaParametros.Mes>
</cfif>

<cfif LvarPeriodoActualConta GT form.Eperiodo OR LvarPeriodoActualConta EQ form.Eperiodo and LvarMesActualConta GT form.Emes>
	<cfset LvarParamRetro = 2> <!--- Asiento Retroactivo --->
	 <cfquery name="rsECtipo" datasource="#Session.DSN#">
                select Oorigen
               from HEContables a
				<cfif intercomp EQ 1>
                    inner join EControlDocInt di on a.IDcontable=di.idcontableori
					inner join HDContablesInt hdi on hdi.IDcontable=a.IDcontable
					and hdi.IDcontable=di.idcontableori
                </cfif>
                where a.IDcontable = #trim(Form.IDcontable)#
      </cfquery>
	   <cfif rsECtipo.recordCount GT 0>
            <cfset LvarOrigen = rsECtipo.Oorigen>
       </cfif>
<cfelse>
	<cfif isdefined("Form.IDcontable") and len(trim(Form.IDcontable))>
        
            <cfquery name="rsECtipo" datasource="#Session.DSN#">
                select a.ECtipo, Oorigen
               from HEContables a
				<cfif intercomp EQ 1>
                    inner join EControlDocInt di on a.IDcontable=di.idcontableori
					inner join HDContablesInt hdi on hdi.IDcontable=a.IDcontable
					and hdi.IDcontable=di.idcontableori
                </cfif>
                where a.IDcontable = #trim(Form.IDcontable)#
            </cfquery>

            <cfif rsECtipo.recordCount EQ 0 and intercomp EQ 1>
            	<cfset LvarParamRetro = 20>
            <cfelseif rsECtipo.recordCount GT 0>
            	<cfset LvarParamRetro = rsECtipo.ECtipo>
				<cfset LvarOrigen = rsECtipo.Oorigen>
            </cfif>
        
    </cfif>
</cfif>	

<cfinvoke returnvariable="Edoc" component="sif.Componentes.Contabilidad" method="Nuevo_Asiento" 
	Ecodigo="#Session.Ecodigo#" 
	Cconcepto="#form.Cconcepto#"
	Oorigen=" "
	Eperiodo="#form.Eperiodo#"
	Emes="#form.Emes#">
</cfinvoke>		

<cftransaction action="begin">
	<cfquery name="ABC_NuevoAsiento" datasource="#Session.DSN#">
		insert into EContables (Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario, ECusucodigo, ECfechacreacion, ECipcrea, ECestado, BMUsucodigo, ECtipo <cfif isdefined("Form.chkCopiarOri")>,Oorigen</cfif>)
		values (
			#Session.Ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Eperiodo#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Emes#">,
			#Edoc#,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.Efecha)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edocbase#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ereferencia#">,
			'N',
			'#Session.usuario#',
			#Session.Usucodigo#,
			<cf_dbfunction name="now">, 
			'#Session.sitio.ip#',
			0,
			#Session.Usucodigo#,
			#lvarParamRetro#
			<cfif isdefined("Form.chkCopiarOri")> 
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarOrigen#">
			</cfif>
		)
	
	  <cf_dbidentity1 datasource="#Session.DSN#">
	</cfquery>
	
	<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_NuevoAsiento">
	<cfif isdefined("ABC_NuevoAsiento.identity") and isdefined("Form.IDcontable")>
		
		<!--- insertar relacion entre asiento origen y el asiento copiado --->
		<cfquery  datasource="#Session.DSN#">
			INSERT INTO REContablesInt 
			(IDcontableOri, IDcontableGen, RECdetalle)
			values 
			(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">,
			#ABC_NuevoAsiento.identity#,
			'#LvarParamRetro# - Copiado <cfif isdefined("Form.chkReversar")>- Reversar </cfif>')
		</cfquery>      
		
		<cfquery name="ABC_DetalleAsiento" datasource="#Session.DSN#">
			insert INTO DContables(Ecodigo, IDcontable, Dlinea, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio)
				select #Session.Ecodigo#, 
					   #ABC_NuevoAsiento.identity#, 
					   Dlinea, 
					   <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Cconcepto#">, 
					   <cf_jdbcquery_param cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">, 
					   <cf_jdbcquery_param cfsqltype="cf_sql_smallint" value="#Form.Emes#">,
					   #Edoc#, 
					   Ocodigo, Ddescripcion, 
				<cfif isdefined("Form.chkReversar")>
					   case Dmovimiento
							when 'D' then 'C'
							when 'C' then 'D'
							else ''
					   end, 
				<cfelse>
					   Dmovimiento, 
				</cfif>
					   Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio
				from 
				<!--- copiar detalle original del asiento intercompañía --->
				<cfif intercomp EQ 1>
					HDContablesInt
				<cfelse>
					HDContables
				</cfif>
				where Ecodigo = #Session.Ecodigo#
				and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
		</cfquery>
				
	<cfelse>
		<cf_errorCode	code = "50244" msg = "Error en Copia de Detalles!.">
	</cfif>		
</cftransaction>


<form action="CopiaAsientos.cfm" method="post" name="sql">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



