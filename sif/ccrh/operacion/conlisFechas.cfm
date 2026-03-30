<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>
	<cfset form.Tcodigo = url.Tcodigo >
</cfif>

<cfif isdefined("url.fform") and not isdefined("form.fform")>
	<cfset form.fform = url.fform >
</cfif>

<cfif isdefined("url.ffecha") and not isdefined("form.ffecha")>
	<cfset form.ffecha = url.ffecha >
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.ffecha") and Len(Trim(Form.ffecha)) NEQ 0>	
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ffecha=" & Form.ffecha>
</cfif>
<cfif isdefined("Form.fform") and Len(Trim(Form.fform)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fform=" & Form.fform>
</cfif>
<cfif isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tcodigo=" & Form.Tcodigo>
</cfif>

<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(fecha) {
	var fecha1 = fecha.split('-');
	vfecha = fecha1[2].substring(0,2);
	vfecha += '/'+fecha1[1]; 
	vfecha += '/'+fecha1[0]; 
	
	if (window.opener != null) {
		<cfif isdefined("form.fform") and isdefined("form.ffecha")>
		window.opener.document.<cfoutput>#form.fform#.#form.ffecha#</cfoutput>.value = vfecha;
		<cfelse>
		window.opener.document.form1.RHIDfechadesde.value = vfecha;
		</cfif>
		window.close();
	}
}
</script>

<html>
<head>
<title>Lista de Fechas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
	<cfquery name="rsLista" datasource="#session.DSN#">
		select CPcodigo, CPhasta 
		from CalendarioPagos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
		  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Tcodigo)#">
		  and CPfcalculo is null
		  and CPtipo = 0
		order by CPhasta
	</cfquery>

	<cfquery name="rsTipoNomina" datasource="#session.DSN#">
		select Tcodigo, Tdescripcion
		from TiposNomina 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
	</cfquery>
	
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr><td width="1%" nowrap><strong>Tipo de N&oacute;mina:&nbsp;</strong></td><td>#trim(rsTipoNomina.Tcodigo)# - #trim(rsTipoNomina.Tdescripcion)#</td></tr>
	</table>
	</cfoutput>


<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="CPcodigo, CPhasta"/>
	<cfinvokeargument name="etiquetas" value="Calendario de Pago,Fecha"/>
	<cfinvokeargument name="formatos" value="V,D"/>
	<cfinvokeargument name="filtro" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisFechas.cfm"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CPhasta"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
</body>
</html>