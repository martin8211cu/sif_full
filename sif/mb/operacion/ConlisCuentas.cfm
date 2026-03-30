<html>
<head>
<title>Lista de Cuentas Bancarias</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfif isdefined("Url.Bid")>
	<cfparam name="Form.Bid" default="#Url.Bid#">
</cfif>
<cfif isdefined("Url.Desc")>
	<cfparam name="Form.Desc" default="#Url.Desc#">
</cfif>
<cfif isdefined("Url.Fecha")>
	<cfparam name="Form.Fecha" default="#Url.Fecha#">
</cfif>
<cfif isdefined("Url.Forma")>
	<cfparam name="Form.Forma" default="#Url.Forma#">
</cfif>
<cfif isdefined("Url.Id")>
	<cfparam name="Form.Id" default="#Url.Id#">
</cfif>
<cfif isdefined("Url.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
</cfif>
<cfif isdefined("Url.Mnombre")>
	<cfparam name="Form.Mnombre" default="#Url.Mnombre#">
</cfif>
<cfif isdefined("Url.Oficina")>
	<cfparam name="Form.Oficina" default="#Url.Oficina#">
</cfif>
<cfif isdefined("Url.Tipo")>
	<cfparam name="Form.Tipo" default="#Url.Tipo#">
</cfif>

<cfif isdefined("Url.fCBcodigo")>
	<cfparam name="Form.fCBcodigo" default="#Url.fCBcodigo#">
</cfif>
<cfif isdefined("Url.fCBdescripcion")>
	<cfparam name="Form.fCBdescripcion" default="#Url.fCBdescripcion#">
</cfif>
<cfif isdefined("Url.fMnombre")>
	<cfparam name="Form.fMnombre" default="#Url.fMnombre#">
</cfif>


<cfset navegacion = "">
<cfset navegacion = "Bid" & "=" & Form.Bid>
<cfset navegacion = navegacion & "&Desc" & "=" & Form.Desc>
<cfset navegacion = navegacion & "&Fecha" & "=" & Form.Fecha>
<cfset navegacion = navegacion & "&Forma" & "=" & Form.Forma>
<cfset navegacion = navegacion & "&Id" & "=" & Form.Id>
<cfset navegacion = navegacion & "&Mcodigo" & "=" & Form.Mcodigo>
<cfset navegacion = navegacion & "&Mnombre" & "=" & Form.Mnombre>
<cfset navegacion = navegacion & "&Oficina" & "=" & Form.Oficina>
<cfset navegacion = navegacion & "&Tipo" & "=" & Form.Tipo>
<cfif isdefined("Form.fCBcodigo")>
	<cfset navegacion = navegacion & "&fCBcodigo" & "=" & Form.fCBcodigo>
</cfif>
<cfif isdefined("Form.fCBdescripcion")>
	<cfset navegacion = navegacion & "&fCBdescripcion" & "=" & Form.fCBdescripcion>
</cfif>
<cfif isdefined("Form.fMnombre")>
	<cfset navegacion = navegacion & "&fMnombre" & "=" & Form.fMnombre>
</cfif>

<!--- Moneda de la Empresa--->
<cfquery name="rsMoneda" datasource="#Session.DSN#" >
	select Mcodigo
	from Empresas 
	where Ecodigo =  #Session.Ecodigo# 
</cfquery>

<!--- 1. Datos que muestra el conlis --->
<cfquery name="conlis" datasource="#Session.DSN#">
	select 
		cb.CBid, 
		cb.CBcodigo, 
		cb.CBdescripcion, 
		cb.Mcodigo, 
		m.Mnombre, 
		cb.Ocodigo, 
	    coalesce((case when cb.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#"> then 1.00 else tc.TCcompra end), 0.00) as TCcompra
	from CuentasBancos cb

		inner join Monedas m 
		on cb.Mcodigo = m.Mcodigo
		
		left outer join Htipocambio tc
		on tc.Ecodigo  = cb.Ecodigo
		and tc.Mcodigo = cb.Mcodigo 
		and tc.Hfecha  <= <cfqueryparam value="#LSParseDateTime(Form.fecha)#" cfsqltype="cf_sql_date">
		and tc.Hfechah > <cfqueryparam value="#LSParseDateTime(Form.fecha)#" cfsqltype="cf_sql_date">
		)

	where cb.Ecodigo =  #Session.Ecodigo# 
    and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  
	<cfif isdefined("Form.Bid") and Len(Trim(Form.Bid))>
		and cb.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
	</cfif>  
	<cfif isdefined("Form.Filtrar") and isdefined("Form.fCBcodigo") and Len(Trim(Form.fCBcodigo))>
		and upper(cb.CBcodigo) like '%#Ucase(Form.fCBcodigo)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and isdefined("Form.fCBdescripcion") and Len(Trim(Form.fCBdescripcion))>
		and upper(CBdescripcion) like '%#Ucase(Form.fCBdescripcion)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and isdefined("Form.fMnombre") and Len(Trim(Form.fMnombre))>
		and upper(Mnombre) like '%#Ucase(Form.fMnombre)#%'
	</cfif>
	order by upper(CBcodigo)
</cfquery>

<script language="JavaScript1.2">
	function Asignar(valor1, valor2, valor3, valor4, valor5, valor6 ) {
		window.opener.document.<cfoutput>#Form.forma#.#Form.id#</cfoutput>.value      = valor1;
		window.opener.document.<cfoutput>#Form.forma#.#Form.desc#</cfoutput>.value    = valor2;
		window.opener.document.<cfoutput>#Form.forma#.#Form.mcodigo#</cfoutput>.value = valor3;
		window.opener.document.<cfoutput>#Form.forma#.#Form.mnombre#</cfoutput>.value = valor4;
		window.opener.document.<cfoutput>#Form.forma#.#Form.tipo#</cfoutput>.value    = valor5;
		window.opener.document.<cfoutput>#Form.forma#.#Form.oficina#</cfoutput>.value = valor6;
		if ( valor5 == '1.0000' ){
			window.opener.document.<cfoutput>#Form.forma#.#Form.tipo#</cfoutput>.disabled = true
		}
		else{
			window.opener.document.<cfoutput>#Form.forma#.#Form.tipo#</cfoutput>.disabled = false
		}
		window.opener.fm(window.opener.document.<cfoutput>#Form.forma#.#Form.tipo#</cfoutput>, 4)
		window.close();
	}
</script>

<body>
	<cfoutput>
	<form action="ConlisCuentas.cfm" method="post" name="form1">
		<input type="hidden" name="Bid" value="#Form.Bid#">
		<input type="hidden" name="Desc" value="#Form.Desc#">
		<input type="hidden" name="Fecha" value="#Form.Fecha#">
		<input type="hidden" name="Forma" value="#Form.Forma#">
		<input type="hidden" name="Id" value="#Form.Id#">
		<input type="hidden" name="Mcodigo" value="#Form.Mcodigo#">
		<input type="hidden" name="Mnombre" value="#Form.Mnombre#">
		<input type="hidden" name="Oficina" value="#Form.Oficina#">
		<input type="hidden" name="Tipo" value="#Form.Tipo#">
		<table width="100%" border="0" cellspacing="0" class="areaFiltro">
			<tr> 
				<td>
					<strong>C&oacute;digo</strong>
				</td>
				<td>
					<strong>Descripci&oacute;n</strong>
				</td>
				<td>
					<strong>Moneda</strong>
				</td>
				<td rowspan="2" width="1%">
					<div align="right">
						<input type="submit" name="Filtrar" value="Filtrar">
					</div>
				</td>
			</tr>
			<tr> 
				<td ><input name="fCBcodigo" type="text" size="30" maxlength="50" style=" text-transform: uppercase; " value="<cfif isdefined('Form.fCBcodigo')>#Form.fCBcodigo#</cfif>"></td>
				<td ><input name="fCBdescripcion" type="text" size="30" maxlength="60" style=" text-transform: uppercase; " value="<cfif isdefined('Form.fCBcodigo')>#Form.fCBdescripcion#</cfif>"></td>
				<td ><input name="fMnombre" type="text" size="30" maxlength="80" style=" text-transform: uppercase; " value="<cfif isdefined('Form.fCBcodigo')>#Form.fMnombre#</cfif>"></td>
		    </tr>
		</table>
	</form>
	</cfoutput>

	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="LvarLista">
			<cfinvokeargument name="query" value="#conlis#"/>
			<cfinvokeargument name="desplegar" value="CBcodigo, CBdescripcion, Mnombre"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Moneda"/>
			<cfinvokeargument name="formatos" value="V,V,V"/>
			<cfinvokeargument name="align" value="left,left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="ConlisCuentas.cfm"/>
			<cfinvokeargument name="formName" value="conlis"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="CBid, CBdescripcion, Mcodigo, Mnombre, TCcompra, Ocodigo"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>

</body>
</html>