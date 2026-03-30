<!---Componente que genera el XML para el retiro de login--->
<cfinvoke component="saci.comp.generadorXML" method="retiroLogin" returnvariable="loginXML">
	<cfinvokeargument name="Contratoid" value="#form.pkg#">
	<cfinvokeargument name="PQcodigo" value="#rsPaquete.PQcodigo#">
	<cfinvokeargument name="LGlogin" value="#rsLog.LGlogin#">
	<cfinvokeargument name="motivoid" value="#form.MRid#">
	<cfinvokeargument name="fecha" value="#LSParseDateTime(form.fretiro)#">
</cfinvoke>	

<!---Validacion de los datos XML--->
<cfsavecontent variable="xsd"><cfinclude template="/saci/xsd/retiroServicio.xsd"></cfsavecontent>
<cfset result = XMLValidate(loginXML, xsd)>

<cfif result.status>
	
	<cfquery name="rsExisteTarea" datasource="#session.DSN#">
		select TPid,TPinsercion,TPtipo
		from ISBtareaProgramada 
		where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
				and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
				and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
				and TPestado = 'P'
				and TPtipo = 'RL'
	</cfquery>
	
	<cfif isdefined("rsExisteTarea.TPid") and len(trim(rsExisteTarea.TPid))>
		
		<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
			method="Cambio">
			<cfinvokeargument name="TPid" value="#rsExisteTarea.TPid#">
			<cfinvokeargument name="CTid" value="#form.cue#">
			<cfinvokeargument name="Contratoid" value="#form.pkg#">
			<cfinvokeargument name="LGnumero" value="#form.logg#">
			<cfinvokeargument name="TPinsercion" value="#rsExisteTarea.TPinsercion#">
			<cfinvokeargument name="TPfecha" value="#LSParseDateTime(form.fretiro)#">
			<!---Esta fecha es la fecha en que se realizo el cambio--->
			<cfinvokeargument name="TPfechaReal" value="">
			<cfinvokeargument name="TPdescripcion" value="Retiro de Login #form.logg#">
			<cfinvokeargument name="TPxml" value="#loginXML#">
			<cfinvokeargument name="TPestado" value="P">
			<cfinvokeargument name="TPtipo" value="RL">
		</cfinvoke>
	<cfelse>	
		<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
			method="Alta">
			<cfinvokeargument name="CTid" value="#form.cue#">
			<cfinvokeargument name="Contratoid" value="#form.pkg#">
			<cfinvokeargument name="LGnumero" value="#form.logg#">
			<cfinvokeargument name="TPinsercion" value="#now()#">
			<cfinvokeargument name="TPfecha" value="#LSParseDateTime(form.fretiro)#">
			<!---Esta fecha es la fecha en que se realizo el cambio--->
			<cfinvokeargument name="TPfechaReal" value="">
			<cfinvokeargument name="TPdescripcion" value="Retiro de Login #form.logg#">
			<cfinvokeargument name="TPxml" value="#loginXML#">
			<cfinvokeargument name="TPestado" value="P">
			<cfinvokeargument name="TPtipo" value="RL">
		</cfinvoke>	
	</cfif>

<cfelse>
	<cfthrow message="Error: Los Datos para el archivo XML son incorrectos">
</cfif>