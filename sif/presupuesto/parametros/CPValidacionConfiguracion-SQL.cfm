
<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select top 1 CPVid from CPValidacionConfiguracion  
			where Ecodigo = #Session.Ecodigo#
			  and CPVid = <cfqueryparam value="#Form.CPCNivel#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfif rsExiste.RecordCount eq 0>
			<cfquery name="rsInsert" datasource="#Session.DSN#">
				insert into CPValidacionConfiguracion (CPVid, PCEcatid, Descripcion, Valor, Ecodigo,BMUsucodigo)
				values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CPCNivel)#">,
						 #Form.PCECATID#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CPDESCRIPCION)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CPCNVALOR)#">, 
						 #session.Ecodigo#, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
			<cfset Form.CPVCid = rsInsert.identity>
			<cfset modo = 'ALTA' >
			<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select CPVid
				from CPValidacionConfiguracion 
				where Ecodigo =  #session.Ecodigo#
				order by CPVid 
			</cfquery>
		</cfif>
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsDelete" datasource="#Session.DSN#">
		delete from CPValidacionConfiguracion
		where Ecodigo = #Session.Ecodigo#
		  and CPVCid  = <cfqueryparam value="#Form.CPVCid#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfset modo = 'ALTA' >			
		
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update CPValidacionConfiguracion 
				set CPVid = <cfqueryparam value="#Form.CPCNivel#" cfsqltype="cf_sql_numeric">, 
					PCEcatid = <cfqueryparam value="#Form.PCECATID#" cfsqltype="cf_sql_numeric">, 
					Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CPDESCRIPCION)#">, 
					Valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CPCNVALOR)#">
			where Ecodigo = #session.Ecodigo#
				and CPVCid = <cfqueryparam value="#Form.CPVCid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo = 'CAMBIO' >
		
	<cfelseif isdefined("Form.Prueba")>
		<cfset LobjControl = createObject( "component","sif.presupuesto.Componentes.PRES_GeneraTablaValidaPPTO")>
		<cfset myTable = LobjControl.CreaTablaValPresupuesto(#session.dsn#)>
			
	</cfif>
<cfelse>
	<cfset modo = 'ALTA' >
</cfif>

<cfoutput>
<form action="CPValidacionConfiguracion.cfm" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CPVCid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CPVCid)#</cfoutput></cfif>">
</form>
</cfoutput>	
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>