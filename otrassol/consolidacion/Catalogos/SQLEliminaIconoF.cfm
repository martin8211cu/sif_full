<!---<cf_dump var="#form#">--->
<cfset params = "">
<cfset modo = "ALTA">

<cfquery name="rsValidaCta" datasource="#session.DSN#">
	select CGICCcuenta
	from CGIC_Catalogo
    where CGICCcuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentacxc#">
</cfquery>

<cfif rsValidaCta.RecordCount EQ 0>
	<cflocation url="CtasEliminaIconoF.cfm?errorCta=1&Cuenta=#form.CFcuentacxc#">
</cfif>	
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into Cons_CtaConEliminaIconoF(CEcodigo, EcodigoEmp, Ccuenta)
			values(<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#form.EcodigoEmp#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#form.CFcuentacxc#" cfsqltype="cf_sql_varchar">
					)
		</cfquery>	
        	   
		<cfset params = params & '&Ecodigodest=#form.EcodigoEmp#'>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select e.Ecodigo, e.Edescripcion
			from Cons_CtaConEliminaIconoF a
			inner join Empresas e
			   on e.Ecodigo = a.EcodigoEmp
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			order by Edescripcion
		</cfquery>
        
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.Ecodigo EQ form.EcodigoEmp>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.Pagina = Ceiling(row / form.MaxRows)>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from Cons_CtaConEliminaIconoF
			where  CEcodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
			  and  EcodigoEmp = <cfqueryparam value="#form.EcodigoEmp2#" cfsqltype="cf_sql_integer">              
              and  Ccuenta = <cfqueryparam value="#form.CcuentaAux#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select EcodigoEmp
			from Cons_CtaConEliminaInter 
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by EcodigoEmp
		</cfquery>
		<cfif  Ceiling(rsPagina.RecordCount/form.MaxRows) lt form.Pagina and form.Pagina GT 1>
			<cfset form.Pagina  = rsPagina.RecordCount/form.MaxRows>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp 
			datasource="#session.dsn#"
			table="Cons_CtaConEliminaIconoF"
			redirect="CtasEliminaIconoF.cfm"
			timestamp="#form.ts_rversion#"
			field1="CEcodigo" 
			type1="integer" 
			value1="#session.Ecodigo#"
			field2="EcodigoEmp" 
			type2="integer" 
			value2="#form.EcodigoEmp2#"
            field3="Ccuenta" 
			type3="varchar" 
			value3="#form.CcuentaAux#"
		>	
		<cfquery name="update" datasource="#Session.DSN#">
			update Cons_CtaConEliminaIconoF set
					EcodigoEmp = <cfqueryparam value="#form.EcodigoEmp#" cfsqltype="cf_sql_integer">,
					Ccuenta = <cfqueryparam value="#form.CFcuentacxc#" cfsqltype="cf_sql_varchar">
			where CEcodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
				  	and EcodigoEmp = <cfqueryparam value="#form.EcodigoEmp2#" cfsqltype="cf_sql_integer">
                  	and Ccuenta = <cfqueryparam value="#form.CcuentaAux#" cfsqltype="cf_sql_varchar">
		</cfquery> 
      
		<cfset params = params & '&Ecodigodest=#form.EcodigoEmp#'>
	</cfif>
</cfif>
        
<cflocation url="CtasEliminaIconoF.cfm?Pagina=#form.Pagina##params#">
