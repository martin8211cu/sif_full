 <!--- Manejo de la navegación y el filtro --->
<cfparam name="navegacion" default="">
<cfparam name="filtro" default="">
<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")>
	<cfparam name="Form.Tcodigo" default="#Url.Tcodigo#">
</cfif>
<cfif isdefined("Url.ERNfcarga") and not isdefined("Form.ERNfcarga")>
	<cfparam name="Form.ERNfcarga" default="#Url.ERNfcarga#">
</cfif>
<cfif isdefined("Url.ERNdescripcion") and not isdefined("Form.ERNdescripcion")>
	<cfparam name="Form.ERNdescripcion" default="#Url.ERNdescripcion#">
</cfif>
<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
</cfif>
<!---<cfif isdefined("Url.Botones") and not isdefined("Form.Botones")><cfparam name="Form.Botones" default="#Url.Botones#"></cfif>--->
<cfif isdefined("Url.Estado") and not isdefined("Form.Estado")>
	<cfparam name="Form.Estado" default="#Url.Estado#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Estado=" & Form.Estado>
</cfif>
<cfif isdefined("Url.Bid") and not isdefined("Form.Bid")>
	<cfparam name="Form.Bid" default="#Url.Bid#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Bid=" & Form.Bid>
<cfelse>
	<cfparam name="Form.Bid" default="0">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Bid=" & Form.Bid>
</cfif>
<cfif isdefined("Url.EIid") and not isdefined("Form.EIid")>
	<cfparam name="Form.EIid" default="#Url.EIid#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EIid=" & Form.EIid>
</cfif>
<cfif isDefined("Form.ERNfverifica") and Ucase(Form.ERNfverifica) eq "TRUE">
	<cfif isdefined("form.Estado") and form.Estado NEQ 'h'>
		<cfset filtro = filtro & " and ERNfverifica is not null">
	<cfelse>
		<cfset filtro = filtro & " and HERNfverifica is not null">
	</cfif>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNfverifica=" & Form.ERNfverifica>
</cfif>
<cfif isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo)) NEQ 0>
	<cfset filtro = filtro & " and UPPER(ERN.Tcodigo) like '%" & Ucase(Form.Tcodigo) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tcodigo=" & Trim(Form.Tcodigo)>
</cfif>
<cfif isdefined("Form.ERNfcarga") and Len(Trim(Form.ERNfcarga)) NEQ 0>
	<cfif isdefined("form.Estado") and form.Estado NEQ 'h'>
		<cfset filtro = filtro & " and ERN.ERNfcarga >= " & #LSParseDateTime(Form.ERNfcarga)#>
	<cfelse>
		<cfset filtro = filtro & " and ERN.HERNfcarga >= " & #LSParseDateTime(Form.ERNfcarga)#>
	</cfif>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNfcarga=" & Form.ERNfcarga>
</cfif>
<cfif isdefined("Form.ERNdescripcion") and Len(Trim(Form.ERNdescripcion)) NEQ 0>
	<cfif isdefined("form.Estado") and form.Estado EQ 'h'>
		<cfset filtro = filtro & " and UPPER(HERNdescripcion) like '%" & Ucase(Form.ERNdescripcion) & "%'">
	<cfelse>
		<cfset filtro = filtro & " and UPPER(ERNdescripcion) like '%" & Ucase(Form.ERNdescripcion) & "%'">
	</cfif>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNdescripcion=" & Form.ERNdescripcion>
</cfif>
<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0>
	<cfset filtro = filtro & " and ERN.Mcodigo = " & Form.Mcodigo>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & Form.Mcodigo>
</cfif>
<cfif isdefined("Form.Estado") and Len(Trim(Form.Estado)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Estado=" & Form.Estado>
</cfif>
<!--- Consultas --->
<!---- Tipos de Nómina --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(Tcodigo) as Tcodigo, Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsDatosTiposNomina" datasource="#Session.DSN#">
	select * from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isDefined("Form.Tcodigo") and len(trim(Form.Tcodigo))>
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Tcodigo)#">
	<cfelse>
		and 1=0
	</cfif>
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templatecss>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1">
		<cfoutput>
		<input type="hidden" name="EIid" value="#form.EIid#">
		<input type="hidden" name="Bid" value="#form.Bid#">
		</cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
		  <tr>
			<td nowrap class="fileLabel"><cf_translate  key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
			<td nowrap class="fileLabel"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
			<td nowrap class="fileLabel"><cf_translate  key="LB_FechaCreacion">Fecha Creaci&oacute;n</cf_translate></td>
			<td nowrap class="fileLabel"><cf_translate  key="LB_Moneda">Moneda</cf_translate></td>
			<td nowrap class="fileLabel"><cf_translate  key="LB_Estado">Estado</cf_translate></td>
			<td nowrap class="fileLabel">&nbsp;</td>
		  </tr>
		  <tr>
			<td>
				<!--- Tipos de Nómina --->
				<cf_rhtiponominaCombo index="0" query="#rsDatosTiposNomina#" todas="False">
				<!---<select name="Tcodigo" tabindex="1">
				  <cfoutput query="rsTiposNomina">
					  <option value="#Trim(Tcodigo)#" <cfif (isDefined("Form.Tcodigo")) and (Form.Tcodigo eq Tcodigo)>selected</cfif>>#Tdescripcion#</option>
				  </cfoutput>
				</select>--->
			</td>
			<td>
				<input name="ERNdescripcion" type="text" value="<cfif (isdefined("Form.ERNdescripcion")) and (len(trim(Form.ERNdescripcion)) gt 0)><cfoutput>#Form.ERNdescripcion#</cfoutput></cfif>" size="60" maxlength="100" tabindex="1">
			</td>
			<td>
				<cfif (isDefined("Form.ERNfcarga")) and (len(trim(Form.ERNfcarga)) gt 0)>
					<cfoutput>
						<cf_sifcalendario name="ERNfcarga" value="#Form.ERNfcarga#" tabindex="1">
					</cfoutput>
				<cfelse>
					<cf_sifcalendario name="ERNfcarga" tabindex="1">
				</cfif>
			</td>
			<td>
				<cfif (isDefined("Form.Mcodigo")) and (len(trim(Form.Mcodigo)) gt 0)>
					<cfset Mcodigo = Form.Mcodigo>
					<cfset rs = QueryNew('Mcodigo')>
					<cfoutput>
						<cf_sifmonedas tabindex="1" query="#rs#">
					</cfoutput>
				<cfelse>
					<cf_sifmonedas tabindex="1">
				</cfif>
			</td>
			<td>
				<select name="estado">
					<option value="p" id="p" <cfif isdefined("form.estado") and form.estado EQ 'p'>selected</cfif>><cf_translate key="LB_Proceso">Proceso</cf_translate></option>
					<option value="h" id="h" <cfif isdefined("form.estado") and form.estado EQ 'h'>selected</cfif>><cf_translate key="LB_Historico">Hist&oacute;rico</cf_translate></option>
				</select>
			</td>
			<td>
				<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar" XmlFile="/rh/generales.xml" returnvariable="BTN_Generar"/>
				<input name="btnFiltrar" type="submit" value="<cfoutput>#BTN_Generar#</cfoutput>" tabindex="1">
			</td>
		  </tr>
		</table>
	</form>
<cfif len(form.Bid) GT 0 >
	<cfset varBid= form.Bid>
<cfelse>
	<cfset varBid="0">
</cfif>

<cfif isdefined("form.Estado") and form.Estado EQ 'h'><!-----Nominas historicas---->
	<cfset sql = "select 	ERN.ERNid,
							HERNdescripcion as ERNdescripcion,
							HERNfcarga as ERNfcarga,
							Tdescripcion,
							c.Mnombre,
							(coalesce(sum(HDRNliquido),0.00) -
								(select
									coalesce(sum(ic.ICmontores),0) ICmontores
								from HERNomina e
								inner join HIncidenciasCalculo ic
									on e.RCNid = ic.RCNid
									and e.ERNid = ERN.ERNid
								inner join DatosEmpleado de
									on de.DEid = ic.DEid
									and de.DETipoPago = 0
								inner join CIncidentes ci
								on ci.CIid = ic.CIid
								where ci.CIExcluyePagoLiquido = 1)
							) as Importe,
							d.CPcodigo
							,#form.EIid# as EIid
							,#varBid# as Bid
							,'#form.Estado#' as estado
				from  HERNomina ERN
					inner join  TiposNomina  T
						on (ERN.Ecodigo = T.Ecodigo and
							   ERN.Tcodigo = T.Tcodigo )
					left outer join HDRNomina DRN
					   on (ERN.ERNid = DRN.ERNid)
					  inner join DatosEmpleado de
	  					on de.DEid = DRN.DEid
	  					and de.DEtipoPago = 0
					left outer join CalendarioPagos d
					   on (ERN.Ecodigo = d.Ecodigo and
							  ERN.RCNid = d.CPid )
					inner join Monedas c
					   on (ERN.Mcodigo = c.Mcodigo)
				where  ERN.Ecodigo = #Session.Ecodigo#
					and HERNestado = 4
					and HERNfverifica is not null
					#filtro#
				group by T.Tdescripcion, ERN.ERNid, ERN.HERNdescripcion, ERN.HERNfcarga, c.Mnombre, d.CPcodigo">
<cfelse><!-----Nominas sin finalizar----->
	<cfset sql = "select ERN.ERNid,
						 ERNdescripcion,
						 ERNfcarga,
						 Tdescripcion,
						c.Mnombre,
						(coalesce(sum(DRNliquido),0.00) -
								(select
									coalesce(sum(ic.ICmontores),0) ICmontores
								from ERNomina e
								inner join IncidenciasCalculo ic
									on e.RCNid = ic.RCNid
									and e.ERNid = ERN.ERNid
								inner join DatosEmpleado de
									on de.DEid = ic.DEid
									and de.DETipoPago = 0
								inner join CIncidentes ci
								on ci.CIid = ic.CIid
								where ci.CIExcluyePagoLiquido = 1)
						) as Importe,
						d.CPcodigo,
						#form.EIid# as EIid,
						#varBid# as Bid
						,'p' as estado
				from  ERNomina ERN
				inner join  TiposNomina  T
					on (ERN.Ecodigo = T.Ecodigo and
						   ERN.Tcodigo = T.Tcodigo )
				left outer join DRNomina DRN
				   on (ERN.ERNid = DRN.ERNid)
				inner join DatosEmpleado de
				  on de.DEid = DRN.DEid
				  and de.DEtipoPago = 0
				left outer join CalendarioPagos d
				   on (ERN.Ecodigo = d.Ecodigo and
						  ERN.RCNid = d.CPid )
				inner join Monedas c
				   on (ERN.Mcodigo = c.Mcodigo)
				where  ERN.Ecodigo = #Session.Ecodigo#
					and ERNestado = 4
					and ERNfverifica is not null
					#filtro#
				group by T.Tdescripcion, ERN.ERNid, ERN.ERNdescripcion, ERN.ERNfcarga, c.Mnombre, d.CPcodigo">
</cfif>

<cfquery name="QueryLista" datasource="#session.DSN#">
	#PreserveSingleQuotes(sql)#
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripción" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CalendarioPagos" Default="Calendario Pagos" returnvariable="LB_CalendarioPagos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaCreacion" Default="Fecha Creación" returnvariable="LB_FechaCreacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default="Moneda" returnvariable="LB_Moneda"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Importe" Default="Importe" returnvariable="LB_Importe"/>

<cfinvoke
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value= "#QueryLista#"/>
	<cfinvokeargument name="cortes" value="Tdescripcion"/>
	<cfinvokeargument name="desplegar" value="ERNdescripcion, CPcodigo, ERNfcarga, Mnombre, Importe"/>
	<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_CalendarioPagos#,#LB_FechaCreacion#,#LB_Moneda#,#LB_Importe#"/>
	<cfinvokeargument name="align" value="left, left, left, left, right"/>
	<cfinvokeargument name="formatos" value="S,S,D,S,M"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="pideParametros.cfm"/>
	<cfinvokeargument name="formName" value="listaNomina"/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="keys" value="ERNid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
