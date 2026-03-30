<cfset form.valor3 = "#replace(form.valor3,",","","ALL")#">
<cfset form.valor2 = "#replace(form.valor2,",","","ALL")#">
<cfset form.Postpago = "#replace(form.Postpago,",","","ALL")#">

<cftransaction> 
  <cfif isDefined("Form.Aceptar")>
	 	<cfif isDefined("Form.LBlanca") and Len(Trim(LBlanca)) gt 0>
			<cfif Form.LBlanca EQ "1">
				<cfset a = updateDato(10,Form.valor3)>
			<cfelseif Form.LBlanca EQ "0">
				<cfset b = insertDato(10,'QP','Monto igual o superior para Lista Blanca',Form.valor3)>
			</cfif>
		</cfif>
		
		<cfif isDefined("Form.LNegra") and Len(Trim(LNegra)) gt 0>
			<cfif Form.LNegra EQ "1">
				<cfset a = updateDato(20,Form.valor2)>
			<cfelseif Form.LNegra EQ "0">
				<cfset b = insertDato(20,'QP','Monto menor para Lista negra',Form.valor2)>
			</cfif>
		</cfif>
        
        <cfif isDefined("Form.LPostpago") and Len(Trim(LPostpago)) gt 0>
			<cfif Form.LPostpago EQ "1">
				<cfset a = updateDato(25,Form.Postpago)>
			<cfelseif Form.LPostpago EQ "0">
				<cfset b = insertDato(25,'QP','Saldo Quick Pass mínimo para no entrar en lista negra',Form.Postpago)>
			</cfif>
		</cfif>
	</cfif>
</cftransaction>

<form action="QPassParametros.cfm" method="post" name="sql"></form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<!--- Inserta un registro en la tabla de Parámetros --->
<cffunction name="insertDato" >		
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="mcodigo" type="string" required="true">
	<cfargument name="pdescripcion" type="string" required="true">
	<cfargument name="pvalor" type="string" required="true">	
		
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from QPParametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#"> 
	</cfquery>
	
	<cfif rsCheck.cantidad eq 0>
		<cfquery datasource="#Session.DSN#">
			insert into QPParametros 
			(
				Ecodigo, 
				Pcodigo, 
				Mcodigo, 
				Pdescripcion, 
				Pvalor, 
				BMUsucodigo
			)
			values (
				#Session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">, 
				#session.Usucodigo#
				)
			</cfquery>	
		</cfif>
	<cfreturn true>
</cffunction>

<!--- Actualiza los datos del registro según el pcodigo --->
<cffunction name="updateDato">					
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="pvalor" type="string" required="true">			
	<cfquery name="updDato" datasource="#Session.DSN#">
		update QPParametros 
        	set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn true>
</cffunction>

