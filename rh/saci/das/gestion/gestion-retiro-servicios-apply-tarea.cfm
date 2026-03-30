<!---Componente que genera el XML para el cambio de Paquete--->
<cfinvoke component="saci.comp.generadorXML" method="retiroServicio" returnvariable="servicioXML">
	<cfinvokeargument name="Contratoid" value="#form.pkg#">
	<cfinvokeargument name="PQcodigo" value="#rsPaquete.PQcodigo#">
	<cfinvokeargument name="motivoid" value="#form.MRid#">
	<cfinvokeargument name="fecha" value="#LSParseDateTime(form.fretiro)#">
	<cfinvokeargument name="devolucion" value="#isdefined('form.devolucion')#">
</cfinvoke>	

<!---Validacion de los datos XML--->
<cfsavecontent variable="xsd"><cfinclude template="/saci/xsd/retiroServicio.xsd"></cfsavecontent>
<cfset result = XMLValidate(servicioXML, xsd)>

<cfif result.status>
	
	<cfquery name="rsExisteTarea" datasource="#session.DSN#">
		select TPid,TPinsercion,TPtipo
		from ISBtareaProgramada 
		where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
				and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
				and TPestado = 'P'
				and TPtipo = 'RS'
	</cfquery>
	
	<cfquery name="rsPaquete" datasource="#session.DSN#">
		Select pr.PQcodigo
			, pa.PQnombre
		from ISBproducto pr
			inner join ISBpaquete pa
				on pa.PQcodigo=pr.PQcodigo
					and pa.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		where pr.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
	</cfquery>		

	<cfset varTXT = "Retiro de Servicios">
	<cfif isdefined('rsPaquete') and rsPaquete.recordCount GT 0>
		<cfset varTXT = "Retiro del Servicio: (" & rsPaquete.PQcodigo & '-'  & rsPaquete.PQnombre & ")">
	</cfif>
	
	<cfif isdefined("rsExisteTarea.TPid") and len(trim(rsExisteTarea.TPid))>		
		<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
			method="Cambio">
			<cfinvokeargument name="TPid" value="#rsExisteTarea.TPid#">
			<cfinvokeargument name="CTid" value="#form.cue#">
			<cfinvokeargument name="Contratoid" value="#form.pkg#">
			<cfinvokeargument name="TPinsercion" value="#rsExisteTarea.TPinsercion#">
			<cfinvokeargument name="TPfecha" value="#LSParseDateTime(form.fretiro)#">
			<cfinvokeargument name="TPfechaReal" value="">
			<cfinvokeargument name="TPdescripcion" value="#varTXT#">
			<cfinvokeargument name="TPxml" value="#servicioXML#">
			<cfinvokeargument name="TPestado" value="P">
			<cfinvokeargument name="TPtipo" value="#rsExisteTarea.TPtipo#">
		</cfinvoke>
	<cfelse>	
		<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
			method="Alta">
			<cfinvokeargument name="CTid" value="#form.cue#">
			<cfinvokeargument name="Contratoid" value="#form.pkg#">
			<cfinvokeargument name="TPinsercion" value="#now()#">
			<cfinvokeargument name="TPfecha" value="#LSParseDateTime(form.fretiro)#">
			<cfinvokeargument name="TPfechaReal" value="">
			<cfinvokeargument name="TPdescripcion" value="#varTXT#">
			<cfinvokeargument name="TPxml" value="#servicioXML#">
			<cfinvokeargument name="TPestado" value="P">
			<cfinvokeargument name="TPtipo" value="RS">
		</cfinvoke>	
	</cfif>
<cfelse>
	<cfthrow message="Error: Los Datos para el archivo XML son incorrectos">
</cfif>