<!------------------------------------- if del Mantenimiento de fechas de inactivación de la cuenta  -------------------------------->
<cfif isDefined("btnAceptar") or isDefined("btnCambiar") or isDefined("btnBorrar.X") >

	<cfif isDefined("btnAceptar")>
		<cfquery name="A_CInactivas" datasource="#Session.DSN#">
			insert INTO CFInactivas (CFcuenta, CFIdesde, CFIhasta, Usucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CFIdesde)#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CFIhasta)#">, 
				 #Session.Usucodigo# 
			)		
		</cfquery>
	
	<cfelseif isDefined("btnCambiar")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CFInactivas" 
			redirect="CuentasFinancieras.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#"
			timestamp="#form.ts_rversion#"
			field1="CFcuenta,numeric,#form.CFcuenta#"
			field2="CFIid,numeric,#form.CFIid#">
						
		<cfquery name="C_CInactivas" datasource="#Session.DSN#">
			update CFInactivas set
				CFIdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CFIdesde)#">, 
				CFIhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CFIhasta)#">, 
				Usucodigo =  #Session.Usucodigo# 
			where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">
			and CFIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFIid#">		
		</cfquery>
		
	<cfelseif isDefined("btnBorrar.X")>
		<cfquery name="B_CInactivas" datasource="#Session.DSN#">
			delete from CFInactivas 
			where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">
			and CFIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFIid#">
		</cfquery>
	</cfif>
		
<!------------------------------------------ if del mantenimiento de la cuenta contable ----------------------------------------->	
<cfelseif isDefined("btnCambiar") >

<cfelseif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CFinanciera" 
			redirect="CuentasFinancieras.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#"
			timestamp="#form.ts_rversion#"
			field1="CFcuenta,numeric,#form.CFcuenta#"
			field2="Ecodigo,numeric,#session.Ecodigo#">			
			
			<!----================ Si la cuenta financiera tiene una sola cuenta contable asociada =================----->
			<cfquery name="rsVerificaCtaC" datasource="#session.DSN#">
				select count(1) as ctsContables
				from CFinanciera a
					inner join CContables b
						on a.Ccuenta = b.Ccuenta
				where a.Ecodigo =  #Session.Ecodigo# 
			  		and a.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">  
			</cfquery>

			<cfif isdefined("rsVerificaCtaC") and rsVerificaCtaC.RecordCount NEQ 0 and rsVerificaCtaC.ctsContables EQ 1>
				<!---===== Actualiza CFinanciera.CFdescripcionF con el valor anterior de CFinanciera.CFdescripcion =======---->
				<cfquery datasource="#session.DSN#">
					update CFinanciera 
						set CFdescripcionF = CFdescripcion 
					where Ecodigo =  #Session.Ecodigo# 
						and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">  
				</cfquery>
				<!---===== Actualiza CContables.Cdescripcion con el valor anterior de CFinanciera.CFdescripcion =======---->
				<cfquery datasource="#session.DSN#">
					update CContables 
						set Cdescripcion = <!---(select b.CFdescripcion 
											 from CFinanciera b 
											where b.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">
										 	  and b.Ccuenta = CContables.Ccuenta 
											) --->
											(
                                                Select b.CFdescripcion 
                                                from CFinanciera b 
                                                where b.Ccuenta = CContables.Ccuenta 
                                                   and b.Ecodigo = CContables.Ecodigo 
                                                   and b.CFcuenta = (Select Min(CFcuenta) from CFinanciera b1 where b1.Ccuenta = CContables.Ccuenta )
                                             )                                
					where Ecodigo =  #Session.Ecodigo# 
					and (select count(1) 
					      from CFinanciera c 
						 where c.Ccuenta = CContables.Ccuenta 
						 and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">	
						 ) > 0
				</cfquery>
			</cfif>
			<!----===========================================================================================---->							
			<cfquery name="SelCFinanciera" datasource="#Session.DSN#">
				update CFinanciera set 				
					   <!----=====CFdescripcionF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFdescripcionF#" null="#Len(Trim(Form.CFdescripcionF)) EQ 0 OR (Trim(Form.CFdescripcion) EQ Trim(Form.CFdescripcionF))#">====---->
					  CFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFdescripcionF#">									  
				where Ecodigo =  #Session.Ecodigo# 
				  and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">
			</cfquery>
	</cfif>			

</cfif>

<cfoutput>

<form action="CuentasFinancieras.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#" method="post" name="sql">
	<input name="CFcuenta" type="hidden" value="<cfif isdefined('Form.CFcuenta')>#Form.CFcuenta#</cfif>">
	<input name="Cmayor" type="hidden" value="<cfif isdefined('Form.Cmayor')>#Form.Cmayor#</cfif>">
	<input name="formato" type="hidden" value="<cfif isdefined('Form.formato')>#Form.formato#</cfif>">
	<cfif not isdefined("form.Nuevo")>
		<input name="Pagina" type="hidden" value="<cfif isdefined('Form.Pagina')>#Form.Pagina#</cfif>">	
	</cfif>
 </form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>