
<cffunction name="LeftUcase" >
   <cfargument name="str" required="true" type="string">
   <cfset strLeftUcase = Left(str, 1)>
   <cfset strLeftUcase = Ucase(strLeftUcase)>
   <cfset strLeftUcase = strLeftUcase & Mid(str,2,Len(str)-1)>
   <cfreturn strLeftUcase>
</cffunction>

<!--- parametros para la forma de imprimir --->
<cfset vparams = "">
<cfif isdefined("Form.fecDesde")>
	<cfset vparams = vparams & "&fecDesde=" & form.fecDesde>
</cfif>

<cfif isdefined("Form.fecHasta")>
	<cfset vparams = vparams & "&fecHasta=" & form.fecHasta>
</cfif>

<cfif isdefined("Form.ckVerFines")>
	<cfset vparams = vparams & "&ckVerFines=" & form.ckVerFines>
</cfif>

<cfoutput>
	<cfif isdefined("url.fecDesde")>
		<cfparam name="Form.fecDesde" default="#url.fecDesde#">
	</cfif>
	
	<cfif isdefined("url.fecHasta")>
		<cfparam name="Form.fecHasta" default="#url.fecHasta#">
	</cfif>
	<cfif isdefined("url.ckVerFines")>
		<cfparam name="Form.ckVerFines" default="#url.ckVerFines#">
	</cfif>	
</cfoutput>

<cfquery name="rsEmpresa" datasource="#session.DSN#" >
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset control = 0>
<cfset index = 0>

<cfsavecontent variable="encabezado">
		<tr> 
		  <td colspan="3" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
		</tr>
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr> 
		  <td colspan="3" align="center"><b>Reportes Faltantes por Recurso</b></td>
		</tr>
		<tr> 
			<cfoutput>
				<td colspan="3" align="center">
					<b>Desde:&nbsp;</b>#LSDateFormat(Form.fecDesde, 'dd/mm/yyyy')# &nbsp; 
					<b>Hasta:&nbsp;</b>#LSDateFormat(fecHasta, 'dd/mm/yyyy')#
				</td>
		  </cfoutput>
		</tr>
		<tr><td>&nbsp;</td></tr>
</cfsavecontent>
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<!--- <cfdump var="#session#"> --->

<form name="formResultados" method="post">

	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<cf_rhimprime datos="/sif/ControlTiempos/consultas/formReportesFXUsr.cfm" paramsuri="#vparams#">
					</td>	
				</tr>
			</table>	
		</cfif>
	</cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
		<cfoutput>#encabezado#</cfoutput>
		<cfquery name="rsDateDiff" datasource="#Session.DSN#">
			Select DateDiff(dd,convert(datetime,'#LSDateFormat(Form.fecDesde,"YYYYMMDD")#'),
			convert(datetime,'#LSDateFormat(Form.fecHasta,"YYYYMMDD")#')) diff
		</cfquery>
		<cfset pintar = true>
		<cfloop index="i" from="0" to="#rsDateDiff.diff#">
			<cfset index = index + 1 >
			<cfset fecha = DateAdd('d', i, LSDateFormat(Form.fecDesde,'mm/dd/yyyy'))>
			<cfif isdefined('form.ckVerFines')>
				<cfset pintar = true>				
			<cfelse>
				<cfif DayOfWeek("#fecha#") NEQ 1 and DayOfWeek("#fecha#") NEQ 7>
					<cfset pintar = true>		
				<cfelse>
					<cfset pintar = false>
				</cfif>		
			</cfif>
			<cfif pintar EQ true>
				<cfquery name="rsDateAdd" datasource="#Session.DSN#">
					Select DateAdd(dd,#i#,convert(datetime,'#LSDateFormat(Form.fecDesde,"YYYYMMDD")#')) newfec
				</cfquery>
					<!--- Ecodigo 3000000000000269(CEcodigo) cliente_empresarial 1500000000000042(EcodigoSDC) --->
					<cfquery name="rs" datasource="#Session.DSN#">
						select distinct a.Usucodigo, a.Ulocalizacion, 
							a.Usulogin, Papellido1 || ' ' ||  Papellido2 || ', ' || Pnombre as nombre, b.rol, a.Pid, 
							a.Pemail1, a.Poficina, a.Pfax 
						from sdc..Usuario a, sdc..UsuarioPermiso b, sdc..UsuarioEmpresa c, sdc..Rol d, sdc..Empresa e, sdc..EmpresaID f
						where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						and b.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
							and upper(d.rol) = 'SIF.CTREG'
							and a.activo	 = 1 
							and b.activo	 = 1 
							and c.activo	 = 1 
							and d.activo	 = 1 
							and e.activo	 = 1 
							and f.activo	 = 1
							and a.Usucodigo	 = b.Usucodigo
							and a.Ulocalizacion = b.Ulocalizacion
							and b.Usucodigo  = c.Usucodigo
							and b.Ulocalizacion = c.Ulocalizacion
							and b.Ecodigo 	 = c.Ecodigo
							and b.cliente_empresarial = c.cliente_empresarial
							and b.rol		 = d.rol
							and c.Ecodigo	 = e.Ecodigo
							and c.Ecodigo	 = f.Ecodigo
							and e.Ecodigo	 = f.Ecodigo
							and a.Usulogin not in (Select Usuario from CTReporteTiempos
												   Where CTRfecha = #lsparsedatetime(lsdateformat(rsDateAdd.newfec,"dd/mm/yyyy"))#)
						order by Papellido1, Papellido2, Pnombre
						
					</cfquery>
					<cfset jump = 0>
					<cfif isdefined("rs") and rs.RecordCount GT 0>
						<cfset control = 1>
						<tr class="encabReporte">
							<td align="center" colspan="3"><b>
								<cfoutput>
									#LeftUcase(DayofWeekAsString(DayOfWeek(fecha)))# &nbsp; #LSDateFormat(fecha,'dd/mm/yyyy')#
								</cfoutput>
							</b></td>
						</tr>
						<cfoutput query="rs">
							<cfswitch expression = '#jump#'>
							   <cfcase value = "1">
								  <cfset jump = 2>
							   </cfcase>
							   <cfcase value = "2">
								  <cfset jump = 3>
							   </cfcase>
							   <cfdefaultcase>
								  <cfset jump = 1>
							   </cfdefaultcase>
							</cfswitch>
							<cfif jump EQ 1>
							<tr>
								<td width="33%" align="left">#rs.nombre#</td>
							<cfelseif jump EQ 2>
								<td width="34%"align="left">#rs.nombre#</td>
							<cfelse>
								<td width="33%"align="left">#rs.nombre#</td>
							</tr>
							</cfif>
							<cfset index = index + 1 >
						</cfoutput><tr><td colspan="3">&nbsp;</td></tr>
					</cfif>
				</tr>
				
			</cfif>	
			<cfif isdefined("url.imprimir")>
				<cfif index mod 35 EQ 1>
					<cfif index NEQ 1>
						<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
					</cfif>
					<cfoutput>#encabezado#</cfoutput>
				</cfif>	
			</cfif>			
		</cfloop>
		<tr> 
		  <td colspan="3">&nbsp;</td>
		</tr>
		<tr> 
		  <td colspan="3" class="topline">&nbsp;</td>
		</tr>
		<tr> 
		  <td colspan="3">&nbsp;</td>
		</tr>
		<tr> 
			<cfif control EQ 1>
		  		<td colspan="3">
					<strong><div align="center">------------------ Fin del Reporte ------------------</div></strong></td>
			<cfelse>
		  		<td colspan="3">
					<strong><div align="center">------------------ No hay datos disponibles ------------------</div></strong>
				</td>			
			</cfif>
		</tr>
		<tr> 
		  <td colspan="3">&nbsp;</td>
		</tr>		
  </table>
</form>
