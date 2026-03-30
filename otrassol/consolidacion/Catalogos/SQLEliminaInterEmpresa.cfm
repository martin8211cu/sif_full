<cfset params = "">
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
        	<cfset Cformatocxc = UCase("#form.cmayor_ccuentacxc#"&"-"&"#form.Cformato_Ccuentacxc#")>
            <cfset Cformatocxp = UCase("#form.cmayor_ccuentacxp#"&"-"&"#form.Cformato_Ccuentacxp#")>
			insert into Cons_CtaConEliminaInter1(CEcodigo, EcodigoEmp, CFCuentaContable,CFCuentaComplemento,CFdescripcion)
			values(<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#form.Ecodigo_Ccuentacxc#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Cformatocxc#" cfsqltype="cf_sql_char">,
                    <cfqueryparam value="#Cformatocxp#" cfsqltype="cf_sql_char">,
                    <cfqueryparam value="#form.CFdescripcion#" cfsqltype="cf_sql_char">
					)
		</cfquery>	
        	   
		<cfset params = params & '&Ecodigodest=#form.Ecodigo_Ccuentacxc#'>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select e.Ecodigo, e.Edescripcion
			from Cons_CtaConEliminaInter1 a
			inner join Empresas e
			   on e.Ecodigo = a.EcodigoEmp
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			order by Edescripcion
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.Ecodigo EQ form.Ecodigo_Ccuentacxc>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.Pagina = Ceiling(row / form.MaxRows)>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
        	<cfset Cformatocxc = "#form.cmayor_ccuentacxc#"&"-"&"#form.Cformato_Ccuentacxc#">
        
			delete from Cons_CtaConEliminaInter1
			where  CEcodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			  and  EcodigoEmp = <cfqueryparam value="#form.EcodigoEmp2#" cfsqltype="cf_sql_integer">              
              and  CFCuentaContable =<cfqueryparam value="#Cformatocxc#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select EcodigoEmp
			from Cons_CtaConEliminaInter1 
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by EcodigoEmp
		</cfquery>
		<cfif  Ceiling(rsPagina.RecordCount/form.MaxRows) lt form.Pagina and form.Pagina GT 1>
			<cfset form.Pagina  = rsPagina.RecordCount/form.MaxRows>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
    
		<cf_dbtimestamp 
			datasource="#session.dsn#"
			table="Cons_CtaConEliminaInter1"
			redirect="CtasEliminaInterempresa.cfm"
			timestamp="#form.ts_rversion#"
			field1="CEcodigo" 
			type1="integer" 
			value1="#session.Ecodigo#"
			field2="EcodigoEmp" 
			type2="integer" 
			value2="#form.EcodigoEmp2#"
			field3="CFCuentaContable" 
			type3="character" 
			value3="#form.Cformato_CcuentacxcAux#"            
		>	
		<cfquery name="update" datasource="#Session.DSN#">
        	<cfset Cformatocxc = "#form.cmayor_ccuentacxc#"&"-"&"#form.Cformato_Ccuentacxc#">
            <cfset Cformatocxp = "#form.cmayor_ccuentacxp#"&"-"&"#form.Cformato_Ccuentacxp#">
<!---Validación de cuenta y cuenta de mayor en Empresa Consolidación--->    
<!---			<cfif rsValidaCta.RecordCount EQ 0>
				<cfif rsCtaMayor.RecordCount EQ 0>
					<cflocation url="CtasEliminaInterempresa.cfm?errorCta=1&Ecodigodest=#form.Ecodigo_Ccuentacxc#&Cuenta=#form.Ccuentacxc#">
				<cfelse>
					<cfset Lprm_Fecha = createdate(Year(Now()),Month(Now()),Day(Now()))>
					<cftransaction>
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
							<cfinvokeargument name="Lprm_Cmayor"   value="#form.cmayor_ccuentacxc#"/>
							<cfinvokeargument name="Lprm_Cdetalle" value="#form.cformato_ccuentacxc#"/>
							<cfinvokeargument name="Lprm_Fecha"    value="#Lprm_Fecha#"/>		
							<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
							<cfinvokeargument name="Lprm_DSN" value="#session.DSN#"/>
							<cfinvokeargument name="Lprm_Ecodigo" value="#session.ecodigo#"/>
							<cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
							<cfinvokeargument name="Lprm_NoVerificarObras" value="true"/>
						</cfinvoke>
						<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
								<cflocation url="CtasEliminaInterempresa.cfm?errorCta=2&Ecodigodest=#form.Ecodigo_Ccuentacxc#&Cuenta=#form.Ccuentacxc#">
						</cfif>            
					</cftransaction>
				</cfif>
			</cfif>	
--->			
			update Cons_CtaConEliminaInter1 set
					EcodigoEmp = <cfqueryparam value="#form.Ecodigo_Ccuentacxc#" cfsqltype="cf_sql_integer">,
					CFCuentaContable   	= UPPER(<cfqueryparam value="#Cformatocxc#" cfsqltype="cf_sql_char">),
                    CFCuentaComplemento	= UPPER(<cfqueryparam value="#Cformatocxp#" cfsqltype="cf_sql_char">),
                    CFdescripcion 		= UPPER(<cfqueryparam value="#form.CFdescripcion#" cfsqltype="cf_sql_char">)
            where CEcodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  	and EcodigoEmp = <cfqueryparam value="#form.EcodigoEmp2#" cfsqltype="cf_sql_integer">
                  	and CFCuentaContable =<cfqueryparam value="#form.Cformato_CcuentacxcAux#" cfsqltype="cf_sql_char">
		</cfquery>      
		<cfset params = params & '&Ecodigodest=#form.Ecodigo_Ccuentacxc#'>
	</cfif>
</cfif>
        
<cflocation url="CtasEliminaInterempresa.cfm?Pagina=#form.Pagina##params#">

<!---<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
<cfoutput>
	<cf_dump var="#form#">  
</cfoutput>  
</body>
</HTML>
--->