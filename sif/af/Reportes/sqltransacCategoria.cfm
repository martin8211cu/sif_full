<cfparam name="url.formato" default="pdf"><!--- flashpaper, pdf --->

<!--- Tabla Temporal con los datos del reporte sin agrupar --->	
<cf_dbtemp name="tmpREPORTECAT" returnvariable="tmpREPORTECAT" datasource="#session.dsn#">
	<cf_dbtempcol name="ACcodigodesc" type="varchar(10)" mandatory="yes">
	<cf_dbtempcol name="ACdescripcion" type="varchar(60)" mandatory="yes">
	<cf_dbtempcol name="AFSvaladq" type="money" mandatory="yes">
	<cf_dbtempcol name="AFSvalrev" type="money" mandatory="yes">
	<cf_dbtempcol name="AFSdepacumadq" type="money" mandatory="yes">
	<cf_dbtempcol name="AFSdepacumrev" type="money" mandatory="yes">
	<cf_dbtempcol name="AFSvallibros" type="money" mandatory="yes">
	<cf_dbtempcol name="AFSdepacumadqmes" type="money" mandatory="yes">
	<cf_dbtempcol name="AFSdepacumrevmes" type="money" mandatory="yes">
</cf_dbtemp>

<!--- Se le quito que el excel entre aqui 
<cfif url.formato eq "txt" or url.formato eq "excel1">--->
<cfif url.formato eq "txt">
	
	<cf_errorCode	code = "50114" msg = "Por el momento no es posible generar el reporte como archivo TXT. Por favor intente en cualquiera de los otros formatos disponibles.">

	<cfquery datasource="#session.dsn#" maxrows="3001">
		INSERT into  #tmpREPORTECAT#(	ACcodigodesc, 
					ACdescripcion, 
					AFSvaladq, 
					AFSvalrev, 
					AFSdepacumadq, 
					AFSdepacumrev, 
					AFSvallibros, 
					AFSdepacumadqmes, 		
					AFSdepacumrevmes)
		select 
			ACcodigodesc, 
			ACdescripcion, 
			(AFSvaladq + AFSvalmej) as ValorAdq, 
			(AFSvalrev) as ValorRev, 
			(AFSdepacumadq+AFSdepacummej) as DepreAcumuladaAdq, 
			(AFSdepacumrev) as DepreAcumuladaRev, 
			((AFSvaladq + AFSvalmej + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) as ValorLibros, 
			((coalesce(AFSdepacumadq+AFSdepacummej,0.0000) - 
			coalesce(( select AFSdepacumadq + AFSdepacummej 			
						from AFSaldos xx 
						where xx.Ecodigo = x.Ecodigo 
						and xx.Aid = x.Aid 
						and xx.AFSperiodo = case when x.AFSmes > 1 then x.AFSperiodo else x.AFSperiodo - 1 end 
						and xx.AFSmes = case when x.AFSmes > 1 then x.AFSmes - 1 else 12 end
						),0.0000))) as DepreAcumAdqMes, 
			((coalesce(AFSdepacumrev,0.0000) - 
			coalesce(( select AFSdepacumrev 
						from AFSaldos xx 
						where xx.Ecodigo = x.Ecodigo 
						and xx.Aid = x.Aid and xx.AFSperiodo = 
										case when x.AFSmes > 1 
										then x.AFSperiodo else x.AFSperiodo - 1 end 
								and xx.AFSmes = case when x.AFSmes > 1 then x.AFSmes - 1 else 12 end
						),0.0000))) as DepreAcumRevMes
		from AFSaldos x
			inner join ACategoria y <cf_dbforceindex name="PK_ACATEGORIA">
				on y.Ecodigo = x.Ecodigo
				and y.ACcodigo = x.ACcodigo
			inner join Activos a
				on a.Ecodigo = x.Ecodigo
				and a.Aid = x.Aid
				                
		where x.Ecodigo = #session.Ecodigo#
		and AFSperiodo = #url.Periodo#
		and AFSmes = #url.Mes#
		and upper(ltrim(rtrim(ACcodigodesc))) between '#ucase(trim(ACcodigodescdesde))#'
		and '#ucase(trim(ACcodigodeschasta))#'
        and (x.AFSvaladq > 0.00  
        	or x.AFSvalmej > 0.00 
            or x.AFSvalrev > 0.00 
            or x.AFSdepacumadq > 0.00 
            or x.AFSdepacummej > 0.00 
            or x.AFSdepacumrev > 0.00)
	</cfquery>
	
	<cfsavecontent variable="myQuery">
		<cfoutput>
		select 
			ACcodigodesc as CodigoCat, 
			ACdescripcion as DescripcionCat, 
			sum(AFSvaladq) as ValorAdq, 
			sum(AFSvalrev) as ValorRev, 
			sum(AFSdepacumadq) as DepreAcumuladaAdq, 
			sum(AFSdepacumrev) as DepreAcumuladaRev, 
			sum(AFSvallibros) as ValorLibros, 
			sum(AFSdepacumadqmes) as DepreAcumAdqMes, 
			sum(AFSdepacumrevmes) as DepreAcumRevMes
		from #tmpREPORTECAT#
		group by ACcodigodesc, ACdescripcion
		order by ACcodigodesc
		</cfoutput>
	</cfsavecontent>
	
	<cftry>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="rsReporte" datasource="#session.DSN#">
		<cfoutput>#myquery#</cfoutput>
		</cf_jdbcquery_open>

	<cfif isdefined("url.Formato") and url.Formato eq "txt">
		<cf_exportQueryToFile query="#rsReporte#" separador="#chr(9)#" filename="TransacXCat_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	<cfelseif isdefined("url.Formato") and url.Formato eq "excel">
		<cf_exportQueryToFile query="#rsReporte#" filename="Adquisicion#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
	</cfif>
	
		 <cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		 </cfcatch>
	</cftry>
		
<cfelse>

	<cfquery datasource="#session.dsn#" maxrows="3001">
		INSERT into #tmpREPORTECAT#(	ACcodigodesc, 
					ACdescripcion, 
					AFSvaladq, 
					AFSvalrev, 
					AFSdepacumadq, 
					AFSdepacumrev, 
					AFSvallibros, 
					AFSdepacumadqmes, 		
					AFSdepacumrevmes)
		select 
			ACcodigodesc, 
			ACdescripcion, 
			(AFSvaladq + AFSvalmej) as AFSvaladq, 
			(AFSvalrev) as AFSvalrev, 
			(AFSdepacumadq+AFSdepacummej) as AFSdepacumadq, 
			(AFSdepacumrev) as AFSdepacumrev, 
			((AFSvaladq + AFSvalmej + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) as AFSvallibros, 
			((coalesce(AFSdepacumadq+AFSdepacummej,0.0000) - coalesce(( 	select AFSdepacumadq + AFSdepacummej 
											from AFSaldos xx 
											where xx.Ecodigo = x.Ecodigo 
								 			  and xx.Aid = x.Aid 
											  and xx.AFSperiodo = case when x.AFSmes > 1 then x.AFSperiodo else x.AFSperiodo - 1 end 
											  and xx.AFSmes = case when x.AFSmes > 1 then x.AFSmes - 1 else 12 end
										),0.0000))) as AFSdepacumadqmes, 

			((coalesce(AFSdepacumrev,0.0000) - coalesce(( 	select AFSdepacumrev 
									from AFSaldos xx 
									where xx.Ecodigo = x.Ecodigo 
									  and xx.Aid = x.Aid 
									  and xx.AFSperiodo = case when x.AFSmes > 1 then x.AFSperiodo else x.AFSperiodo - 1 end 
									  and xx.AFSmes = case when x.AFSmes > 1 then x.AFSmes - 1 else 12 end	
								   ),0.0000))) as AFSdepacumrevmes

		from AFSaldos x
			inner join ACategoria y <cf_dbforceindex name="PK_ACATEGORIA">
			on y.Ecodigo = x.Ecodigo
			and y.ACcodigo = x.ACcodigo
			inner join Activos a
			on a.Ecodigo = x.Ecodigo
			and a.Aid = x.Aid
			
		where x.Ecodigo = #session.Ecodigo#
		and AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
		and AFSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mes#">
		and upper(ltrim(rtrim(ACcodigodesc))) between '#ucase(trim(ACcodigodescdesde))#'
		and '#ucase(trim(ACcodigodeschasta))#'
        and (x.AFSvaladq > 0.00  
        	or x.AFSvalmej > 0.00 
            or x.AFSvalrev > 0.00 
            or x.AFSdepacumadq > 0.00 
            or x.AFSdepacummej > 0.00 
            or x.AFSdepacumrev > 0.00)
	</cfquery>

	<cfquery name="rsReporte" datasource="#session.dsn#" maxrows="3001">
	Select	ACcodigodesc, 
		ACdescripcion, 		
		sum(AFSvaladq) as AFSvaladq, 
		sum(AFSvalrev) as AFSvalrev, 
		sum(AFSdepacumadq) as AFSdepacumadq, 
		sum(AFSdepacumrev) as AFSdepacumrev, 
		sum(AFSvallibros) as AFSvallibros, 
		sum(AFSdepacumadqmes) as AFSdepacumadqmes, 		
		sum(AFSdepacumrevmes) as AFSdepacumrevmes
	from #tmpREPORTECAT#
	group by ACcodigodesc, ACdescripcion
	order by ACcodigodesc 
	</cfquery>
	<cfquery name="rsUsuario" datasource="asp">
		select 
			({fn concat({fn concat (dp.Pnombre, {fn concat(' ', dp.Papellido1)} )}, {fn concat(' ', dp.Papellido2)})}) as Usuario
		from Usuario u
			inner join DatosPersonales dp
			on dp.datos_personales = u.datos_personales
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	</cfquery>
	<cfif rsReporte.recordcount GT 3000>
		<cf_errorCode	code = "50115" msg = "La cantidad de activos a desplegar sobrepasa los 3000 registros. Reduzca los rangos en los filtros ó exporte a archivo. ">
		<cfabort>
	</cfif>
	
	<cfquery name="rsMes" datasource="#session.dsn#">
		select VSdesc as Mes
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSgrupo = 1
			and <cf_dbfunction name="to_number" args="b.VSvalor"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Mes#">
		where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
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
		typeReport = #typeRep#
		fileName = "af.consultas.transacCategoria"
		headers = "empresa:#Session.Enombre#"/>
	<cfelse>
	<cfreport format="#url.formato#" template= "transacCategoria.cfr" query="rsReporte">
		<cfreportparam name="Empresa" value="#session.Enombre#">
		<cfreportparam name="Usuario" value="#rsUsuario.Usuario#">
		<cfreportparam name="Periodo" value="#url.Periodo#">
		<cfreportparam name="Mes" value="#rsMes.Mes#">
	</cfreport>
	</cfif>
</cfif>

