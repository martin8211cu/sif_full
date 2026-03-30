
<cfif isdefined("url.Turno_id") and not isdefined("form.Turno_id")>
	<cfset form.Turno_id= url.Turno_id>
</cfif>
<cfif isdefined("url.Codigo_turno") and not isdefined("form.Codigo_turno")>
	<cfset form.Codigo_turno= url.Codigo_turno >
</cfif>
<cfif isdefined("url.Tdescripcion") and not isdefined("form.Tdescripcion")>
	<cfset form.Tdescripcion= url.Tdescripcion >
</cfif>

<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario= url.formulario >
</cfif>


<script language="JavaScript" type="text/javascript">
//La funcion recibe el CMTScodigo y CMTSdescripcion
function Asignar(id,codigo,descripcion){
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Turno_id.value   = id;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Codigo_turno.value = codigo;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Tdescripcion.value = descripcion;
		window.close();
	}
}
</script>

<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("Url.Turno_id") and not isdefined("Form.Turno_id")>
	<cfparam name="Form.Turno_id" default="#Url.Turno_id#">
</cfif>
<cfif isdefined("Url.Codigo_turno") and not isdefined("Form.Codigo_turno")>
	<cfparam name="Form.Codigo_turno" default="#Url.Codigo_turno#">
</cfif>
<cfif isdefined("Url.Tdescripcion") and not isdefined("Form.Tdescripcion")>
	<cfparam name="Form.Tdescripcion" default="#Url.Tdescripcion#">
</cfif>

<!---- Se establecen las variables de navegacion y filtros ----->
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.Codigo_turno") and Len(Trim(Form.Codigo_turno)) NEQ 0>
	<cfset filtro = filtro & "and Codigo_turno = '#trim(ucase(Form.Codigo_turno))#'" >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Codigo_turno=" & Form.Codigo_turno>
</cfif>
<cfif isdefined("Form.Tdescripcion") and Len(Trim(Form.Tdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(Tdescripcion) like '%" & #UCase(Form.Tdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tdescripcion=" & Form.Tdescripcion>
</cfif>


<html>
<head>
<title>Lista de Turnos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtro" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" align="right"><strong>Código</strong></td>
		<td> 
			<input name="Codigo_turno" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.Codigo_turno")>#Form.Codigo_turno#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td width="1%" align="right"><strong>Descripción</strong></td>
		<td> 
			<input name="Tdescripcion" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.Tdescripcion")>#Form.Tdescripcion#</cfif>" onfocus="javascript:this.select();" >
		</td>

		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsTurnos" datasource="#session.DSN#">
	select Turno_id,Codigo_turno, Tdescripcion, HI_turno, HF_turno
	from Turnos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	#preservesinglequotes(filtro)#	
	order by Codigo_turno	
</cfquery>

<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsTurnos#"/> 
	<cfinvokeargument name="desplegar" value="Codigo_turno, Tdescripcion"/> 
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/> 
	<cfinvokeargument name="formatos" value="V,V"/> 
	<cfinvokeargument name="align" value="left,left"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="conlisTurnos.cfm"/> 
	<cfinvokeargument name="formname" value="filtro"/> 
	<cfinvokeargument name="maxrows" value="15"/> 				
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Turno_id, Codigo_turno, Tdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke> 

</body>
</html>
<!----
<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario= url.formulario >
</cfif>

<script language="JavaScript" type="text/javascript">

function Asignar(Turno_id,Codigo_turno,Tdescripcion) {
	if (window.opener != null) {
		window.opener.document.form1.Turno_id.value = Turno_id;
		window.opener.document.form1.Codigo_turno.value = Codigo_turno;
		window.opener.document.form1.Tdescripcion.value = Tdescripcion;
		window.close();
	}
}
</script>

<cfif isdefined("Url.Codigo_turno") and not isdefined("Form.Codigo_turno")>
	<cfparam name="Form.Codigo_turno" default="#Url.Codigo_turno#">
</cfif>
<cfif isdefined("Url.Tdescripcion") and not isdefined("Form.Tdescripcion")>
	<cfparam name="Form.Tdescripcion" default="#Url.Tdescripcion#">
</cfif>

<cfset filtro = "">
<!----
<cfset filtroObserv = "">
<cfset filtrotipo = "">
<cfset navegacion = "">
---->

<cfif isdefined("Form.Codigo_turno") and Len(Trim(Form.Codigo_turno)) NEQ 0>
 	<cfset filtro = filtro & " and a.Codigo_turno =" & form.Codigo_turno >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Codigo_turno=" & Form.Codigo_turno>
</cfif>

<cfif isdefined("Form.Tdescripcion") and Len(Trim(Form.Tdescripcion)) NEQ 0>
 	<cfset filtro= filtro& " and upper(Tdescripcion) like '%" & #UCase(Form.Tdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tdescripcion=" & Form.Tdescripcion>
</cfif>

<html>
<head>
<title>Lista de Turnos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>


<cfquery name="rsLista" datasource="#session.DSN#">
	select Turno_id,Codigo_turno, Tdescripcion, HI_turno, HF_turno
	from Turnos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	#preservesinglequotes(filtro)#	
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form style="margin:0;" name="filtroTurno" method="post" action="ConlisTurnos.cfm">
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
				<cfoutput>
					<td width="12%" align="right" nowrap><strong>C&oacute;digo/strong></td>					
					<td width="7%" nowrap> 
						<input name="Codigo_turno" type="text" id="Codigo_turno" size="10" maxlength="80" value="<cfif isdefined("Form.Codigo_turno")>#Form.Codigo_turno#</cfif>" onFocus="javascript:this.select();">
					</td>

					<td width="9%" align="right"><strong>Descripción</strong></td>
					
					<td width="27%" nowrap> 
						<input name="Tdescripcion" type="text" id="Tdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.Tdescripcion")>#Form.Tdescripcion#</cfif>" onFocus="javascript:this.select();">
					</td>
					
					<td width="16%" align="center">
						<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					</td>
				</tr>
			</table>
		</cfoutput>
			</form>
		</td>
	</tr>	
	<tr>
		<td>
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsLista#"/> 
				<cfinvokeargument name="desplegar" value="Codigo_turno, Tdescripcion"/> 
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripción"/> 
				<cfinvokeargument name="formatos" value="V,V"/> 
				<cfinvokeargument name="align" value="left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="ConlisTurnos.cfm"/> 
				<!---<cfinvokeargument name="formname" value="listaOC"/> --->
				<cfinvokeargument name="maxrows" value="15"/> 				
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="Turno_id,Codigo_turno,Tdescripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
				<!---<cfinvokeargument name="Cortes" value="CMTScodigo"/>---->
			</cfinvoke> 
		</td>
	</tr>
</table>
</cfoutput>

</body>
</html>
---->