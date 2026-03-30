<!--- Pasa valores del url al form, por casos de navegacion --->
<cfif isdefined("Url.HERNcapturado") and not isdefined("Form.HERNcapturado")><cfparam name="Form.HERNcapturado" default="#Url.HERNcapturado#"></cfif>
<cfif isdefined("Url.HERNestado") and not isdefined("Form.HERNestado")><cfparam name="Form.HERNestado" default="#Url.HERNestado#"></cfif>
<cfif isdefined("Url.HERNfverifica") and not isdefined("Form.HERNfverifica")><cfparam name="Form.HERNfverifica" default="#Url.HERNfverifica#"></cfif>
<cfif isdefined("Url.PermiteFiltro") and not isdefined("Form.PermiteFiltro")><cfparam name="Form.PermiteFiltro" default="#Url.PermiteFiltro#"></cfif>
<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")><cfparam name="Form.Tcodigo" default="#Url.Tcodigo#"></cfif>
<cfif isdefined("Url.HERNfcarga") and not isdefined("Form.HERNfcarga")><cfparam name="Form.HERNfcarga" default="#Url.HERNfcarga#"></cfif>
<cfif isdefined("Url.HERNdescripcion") and not isdefined("Form.HERNdescripcion")><cfparam name="Form.HERNdescripcion" default="#Url.HERNdescripcion#"></cfif>
<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")><cfparam name="Form.Mcodigo" default="#Url.Mcodigo#"></cfif>
<cfif isdefined("Url.Botones") and not isdefined("Form.Botones")><cfparam name="Form.Botones" default="#Url.Botones#"></cfif>
<cfif isdefined("Url.irA") and not isdefined("Form.irA")><cfparam name="Form.irA" default="#Url.irA#"></cfif>
<cfparam default="" name="Form.CamposAdicionales" type="string">

<!--- Consultas --->
<!---- Tipos de Nómina --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(Tcodigo) as Tcodigo, Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined('Form.Tcodigo')and len(trim(Form.Tcodigo))>
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Tcodigo#">
	<cfelse>
		and 1=0
	</cfif>
</cfquery>

<!--- Manejo de la navegación y el filtro --->
<cfparam name="navegacion" default="">
<cfparam name="filtro" default="">

<!--- Obtiene el nombre del Archivo, debido a que este componente puede ser incluido en varios Archivos. --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<!--- Definición del Filtro de la consulta --->
<!--- Filtro Básico --->
<cfif isDefined("Form.HERNestado") and len(trim(Form.HERNestado)) gt 0>
	<cfset filtro = filtro & " and HERNestado in (" & Form.HERNestado & ")">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HERNestado=" & Form.HERNestado>
</cfif>
<cfif (isDefined("Form.HERNcapturado")) and (Ucase(Form.HERNcapturado) eq "TRUE")>
	<cfset filtro = filtro & " and HERNcapturado = 1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HERNcapturado=" & Form.HERNcapturado>
</cfif>
<cfif isDefined("Form.HERNfverifica") and Ucase(Form.HERNfverifica) eq "TRUE">
	<cfset filtro = filtro & " and HERNfverifica is not null">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HERNfverifica=" & Form.HERNfverifica>
</cfif>
<!--- Filtro Adicional --->
<cfif isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo)) NEQ 0>
	<cfset filtro = filtro & " and UPPER(ERN.Tcodigo) like '%" & Ucase(Form.Tcodigo) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tcodigo=" & Trim(Form.Tcodigo)>
</cfif>
<cfif isdefined("Form.HERNfcarga") and Len(Trim(Form.HERNfcarga)) NEQ 0>
	<cfset filtro = filtro & " and ERN.HERNfcarga >= " & #LSParseDateTime(Form.HERNfcarga)#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HERNfcarga=" & Form.HERNfcarga>
</cfif>
<cfif isdefined("Form.HERNdescripcion") and Len(Trim(Form.HERNdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and UPPER(HERNdescripcion) like '%" & Ucase(Form.HERNdescripcion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HERNdescripcion=" & Form.HERNdescripcion>
</cfif>
<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0>
	<cfset filtro = filtro & " and ERN.Mcodigo = " & Form.Mcodigo>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & Form.Mcodigo>
</cfif>

<!--- Pintado del Filtro Adicional --->
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	  <tr>
		<td nowrap class="fileLabel"><cf_translate  key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
		<td nowrap class="fileLabel"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
		<td nowrap class="fileLabel"><cf_translate  key="LB_FechaCreacion">Fecha Creaci&oacute;n</cf_translate></td>
		<td nowrap class="fileLabel"><cf_translate  key="LB_Moneda">Moneda</cf_translate></td>
		<td nowrap class="fileLabel">&nbsp;</td>
	  </tr>
	  <tr>
		<td>
			<!--- Tipos de Nómina --->
			<cf_rhtiponominaCombo index="0" query="#rsTiposNomina#">

			<!---<select name="Tcodigo" tabindex="1">
			  <option value="">--Todos--</option>
			  <cfoutput query="rsTiposNomina"> 
				  <option value="#Trim(Tcodigo)#" <cfif (isDefined("Form.Tcodigo")) and (Form.Tcodigo eq rsTiposNomina.Tcodigo)>selected</cfif>>#Tdescripcion#</option>
			  </cfoutput>
			</select>--->
		</td>
		<td>
			<input name="HERNdescripcion" type="text" value="<cfif (isdefined("Form.HERNdescripcion")) and (len(trim(Form.HERNdescripcion)) gt 0)><cfoutput>#Form.HERNdescripcion#</cfoutput></cfif>" size="60" maxlength="100" tabindex="1">
		</td>
		<td>
			<cfif (isDefined("Form.HERNfcarga")) and (len(trim(Form.HERNfcarga)) gt 0)>
				<cfoutput>
					<cf_sifcalendario name="HERNfcarga" value="#Form.HERNfcarga#" tabindex="1">
				</cfoutput>
			<cfelse>
				<cf_sifcalendario name="HERNfcarga" tabindex="1">
			</cfif>
		</td>
		<td>
			<cfif (isDefined("Form.Mcodigo")) and (len(trim(Form.Mcodigo)) gt 0)>
				<cfset Mcodigo = Form.Mcodigo>
				<cfset rs = QueryNew('Mcodigo')>
				<cfoutput>
					<cf_sifmonedas tabindex="1" value="#Form.Mcodigo#">
				</cfoutput>
			<cfelse>
				<cf_sifmonedas tabindex="1">
			</cfif>
		</td>
		<td>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>
			<input name="btnFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
		</td>
	  </tr>
	</table>
</form>

<cfquery name="QueryLista" datasource="#session.DSN#">
	select ERN.ERNid, 
		   HERNdescripcion, 
		   HERNfcarga, 
		   Tdescripcion, 
		   c.Mnombre, 
		   coalesce(sum(HDRNliquido),0.00) as Importe, 
		   d.CPcodigo #form.camposAdicionales#

	from  HERNomina ERN  

	inner join  TiposNomina  T
	  on ERN.Ecodigo = T.Ecodigo 
	  and ERN.Tcodigo = T.Tcodigo

	left outer join HDRNomina DRN
	  on ERN.ERNid = DRN.ERNid 

	left outer join CalendarioPagos d
	  on ERN.Ecodigo = d.Ecodigo 
	  and ERN.RCNid = d.CPid

	inner join Monedas c
	on ERN.Mcodigo = c.Mcodigo

	where  ERN.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and RCNid is not null
	#preservesinglequotes(filtro)#
	group by T.Tdescripcion, ERN.ERNid, ERN.HERNdescripcion, ERN.HERNfcarga, c.Mnombre, d.CPcodigo
	order by T.Tdescripcion,HERNfcarga desc
	
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripción"
returnvariable="LB_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CalendarioPagos"
Default="Calendario Pagos"
returnvariable="LB_CalendarioPagos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_FechaCreacion"
Default="Fecha Creación"
returnvariable="LB_FechaCreacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Moneda"
Default="Moneda"
returnvariable="LB_Moneda"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Importe"
Default="Importe"
returnvariable="LB_Importe"/>


<cfinvoke 
		component="rh.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaEduRet">
		<cfinvokeargument name="query" value= "#QueryLista#"/>
		<cfinvokeargument name="cortes" value="Tdescripcion"/>	
		<cfinvokeargument name="desplegar" value="HERNdescripcion, CPcodigo, HERNfcarga, Mnombre, Importe"/>
		<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_CalendarioPagos#, #LB_FechaCreacion#, #LB_Moneda#, #LB_Importe#"/>
		<cfinvokeargument name="align" value="left, left, left, left, right"/>
		<cfinvokeargument name="formatos" value="S,S,D,S,M"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="PNomina.cfm"/>
		<cfinvokeargument name="formName" value="listaNomina"/>
		<cfinvokeargument name="keys" value="ERNid"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="maxRows" value="10"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
<br>

<script type="text/javascript" language="javascript1.2">
</script>