<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfparam name="Attributes.Ecodigo" 				default="#session.Ecodigo#" type="numeric">
<cfparam name="Attributes.EOidorden" 			default="-1"  				type="numeric">
<cfparam name="Attributes.EOnumero" 			default="-1"  				type="numeric">
<cfparam name="Attributes.ESidsolicitud"		default="-1"  				type="numeric">
<cfparam name="Attributes.DSlinea"	 			default="-1"  				type="numeric">
<cfparam name="Attributes.CMtipo" 				default=""  				type="string">
<cfparam name="Attributes.Cid" 					default="-1"  				type="string">
<cfparam name="Attributes.Aid" 					default="-1"  				type="string">
<cfparam name="Attributes.Alm_Aid" 				default="-1"				type="string">
<cfparam name="Attributes.ACcodigo"				default="-1"				type="string">
<cfparam name="Attributes.ACid"					default="-1"  				type="string">
<cfparam name="Attributes.DOdescripcion"		default=""  				type="string">
<cfparam name="Attributes.DOobservaciones"		default=""  				type="string">
<cfparam name="Attributes.DOalterna"			default=""  				type="string">
<cfparam name="Attributes.DOcantidad"			default="0"	  				type="numeric">
<cfparam name="Attributes.DOcantsurtida"		default="0"  				type="numeric">
<cfparam name="Attributes.DOpreciou"			default="0"			 		type="numeric">
<cfparam name="Attributes.DOfechaes"			default=""  				type="string">
<cfparam name="Attributes.DOgarantia"			default="0"  				type="numeric">
<cfparam name="Attributes.CFid"					default="-1"  				type="numeric">
<cfparam name="Attributes.Icodigo"				default="-1"  				type="string">
<cfparam name="Attributes.Ucodigo"				default="-1"  				type="string">
<cfparam name="Attributes.DOfechareq"			default="-1"  				type="string">
<cfparam name="Attributes.Ppais"				default="CR"  				type="string">
<cfparam name="Attributes.tipo"					default=""					type="string">
<cfparam name="Attributes.DOmontodesc"			default="0"					type="string">
<cfparam name="Attributes.DOporcdesc"			default="0"					type="string">

<cfset Attributes.DOpreciou = LvarOBJ_PrecioU.enCF(Attributes.DOpreciou)>
<cfset DOtotal = Attributes.DOcantidad * Attributes.DOpreciou>

<cfif len(trim(Attributes.tipo)) gt 0 >
	<cfif Attributes.tipo eq "insert">
		<cfquery name="consecutivo" datasource="#session.DSN#">				
			select max(DOconsecutivo) as linea
			from DOrdenCM 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#"> 
			  and EOidorden=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.EOidorden#">
		</cfquery>
		<cfset dlinea = 1 >
		<cfif consecutivo.RecordCount gt 0 and len(trim(consecutivo.linea)) >
			<cfset dlinea = consecutivo.linea + 1>
		</cfif>

		<cfquery name="insert" datasource="#session.DSN#">				
			insert into DOrdenCM ( Ecodigo, EOidorden, EOnumero, DOconsecutivo, ESidsolicitud, DSlinea, 
								   CMtipo, Cid, Aid, Alm_Aid, ACcodigo, ACid, DOdescripcion, DOobservaciones, DOalterna, 
								   DOcantidad, DOcantsurtida, DOpreciou, DOtotal, DOfechaes, DOgarantia, 
								   CFid, Icodigo, Ucodigo, DOfechareq, Ppais, DOmontodesc, DOporcdesc )
					 values (   <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Attributes.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Attributes.EOidorden,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Attributes.EOnumero,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#dlinea#">,
								<cfif Attributes.ESidsolicitud neq -1><cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Attributes.ESidsolicitud,',','','all')#"><cfelse>null</cfif>, 
								<cfif Attributes.DSlinea neq -1><cfqueryparam cfsqltype="cf_sql_integer" 	value="#Replace(Attributes.DSlinea,',','','all')#"><cfelse>null</cfif>, 
								<cfqueryparam cfsqltype="cf_sql_char" 	value="#Attributes.CMtipo#">,
								<cfif Attributes.CMtipo eq "S" and ( len(trim(Attributes.Cid)) gt 0 and Attributes.Cid neq "-1")><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.Cid,',','','all')#"><cfelse>null</cfif>, 
								<cfif Attributes.CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Attributes.CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.Alm_Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Attributes.CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Attributes.ACcodigo,',','','all')#"><cfelse>null</cfif>,
								<cfif Attributes.CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Attributes.ACid,',','','all')#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Attributes.DOdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Attributes.DOobservaciones#">,
								<cfif len(trim(Attributes.DOalterna)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.DOalterna#"><cfelse>null</cfif>,
								
                                <cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Attributes.DOcantidad,',','','all')#">, 
								<cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Attributes.DOcantsurtida,',','','all')#">, 
								#LvarOBJ_PrecioU.enCF(Attributes.DOpreciou)#, 
								<cfqueryparam cfsqltype="cf_sql_money" 		value="#Replace(DOtotal,',','','all')#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Attributes.DOfechaes)#">,
								<cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Attributes.DOgarantia,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.CFid,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Attributes.Icodigo)#">,
								<cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Attributes.Ucodigo)#">,
								<cfif len(trim(Attributes.DOfechareq)) ><cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Attributes.DOfechareq)#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_char"	    value="#Attributes.Ppais#">,
								<cfqueryparam cfsqltype="cf_sql_money" 		value="#Replace(Attributes.DOmontodesc,',','','all')#">,								
								<cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Attributes.DOporcdesc,',','','all')#"> 
							)
		</cfquery>									
	<cfelseif Attributes.tipo eq "update">
		<cfquery name="update" datasource="#session.DSN#">
			update DOrdenCM
			set EOnumero   = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Replace(Attributes.EOnumero,',','','all')#">, 									
				ESidsolicitud = <cfif Attributes.ESidsolicitud neq -1><cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Attributes.ESidsolicitud,',','','all')#"><cfelse>null</cfif>, 
				DSlinea    = <cfif Attributes.DSlinea neq -1><cfqueryparam cfsqltype="cf_sql_integer" 	value="#Replace(Attributes.DSlinea,',','','all')#"><cfelse>null</cfif>, 
				CMtipo  = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Attributes.CMtipo#">,
				Cid        = <cfif Attributes.CMtipo eq "S" and ( len(trim(Attributes.Cid)) gt 0 and Attributes.Cid neq "-1")><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.Cid,',','','all')#"><cfelse>null</cfif>, 
				Aid        = <cfif CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.Aid,',','','all')#"><cfelse>null</cfif>,
				Alm_Aid    = <cfif CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.Alm_Aid,',','','all')#"><cfelse>null</cfif>,
				ACcodigo   = <cfif CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Attributes.ACcodigo,',','','all')#"><cfelse>null</cfif>,
				ACid       = <cfif CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Attributes.ACid,',','','all')#"><cfelse>null</cfif>,
				DOdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Attributes.DOdescripcion#">,
				DOobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Attributes.DOobservaciones#">,
				DOalterna  = <cfif len(trim(Attributes.DOalterna)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Attributes.DOalterna#"><cfelse>null</cfif>,
				DOcantidad = <cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Attributes.DOcantidad,',','','all')#">, 
				DOcantsurtida = <cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Attributes.DOcantsurtida,',','','all')#">, 
				DOpreciou  = #LvarOBJ_PrecioU.enCF(Attributes.DOpreciou)#, 
				DOtotal    = <cfqueryparam cfsqltype="cf_sql_money" 		value="#Replace(DOtotal,',','','all')#">, 
				DOfechaes  = <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Attributes.DOfechaes)#">,
				DOgarantia = <cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Attributes.DOgarantia,',','','all')#">,
				CFid	   = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Attributes.CFid,',','','all')#">,
				Icodigo	   = <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Attributes.Icodigo)#">,
				Ucodigo	   = <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Attributes.Ucodigo)#">,
				DOfechareq = <cfif len(trim(Attributes.DOfechareq)) ><cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Attributes.DOfechareq)#"><cfelse>null</cfif>,
				Ppais	   = <cfqueryparam cfsqltype="cf_sql_char"	    value="#Attributes.Ppais#">,
				DOmontodesc= <cfqueryparam cfsqltype="cf_sql_money"	    value="#Replace(Attributes.DOmontodesc,',','','all')#">,
				DOporcdesc = <cfqueryparam cfsqltype="cf_sql_float"	    value="#Replace(Attributes.DOporcdesc,',','','all')#">								
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Attributes.DOlinea,',','','all')#">
			  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Attributes.EOidorden,',','','all')#">
			  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
		</cfquery>
	<cfelseif Attributes.tipo eq "delete">
		<cfquery name="delete" datasource="#session.DSN#">
			delete from DOrdenCM	
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.DOlinea#">
			  and EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Attributes.EOidorden#">
			  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
		</cfquery>	
	</cfif>	
<cfelse>
	<cfexit method="exittag">
</cfif>