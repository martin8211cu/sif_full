<cffunction name="get_CualMes" access="public" returntype="string">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Nombre del mes --->">
		<cfswitch expression="#valor#">
			<cfcase value="1"> <cfset CualMes = 'Enero'> </cfcase>
			<cfcase value="2"> <cfset CualMes = 'Febrero'> </cfcase>
			<cfcase value="3"> <cfset CualMes = 'Marzo'> </cfcase>
			<cfcase value="4"> <cfset CualMes = 'Abril'> </cfcase>
			<cfcase value="5"> <cfset CualMes = 'Mayo'> </cfcase>
			<cfcase value="6"> <cfset CualMes = 'Junio'> </cfcase>												
			<cfcase value="7"> <cfset CualMes = 'Julio'> </cfcase>
			<cfcase value="8"> <cfset CualMes = 'Agosto'> </cfcase>
			<cfcase value="9"> <cfset CualMes = 'Setiembre'> </cfcase>
			<cfcase value="10"> <cfset CualMes = 'Octubre'> </cfcase>
			<cfcase value="11"> <cfset CualMes = 'Noviembre'> </cfcase>
			<cfcase value="12"> <cfset CualMes = 'Diciembre'> </cfcase>
			<cfdefaultcase> <cfset CualMes = 'Enero'> </cfdefaultcase>
		</cfswitch>
	<cfreturn #CualMes#>
</cffunction>

<cfset NombMes = '#get_CualMes(url.mes)#'>
<cfset NombMes2 = '#get_CualMes(url.mes2)#'>

<cfquery name="rsMonloc" datasource="#session.DSN#">
	select Mnombre
	from Empresas a
	inner join Monedas m
		on  a.Ecodigo = m.Ecodigo
		and a.Mcodigo = m.Mcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		a.Fecha as Dfecha,
		d.SNidentificacion,
		d.SNnombre,
		{fn concat ( {fn concat (ct.CCTcodigo, ' - ')}, ct.CCTdescripcion)} as Concepto,
		c.Ddocumento,
		coalesce (rtrim(e.direccion1), e.direccion2) as direccion1,
		
		<!--- Calcular el  SubTotalFac en el cfr ---> 
		round(a.MontoPagadoLocal,2) * case ct.CCTtipo when 'D' then 1.00 else -1.00 end as MontoCalculado,

		case ct.CCTtipo
			when 'D' then
				coalesce(( 
					select sum(Dtotalloc)
					from BMovimientos bm
					where bm.Ecodigo = a.Ecodigo
					  and bm.CCTcodigo = a.TipoPago
					  and bm.Ddocumento = a.DocumentoPago
					  and bm.CCTRcodigo = a.CCTcodigo
					  and bm.DRdocumento = a.Documento
				), 0)
			when 'C' then
				coalesce(( 
					select sum(Dtotalloc)
					from BMovimientos bm
					where bm.Ecodigo = a.Ecodigo
					  and bm.CCTcodigo = a.TipoPago
					  and bm.Ddocumento = a.DocumentoPago
					  and bm.CCTRcodigo = a.CCTcodigo
					  and bm.DRdocumento = a.Documento
				), 0) * -1.00

		end 
		as TotalFac
	from ImpDocumentosCxCMov a
		inner join HDocumentos c
			inner join CCTransacciones ct
			on  ct.CCTcodigo = c.CCTcodigo
			and ct.Ecodigo   = c.Ecodigo
		on  c.CCTcodigo = a.CCTcodigo
		and c.Ecodigo   = a.Ecodigo
		and c.Ddocumento = a.Documento


		inner join SNegocios d
		on  d.Ecodigo  = c.Ecodigo
		and d.SNcodigo = c.SNcodigo

		left outer join DireccionesSIF  e
		on   e.id_direccion = c.id_direccionFact

	where   a.Periodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
	and     a.Periodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
	and   ((a.Periodo * 100 + a.Mes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">))
	and     a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by a.Fecha,d.SNnombre,c.Ddocumento
	
	
</cfquery>

<!--- <cf_dump var="#rsReporte#"> --->

<cfif rsReporte.recordcount GT 20000>
	<cfoutput>
	<br>
	<br>
	Se genero un reporte más grande de lo permitido ( Máximo de 20.000 registros ). El reporte genera #rsReporte.recordcount# Registros.  Se abortó el proceso
	<br>
	<br>
	</cfoutput>
	<cfabort>
</cfif>


<!--- Define cual reporte va a llamar --->
<cfset archivo = "IVATrasEfecCob.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- INVOCA EL REPORTE --->


<cfif isdefined("url.formato") and url.formato eq 'Tabular'>
	<cfquery name="rsReporteQoQ" dbtype="query">
		select 
			SNidentificacion as Identificacion,
			SNnombre as Nombre,
			Ddocumento as Documento,
			Concepto,
			Dfecha as Fecha,
			direccion1 as Direccion,
			TotalFac - MontoCalculado as SubTotal,
			MontoCalculado as Impuesto,
			TotalFac as Total
		from rsReporte
		order by Dfecha, Nombre, Documento
	</cfquery>

	<cf_exportQueryToFile query="#rsReporteQoQ#" filename="IVA_Efec_Cobrado_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
<cfelse>
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
		typeReport = #typeRep#
		fileName = "cc.reportes.IVATrasEfecCob"/>
	<cfelse>
	<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
		<cfreportparam name="periodo" value="#url.periodo#">
		<cfreportparam name="mes" value="#NombMes#">
		<cfreportparam name="periodo2" value="#url.periodo2#">
		<cfreportparam name="mes2" value="#NombMes2#">
		<cfreportparam name="Mlocal" value="#rsMonloc.Mnombre#">
	</cfreport>
	</cfif>
</cfif>	
