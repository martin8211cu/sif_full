<!---	Lista de Encabezados de Registros de Nómina.
	
		Esta lista es genérica para los diferentes pasos del Pago de la Nómina, Requiere como parámetros el ERNestado, el ERNcapturado, y el ERNfverifica,
y los utiliaza de la siguiente manera: 
	1. ERNestado, lo coloca en el filtro con el valor definido a través de esta variable.
	2. ERNcapturado, si viene en "True", verifica que el valor de este campo sea 1.
	3. ERNfverifica, si viene en "True", verifica que el valor de este campo no sea nulo.
	
		Los Siguientes son otros parámetros adicionales que afectan el funcionamiento de la lista y el filtro de la misma:
	1. PermiteFiltro, Si viene en "True", pone Filtro a la lista.
	2. Botones, Listado de Botones de la Lista. Si viene "None" lo ignora.
	3. irA, Define la pantalla hacia donde se va cuando le hacen click a una línea.
--->

<!--- Pasa valores del url al form, por casos de navegacion --->
<cfif isdefined("Url.ERNcapturado") and not isdefined("Form.ERNcapturado")><cfparam name="Form.ERNcapturado" default="#Url.ERNcapturado#"></cfif>
<cfif isdefined("Url.ERNestado") and not isdefined("Form.ERNestado")><cfparam name="Form.ERNestado" default="#Url.ERNestado#"></cfif>
<cfif isdefined("Url.ERNfverifica") and not isdefined("Form.ERNfverifica")><cfparam name="Form.ERNfverifica" default="#Url.ERNfverifica#"></cfif>
<cfif isdefined("Url.PermiteFiltro") and not isdefined("Form.PermiteFiltro")><cfparam name="Form.PermiteFiltro" default="#Url.PermiteFiltro#"></cfif>
<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")><cfparam name="Form.Tcodigo" default="#Url.Tcodigo#"></cfif>
<cfif isdefined("Url.ERNfcarga") and not isdefined("Form.ERNfcarga")><cfparam name="Form.ERNfcarga" default="#Url.ERNfcarga#"></cfif>
<cfif isdefined("Url.ERNdescripcion") and not isdefined("Form.ERNdescripcion")><cfparam name="Form.ERNdescripcion" default="#Url.ERNdescripcion#"></cfif>
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
</cfquery>

<!--- Manejo de la navegación y el filtro --->
<cfparam name="navegacion" default="">
<cfparam name="filtro" default="">

<!--- Obtiene el nombre del Archivo, debido a que este componente puede ser incluido en varios Archivos. --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<!--- Definición del Filtro de la consulta --->
<!--- Filtro Básico --->
<cfif isDefined("Form.ERNestado") and len(trim(Form.ERNestado)) gt 0>
	<cfset filtro = filtro & " and ERNestado = " & Form.ERNestado >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNestado=" & Form.ERNestado>
</cfif>
<cfif (isDefined("Form.ERNcapturado")) and (Ucase(Form.ERNcapturado) eq "TRUE")>
	<cfset filtro = filtro & " and ERNcapturado = 1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNcapturado=" & Form.ERNcapturado>
</cfif>
<cfif isDefined("Form.ERNfverifica") and Ucase(Form.ERNfverifica) eq "TRUE">
	<cfset filtro = filtro & " and ERNfverifica is not null">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNfverifica=" & Form.ERNfverifica>
</cfif>
<!--- Filtro Adicional --->
<cfif (isDefined("Form.PermiteFiltro")) and (Ucase(Form.PermiteFiltro) eq "TRUE")>
	<cfif isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo)) NEQ 0>
		<cfset filtro = filtro & " and UPPER(ERN.Tcodigo) like '%" & Ucase(Form.Tcodigo) & "%'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tcodigo=" & Trim(Form.Tcodigo)>
	</cfif>
	<cfif isdefined("Form.ERNfcarga") and Len(Trim(Form.ERNfcarga)) NEQ 0>
		<cfset filtro = filtro & " and ERN.ERNfcarga >= " & #LSParseDateTime(Form.ERNfcarga)#>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNfcarga=" & Form.ERNfcarga>
	</cfif>
	<cfif isdefined("Form.ERNdescripcion") and Len(Trim(Form.ERNdescripcion)) NEQ 0>
		<cfset filtro = filtro & " and UPPER(ERNdescripcion) like '%" & Ucase(Form.ERNdescripcion) & "%'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ERNdescripcion=" & Form.ERNdescripcion>
	</cfif>
	<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0>
		<cfset filtro = filtro & " and ERN.Mcodigo = " & Form.Mcodigo>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & Form.Mcodigo>
	</cfif>
</cfif>

<cfquery name="rsDatosTiposNomina" datasource="#Session.DSN#">
	select * from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isDefined("Form.Tcodigo") and len(trim(Form.Tcodigo))>
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Tcodigo)#">
	<cfelse>
		and 1=0
	</cfif>
</cfquery>

<!--- Pintado del Filtro Adicional --->
<cf_templatecss>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cfif (isDefined("Form.PermiteFiltro")) and (Ucase(Form.PermiteFiltro) eq "TRUE")>
	<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1">
		<cfif len(trim(Form.CamposAdicionales)) gt 0>
			<cfset arrCamposAdd = ListToArray(Form.CamposAdicionales, ',')>
			<cfloop from="1" to="#ArrayLen(arrCamposAdd)#" index="i">
				<cfset arrCamposAdd0 = ListToArray(arrCamposAdd[i], '=')>
				<cfoutput>
				<input type="hidden" name="#arrCamposAdd0[1]#" value="#arrCamposAdd0[2]#">
				</cfoutput>
			</cfloop>
		</cfif>
		<cfoutput>
			<input type="hidden" name="ERNcapturado" value="#Form.ERNcapturado#">
			<input type="hidden" name="ERNestado" value="#Form.ERNestado#">
			<input type="hidden" name="ERNfverifica" value="#Form.ERNfverifica#">
			<input type="hidden" name="PermiteFiltro" value="#Form.PermiteFiltro#">
			<input type="hidden" name="Botones" value="#Form.Botones#">
			<input type="hidden" name="irA" value="#Form.irA#">
		</cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
		  <tr>
			<td nowrap class="fileLabel">Tipo de N&oacute;mina</td>
			<td nowrap class="fileLabel">Descripci&oacute;n</td>
			<td nowrap class="fileLabel">Fecha Creaci&oacute;n</td>
			<td nowrap class="fileLabel">Moneda</td>
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
<!--- 					<cfquery name="rs" datasource="#Session.DSN#">
						select Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
					</cfquery> --->
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
				<input name="btnFiltrar" type="submit" value="Filtrar" tabindex="1">
			</td>
		  </tr>
		</table>
	</form>
</cfif>

<!--- QUERY ORIGINAL 
select ERN.ERNid, ERNdescripcion, ERNfcarga, Tdescripcion, 
            c.Mnombre, isnull(sum(DRNliquido),0.00) Importe, d.CPcodigo 
from ERNomina ERN, DRNomina DRN, TiposNomina T, Monedas c, CalendarioPagos d 
where ERN.Ecodigo = T.Ecodigo
 and ERN.Tcodigo = T.Tcodigo
 and ERN.ERNid *= DRN.ERNid
 and ERN.Mcodigo = c.Mcodigo 
and ERN.Ecodigo *= d.Ecodigo 
and ERN.RCNid *= d.CPid 
and ERN.Ecodigo = 1
 and ERNestado = 2 
group by T.Tdescripcion, ERN.ERNid, ERN.ERNdescripcion, ERN.ERNfcarga, c.Mnombre, d.CPcodigo --->


<cfquery name="QueryLista" datasource="#session.DSN#">
	select ERN.ERNid, 
		   ERNdescripcion, 
		   ERNfcarga, 
		   Tdescripcion, 
		   c.Mnombre, 
		   coalesce(sum(DRNliquido),0.00) as Importe, 
		   d.CPcodigo #form.camposAdicionales#

	from  ERNomina ERN  

	inner join  TiposNomina  T
	  on ERN.Ecodigo = T.Ecodigo 
	  and ERN.Tcodigo = T.Tcodigo

	left outer join DRNomina DRN
	  on ERN.ERNid = DRN.ERNid 

	left outer join CalendarioPagos d
	  on ERN.Ecodigo = d.Ecodigo 
	  and ERN.RCNid = d.CPid

	inner join Monedas c
	on ERN.Mcodigo = c.Mcodigo

	where  ERN.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	#filtro#
	group by T.Tdescripcion, ERN.ERNid, ERN.ERNdescripcion, ERN.ERNfcarga, c.Mnombre, d.CPcodigo
</cfquery>


<!---
<cfset sql = "select ERN.ERNid, ERNdescripcion, ERNfcarga, Tdescripcion, 
				c.Mnombre, coalesce(sum(DRNliquido),0.00) as Importe, d.CPcodigo #form.camposAdicionales#
	from  ERNomina ERN  
	inner join  TiposNomina  T
		on (ERN.Ecodigo = T.Ecodigo and 
			   ERN.Tcodigo = T.Tcodigo ) 
	left outer join DRNomina DRN
	   on (ERN.ERNid = DRN.ERNid) 
	left outer join CalendarioPagos d
	   on (ERN.Ecodigo = d.Ecodigo and 
			  ERN.RCNid = d.CPid ) 
	inner join Monedas c
	   on (ERN.Mcodigo = c.Mcodigo)
	where  ERN.Ecodigo = #Session.Ecodigo# #filtro#
	group by T.Tdescripcion, ERN.ERNid, ERN.ERNdescripcion, ERN.ERNfcarga, c.Mnombre, d.CPcodigo">

<cfquery name="QueryLista" datasource="#session.DSN#">
	#PreserveSingleQuotes(sql)#
</cfquery>
--->

<cfinvoke 
		component="rh.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaEduRet">
		<cfinvokeargument name="query" value= "#QueryLista#"/>
		<cfinvokeargument name="cortes" value="Tdescripcion"/>	
		<cfinvokeargument name="desplegar" value="ERNdescripcion, CPcodigo, ERNfcarga, Mnombre, Importe"/>
		<cfinvokeargument name="etiquetas" value="Descripción, Calendario Pagos, Fecha Creación, Moneda, Importe"/>
		<cfinvokeargument name="align" value="left, left, left, left, right"/>
		<cfinvokeargument name="formatos" value="S,S,D,S,M"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfif (isDefined("Form.irA")) and (len(trim(Form.irA)) gt 0)>
			<cfinvokeargument name="irA" value="#Form.irA#"/>
		</cfif>
		<cfinvokeargument name="formName" value="listaNomina"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="keys" value="ERNid"/>
		<cfif (isDefined("Form.Botones")) and (len(trim(Form.Botones)) gt 0) and (Ucase(Form.Botones) neq "NONE")>
			<cfinvokeargument name="botones" value="#Form.Botones#"/>
		</cfif>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>