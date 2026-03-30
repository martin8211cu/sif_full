	<cfset LvarProyectos = (isdefined("session.menues.SMCODIGO") AND session.menues.SMCODIGO EQ "PROY")>

<cfif isdefined('Form.CPPid') and Len(Trim(Form.CPPid))>
	<cfset session.CPPid = form.CPPid>
</cfif>
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid
	  from CPresupuestoPeriodo p inner join Monedas m on p.Mcodigo=m.Mcodigo
	 where p.Ecodigo = #Session.Ecodigo#
	   and p.CPPestado <>0
	 order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>

<cfif rsPeriodos.CPPid EQ "">
	<BR>
	<div style="color:#FF0000; text-align:center">
	No existen Periodos de Presupuesto Abiertos
	</div>
	<BR>
	<cfexit>
</cfif>

<cfparam name="session.CPPid" default="#rsPeriodos.CPPid#">

<!--- <cfif isdefined("url.filtroCmayor") and Len(Trim(url.filtroCmayor))>
	<cfparam name="Form.filtroCmayor" default="#Url.filtroCmayor#">
</cfif>
<cfif isdefined("url.filtroCPformato") and Len(Trim(url.filtroCPformato))>
	<cfparam name="Form.filtroCPformato" default="#Url.filtroCPformato#">
</cfif>
<cfif isdefined("url.filtroCPdescripcion") and Len(Trim(url.filtroCPdescripcion))>
	<cfparam name="Form.filtroCPdescripcion" default="#Url.filtroCPdescripcion#">
</cfif> --->

<cf_navegacion name="filtroCmayor"			session default="">
<cf_navegacion name="filtroCPformato"		session default="">
<cf_navegacion name="filtroCPdescripcion"	session default="">

<cfset LvarCmayor = ''>
<cfif isdefined("form.filtroCmayor") and len(trim(form.filtroCmayor))>
	<cfset LvarCmayor = trim(form.filtroCmayor)>
<cfelse>
	<cfif isdefined("form.filtroCPformato") and (len(trim(form.filtroCPformato)) EQ 4 or len(trim(form.filtroCPformato)) GT 4 and mid(trim(form.filtroCPformato),5,1) EQ "-")>
		<cfset LvarCmayor = mid(form.filtroCPformato,1,4)>
	<cfelseif isdefined("form.Cmayor") and len(trim(form.Cmayor))>
		<cfset LvarCmayor = trim(form.Cmayor)>
	<cfelseif isdefined("form.CPformato") and (len(trim(form.CPformato)) EQ 4 or len(trim(form.CPformato)) GT 4 and mid(trim(form.CPformato),5,1) EQ "-")>
		<cfset LvarCmayor = mid(form.CPformato,1,4)>
	</cfif>
	<cfif Len(trim(LvarCmayor))>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select Cmayor
			  from CtasMayor
			 where Ecodigo = #Session.Ecodigo#
			   and Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCmayor#">
		</cfquery>
		<cfset LvarCmayor = rsSQL.Cmayor>
	</cfif>
</cfif>

<cfquery name="rsCtasMayor" datasource="#Session.DSN#">
	select m.Cmayor, m.Cdescripcion
	  from CtasMayor m
	  	inner join CPVigencia v
			inner join PCEMascaras mk
				 on mk.PCEMid = v.PCEMid
				and mk.PCEMformatoP is not null
			 on v.Ecodigo = m.Ecodigo
			and v.Cmayor = m.Cmayor
	 where m.Ecodigo = #Session.Ecodigo#
	<cfif LvarProyectos>
	   and exists 
	   		(
				Select 1
				  from PRJproyecto prj
				 where prj.Ecodigo = m.Ecodigo
				   and prj.Cmayor = m.Cmayor
			)
	</cfif>
	 order by m.Cmayor
</cfquery>
<cf_CPSegUsu_setCFid>
<cfif Len(trim(LvarCmayor)) EQ 0 and session.CPsegUsu.CFid LTE -1 AND NOT LvarProyectos>
	<cfset LvarCmayor = rsCtasMayor.Cmayor>
</cfif>

<cfset filtro = "">
<!--- <cfset navegacion = ""> --->

<cfif isdefined("session.CPPid") and Len(Trim(session.CPPid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & session.CPPid>
</cfif>

<!--- <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtroCmayor=" & LvarCmayor> --->

<cfif isdefined("Form.filtroCPformato") and Len(Trim(Form.filtroCPformato))>
	<cfset filtro = filtro & " and upper(CPformato) like " & "'%#ucase(trim(Form.filtroCPformato))#%' ">
	<!--- <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtroCPformato=" & Form.filtroCPformato> --->
</cfif>
<cfif isdefined("Form.filtroCPdescripcion") and Len(Trim(Form.filtroCPdescripcion))>
	<cfset filtro = filtro & " and upper(coalesce(CPdescripcionF,CPdescripcion)) like " & "'%#ucase(trim(Form.filtroCPdescripcion))#%' ">
	<!--- <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtroCPdescripcion=" & Form.filtroCPdescripcion> --->
</cfif>

<cfif LvarProyectos>
	<cfset filtro = filtro & "
	   and exists 
	   		(
				Select 1
				  from PRJproyecto prj
				 where prj.Ecodigo = a.Ecodigo
				   and prj.Cmayor  = a.Cmayor
			)
	">
</cfif>

<cfoutput>
<form name="filtroAcciones" method="post" action="ConsPresupuesto.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  <tr> 
    <td class="fileLabel" nowrap width="1">
		Per&iacute;odo&nbsp;Presupuestario:
	</td>
	<td width="1">
		<cf_cboCPPid value="#session.CPPid#" onChange="this.form.submit();" CPPestado="1,2">
	</td>
    <td class="fileLabel" nowrap>
		Centro Funcional:
	</td>
	<td width="1">
		<cf_CPSegUsu_cboCFid value="#form.CFid#" Consultar="true">
	</td>
    <td class="fileLabel" colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td class="fileLabel">Cuenta Mayor<cfif LvarProyectos> para Proyectos</cfif>:</td>
	<td>
		<select name="FiltroCmayor">
			<option value="">(Todas las Cuentas de Mayor)</option>
		<cfloop query="rsCtasMayor">
			<option value="#rsCtasMayor.Cmayor#" <cfif rsCtasMayor.Cmayor EQ LvarCmayor>selected</cfif>>
				#rsCtasMayor.Cmayor# - #rsCtasMayor.Cdescripcion#
			</option>
		</cfloop>
		</select>
	</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td class="fileLabel">Cuenta:</td>
	<td>
		<input type="text" name="filtroCPformato" value="<cfif isdefined('form.filtroCPformato') and form.filtroCPformato NEQ ''>#form.filtroCPformato#</cfif>" size="40"  maxlength="100">
	</td>
    <td class="fileLabel">Descripcion:</td>
	<td>
		<input type="text" name="filtroCPdescripcion" value="<cfif isdefined('form.filtroCPdescripcion') and form.filtroCPdescripcion NEQ ''>#form.filtroCPdescripcion#</cfif>" size="40" maxlength="100">
	</td>
	<td>
	</td>
	<td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
	</td>
	<td width="100">&nbsp;
		
	</td>
  </tr>
</table>
</form>
</cfoutput>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<cf_CPSegUsu_where returnVariable="LvarCPSegUsu" Consultar="true" aliasCuentas="a">

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pLista"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="CPresupuesto a, CPCuentaPeriodo p"/>
			<cfinvokeargument name="columnas" value="	a.CPcuenta, a.CPformato, 
														coalesce(a.CPdescripcionF, a.CPdescripcion) as CPdescripcion, 
														'#session.CPPid#' as CPPid,
														case p.CPCPtipoControl
															when 0 then 'Abierto'
															when 1 then 'Restringido'
															when 2 then 'Restrictivo'
														end as TipoControl, 
														case p.CPCPcalculoControl
															when 1 then 'Mensual'
															when 2 then 'Acumulado'
															when 3 then 'Total'
														end as CalculoControl"/>
			<cfinvokeargument name="desplegar" value="CPformato, CPdescripcion, TipoControl, CalculoControl"/>
			<cfinvokeargument name="etiquetas" value="Cuenta, Descripción, Tipo de<BR>Control, Calculo<BR>Control"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfif LvarCmayor NEQ "">
				<cfset LvarCmayorFiltro = "and a.Cmayor = '#LvarCmayor#'">
			<cfelse>
				<cfset LvarCmayorFiltro = "">
			</cfif>
			
			<cfinvokeargument name="filtro" value=" a.Ecodigo = #Session.Ecodigo# 
													#LvarCmayorFiltro#
													and a.CPmovimiento = 'S'
													and p.Ecodigo = a.Ecodigo
													and p.CPPid = #session.CPPid#
													and p.CPcuenta = a.CPcuenta
													#filtro# 
													#LvarCPSegUsu#
													order by a.CPformato
												"/>
			<cfinvokeargument name="align" value="left, left, left, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			<cfinvokeargument name="keys" value="CPcuenta"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="formName" value="listaCuentas"/>
			<cfinvokeargument name="PageIndex" value="1"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
	</td>
  </tr>
</table>
