<cffunction name="querysRep"  access="public" output="true" returntype="query">
	<cfargument name='tipoRep' type='numeric' required='true'>
	<cfset repPermitido = true>

	<!--- depreciacionMesCF o depreciacionMesCC --->
	<cfif Arguments.tipoRep NEQ "" and (Arguments.tipoRep EQ 1 or Arguments.tipoRep EQ 2)>
		<cfquery name="rsCantRgs" datasource="#session.DSN#">
			select count(1) as cantRegs
			from Activos a 
				inner join TransaccionesActivos b 
					on b.Ecodigo = a.Ecodigo 
					and b.Aid = a.Aid
					<cfif isdefined("form.FCentroF") and form.FCentroF NEQ ''>
						and (b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#"> or 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#"> = 0)
					</cfif>
					and b.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
					and b.TAmes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
					and b.IDtrans = 4
			
				inner join ACategoria cat 
					on cat.Ecodigo = a.Ecodigo  and cat.ACcodigo = a.ACcodigo
					<cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) neq 0>
						and (cat.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> or 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> = 0)
					</cfif>
			
				inner join AClasificacion cla 
					on cla.Ecodigo = a.Ecodigo  
					and cla.ACcodigo = a.ACcodigo 
					and cla.ACid = a.ACid
					<cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) neq 0>
						and (cla.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> or 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> = 0)
					</cfif>				
					<cfif isdefined("form.ACid") and len(trim(form.ACid)) neq 0>
						and (cla.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#"> or 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#"> = 0)
					</cfif>					
					
				inner join Empresas c
					on c.Ecodigo=a.Ecodigo
			
				inner join CFuncional cf
					on cf.Ecodigo=a.Ecodigo
					and cf.CFid=b.CFid
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
		</cfquery>

		<cfif isdefined('rsCantRgs') and rsCantRgs.cantRegs LTE 10000>
			<cfquery name="rsReporte" datasource="#session.DSN#">
				select 
					rtrim(ltrim(cat.ACdescripcion)) AS ACdescripcion
					, rtrim(ltrim(cla.ACdescripcion)) as clasedescripcion
					, b.CFid
					, round(TAmontolocadq,2) as AFSdepacumadq
					, TAmontolocmej as AFSdepacummej
					, b.TAmontolocrev as AFSdepacumrev            
					, rtrim(cf.CFcodigo) as CFcodigo
					, cf.CFdescripcion
					, c.Edescripcion as Edescripcion
					, a.Aplaca 
					, a.Afechainidep
					, substring(a.Adescripcion,1,30) as Adescripcion
					, rtrim(cla.ACcodigodesc) as ACcodigodesc
					, rtrim(cat.ACcodigodesc) as categoria
					, cat.ACcodigo
					, cla.ACid
				from Activos a 
					inner join TransaccionesActivos b 
						on b.Ecodigo = a.Ecodigo 
						and b.Aid = a.Aid
						<cfif isdefined("form.FCentroF") and form.FCentroF NEQ ''>
							and (b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#"> or 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#"> = 0)
						</cfif>
						and b.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
						and b.TAmes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
						and b.IDtrans = 4
				
					inner join ACategoria cat 
						on cat.Ecodigo = a.Ecodigo  and cat.ACcodigo = a.ACcodigo
						<cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) neq 0>
							and (cat.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> or 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> = 0)
						</cfif>
				
					inner join AClasificacion cla 
						on cla.Ecodigo = a.Ecodigo  
						and cla.ACcodigo = a.ACcodigo 
						and cla.ACid = a.ACid
						<cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) neq 0>
							and (cla.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> or 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> = 0)
						</cfif>				
						<cfif isdefined("form.ACid") and len(trim(form.ACid)) neq 0>
							and (cla.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#"> or 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#"> = 0)
						</cfif>					
						
					inner join Empresas c
						on c.Ecodigo=a.Ecodigo
				
					inner join CFuncional cf
						on cf.Ecodigo=a.Ecodigo
						and cf.CFid=b.CFid
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				order by 
				<!--- depreciacionMesCF --->
				<cfif Arguments.tipoRep EQ 1>
					cat.ACcodigo,cla.ACid,b.CFid
					<!--- depreciacionMesCC --->
				<cfelseif Arguments.tipoRep EQ 2>
					b.CFid,cla.ACid,cat.ACcodigo
				</cfif>
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50052" msg = "Su consulta posee demaciados registros, por favor defina de nuevo los filtros y vuelva a intentarlo.">
			<cfabort>
		</cfif>
	<!--- depreciacionMesCFres y depreciacionMesCCres--->
	<cfelseif Arguments.tipoRep NEQ "" and (Arguments.tipoRep EQ 3 or Arguments.tipoRep EQ 4)>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select 	 e.CFid
			, rtrim(e.CFcodigo) as CFcodigo
			, e.CFdescripcion 
            , d.ACcodigodesc
			, d.ACdescripcion
			, c.ACcodigodesc as categoria 
            , c.ACdescripcion as clasedescripcion 
            , sum(round(a.TAmontolocadq,2)) as AFSdepacumadq
			, sum(round(TAmontolocmej,2)) as AFSdepacummej 
            , sum(round(a.TAmontolocrev,2)) as AFSdepacumrev 
			from TransaccionesActivos a
				inner join Activos b
					on b.Aid = a.Aid
					and b.Ecodigo = a.Ecodigo
					<cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) neq 0>
						and (b.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> or 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#"> = 0)
					</cfif>
					<cfif isdefined("form.ACid") and len(trim(form.ACid)) neq 0>
						and (b.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#"> or 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#"> = 0)
					</cfif>
				inner join AClasificacion c
					on c.ACid = b.ACid
					and c.Ecodigo = b.Ecodigo
				inner join ACategoria d
					on d.ACcodigo = b.ACcodigo
					and d.Ecodigo = b.Ecodigo
				inner join CFuncional e
					on e.CFid = a.CFid
					and e.Ecodigo = a.Ecodigo
				inner join Empresas f
					on f.Ecodigo = a.Ecodigo
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.IDtrans = 4 
				<cfif isdefined("form.FCentroF") and form.FCentroF NEQ ''>
					and (a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#"> or 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#"> = 0)
				</cfif>
				and a.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
				and a.TAmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
			group by 
				<!--- depreciacionMesCFres --->
				<cfif Arguments.tipoRep EQ 3>
					e.CFid
					, rtrim(e.CFcodigo)
					, e.CFdescripcion
					, d.ACcodigodesc
					, d.ACdescripcion
					, c.ACcodigodesc
					, c.ACdescripcion
					<!--- depreciacionMesCCres --->
				<cfelseif Arguments.tipoRep EQ 4>
					 d.ACcodigodesc
					, d.ACdescripcion
					, c.ACcodigodesc
					, c.ACdescripcion
					, e.CFid
					, rtrim(e.CFcodigo)
					, e.CFdescripcion
				</cfif>			
		</cfquery>
	</cfif>	
	
	<cfreturn #rsReporte#>
</cffunction>

<cfset nombreReporteJR = "">
<cfif isdefined('form.Reporte')>
	<cfset nombRep = "">
	<cfif isdefined("form.cf") and form.cf EQ 1>
		<cfset nombRep = "depreciacionMesCF.cfr">
		<cfset nombreReporteJR = "depreciacionMesCF">
		<cfset rsRep = querysRep(1)>
	<cfelseif  isdefined("form.cf") and form.cf EQ 2>
		<cfset nombRep = "depreciacionMesCC.cfr">
		<cfset nombreReporteJR = "depreciacionMesCC">
		<cfset rsRep = querysRep(2)>
	<cfelseif  isdefined("form.cf") and form.cf EQ 3>
		<cfset nombRep = "depreciacionMesCFres.cfr">
		<cfset nombreReporteJR = "depreciacionMesCFres">
		<cfset rsRep = querysRep(3)>		
	<cfelseif  isdefined("form.cf") and form.cf EQ 4>
		<cfset nombRep = "depreciacionMesCCres.cfr">
		<cfset nombreReporteJR = "depreciacionMesCCres">
		<cfset rsRep = querysRep(4)>		
	</cfif>
	
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		and a.Iid = b.Iid
		and <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> = #form.mes#
		
	</cfquery>
	<cfif isdefined("rsMeses") and rsMeses.RecordCount neq 0>
		<cfset form.nombreMes = rsMeses.Pdescripcion>
	<cfelse>
		<cfset form.nombreMes = 'No definido'>
	</cfif>
	
	<!--- INVOCA EL REPORTE --->
	<cfif isdefined('rsRep') and rsRep.recordCount GT 0>
		<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif form.formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsRep#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "af.consultas.#nombreReporteJR#"/>
	<cfelse>
		<cfreport format="#form.formato#" template= "#nombRep#" query="rsRep">
			<cfreportparam name="Periodo" value="#form.Periodo#">
			<cfreportparam name="nombMes" value="#form.nombreMes#">
		</cfreport>	
		</cfif>
	<cfelse>
		<table width="70%"  border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr><td>&nbsp;</td></tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr><td align="center"><strong>**** No se encontr&oacute; informaci&oacute;n para el reporte **** </strong></td></tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr><td align="center"><input name="Regresar" type="button" onClick="javascript: regresar();" value="Regresar"></td></tr>			  
		</table>
	</cfif>
</cfif>


<script language="javascript" type="text/javascript">
	function regresar(){
		document.href=history.back();
		return false;
	}
</script>

