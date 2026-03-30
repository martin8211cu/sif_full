<cfparam  name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
	
			<cfquery name="rsCodigoValido" datasource="#session.dsn#">
				SELECT count(1) as Total
				FROM GEcategoriaDestino
				WHERE GECDcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.GECDcodigo#">) 										
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfif #rsCodigoValido.Total# eq 0>
			
				<cfquery name="InsertCategoriaDestino" datasource="#Session.DSN#">
					INSERT INTO GEcategoriaDestino 
							(	Ecodigo, 
								GECDcodigo, 
								GECDdescripcion, 
								GECDmonto, 
								BMUsucodigo)
					
                    VALUES(
                    			<cfqueryparam cfsqltype="cf_sql_integer" 		value="#Session.Ecodigo#">,
                                upper(<cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.GECDcodigo#">),
                                upper(<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.GECDdescripcion#">),
                                <cfqueryparam cfsqltype="cf_sql_money" 			value="#Form.GECDmonto#">, 
                                <cfqueryparam cfsqltype="cf_sql_numeric"		value="#session.Usucodigo#">
                           )

				</cfquery>
	
				<cfset modo="ALTA">
				
			<cfelse>
				<cfthrow message="EL CODIGO INGRESADO YA FUE ASIGNADO A UNA CATEGOR&Iacute;A">
			</cfif>
		<cfelseif isdefined("Form.Baja")>						
			<cfquery name="deleteCat" datasource="#Session.DSN#">
				DELETE FROM GEcategoriaDestino 
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					AND GECDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GECDid#">			
			</cfquery> 	  
			<cfset modo="ALTA">
            
		<cfelseif isdefined("Form.Cambio")>
			
			<cfquery name="checkAvailable" datasource="#session.dsn#">
				SELECT COUNT(1) AS Total FROM GEcategoriaDestino
				WHERE Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
				  AND GECDcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.GECDcodigo#">)
                  AND GECDid <> <cfqueryparam value="#form.GECDid#" cfsqltype="cf_sql_numeric">
			</cfquery>
				
			<cfif #checkAvailable.Total# eq 0>
				<cfquery name="updateCat" datasource="#Session.DSN#">
					UPDATE GEcategoriaDestino SET
						GECDcodigo 			= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.GECDcodigo#">),
						GECDdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GECDdescripcion#">,
                        GECDmonto			= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.GECDmonto#">
									
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and GECDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GECDid#">
				</cfquery>	
				<cfset modo="CAMBIO">
			
			<cfelse>
				<cfthrow message="EL CODIGO INGRESADO YA FUE ASIGNADO A UNA CATEGORIA DE DESTINO">
			</cfif>
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="GEcategoriaDestino.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="GECDid" type="hidden" value="<cfif isdefined("Form.GECDid")><cfoutput>#Form.GECDid#</cfoutput></cfif>">	
	</cfif>	
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

