<cfquery name="rsListadoCompradores" datasource="#session.dsn#">
	select 
		rtrim(d.CMTScodigo)+'-'+rtrim(d.CMTSdescripcion) TipoSoli,
        a.CMCcodigo codigo,
		a.CMCnombre nombre,
		case a.CMCestado when 0 then 'Inactivo' when 1 then 'Activo' end estado        
	from CMCompradores a
		inner join Usuario b
			on b.Usucodigo = a.Usucodigo
		inner join CMEspecializacionComprador c
			on c.CMCid   = a.CMCid 
           and c.Ecodigo = a.Ecodigo
		inner join CMTiposSolicitud d 
		    on d.CMTScodigo = c.CMTScodigo 
           and d.Ecodigo    = c.Ecodigo
	where a.Ecodigo = #session.Ecodigo#
    <cfif isdefined('url.Nombre') and LEN(TRIM(url.Nombre))>
    	and upper(a.CMCnombre) like '%#UCASE(TRIM(url.Nombre))#%'
    </cfif>
    <cfif isdefined('url.Codigo') and LEN(TRIM(url.Codigo))>
    	and upper(a.CMCcodigo) like '%#UCASE(TRIM(url.Codigo))#%'
    </cfif>
     <cfif isdefined('url.Estatus') and LEN(TRIM(url.Estatus))>
    	and a.CMCestado = #url.Estatus#
    </cfif>
    <cfif isdefined('url.CMTScodigo') and LEN(TRIM(url.CMTScodigo))>
    	and d.CMTScodigo = '#url.CMTScodigo#'
    </cfif>
    order by  rtrim(d.CMTScodigo)+'-'+rtrim(d.CMTSdescripcion)
</cfquery>
	<cfset Filtros = ''>
<cfif isdefined('url.Nombre') and LEN(TRIM(url.Nombre))>
	<cfset Filtros = '   Nombre:'& TRIM(url.Nombre)>
</cfif>
<cfif isdefined('url.Codigo') and LEN(TRIM(url.Codigo))>
	<cfset Filtros = Filtros & '   Codigo:'& TRIM(url.Codigo)>
</cfif>
<cfif isdefined('url.Estatus') and LEN(TRIM(url.Estatus))>
	<cfset Activo = 'Activo'><cfset Inactivo = 'Inactivo'>
	<cfset Filtros = Filtros & '   Estatus:'& IIF(url.Estatus EQ 0,Inactivo,Activo)>
</cfif>
<cfif isdefined('url.CMTScodigo') and LEN(TRIM(url.CMTScodigo))>
	<cfset Filtros = Filtros & '   Tipo Solicitud::'& TRIM(URL.CMTScodigo)&'-'&TRIM(URL.CMTSdescripcion)>
</cfif>
<cfif NOT LEN(TRIM(Filtros))>
	<cfset Filtros = 'Sin Filtros'>
<cfelse>
	<cfset Filtros = 'Filtros: '&Filtros>
</cfif>
<cfif url.Formato EQ 'Excel'>
        <cf_exportQueryToFile query="#rsListadoCompradores#" encabezados="true" queryName="rsListadoCompradores"  filename="RepListaComprador.xls" jdbc="false">
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
		<cf_js_reports_service_tag queryReport = "#rsListadoCompradores#" 
			isLink = False 
			typeReport = typeRep
			fileName = "cm.consultas.listadoCompradores"
			headers = "empresa:#session.enombre#"/>
	<cfelse>
    <cfreport format="#url.Formato#" template="listadoCompradores.cfr" query="rsListadoCompradores">
      <cfreportparam name="Empresa" value="#session.enombre#">
      <cfreportparam name="Titulo"  value="Listado de Compradores">
      <cfreportparam name="Filtros" value="#Filtros#">
    </cfreport> 
	</cfif>
</cfif>