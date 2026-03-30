		
<!---Componente que genera el XML para el cambio de Paquete--->
<cfinvoke component="saci.comp.generadorXML" method="CambioPaquete" returnvariable="PaqueteXML">
	<cfinvokeargument name="cambioPQ" value="#session.saci.cambioPQ#">
	<cfinvokeargument name="cuentaid" value="#form.cue#">
</cfinvoke>	

<!---Validacion de los datos XML--->
<cfsavecontent variable="xsd"><cfinclude template="/saci/xsd/cambioPaquete.xsd"></cfsavecontent>
<cfset result = XMLValidate(PaqueteXML, xsd)>

<!---Agrega el cambio de Paquete--->
<cfif result.status>		
	<cfquery name="rsConservar" datasource="#session.DSN#">
		select TPid,TPinsercion,TPtipo
		from ISBtareaProgramada 
		where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
				and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
				and TPestado = 'P'
				and TPtipo = 'CP'
	</cfquery>

	<cfquery name="rsPaquetes" datasource="#session.DSN#">
		Select p1.PQcodigo as PQcodigoOrig
			, p1.PQnombre as PQnombreOrig
			, p2.PQcodigo as PQcodigoNew
			, p2.PQnombre as PQnombreNew
		from ISBpaquete p1
			inner join ISBpaquete p2
				on p2.Ecodigo=p1.Ecodigo
					and p2.PQcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.cambioPQ.PQnuevo#">
		
		where p1.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and p1.PQcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.cambioPQ.PQanterior#">
	</cfquery>	
	<cfset varTXT = "Cambio de paquete">
	<cfif isdefined('rsPaquetes') and rsPaquetes.recordCount GT 0>
		<cfset varTXT = "Cambio del paquete " & rsPaquetes.PQcodigoOrig & '-' & rsPaquetes.PQnombreOrig & ' por el paquete ' & rsPaquetes.PQcodigoNew & '-' & rsPaquetes.PQnombreNew>
	</cfif>	
	
	<cfif isdefined("rsConservar.TPid") and len(trim(rsConservar.TPid))>
		<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
			method="Cambio">
			<cfinvokeargument name="TPid" value="#rsConservar.TPid#">
			<cfinvokeargument name="CTid" value="#form.cue#">
			<cfinvokeargument name="Contratoid" value="#form.pkg#">
			<cfinvokeargument name="TPinsercion" value="#rsConservar.TPinsercion#">
			<cfinvokeargument name="TPfecha" value="#LSParseDateTime(form.fretiro)#">
			<cfinvokeargument name="TPfechaReal" value="">
			<cfinvokeargument name="TPdescripcion" value="#varTXT#">
			<cfinvokeargument name="TPxml" value="#PaqueteXML#">
			<cfinvokeargument name="TPestado" value="P">
			<cfinvokeargument name="TPtipo" value="#rsConservar.TPtipo#">
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
			<cfinvokeargument name="TPxml" value="#PaqueteXML#">
			<cfinvokeargument name="TPestado" value="P">
			<cfinvokeargument name="TPtipo" value="CP">
		</cfinvoke>	
	</cfif>
	<cfset StructDelete(Session.saci, "cambioPQ")>
<cfelse>
	<cfset StructDelete(Session.saci, "cambioPQ")>
	<cfthrow message="Error: Los Datos para el archivo XML son incorrectos">
</cfif>
