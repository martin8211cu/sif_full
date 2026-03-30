<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templatecss>
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


<cfquery name="rsProc" datasource="#session.DSN#">
	set nocount on
	select a.RHUMid
		,{fn concat({fn concat({fn concat({fn concat(c1.Pnombre , ' ' )}, c1.Papellido1 )}, ' ' )}, c1.Papellido2 )} as NombreUsuario
		,d.CFdescripcion as Centro
		,d.CFid  
		,{fn concat({fn concat({fn concat({fn concat(g.DEnombre , ' ' )}, g.DEapellido1 )}, ' ' )}, g.DEapellido2 )} as NombreEmpleado
		,<cf_dbfunction name="date_format" args="RHCMfcapturada,DD/MM/YY"> as RHCMfcapturada
		,substring(<cf_dbfunction name="to_char" args="RHCMhoraentrada">,1,5) as RHCMhoraentrada
		,substring(<cf_dbfunction name="to_char" args="RHCMhorasalida">,1,5) as RHCMhorasalida
		,substring(<cf_dbfunction name="to_char" args="RHCMhoraentradac">,1,5) as RHCMhoraentradac
		,substring(<cf_dbfunction name="to_char" args="RHCMhorasalidac">,1,5) as RHCMhorasalidac
		,coalesce(RHCMhorasrebajar,0) as RHCMhorasrebajar
		,cia.Enombre as Enombre
		,g.DEidentificacion as cedula
		,d.CFdescripcion
		,rhp.RHPdescripcion
		,rhpu.RHPdescpuesto 
		,coalesce(RHCMhorasadicautor,0) as RHCMhorasadicautor
		--,substring(h.RHASdescripcion,1,35) as RHASdescripcion
		, e.RHPMfcierre
		, f.RHCMusuarioautor
	from  DatosEmpleado g
		,RHControlMarcas f
		,RHProcesamientoMarcas e 
		,CFuncional d 
		,RHUsuariosMarcas a
		,Usuario b1
		,DatosPersonales c1
		,LineaTiempo lt
		--,RHAccionesSeguir h 
		,Empresa cia 
		,RHPlazas rhp
		,RHPuestos rhpu
	
	where g.Ecodigo=  <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
			and g.DEid in (<cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">) --, 4839, 4840)
		</cfif>
		<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
			and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
		</cfif>
		<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
			and f.RHCMfcapturada
			   between  <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(fdesde,'YYYYMMDD')#">
			and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(fhasta,'YYYYMMDD')#">
		</cfif>
		and f.DEid   = g.DEid
		and e.RHPMid = f.RHPMid
		and d.CFid   = e.CFid 	
		and d.CFid   = a.CFid 	
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between lt.LTdesde and lt.LThasta
		and lt.DEid  = g.DEid
		and a.Usucodigo = b1.Usucodigo 
		and f.RHCMusuarioautor = a.Usucodigo
		and b1.datos_personales = c1.datos_personales 
		--and h.RHASid =* f.RHASid
		and cia.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.EcodigoSDC#">
		and rhp.RHPid = lt.RHPid
		and lt.RHPcodigo = rhpu.RHPcodigo
		and rhpu.Ecodigo = g.Ecodigo
		and lt.Ecodigo = g.Ecodigo
		and coalesce(RHCMhorasadicautor,0) > 0
		order by
		<cfif isdefined("form.ckCF")>
			3 
		</cfif>
		<cfif isdefined("form.ckSP")>
			<cfif isdefined("form.ckCF")>	
				,
			</cfif>
				2
		</cfif>
		<cfif isdefined("form.ckF")>
			<cfif isdefined("form.ckCF") or isdefined("form.ckCF")>
				,
			</cfif>
			13 
		</cfif>
		<cfif not isdefined("form.ckCF") and not isdefined("form.ckSP") and not isdefined("form.ckF")>
			13,2,3
		</cfif>
		set nocount off
</cfquery>
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
<cfset MaxRows_rsProc=50>
<cfset StartRow_rsProc=Min((PageNum_rsProc-1)*MaxRows_rsProc+1,Max(rsProc.RecordCount,1))>
<cfset EndRow_rsProc=Min(StartRow_rsProc+MaxRows_rsProc-1,rsProc.RecordCount)>
<cfset TotalPages_rsProc=Ceiling(rsProc.RecordCount/MaxRows_rsProc)>
<cfset QueryString_rsProc=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rsProc,"PageNum_rsProc=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsProc=ListDeleteAt(QueryString_rsProc,tempPos,"&")>
</cfif>
<cfoutput>
<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
	<tr> 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
	</tr>
	<tr> 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:12pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate  key="LB_ReportesDeHorasExtras">Reporte de Horas Extras</cf_translate></strong></td>
	</tr>
</table>
<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0 and rsProc.RecordCount EQ 0>

		<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
		<tr > 
			<td nowrap align="center" ><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:<cfif rsProc.RecordCount gt 0>#rsProc.CFdescripcion#<cfelse>#rsCentro.Centro# <cf_translate  key="LB_NoTieneMarcas">no tiene Marcas.</cf_translate></cfif></td>
		</tr>
		<!--- <tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr> --->
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
		<td colspan="6" align="center"><strong><cf_translate  key="LB_NoHayRegistrosDeHorasExtrasParaEstaEmpresa">No hay registros de Horas Extras para esta empresa</cf_translate></strong>
		&nbsp;</td>
	</tr>  
	 <tr><td><hr width="100%" size="0" color="##000000"></td></tr>
</cfif>
<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 and rsProc.RecordCount EQ 0 >
	<tr > 
		<td colspan="6" align="center"><font size="2"><strong><cf_translate  key="LB_Desde">Desde</cf_translate>: &nbsp;</strong>#form.fdesde#<strong>&nbsp; <cf_translate  key="LB_Hasta">Hasta</cf_translate>: &nbsp;</strong> #form.fhasta#</font>
		&nbsp;</td>
	</tr>  
</cfif>
</table>
</cfoutput>

<cfif rsProc.RecordCount NEQ 0>
	
		
		<cfset IdEmpleado = 0>
		<cfset descripcion = "">
		<cfset supervisor = "">
		<cfset TotalExtrasSP = 0>
		<cfset TotalExtrasCF = 0>
		
		<cfset NumLinea = 1>
		<cfset temp = 0> <!--- Controla si esta cerrado el periodo de Extras --->
<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
  <cfoutput query="rsProc" startRow="#StartRow_rsProc#" maxRows="#MaxRows_rsProc#">
  	<cfflush interval="512">
		<cfif descripcion NEQ rsProc.centro>
			
			<cfset TotalExtrasCF = 0>
			<cfset descripcion = rsProc.centro>
			<!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center"> --->
				<tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr>
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>: &nbsp;</strong>#rsProc.CFdescripcion#<strong></strong></font>&nbsp;</td>
				</tr>
			<!--- </table> --->
		</cfif>
		
		<cfif  supervisor NEQ rsProc.NombreUsuario > <!--- len(trim(supervisor)) NEQ 0 and --->
			
			<!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center"> --->
				<cfif len(trim(supervisor)) NEQ 0>
					<tr class="listaCorte" >
						<td width="50%" colspan="5"><cf_translate  key="LB_TotalDeHorasExtrasAutorizadasPorSupervisor">Total de Horas Extras Autorizadas por Supervisor</cf_translate>: #supervisor#</td>
						<td width="10%" align="right" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>"><strong>#LSNumberFormat(TotalExtrasSP,',9.00')#</strong></td>
						
					</tr>
				</cfif>
				<tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr>
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong><cf_translate  key="LB_Supervisor">Supervisor</cf_translate>: &nbsp;</strong>#rsProc.NombreUsuario#<strong></strong></font>&nbsp;</td>
				</tr>
			<!--- </table> --->
			<cfset Supervisor = rsProc.NombreUsuario>
		</cfif>	
				
		<cfif IdEmpleado NEQ rsProc.cedula >
			<cfset IdEmpleado = rsProc.cedula>
			<!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center"> --->
				
				<tr> 
					<td colspan="6" align="center">
						<font size="2"><strong><cf_translate  key="LB_Funcionario">Funcionario</cf_translate>: &nbsp; #rsProc.cedula# - #rsProc.NombreEmpleado#</strong></font>
					</td>
				</tr>
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong><cf_translate  key="LB_Puesto">Puesto</cf_translate>: &nbsp;</strong>#rsProc.RHPdescpuesto#<strong></strong></font>
					&nbsp;</td>
				</tr>  
				<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 >
					<tr > 
						<td colspan="6" align="center"><font size="2"><strong><cf_translate  key="LB_Desde">Desde</cf_translate>: &nbsp;</strong>#form.fdesde#<strong>&nbsp; <cf_translate  key="LB_Hasta">Hasta</cf_translate>: &nbsp;</strong> #form.fhasta#</font>
						&nbsp;</td>
					</tr>  
				</cfif>
				<tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr>
				<tr class="listaCorte" >
						<td width="10%"><cf_translate  key="LB_FechaMarca">Fecha Marca</cf_translate>:</td>
						<td width="10%" align="center"><cf_translate  key="LB_FechaMarca">Fecha Marca</cf_translate>Marca Entrada:</td>
						<td width="10%" align="center"><cf_translate  key="LB_FechaMarca">Fecha Marca</cf_translate>Marca Salida:</td>
						<td width="10%" align="center"><cf_translate  key="LB_EntradaAutorizada">Entrada Autorizada</cf_translate>:</td>
						<td width="10%" align="center"><cf_translate  key="LB_SalidaAutorizada">Salida Autorizada</cf_translate>:</td>
						<td width="10%" align="left"><cf_translate    key="LB_HorasExtrasAut">Horas extras Aut.</cf_translate></td>
						
						<!--- <td width="10%"><strong>Acci&oacute;n Reportada</strong></td> --->
				</tr>
			<!--- </table> --->
		</cfif>				
		<!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center"> --->
			<cfset NumLinea = NumLinea + 1>
			<cfset TotalExtrasCF = TotalExtrasCF + rsProc.RHCMhorasadicautor>
			<cfset TotalExtrasSP = TotalExtrasSP + rsProc.RHCMhorasadicautor>
			<tr>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMfcapturada#</td>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHCMhoraentrada#</td>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHCMhorasalida#</td>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHCMhoraentradac#</td>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHCMhorasalidac#</td>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="right">#LSNumberFormat(rsProc.RHCMhorasadicautor,',9.00')#</td>
				<!--- <td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHCMhorasrebajar#</td>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.RHASdescripcion#</td>
				--->
			</tr>
			<cfif len(trim(rsProc.RHPMfcierre)) EQ 0>
				<cfset temp = temp + 1>						
			</cfif>
	</cfoutput>
<cfoutput>
	
	<tr class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" >
		<td width="50%" colspan="5" ><strong><cf_translate    key="LB_TotalDeHorasExtrasAutorizadasPorSupervisor">Total de Horas Extras Autorizadas por Supervisor</cf_translate>:</strong> #supervisor#</td>
		<td width="10%" align="right" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>"><strong>#LSNumberFormat(TotalExtrasSP,',9.00')#</strong></td>
	</tr>
</cfoutput>
	<tr> 
		<td colspan="6" align="center">&nbsp;</td>
	</tr>  
	<cfif #temp# GT 0>
		<tr > 
			<td colspan="6" align="left"><strong><cf_translate   key="LB_EsteReporteEsDeCaracterTemporalYaQueNoSeHaCerradoElProcesamientoDeMarcas">Este reporte es de car&aacute;cter temporal , ya que no se ha cerrado el Procesamiento de marcas.</cf_translate></strong></td>
		</tr>  
	</cfif>
	<tr > 
		<td colspan="6" align="center">&nbsp;</td>
	</tr>  
	
		<tr > 
			<td colspan="6" align="center"><strong>------------------------------
				<cf_translate  key="LB_FinDelReporte">Fin del Reporte</cf_translate>
			--------------------------------------</strong>	&nbsp;
			</td>
		</tr>  
  </table>

</cfif>			    

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
      	<td colspan="6" align="center">
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
  </cfoutput>
</table>
