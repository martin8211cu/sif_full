<cfinvoke component="sif.Componentes.Translate"  
method="Translate"
key="MSG_LaSumatoriaDeLosPesoDeLosComportamientosDeLaHabilidadDebenSerDeCien" 
default="La sumatoria de los pesos de los comportamientos de la habilidad deben ser de cien"
returnvariable="MSG_Sumatoria"/>

<cfparam name="action" default="PuestosHabilidades.cfm">
<cfparam name="modo" default="ALTA">

<!----============= Validar que la sumatoria de los pesos de los comportamientos no supere 100 =============----->
<cfset vn_pesos = 0>
<cfif isdefined("form.RHHid") and len(trim(form.RHHid))>
	<cfquery name="rsPesos" datasource="#session.DSN#">
		select coalesce(sum(RHCOpeso),0) as peso
		from RHComportamiento
		where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif not isdefined("Form.btn_AgregarComp") and isdefined("form.RHCOid") and len(trim(form.RHCOid))>
				and RHCOid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOid#">
			</cfif>	
	</cfquery>
<cfelse>
	<cfset rsPesos.peso = 0>
</cfif>
<cfif isdefined("form.RHCOpeso") and len(trim(form.RHCOpeso))>
	<cfset vn_pesos = rsPesos.peso + form.RHCOpeso>
<cfelse>
	<cfset vn_pesos = rsPesos.peso>
</cfif>

<cfif not isdefined("form.btnNuevo") and not isdefined("form.borrarComp") or len(trim(form.borrarComp)) EQ 0>
	<cfif vn_pesos GT 100>
		<cf_throw message="#MSG_Sumatoria#" errorcode="2165">
	</cfif>
</cfif>
<!----========================================================================================================---->

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
				insert into RHHabilidades ( Ecodigo, RHHcodigo, RHHdescripcion, BMusuario, BMfecha, RHHdescdet, PCid,RHHFid,RHHSFid
				<cfif isdefined("form.RHHubicacionB")>
					,RHHubicacionB
				</cfif>
				)
							 values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
									  <cfqueryparam value="#ucase(trim(form.RHHcodigo))#" cfsqltype="cf_sql_char">,
									  <cfqueryparam value="#form.RHHdescripcion#" cfsqltype="cf_sql_varchar">,
									  <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">, <!---getdate()--->
									    <cfif isdefined("Form.RHHdescdet") and Len(Trim(Form.RHHdescdet))>
											<cfqueryparam value="#form.RHHdescdet#" cfsqltype="cf_sql_varchar">
										<cfelse>
											null
										</cfif>
										<cfif Len(Trim(form.PCid))>
											,<cfqueryparam value="#form.PCid#" cfsqltype="cf_sql_numeric">
										<cfelse>
											,null
										</cfif>	
										 <cfif isdefined("Form.RHHFid") and Len(Trim(Form.RHHFid))>
										 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#">
										 <cfelse>
										 ,null
										 </cfif>
										 <cfif isdefined("Form.RHHSFid") and Len(Trim(Form.RHHSFid))>
										 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#">
										 <cfelse>
										 ,null
										 </cfif>
									    <cfif isdefined("form.RHHubicacionB")>
											,<cfqueryparam value="#Ucase(Trim(Form.RHHubicacionB))#" cfsqltype="cf_sql_char" null="#Len(trim(form.RHHubicacionB)) EQ 0#">
										</cfif>	
											)
			</cfquery>
			
		<cfelseif isdefined("form.Cambio")>
			<cf_dbtimestamp
			 datasource="#session.dsn#"
			 table="RHHabilidades"
			 redirect="PuestosHabilidades.cfm"
			 timestamp="#form.ts_rversion#"
			 field1="RHHid" type1 = "numeric" value1="#form.RHHid#" 
			 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">		
			 
			<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">			
				update RHHabilidades
				set RHHcodigo = <cfqueryparam value="#ucase(trim(form.RHHcodigo))#" cfsqltype="cf_sql_char">,
				RHHdescripcion = <cfqueryparam value="#form.RHHdescripcion#" cfsqltype="cf_sql_varchar">,
				BMusumod = 		<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				BMfechamod = 	<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">, <!---getdate()--->
				RHHdescdet =	<cfif isdefined("Form.RHHdescdet") and Len(Trim(Form.RHHdescdet))>
									<cfqueryparam value="#form.RHHdescdet#" cfsqltype="cf_sql_varchar">
								<cfelse>
									null
								</cfif>,
				PCid = <cfif Len(Trim(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse> null</cfif>,	
				RHHFid = <cfif Len(Trim(form.RHHFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#"><cfelse> null</cfif>,	
				RHHSFid = <cfif Len(Trim(form.RHHSFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#"><cfelse> null</cfif>	
				<cfif isdefined("form.RHHubicacionB")>
					,RHHubicacionB = <cfqueryparam value="#Ucase(Trim(Form.RHHubicacionB))#" cfsqltype="cf_sql_char" null="#Len(trim(form.RHHubicacionB)) EQ 0#">
				</cfif>
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHHid =  <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
				  <!---and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)--->
			</cfquery>
			  <cfset modo = 'CAMBIO'>
			  
		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_Puestos_deleteA" datasource="#session.DSN#">			
				delete 
				from RHIHabilidad 
				where RHHid = <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfquery name="ABC_Puestos_deleteB" datasource="#session.DSN#">							
				delete from RHHabilidades
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHHid =  <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
			</cfquery>
						
		<cfelseif isdefined("form.btn_AgregarItem") and len(trim(RHIHid)) eq 0><!--- Alta Detalle--->
		
			<cfquery name="rsCuenta" datasource="#session.DSN#">
				select RHHcodigo, RHHdescripcion
				from RHHabilidades
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHHid =  <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			 <cf_dbtimestamp
			 datasource="#session.dsn#"
			 table="RHHabilidades"
			 redirect="PuestosHabilidades.cfm"
			 timestamp="#form.ts_rversion#"
			 field1="RHHid" type1 = "numeric" value1="#form.RHHid#" 
			 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">			
			 
			<cfquery name="ABC_Puestos_updateD0" datasource="#session.DSN#">							
				update RHHabilidades
				set RHHcodigo = <cfqueryparam value="#ucase(trim(form.RHHcodigo))#" cfsqltype="cf_sql_char">,
				RHHdescripcion = <cfqueryparam value="#form.RHHdescripcion#" cfsqltype="cf_sql_varchar">,
				BMusumod = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				BMfechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,<!---getdate()--->
				RHHdescdet = <cfif isdefined("Form.RHHdescdet") and Len(Trim(Form.RHHdescdet))>
								<cfqueryparam value="#form.RHHdescdet#" cfsqltype="cf_sql_varchar">
							 <cfelse>
								null
							 </cfif>,
 				<cfif Len(Trim(form.PCid))>
					PCid = <cfqueryparam value="#form.PCid#" cfsqltype="cf_sql_numeric">
				<cfelse>
					PCid = null
				</cfif>	
				<cfif isdefined("form.RHHubicacionB")>
					, RHHubicacionB = <cfqueryparam value="#Ucase(Trim(Form.RHHubicacionB))#" cfsqltype="cf_sql_char" null="#Len(trim(form.RHHubicacionB)) EQ 0#">
				</cfif>
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHHid =  <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
				 <!--- and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)--->
			</cfquery>
				  

			<cfquery name="rsCuenta" datasource="#session.DSN#">
				select RHHcodigo, RHHdescripcion, BMusumod, BMfechamod, PCid
				from RHHabilidades
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHHid =  <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			 <cfif rsCuenta.RECORDCOUNT GT 0>  
				<cfquery name="ABC_Puestos_insertD0" datasource="#session.DSN#">
				<!---if (@@rowcount > 0)--->
					insert INTO RHIHabilidad (RHHid, RHIHdescripcion, RHIHorden)
					values (<cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">, 
							<cfqueryparam value="#form.RHIHdescripcion#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#form.RHIHorden#" cfsqltype="cf_sql_numeric">)
				</cfquery>
			 </cfif>
			<cfset modo = 'CAMBIO'>
			
		<cfelseif isdefined("form.btn_ModificarItem") and len(trim(RHIHid)) gt 0><!--- Cambio Detalle--->
			 <cf_dbtimestamp
			 datasource="#session.dsn#"
			 table="RHHabilidades"
			 redirect="PuestosHabilidades.cfm"
			 timestamp="#form.ts_rversion#"
			 field1="RHHid" type1 = "numeric" value1="#form.RHHid#" 
			 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">
			<cfquery name="ABC_Puestos_updateD01" datasource="#session.DSN#">
				update RHHabilidades
				set RHHcodigo = <cfqueryparam value="#ucase(trim(form.RHHcodigo))#" cfsqltype="cf_sql_char">,
				RHHdescripcion = <cfqueryparam value="#form.RHHdescripcion#"    cfsqltype="cf_sql_varchar">,
				BMusumod = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
				BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				RHHdescdet = <cfif isdefined("Form.RHHdescdet") and Len(Trim(Form.RHHdescdet))>
								<cfqueryparam value="#form.RHHdescdet#" cfsqltype="cf_sql_varchar">
							 <cfelse>
								null
							 </cfif> ,
							 <cfif Len(Trim(form.PCid))>
								PCid = <cfqueryparam value="#form.PCid#" cfsqltype="cf_sql_numeric">
							 <cfelse>
								PCid = null
							 </cfif>	
							 <cfif isdefined("form.RHHubicacionB")>
								,RHHubicacionB = <cfqueryparam value="#Ucase(Trim(Form.RHHubicacionB))#" cfsqltype="cf_sql_char" null="#Len(trim(form.RHHubicacionB)) EQ 0#">
							 </cfif>
			
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHHid =  <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
				  <!---and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)--->
		   </cfquery>

			<cfquery name="rsCuenta2" datasource="#session.DSN#">
				select RHHcodigo, RHHdescripcion, BMusumod, BMfechamod
				from RHHabilidades
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHHid =  <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfif rsCuenta2.RECORDCOUNT GT 0>
				<cfquery name="ABC_Puestos_updateD02" datasource="#session.DSN#">
					update RHIHabilidad 
					set RHIHdescripcion=<cfqueryparam value="#form.RHIHdescripcion#" cfsqltype="cf_sql_varchar">, 
					RHIHorden=<cfqueryparam value="#form.RHIHorden#" cfsqltype="cf_sql_numeric">
					where RHHid = <cfqueryparam value="#form.RHHid#" cfsqltype="cf_sql_numeric">
					and RHIHid = <cfqueryparam value="#form.RHIHid#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>	
			<cfset modo = 'CAMBIO'>
			
		<cfelseif isdefined("form.borrarItem") and len(trim(borrarItem)) gt 0><!--- Baja Detalle--->
				<cfquery name="ABC_Puestos_updateD02" datasource="#session.DSN#">
					delete 
					from RHIHabilidad 
					where RHIHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.borrarItem#">
				</cfquery>				  
			<cfset modo = 'CAMBIO'>
		<!----================== PARA COMPORTAMIENTOS ==================---->
		<cfelseif isdefined("form.btn_AgregarComp")>		
			<cfquery datasource="#Session.DSN#">			
				insert into RHComportamiento (Ecodigo, RHCOcodigo, 
											RHCOdescripcion, RHHid, RHGNid, 
											RHCOpeso, BMUsucodigo, BMfechaalta)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCOcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.RHCOdescripcion#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOpeso#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
			</cfquery>
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.borrarComp") and len(trim(form.borrarComp))>
			<cfquery datasource="#session.DSN#">
				delete from RHComportamiento
				where RHCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.borrarComp#">
			</cfquery>
			<cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.btn_ModificarComp") and isdefined("form.RHCOid") and len(trim(form.RHCOid))>
			<cfquery datasource="#session.DSN#">
				update RHComportamiento
					set RHCOcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCOcodigo#">,
						RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">,
						RHCOpeso = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#form.RHCOpeso#">,
						<cfif isdefined("form.RHCOdescripcion") and len(trim(form.RHCOdescripcion))>
							RHCOdescripcion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHCOdescripcion#">
						<cfelse>
							RHCOdescripcion = ' '
						</cfif>
				where RHCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOid#">
			</cfquery>
			<cfset modo = 'CAMBIO'>
		<!----======================================================------>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHHid" type="hidden" value="#form.RHHid#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>