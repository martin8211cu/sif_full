
<cfif isdefined("Url.RHTid") and not isdefined("Form.RHTid")>
	<cfparam name="Form.RHTid" default="#Url.RHTid#">
<cfelse>
	<cfparam name="Form.RHTid" default="-1">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
<cfelse>
	<cfparam name="Form.DEid" default="-1">
</cfif>
<cfif isdefined("Url.fechaH") and not isdefined("Form.fechaH")>
	<cfparam name="Form.fechaH" default="#Url.fechaH#">
<cfelse>
	<cfparam name="Form.fechaH" default="#LSDateFormat(now(), "dd/mm/yyyy")#">
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="pdf">
</cfif>
<cfif isdefined("tempfile")>
	<cfset BDconexion = Lcache>
<cfelse>
	<cfset BDconexion = Session.DSN >
</cfif>

<cfquery name="reporte" datasource="#BDconexion#">
	select   {fn concat({fn concat({fn concat({fn concat(a.DEnombre , ' ' )}, a.DEapellido1 )}, ' ' )},a.DEapellido2 )} as NombreCompleto,
		RHAAid  ,rhaa.RHTid ,DLlinea ,rhaa.DEid  , fdesdeaccion ,fhastaaccion ,falerta,
		recibido , rhaa.BMUsucodigo ,BMfechaalta,
		RHTdesc, rhaa.Ecodigo
	from  RHAlertaAcciones rhaa
	   	  inner join DatosEmpleado a
		    on  a.DEid    = rhaa.DEid
			and a.Ecodigo = rhaa.Ecodigo 
		<cfif isdefined("Form.fechaH") and Len(Trim(Form.fechaH))>
			and rhaa.falerta <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("d",1,LSParseDateTime(Form.fechaH))#">
		</cfif>
		inner join RHTipoAccion rhta
 		  on rhta.RHTid = rhaa.RHTid
		     and rhta.Ecodigo = rhaa.Ecodigo
				
	where rhaa.Ecodigo = 
	<cfif isdefined("session.Ecodigo")>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
	</cfif>
	
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) and Form.DEid NEQ -1>
		and rhaa.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfif>
	<cfif isdefined("Form.RHTid") and Len(Trim(Form.RHTid)) and Form.RHTid NEQ -1>
		and rhaa.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
	</cfif>
     and rhaa.recibido = 0
	order by rhaa.RHAAid, a.DEid, rhaa.fhastaaccion
</cfquery>

<cfset DescRangoFechas = "">
<cfif isdefined("Form.fechaH") and Len(Trim(Form.fechaH))>
	<cfset DescRangoFechas = "Fecha Hasta: #LSDateFormat(Form.fechaH,'dd/mm/yyyy')#">
<cfelseif not isdefined("Form.fechaH")>
	<cfset DescRangoFechas = "Fechas: TODAS">
</cfif>
<cfif isdefined("reporte") AND reporte.RecordCount NEQ 0>
	
	<cfif isdefined("tempfile")>
		<cfreport format="#Form.formato#" template="VisualizaAlerta.cfr" query="reporte" filename="#tempfile#" overwrite="yes">	
		
			<cfreportparam name="Edescripcion" value="#empresa_nombre#">
			<cfreportparam name="DescRangoFechas" value="#DescRangoFechas#">
		
				<cfreportparam name="RHTid" value="-1">
	
				<cfreportparam name="DEid" value="-1">
				<cfreportparam name="fechaH" value="">
				<cfreportparam name="formato" value="#Form.formato#">
				<cfreportparam name="Automatico" value="true">
		</cfreport>
	<cfelse>
		<cfreport format="#Form.formato#" template= "VisualizaAlerta.cfr" query="reporte">
			<cfreportparam name="Edescripcion" value="#Session.Enombre#">
			<cfreportparam name="DescRangoFechas" value="#DescRangoFechas#">
		
			<cfif isdefined("Form.RHTid") and Len(Trim(Form.RHTid))>
				<cfreportparam name="RHTid" value="#Form.RHTid#">
			<cfelse>
				<cfreportparam name="RHTid" value="-1">
			</cfif>
			<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
				<cfreportparam name="DEid" value="#Form.DEid#">
			<cfelse>
				<cfreportparam name="DEid" value="-1">
			</cfif>
			<cfif isdefined("Form.fechaH") and Len(Trim(Form.fechaH))>
				<cfreportparam name="fechaH" value="#Form.fechaH#">
			<cfelse>
				<cfreportparam name="fechaH" value="">
			</cfif>
			<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
				<cfreportparam name="formato" value="#Form.formato#">
			</cfif>
		</cfreport>
	</cfif>
</cfif>