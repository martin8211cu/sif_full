<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif not isdefined("url.formato") >
	<cfset tipoformato = "html">
<cfelse>
	<cfset tipoformato = #url.formato#>
</cfif>

<cfquery name="rsAnoPres" datasource="#session.dsn#">
	select CPPfechaDesde, CPPfechaHasta
	from CPresupuestoPeriodo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfset fecha_desde = DateFormat(rsAnoPres.CPPfechaDesde,'dd/mm/yyyy')>
<cfset fecha_hasta = DateFormat(rsAnoPres.CPPfechaHasta,'dd/mm/yyyy')>


<cfquery name="rsReporte" datasource="#session.DSN#">
	select	
		Em.Edescripcion, 
		EO.EOnumero, 
		EO.EOfecha,
		EO.EOtotal, 
		DO.DOconsecutivo,	
		DO.ESidsolicitud,0,
		DO.DOdescripcion,
		DO.DOcantidad,
		#LvarOBJ_PrecioU.enSQL_AS("DO.DOpreciou")#,
		Mo.Mnombre,
		Sn.SNidentificacion,
		Sn.SNnombre,
		coalesce(Sn.SNtelefono,'--') as SNtelefono,
		DSC.DSconsecutivo,
		DSC.ESnumero, 
		Sn.SNcodigo,
		Sn.SNnumero
	
	from EOrdenCM EO 
		inner join DOrdenCM DO
			on EO.EOidorden  = DO.EOidorden 
		inner join Monedas Mo
			on  EO.Ecodigo = Mo.Ecodigo
			and EO.Mcodigo     = Mo.Mcodigo 		
		inner join SNegocios Sn
			on EO.Ecodigo = Sn.Ecodigo
			and EO.SNcodigo = Sn.SNcodigo
		inner join Empresas Em
			on EO.Ecodigo = Em.Ecodigo
		inner join DSolicitudCompraCM DSC
			on DO.Ecodigo = DSC.Ecodigo			
			and DO.DSlinea = DSC.DSlinea

	where EO.Ecodigo  = #session.Ecodigo#
	  and EO.EOestado = 10 
	  <cfif isdefined("url.numero1") and len(trim(url.numero1)) and isdefined("url.numero2") and len(trim(url.numero2))>
		  and Sn.SNnumero between '#url.numero1#' and '#url.numero2#'
	  </cfif>
	  and EO.EOfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fdesde)#"> 
	  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fhasta)#">

	order by EO.SNcodigo
</cfquery>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	<cfset typeRep = 1>
	<cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	</cfif>
	<cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = typeRep
		fileName = "cm.consultas.OrdenesCompraLocales"
		headers = "empresa:#session.enombre#"/>
<cfelse>
<cfreport format="#url.formato#" template="Reportes/OrdenesCompraLocales.cfr" query="rsReporte">
	<cfreportparam name="enombre" 		value="#session.enombre#">
	<cfreportparam name="fecha_desde"   value="#fecha_desde#">
	<cfreportparam name="fecha_hasta"   value="#fecha_hasta#">
	<cfif isDefined("url.codigo1") and len(trim(url.codigo1)) NEQ 0>
		<cfreportparam name="codigo1"   value="#url.codigo1#">
	<cfelseif isDefined("url.codigo1") and len(trim(url.codigo1)) EQ 0>
		<cfreportparam name="codigo1"   value="-1"> 
	</cfif>	
	<cfif isDefined("url.codigo2") and len(trim(url.codigo2)) NEQ 0>
		<cfreportparam name="codigo2"   value="#url.codigo2#">
	<cfelseif isDefined("url.codigo2") and len(trim(url.codigo2)) EQ 0>
		<cfreportparam name="codigo2"   value="-1"> 
	</cfif>		
	<cfif isDefined("url.fdesde") and len(trim(url.fdesde)) NEQ 0>
		<cfreportparam name="fdesde"   	value="#LSParseDateTime(url.fdesde)#">
	<cfelseif isDefined("url.fdesde") and len(trim(url.fdesde)) EQ 0>
		<cfreportparam name="fdesde"   	value="#LSParseDateTime('01/01/1900')#">
	</cfif>
	<cfif isDefined("url.fhasta") and len(trim(url.fhasta)) NEQ 0>
		<cfreportparam name="fhasta" 	value="#LSParseDateTime(url.fhasta)#">
	<cfelseif isDefined("url.fhasta") and len(trim(url.fhasta)) EQ 0>
		<cfreportparam name="fhasta"  	value="#LSParseDateTime('01/01/6100')#"> 
	</cfif>
	<cfif isDefined("url.numero1") and len(trim(url.numero1)) NEQ 0>
		<cfreportparam name="numero1"	value="#url.numero1#">
	<cfelseif isDefined("url.numero1") and len(trim(url.numero1)) EQ 0>
		<cfreportparam name="numero1"   value="000-0000"> 
	</cfif>
	<cfif isDefined("url.numero2") and len(trim(url.numero2)) NEQ 0>
		<cfreportparam name="numero2"   value="#url.numero2#">
	<cfelseif isDefined("url.numero2") and len(trim(url.numero2)) EQ 0>
		<cfreportparam name="numero2"   value="999-9999">  
	</cfif>
	<cfreportparam name="maskPU"  value="#LvarOBJ_PrecioU.maskRPT()#">
</cfreport>
</cfif>
