<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
<cfelse>
	<cfset index = 1>	
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar<cfoutput>#index#</cfoutput>(RHEid,RHEdescripcion) {
	if (window.opener != null) {		
		window.opener.document.form1.RHEid<cfoutput>#index#</cfoutput>.value = RHEid;
		window.opener.document.form1.RHEdescripcion<cfoutput>#index#</cfoutput>.value = RHEdescripcion;
		window.opener.funcCargaCombo();
		window.close();
	}
}
</script>

<cfif isdefined("Url.RHEdescripcion") and not isdefined("Form.RHEdescripcion")>
	<cfparam name="Form.EOidorden" default="#Url.RHEdescripcion#">
</cfif>
<cfif isdefined("Url.RHEfdesde") and not isdefined("Form.RHEdescripcion")>
	<cfparam name="Form.RHEfdesde" default="#Url.RHEfdesde#">
</cfif>
<cfif isdefined("Url.RHEfhasta") and not isdefined("Form.RHEfhasta")>
	<cfparam name="Form.RHEfhasta" default="#Url.RHEfhasta#">
</cfif>
<cfif isdefined("Url.RHEestado") and not isdefined("Form.RHEestado")>
	<cfparam name="Form.RHEestado" default="#Url.RHEestado#">
</cfif>
<cfif isdefined("Url.index") and not isdefined("Form.index")>
	<cfparam name="index" default="#Url.index#">
</cfif>

<cfset navegacion = "">
<cfset filtro = "">

<cfif isdefined("Form.RHEdescripcion") and Len(Trim(Form.RHEdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHEdescripcion) like '%" & #UCase(Form.RHEdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEdescripcion=" & Form.RHEdescripcion>
</cfif>
<cfif isdefined("Form.RHEfdesde") and Len(Trim(Form.RHEfdesde)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEfdesde=" & Form.RHEfdesde>
</cfif>
<cfif isdefined("Form.RHEfhasta") and Len(Trim(Form.RHEfhasta)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEfhasta=" & Form.RHEfhasta>
</cfif>
<cfif isdefined("Form.RHEestado") and Len(Trim(Form.RHEestado)) NEQ 0>
 	<cfset filtro = filtro & " and RHEestado = '" & Form.RHEestado & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEestado=" & Form.RHEestado>
</cfif>
<cfif isdefined("index") and Len(Trim(index)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "index=" & index>
</cfif>

<html>
<head>
<title>Lista de Escenarios </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>

<cfquery name="rsLista" datasource="#session.DSN#">
	select 	RHEid, 
			RHEdescripcion, 
			RHEid, 
			RHEfdesde, 
			RHEfhasta, 
			case RHEestado 	when 'A' then 'Aprobado'
					  		when 'R' then 'Rechazado'
							else 'En proceso' 
			end as RHEestado			
	from RHEscenarios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	<cfif isdefined("Form.RHEfdesde") and Len(Trim(Form.RHEfdesde)) NEQ 0>
		and RHEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEfdesde)#">
	</cfif>
	<cfif isdefined("Form.RHEfhasta") and Len(Trim(Form.RHEfhasta)) NEQ 0>
		and RHEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEfhasta)#">
	</cfif>
	<cfif not isdefined("btn_filtrar")>
		and RHEestado = 'A'		
	</cfif>
	#preservesinglequotes(filtro)#
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="2" align="center"><strong>Lista de Escenarios</strong></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<form style="margin:0;" name="form1" method="post" action="ConlisEscenarios.cfm">
			<cfif Len(Trim(index))>
				<input type="hidden" name="idx" value="#index#">
			</cfif>
			  	
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td width="11%" align="right" nowrap><strong>Descripci&oacute;n:</strong></td>
					<td width="21%"> 
						<input size="30" type="text" name="RHEdescripcion" value="<cfif isdefined("form.RHEdescripcion") and len(trim(form.RHEdescripcion))>#form.RHEdescripcion#</cfif>">						
				  	</td>
					<td width="12%" align="right" nowrap><strong>Fecha desde:</strong></td>
					<td width="10%">
						<cfset vd_fechadesde = ''>
						<cfif isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>
							<cfset vd_fechadesde = form.RHEfdesde>
						</cfif>
						<cf_sifcalendario conexion="#session.DSN#" form="form1" name="RHEfdesde" value="#vd_fechadesde#"> 
				  	</td>
					<td width="10%" align="right" nowrap><strong>Fecha hasta:</strong></td>
					<td width="6%">
						<cfset vd_fechahasta = ''>
						<cfif isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))>
							<cfset vd_fechahasta = form.RHEfhasta>
						</cfif>
						<cf_sifcalendario conexion="#session.DSN#" form="form1" name="RHEfhasta" value="#vd_fechahasta#"> 
				  	</td>
					<td width="9%" align="right"><strong>Estado:</strong></td>
					<td width="21%"> 
						<select name="RHEestado">
							<option value="">--- Todos ----</option>
							<option value="A" <cfif isdefined("form.RHEestado") and form.RHEestado eq 'A'>selected<cfelseif not isdefined("btn_filtrar")>selected</cfif>>Aprobado</option> 
							<option value="P" <cfif isdefined("form.RHEestado") and form.RHEestado eq 'P'>selected</cfif>>En proceso</option> 
							<option value="R" <cfif isdefined("form.RHEestado") and form.RHEestado eq 'R'>selected</cfif>>Rechazado</option> 
							<option value="T" <cfif isdefined("form.RHEestado") and form.RHEestado eq 'T'>selected</cfif>>Terminado</option> 
						</select>
				  	</td>
					<td>
						<input type="submit" name="btn_filtrar" value="Filtrar">
					</td>
				</tr>
			</table>
			</form>
		</td>
	</tr>	
	<tr>
		<td>
			<cfinvoke 
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsLista#"/> 
				<cfinvokeargument name="desplegar" value="RHEdescripcion, RHEfdesde, RHEfhasta, RHEestado"/> 
				<cfinvokeargument name="etiquetas" value="Escenario, Fecha desde, Fecha hasta, Estado"/> 
				<cfinvokeargument name="formatos" value="S,D,D,S"/> 
				<cfinvokeargument name="align" value="left,left,left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="ConlisEscenarios.cfm"/> 
				<cfinvokeargument name="formname" value="form1"/> 
				<cfinvokeargument name="maxrows" value="15"/> 				
				<cfinvokeargument name="funcion" value="Asignar#index#"/>
				<cfinvokeargument name="fparams" value="RHEid, RHEdescripcion, RHEfdesde, RHEfhasta"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			</cfinvoke> 
		</td>
	</tr>
</table>
</cfoutput>

</body>
</html>