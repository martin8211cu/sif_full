<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cfparam name="PageNum_rsProc" default="1">

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
	<!----set nocount on--->
	select a.RHUMid
		,rtrim({fn concat({fn concat({fn concat({ fn concat(rtrim(c1.Pnombre), ' ') }, rtrim(c1.Papellido1))}, ' ')},rtrim(c1.Papellido2)) }) as NombreUsuario
		,d.CFdescripcion as Centro
		,d.CFid  
		,rtrim({fn concat({fn concat({fn concat({ fn concat(g.DEnombre, ' ') },g.DEapellido1)}, ' ')},g.DEapellido2) }) as NombreEmpleado
		,convert(varchar,RHCMfcapturada, 103) as RHCMfcapturada
		,substring(convert(varchar,RHCMhoraentrada,108),1,5) as RHCMhoraentrada
		,substring(convert(varchar,RHCMhorasalida,108),1,5) as RHCMhorasalida
		,substring(convert(varchar,RHCMhoraentradac,108),1,5) as RHCMhoraentradac
		,substring(convert(varchar,RHCMhorasalidac,108),1,5) as RHCMhorasalidac
		,coalesce(RHCMhorasrebajar,0) as RHCMhorasrebajar
		,cia.Enombre as Enombre
		,g.DEidentificacion as cedula
		,d.CFdescripcion
		,rhp.RHPdescripcion
		,rhpu.RHPdescpuesto 
		,coalesce(RHCMhorasadicautor,0) as RHCMhorasadicautor
		,substring(h.RHASdescripcion,1,35) as RHASdescripcion
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
		,RHAccionesSeguir h 
		,Empresa cia 
		,RHPlazas rhp
		,RHPuestos rhpu
	
	where g.Ecodigo=  <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
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
		and #now()# between lt.LTdesde and lt.LThasta
		and lt.DEid  = g.DEid
		and a.Usucodigo = b1.Usucodigo 
		and f.RHCMusuarioautor = a.Usucodigo
		and b1.datos_personales = c1.datos_personales 
		and h.RHASid = f.RHASid
		and cia.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.EcodigoSDC#">
		and rhp.RHPid = lt.RHPid
		and lt.RHPcodigo = rhpu.RHPcodigo
		and rhpu.Ecodigo = g.Ecodigo
		and lt.Ecodigo = g.Ecodigo
		
		order by 3,18,5

		<!----set nocount off---->
</cfquery>
<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
	<!--- Centro Funcional ---->
	<cfquery name="rsCentro" datasource="#session.DSN#">
		select CFdescripcion as Centro, CFid
		from CFuncional 
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_centro#">
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
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
	<tr> 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
	</tr>
	<tr> 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_Acciones_Reportadas_Con_Base_En_El_Control_de_Asistenci" xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Acciones Reportadas con Base en el Control de Asistencia</cf_translate></strong></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0 and rsProc.RecordCount EQ 0>

		<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
		<tr > 
			<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Centro Funcional:<cfif rsProc.RecordCount gt 0>#rsProc.CFdescripcion#<cfelse>#rsCentro.Centro# no tiene Marcas.</strong></cfif></td>
		</tr>
		<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
</cfif>
<cfif not isdefined("rsCentro") and rsProc.RecordCount EQ 0 >

	<tr><td><hr width="100%" size="0" color="##000000"></td></tr>
	<tr > 
		<td colspan="8" align="center"><strong><cf_translate key="LB_No_hay_registros_de_Acciones_reportadas_para_esta_empresa"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">No hay registros de Acciones Reportadas para esta empresa</cf_translate></strong>
		&nbsp;</td>
	</tr>  
	 <tr><td><hr width="100%" size="0" color="##000000"></td></tr>
</cfif>
<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 and rsProc.RecordCount EQ 0 >
	<tr > 
		<td colspan="8" align="center"><font size="2"><strong><cf_translate key="LB_Desde"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Desde</cf_translate>: &nbsp;</strong>#form.fdesde#<strong>&nbsp; <cf_translate key="LB_Hasta"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Hasta</cf_translate>: &nbsp;</strong> #form.fhasta#</font>
		&nbsp;</td>
	</tr>  
</cfif>
</table>
</cfoutput>


<cfif rsProc.RecordCount NEQ 0>

		
		<cfset NomAccion = "">
		<cfset descripcion = "">
		<cfset supervisor = "">
		<cfset cambioCentro = 0>
		
		<cfset NumLinea = 1>
		<cfset temp = 0> <!--- Controla si esta cerrado el periodo de Extras --->

  <cfoutput query="rsProc" startRow="#StartRow_rsProc#" maxRows="#MaxRows_rsProc#">
  	<cfflush interval="512">
		<cfif descripcion NEQ rsProc.centro>
			<cfset cambioCentro = 1>
			<cfset descripcion = rsProc.centro>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
				<tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr>
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong><cf_translate key="LB_Centro_Funcional"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Centro Funcional</cf_translate>: &nbsp;</strong>#rsProc.CFdescripcion#<strong></strong></font>&nbsp;</td>
				</tr>
				
				
			</table>
		</cfif>
		
		<cfif  supervisor NEQ rsProc.NombreUsuario  or cambioCentro EQ 1> <!--- len(trim(supervisor)) NEQ 0 and --->
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
				
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong>Supervisor: &nbsp;</strong>#rsProc.NombreUsuario#<strong></strong></font>&nbsp;</td>
				</tr>
				<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 >
					<tr > 
						<td colspan="6" align="center"><font size="2"><strong>Desde: &nbsp;</strong>#form.fdesde#<strong>&nbsp; Hasta: &nbsp;</strong> #form.fhasta#</font>
						&nbsp;</td>
					</tr>  
				</cfif>
				<tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr>
			</table>
			<cfset Supervisor = rsProc.NombreUsuario>
		</cfif>	
		
		<cfif NomAccion NEQ rsProc.RHASdescripcion  or cambioCentro EQ 1>
			<cfset NomAccion = rsProc.RHASdescripcion>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
				<!--- <tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr> --->
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong><cf_translate key="LB_Accion_Asociada"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Accion Asociada</cf_translate>: &nbsp;</strong>#rsProc.RHASdescripcion#<strong></strong></font>
					&nbsp;</td> 
				</tr>  
				<tr class="listaCorte" >
					<td width="10%" align="left"><strong><cf_translate key="LB_Identificacion"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Identificaci&oacute;n</cf_translate>:</strong></td>
					<td width="30%" align="left"><strong><cf_translate key="LB_Funcionario"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Funcionario</cf_translate>:</strong></td>
					<td width="20%" align="center"><strong><cf_translate key="LB_Fecha_Marca"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Fecha Marca</cf_translate>:</strong></td>
					<td width="20%" align="center"><strong><cf_translate key="LB_Marca_Entrada"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Marca Entrada</cf_translate>:</strong></td>
					<td width="20%" align="center"><strong><cf_translate key="LB_Marca_Salida"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Marca Salida</cf_translate>:</strong></td>
				</tr>
			</table>
		</cfif>
		
						
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
			<cfset NumLinea = NumLinea + 1>
			
			<tr>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.cedula#</td>
				<td width="30%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.NombreEmpleado#</td>
				<td width="20%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHCMfcapturada#</td>
				<td width="20%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHCMhoraentrada#</td>
				<td width="20%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHCMhorasalida#</td>

			</tr>
			<cfif len(trim(rsProc.RHPMfcierre)) EQ 0>
				<cfset temp = temp + 1>						
			</cfif>
			<cfset cambioCentro = 0>
	</cfoutput>
	<tr> 
		<td colspan="6" align="center">&nbsp;</td>
	</tr>  
	<cfif #temp# GT 0>
		<tr > 
			<td colspan="6" align="left"><strong><cf_translate key="MSG_Este_reporte_es_de_caracter_temporal_porque_no_se_ha_cerrado_el_procesamiento_de_marcas"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Este reporte es de car&aacute;cter temporal , ya que no se ha cerrado el Procesamiento de marcas.</cf_translate></strong></td>
		</tr>  
	</cfif>
	<tr > 
		<td colspan="6" align="center">&nbsp;</td>
	</tr>  
	</tr>  
	<tr > 
		<td colspan="6" align="center"><strong>------------------------------
			<cf_translate key="LB_Fin_del_Reporte"  xmlfile="/rh/marcas/consultas/AccionesRep-form.xml">Fin del Reporte</cf_translate>
		--------------------------------------</strong>	&nbsp;
		</td>
	</tr>  
		
	</table>
</cfif>			    

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
  <cfset params= "">
	
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
  </cfoutput>
</table>
