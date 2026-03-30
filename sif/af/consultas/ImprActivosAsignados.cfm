	<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_dbfunction name="op_concat" returnvariable="_CAT">
<cf_dbfunction name="now" returnvariable="hoy">

<cfif isdefined('DEid') and form.DEid NEQ ''>

	<cfquery datasource="#session.dsn#" name="rsEmpresa">
		select Enombre
		from Empresa
		where Ereferencia = #session.Ecodigo#
	</cfquery>

	<cfquery datasource="#session.dsn#" name="rsFecha">
		select  Fecha_Actual = 'México, D.F., a '+convert(varchar,day(getdate()))+' de '+
		case month(getdate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5        then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then        'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end+' de '+convert(varchar,year(getdate()))
	</cfquery>

	<cfquery datasource="#session.dsn#" name="rsEncargadoCF">
		select DEnombre #_Cat# ' ' #_Cat# DEapellido1 #_Cat# ' ' #_Cat# DEapellido2 as Nombre
		from DatosEmpleado DE
		inner join EmpleadoCFuncional EC on DE.DEid = EC.DEid
		inner join CFuncional CF on EC.CFid = CF.CFid
		where ECFencargado = 1
		and CFcodigo = '261'
	</cfquery>

	<cfquery datasource="#session.dsn#" name="rsReporte">

			Select
				a.AFRffin, a.CRCCid,	ltrim(rtrim(b.CRCCcodigo)) #_Cat# '-' #_Cat# ltrim(rtrim(b.CRCCdescripcion))				                as CentroCustodia, c.Aplaca as Placa, a.AFRfini as Fecha,coalesce(a.CRDRdescripcion,'-') as Descripcion,
				coalesce(CRDRdescdetallada,'-') as DescripcionDet, a.CRTDid, rtrim(d.CRTDdescripcion) as TipoDocumento,
				e.ACdescripcion as Categoria, f.ACdescripcion as Clase, c.Aserie as Serie, g.DEidentificacion  as 			                Cedula, g.DEnombre #_Cat# ' ' #_Cat# g.DEapellido1 #_Cat# ' ' #_Cat# g.DEapellido2 as Nombre, g.DEemail,
				CFACT.CFidresp as CFidresp,
				CFACT.CFcodigo as CFcodigo,
				g.DEdireccion as DEdireccion,
				g.DEtelefono1 as extension,
				g.DEtelefono2 as celular,
				CFACT.CFdescripcion as CFdescripcion,
				case when (#hoy# >= a.AFRfini and #hoy# <= a.AFRffin) then 'Activo' else 'Inactivo' end as descEstado,
				case when (#hoy# >= a.AFRfini and #hoy# <= a.AFRffin) then 'A' else 'I' end as idEstado,
				(select min(HIS.CRBfecha)
							from CRBitacoraTran  HIS
							where  HIS.Ecodigo = c.Ecodigo
					       and HIS.CRBPlaca = c.Aplaca
		    			   and HIS.CRBid = (select max(BITC.CRBid)
								           		from CRBitacoraTran BITC
						        			    where BITC.Ecodigo = c.Ecodigo
									            and BITC.CRBPlaca = c.Aplaca)
				) as UltimaMofic,
				h.Usulogin,
				j.AFMid,j.AFMcodigo,j.AFMdescripcion,
				k.AFMMid,k.AFMMcodigo,k.AFMMdescripcion
		from AFResponsables a
	  inner join CRCentroCustodia b
		on b.Ecodigo = a.Ecodigo
		and b.CRCCid = a.CRCCid
	  inner join Activos c
		on c.Aid = a.Aid
		and c.Ecodigo = a.Ecodigo
	  left outer join AFMarcas j on
				c.AFMid = j.AFMid
	  left outer join AFMModelos k on
				c.AFMMid = k.AFMMid
	  left outer join CRTipoDocumento d
	    on d.Ecodigo = a.Ecodigo
		and d.CRTDid =a.CRTDid
	  left outer join ACategoria e
		on e.Ecodigo = c.Ecodigo
		and e.ACcodigo =c.ACcodigo
	  left outer join AClasificacion f
		on f.Ecodigo = e.Ecodigo
		and f.ACcodigo =e.ACcodigo
		and f.ACid =c.ACid
	  left outer join DatosEmpleado  g on a.DEid 	= g.DEid
	  left outer join EmpleadoCFuncional ef
	  	on ef.DEid = g.DEid
		and GETDATE() between convert(datetime,ECFdesde) and convert(datetime,ECFhasta)
	  left outer join CFuncional CFACT
	  	on CFACT.CFid = ef.CFid
	  left outer join Usuario h
		on a.Usucodigo = h.Usucodigo

	where a.Ecodigo =  #Session.Ecodigo#
		  and convert(datetime, a.AFRffin, 103) > getdate()
				<cfif isdefined("DEid") and ltrim(rtrim(DEid)) gt 0>
			    	and a.DEid = #DEid#
			    </cfif>
				<cfif isdefined("form.VER") and (form.VER eq 'A'or form.VER eq "A,T")>
					and (#hoy# >= a.AFRfini and #hoy# <= a.AFRffin)
				<cfelseif isdefined("form.VER") and form.VER eq 'I'>
					and #hoy# > a.AFRffin
				</cfif>
		</cfquery>



<!--- JMRV INICIO. 04 de Junio de 2014 --->

<!--- Para obtener el piso --->
<cfif isdefined("rsReporte") and isdefined("rsReporte.DEdireccion") and findNoCase("piso",rsReporte.DEdireccion)>
	<cfset ubicaPiso=findNoCase("piso",rsReporte.DEdireccion)>
	<cfset cadena1=RemoveChars(rsReporte.DEdireccion, 1, #ubicaPiso# - 1)>
	<cfset piso = GetToken(#cadena1#, 2, " ")>
	<cfif piso eq "">
		<cfset piso = "SN">
	</cfif>
<cfelse>
	<cfset piso = "SN">
</cfif>

<!--- Para obtener la jerarquia --->
<cfif isdefined("rsReporte") and rsReporte.recordcount GT 0>
	<cfset contador = 0>
	<cfset flag = "true">
	<cfset CFid = #rsReporte.CFidresp#>

	<cfset direccion 	= ltrim(rtrim("#rsReporte.CFcodigo#")) & ' - ' & ltrim(rtrim("#rsReporte.CFdescripcion#"))>
	<cfset subdireccion = 'NA'>
	<cfset gerencia		= 'NA'>
	<cfset subgerencia	= 'NA'>

	<cfloop condition = "flag">

		<cfquery name="buscaJerarquia" datasource="#session.DSN#">
			select CFidresp, CFcodigo, CFdescripcion
			from CFuncional
			where CFid = #CFid#
		</cfquery>

		<cfif buscaJerarquia.CFidresp NEQ "" and buscaJerarquia.CFdescripcion NEQ 'EMPRESA GENERICA'>

			<cfset subgerencia	= "#gerencia#">
			<cfset gerencia 	= "#subdireccion#">
			<cfset subdireccion = "#direccion#">
			<cfset direccion 	= ltrim(rtrim("#buscaJerarquia.CFcodigo#")) & ' - ' & ltrim(rtrim("#buscaJerarquia.CFdescripcion#"))>

			<cfset CFid = #buscaJerarquia.CFidresp#>
			<cfset contador = contador + 1>
		<cfelse>
			<cfset flag = false>
		</cfif>

	</cfloop>
</cfif>

	<cfif isdefined("rsReporte") and rsReporte.recordcount GT 0>
	  <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 2>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "af.consultas.RptResguardo"
		headers = "empresa:#rsEmpresa.Enombre#"/>
	<cfelse>
		<cfreport format="pdf" template="RptResguardo.cfr" query="rsReporte">
			<cfreportparam name="Empresa" value="#rsEmpresa.Enombre#">
			<cfreportparam name="Fecha" value="#rsFecha.Fecha_Actual#">
			<cfreportparam name="EncargadoCF" value="#rsEncargadoCF.Nombre#">
			<cfreportparam name="direccion" value="#direccion#">
			<cfreportparam name="subDireccion" value="#subdireccion#">
			<cfreportparam name="gerencia" value="#gerencia#">
			<cfreportparam name="subGerencia" value="#subgerencia#">
			<cfreportparam name="piso" value="#piso#">
		</cfreport>
		</cfif>
	<cfelse>
		<cfthrow message="No se encontraron activos asignados al empleado">
	</cfif>

<!--- JMRV FIN. 04 de Junio de 2014 --->

</cfif>





