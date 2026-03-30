<cfparam name="form.PQmaxSession" default=""><!--- Funcionar para VPN y no VPN --->
<cfif IsDefined("form.Cambio")>	
	<cfset fechaIni="">
	<cfset fechaFin="">	
	<cfinclude template="ISBpaquete-palabrasreservadas.cfm">
	
	<cfif isdefined('form.PQinicio') and len(trim(form.PQinicio))>
		<cfset fechaIni=LSParseDateTime(form.PQinicio)>
	</cfif>
	<cfif isdefined('form.PQcierre') and len(trim(form.PQcierre))>
		<cfset fechaFin=LSParseDateTime(form.PQcierre)>
	</cfif>
		
	<cfif isdefined('form.TRANUC')>
		<cfquery datasource="#session.dsn#" name="rstrafer">
			select Tranuc
			from ISBtransaccionDepositos
			where Tranuc = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TRANUC#">
			and Sevcod = '09'
			and Trahab = 'S'
		</cfquery>	 
	</cfif>
	
	
	<cfif isdefined('form.PQtransaccion') and isdefined('form.PQpagodeposito')>
		<cfquery datasource="#session.dsn#" name="rstransac">
			select Tranuc
			from ISBtransaccionDepositos
			where Tranuc = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQtransaccion#">
			and Sevcod = '52'
			and Trahab = 'S'
		</cfquery>	 
	</cfif>
	
	<cfif isdefined('form.PQnombre')>

		<cfif Listfind(palabrasreservadas,"#LCase(form.PQnombre)#") neq 0>
			<cfthrow message="El nombre #form.PQnombre# es una palabra reservada en Cisco">
		</cfif>

	</cfif>

	<cfif rstrafer.RecordCount eq 0>
		<cfthrow message="La transacción (SEVCOD=09) #form.TRANUC# no existe en el catálogo de transacciones">
	</cfif>

	<cfif rstransac.RecordCount eq 0 and form.PQpagodeposito eq 'F'>
		<cfthrow message="La transacción (SEVCOD=52) #form.PQtransaccion# no existe en el catálogo de transacciones">
	</cfif>
		
	
		
	<cfif form.PQcomisionTipo EQ 1>
		<cfset form.PQcomisionMnto = 0>
	<cfelseif form.PQcomisionTipo EQ 2>
		<cfset form.PQcomisionPctj = 0>
	<cfelse>
		<cfset form.PQcomisionMnto = 0>
		<cfset form.PQcomisionPctj = 0>
	</cfif>

	<cfinvoke component="saci.comp.ISBpaquete"
		method="Cambio" >
		<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
		<cfinvokeargument name="Miso4217" value="#form.Miso4217#">
		<cfif isdefined('form.MRidMayorista') and form.MRidMayorista NEQ '-1'>
			<cfinvokeargument name="MRidMayorista" value="#form.MRidMayorista#">
		</cfif>
		<cfinvokeargument name="PQnombre" value="#form.PQnombre#">
		<cfinvokeargument name="PQdescripcion" value="#form.PQdescripcion#">
		<cfinvokeargument name="PQinicio" value="#fechaIni#">
		<cfinvokeargument name="PQcierre" value="#fechaFin#">
		<cfinvokeargument name="PQcomisionTipo" value="#form.PQcomisionTipo#">
		<cfinvokeargument name="PQpagodeposito" value="#form.PQpagodeposito#">
		<cfinvokeargument name="PQcomisionPctj" value="#form.PQcomisionPctj#">
		<cfinvokeargument name="PQcomisionMnto" value="#form.PQcomisionMnto#">
		<cfinvokeargument name="PQtoleranciaGarantia" value="#form.PQtoleranciaGarantia#">
		<cfinvokeargument name="PQtarifaBasica" value="#form.PQtarifaBasica#">
		<cfinvokeargument name="PQcompromiso" value="#IsDefined('form.PQcompromiso')#">
		<cfinvokeargument name="PQhorasBasica" value="#form.PQhorasBasica#">
		<cfinvokeargument name="PQprecioExc" value="#form.PQprecioExc#">
		<cfinvokeargument name="Habilitado" value="#Iif(IsDefined('form.Habilitado'), DE('1'), DE('0'))#">
		<cfinvokeargument name="PQroaming" value="#IsDefined('form.PQroaming')#">
		<cfinvokeargument name="PQautogestion" value="#IsDefined('form.PQautogestion')#">
		<cfinvokeargument name="PQutilizadoagente" value="#Iif(IsDefined('form.PQutilizadoagente'), DE('1'), DE('0'))#">
		<cfinvokeargument name="PQmailQuota" value="#form.PQmailQuota#">
		<cfinvokeargument name="PQinterfaz" value="#IsDefined('form.PQinterfaz')#">
		<cfinvokeargument name="PQtelefono" value="#IsDefined('form.PQtelefono')#">
		<cfif Len(Trim(form.PQmaxSession))>
			<cfinvokeargument name="PQmaxSession" value="#form.PQmaxSession#">
		</cfif>
		<cfif Len(Trim(form.CINCAT))>
			<cfinvokeargument name="CINCAT" value="#form.CINCAT#">
		</cfif>
		<cfinvokeargument name="PQagrupa" value="#form.PQagrupa#">
		<cfif isdefined('form.PQadelanto') and Len(Trim(form.PQadelanto))>
			<cfinvokeargument name="PQadelanto" value="S">
		<cfelse>
			<cfinvokeargument name="PQadelanto" value="N">
		</cfif>
		<cfif isdefined('form.PQtransaccion') and Len(Trim(form.PQtransaccion))>
			<cfinvokeargument name="PQtransaccion" value="#form.PQtransaccion#">
		</cfif>		
		<cfif isdefined('form.TRANUC') and Len(Trim(form.TRANUC))>
			<cfinvokeargument name="TRANUC" value="#form.TRANUC#">
		</cfif>				
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversionS#">
	</cfinvoke>

<cfelseif IsDefined("form.Baja")>
	
	<cfquery name="rsPrepago" datasource="#session.DSN#">
		select count(1) as existe
		from ISBprepago
		where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#">
	</cfquery>
	<cfquery name="rsProducto" datasource="#session.DSN#">
		select count(1) as existe
		from ISBproducto
		where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#">
	</cfquery>
	<cfquery name="rsAgenteOferta" datasource="#session.DSN#">
		select count(1) as existe
		from ISBagenteOferta
		where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#">
	</cfquery>
	
	<!--- Consulta los resultados de los querys anteriores para saber si existen dependencias--->
	<cfset tablas = "">
	<cfif rsPrepago.existe GT 0> <cfset tablas = "ISBprepago"></cfif>
	<cfif rsProducto.existe GT 0> <cfif len(trim(tablas))><cfset tablas =  tablas & ", "></cfif> <cfset tablas = tablas & "ISBproducto"></cfif>
	<cfif rsAgenteOferta.existe GT 0> <cfif len(trim(tablas))><cfset tablas =  tablas & ", "></cfif> <cfset tablas = tablas & "ISBagenteOferta"></cfif>
	
	<cfif len(trim(tablas))>
		<!---Existen dependecias por lo que no se puede borrar el paquete--->
		<cfthrow message="Error: No se puede borrar el paquete #form.PQnombre#, debido a que posee dependencias con #tablas#">
	<cfelse>
		<!---No existen dependecias, se puede borrar el paquete. Primero borra las relaciones que tenga con ISBservicio y con ISBcambioPaquete--->
		<cfquery name="rsDelServicio" datasource="#session.DSN#">
			delete ISBservicio where PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#">
		</cfquery>
		<cfquery name="rsDelCambioPQ" datasource="#session.DSN#">
			delete ISBpaqueteCambio where PQcodDesde = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#">
		</cfquery>
		<cfinvoke component="saci.comp.ISBpaquete"
			method="Baja" >
			<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
		</cfinvoke>
		<cfset form.PQcodigo = "">
		<!--- <cflocation url="ISBpaquete.cfm?pagina=#form.pagina#&Filtro_PQnombre=#form.Filtro_PQnombre#&HFiltro_PQnombre=#form.Filtro_PQnombre#&Filtro_PQdescripcion=#form.Filtro_PQdescripcion#&HFiltro_PQdescripcion=#form.Filtro_PQdescripcion#"> --->
	</cfif>
	

<cfelseif IsDefined("form.Nuevo")>

<cfelseif IsDefined("form.Alta")>	

<cfinclude template="ISBpaquete-palabrasreservadas.cfm">
			
	<cfif isdefined('form.TRANUC')>
		<cfquery datasource="#session.dsn#" name="rstrafer">
			select Tranuc
			from ISBtransaccionDepositos
			where Tranuc = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TRANUC#">
			and Sevcod = '09'
			and Trahab = 'S'
		</cfquery>	 
	</cfif>


	<cfif isdefined('form.PQtransaccion') and isdefined('form.PQpagodeposito')>
	<cfquery datasource="#session.dsn#" name="rstransac">
			select Tranuc
			from ISBtransaccionDepositos
			where Tranuc = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQtransaccion#">
			and Sevcod = '52'
			and Trahab = 'S'
		</cfquery>	 
	</cfif>

	<cfif isdefined('form.PQnombre')>

		<cfif Listfind(palabrasreservadas,"#LCase(form.PQnombre)#") neq 0>
			<cfthrow message="El nombre #form.PQnombre# es una palabra reservada en Cisco">
		</cfif>

	</cfif>

	<cfif rstrafer.RecordCount eq 0>
		<cfthrow message="La transacción (SEVCOD=09) #form.TRANUC# no existe en el catálogo de transacciones">
	</cfif>
	
	<cfif rstransac.RecordCount eq 0 and form.PQpagodeposito eq 'F'>
		<cfthrow message="La transacción (SEVCOD=52) #form.PQtransaccion# no existe en el catálogo de transacciones">
	</cfif>
	
	<cfquery  name="ckPaquete" datasource="#session.dsn#">
		select count(1) as r 
			from ISBpaquete
    where convert(int, PQcodigo)  = convert(int,<cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#">)
	</cfquery>
	
	<cfif ckPaquete.Recordcount gt 0 and ckPaquete.r eq 1>
		<cfthrow message="Ya existe un registro con ese c&oacute;digo">
	<cfelse>
		<cfinvoke component="saci.comp.ISBpaquete" returnvariable="idReturn"
			method="Alta"  >
			<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
			<cfinvokeargument name="Miso4217" value="#form.Miso4217#">
			<cfif isdefined('form.MRidMayorista') and form.MRidMayorista NEQ '-1'>
				<cfinvokeargument name="MRidMayorista" value="#form.MRidMayorista#">
			</cfif>
			<cfinvokeargument name="PQnombre" value="#form.PQnombre#">
			<cfinvokeargument name="PQdescripcion" value="#form.PQdescripcion#">
			<cfinvokeargument name="PQinicio" value="#LSParseDateTime(form.PQinicio)#">
			<cfif Len(Trim(form.PQcierre))> 
				<cfinvokeargument name="PQcierre" value="#LSParseDateTime(form.PQcierre)#">
			</cfif>
			<cfinvokeargument name="PQcomisionTipo" value="#form.PQcomisionTipo#">
			<cfinvokeargument name="PQpagodeposito" value="#form.PQpagodeposito#">
			<cfinvokeargument name="PQcomisionPctj" value="#form.PQcomisionPctj#">
			<cfinvokeargument name="PQcomisionMnto" value="#form.PQcomisionMnto#">
			<cfinvokeargument name="PQtoleranciaGarantia" value="#form.PQtoleranciaGarantia#">
			<cfinvokeargument name="PQtarifaBasica" value="#form.PQtarifaBasica#">
			<cfinvokeargument name="PQcompromiso" value="#IsDefined('form.PQcompromiso')#">
			<cfinvokeargument name="PQhorasBasica" value="#form.PQhorasBasica#">
			<cfinvokeargument name="PQprecioExc" value="#form.PQprecioExc#">
			<cfinvokeargument name="Habilitado" value="#Iif(IsDefined('form.Habilitado'), DE('1'), DE('0'))#">
			<cfinvokeargument name="PQroaming" value="#IsDefined('form.PQroaming')#">
			<cfinvokeargument name="PQautogestion" value="#IsDefined('form.PQautogestion')#">
			<cfinvokeargument name="PQutilizadoagente" value="#Iif(IsDefined('form.PQutilizadoagente'), DE('1'), DE('0'))#">
			<cfinvokeargument name="PQmailQuota" value="#form.PQmailQuota#">
			<cfinvokeargument name="PQinterfaz" value="#IsDefined('form.PQinterfaz')#">
			<cfinvokeargument name="PQtelefono" value="#IsDefined('form.PQtelefono')#">
			<cfif Len(Trim(form.PQmaxSession))>
				<cfinvokeargument name="PQmaxSession" value="#form.PQmaxSession#">
			</cfif>
			<cfinvokeargument name="CINCAT" value="0">
			<cfinvokeargument name="PQagrupa" value="#form.PQagrupa#">
			<cfif isdefined('form.PQadelanto') and Len(Trim(form.PQadelanto))>
				<cfinvokeargument name="PQadelanto" value="S">
			<cfelse>
				<cfinvokeargument name="PQadelanto" value="N">
			</cfif>
			<cfif isdefined('form.PQtransaccion') and Len(Trim(form.PQtransaccion))>
				<cfinvokeargument name="PQtransaccion" value="#form.PQtransaccion#">
			</cfif>		
			<cfif isdefined('form.TRANUC') and Len(Trim(form.TRANUC))>
				<cfinvokeargument name="TRANUC" value="#form.TRANUC#">
			</cfif>		
			<cfinvokeargument name="PQfileconfigura" value="#form.PQfileconfigura#">
		</cfinvoke>
	</cfif>
	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBservicio-apply.cfm">

<cfinclude template="ISBpaquete-redirect.cfm">
