<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cfparam name="PageNum_rsProc" default="1">

<cfif isDefined("Url.Usuario") and not isDefined("Form.Usuario")>
  <cfset Form.Usuario = Url.Usuario>
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
	select p.RHPJfinicio
		 ,p.RHPJffinal
		 ,j.RHJdescripcion
		 ,coalesce((select  R2.RHJdescripcion
			from  LineaTiempo lt, RHJornadas R2
			  where lt.RHJid = R2.RHJid 
				and lt.DEid = g.DEid
				and p.RHPJfinicio between lt.LTdesde and lt.LThasta), j.RHJdescripcion ) as ltJornada
		,{fn concat({fn concat({fn concat({ fn concat(rtrim(g.DEnombre), ' ') },rtrim(g.DEapellido1))}, ' ')},rtrim(g.DEapellido2)) } as NombreEmpleado
		,g.DEidentificacion as cedula 
		,cf.CFid
		,cf.CFdescripcion as centro
		,{fn concat({fn concat({fn concat({ fn concat(rtrim(c1.Pnombre), ' ') },rtrim(c1.Papellido1))}, ' ')},rtrim(c1.Papellido2)) } as NombreUsuario
		,rhp.RHPdescripcion
		,rhpu.RHPdescpuesto 
	from RHPlanificador p
		,RHJornadas j
		,DatosEmpleado g
		,RHPlazas rhp
		,RHPuestos rhpu
		,LineaTiempo lt
		,CFuncional cf
		,Usuario b1
		,DatosPersonales c1
	where  g.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
			and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
		</cfif>
		<cfif isdefined("form.Usuario") and len(trim(form.Usuario)) NEQ 0>
			and b1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.Usuario#">
		</cfif>
		<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
			and p.RHPJfinicio >= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(fdesde,'YYYYMMDD')#">
		  	and p.RHPJfinicio <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(fhasta,'YYYYMMDD')#">
		</cfif> 
		  and p.RHJid = j.RHJid
		  and g.DEid = p.DEid
		  and rhp.RHPid = lt.RHPid
		  and lt.RHPcodigo = rhpu.RHPcodigo
		  and rhpu.Ecodigo = g.Ecodigo
		  and lt.Ecodigo = g.Ecodigo
		  and lt.DEid  = g.DEid
		  and p.RHPJfinicio between lt.LTdesde and lt.LThasta
		  and cf.CFid = rhp.CFid
		  and p.RHPJusuario = b1.Usucodigo 
		  and b1.datos_personales = c1.datos_personales 
	order by 8,6,1
</cfquery>

<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
	<!--- Centro Funcional ---->
	<cfquery name="rsCentro" datasource="#session.DSN#">
		select CFdescripcion as Centro, CFid
		from CFuncional 
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_centro#">
	</cfquery>
</cfif>

<cfif isdefined("form.Usuario") and len(trim(form.Usuario)) NEQ 0 and rsProc.RecordCount EQ 0>
	<cfquery name="rsUsuario" datasource="asp">
		select {fn concat({fn concat({fn concat({ fn concat(rtrim(c1.Pnombre), ' ') },rtrim(c1.Papellido1))}, ' ')},rtrim(c1.Papellido2)) } as NombreUsuario
		from Usuario b1, DatosPersonales c1
		where b1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.Usuario#">
		and b1.datos_personales = c1.datos_personales 
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
	<tr > 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
	</tr>
	<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_Reporte_de_cambios_de_jornada" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Reporte de Cambios de Jornada</cf_translate></strong></td>		</strong>
	</tr>
	
</table>
<table width="85%" border="0" cellpadding="2" cellspacing="0" align="center" >
	<cfif rsProc.RecordCount EQ 0>
		<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0 >
			<!--- <tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr> --->
			<tr > 
				<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Centro Funcional:<cfif rsProc.RecordCount gt 0>#rsProc.CFdescripcion#<cfelse>#rsCentro.Centro# no tiene Marcas.</cfif></strong></td>
			</tr>
			<tr><td nowrap><hr width="100%" size="0" color="##000000"></td></tr>
		</cfif>
		
		<cfif not isdefined("rsCentro") >
			<!--- <tr><td><hr width="100%" size="0" color="##000000"></td></tr> --->
			<tr > 
				<td colspan="8" align="center"><strong><cf_translate key="LB_No_hay_registrados_cambios_de_jornada_para_esta_empresa" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">No hay registrados Cambios de Jornada para esta empresa</cf_translate></strong>
				&nbsp;</td>
			</tr>  
			 <tr><td><hr width="100%" size="0" color="##000000"></td></tr>
		</cfif>
		<cfif isdefined("form.Usuario") and len(trim(form.Usuario)) NEQ 0>
			<tr > 
				<td colspan="6" align="center"><font size="2"><strong><cf_translate key="LB_Supervisor" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Supervisor:</cf_translate> &nbsp;</strong>#rsUsuario.NombreUsuario#<strong></strong></font>&nbsp;</td>
			</tr>
		</cfif>
		<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 >
			<tr > 
				<td colspan="8" align="center"><font size="2"><strong><cf_translate key="LB_Desde" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Desde: </cf_translate>&nbsp;</strong>#form.fdesde#<strong>&nbsp; <cf_translate key="LB_Hasta" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Hasta:</cf_translate> &nbsp;</strong> #form.fhasta#</font>
				&nbsp;</td>
			</tr>  
		</cfif>
	</cfif>
</table>	
</cfoutput>

<cfif rsProc.RecordCount NEQ 0>
		<cfset descripcion = "">
		<cfset supervisor = "">
		<cfset cambioCentro = 0>
		<cfset NumLinea = 1>

  <cfoutput query="rsProc" startRow="#StartRow_rsProc#" maxRows="#MaxRows_rsProc#">
  	<cfflush interval="512">
		<cfif descripcion NEQ rsProc.centro>
			<cfset cambioCentro = 1>
			<cfset descripcion = rsProc.centro>
			<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
				<tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr> 
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong><cf_translate key="LB_Centro_Funcional" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Centro Funcional: </cf_translate>&nbsp;</strong>#rsProc.centro#<strong></strong></font>&nbsp;</td>
				</tr>
			</table>
		</cfif>
		<cfif  supervisor NEQ rsProc.NombreUsuario  or cambioCentro EQ 1> <!--- len(trim(supervisor)) NEQ 0 and --->
			<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
				<tr > 
					<td colspan="6" align="center"><font size="2"><strong><cf_translate key="LB_Supervisor" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Supervisor:</cf_translate> &nbsp;</strong>#rsProc.NombreUsuario#<strong></strong></font>&nbsp;</td>
				</tr>
				<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) neq 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) neq 0 >
					<tr > 
						<td colspan="6" align="center"><font size="2"><strong><cf_translate key="LB_Desde" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Desde:</cf_translate> &nbsp;</strong>#form.fdesde#<strong>&nbsp; <cf_translate key="LB_Hasta" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Hasta:</cf_translate> &nbsp;</strong> #form.fhasta#</font>
						&nbsp;</td>
					</tr>  
				</cfif>
				<tr><td colspan="6"><hr width="100%" size="0" color="##000000"></td></tr>
				<tr class="listaCorte" >
					<td width="10%" align="left"><strong><cf_translate key="LB_Identificacion" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Identificaci&oacute;n:</cf_translate></strong></td>
					<td width="30%" align="left"><strong><cf_translate key="LB_Funcionario" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Funcionario:</cf_translate></strong></td>
					<td width="15%" align="center"><strong><cf_translate key="LB_Fecha_Inicio_Cambio_de_Jornada" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Fecha Inicio Cambio de Jornada:</cf_translate></strong></td>
					<td width="15%" align="center"><strong><cf_translate key="LB_Fecha_Fin_cambio_de_Jornada" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Fecha Fin cambio de Jornada:</cf_translate></strong></td>
					<td width="15%" align="center"><strong><cf_translate key="LB_Jornada_Empleado" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Jornada Empleado:</cf_translate></strong></td>
					<td width="15%" align="center"><strong><cf_translate key="LB_Jornada_Asignada" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Jornada Asignada:</cf_translate></strong></td>
				</tr>
				
<!--- 			</table> --->
			<cfset Supervisor = rsProc.NombreUsuario>
		</cfif>	
		<!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center"> --->
			<cfset NumLinea = NumLinea + 1>
			<tr>
				<td width="10%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.cedula#</td>
				<td width="30%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="left">#rsProc.NombreEmpleado#</td>
				<td width="15%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#LSDateformat(rsProc.RHPJfinicio,"dd/mm/yyyy")#</td>
				<td width="15%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#LSDateformat(rsProc.RHPJffinal,"dd/mm/yyyy")#</td>
				<td width="15%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.RHJdescripcion#</td>
				<td width="15%" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>" align="center">#rsProc.ltJornada#</td>
			</tr>
						
			<cfset cambioCentro = 0>
	</cfoutput>
	<tr> 
		<td colspan="6" align="center">&nbsp;</td>
	</tr>  
	<tr > 
		<td colspan="6" align="center"><strong>------------------------------
			<cf_translate key="LB_Fin_del_Reporte" xmlfile="/rh/marcas/consultas/CambiosJornada-form.xml">Fin del Reporte</cf_translate>
		--------------------------------------</strong>	&nbsp;
		</td>
	</tr>  
		
	</table>

</cfif>			    

<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
  <cfset params= "">
	<cfif isDefined("form.Usuario") and len(trim(form.Usuario)) neq 0>
	 <cfset params = params & '&Usucodigo=' & #form.Usuario# >
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
          <a href="#CurrentPage#?PageNum_rsProc=1#params#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a>
        </cfif>
        <cfif PageNum_rsProc GT 1>
          <a href="#CurrentPage#?PageNum_rsProc=#Max(DecrementValue(PageNum_rsProc),1)##params#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a>
        </cfif>
        <cfif PageNum_rsProc LT TotalPages_rsProc>
          <a href="#CurrentPage#?PageNum_rsProc=#Min(IncrementValue(PageNum_rsProc),TotalPages_rsProc)##params#"><img  src="/cfmx/rh/imagenes/Next.gif" border=0></a>
        </cfif>
        <cfif PageNum_rsProc LT TotalPages_rsProc>
          <a href="#CurrentPage#?PageNum_rsProc=#TotalPages_rsProc##params#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a>
        </cfif>
      </td>
    </tr>
  </cfoutput>
</table>
