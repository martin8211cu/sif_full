<!--- 
	Creado por: Ana Villavicencio
	Fecha: 26 de enero del 2006
	Motivo: Nuevo reporte de histórico de una plaza presupuestaria. 
 --->
<cfif isdefined("Url.RHPPcodigoD") and LEN(TRIM(url.RHPPcodigoD)) and not isdefined("Form.RHPPcodigoD")>
	<cfparam name="Form.RHPPcodigoD" default="#Url.RHPPcodigoD#">
</cfif>
<cfif isdefined("Url.RHPPcodigoH") and LEN(TRIM(url.RHPPcodigoH)) and not isdefined("Form.RHPPcodigoH")>
	<cfparam name="Form.RHPPcodigoH" default="#Url.RHPPcodigoH#">
</cfif>

<cfif isdefined("Url.RHPPidD") and not isdefined("Form.RHPPidD")>
	<cfparam name="Form.RHPPidD" default="#Url.RHPPidD#">
</cfif>
<cfif isdefined("Url.RHPPidH") and not isdefined("Form.RHPPidH")>
	<cfparam name="Form.RHPPidH" default="#Url.RHPPidH#">
</cfif>

<cfif isdefined("Url.FechaD") and not isdefined("Form.FechaD")>
	<cfparam name="Form.FechaD" default="#Url.FechaD#">
</cfif>
<cfif isdefined("Url.FechaH") and not isdefined("Form.FechaH")>
	<cfparam name="Form.FechaH" default="#Url.FechaH#">
<cfelse>
	<cfparam name="Form.FechaH" default="">
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="pdf">
</cfif>

<cfif not isdefined('form.RHPPcodigoD')>
	<cfquery name="rsMinPlaza" datasource="#session.DSN#">
		select coalesce(min(RHPPcodigo),'') as minPlaza
		from RHPlazaPresupuestaria 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfparam name="form.RHPPcodigoD" default="#rsMinPlaza.minPlaza#">
</cfif>
<cfif not isdefined('form.RHPPcodigoH')>
	<cfquery name="rsMaxPlaza" datasource="#session.DSN#">
		select coalesce(max(RHPPcodigo),'') as maxPlaza
		from RHPlazaPresupuestaria 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfparam name="form.RHPPcodigoH" default="#rsMaxPlaza.maxPlaza#">
</cfif>

	<cfquery name="rsReporte" datasource="#Session.DSN#">
		
		select 
		 pp.RHPPid,
			pp.RHPPcodigo, 
		 pp.RHPPdescripcion,
		 cf.CFdescripcion,
			de.DEidentificacion,
		{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as nombre,	
		 lt.LTdesde, 
		 lt.LThasta, 
		 lt.LTsalario,
         lt.LTporcplaza,
		 cf.CFid
		from RHLineaTiempoPlaza ltp
		inner join RHPlazaPresupuestaria pp 
		   on ltp.Ecodigo = pp.Ecodigo
		  and ltp.RHPPid = pp.RHPPid
		inner join RHPlazas p 
		   on ltp.Ecodigo = p.Ecodigo
		  and pp.RHPPid = p.RHPPid
		inner join CFuncional cf
		   on p.Ecodigo = cf.Ecodigo
		  and p.CFid = cf.CFid
		inner join LineaTiempo lt
		   on ltp.Ecodigo = lt.Ecodigo
		  and ltp.RHLTPfhasta >= lt.LTdesde
		  and ltp.RHLTPfdesde <= lt.LThasta
		  and p.Ecodigo = lt.Ecodigo
		  and p.RHPid = lt.RHPid
		inner join DatosEmpleado de
		   on lt.Ecodigo = de.Ecodigo
		  and lt.DEid = de.DEid
		where ltp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaD)#"> <= ltp.RHLTPfhasta
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaH)#"> >= ltp.RHLTPfdesde
		<cfif form.RHPPcodigoD GT form.RHPPcodigoH>
		  and pp.RHPPcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoH#">
		  and pp.RHPPcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoD#">
		<cfelse>
		  and pp.RHPPcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoD#">
		  and pp.RHPPcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoH#">
		</cfif>
		union
		
		select 
		 pp.RHPPid,
			pp.RHPPcodigo, 
		 pp.RHPPdescripcion,
		 cf.CFdescripcion,
			de.DEidentificacion,
		{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as nombre,	
		 lt.LTdesde, 
		 lt.LThasta, 
		 lt.LTsalario,
         lt.LTporcplaza,
		 cf.CFid
		from RHLineaTiempoPlaza ltp
		inner join RHPlazaPresupuestaria pp 
		   on ltp.Ecodigo = pp.Ecodigo
		  and ltp.RHPPid = pp.RHPPid
		inner join RHPlazas p 
		   on ltp.Ecodigo = p.Ecodigo
		  and pp.RHPPid = p.RHPPid
		inner join CFuncional cf
		   on p.Ecodigo = cf.Ecodigo
		  and p.CFid = cf.CFid
		inner join LineaTiempoR lt
		   on ltp.Ecodigo = lt.Ecodigo
		  and ltp.RHLTPfhasta >= lt.LTdesde
		  and ltp.RHLTPfdesde <= lt.LThasta
		  and p.Ecodigo = lt.Ecodigo
		  and p.RHPid = lt.RHPid
		inner join DatosEmpleado de
		   on lt.Ecodigo = de.Ecodigo
		  and lt.DEid = de.DEid
		where ltp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaD)#"> <= ltp.RHLTPfhasta
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaH)#"> >= ltp.RHLTPfdesde
		<cfif form.RHPPcodigoD GT form.RHPPcodigoH>
		  and pp.RHPPcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoH#">
		  and pp.RHPPcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoD#">
		<cfelse>
		  and pp.RHPPcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoD#">
		  and pp.RHPPcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPPcodigoH#">
		</cfif>        
		order by pp.RHPPcodigo, LTdesde,LThasta

		
	</cfquery>
<cfif isdefined('rsReporte') and rsReporte.RecordCount GT 0>
	<cfreport format="#Form.formato#" template= "HistoricoPlazaP.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfif isdefined("Form.RHPPidD") and Len(Trim(Form.RHPPidD))>
			<cfreportparam name="RHPPidD" value="#Form.RHPPidD#">
		<cfelse>
			<cfreportparam name="RHPPidD" value="-1">
		</cfif>
		<cfif isdefined("Form.RHPPidH") and Len(Trim(Form.RHPPidH))>
			<cfreportparam name="RHPPidH" value="#Form.RHPPidH#">
		<cfelse>
			<cfreportparam name="RHPPidH" value="-1">
		</cfif>
		<cfif isdefined('form.FechaD') and LEN(TRIM(form.FechaD))>
			<cfreportparam name="FechaD" value="#LSDateFormat(form.FechaD,'dd/mm/yyyy')#">
		<cfelse>
			<cfreportparam name="FechaD" value="">
		</cfif>
		<cfif isdefined('form.FechaH') and LEN(TRIM(form.FechaH))>
			<cfreportparam name="FechaH" value="#LSDateFormat(form.FechaH,'dd/mm/yyyy')#">
		<cfelse>
			<cfreportparam name="FechaH" value="">
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
					<tr bgcolor="##BFD6DB"><td width="2%">&nbsp;</td><td  align="center"><font size="+1"><cf_translate  key="LB_HistoricoDePlazasPresupuestarias">Histórico de Plazas Presupuestarias</cf_translate></font></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">--------------- <cf_translate  key="LB_NoHayRegistrosRelacionados">No hay registros relacionados </cf_translate>---------------</td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>