<cfif form.SScodigo NEQ '*'>
	<cfif form.SMcodigo NEQ '*'>
		<cfset mapkey = form.SScodigo & '.' & form.SMcodigo>
	<cfelse>
		<cfset mapkey = form.SScodigo>
	</cfif>
<cfelse>
	<cfset mapkey = 'todo'>
</cfif>

  <cftry>
  	<cfif form.SScodigo EQ ''>
		<cfthrow message="Debe seleccionar un sistema, o todos.">
	</cfif>
	<cfif form.SScodigo EQ '*'>
		<cfset form.SSdescripcion="Todo">
	<cfelse>
		<cfquery datasource="asp" name="data">
			select SSdescripcion
			from SSistemas
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		</cfquery>
		<cfset form.SSdescripcion = data.SSdescripcion>
	</cfif>
	<cfif form.SMcodigo EQ '*'>
		<cfset form.SMdescripcion="Todo">
	<cfelse>
		<cfquery datasource="asp" name="data">
			select SMdescripcion
			from SModulos
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		</cfquery>
		<cfset form.SMdescripcion = data.SMdescripcion>
	</cfif>
	
	<cfinvoke component="asp.parches.comp.parche" method="agregar_seguridad"
		mapkey="#mapkey#"
		SScodigo="#form.SScodigo#" SSdescripcion="#SSdescripcion#"
		SMcodigo="#form.SMcodigo#" SMdescripcion="#SMdescripcion#" />
    <cfcatch type="any">
      <cfset str = StructNew()>
      <cfset str.msg = cfcatch.Message & ' ' & cfcatch.Detail>
      <cfset str.archivo = mapkey>
      <cfset ArrayAppend(session.parche.errores, str)>
    </cfcatch>
  </cftry>
<cfset session.parche.seg_file = mapkey>
<cfinvoke component="asp.parches.comp.parche" method="contar"/>
<cflocation url="segconfirmar.cfm">
