<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<!---<cf_templatecss> 
 <link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<cf_templatecss>--->
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cfparam name="PageNum_rsProc" default="1">

<cfif isDefined("Url.DEid") and not isDefined("Form.DEid")>
  <cfset Form.DEid = Url.DEid>
</cfif>

<cfif isDefined("Url.id_centro") and not isDefined("Form.id_centro")>
  <cfset Form.id_centro = Url.id_centro>
</cfif>

<cfif isDefined("Url.fdesde") and not isDefined("Form.fdesde")>
  <cfset Form.fdesde = Url.fdesde>
</cfif>

<cfif isDefined("Url.fhasta") and not isDefined("Form.fhasta")>
  <cfset Form.fhasta = Url.fhasta>
</cfif>

<cfinclude template="queryMarcas.cfm">

<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
	<!--- Centro Funcional ---->
	<cfquery name="rsCentro" datasource="#session.DSN#">
		select CFdescripcion as Centro, CFid
		from CFuncional 
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_centro#">
	</cfquery>
</cfif>

<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0 and rsProc.RecordCount EQ 0>
	<cfquery name="rsEmpleado2" datasource="#session.DSN#">
		select DEid, {fn concat({fn concat({fn concat({fn concat(DEapellido1 , ' ' )}, DEapellido2 )}, ' ' )}, DEnombre )} as nombreCompleto, 
		DEidentificacion as cedula 
		from DatosEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
</cfif>

<!--- <cfset MaxRows_rsProc=100>
<cfset StartRow_rsProc=Min((PageNum_rsProc-1)*MaxRows_rsProc+1,Max(rsProc.RecordCount,1))>
<cfset EndRow_rsProc=Min(StartRow_rsProc+MaxRows_rsProc-1,rsProc.RecordCount)>
<cfset TotalPages_rsProc=Ceiling(rsProc.RecordCount/MaxRows_rsProc)>
<cfset QueryString_rsProc=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rsProc,"PageNum_rsProc=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsProc=ListDeleteAt(QueryString_rsProc,tempPos,"&")>
</cfif> --->
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
	<tr> 
		<td nowrap align="center" ><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
	</tr>
	<tr > 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate  key="LB_ReporteDeMarcas">Reporte de Marcas</cf_translate></strong></td>
	</tr>
	
</table>
<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
	<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0 and rsProc.RecordCount EQ 0>
		<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
		<tr > 
			<td nowrap align="center"><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:<cfif rsProc.RecordCount gt 0>#rsProc.CFdescripcion#<cfelse>#rsCentro.Centro# <cf_translate  key="LB_NoTieneMarcas">no tiene Marcas.</cf_translate></cfif></td>
		</tr>
		<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
	</cfif>
	<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0 and rsProc.RecordCount EQ 0>
		<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
		<tr > 
			<td nowrap align="center" ><strong><cf_translate  key="LB_Funcionario">Funcionario</cf_translate>:</strong> #rsEmpleado2.cedula# - #rsEmpleado2.nombreCompleto# <cf_translate  key="LB_NoTieneMarcas">no tiene Marcas.</cf_translate></td>
		</tr>
		<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
	</cfif>
	<cfif not isdefined("rsCentro") and rsProc.RecordCount EQ 0 >
		<tr><td><hr width="100%" size="0" color="##000000"></td></tr>
		<tr > 
			<td colspan="8"  align="center"><strong><cf_translate  key="LB_NoHayRegistrosDeMarcasParaEstaEmpresa">No hay registros de marcas para esta empresa</cf_translate></strong>
			&nbsp;</td>
		</tr>  
		 <tr><td><hr width="100%" size="0" color="##000000"></td></tr>
	</cfif>
	<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 >
		<tr > 
			<td colspan="8" align="center"><font size="2"><strong><cf_translate  key="LB_Desde">Desde</cf_translate>: &nbsp;</strong>#form.fdesde#<strong>&nbsp; <cf_translate  key="LB_Hasta">Hasta</cf_translate>: &nbsp;</strong> #form.fhasta#</font>
			&nbsp;</td>
		</tr>  
	</cfif>
</table>	
</cfoutput>
<cfif rsProc.RecordCount NEQ 0>

	<cfset IdEmpleado = 0>
	<cfset descripcion = "">
	<cfset supervisor = "">
	
	<cfset NumLinea = 1>
	<cfset temp = 0> <!--- Controla si esta cerrado el periodo de Extras --->
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
  <cfoutput query="rsProc">
   <cfflush interval="512">
	<cfif descripcion NEQ rsProc.centro >
		<!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center"> --->
			<tr><td colspan="8"><hr width="100%" size="0" color="##000000"></td></tr>
			<tr > 
				<td colspan="8" align="center"><font size="2"><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>: &nbsp;</strong>#rsProc.CFdescripcion#<strong></strong></font>&nbsp;</td>
			</tr>
		<!--- </table> --->
		<cfset descripcion = rsProc.centro>
		
	</cfif>
	<cfif supervisor NEQ rsProc.NombreUsuario>
		<cfset supervisor = rsProc.NombreUsuario>
<!--- 		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
 --->			<tr > 
				<td colspan="8" align="center"><font size="2"><strong><cf_translate  key="LB_Supervisor">Supervisor</cf_translate>: &nbsp;</strong>#rsProc.NombreUsuario#<strong></strong></font>&nbsp;</td>
			</tr>
		<!--- </table> --->
	</cfif>	
			
	<cfif IdEmpleado NEQ rsProc.cedula >
		<cfset IdEmpleado = rsProc.cedula>
<!--- 		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
 --->			<tr><td colspan="8"><hr width="100%" size="0" color="##000000"></td></tr>
			<tr > 
				<td colspan="8" align="center">
					<font size="2"><strong><cf_translate  key="LB_Funcionario">Funcionario</cf_translate>: &nbsp; #rsProc.cedula# - #rsProc.NombreEmpleado#</strong></font>
				</td>
			</tr>
			<tr > 
				<td colspan="8" align="center"><font size="2"><strong><cf_translate  key="LB_Puesto">Puesto</cf_translate>: &nbsp;</strong>#rsProc.RHPdescpuesto#<strong></strong></font>
				&nbsp;</td>
			</tr>  
			<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 >
				<tr > 
					<td colspan="8" align="center"><font size="2"><strong><cf_translate  key="LB_Desde">Desde</cf_translate>: &nbsp;</strong>#form.fdesde#<strong>&nbsp; <cf_translate  key="LB_Hasta">Hasta</cf_translate>: &nbsp;</strong> #form.fhasta#</font>
					&nbsp;</td>
				</tr>  
			</cfif>
			<tr><td colspan="8"><hr width="100%" size="0" color="##000000"></td></tr>
			<tr class="listaCorte" >
					<td width="10%"><cf_translate  key="LB_FechaMarca">Fecha Marca</cf_translate>:</td>
					<td width="10%"><cf_translate  key="LB_MarcaEntrada">Marca Entrada</cf_translate>:</td>
					<td width="10%"><cf_translate  key="LB_MarcaSalida">Marca Salida</cf_translate>:</td>
					<td width="10%"><cf_translate  key="LB_EntradaAutorizada">Entrada Autorizada</cf_translate>:</td>
					<td width="10%"><cf_translate  key="LB_SalidaAutorizada">Salida Autorizada</cf_translate>:</td>
					<td width="10%"><cf_translate  key="LB_HorasExtrasAut">Horas extras Aut.</cf_translate></td>
					<td width="10%"><cf_translate  key="LB_HorasRebajadas">Horas Rebajadas</cf_translate></td>
					<td width="10%"><cf_translate  key="LB_AccionReportada">Acci&oacute;n Reportada</cf_translate></td>
			</tr>
		<!--- </table> --->
	</cfif>				
	<!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center"> --->
		<cfset NumLinea = NumLinea + 1>
		<tr>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#LSDateFormat(rsProc.RHCMfcapturada,'dd/mm/yyyy')#</td>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhoraentrada#</td>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhorasalida#</td>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhoraentradac#</td>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhorasalidac#</td>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center"><cfif rsProc.RHCMhorasadicautor GT 0>#LSNumberFormat(rsProc.RHCMhorasadicautor,',9.00')#<cfelse>&nbsp;</cfif></td>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#LSNumberFormat(rsProc.RHCMhorasrebajar,',9.00')#</td>
			<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left" nowrap>#rsProc.RHASdescripcion#</td>
		</tr>
		<cfif len(trim(rsProc.RHPMfcierre)) EQ 0>
			<cfset temp = temp + 1>						
		</cfif>
		<cfset Supervisor = rsProc.NombreUsuario>
  </cfoutput>

<tr > 
					<td colspan="8" align="center">&nbsp;</td>
				</tr>  
				<cfif #temp# GT 0>
					<tr > 
						<td colspan="8" align="left"><strong><cf_translate  key="LB_EsteReporteEsDeCaracterTemporal">Este reporte es de car&aacute;cter temporal , ya que no se ha cerrado el Procesamiento de marcas.</cf_translate></strong></td>
					</tr>  
				</cfif>
				<tr > 
					<td colspan="8" align="center"><strong>------------------------------
						<cfif isdefined("url.DEid")>
							<cf_translate  key="LB_FinDelReporte">Fin del Reporte</cf_translate>
						<cfelse>
							<cf_translate  key="LB_FinDeLaConsulta">Fin de la Consulta </cf_translate>
						</cfif>
					--------------------------------------</strong>
					&nbsp;</td>
				</tr>  
			</table>
		<!--- <cfelse>
			
			<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
				<tr><td><hr width="100%" size="0" color="##000000"></td></tr>
				
				<tr > 
					<td colspan="8" align="center"><font size="2"><strong>No hay registros</strong></font>
					&nbsp;</td>
				</tr>  
				 <tr><td><hr width="100%" size="0" color="##000000"></td></tr>
			</table> --->
			
		</cfif>			   

 <!---	
  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	<cfset params= "">
	<cfif isdefined("form.DEid") and len(trim(form.DEid)) neq 0>
		<cfset params = params & '&DEid=' & #form.DEid#>
	</cfif>
	<cfif isdefined("form.id_centro")  and len(trim(form.id_centro)) neq 0>
		<cfset params = params & '&id_centro=' & #form.id_centro# >
	</cfif>
	<cfif isdefined("form.fdesde")  and len(trim(form.fdesde)) neq 0>
		<cfset params = params & '&fdesde=' & #form.fdesde# >
	</cfif>
	<cfif isdefined("form.fhasta")  and len(trim(form.fhasta)) neq 0>
		<cfset params = params & '&fhasta=' & #form.fhasta# >
	</cfif>

  <cfoutput>	
    <tr>
      	<td colspan="8" align="center">
	
        <cfif PageNum_rsProc GT 1>
          <a href="#CurrentPage#?PageNum_rsProc=1#params#"><img src="../../capacitaciondes/consultas/First.gif" border=0></a>
		</cfif>
        <cfif PageNum_rsProc GT 1>
          <a href="#CurrentPage#?PageNum_rsProc=#Max(DecrementValue(PageNum_rsProc),1)##params#"><img src="../../capacitaciondes/consultas/Previous.gif" border=0></a>
        </cfif>
		<cfif PageNum_rsProc LT TotalPages_rsProc>
          <a href="#CurrentPage#?PageNum_rsProc=#Min(IncrementValue(PageNum_rsProc),TotalPages_rsProc)##params#"><img src="../../capacitaciondes/consultas/Next.gif" border=0></a>
		</cfif>
        <cfif PageNum_rsProc LT TotalPages_rsProc>
          <a href="#CurrentPage#?PageNum_rsProc=#TotalPages_rsProc##params#"><img src="../../capacitaciondes/consultas/Last.gif" border=0></a>
		</cfif>
      </td>
    </tr>
	</table>
  </cfoutput>
   --->