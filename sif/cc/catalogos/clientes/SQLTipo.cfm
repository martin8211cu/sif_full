<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 24 de mayo del 2005
	Motivo:	corrección de tipo de parametro en las consultas, se estaba enviando un integer donde era un numeric
	Linea:  26, 34
----------->
<cfparam name="modo" default="ALTA">
		
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insClienteDetallistaTipo" datasource="#Session.DSN#">			
			insert into ClienteDetallistaTipo (CEcodigo, CDTdescripcion)
			values 
			(				
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#"> , 
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDTdescripcion#">)) 
			)
		</cfquery>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delClienteDetallistaTipo" datasource="#Session.DSN#">
			delete from ClienteDetallistaTipo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
			  and CDTid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDTid#">
			  <cfset modo="ALTA">
		</cfquery>
	<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#Session.DSN#"
							table="ClienteDetallistaTipo"
							redirect="Tipo.cfm"
							timestamp="#Form.ts_rversion#"
							field1="CEcodigo" 		type1="integer"  value1="#Session.CEcodigo#"
							field2="CDTid" 			type2="varchar"  value2="#Form.CDTid#">
							
		<cfquery name="updClienteDetallistaTipo" datasource="#Session.DSN#">
			update ClienteDetallistaTipo set 
				CDTdescripcion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDTdescripcion#">
			where CEcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
			  and CDTid    	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDTid#">			
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>
<form action="Tipo.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="CDTid" type="hidden" value="<cfif isdefined("Form.CDTid")><cfoutput>#Form.CDTid#</cfoutput></cfif>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

