<!---- ******************* Funcion que se encarga de asignar oficinas *******************************--->
<cfif isdefined("Form.btnAsignar")>
	<cfquery name="rsAsigna" datasource="#Session.DSN#">
		delete from PCDCatalogoValOficina
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
		and PCDcatid = <cfqueryparam value="#form.PCDcatid#" cfsqltype="cf_sql_numeric">
	</cfquery> 
	<cfif isdefined("Form.chk")>
	<cfset oficinas = ListToArray(Form.chk, ',')>
		<cfloop from="1" to="#ArrayLen(oficinas)#" index="i">
			<cfquery name="rsAsigna" datasource="#Session.DSN#">
				Insert into PCDCatalogoValOficina(PCDcatid, Ecodigo, Ocodigo, BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#oficinas[i]#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>  
		</cfloop>
	</cfif>
<cfelse>
	<cfquery name="ConsultaRegistro" datasource="#Session.DSN#">
		select 1 from PCDCatalogoValOficina
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
			and PCDcatid = <cfqueryparam value="#form.PCDcatid#" cfsqltype="cf_sql_numeric">
			and Ocodigo = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif ConsultaRegistro.recordcount eq 0>
		<cfquery name="rsInsertar" datasource="#Session.DSN#">
			Insert into PCDCatalogoValOficina(PCDcatid, Ecodigo, Ocodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>  
	<cfelse>
		<cfquery name="rsElimina" datasource="#Session.DSN#">
			delete from PCDCatalogoValOficina
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
			and PCDcatid = <cfqueryparam value="#form.PCDcatid#" cfsqltype="cf_sql_numeric">
			and Ocodigo = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
</cfif>	

	
<!---************** Se encarga de mandar por url, los parametros al formulario ****************--->
<cfset LvarIncVal = "">
<cfif isdefined("Form.IncVal")>
	<cfset LvarIncVal = "&IncVal=1">
</cfif>
<cflocation url="ValoresxOficinas.cfm?PCEcatid=#form.PCEcatid#&PCDcatid=#form.PCDcatid#&PCEcodigo=#form.PCEcodigo#&PCEdescripcion=#form.PCEdescripcion#&PCDvalor=#form.PCDvalor#&PCDdescripcion=#form.PCDdescripcion##LvarIncVal#">

