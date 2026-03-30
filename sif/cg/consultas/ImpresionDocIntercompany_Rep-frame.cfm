<!--- TIPO DE REPORTE TABULADO --->
<cfif isdefined("url.Formatos") and len(trim(url.Formatos)) and url.Formatos  eq 'tab'>
	<cfsavecontent variable="myQuery">
		<cfoutput>
			select distinct 
					(select Edescripcion 
					 from Empresas
					 where Ecodigo = ecd.Ecodigo)as EmpresaOri, 
					(select Edescripcion 
					 from Empresas
					 where Ecodigo = ecd.Ecodigodest)as EmpresaDest, 
					ecd.fechaasiento,
					u.Usulogin,				
					dc.Dlinea as Linea,
					(select CFformato
					 from CFinanciera
					 where Ecodigo = dc.Ecodigo
					   and CFcuenta =dc.CFcuenta) CFformato,
					ecd.fechaasiento,
					(select Oficodigo
					 from EContables ec2
					 inner join Oficinas o
						on ec2.Ecodigo = o.Ecodigo
						and ec2.Ocodigo = o.Ocodigo
					 where ec2.IDcontable = ecd.idcontableori
					) as OficinaOri, 
		
					(select Oficodigo
					 from Oficinas
					 where Ecodigo = ecd.Ecodigodest
					   and Ocodigo = dcd.Ocodigodest
					) as OficinaDest,
					dc.Dtipocambio,
					case when Dmovimiento = 'C' then Doriginal else 0.00 end as Credito,
					case when Dmovimiento = 'D' then Doriginal else 0.00 end as Debito,
					idcontableori,
					DCmonto			
			from EControlDocInt ecd
			inner join DControlDocInt dcd
				on dcd.ECid = ecd.ECid
			inner join Empresas e
				on e.Ecodigo = ecd.Ecodigo
			inner join Empresas e1
				on e1.Ecodigo = ecd.Ecodigodest
			left outer join EContables ec
				on ec.IDcontable = ecd.Idcontabledest
				<cfif isdefined("url.TipoAsiento") and len(trim(url.TipoAsiento)) GT 0 >
					and upper(ec.Oorigen)  like '%#Ucase(listgetat(url.TipoAsiento,1))#%'
				</cfif>	
			inner join DContables dc
			on dc.IDcontable = ec.IDcontable	
			left outer join EContables ec2
				on ec2.IDcontable = ecd.idcontableori
				<cfif isdefined("url.origen") and len(trim(url.origen)) GT 0 >
					and upper(ec2.Oorigen)  like "%#Ucase(listgetat(url.TipoAsiento,1))#%"
				</cfif>	
			inner join Usuario u
				on u.Usucodigo = ecd.Usucodigo			
			where ecd.Ecodigo = #url.EcodigoOri#
			  and ecd.Ecodigodest = #url.EcodigoDest#
			  and ecd.fechalta between #LSParseDateTime(url.FechaDOri)#
							and #LSParseDateTime(url.FechaHOri)#
			  and ecd.fechaaltadest between #LSParseDateTime(url.FechaDDest)#
							and #LSParseDateTime(url.FechaHDest)#
	
		</cfoutput>
	</cfsavecontent>	
	<cftry>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="data" datasource="#session.DSN#">
		<cfoutput>#myquery#</cfoutput>
		</cf_jdbcquery_open>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="DocumentosIntercompany_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
<cfelse>
	<!--- CONSULTA PARA VERIFICAR LA CANTIDAD DE REGISTROS GENERADOS --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 	count(1) as cantidad
		from EControlDocInt ecd
		inner join DControlDocInt dcd
			on dcd.ECid = ecd.ECid
		inner join Empresas e
			on e.Ecodigo = ecd.Ecodigo
		inner join Empresas e1
			on e1.Ecodigo = ecd.Ecodigodest
		inner join EContables ec
			on ec.IDcontable = ecd.Idcontabledest
			<cfif isdefined("url.TipoAsiento") and len(trim(url.TipoAsiento)) GT 0 >
				and upper(ec.Oorigen)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(listgetat(url.TipoAsiento,1))#%">
			</cfif>	
		inner join DContables dc
			on dc.IDcontable = ec.IDcontable	
		left outer join EContables ec2
			on ec2.IDcontable = ecd.idcontableori
			<cfif isdefined("url.origen") and len(trim(url.origen)) GT 0 >
				and upper(ec2.Oorigen)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(listgetat(url.TipoAsiento,1))#%">
			</cfif>	
		inner join Usuario u
			on u.Usucodigo = ecd.Usucodigo			
		where ecd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoOri#">
		  and ecd.Ecodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoDest#">
		  and ecd.fechalta between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDOri)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHOri)#">
		  and ecd.fechaaltadest between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDDest)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHDest)#">
	</cfquery>
	<!--- SI LA CANTIDAD DE REGISTRO EXCEDE 5000 ENTONCES LO INDICA --->
	<cfif rsReporte.cantidad GT 5000 and isdefined("url.formato") and url.formato neq 'tab'>
		<br><br>
			<div align="center"> Se genero un reporte de más de 5,000 Registros. <br></div> 
			<div align="center">Registros Generados: <cfoutput>#LSnumberformat(rsReporte.cantidad, '_,')#</cfoutput>. </div> 
		<br /><br />
			<div align="center"> Debe ser más específico con los filtros del reporte. <br /></div> 
		<br />
			<div align="center"><a href="javascript:parent.document.location.href='ImpresionDocIntercompany.cfm';">Regresar</a></div> 
		<cfabort>
	<!--- SI LA CANTIDAD DE REGISTRO ES CERO ENTONCES LO INDICA --->
	<cfelseif rsReporte.cantidad EQ 0 >
		<br><br>
 		   <div align="center">No se generaron registros para mostrar en el reporte. </div> 
 		<br>
		  <div align="center"> <a href="javascript:parent.document.location.href='ImpresionDocIntercompany.cfm';">Regresar</a></div>
		<cfabort>
	</cfif>
	<!--- SI LA CANTIDAD NO EXCEDE LOS 5000 ENTONCES EJECUTA LA CONSULTA PARA EL REPORTE --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select distinct 
			(select Edescripcion 
			 from Empresas
			 where Ecodigo = ecd.Ecodigo)as EmpresaOri, 
			(select Edescripcion 
			 from Empresas
			 where Ecodigo = ecd.Ecodigodest)as EmpresaDest, 
			ecd.fechaasiento,
			u.Usulogin,				
			dc.Dlinea as Linea,
			(select CFformato
			 from CFinanciera
			 where Ecodigo = dc.Ecodigo
			   and CFcuenta =dc.CFcuenta) CFformato,
			ecd.fechaasiento,
			(select Oficodigo
			 from EContables ec2
			 inner join Oficinas o
				on ec2.Ecodigo = o.Ecodigo
				and ec2.Ocodigo = o.Ocodigo
			 where ec2.IDcontable = ecd.idcontableori
			) as OficinaOri, 

			(select Oficodigo
			 from Oficinas
			 where Ecodigo = ecd.Ecodigodest
			   and Ocodigo = dcd.Ocodigodest
			) as OficinaDest,
			dc.Dtipocambio,
			case when Dmovimiento = 'C' then Dlocal else 0.00 end as Credito,
			case when Dmovimiento = 'D' then Dlocal else 0.00 end as Debito,
			idcontableori,
			DCmonto
		from EControlDocInt ecd
		inner join DControlDocInt dcd
			on dcd.ECid = ecd.ECid
		left outer join EContables ec
			on ec.IDcontable = ecd.Idcontabledest
			<cfif isdefined("url.TipoAsiento") and len(trim(url.TipoAsiento)) GT 0 >
				and upper(ec.Oorigen)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(listgetat(url.TipoAsiento,1))#%">
			</cfif>		
		inner join DContables dc
			on dc.IDcontable = ec.IDcontable
		left outer join EContables ec2
			on ec2.IDcontable = ecd.idcontableori
			<cfif isdefined("url.origen") and len(trim(url.origen)) GT 0 >
				and upper(ec2.Oorigen)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(listgetat(url.TipoAsiento,1))#%">
			</cfif>	
		inner join Usuario u
			on u.Usucodigo = ecd.Usucodigo			
		where ecd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoOri#">
		  and ecd.Ecodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoDest#">
		  and ecd.fechalta between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDOri)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHOri)#">
		  and ecd.fechaaltadest between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDDest)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHDest)#">
		order by idcontableori
	</cfquery>
	<!---Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = #session.Ecodigo#
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
				fileName = "cg.consultas.ImpresionDocIntercompany"
				headers = "Empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>
		<cfreport format="#formatos#" template="ImpresionDocIntercompany.cfr" query="rsReporte">
			<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
				<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
			</cfif>
		</cfreport>
	</cfif>
</cfif>

