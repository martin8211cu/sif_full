<cfparam name="Attributes.Ecodigo" 			default="#session.Ecodigo#" 	type="numeric">
<cfparam name="Attributes.EOidorden" 		default="-1"  					type="numeric">
<cfparam name="Attributes.EOnumero" 		default="-1"  					type="numeric">
<cfparam name="Attributes.SNcodigo" 		default="-1"  					type="numeric">
<cfparam name="Attributes.CMCid" 			default="-1"  					type="numeric">
<cfparam name="Attributes.Mcodigo" 			default="-1"  					type="numeric">
<cfparam name="Attributes.Rcodigo" 			default="-1"  					type="string">
<cfparam name="Attributes.CMTOcodigo" 		default=""  					type="string">
<cfparam name="Attributes.EOfecha"			default=""  					type="string">
<cfparam name="Attributes.Observaciones"	default="" 						type="string">
<cfparam name="Attributes.EOtc"				default="-1"	  				type="numeric">
<cfparam name="Attributes.EOrefcot"			default="-1"  					type="numeric">
<cfparam name="Attributes.Impuesto"			default="-1"  					type="numeric">
<cfparam name="Attributes.EOdesc"			default="-1"			 		type="numeric">
<cfparam name="Attributes.EOtotal"			default="-1"  					type="numeric">
<cfparam name="Attributes.EOplazo"			default="-1"	 				type="numeric">
<cfparam name="Attributes.tipo"				default=""						type="string">
<cfparam name="Attributes.EOporcanticipo"	default="0"	 					type="numeric">
<cfparam name="Attributes.CMFPid"			default="-1"					type="numeric">
<cfparam name="Attributes.CMIid"			default="-1"					type="numeric">
<cfparam name="Attributes.EOdiasEntrega"	default="0"						type="numeric">
<cfparam name="Attributes.EOtipotransporte"	default=""						type="string">
<cfparam name="Attributes.EOlugarentrega"	default=""						type="string">
<cfparam name="Attributes.CRid"				default="-1"					type="numeric">

<cfset Request.Key = "">

<cfif len(trim(Attributes.tipo)) gt 0 >
	<cfif Attributes.tipo eq "insert">
		<cftransaction>
			<!--- Control de concurrencia y duplicados (cflock + cftransaction + update) de consecutivos de EOrden --->
			<cflock name="LCK_EOrdenCM#Attributes.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
				<!--- Calculo de Consecutivo: ultimo + 1 --->
                <cfquery name="rsConsecutivoOrden" datasource="#Session.DSN#">
                    select coalesce(max(EOnumero), 0) + 1 as EOnumero
                      from EOrdenCM
                     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
                </cfquery>
                <cfquery datasource="#Session.DSN#">
                    update EOrdenCM
                       set EOnumero = EOnumero
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
                      and EOnumero = #rsConsecutivoOrden.EOnumero-1#
                </cfquery>

				<!--- Guardar el numero del encabezado de Orden de Compra --->
				<cfset numero = rsConsecutivoOrden.EOnumero>

				<cfquery name="insert" datasource="#session.DSN#">
					insert into EOrdenCM ( Ecodigo, EOnumero, SNcodigo, CMTOcodigo, CMCid, Mcodigo, Rcodigo, EOfecha, Observaciones, EOtc, EOrefcot, Impuesto, EOdesc, EOtotal, Usucodigo, EOplazo, EOfalta, EOporcanticipo, CMFPid, CMIid, EOdiasEntrega, EOtipotransporte, EOlugarentrega, CRid)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#numero#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.SNcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Attributes.CMTOcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.CMCid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.Mcodigo#">, 
						<cfif Attributes.Rcodigo neq '-1' ><cfqueryparam cfsqltype="cf_sql_char"	value="#Attributes.Rcodigo#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Attributes.EOfecha)#">,
						<cfif len(trim(Attributes.Observaciones)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Observaciones#"><cfelse>null</cfif>, 
						<cfqueryparam cfsqltype="cf_sql_float" 		value="#Attributes.EOtc#">, 
						<cfif Attributes.EOrefcot neq -1 ><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Attributes.EOrefcot#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Attributes.Impuesto#">, 
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Attributes.EOdesc#">, 
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Attributes.EOtotal#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.EOplazo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
						<cfif isdefined("Attributes.EOporcanticipo") and Len(Trim(Attributes.EOporcanticipo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EOporcanticipo#" scale="2"><cfelse>null</cfif>, 
						<cfif isdefined("Attributes.CMFPid") and Len(Trim(Attributes.CMFPid)) and Attributes.CMFPid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CMFPid#"><cfelse>null</cfif>,
						<cfif isdefined("Attributes.CMIid") and Len(Trim(Attributes.CMIid)) and Attributes.CMIid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CMIid#"><cfelse>null</cfif>,
						<cfif isdefined("Attributes.EOdiasEntrega") and Len(Trim(Attributes.EOdiasEntrega))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EOdiasEntrega#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.EOtipotransporte#" null="#Len(Trim(Attributes.EOtipotransporte)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.EOlugarentrega#" null="#Len(Trim(Attributes.EOlugarentrega)) EQ 0#">,
						<cfif isdefined("Attributes.CRid") and Len(Trim(Attributes.CRid)) and Attributes.CRid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CRid#"><cfelse>null</cfif>
					)
					<cf_dbidentity1 datasource="#session.DSN#">				
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">
			</cflock>
		</cftransaction>
	<cfelseif Attributes.tipo eq "update">
		<cfquery name="update" datasource="#session.DSN#">
			update EOrdenCM
			set SNcodigo  		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.SNcodigo#">, 
				CMTOcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Attributes.CMTOcodigo#">, 
				CMCid     		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.CMCid#">,
				Mcodigo   		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.Mcodigo#">, 
				EOfecha   		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Attributes.EOfecha)#">,
				EOtc      		= <cfqueryparam cfsqltype="cf_sql_float"	value="#Attributes.EOtc#">, 
				Impuesto  		= <cfqueryparam cfsqltype="cf_sql_money"	value="#Attributes.Impuesto#">, 
				EOdesc    		= <cfqueryparam cfsqltype="cf_sql_money"	value="#Attributes.EOdesc#">, 
				EOtotal   		= <cfqueryparam cfsqltype="cf_sql_money"	value="#Attributes.EOtotal#">, 
				Usucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
				EOplazo			= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.EOplazo#">,
				Rcodigo   		= <cfif Attributes.Rcodigo neq '-1' ><cfqueryparam cfsqltype="cf_sql_char"	value="#Attributes.Rcodigo#"><cfelse>null</cfif>,
				Observaciones 	= <cfif len(trim(Attributes.Observaciones)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar"  value="#Attributes.Observaciones#"><cfelse>null</cfif>, 
				EOrefcot  		= <cfif Attributes.EOrefcot neq -1 ><cfqueryparam cfsqltype="cf_sql_numeric"		value="#Attributes.EOrefcot#"><cfelse>null</cfif>,
				EOporcanticipo = <cfif isdefined("Attributes.EOporcanticipo") and Len(Trim(Attributes.EOporcanticipo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EOporcanticipo#" scale="2"><cfelse>null</cfif>, 
				CMFPid = <cfif isdefined("Attributes.CMFPid") and Len(Trim(Attributes.CMFPid)) and Attributes.CMFPid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CMFPid#"><cfelse>null</cfif>,
				CMIid = <cfif isdefined("Attributes.CMIid") and Len(Trim(Attributes.CMIid)) and Attributes.CMIid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CMIid#"><cfelse>null</cfif>,
				EOdiasEntrega = <cfif isdefined("Attributes.EOdiasEntrega") and Len(Trim(Attributes.EOdiasEntrega))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EOdiasEntrega#"><cfelse>null</cfif>,
				EOtipotransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.EOtipotransporte#" null="#Len(Trim(Attributes.EOtipotransporte)) EQ 0#">,
				EOlugarentrega = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.EOlugarentrega#" null="#Len(Trim(Attributes.EOlugarentrega)) EQ 0#">,
				CRid = <cfif isdefined("Attributes.CRid") and Len(Trim(Attributes.CRid)) and Attributes.CRid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CRid#"><cfelse>null</cfif>
				where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.Ecodigo#">
				and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.EOidorden#">
		</cfquery>	  
	<cfelseif Attributes.tipo eq "delete">
		<cfquery name="delete" datasource="#session.DSN#">
			delete from EOrdenCM	
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.Ecodigo#">
				and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.EOidorden#">
		</cfquery>	  
	</cfif>		  
	<cfif Attributes.tipo eq "insert">
		<cfset Request.key = insert.identity >
	</cfif>
<cfelse>
	<cfexit method="exittag">
</cfif>