<cfdump var="#url#">
<cfif isdefined("Url.CFcodigoI") and not isdefined("Form.CFcodigoI")>
	<cfparam name="Form.CFcodigoI" default="#Url.CFcodigoI#">
<cfelse>
	<cfparam name="Form.CFcodigoI" default="-1">
</cfif>
<cfif isdefined("Url.CFcodigoF") and not isdefined("Form.CFcodigoF")>
	<cfparam name="Form.CFcodigoF" default="#Url.CFcodigoF#">
<cfelse>
	<cfparam name="Form.CFcodigoF" default="-1">
</cfif>
<cfif isdefined("Url.Nombre1") and not isdefined("Form.Nombre1")>
	<cfparam name="Form.Nombre1" default="#Url.Nombre1#">
</cfif>
<cfif isdefined("Url.Nombre2") and not isdefined("Form.Nombre2")>
	<cfparam name="Form.Nombre2" default="#Url.Nombre2#">
</cfif>
<cfif isdefined("Url.Orden") and not isdefined("Form.Orden")>
	<cfparam name="Form.Orden" default="#Url.Orden#">
</cfif>
<cfif isdefined("Url.fdesde") and not isdefined("Form.fdesde")>
	<cfparam name="Form.fdesde" default="#LSDateFormat(Url.fdesde,'YYYY/MM/DD')#">
</cfif>
<cfif isdefined("Url.fhasta") and not isdefined("Form.fhasta")>
	<cfparam name="Form.fhasta" default="#LSDateFormat(Url.fhasta,'YYYY/MM/DD')#">
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="pdf">
</cfif>

<cfquery name="rsReporte" datasource="#Session.DSN#">
	select lt.RHPid, 
		cf.CFcodigo, cf.CFdescripcion, 
		<cfif isdefined('form.Nombre1')>
			<cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2 ,' ',de.DEnombre">  as nombre,
		<cfelseif isdefined('form.Nombre2')>
			<cf_dbfunction name="concat" args="de.DEnombre,' 'de.DEapellido1,' ',de.DEapellido2 ">  as nombre,
		</cfif>
		de.DEidentificacion,
		de.DEid,
		ev.EVfantig,
		dv.DVEfecha, dv.DVEdescripcion,
		dv.DVEdisfrutados, dv.DVEcompensados,
		coalesce(DVEdisfrutados,0)+coalesce(DVEcompensados,0) as SaldoVac
	from LineaTiempo lt
	inner join RHPlazas p
	   on lt.RHPid = p.RHPid
	  and lt.Ecodigo = p.Ecodigo
	inner join CFuncional cf
	   on p.CFid = cf.CFid
	  and p.Ecodigo = cf.Ecodigo
	inner join DatosEmpleado de
	   on lt.DEid = de.DEid
	inner join EVacacionesEmpleado ev
	   on de.DEid = ev.DEid
	left outer join DVacacionesEmpleado dv
	   on ev.DEid = dv.DEid
	  and (coalesce(abs(DVEdisfrutados),0)+coalesce(abs(DVEcompensados),0)) > 0 
	  and abs(coalesce(DVEenfermedad,0)) = 0
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta 
	<cfif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI)) and isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>
	  and ltrim(rtrim(cf.CFcodigo)) between <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#"> 
	  						  and <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#">
	<cfelseif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI))>
		 and ltrim(rtrim(cf.CFcodigo)) >= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#"> 
	<cfelseif isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>	
		 and ltrim(rtrim(cf.CFcodigo)) <= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#"> 
	</cfif>	
	
	<cfif isdefined ('form.fdesde') and len(trim(form.fdesde)) gt 0 and (not isdefined ('form.fhasta') or len(trim(form.fhasta)) eq 0)>
		and dv.DVEfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#(form.fdesde)#">
	</cfif> 
	
	<cfif isdefined ('form.fhasta') and len(trim(form.fhasta)) gt 0 and (not isdefined ('form.fdesde') or len(trim(form.fdesde)) eq 0)>
		and dv.DVEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#(form.fhasta)#">
	</cfif>
	
	<cfif isdefined ('form.fhasta') and len(trim(form.fhasta)) gt 0 and isdefined ('form.fdesde') and len(trim(form.fdesde)) gt 0> 
		and dv.DVEfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#(form.fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#(form.fhasta)#">
	</cfif>
	
	<cfif isdefined('form.orden')>
		<cfif form.orden EQ 1>
			order by CFcodigo,de.DEidentificacion
		<cfelse>
			order by CFcodigo,nombre
		</cfif>
	</cfif>
</cfquery>


<!--- <cf_dump var="#rsReporte#"> --->
<cfif isdefined("rsReporte") AND rsReporte.RecordCount NEQ 0>
	<cfreport format="#Form.formato#" template= "VacacionesEmpA.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
			<cfreportparam name="formato" value="#Form.formato#">
		</cfif>
	</cfreport>
</cfif>