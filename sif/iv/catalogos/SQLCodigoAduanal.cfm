<!--- ************** Funcion que valida si el campor CAcodigo ya existe solo en 
					el caso de que se haya cambiado el CAcodigo del encabezado ***************--->
<cffunction name="validar">
	<cfargument name="codigo" required="no" type="string">
	
	<cfquery name="rsCAcodigo" datasource="#Session.DSN#">
		select CAcodigo 
		from CodigoAduanal
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	     and  CAcodigo = <cfqueryparam value="#arguments.codigo#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfif  rsCAcodigo.recordcount GT 0>
		<cf_errorCode	code = "50395" msg = "EL Código Anual ya existe!">
	</cfif> 
</cffunction> 

<cfif not isdefined("form.btnNuevoD")>
	<!--- Caso 1: Agregar Encabezado --->
	<cfif isdefined("form.btnModificarE")>
			<!---********** If para saber si el CAcodigo fue cambiado (en CAcodigo se guarda el codigo
							cambiado(si es el caso) de la BDs y el _CAcodigo del registro mostrado**********------> 
			<cfif trim(form.CAcodigo) neq trim(form._CAcodigo) >
				<cfset validar(Form.CAcodigo)>
			</cfif> 

			<cf_dbtimestamp datasource="#session.dsn#"
					table="CodigoAduanal"
					redirect="CodigoAduanal.cfm"
					timestamp="#form.ts_rversionE#"
					field1="CAid" 
					type1="numeric" 
					value1="#form.CAid#"
					field2="Ecodigo" 
					type2="integer" 
					value2="#session.ecodigo#">
			
			<cfquery name="updateE" datasource="#Session.DSN#">
				update CodigoAduanal set
					   Icodigo   = <cfqueryparam value="#Form.LImpuestos#" cfsqltype="cf_sql_char">,
					   CAcodigo   = <cfqueryparam value="#Form.CAcodigo#" cfsqltype="cf_sql_char">,
					   CAdescripcion    = <cfqueryparam value="#Form.CAdescripcion#" cfsqltype="cf_sql_varchar">,
					   porcCIF  = <cfqueryparam value="#Form.porcCIF#" cfsqltype="cf_sql_money">,	
					   porcFOB  = <cfqueryparam value="#Form.porcFOB#" cfsqltype="cf_sql_money">,	
					   porcSegLoc  = <cfqueryparam value="#Form.porcSegLoc#" cfsqltype="cf_sql_money">,	
					   porcFletLoc = <cfqueryparam value="#Form.porcFletLoc#" cfsqltype="cf_sql_money">,	
					   porcAgeAdu  = <cfqueryparam value="#Form.porcAgeAdu#" cfsqltype="cf_sql_money">,				   
					   Usucodigomod   = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   fechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">				   
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CAid = <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">
			</cfquery>
	</cfif>
	<cfif isdefined("Form.AltaE")>
	<!---**************** query para verificar que no exista ya ese codigo aduanal CAcodigo *****--->
		<cftransaction>
			
			<cfset validar(Form.CAcodigo)>
			<cfquery name="insertE" datasource="#Session.DSN#">
					insert into CodigoAduanal(Ecodigo, Icodigo, CAcodigo, CAdescripcion, porcCIF, 
							porcFOB, porcSegLoc, porcFletLoc, porcAgeAdu, Usucodigo, fechaalta) 
					values ( <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Form.LImpuestos#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.CAcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.CAdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.porcCIF#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.porcFOB#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.porcSegLoc#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.porcFletLoc#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.porcAgeAdu#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					   )
					<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertE"> 
		</cftransaction>
		  
		<cfif isdefined('insertE')>
			<cfset form.CAid = insertE.identity>		
		</cfif>
	<!--- Caso 2: Borrar encabezado y sus respectivos detalles--->
	<cfelseif isdefined("Form.btnBorrarE")>
		<cfquery name="deleteD" datasource="#session.DSN#">
			delete from ImpuestosCodigoAduanal
			where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			  and  CAid = <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="deleteE" datasource="#session.DSN#">
			delete from CodigoAduanal
			where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			  and  CAid = <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">
		</cfquery>

	<!--- Caso 3: Agregar Detalle  y opcionalmente modificar el encabezado --->
	<cfelseif isdefined("Form.btnAgregarD")>
			<!---********** If para saber si el CAcodigo fue cambiado (en CAcodigo se guarda el codigo
							cambiado(si es el caso) de la BDs y el _CAcodigo del registro mostrado**********------> 
			<cfif trim(form.CAcodigo) neq trim(form._CAcodigo) >
				<cfset validar(Form.CAcodigo)>
			</cfif> 
			
			<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CodigoAduanal"
			 			redirect="CodigoAduanal.cfm"
			 			timestamp="#form.ts_rversionE#"
						field1="CAid" 
						type1="numeric" 
						value1="#form.CAid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.ecodigo#">
	
			<cfquery name="updateE" datasource="#Session.DSN#">
				update CodigoAduanal set
					   Icodigo   = <cfqueryparam value="#Form.LImpuestos#" cfsqltype="cf_sql_char">,
					   CAcodigo   = <cfqueryparam value="#Form.CAcodigo#" cfsqltype="cf_sql_char">,
					   CAdescripcion    = <cfqueryparam value="#Form.CAdescripcion#" cfsqltype="cf_sql_varchar">,
					   porcCIF  = <cfqueryparam value="#Form.porcCIF#" cfsqltype="cf_sql_money">,	
					   porcFOB  = <cfqueryparam value="#Form.porcFOB#" cfsqltype="cf_sql_money">,	
					   porcSegLoc  = <cfqueryparam value="#Form.porcSegLoc#" cfsqltype="cf_sql_money">,	
					   porcFletLoc = <cfqueryparam value="#Form.porcFletLoc#" cfsqltype="cf_sql_money">,	
					   porcAgeAdu  = <cfqueryparam value="#Form.porcAgeAdu#" cfsqltype="cf_sql_money">,				   
					   Usucodigomod   = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   fechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">				   
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CAid = <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfquery name="insertD" datasource="#Session.DSN#">
				insert into ImpuestosCodigoAduanal(CAid,Ecodigo, Icodigo, Ppaisori, porcCIF, 
							porcFOB, porcSegLoc, porcFletLoc, porcAgeAdu, Usucodigo, fechaalta) 
				values ( <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">,
						 #session.ecodigo#,
						 <cfqueryparam value="#Form.DLImpuestos#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.LPaises#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.DporcCIF#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.DporcFOB#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.DporcSegLoc#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.DporcFletLoc#" cfsqltype="cf_sql_money">,
						 <cfqueryparam value="#form.DporcAgeAdu#" cfsqltype="cf_sql_money">,
						 #session.Usucodigo#,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					   )
			</cfquery>
	
			<cfset form.Ppaisori = Form.LPaises>		
	<!--- Caso 4: Modificar Detalle  y opcionalmente modificar el encabezado --->			
	<cfelseif isdefined("Form.btnCambiarD")>
			<!---********** If para saber si el CAcodigo fue cambiado (en CAcodigo se guarda el codigo
							cambiado(si es el caso) de la BDs y el _CAcodigo del registro mostrado**********------> 
			<cfif trim(form.CAcodigo) neq trim(form._CAcodigo) >
				<cfset validar(Form.CAcodigo)>
			</cfif> 
			
			<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CodigoAduanal"
			 			redirect="CodigoAduanal.cfm"
			 			timestamp="#form.ts_rversionE#"
						field1="CAid" 
						type1="numeric" 
						value1="#form.CAid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.ecodigo#">
				
			<cfquery name="updateE" datasource="#Session.DSN#">
				update CodigoAduanal set
					   Icodigo   = <cfqueryparam value="#Form.LImpuestos#" cfsqltype="cf_sql_char">,
					   CAcodigo   = <cfqueryparam value="#Form.CAcodigo#" cfsqltype="cf_sql_char">,
					   CAdescripcion    = <cfqueryparam value="#Form.CAdescripcion#" cfsqltype="cf_sql_varchar">,
					   porcCIF  = <cfqueryparam value="#Form.porcCIF#" cfsqltype="cf_sql_money">,	
					   porcFOB  = <cfqueryparam value="#Form.porcFOB#" cfsqltype="cf_sql_money">,	
					   porcSegLoc  = <cfqueryparam value="#Form.porcSegLoc#" cfsqltype="cf_sql_money">,	
					   porcFletLoc = <cfqueryparam value="#Form.porcFletLoc#" cfsqltype="cf_sql_money">,	
					   porcAgeAdu  = <cfqueryparam value="#Form.porcAgeAdu#" cfsqltype="cf_sql_money">,				   
					   Usucodigomod   = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   fechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">				   
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CAid = <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cf_dbtimestamp datasource="#session.dsn#"
			 			table="ImpuestosCodigoAduanal"
			 			redirect="CodigoAduanal.cfm"
			 			timestamp="#form.ts_rversionD#"
						field1="CAid" 
						type1="numeric" 
						value1="#form.CAid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.ecodigo#"
						field3="Ppaisori" 
						type3="char" 
						value3="#form.LPaises#"
					>

			<cfquery name="updateD" datasource="#Session.DSN#">
				update ImpuestosCodigoAduanal set
					   Icodigo   = <cfqueryparam value="#Form.DLImpuestos#" cfsqltype="cf_sql_char">,
					   porcCIF  = <cfqueryparam value="#Form.DporcCIF#" cfsqltype="cf_sql_money">,	
					   porcFOB  = <cfqueryparam value="#Form.DporcFOB#" cfsqltype="cf_sql_money">,	
					   porcSegLoc  = <cfqueryparam value="#Form.DporcSegLoc#" cfsqltype="cf_sql_money">,	
					   porcFletLoc = <cfqueryparam value="#Form.DporcFletLoc#" cfsqltype="cf_sql_money">,	
					   porcAgeAdu  = <cfqueryparam value="#Form.DporcAgeAdu#" cfsqltype="cf_sql_money">,				   
					   Usucodigomod   = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   fechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">				   
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CAid = <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">
					   and Ppaisori   = <cfqueryparam value="#trim(Form.LPaises)#" cfsqltype="cf_sql_char">
			</cfquery> 
			
			<cfset form.Ppaisori = Form.LPaises>
	<!--- Caso 5: Borrar detalle --->
	<cfelseif isdefined("Form.btnBorrarD")>
		<cfquery name="deleteD" datasource="#session.DSN#">
				delete from ImpuestosCodigoAduanal
				where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				  and  CAid = <cfqueryparam value="#form.CAid#" cfsqltype="cf_sql_numeric">
				  and  Ppaisori = <cfqueryparam value="#trim(Form.LPaises)#" cfsqltype="cf_sql_char">
		</cfquery>
	</cfif>
</cfif>

<cfset params="">
<cfif isdefined("Form.btnNuevo")>
	<cfset params= params&'&btnNuevo=btnNuevo'>	
</cfif>
<cfif not isdefined('form.btnNuevo') and not isdefined('form.btnBorrarE') and not isdefined('form.Regresar')>
	<cfif isdefined('form.CAid') and form.CAid NEQ ''>
		<cfset params= params&'&CAid='&form.CAid>	
	</cfif>
	<cfif isdefined("Form.btnCambiarD") or isdefined('form.btnAgregarD')>
		<cfset params= params&'&Ppaisori='&form.Ppaisori>	
	</cfif>	
</cfif>
<cfif isdefined('form.filtro_CAcodigo') and form.filtro_CAcodigo NEQ ''>
	<cfset params= params&'&filtro_CAcodigo='&form.filtro_CAcodigo>	
	<cfset params= params&'&hfiltro_CAcodigo='&form.filtro_CAcodigo>		
</cfif>
<cfif isdefined('form.filtro_CAdescripcion') and form.filtro_CAdescripcion NEQ ''>
	<cfset params= params&'&filtro_CAdescripcion='&form.filtro_CAdescripcion>	
	<cfset params= params&'&hfiltro_CAdescripcion='&form.filtro_CAdescripcion>		
</cfif>
<cfif isdefined('form.filtro_Idescripcion') and form.filtro_Idescripcion NEQ ''>
	<cfset params= params&'&filtro_Idescripcion='&form.filtro_Idescripcion>	
	<cfset params= params&'&hfiltro_Idescripcion='&form.filtro_Idescripcion>		
</cfif>
<cfif isdefined('form.filtro_Pnombre') and form.filtro_Pnombre NEQ ''>
	<cfset params= params&'&filtro_Pnombre='&form.filtro_Pnombre>	
	<cfset params= params&'&hfiltro_Pnombre='&form.filtro_Pnombre>		
</cfif>
<cfif isdefined('form.filtro_Idescripcion2') and form.filtro_Idescripcion2 NEQ ''>
	<cfset params= params&'&filtro_Idescripcion2='&form.filtro_Idescripcion2>	
	<cfset params= params&'&hfiltro_Idescripcion2='&form.filtro_Idescripcion2>		
</cfif>
<cfif isdefined('form.Pagina2') and form.Pagina2 NEQ ''>
	<cfset params= params&'&Pagina2='&form.Pagina2>	
</cfif>

<cflocation url="listaCodigoAduanal.cfm?Pagina=#Form.Pagina##params#">

