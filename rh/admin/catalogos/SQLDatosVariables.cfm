<!---
<!--- ************** Funcion que valida si el campor RHEDVcodigo ya existe solo en 
					el caso de que se haya cambiado el RHEDVcodigo del encabezado ***************--->
<cffunction name="validar">
	<cfargument name="codigo" required="no" type="string">	
	<cfquery name="rsRHDEVcodigo" datasource="#Session.DSN#">
		select RHEDVcodigo
		from RHEDatosVariables
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	     and  RHEDVcodigo = <cfqueryparam value="#arguments.codigo#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfif  rsRHDEVcodigo.recordcount GT 0>
		<cf_throw message="EL código del dato variable ya existe">
	</cfif> 
</cffunction> 
---->

<!--- ============================================== ---> 
<cfparam name="action" default="DatosVariables.cfm">
<cfif not isdefined("form.btnNuevoD")>
	<!--- Caso 1: Agregar Encabezado --->
	<cfif isdefined("form.btnModificarEnc")>			
			<!----
			<!---********** If para saber si el RHEDVcodigo fue cambiado (en RHEDVcodigo se guarda el codigo
							cambiado(si es el caso) de la BDs y el _RHEDVcodigo del registro mostrado**********------> 
			<cfif trim(form.RHEDVcodigo) neq trim(form.RHEDVcodigo) >
				<cfset validar(form.RHEDVcodigo)>
			</cfif> 
			---->
			
			<cf_dbtimestamp datasource="#session.dsn#"
					table="RHEDatosVariables"
					redirect="DatosVariables.cfm"
					timestamp="#form.ts_rversionE#"
					field1="RHEDVid" 
					type1="numeric" 
					value1="#form.RHEDVid#"
					field2="Ecodigo" 
					type2="integer" 
					value2="#session.ecodigo#">
			
			<cfquery name="updateE" datasource="#Session.DSN#">
				update RHEDatosVariables set
					   RHEDVcodigo   = <cfqueryparam value="#Form.RHEDVcodigo#" cfsqltype="cf_sql_char">,
					   RHEDVdescripcion   = <cfqueryparam value="#Form.RHEDVdescripcion#" cfsqltype="cf_sql_longvarchar">,
					   RHDEorden = <cfif isdefined ("form.RHDEorden") and len(trim(form.RHDEorden))>
					   <cfqueryparam value="#Form.RHDEorden#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
					   BMUsucodigo   = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   fechaalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					   RHEDVtipo = <cfqueryparam value="#Form.RHEDVtipo#" cfsqltype="cf_sql_integer">
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				   and RHEDVid = <cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric">
			</cfquery>
	</cfif>
	
	<cfif isdefined("Form.btnAgregarE")>
		<cftransaction>		
		<!---<cfset validar(form.RHEDVcodigo)>--->
			<cfquery name="insertE" datasource="#Session.DSN#">
					insert into RHEDatosVariables (Ecodigo, RHEDVcodigo, RHEDVdescripcion, RHDEorden, BMUsucodigo, fechaalta, RHEDVtipo) 
					values ( <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Form.RHEDVcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.RHEDVdescripcion#" cfsqltype="cf_sql_longvarchar">,
						 <cfif isdefined ("form.RHDEorden") and len(trim(form.RHDEorden))><cfqueryparam value="#Form.RHDEorden#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
						 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						 <cfqueryparam value="#Form.RHEDVtipo#" cfsqltype="cf_sql_integer">						 
					   )
					<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertE"> 
		</cftransaction>
		  
	<!--- Caso 2: Borrar encabezado y sus respectivos detalles--->
	<cfelseif isdefined("Form.btnBorrarE")>
		<cfquery name="deleteD" datasource="#session.DSN#">
				delete from RHDDatosVariables
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				  and  RHEDVid = <cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="deleteE" datasource="#session.DSN#">
				delete from RHEDatosVariables
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				  and  RHEDVid = <cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		<cfset  action = "listaDatosVariables.cfm">
	
	<!--- Caso 3: Agregar Detalle  y opcionalmente modificar el encabezado --->
	<cfelseif isdefined("Form.btnAgregarD")>
			<!---
			<!---********** If para saber si el RHEDVcodigo fue cambiado (en RHEDVcodigo se guarda el codigo
							cambiado(si es el caso) de la BDs y el _RHEDVcodigo del registro mostrado**********------> 
			<cfif trim(form.RHEDVcodigo) neq trim(form._RHEDVcodigo) >
				<cfset validar(form.RHEDVcodigo)>
			</cfif> 
			---->
			
			<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHEDatosVariables"
			 			redirect="DatosVariables.cfm"
			 			timestamp="#form.ts_rversionE#"
						field1="RHEDVid" type1="numeric" value1="#form.RHEDVid#"
						field2="Ecodigo" type2="integer" value2="#session.ecodigo#">
	
			<cfquery name="updateE" datasource="#Session.DSN#">
				update RHEDatosVariables set
					   RHEDVcodigo   = <cfqueryparam value="#Form.RHEDVcodigo#" cfsqltype="cf_sql_char">,
					   RHEDVdescripcion   = <cfqueryparam value="#Form.RHEDVdescripcion#" cfsqltype="cf_sql_longvarchar">,
					   RHDEorden = <cfif isdefined ("form.RHDEorden") and len(trim(form.RHDEorden))>
					   					<cfqueryparam value="#Form.RHDEorden#" cfsqltype="cf_sql_integer">
									<cfelse>null</cfif>,
					   BMUsucodigo   = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   fechaalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					   RHEDVtipo = <cfqueryparam value="#Form.RHEDVtipo#" cfsqltype="cf_sql_integer">
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  RHEDVid = <cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric">
			</cfquery>
									
			<cfquery name="insertD" datasource="#Session.DSN#">
				insert into RHDDatosVariables(Ecodigo, RHDDVcodigo, RHDDVdescripcion, RHDDVvalor, RHEDVid, 
							RHDDVorden, BMUsucodigo, fechaalta, EIid, RHDDVvaloracion, RHHFid, RHHSFid, RHECgrado) 
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHDDVcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDDVdescripcion#">,
						 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.RHDDVvalor#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEDVid#">,
						 <cfif isdefined ("form.RHDDVorden") and len(trim(form.RHDDVorden))>
						  	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDDVorden#">
						 <cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfif isdefined("form.EIid") and len(trim(form.EIid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#"><cfelse>null</cfif>,
						 <cfif isdefined("form.RHDDVvaloracion") and len(trim(form.RHDDVvaloracion)) ><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHDDVvaloracion, ',','','all')#"><cfelse>null</cfif>,
                         <cfif isdefined("form.RHHFid") and len(trim(form.RHHFid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#"><cfelse>null</cfif>,
                         <cfif isdefined("form.RHHSFid") and len(trim(form.RHHSFid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#"><cfelse>null</cfif>,
                         <cfif isdefined("form.RHECgrado") and len(trim(form.RHECgrado)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECgrado#"><cfelse>null</cfif>
					   )
			</cfquery>
			
	<!--- Caso 4: Modificar Detalle  y opcionalmente modificar el encabezado --->			
	<cfelseif isdefined("Form.btnCambiarD")>			
			<!---
			<!---********** If para saber si el RHEDVcodigo fue cambiado (en RHEDVcodigo se guarda el codigo
							cambiado(si es el caso) de la BDs y el _RHEDVcodigo del registro mostrado**********------> 
			<cfif trim(form.RHEDVcodigo) neq trim(form._RHEDVcodigo) >
				<cfset validar(form.RHEDVcodigo)>
			</cfif>
			---->
			
			<!--- Update del encabezado ---->
			<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHEDatosVariables"
			 			redirect="DatosVariables.cfm"
			 			timestamp="#form.ts_rversionE#"
						field1="RHEDVid" type1="numeric" value1="#form.RHEDVid#"
						field2="Ecodigo" type2="integer" value2="#session.ecodigo#">
				
			<cfquery name="updateE" datasource="#Session.DSN#">
				update RHEDatosVariables set
					   RHEDVcodigo   = <cfqueryparam value="#Form.RHEDVcodigo#" cfsqltype="cf_sql_char">,
					   RHEDVdescripcion   = <cfqueryparam value="#Form.RHEDVdescripcion#" cfsqltype="cf_sql_longvarchar">,
					   RHDEorden = 	<cfif isdefined ("form.RHDEorden") and len(trim(form.RHDEorden))>
					   					<cfqueryparam value="#Form.RHDEorden#" cfsqltype="cf_sql_integer">
									<cfelse>null</cfif>,
					   BMUsucodigo   = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   fechaalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					   RHEDVtipo = <cfqueryparam value="#Form.RHEDVtipo#" cfsqltype="cf_sql_integer">
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  RHEDVid = <cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<!----  Update del detalle ---->
			<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHDDatosVariables"
			 			redirect="DatosVariables.cfm"
			 			timestamp="#form.ts_rversionD#"
						field1="RHEDVid" type1="numeric" value1="#form.RHEDVid#"
						field2="Ecodigo" type2="integer" value2="#session.ecodigo#"
						field3="RHDDVlinea" type3="numeric" value3="#form.RHDDVlinea#">

			<cfquery name="updateD" datasource="#Session.DSN#">
				update 	RHDDatosVariables set
					   	RHDDVcodigo   = <cfqueryparam value="#Form.RHDDVcodigo#" cfsqltype="cf_sql_char">,
					   	RHDDVdescripcion   = <cfqueryparam value="#Form.RHDDVdescripcion#" cfsqltype="cf_sql_varchar">,
					  	RHDDVvalor  = <cfqueryparam value="#Form.RHDDVvalor#" cfsqltype="cf_sql_longvarchar">,	
					   	RHDDVorden  =	<cfif isdefined ("form.RHDDVorden") and len(trim(form.RHDDVorden))>
					   						<cfqueryparam value="#Form.RHDDVorden#" cfsqltype="cf_sql_integer">
										<cfelse>null</cfif>,	
					   	BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						EIid = <cfif isdefined("form.EIid") and len(trim(form.EIid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#"><cfelse>null</cfif>,
						RHDDVvaloracion = <cfif isdefined("form.RHDDVvaloracion") and len(trim(form.RHDDVvaloracion)) ><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHDDVvaloracion, ',', '', 'all')#"><cfelse>null</cfif>,
						RHHFid = <cfif isdefined("form.RHHFid") and len(trim(form.RHHFid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#"><cfelse>null</cfif>,
                        RHHSFid = <cfif isdefined("form.RHHSFid") and len(trim(form.RHHSFid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#"><cfelse>null</cfif>,
                        RHECgrado = <cfif isdefined("form.RHECgrado") and len(trim(form.RHECgrado)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECgrado#"><cfelse>null</cfif>
					 
                where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  RHEDVid = <cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric">
					   and RHDDVlinea  = <cfqueryparam value="#Form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
			</cfquery> 
	
	<!--- Caso 5: Borrar detalle --->
	<cfelseif isdefined("Form.btnBorrarD")>
		<cfquery name="deleteD" datasource="#session.DSN#">
				delete from RHDDatosVariables
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				  and  RHEDVid = <cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric">
				  and RHDDVlinea   = <cfqueryparam value="#Form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>
	
<cfoutput>
	<form action="#action#" method="post" name="sql">
		<input name="RHEDVid" type="hidden" value="<cfif isdefined("insertE")>#insertE.identity#<cfelse>#form.RHEDVid#</cfif>" >
		<cfif isdefined("Form.btnCambiarD") >
			<input name="RHDDVlinea" type="hidden" value="<cfif isdefined("Form.RHDDVlinea")>#Form.RHDDVlinea#</cfif>" >
		</cfif>	
	</form>
</cfoutput>
<!--- ============================================== ---> 
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
