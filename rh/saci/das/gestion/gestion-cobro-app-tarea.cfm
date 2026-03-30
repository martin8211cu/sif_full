
<!---Componente que genera el XML para el cambio de Paquete--->
<cfinvoke component="saci.comp.generadorXML" method="cambioFormaCobro" returnvariable="CobroXML">
	<cfinvokeargument name="Contratoid" value="">
	<cfinvokeargument name="CTcobro" value="#form.CTcobro2#">
	<cfinvokeargument name="CTtipoCtaBco" value="#CTtipoCtaBco#">
	<cfinvokeargument name="CTbcoRef" value="#CTbcoRef#">
	<cfinvokeargument name="CTmesVencimiento" value="#CTmesVencimiento#">
	<cfinvokeargument name="CTanoVencimiento" value="#CTanoVencimiento#">
	<cfinvokeargument name="CTverificadorTC" value="#CTverificadorTC#">
	<cfinvokeargument name="EFid" value="#EFid#">
	<cfinvokeargument name="MTid" value="#MTid#">
	<cfinvokeargument name="PpaisTH" value="#PpaisTH#">
	<cfinvokeargument name="CTcedulaTH" value="#CTcedulaTH#">
	<cfinvokeargument name="CTnombreTH" value="#CTnombreTH#">
	<cfinvokeargument name="CTapellido1TH" value="#CTapellido1TH#">
	<cfinvokeargument name="CTapellido2TH" value="#CTapellido2TH#">
</cfinvoke>	
	
<!---Validacion de los datos XML--->
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
</cfif>