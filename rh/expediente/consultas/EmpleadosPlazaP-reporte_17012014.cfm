<!--- 
	Creado por: Ana Villavicencio
	Fecha: 26 de enero del 2006
	Motivo: Nuevo reporte de empleados por plaza Presupuestaria.
 --->
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
<cfif isdefined("Url.FechaCorte") and not isdefined("Form.FechaCorte")>
	<cfparam name="Form.FechaCorte" default="#Url.FechaCorte#">
<cfelse>
	<cfparam name="Form.FechaCorte" default="">
</cfif>
<cfif isdefined("Url.Nombre1") and not isdefined("Form.Nombre1")>
	<cfparam name="Form.Nombre1" default="#Url.Nombre1#">
</cfif>
<cfif isdefined("Url.Nombre2") and not isdefined("Form.Nombre2")>
	<cfparam name="Form.Nombre2" default="#Url.Nombre2#">
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="pdf">
</cfif>

<cfquery name="rsReporte" datasource="#Session.DSN#">
	select cf.CFid, cf.CFdescripcion,pp.RHPPcodigo,pp.RHPPdescripcion,mp.RHMPPdescripcion,
			lt.LTdesde,DLTmonto as LTsalario,lt.LTporcplaza,
			de.DEidentificacion,
			<cfif isdefined('form.Nombre1')>
			{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as nombre
			<cfelseif isdefined('form.Nombre2')>
			{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as nombre
			</cfif>
	from DatosEmpleado de
	inner join LineaTiempo lt
	   on de.DEid = lt.DEid
	  and de.Ecodigo = lt.Ecodigo
    <!---SML Modificacion para que solo considere el Sueldo Mensual--->
    inner join DLineaTiempo dl on dl.LTid = lt.LTid 
    inner join ComponentesSalariales cs on cs.CSid = dl.CSid
    	and cs.CSsalariobase = 1 
	<!---SML Modificacion para que solo considere el Sueldo Mensual--->
	  <cfif isdefined('form.FechaCorte') and LEN(TRIM(form.FechaCorte))>
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaCorte)#"> between LTdesde and LThasta
	<cfelse>
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">  between lt.LTdesde and lt.LThasta 
	  </cfif>
	inner join RHPlazas p
	   on lt.Ecodigo = p.Ecodigo
	  and lt.RHPid = p.RHPid
	  and lt.RHPcodigo = p.RHPpuesto
	inner join CFuncional cf
	   on p.Ecodigo = cf.Ecodigo
	  and p.CFid = cf.CFid
	  <cfif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI)) and isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>
	    and cf.CFcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#"> 
	  	and <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#">
	  <cfelseif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI))>
		and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#"> 
	  <cfelseif isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>	
		and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#"> 
	  </cfif>	
	inner join RHPlazaPresupuestaria pp
	   on p.Ecodigo = pp.Ecodigo
	  and p.RHPPid = pp.RHPPid
	inner join RHPuestos pu
	   on p.Ecodigo = pu.Ecodigo
	  and p.RHPpuesto = pu.RHPcodigo
	inner join RHMaestroPuestoP mp
	   on pu.Ecodigo = mp.Ecodigo
	  and pu.RHMPPid = mp.RHMPPid
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    union
    select cf.CFid, cf.CFdescripcion,pp.RHPPcodigo,pp.RHPPdescripcion,mp.RHMPPdescripcion,
			lt.LTdesde,lt.LTsalario,lt.LTporcplaza,
			de.DEidentificacion,
			<cfif isdefined('form.Nombre1')>
			{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as nombre
			<cfelseif isdefined('form.Nombre2')>
			{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as nombre
			</cfif>
	from DatosEmpleado de
	inner join LineaTiempoR lt
	   on de.DEid = lt.DEid
	  and de.Ecodigo = lt.Ecodigo
	  <cfif isdefined('form.FechaCorte') and LEN(TRIM(form.FechaCorte))>
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaCorte)#"> between LTdesde and LThasta
	<cfelse>
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">  between lt.LTdesde and lt.LThasta 
	  </cfif>
	inner join RHPlazas p
	   on lt.Ecodigo = p.Ecodigo
	  and lt.RHPid = p.RHPid
	  and lt.RHPcodigo = p.RHPpuesto
	inner join CFuncional cf
	   on p.Ecodigo = cf.Ecodigo
	  and p.CFid = cf.CFid
	  <cfif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI)) and isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>
	    and cf.CFcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#"> 
	  	and <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#">
	  <cfelseif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI))>
		and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#"> 
	  <cfelseif isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>	
		and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#"> 
	  </cfif>	
	inner join RHPlazaPresupuestaria pp
	   on p.Ecodigo = pp.Ecodigo
	  and p.RHPPid = pp.RHPPid
	inner join RHPuestos pu
	   on p.Ecodigo = pu.Ecodigo
	  and p.RHPpuesto = pu.RHPcodigo
	inner join RHMaestroPuestoP mp
	   on pu.Ecodigo = mp.Ecodigo
	  and pu.RHMPPid = mp.RHMPPid
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    
	order by cf.CFid,pp.RHPPcodigo,de.DEidentificacion

</cfquery>
<cfif isdefined('rsReporte') and rsReporte.RecordCount>
	<cfreport format="#Form.formato#" template= "EmpleadosPlazaP.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfif isdefined("Form.CFcodigoI") and Len(Trim(Form.CFcodigoI))>
			<cfreportparam name="CFcodigoI" value="#Form.CFcodigoI#">
		<cfelse>
			<cfreportparam name="CFcodigoI" value="-1">
		</cfif>
		<cfif isdefined("Form.CFcodigoF") and Len(Trim(Form.CFcodigoF))>
			<cfreportparam name="CFcodigoF" value="#Form.CFcodigoF#">
		<cfelse>
			<cfreportparam name="CFcodigoF" value="-1">
		</cfif>
		<cfif isdefined('form.FechaCorte') and LEN(TRIM(form.FechaCorte))>
			<cfreportparam name="FechaCorte" value="#form.FechaCorte#">
		<cfelse>
			<cfreportparam name="FechaCorte" value="">
		</cfif>
		<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
			<cfreportparam name="formato" value="#Form.formato#">
		</cfif>
	</cfreport>
<cfelse>
	<cfdocument format="#Form.formato#" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
		<tr>
			<td>
				<table width="100%" cellpadding="7px" cellspacing="0">
					<tr bgcolor="##BFD6DB" style="padding-left:100px; "><td width="2%">&nbsp;</td><td align="center"><font size="+2">#session.Enombre#</font></td></tr>
					<tr bgcolor="##BFD6DB"><td width="2%">&nbsp;</td><td  align="center"><font size="+1"><cf_translate  key="LB_EmpleadosPorPlazaPresupuestaria">Empleados por Plaza Presupuestaria</cf_translate></font></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">--------------- <cf_translate  key="LB_NoHayRegistrosRelacionados">No hay registros relacionados</cf_translate> ---------------</td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>