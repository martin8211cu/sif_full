<cfquery name="reporte" datasource="#Session.DSN#">
	select  {fn concat({fn concat(rtrim(jo.RHJcodigo) , ' - ' )},  jo.RHJdescripcion  )} as jornada
	
	<cfif isdefined("url.empleados")>
		,{fn concat({fn concat(rtrim(<cf_dbfunction name="to_char" args="cf.CFid">) , ' ' )},  cf.CFdescripcion  )}  as centro, 
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as empleado
	
	<cfelse>
		,'' as centro,
		'' as empleado
	</cfif>

	from RHJornadas jo
	left outer join LineaTiempo dl
		on dl.Ecodigo = jo.Ecodigo
		and dl.RHJid = jo.RHJid 
		and getdate() between dl.LTdesde and dl.LThasta
		

	left outer join  RHPlazas pl
		on pl.Ecodigo = jo.Ecodigo
		and pl.RHPid = dl.RHPid

	left outer join  CFuncional cf
		on cf.Ecodigo = jo.Ecodigo
		and  cf.CFid = pl.CFid
	
	left outer join DatosEmpleado de
		on de.Ecodigo = jo.Ecodigo
		and de.DEid = dl.DEid 
	where
		jo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		
		<cfif isdefined("url.RHJid") and len(trim(url.RHJid))neq 0>
		and  jo.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHJid#">
		</cfif>
		
	order by  jo.RHJcodigo,jo.RHJdescripcion, cf.CFdescripcion, de.DEnombre , de.DEapellido1 , de.DEapellido2
</cfquery>

<cfif reporte.recordCount gt 0 >
		<cfif isdefined("url.empleados")>
			<cfset muestraEmp = 1>
		<cfelse>
			<cfset muestraEmp = 0>		
		</cfif>
		
		<cfreport format="#url.formato#" template= "jornadas.cfr" query="reporte">
			<cfreportparam name="Edescripcion" value="#Session.Enombre#">
			<cfreportparam name="muestraEmp" value="#muestraEmp#">
		</cfreport>
<cfelse>
	<cfdocument format="flashpaper" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
		<tr>
			<td>
				<table width="100%" cellpadding="3px" cellspacing="0">
					<tr bgcolor="##E3EDEF" style="padding-left:100px; "><td width="2%">&nbsp;</td><td align="center"><font size="1" color="##6188A5">#session.Enombre#</font></td></tr>
					<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td  align="center"><font size="+1"><cf_translate  key="LB_ReporteDeJornadas">Reporte de Jornadas</cf_translate></font></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">-- <cf_translate  key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --</td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>
