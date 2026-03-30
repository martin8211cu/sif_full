<!---Caso en que la pantalla se consultada desde el sistema diferente de pso. 
entonces define la empresa en que se encuentra actualmente para poner valores por defecto  CarolRS--->
<cfset inactivo = "">
<cfif session.usuario NEQ 'pso'>
	<cfset form.CEcodigo= session.CEcodigo>
	<cfset form.Ecodigo= session.ecodigosdc>
	<cfset inactivo = "disabled">
</cfif>

<cf_templateheader title="Comportamiento de Acci&oacute;n Masiva">
<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="Cargas Iniciales">


<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsetting requesttimeout="20000">
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfif not (IsDefined("form.CDPid") and Len(Trim(form.CDPid))
	and IsDefined("form.btnReporte") and Len(Trim(form.btnReporte)))>
<!---<cf_templateheader title="#nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">

	<cf_web_portlet_start skin = "box">--->
</cfif>
	<!--- 	******************************************
			Como  header  de  todo  el  funcionamiento 
			de  este  proceso  se  encuentra un filtro 
			por Cuenta Empresarial, Empresa, y Módulo. 
			****************************************** --->
	<cfquery name="rsCE" datasource="asp">
		select CEcodigo, CEnombre
		from CuentaEmpresarial
		order by CEnombre
	</cfquery>
	<cfif isdefined("form.CEcodigo") and form.CEcodigo GT 0>
		<cfquery name="rsE" datasource="asp">
			select Ecodigo, Enombre, Ereferencia
			from Empresa
			where CEcodigo = #form.CEcodigo#
			order by Enombre
		</cfquery>
		<cfif isdefined("form.Ecodigo") and form.Ecodigo GT 0>		
			<cfquery name="rsSS" datasource="asp">
				select SScodigo, SSdescripcion
				from SSistemas
				order by SScodigo
			</cfquery>
			<cfquery name="rsC" datasource="asp">
				select Ccache, Ereferencia
				from Empresa a
					inner join Caches b
					on b.Cid = a.Cid
				where a.Ecodigo = #form.Ecodigo#
				and a.CEcodigo = #form.CEcodigo#
			</cfquery>
			<cfset Gvar.Ecodigo = rsC.Ereferencia>
			<cfset Gvar.Conexion = rsC.Ccache>
			<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))
					and isdefined("form.CDPid") and form.CDPid gt 0>
				<cfquery name="rsData" datasource="asp">
					select CDPtabla, CDPtablaCarga, CDPrutaValida, CDPrutaProcesa
					from CDParametros
					where Ecodigo = #form.Ecodigo#
					and SScodigo = '#form.SScodigo#' 
					and CDPid = #form.CDPid#
				</cfquery>
				<cfset Gvar.table_dest=rsData.CDPtabla>
				<cfset Gvar.table_name=rsData.CDPtablaCarga>
				<cfset Gvar.rutaValida=rsData.CDPrutaValida>
				<cfset Gvar.rutaProcesa=rsData.CDPrutaProcesa>
			</cfif>
		</cfif>
	</cfif>
	<cfif not (IsDefined("form.CDPid") and Len(Trim(form.CDPid))
	and IsDefined("form.btnReporte") and Len(Trim(form.btnReporte)))>
	<form name="formfiltrosup" 
			method="post"
			action="#currentpage#" 
			style="margin:0">
		<table width="100%" 
				align="center"
				style="margin:0"
				border ="0"
				cellspacing="0"
				cellpadding="0"
				class="tituloListas">
		<tr>
		<td width="100%" align="left">
		<table width="1%" 
				align="center"
				style="margin:0"
				border ="0"
				cellspacing="0"
				cellpadding="0"
				class="tituloListas">
			<tr>
				<td width="1%" 
						class="etiqueta" 
						nowrap>
					Cuenta Empresarial&nbsp;:&nbsp;
				</td>
				<td width="1%">
					<select name="CEcodigo" onchange="javascript:this.form.submit();" <cfoutput>#inactivo#</cfoutput>>
						<option value=""></option>
						<cfoutput query="rsCE">
						<cfset selected = iif(IsDefined("form.CEcodigo") and form.CEcodigo eq CEcodigo,DE("selected"),DE(""))>
						<option value="#CEcodigo#" #selected#>#CEnombre#</option>
						</cfoutput>
					</select>
				</td>
				<td rowspan="3" valign="bottom" width="98%" align = "left"> <cf_botones values="Ir"> </td>
			</tr>
			<cfif isdefined("form.CEcodigo") and form.CEcodigo GT 0>
				<tr>
					<td class="etiqueta" 
							nowrap>
						Empresa&nbsp;:&nbsp;
					</td>
					<td>
						<select name="Ecodigo" onchange="javascript:this.form.submit();" <cfoutput>#inactivo#</cfoutput>>
							<option value=""></option>
							<cfoutput query="rsE">
							<cfset selected = iif(IsDefined("form.Ecodigo") and form.Ecodigo eq Ecodigo,DE("selected"),DE(""))>
							<option value="#Ecodigo#" #selected#>#Enombre#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<cfif isdefined("form.Ecodigo") and form.Ecodigo GT 0>
					<tr>
						<td class="etiqueta" 
								nowrap>
							Sistema&nbsp;:&nbsp;
						</td>
						<td>
							<select name="SScodigo" onchange="javascript:this.form.submit();" >
								<option value=""></option>
								<cfoutput query="rsSS">
								<cfset selected = iif(IsDefined("form.SScodigo") and form.SScodigo eq SScodigo,DE("selected"),DE(""))>
								<option value="#SScodigo#" #selected#>#SSdescripcion#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
				</cfif>
			</cfif>
		</table>
		</td>
		</tr>
		</table>
	</form>
	</cfif>
	<cfif isdefined("form.CEcodigo") and form.CEcodigo GT 0
			and isdefined("form.Ecodigo") and form.Ecodigo GT 0
			and isdefined("form.SScodigo") and form.SScodigo GT 0>
		<cfquery datasource="asp" name="rsThisSS">
			select SScodigo, SSdescripcion
			from SSistemas
			where SScodigo = '#form.SScodigo#'
		</cfquery>
		<table width="100%" 
					align="center"
					style="margin:0"
					border ="0"
					cellspacing="0"
					cellpadding="0">
			<cfif IsDefined("form.CDPid") and Len(Trim(form.CDPid))
					and IsDefined("form.btnGenerar") and Len(Trim(form.btnGenerar))>
				<cfinclude template="generar.cfm">
			<cfelseif IsDefined("form.CDPid") and Len(Trim(form.CDPid))
					and IsDefined("form.btnReporte") and Len(Trim(form.btnReporte))>
				<cfinclude template="reporte.cfm">
			<cfelseif IsDefined("form.CDPid") and Len(Trim(form.CDPid)) and isdefined("form.BTNGenerarCarga") and form.BTNGenerarCarga EQ 1> 
				<tr>
					<td align="center" class ="tituloListas">
						Resumen de Resultados de Validaci&oacute;n de Carga de <cfoutput>#Gvar.table_name#</cfoutput>
					</td>
				</tr><!---<cfdump var="#form#">--->
				<cfinclude template="validar.cfm">
			<cfelse>
				<tr>
					<td align="center" class ="tituloListas">
						Lista Cargas Iniciales de <cfoutput>#rsThisSS.SScodigo# - #rsThisSS.SSdescripcion#</cfoutput>
					</td>
				</tr>
				<tr>
					<td>
						<cfinclude template="lista.cfm">
					</td>
				</tr>
			</cfif>
		</table>
	</cfif>
	<cfif not (IsDefined("form.CDPid") and Len(Trim(form.CDPid))
	and IsDefined("form.btnReporte") and Len(Trim(form.btnReporte)))>
	<cf_web_portlet_end>
	<cf_web_portlet_end>
<cf_templatefooter>
</cfif>