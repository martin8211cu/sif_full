<!--- 
	Modificado por : Rodolfo Jimenez Jara
	Fecha: 10 de Noviembre de 2005
	Motivo: Creacion del reporte con filtros de 
	
	Modificado por : Rodolfo Jimenez Jara
	Fecha: 14 de Noviembre de 2005
	Motivo: Si solo se digito el CFcodigo y se da el botn Generar, hace mal la consulta,
	        se agreg el siguiente cdigo para buscar el CFid, si el usuario digit el CFcodigo y le di ENTER
			se debe buscar el CFid, al tag no le dio tiempo y no hace bien la consulta, lo mimos.
 --->
<!--- cfquery --->
<cfif isdefined("form.CFcodigo") and not isdefined("form.CFdescripcion")>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFid , CFdescripcion
		from CFuncional
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigo#">
	</cfquery>
	<cfif isdefined("rsCFuncional") and rsCFuncional.RecordCount NEQ 0>
		<cfset VarCFid = rsCFuncional.CFid>
	</cfif>
<cfelseif isdefined("form.CFid") and len(trim(form.CFid)) and isdefined("form.CFdescripcion")>
	<cfset VarCFid = form.CFid>
</cfif>

<!--- RHMPPid,RHMPPcodigo,RHMPPdescripcion --->
<cfif isdefined("form.RHMPPcodigo") and isdefined("form.RHMPPdescripcion") and len(trim(form.RHMPPdescripcion)) eq 0>
	<cfquery name="rsRHMaestroPuestoP" datasource="#session.DSN#">
		select RHMPPid,RHMPPcodigo,RHMPPdescripcion
		from RHMaestroPuestoP
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHMPPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHMPPcodigo#">
	</cfquery>
	<cfif isdefined("rsRHMaestroPuestoP") and rsRHMaestroPuestoP.RecordCount NEQ 0>
		<cfset VarRHMPPid = rsRHMaestroPuestoP.RHMPPid>
	</cfif>
	
<cfelseif isdefined("form.RHMPPid") and len(trim(form.RHMPPid)) and isdefined("form.RHMPPdescripcion")>
	<cfset VarRHMPPid= form.RHMPPid>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 	RHSPconsecutivo,
			mp.RHMPPcodigo,
			mp.RHMPPdescripcion,
			sp.RHPcodigo, 
			p.RHPdescpuesto,
			(Pnombre #LvarCNCT# ' ' #LvarCNCT# Papellido1 #LvarCNCT# ' ' #LvarCNCT# Papellido2) as nombreSol, 
			m.Miso4217 as Mcodigo, 
			salarioref, 
			salariomax, 
			Observaciones, 
			RHSPestado,
			ltrim(rtrim(cf.CFcodigo)) as CFcodigo, 
			RHSPcantidad, 
			coalesce(ltrim(rtrim(mp.RHMPPcodigo))  #LvarCNCT# ' - ' #LvarCNCT# ltrim(rtrim(mp.RHMPPdescripcion)),' --- ')  as PuestoPres, 
			sp.RHSPfdesde, 
			case sp.RHSPfhasta	when '61000101' then 'Indefinido'
								else convert(varchar,sp.RHSPfhasta,103)
			end as RHSPfhasta,			
			sp.CFid,
			ltrim(rtrim(cf.CFdescripcion)) as CFdescripcion, 
			coalesce(ltrim(rtrim(RHTTdescripcion)),' --- ')  as TablaSal, 
			coalesce(ltrim(rtrim(RHCdescripcion)),' --- ')   as RHCategoria, 
			coalesce(ltrim(rtrim(p.RHPcodigo)) #LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(p.RHPdescpuesto)), ' --- ')  as PuestoRH,
			sp.saldo
		
		from RHSolicitudPlaza sp
			inner join CFuncional cf
				on cf.Ecodigo=sp.Ecodigo
				and cf.CFid=sp.CFid
			
			left outer join RHMaestroPuestoP mp
				on mp.RHMPPid=sp.RHMPPid
				and mp.Ecodigo=sp.Ecodigo
	
			left outer join RHPuestos p
				on p.RHPcodigo=sp.RHPcodigo
				and p.Ecodigo=sp.Ecodigo
	
			inner join Monedas m
				on sp.Mcodigo = m.Mcodigo
	
			inner join Usuario u
				on u.Usucodigo=sp.BMUsucodigo
	
				left outer join DatosPersonales dp
					on dp.datos_personales = u.datos_personales
	
			left outer join RHTTablaSalarial ts
				on sp.RHTTid  = ts.RHTTid 
	
				inner join RHCategoria rhc
				on sp.RHCid = rhc.RHCid
	
	where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined ("VarCFid")and len(trim(VarCFid))>
	 		and sp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VarCFid#">
		</cfif>		
		<cfif isdefined ("form.Usucodigo") and len(trim(form.Usucodigo))>
			and sp.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfif>
		<cfif isdefined ("VarRHMPPid") and len(trim(VarRHMPPid))>
	  		and sp.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VarRHMPPid#"> 
	 	</cfif>
		
		<!----Filtro de no.solicitud---->
		<cfif isdefined("form.RHSPconsecutivo_desde") and len(trim(form.RHSPconsecutivo_desde)) and (isdefined("form.RHSPconsecutivo_hasta") and len(trim(form.RHSPconsecutivo_hasta))) >
			<cfif form.RHSPconsecutivo_desde  GT form.RHSPconsecutivo_hasta>
				and sp.RHSPconsecutivo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_hasta#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
			<cfelseif form.RHSPconsecutivo_desde EQ form.RHSPconsecutivo_hasta>
				and sp.RHSPconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
			<cfelse>
				and sp.RHSPconsecutivo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_hasta#">
			</cfif>
		<cfelseif isdefined("form.RHSPconsecutivo_desde") and len(trim(form.RHSPconsecutivo_desde)) and (not isdefined("form.RHSPconsecutivo_hasta") or len(trim(form.RHSPconsecutivo_hasta)) EQ 0) >
			and sp.RHSPconsecutivo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
		<cfelseif isdefined("form.RHSPconsecutivo_hasta") and len(trim(form.RHSPconsecutivo_hasta)) and (not isdefined("form.RHSPconsecutivo_desde") or len(trim(form.RHSPconsecutivo_desde)) EQ 0) >
			and sp.RHSPconsecutivo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_hasta#">
		</cfif>	
		
		<!---Filtro de las fechas ----->
		<cfif isdefined("Form.fdesde") and len(trim(Form.fdesde)) and isdefined("Form.fhasta") and len(trim(Form.fhasta))>
			<cfif form.fdesde EQ form.fhasta>
				and sp.RHSPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fdesde)#">
			<cfelse>
				and sp.RHSPfdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fdesde)#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fhasta)#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.fdesde") and len(trim(Form.fdesde)) and not ( isdefined("Form.fhasta") and len(trim(Form.fhasta)) )>
			and sp.RHSPfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fdesde)#">
		</cfif>
		
		<cfif isdefined("Form.fhasta") and len(trim(Form.fhasta)) and not ( isdefined("Form.fdesde") and len(trim(Form.fdesde)) )>
			and sp.RHSPfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fhasta)#">
		</cfif>
			
	order by sp.CFid, Pnombre, Papellido1, Papellido2, RHSPconsecutivo
</cfquery>

<cfif rsReporte.recordcount GT 1500>
	<br>
	<br>
	Se genero un reporte ms grande de lo permitido.  Se abort el proceso
	<br>
	<br>
	<cfabort>
</cfif>

<!--- Define cual reporte va a llamar --->
<cfset archivo = "PlazasAplicadas.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- INVOCA EL REPORTE --->


<cfreport format="#form.formato#" template= "#archivo#" query="rsReporte">
	<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
	<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
	
</cfreport>