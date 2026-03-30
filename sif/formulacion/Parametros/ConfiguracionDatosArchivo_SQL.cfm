<cfset form.valor3 = "#replace(form.valor3,",","","ALL")#">
<cfset form.valor2 = "#replace(form.valor2,",","","ALL")#">

<cftransaction>
  <cfif isDefined("Form.Aceptar")>
	 	<cfif isDefined("Form.Separador") and Len(Trim(Separador)) gt 0>
			<cfif Form.Separador EQ "1">
				<cfset a = updateDato(3000,Form.valor2)>
			<cfelseif Form.Separador EQ "0">
				<cfset b = insertDato(3000,'ES','Separador de la Máscara',Form.valor3)>
			</cfif>
		</cfif>
		
		<cfif isDefined("Form.CodInst") and Len(Trim(CodInst)) gt 0>
			<cfif Form.CodInst EQ "1">
				<cfset a = updateDato(3001,Form.valor3)>
			<cfelseif Form.CodInst EQ "0">
				<cfset b = insertDato(3001,'ES','Código de la Institución',Form.valor2)>
			</cfif>
		</cfif>
	</cfif>
</cftransaction>

<form action="ConfiguracionDatosArchivo.cfm" method="post" name="sql"></form>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<!--- Inserta un registro en la tabla de Parámetros --->
<cffunction name="insertDato" >		
	<cfargument name="pcodigo" 		type="numeric"required="true">
	<cfargument name="mcodigo" 		type="string" required="true">
	<cfargument name="pdescripcion"  type="string" required="true">
	<cfargument name="pvalor" 			type="string" required="true">	
		
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from Parametros 
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		 and Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#"> 
	</cfquery>
	
	<cfif rsCheck.cantidad eq 0>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros 
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
		update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn true>
</cffunction>

