
<!---ACOMODA LOS NIVELES DE LOS CF --->

<cfset CFid = '' >
<cfset CFidt = '' >
<cfset CFidres = '' >
<cfset CFcodigo = '' >
<cfset nivel = '' >
<cfset path = '' >
<cfset salida = '' >

<cfset ECO = 0>
<cfif isdefined("url.Ecodigo") and len(trim(url.Ecodigo))>
<cfset ECO = url.Ecodigo>
</cfif>

<cfquery name="rs_Empresa" datasource="minisif">
	select Edescripcion
	from Empresas 
	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ECO#">  
</cfquery>
<cfif rs_Empresa.RecordCount EQ 0>
	<cfdump var="No existe la empresa indicada ">
    <cfabort>
</cfif>

<cfquery name="rs_centro" datasource="minisif">
	select min(CFid) as id
	from CFuncional 
	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ECO#">  
</cfquery>
<cfset CFid = rs_centro.id >


<cfloop condition="true">
	<cfset CFidt = CFid >
	<cfset nivel = 0 > 
	<cfset path = '' >
	<cfset salida = 0 >
	
	<cfloop condition="salida neq 1">
	
		<cfquery name="rs1" datasource="minisif">
			select CFcodigo,
				   CFidresp 
			from CFuncional
			where  CFid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidt#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ECO#">
		</cfquery>
		<cfset CFcodigo = rs1.CFcodigo >
		<cfset CFidres = rs1.CFidresp >		
		
		<cfif len(trim(CFidres))>
			<cfif len(trim(path)) eq 0>
				<cfset nivel = 1 >
				<cfset path = CFcodigo >
			<cfelse>
				<cfset nivel = nivel + 1 >
				<cfset path = trim(CFcodigo) & '/' & path >
			</cfif>
			<cfset CFidt = CFidres >
		<cfelse>
			<cfif len(trim(path)) eq 0 >
				<cfset nivel = 0 >
				<cfset path = CFcodigo >
			<cfelse>
				<cfset nivel = nivel +1 >
				<cfset path = trim(CFcodigo) & '/' & path >
			</cfif>
			<cfset salida = 1 >
		</cfif>
	</cfloop>
	<cfquery datasource="minisif">
		update CFuncional 
		set CFpath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">, 
			CFnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
	</cfquery>
	
	<cfquery name="rs_seguir" datasource="minisif">
		select min(CFid) as id
		from CFuncional
		where CFid  > <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ECO#">
	</cfquery>
	<cfset CFid = rs_seguir.id >
	<cfif len(trim(CFid)) eq 0 >
		<cfbreak>
	</cfif>
</cfloop>

<cfdump var="Fin del acomodo de niveles y &aacute;rbol para la Empresa: #rs_Empresa.Edescripcion# ">

<cfabort>

<!--- FIN DE ACOMODO --->