<cfif isdefined("form.Cambiar")>
	
	<cfif form.CTcobro2 EQ "4">						
		<cfset CTcobro = form.CTcobro2>
		<cfset CTtipoCtaBco = "">
		<cfset CTbcoRef = "">
		<cfset CTmesVencimiento = "">
		<cfset CTanoVencimiento = "">
		<cfset CTverificadorTC = "">
		<cfset EFid = "">
		<cfset MTid = "">
		<cfset PpaisTH = "">
		<cfset CTcedulaTH = "">
		<cfset CTnombreTH = ""> 
		<cfset CTapellido1TH = "">
		<cfset CTapellido2TH = "">
			
	<cfelseif  form.CTcobro2 EQ "2">
		<cfset CTcobro = form.CTcobro2>
		<cfset CTtipoCtaBco = "">
		<cfset CTbcoRef = form.NumTarjeta2>
		<cfset CTmesVencimiento = form.MesTarjeta2>
		<cfset CTanoVencimiento = form.AnoTarjeta2>
		<cfset CTverificadorTC = form.VerificaTarjeta2>
		<cfset EFid = "">
		<cfset MTid = form.MTid2>
		<cfset PpaisTH = form.Ppais2>
		<cfset CTcedulaTH = form.CedulaTarjeta2>
		<cfset CTnombreTH = form.NombreTarjeta2> 
		<cfset CTapellido1TH = form.Apellido1Tarjeta2>
		<cfset CTapellido2TH = form.Apellido2Tarjeta2>
		
	<cfelseif form.CTcobro2 EQ "1">
		<cfset CTcobro = form.CTcobro2>
		<cfset CTtipoCtaBco = form.CuentaTipo2>
		<cfset CTbcoRef = form.NumCuenta2>
		<cfset CTmesVencimiento = "">
		<cfset CTanoVencimiento = "">
		<cfset CTverificadorTC = "">
		<cfset EFid = form.EFid2>					
		<cfset MTid = "">
		<cfset PpaisTH = "">
		<cfset CTcedulaTH = form.CedulaCuenta2>
		<cfset CTnombreTH =form.NombreCuenta2> 
		<cfset CTapellido1TH = form.Apellido1Cuenta2>
		<cfset CTapellido2TH = form.Apellido2Cuenta2>
	</cfif>
	
	<cfif isdefined("form.radio")>
		
		<cfif form.radio EQ 1>
			<cfinclude template="/saci/das/gestion/gestion-cobro-app-tarea.cfm">	<!---retiro en una fecha determinada--->
		
		<cfelseif form.radio EQ 2>										<!---retiro en este momento--->					
			<cfinvoke component="saci.comp.ISBcuentaCobro" method="Cambio">	
				<cfinvokeargument name="CTid" 				value="#form.cue#">
				<cfinvokeargument name="CTcobro" 			value="#CTcobro2#">
				<cfinvokeargument name="CTtipoCtaBco" 		value="#CTtipoCtaBco#">
				<cfinvokeargument name="CTbcoRef" 			value="#CTbcoRef#">
				<cfinvokeargument name="CTmesVencimiento" 	value="#CTmesVencimiento#">
				<cfinvokeargument name="CTanoVencimiento" 	value="#CTanoVencimiento#">
				<cfinvokeargument name="CTverificadorTC" 	value="#CTverificadorTC#">
				<cfinvokeargument name="EFid" 				value="#EFid#">
				<cfinvokeargument name="MTid" 				value="#MTid#">
				<cfinvokeargument name="PpaisTH" 			value="#PpaisTH#">
				<cfinvokeargument name="CTcedulaTH" 		value="#CTcedulaTH#">
				<cfinvokeargument name="CTnombreTH" 		value="#CTnombreTH#">
				<cfinvokeargument name="CTapellido1TH" 		value="#CTapellido1TH#">
				<cfinvokeargument name="CTapellido2TH" 		value="#CTapellido2TH#">
			</cfinvoke>
		</cfif>	
		
	<cfelse>
		<cfthrow message="Error: no seleccionó si deseaba hacer el retiro en este momento o en un fecha determinada.">
	</cfif>
	
	<!---<!---Validacion de los datos XML--->
	<cfsavecontent variable="xsd"><cfinclude template="/saci/xsd/cambioPaquete.xsd"></cfsavecontent>
	<cfset result = XMLValidate(CobroXML, xsd)>
	
	<!---Agrega el cambio de Paquete--->
	<cfif result.status>		
		<cfquery name="rsConservar" datasource="#session.DSN#">
			select TPid,TPinsercion,TPtipo
			from ISBtareaProgramada 
			where 	CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
					and TPestado = 'P'
					and TPtipo = 'CFC'
					<!---and Contratoid = null--->
		</cfquery>
		
		<cfif isdefined("rsConservar.TPid") and len(trim(rsConservar.TPid))>
			<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
				method="Cambio">
				<cfinvokeargument name="TPid" value="#rsConservar.TPid#">
				<cfinvokeargument name="CTid" value="#form.CTid#">
				<cfinvokeargument name="Contratoid" value="">
				<cfinvokeargument name="TPinsercion" value="#rsConservar.TPinsercion#">
				<cfinvokeargument name="TPfecha" value="#LSParseDateTime(form.fretiro)#">
				<cfinvokeargument name="TPfechaReal" value="">
				<cfinvokeargument name="TPdescripcion" value="Cambio de forma de cobro">
				<cfinvokeargument name="TPxml" value="#CobroXML#">
				<cfinvokeargument name="TPestado" value="P">
				<cfinvokeargument name="TPtipo" value="#rsConservar.TPtipo#">
			</cfinvoke>
		<cfelse>	
			<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
				method="Alta">
				<cfinvokeargument name="CTid" value="#form.CTid#">
				<cfinvokeargument name="Contratoid" value="">
				<cfinvokeargument name="TPinsercion" value="#now()#">
				<cfinvokeargument name="TPfecha" value="#LSParseDateTime(form.fretiro)#">
				<cfinvokeargument name="TPfechaReal" value="">
				<cfinvokeargument name="TPdescripcion" value="Cambio de forma de cobro">
				<cfinvokeargument name="TPxml" value="#CobroXML#">
				<cfinvokeargument name="TPestado" value="P">
				<cfinvokeargument name="TPtipo" value="CFC">
			</cfinvoke>	
		</cfif>
	<cfelse>
		<cfthrow message="Error: Los Datos para el archivo XML son incorrectos">
	</cfif>--->
<cfelseif isdefined("form.Eliminar")>
	<!---Elimimnacion de la tarea programada--->
	<cfquery name="rsTarea" datasource="#session.DSN#">
		select TPid
		from ISBtareaProgramada 
		where 	CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
				and TPestado = 'P'
				and TPtipo = 'CFC'
	</cfquery>
	<cfif rsTarea.recordCount GT 0>
		<cfinvoke component="saci.comp.ISBtareaProgramada" method="Baja">
			<cfinvokeargument name="TPid" value="#rsTarea.TPid#">
		</cfinvoke>
	</cfif>
</cfif>