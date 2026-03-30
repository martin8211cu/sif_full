<cfif isdefined("Procesar")>

	<cftransaction>
		<!--- Registrar en bitácora el movimiento --->
		<cfset listaValores = form.rb>
		<cfloop index = "Orden" list = "#listaValores#"  delimiters="," >
			<cfquery name="insBitacora" datasource="#Session.DSN#">
				insert into BMComprador (Ecodigo, CMCidorig, CMCidnuevo, BMCtipo, EOidorden, BMCfecha, Usucodigo)
				select 
					Ecodigo, 
					CMCid, 
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CMCid#">, 
					1, 
					EOidorden, 
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					#Session.Usucodigo#
				from EOrdenCM
				where EOidorden = #Orden#
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			

			<!--- Actualizar el nuevo comprador en la orden --->
			<cfquery datasource="#session.DSN#">
				update EOrdenCM
				set CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
				where EOidorden = #Orden#
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfloop>
	</cftransaction>
</cfif>

<!---
<cfoutput>
	<form action="reasignarOrden-email.cfm" method="post" name="sql">
		<input name="CMCid" type="hidden" value="#form.CMCid#">		
		<input name="EOidorden" type="hidden" value="#form.EOidorden#">
		<input name="Comprador" type="hidden" value="#form.Comprador#">
		<input name="RB" type="hidden" value="#form.RB#">
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
--->
