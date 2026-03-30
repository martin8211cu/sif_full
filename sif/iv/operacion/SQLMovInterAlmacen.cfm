<cfparam name="modoDet" default="ALTA">

<cfif not isdefined("form.NuevoD")>

	<cfset dioError = false>	
	<cfif isDefined("Form.EMid") and Form.EMid NEQ "" and isdefined("Form.DMAid") and Form.DMAid NEQ "" and not isDefined("Form.BorrarD")>
		<cfquery name="rsSumaCantidad2" datasource="#session.DSN#">
			select coalesce(sum(DMcant),0.00) Acumulado
			from DMinteralmacen 
			where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#"> 
			  and DMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DMAid#">
		</cfquery>
		
		<cfquery name="rsExist" datasource="#session.DSN#">
				select Eexistencia
				from Existencias 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
				  and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AlmIni#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DMAid#">
		</cfquery>

		<cfif isDefined("Form.CambiarD") and Form.CambiarD NEQ "">
			<cfif #Evaluate('(#rsSumaCantidad2.Acumulado# - #Form.CantidadTemp2#) + #Replace(Form.Cantidad,',','', 'all')#')# GT #rsExist.Eexistencia#>				
				<cfset dioError = true>
				<cfif not isdefined("Form.BorrarE")>
                <cfoutput>
				<script>alert("La cantidad digitada sobrepasa las existencias disponibles al momento :#rsExist.Eexistencia#");</script>			
                </cfoutput>
				</cfif>
			</cfif>		
		<cfelse>
			<cfif #Evaluate('#rsSumaCantidad2.Acumulado# + #Replace(Form.Cantidad,',','', 'all')#')# GT #rsExist.Eexistencia#>
				<cfset dioError = true>                
				<cfif not isdefined("Form.BorrarE")>
                <cfset LvarDisAlMomento=#rsExist.Eexistencia#-#rsSumaCantidad2.Acumulado#>
                 <cfoutput>
				<script>alert("La cantidad digitada sobrepasa las existencias disponibles al momento:#LvarDisAlMomento#");</script>	
                </cfoutput>		
				</cfif>
			</cfif>
		</cfif>
	</cfif>	
	<cfset cambioEncab = false>	
	<cfif not (isDefined("Form.EMfecha") and Trim(Form.EMfecha) EQ Trim(Form._EMfecha)
		and isDefined("Form.Documento") and Trim(Form.Documento) EQ Trim(Form._Documento))>
		<cfset cambioEncab = true>
	</cfif>
		<cfif isdefined("Form.AgregarE")>
			<cftransaction>
				<cfquery name="InsEMinteralmacen" datasource="#session.DSN#">
					insert into EMinteralmacen (Ecodigo, EMalm_Orig, EMalm_Dest, EMdoc, EMusu, EMresp, EMfecha , Eestado)
					values (
						<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AlmIni#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AlmFin#">, 
						<cfqueryparam value="#Form.Documento#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						<cfqueryparam value="#LSParseDateTime(Form.EMfecha)#" cfsqltype="cf_sql_timestamp">,		
                        <cfif isdefined("form.Estado") and form.Estado eq 1>
	                        <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        <cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        </cfif>		
					)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="InsEMinteralmacen">
				<cfset modo="CAMBIO">
				<cfset modoDet="ALTA">
			</cftransaction>
		<cfelseif isdefined("Form.BorrarE")>
			<cfquery name="delDMinteralmacen" datasource="#session.DSN#">
				delete from DMinteralmacen
				where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#">
			</cfquery>
			<cfquery name="delEMinteralmacen" datasource="#session.DSN#">	
				delete from EMinteralmacen
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">				  
			</cfquery>
			<cfset modo="ALTA">
			<cfset modoDet="ALTA">
			  			  
		<cfelseif isdefined("Form.AgregarD")>
			<cfif not dioError>					
				<cfquery name="InsDMinteralmacen" datasource="#session.DSN#">
					insert into DMinteralmacen (EMid, DMAid, DMcant)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DMAid#">, 
						<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.Cantidad,',','', 'all')#">
					)
				</cfquery>
			</cfif>
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">				
		<cfelseif isdefined("Form.BorrarD")>
			<cfquery name="delEMinteralmacen" datasource="#session.DSN#">
				delete from DMinteralmacen
				where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
				  and DMlinea = <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric">				  
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">								  
		<cfelseif isdefined("Form.CambiarD")>		
			<cfif not dioError>		
				<cftransaction>
					<cf_dbtimestamp 
						datasource = "#session.dsn#"
						table = "DMinteralmacen"
						redirect = "MovInterAlmacen.cfm?EMid=#form.EMid#&DMlinea=#form.DMlinea#"
						timestamp = "#form.timestampD#"
						field1 = "EMid"
						type1 = "numeric"
						value1 = "#Form.EMid#"
						field2 = "DMlinea"
						type2 = "numeric"
						value2 = "#form.DMlinea#">
					<cfquery name="updEMinteralmacen" datasource="#session.DSN#">
						update DMinteralmacen
						set DMAid =  <cfqueryparam value="#Form.DMAid#" cfsqltype="cf_sql_numeric">,
							DMcant = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.Cantidad,',','', 'all')#"> 
						where EMid =  <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric"> 
						  and DMlinea = <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric"> 
	
					</cfquery>
				</cftransaction>
 				<cfif cambioEncab>
                  		<cfif isdefined("form.Estado") and form.Estado eq 1>
                  			<cf_dbtimestamp 
							datasource = "#session.dsn#"
							table = "EMinteralmacen"
							redirect = "MovInterAlmacenconAprobacion.cfm?EMid=#form.EMid#"
							timestamp = "#form.timestampE#"
							field1 = "EMid"
							type1 = "numeric"
							value1 = "#Form.EMid#"> 	
                             							
                          <cfelse>
                             	<cf_dbtimestamp 
							datasource = "#session.dsn#"
							table = "EMinteralmacen"  
							redirect = "MovInterAlmacen.cfm?EMid=#form.EMid#"
							timestamp = "#form.timestampE#"
							field1 = "EMid"
							type1 = "numeric"
							value1 = "#Form.EMid#"> 	
                             							
                         </cfif>
							
					<cfquery name="updEMinteralmacen" datasource="#session.DSN#">
						update EMinteralmacen
						set
							EMdoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Documento#">,
							EMfecha = <cfqueryparam value="#LSParseDateTime(Form.EMfecha)#" cfsqltype="cf_sql_timestamp">,
                            <cfif isdefined("form.Estado") and form.Estado eq 1>
	                       		Eestado = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        	<cfelse>
                        		Eestado = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        	</cfif>	
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
					</cfquery>
				</cfif>
			</cfif>
			<cfset modo="CAMBIO">
			<cfset modoDet="CAMBIO">
		</cfif>
<cfelse>
	<cfset modo    = "CAMBIO">
	<cfset modoDet = "ALTA">
</cfif>
<cfif isdefined("form.Estado") and form.Estado eq 1>
<form action="MovInterAlmacenconAprobacion.cfm" method="post" name="sql">
<cfelse>
<form action="MovInterAlmacen.cfm" method="post" name="sql">

</cfif>
	<input name="modo"    type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="modoDet" type="hidden" value="<cfoutput>#modoDet#</cfoutput>">	

	<cfif isdefined("InsEMinteralmacen.identity")>
	   	<input name="EMid" type="hidden" value="<cfif isdefined("InsEMinteralmacen.identity")><cfoutput>#InsEMinteralmacen.identity#</cfoutput></cfif>">
	<cfelse>
	   	<input name="EMid" type="hidden" value="<cfif isdefined("Form.EMid") and not isDefined("Form.BorrarE")><cfoutput>#Form.EMid#</cfoutput></cfif>">		
	</cfif>

	<cfif modoDet neq 'ALTA'>
   		<input name="DMlinea" type="hidden" value="<cfif isdefined("Form.DMlinea")><cfoutput>#Form.DMlinea#</cfoutput></cfif>">
		<input name="DMAid"   type="hidden" value="<cfif isdefined("Form.DMAid")><cfoutput>#Form.DMAid#</cfoutput></cfif>">
		<input name="AlmIni"  type="hidden" value="<cfif isdefined("Form.AlmIni")><cfoutput>#Form.AlmIni#</cfoutput></cfif>">
	</cfif>

</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
 
