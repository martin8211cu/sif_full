<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="P&oacute;lizas Sin Aplicar" 
returnvariable="LB_Titulo" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloR" Default="Reporte de Documentos No Aplicados en Contabilidad General" returnvariable="LB_TituloR" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="PolizasSinAplicar" 
returnvariable="LB_Archivo" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Concepto" Default="Concepto" 
returnvariable="LB_Concepto" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descrpción" 
returnvariable="LB_Descripcion" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Documento" Default="Documento" 
returnvariable="LB_Documento" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Doc" Default="Doc:" 
returnvariable="LB_Doc" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Referencia" Default="Referencia" 
returnvariable="LB_Referencia" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ref" Default="Ref:" 
returnvariable="LB_Ref" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" 
returnvariable="LB_Fecha" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo" 
returnvariable="LB_Periodo" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes" 
returnvariable="LB_Mes" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_anio" Default="Año" 
returnvariable="LB_anio" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Linea" Default="Linea" 
returnvariable="LB_Linea" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Oficina" Default="Oficina" 
returnvariable="LB_Oficina" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta" 
returnvariable="LB_Cuenta" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default="Moneda" 
returnvariable="LB_Moneda" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoOrigen" Default="Monto Original" 
returnvariable="LB_MontoOrigen" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Debitos" Default="Débitos" 
returnvariable="LB_Debitos" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Creditos" Default="Créditos" 
returnvariable="LB_Creditos" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Usuario" Default="Usuario" 
returnvariable="LB_Usuario" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalDocumento" Default="Total Documento" 
returnvariable="LB_TotalDocumento" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalConcepto" Default="Total Concepto" 
returnvariable="LB_TotalConcepto" xmlfile = "DocumentosNoAplicados-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Todos" Default="Todos" 
returnvariable="LB_Todos" xmlfile = "ListaDocumentosEnProceso.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Pagina" Default="Página" 
returnvariable="LB_Pagina" xmlfile = "DocumentosNoAplicados-frame.xml"/>

<cfsetting enablecfoutputonly="yes">

<!--- necesario para convertir una fecha string '24/10/2002' en '20021024'  --->
<cffunction name="convertir_fecha" access="public" returntype="string">
<cfargument name="fecha" type="string" required="true">
	<cfset dia = Mid(fecha,1,2)>
	<cfset mes = Mid(fecha,4,2)>	
	<cfset anio = Mid(fecha,7,4)>
	<cfset fechaConv = anio & mes & dia>			
	<cfreturn #fechaConv#>
</cffunction>

<cfquery name="rsReporte" datasource="#session.dsn#">
	select 
	count(*) as cantidad
	from EContables e
	   inner join DContables d
		  on d.IDcontable = e.IDcontable
	where e.Ecodigo = #session.Ecodigo#
	 <cfif isdefined ("url.periodoIni") and isdefined ("PeriodoFin")>
		<cfif url.PeriodoIni eq url.PeriodoFin>
			and e.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
			and e.Emes    >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">
			and e.Emes    <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">
		<cfelse>
			and e.Eperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
			and e.Eperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#">
			and ((e.Eperiodo * 100 + e.Emes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">))
		</cfif>
	 </cfif>
	 <cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
	  	and (upper(ltrim(rtrim(e.ECusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.Usuario))#"> or <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Usuario#"> = '#LB_Todos#')
	 </cfif>
	 <cfif isdefined ("url.Oficodigo") and len(trim(url.Oficodigo))>
	  	and (d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Oficodigo#"> or <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> = -1)
	 </cfif>
	  <!--- FILTROS DE FECHAS --->
	 <cfif isdefined("url.fechaini") and len(trim(url.fechaini)) and isdefined("url.fechafin") and len(trim(url.fechafin))>
		and e.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaini)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechafin)#">
	 <cfelseif isdefined("url.fechaini") and len(trim(url.fechaini)) and not isdefined("url.fechafin")>
		and e.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaini)#">
	 <cfelseif isdefined("url.fechafin") and len(trim(url.fechafin)) and not isdefined("url.fechaini")>
		and e.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechafin)#">
	 </cfif> 
	  <!--- FILTROS DE Conceptos --->
	 <cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
		and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#"> 
		and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
	 <cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
		and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#">
	 <cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))> 
		and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
	 </cfif> 
     <cfif isdefined('url.origen') and len(trim(url.origen))>
     	and e.Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Origen#">
     </cfif>
	 
	   <!--- FILTROS DE ASIENTOS --->
	 <cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
		and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#"> 
		and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
	 <cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
		and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#">
	 <cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))> 
		and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
	 </cfif> 
     
	<!--- FILTROS DE REFERENCIA Y DOCUMENTO --->         
    <cfif isdefined("url.txtref") and len(trim(url.txtref))>
    	and e.Ereferencia like '%#url.txtref#%'
    </cfif> 
    <cfif isdefined("url.txtdoc") and len(trim(url.txtdoc))>
    	and e.Edocbase like '%#url.txtdoc#%'
    </cfif> 
     
</cfquery>

<cfif rsReporte.cantidad GT 10000>
<cfoutput>
	<br>
	<br>
	&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Se genero un reporte de más de 10,000 Registros.
	<br>
	&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Registros Generados: <cfoutput>#LSnumberformat(rsReporte.cantidad, '_,')#</cfoutput>. 
	<br />
	<br />
	&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Debe ser más específico con los filtros del reporte.
	<br />
	<br />
	&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <a href="ListaDocumentosEnProceso.cfm"><cf_translate key=BTN_Regresar>Regresar</cf_translate></a>
</cfoutput>
	<cfabort>
</cfif>

<cfsetting requesttimeout="600">
<cfset LvarFecha = dateformat(now(), 'DD/MM/YYYY HH:MM:SS')>
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		e.Cconcepto as Concepto, 
		(select min(c.Cdescripcion)
			from
				ConceptoContableE c
			where c.Ecodigo   = e.Ecodigo
		 	  and c.Cconcepto = e.Cconcepto
		) as DescripcionConcepto, 
		e.Edocumento as Documento, 
		e.Efecha as Fecha, 
		e.Eperiodo as Periodo, 
		e.Emes as Mes, 
		e.ECauxiliar as Auxiliar, 
		e.ECusuario as Usuario, 
		e.Ereferencia as ref,
		e.Ereferencia,
		d.Dlinea as Linea,
		d.Ddocumento as DDocumento,
		d.Ddescripcion as Descripcion,
		d.Dreferencia as Referencia,
		cf.CFformato as Cuenta,
		(select min(o.Oficodigo)
			from Oficinas o
			where o.Ecodigo = d.Ecodigo
			  and o.Ocodigo = d.Ocodigo
		) as Oficina,

		coalesce(d.Doriginal, 1) as  Monto,

		coalesce(d.Dtipocambio, 1) as	 TipoCambio, 

		case when Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
		case when Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
		'#LvarFecha#' as fecha_hora,

		e.Edescripcion as Edescripcion,
		m.Miso4217 as Moneda,
        e.Edocbase as doc,
		e.Edocbase

	from EContables e
	   inner join DContables d
			inner join CFinanciera cf
			on cf.CFcuenta = d.CFcuenta
		inner join Monedas m
			on m.Mcodigo = d.Mcodigo
		on d.IDcontable = e.IDcontable
	where e.Ecodigo = #session.Ecodigo#
	 <cfif isdefined ("url.periodoIni") and isdefined ("PeriodoFin")>
		<cfif url.PeriodoIni eq url.PeriodoFin>
			and e.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
			and e.Emes    >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">
			and e.Emes    <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">
		<cfelse>
			and e.Eperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
			and e.Eperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#">
			and ((e.Eperiodo * 100 + e.Emes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">))
		</cfif>
	 </cfif>
	 <cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
	  	and (upper(ltrim(rtrim(e.ECusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.Usuario))#"> or <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Usuario#"> = '#LB_Todos#')
	 </cfif>
	  <!--- FILTROS DE FECHAS --->
	 <cfif isdefined("url.fechaini") and len(trim(url.fechaini)) and isdefined("url.fechafin") and len(trim(url.fechafin))>
		and e.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaini)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechafin)#">
	 <cfelseif isdefined("url.fechaini") and len(trim(url.fechaini)) and not isdefined("url.fechafin")>
		and e.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaini)#">
	 <cfelseif isdefined("url.fechafin") and len(trim(url.fechafin)) and not isdefined("url.fechaini")>
		and e.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechafin)#">
	 </cfif> 
	  <!--- FILTROS DE Conceptos --->
	 <cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
		and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#"> 
		and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
	 <cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
		and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#">
	 <cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))> 
		and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
	 </cfif> 
     <cfif isdefined('url.origen') and len(trim(url.origen))>
     	and e.Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Origen#">
     </cfif>
	<!--- FILTROS DE REFERENCIA Y DOCUMENTO --->         
    <cfif isdefined("url.txtref") and len(trim(url.txtref))>
    	and e.Ereferencia like '%#url.txtref#%'
    </cfif> 
    <cfif isdefined("url.txtdoc") and len(trim(url.txtdoc))>
    	and e.Edocbase like '%#url.txtdoc#%'
    </cfif> 
	 <!--- FILTROS DE ASIENTOS --->
	 <cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
		and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#"> 
		and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
	 <cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
		and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#">
	 <cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))> 
		and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
	 </cfif> 
	  <cfif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 0>
	  	order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
	  <cfelseif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 1>
	  	order by e.Cconcepto, e.Edocumento,  d.Ddocumento, d.Dlinea
	  </cfif>
</cfquery>
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo = #session.Ecodigo#
</cfquery>
<cfsetting enablecfoutputonly="no">
<cfif lcase(url.formato) NEQ 'excel'>
	<!--- INVOCA EL REPORTE --->
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
				fileName = "cg.consultas.DocumentosNoAplicados"
				headers = "title:#LB_TituloR#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "DocumentosNoAplicados.cfr" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="Edesc" value="#rsEmpresa.Edescripcion#">
			<cfreportparam name="LB_TituloR" value="#LB_TituloR#">
			<cfreportparam name="LB_Concepto" value="#LB_Concepto#">
			<cfreportparam name="LB_Documento" value="#LB_Documento#">
			<cfreportparam name="LB_Doc" value="#LB_Doc#">
			<cfreportparam name="LB_Descripcion" value="#LB_Descripcion#">
			<cfreportparam name="LB_Fecha" value="#LB_Fecha#">
			<cfreportparam name="LB_Usuario" value="#LB_Usuario#">
			<cfreportparam name="LB_Periodo" value="#LB_Periodo#">
			<cfreportparam name="LB_Mes" value="#LB_Mes#">
			<cfreportparam name="LB_Linea" value="#LB_Linea#">
			<cfreportparam name="LB_Oficina" value="#LB_Oficina#">
			<cfreportparam name="LB_Cuenta" value="#LB_Cuenta#">
			<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
			<cfreportparam name="LB_MontoOrigen" value="#LB_MontoOrigen#">
			<cfreportparam name="LB_Creditos" value="#LB_Creditos#">
			<cfreportparam name="LB_Debitos" value="#LB_Debitos#">
			<cfreportparam name="LB_TotalDocumento" value="#LB_TotalDocumento#">
			<cfreportparam name="LB_TotalConcepto" value="#LB_TotalConcepto#">
			<cfreportparam name="LB_Moneda" value="#LB_Moneda#">   
			<cfreportparam name="LB_Ref" value="#LB_Ref#">   
			<cfreportparam name="LB_anio" value="#LB_anio#"> 
			<cfreportparam name="LB_Pagina" value="#LB_Pagina#">   
			
			<cfif isdefined("url.PeriodoIni") and len(trim(url.PeriodoIni)) and url.PeriodoIni NEQ -1> 
				<cfreportparam name="PeriodoIni" value="#url.PeriodoIni#">
			<cfelse>
				<cfreportparam name="PeriodoIni" value="1900">
			</cfif>
			<cfif isdefined("url.PeriodoFin") and len(trim(url.PeriodoFin)) and url.PeriodoFin NEQ -1> 
				<cfreportparam name="PeriodoFin" value="#url.PeriodoFin#">		
			<cfelse>
				<cfreportparam name="PeriodoFin" value="6100">
			</cfif>
			<cfif isdefined("url.MesIni") and len(trim(url.MesIni)) and url.MesIni NEQ -1> 
				<cfreportparam name="MesIni" value="#url.MesIni#">		
			<cfelse>
				<cfreportparam name="MesIni" value="1">
			</cfif>
			<cfif isdefined("url.MesFin") and len(trim(url.MesFin)) and url.MesFin NEQ -1> 
				<cfreportparam name="MesFin" value="#url.MesFin#">		
			<cfelse>
				<cfreportparam name="MesFin" value="12">
			</cfif>
			<cfif isdefined("url.loteini") and len(trim(url.loteini)) and url.loteini NEQ -1> 
				<cfreportparam name="LoteIni" value="#url.loteini#">		
			<cfelse>
				<cfreportparam name="LoteIni" value="0">
			</cfif>
			<cfif isdefined("url.lotefin") and len(trim(url.lotefin)) and url.lotefin NEQ -1> 
				<cfreportparam name="LoteFin" value="#url.lotefin#">		
			<cfelse>
				<cfreportparam name="LoteFin" value="999999999999">
			</cfif>
			<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo))  and url.Oficodigo NEQ -1> 
				<cfreportparam name="OficinaOrigen" value="#url.CCTcodigo#">
			<cfelse>
				<cfreportparam name="OficinaOrigen" value="-1">
			</cfif>
			<cfif isdefined("url.Origen") and len(trim(url.Origen)) and url.Origen NEQ -1> 
				<cfreportparam name="Origen" value="%#Ucase(trim(url.Origen))#%">
			<cfelse>
				<cfreportparam name="Origen" value="-1">
			</cfif>	
			<cfif isdefined("url.Usuario") and len(trim(url.Usuario)) and url.Usuario NEQ '#LB_Todos#'> 
				<cfreportparam name="Usuario" value="#Ucase(trim(url.Usuario))#">
			<cfelse>
				<cfreportparam name="Usuario" value="#LB_Todos#">
			</cfif>	
			<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) NEQ 0> 
				<cfreportparam name="fechaini" value="#url.fechaIni#">
			</cfif>
			<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin)) NEQ 0> 
				<cfreportparam name="fechafin" value="#url.fechaFin#">
			</cfif>
		</cfreport>
	</cfif>
<cfelse>
	<cfset cantcolumnas = 10>
	<cfset Title = "#LB_Titulo#">
	<cfset FileName = "#LB_Archivo#">
	<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
	<!--- Pinta los botones de regresar, impresin y exportar a excel. --->
	<cf_htmlreportsheaders
		title="#Title#" 
		filename="#FileName#" 
		ira="ListaDocumentosEnProceso.cfm"
        method="URL">
	<cfoutput>
	<table width="100%">
		<tr><td colspan="#cantcolumnas#">&nbsp;</td></tr>
		<tr><td colspan="#cantcolumnas#" align="center"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td colspan="#cantcolumnas#">&nbsp;</td></tr>
		<tr><td colspan="#cantcolumnas#" align="center"><strong>#LB_TituloR#</strong></td></tr>
	</cfoutput>
	<cfflush interval="64">
	<cfoutput query="rsReporte" group="Concepto">
		<tr><td colspan="#cantcolumnas#">&nbsp;</td></tr>
		<tr><td colspan="#cantcolumnas#"><strong>#LB_Concepto#:  #Concepto#  #DescripcionConcepto#</strong></td></tr>
		<cfset totConceptoDebitos = 0>
		<cfset totConceptoCreditos = 0>
		<cfoutput group="Documento">
			<tr><td colspan="#cantcolumnas#">&nbsp;</td></tr>
			<tr><td colspan="10">
                    <table  bgcolor="lightgray" border="0"  width="100%">
                        <tr>
                            <td><strong>#LB_Documento#: #Documento#</strong></td>
                            <td><strong>#LB_Descripcion#: #Edescripcion#</strong></td>
                            <td><strong>#LB_Referencia#: #Ereferencia#</strong></td>
                            <td><strong>#LB_Documento#: #Edocbase#</strong></td>
                            <td><strong>#LB_Fecha#</strong></td>
                            <td><strong>#DateFormat(Fecha, "dd/mm/yyyy")#</strong></td>
                            <td><strong>#LB_Periodo#: #Periodo#</strong></td>
                            <td><strong>#LB_Mes#: #Mes#</strong></td>
                    	</tr>
                        </table>
                </td>
			</tr>
			<tr><td colspan="#cantcolumnas#">&nbsp;</td></tr>
			<tr>
				<td><strong>#LB_Linea#</strong></td>
				<td><strong>#LB_Oficina#</strong></td>
				<td><strong>#LB_Documento#</strong></td>
				<td><strong>#LB_Descripcion#</strong></td>
				<td><strong>#LB_Referencia#</strong></td>
				<td nowrap><strong>#LB_Cuenta#</strong></td>
				<td nowrap><strong>#LB_Moneda#</strong></td>
				<td nowrap align="right"><strong>#LB_MontoOrigen#</strong></td>
				<td nowrap align="right"><strong>#LB_Debitos#</strong></td>
				<td nowrap align="right"><strong>#LB_Creditos#</strong></td>
			</tr>
			<cfset totDebitos = 0>
			<cfset totCreditos = 0>
			<cfoutput>
				<tr>
					<td>#linea#</td>
					<td>#Oficina#</td>
					<td>#DDocumento#</td>
					<td>#Descripcion#</td>
					<td>#Referencia#</td>
					<td>#Cuenta#</td>
					<td nowrap>#Moneda#</td>
					<td nowrap align="right">#numberformat(Monto,",9.00")#</td>
					<td nowrap align="right">#numberformat(Debitos,",9.00")#</td>
					<td nowrap align="right">#numberformat(Creditos,",9.00")#</td>
				</tr>
				<cfset totDebitos = totDebitos + Debitos>
				<cfset totCreditos = totCreditos + Creditos>
			</cfoutput>
			<tr>
				<td colspan="#cantcolumnas - 2#"><strong>#LB_TotalDocumento# #Documento#:</strong></td>
				<td nowrap align="right"><strong>#numberformat(totDebitos,",9.00")#</strong></td>
				<td nowrap align="right"><strong>#numberformat(totCreditos,",9.00")#</strong></td>
			</tr>
			<cfset totConceptoDebitos = totConceptoDebitos + totDebitos>
			<cfset totConceptoCreditos = totConceptoCreditos + totCreditos>
		</cfoutput>
			<tr>
				<td colspan="#cantcolumnas - 2#"><strong>#LB_TotalConcepto# #Concepto#:</strong></td>
				<td nowrap align="right"><strong>#numberformat(totConceptoDebitos,",9.00")#</strong></td>
				<td nowrap align="right"><strong>#numberformat(totConceptoCreditos,",9.00")#</strong></td>
			</tr>
	</cfoutput>
	<cfoutput>
	</table>
	</cfoutput>		
</cfif>
