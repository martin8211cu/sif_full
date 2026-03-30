
<cfset navegacion = '?pagenum_lista=#url.pageNum_lista#' >
<!--- filtro fecha --->
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<cfset navegacion = navegacion & '&filtro_fecha=#url.filtro_fecha#' >
</cfif>

<!--- filtro concepto --->
<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	<cfset navegacion = navegacion & '&filtro_CIid=#url.filtro_CIid#' >
</cfif>

<!--- filtro empleado --->
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset navegacion = navegacion & '&DEid=#url.DEid#' >
</cfif>
<!--- filtro empleado --->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	<cfset navegacion = navegacion & '&CFpk=#url.CFpk#' >
</cfif>
<!--- filtro centro funcional  --->
<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
	<cfset navegacion = navegacion & '&dependencias=#url.dependencias#' >
</cfif>

<!--- filtro de estado --->	
<cfif isdefined("url.filtro_estado")>
	<cfset navegacion = navegacion & '&filtro_estado=#url.filtro_estado#' >
</cfif>


<cfif isdefined("url.btnAprobar") and isdefined("url.chk")>
<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	<!--- revisar bien este proceso, falta la integracion con presupuesto --->
	<cfset consecutivo = 1 >
	<cfquery name="rs_consecutivo" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 1020
	</cfquery>
	<cfif len(trim(rs_consecutivo.Pvalor)) and isnumeric(rs_consecutivo.Pvalor) >
		<cfset consecutivo = rs_consecutivo.Pvalor + 1 >
	</cfif>
	
	<!--- empresa usa presupuesto --->
	<cfset usaPresupuesto = false >
	<cfquery name="rs_pres" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 540
	</cfquery>
	<cfif trim(rs_pres.Pvalor) eq 1 >
		<cfset usaPresupuesto = true >
	</cfif>

	<cftransaction>
	
	<!--- hace la parte presupuestaria solo si parametro 540 (usa de presupuesto) esta activo--->
	<cfif usaPresupuesto >
		<!--- recupera la mascara del centro funcional --->
		<!--- *** revisar esto *** --->
		<!--- se comenta este codigo para uso en Coopelesca, donde la parte presupuestaria no interesa --->
		<cfquery datasource="#session.DSN#">
			update Incidencias
			set CFormato = ( 	select min(cf.CFcuentac)
								from CFuncional cf, RHPlazas p, LineaTiempo lt
								where p.CFid=cf.CFid
								and lt.RHPid=p.RHPid
								and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
								and lt.DEid = Incidencias.DEid ),
				complemento = ( select min(CIcuentac)
								from CIncidentes
								where CIid=Incidencias.CIid )
			where Iid in (#url.chk#) 
		</cfquery>
	
		<!--- aplicar mascara--->
		<!--- ************************************************************************************************************** --->
		<!--- instancia componente de aplicacion de mascara --->
		<cfobject component="sif.Componentes.AplicarMascara" name="mascara">	

		<!--- valida la existencia de la funcion CGAplicarMascara2 --->
		<cfset existe_aplicarmascara = true >
		<cftry>
			<cfquery datasource="#arguments.conexion#">
				select <cfif Application.dsinfo[session.DSN].type is 'sqlserver'>dbo.</cfif>CGAplicarMascara2(Edescripcion, 'abc', '?')
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			<cfcatch type="any">
				<cfset existe_aplicarmascara = false >
			</cfcatch>
		</cftry>
		<!--- a esta primer parte del if deberia entrar si es ORACLE y si NO existe la funcion CGAplicarMascara2 --->
		<!--- esta funcion no la hemos definido en oracle por lo que deberia entrar aqui siempre ke el dsn sea oracle --->
		<cfif not existe_aplicarmascara >
			<cfquery name="rs_incidencias" datasource="#session.DSN#">
				select Iid, CFormato, complemento
				from Incidencias
				where Iid in (#url.chk#)
				  and (<cf_dbfunction name="findOneOf" args="CFormato, ?!*"> and rtrim(ltrim(CFormato)) is not null)			
			</cfquery>
			<cfloop query="rs_incidencias">
				<cfset vFormato = mascara.AplicarMascara(rs_incidencias.CFormato,rs_incidencias.complemento)>
				<cfset vFormato = mascara.AplicarMascara(vFormato,rs_incidencias.complemento, '*')>
				<cfset vFormato = mascara.AplicarMascara(vFormato,rs_incidencias.complemento, '!')>
				<cfquery datasource="#session.DSN#">
					update Incidencias 
					set CFormato =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#vFormato#">
					where Iid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_incidencias.Iid#">
				</cfquery>
			</cfloop>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update Incidencias
				set CFormato = 	<cfif Application.dsinfo[session.DSN].type is 'sqlserver'>dbo.</cfif>CGAplicarMascara2(CFormato, complemento, '*')
				where Iid in (#url.chk#) 		
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update Incidencias
				set CFormato = 	<cfif Application.dsinfo[session.DSN].type is 'sqlserver'>dbo.</cfif>CGAplicarMascara2(CFormato, complemento, '?')
				where Iid in (#url.chk#) 		
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update Incidencias
				set CFormato = 	<cfif Application.dsinfo[session.DSN].type is 'sqlserver'>dbo.</cfif>CGAplicarMascara2(CFormato, complemento, '!')
				where Iid in (#url.chk#) 		
			</cfquery>	
		</cfif>
		
		<!--- calcula la cuenta financiera segun formato --->
		<cfquery datasource="#session.DSN#">
			update Incidencias
			set CFcuenta = (  	select min(CFcuenta) 
								from CFinanciera
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and CFformato = Incidencias.CFormato )
			where Iid in (#url.chk#)
		</cfquery>
	</cfif>		

	<cfset vNAP = randrange(1, 100000) >
	<cfquery datasource="#session.DSN#">
		update Incidencias
		set Iestado = 1,
			Iusuaprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			Ifechaaprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			Inumdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">,
			NRP = null,
			NAP = #vNAP#	<!--- puesto a dedo para simular aprobacion de presupuesto, esto debe quitarse  --->
		where Iid in (#url.chk#) 
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update RHParametros
		set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consecutivo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 1020
	</cfquery>

	</cftransaction>

<cfelseif isdefined("url.btnRechazar") and isdefined("url.chk")>
<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	<cfquery datasource="#session.DSN#">
		update Incidencias
		set Iestado = 2,
			NAP = null,
			NRP = null,
			CFormato = null,
			complemento = null,
			CFcuenta = null,
			Iusuaprobacion = null,
			Ifechaaprobacion = null,
			Inumdocumento = null
		where Iid in (#url.chk#) 
	</cfquery>

</cfif>

<cflocation url="aprobarIncidencias.cfm#navegacion#">