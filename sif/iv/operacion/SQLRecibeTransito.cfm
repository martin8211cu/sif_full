<cfset modo="ALTA">
<cfset modoDet="ALTA">

<cftry>
	<cfif isdefined("Form.btnAgregarE")>
	<cftransaction>
		<cfquery name="ABC_ERecibeTransito" datasource="#Session.DSN#">

			insert into ERecibeTransito 
			(
				Ecodigo,
				ERTfecha, 
				ERTaplicado, 
				Usucodigo, 
				Ulocalizacion, 
				ERTdocref, 
				ERTobservacion
			)			
				values 
			( 
				#Session.Ecodigo#,
				#lsparsedatetime(form.ERTfecha)#,
				0,
				#Session.Usucodigo#,
				'#Session.Ulocalizacion#',
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.ERTdocref#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.ERTobservacion)#">
			)
                <cf_dbidentity1 datasource="#Session.DSN#">
        </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="ABC_ERecibeTransito" returnvariable="ID">
	</cftransaction>

		<cfset modo="CAMBIO">

		<cfset modoDet="ALTA">

	<cfelseif isdefined("Form.btnBorrarE")>

		<cfquery name="ABC_ERecibeTransito1" datasource="#Session.DSN#">
			update Transito 
  				set Trecibido = coalesce(( select sum(coalesce(d.DRTcantidad, 0.00) - coalesce(d.DRTgananciaperdida, 0)) 
                     from DRecibeTransito d 
                       where d.Tid = Transito.Tid 
                       and d.ERTid <><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#">) , 0) 
				where (select count(1) 
        				from DRecibeTransito b 
        				where Transito.Tid = b.Tid
        				and b.ERTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#"> ) > 0 
		</cfquery>

		<cfquery name="ABC_ERecibeTransito2" datasource="#Session.DSN#">
			delete from DRecibeTransito
			where ERTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#">
		</cfquery>
				
		<cfquery name="ABC_ERecibeTransito3" datasource="#Session.DSN#">
			delete from ERecibeTransito
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and ERTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#">
		</cfquery>

		<cfset modo="ALTA">
		<cfset modoDet="ALTA">

	<cfelseif isdefined("Form.btnAgregarD")>
		<cf_dbtimestamp
					datasource="#session.dsn#"
					table="ERecibeTransito" 
					redirect="RecibeTransito.cfm"
					timestamp="#Form.timestampE#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="ERTid,numeric,#Form.ERTid#">
			
		<cfquery name="ABC_ERecibeTransito1" datasource="#Session.DSN#">
			update ERecibeTransito
			set ERTfecha = <cf_dbfunction name="to_date"  args="#Form.ERTfecha#">,
			ERTdocref =      <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ERTdocref#">,
			ERTobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.ERTobservacion)#">
			where Ecodigo =   #Session.Ecodigo# 
			  and ERTid =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#">
		</cfquery>
			
		<cf_dbfunction name="today"	returnvariable="hoy">
		<cfquery name="ABC_ERecibeTransito2" datasource="#Session.DSN#">
			insert into DRecibeTransito (ERTid, Tid, Alm_Aid, DRTcantidad, Aid, DRTfecha,
			Ddocumento, DRTcostoU, Ucodigo, Kunidades, Kcosto, DRTembarque, DRTgananciaperdida)
			values 
			(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Alm_Aid#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRTcantidad#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.Aid#">,
				<cf_dbfunction name="to_date"	args="#hoy#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRTcostoU#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ucodigo#">,
				0.00,
				0.00,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DRTembarque#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DRTgananciaperdida#">
				)
		</cfquery>

		<cfquery name="ABC_ERecibeTransito" datasource="#Session.DSN#">
			update Transito
				set Trecibido = coalesce((
						select sum(coalesce(d.DRTcantidad, 0.00) - coalesce(d.DRTgananciaperdida, 0))
						from DRecibeTransito d
						where d.Tid = Transito.Tid
						) , 0)
			where Transito.Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">
		</cfquery>

		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">				

	<cfelseif isdefined("Form.btnBorrarD")>

		<cfquery name="ABC_ERecibeTransito" datasource="#Session.DSN#">
			delete from DRecibeTransito
			where ERTid = <cfqueryparam value="#form.ERTid#" cfsqltype="cf_sql_numeric">
			  and DRTlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRTlinea#">
		</cfquery>
	  
			<cfif isDefined("Form.Tid") and Len(Trim(Form.Tid)) GT 0>

				<cfquery name="ABC_ERecibeTransitoActualiza" datasource="#Session.DSN#">
					update Transito
						set Trecibido = coalesce((
								select sum(coalesce(d.DRTcantidad, 0.00) - coalesce(d.DRTgananciaperdida, 0))
								from DRecibeTransito d
								where d.Tid = Transito.Tid
								) , 0)
					where Transito.Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">
				</cfquery>

			</cfif>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">								  

	<cfelseif isdefined("Form.btnCambiarD")>		
		
			<cf_dbtimestamp
					datasource="#session.dsn#"
					table="ERecibeTransito" 
					redirect="RecibeTransito.cfm"
					timestamp="#Form.timestampE#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="ERTid,numeric,#Form.ERTid#">
					
		<cfquery name="ABC_ERecibeTransito1" datasource="#Session.DSN#">
			update ERecibeTransito
			set ERTfecha 	   = <cf_jdbcquery_param cfsqltype="cf_sql_date"    value="#LSParseDateTime(Form.ERTfecha)#">,
			    ERTdocref 	   = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.ERTdocref#" 			len="20">,
			    ERTobservacion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#trim(Form.ERTobservacion)#" len="255">
			    where Ecodigo  = #Session.Ecodigo# 
			  and ERTid =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#">				
		</cfquery>

			<cf_dbtimestamp
					datasource="#session.dsn#"
					table="DRecibeTransito" 
					redirect="RecibeTransito.cfm"
					timestamp="#Form.timestampD#"
					field1="ERTid,numeric,#form.ERTid#"
					field2="DRTlinea,numeric,#Form.DRTlinea#">
					
		<cfquery name="ABC_ERecibeTransito2" datasource="#Session.DSN#">
			update DRecibeTransito set
				DRTcantidad 		= <cfqueryparam cfsqltype="cf_sql_float"   value="#Form.DRTcantidad#">, 
				DRTcostoU 			= <cfqueryparam cfsqltype="cf_sql_money"   value="#Form.DRTcostoU#">,
				DRTembarque 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.DRTembarque#" len="20">,
				DRTgananciaperdida 	= <cfqueryparam cfsqltype="cf_sql_money"   value="#Form.DRTgananciaperdida#">
			where ERTid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERTid#"    >
			  and DRTlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRTlinea#">
		</cfquery>

			<cfif isDefined("Form.Tid") and Len(Trim(Form.Tid)) GT 0>  

				<cfquery name="ABC_ERecibeTransito" datasource="#Session.DSN#">
					update Transito
						set Trecibido = coalesce((
								select sum(coalesce(d.DRTcantidad, 0.00) - coalesce(d.DRTgananciaperdida, 0))
								from DRecibeTransito d
								where d.Tid = Transito.Tid
								) , 0)
					where Transito.Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">
				</cfquery>

			</cfif>
			
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">
			
		<cfelseif isdefined("Form.btnBorrarSel")>							
			<cfif isDefined("Form.chk")>				
				<cfset arreglo = ListToArray(Form.Chk,',')>
				<cfloop index="j" from="1" to="#ArrayLen(arreglo)#">		
					<cfset subarreglo = ListToArray(arreglo[j],'|')>
					
					<cfset ERTid = subarreglo[1]>
					<cfset DRTlinea = subarreglo[2]>
					<cfset Tid = subarreglo[3]>
					<cfset DRTcantidad = subarreglo[4]>
					<cfset DRTgananciaperdida = subarreglo[5]>

					<cfquery name="ABC_ERecibeTransito1" datasource="#Session.DSN#">
						delete from DRecibeTransito
						where ERTid = #ERTid#
						  and DRTlinea  = #DRTlinea#
					</cfquery>

					<cfquery name="ABC_ERecibeTransito2" datasource="#Session.DSN#">
						update Transito
							set Trecibido = coalesce((
									select sum(coalesce(d.DRTcantidad, 0.00) - coalesce(d.DRTgananciaperdida, 0))
									from DRecibeTransito d
									where d.Tid = Transito.Tid
									) , 0)
						where Transito.Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Tid#">
					</cfquery>

				</cfloop>				
			</cfif>

			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">	
		<cfelseif isDefined("btnNuevo")>		
			<cfset modo="ALTA">
			<cfset modoDet="ALTA">	
		<cfelseif isDefined("btnNuevoD")>		
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">
		<cfelseif isDefined("btnAplicar")>	

		<cfinvoke component="sif.Componentes.IN_PosteoRecibeTransito" method="Recibo_de_Productos_en_Transito">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#" >
			<cfinvokeargument name="ERTid" value="#Form.ERTid#" >
		</cfinvoke>

			<cfset modo="ALTA">
			<cfset modoDet="ALTA">		
		</cfif>
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

<form action="RecibeTransito.cfm" method="post" name="sql">
	<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">	
	<cfif isdefined("ID")>
	   	<input name="ERTid" type="hidden" value="#ID#">
	<cfelseif isDefined("btnNuevo")>
		<input name="ERTid" type="hidden" value="">
	<cfelseif isDefined("btnBorrarSel")>
		<input name="ERTid" type="hidden" value="#Form.ERTid_#">
	<cfelse>
		<input name="ERTid" type="hidden" value="<cfif isdefined("Form.ERTid") and modo NEQ "ALTA">#Form.ERTid#</cfif>">
	</cfif>	
	
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>