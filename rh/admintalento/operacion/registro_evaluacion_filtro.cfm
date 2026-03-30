<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.fRHRSestado") and not isdefined("Form.fRHRSestado")>
	<cfparam name="Form.fRHRSestado" default="#Url.fRHRSestado#">
</cfif>
<cfif isdefined("Url.fRHRStipo") and not isdefined("Form.fRHRStipo")>
	<cfparam name="Form.fRHRStipo" default="#Url.fRHRStipo#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
 	<cfset filtro = filtro & " and b.DEid=" & UCase(Form.DEid)>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.fRHRSestado") and Len(Trim(Form.fRHRSestado)) NEQ 0>
 	<cfset filtro = filtro & " and RHRSestado = " & Form.fRHRSestado>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHRSestado=" & Form.fRHRSestado>
</cfif>
<cfif isdefined("Form.fRHRStipo") and Len(Trim(Form.fRHRStipo)) NEQ 0>
 	<cfset filtro = filtro & " and RHRStipo = '" & Form.fRHRStipo &"'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHRStipo=" & Form.fRHRStipo>
</cfif>

<form action="registro_evaluacion.cfm" method="post" style="margin:0" name="form1">
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0" class="areafiltro">
  <tr>
    <td><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate></td>
    <td>
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			<cfquery name="rsQuery" datasource="#session.DSN#">
				 select a.NTIcodigo, 
						a.DEid, 
						a.DEidentificacion, 
						<cf_dbfunction name="concat" args="a.DEapellido1 ,' ',a.DEapellido2,' ',a.DEnombre"> as NombreEmp
				from DatosEmpleado a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>
			<cf_rhempleado tabindex="1" size="30" form="form1" query="#rsQuery#">
		<cfelse>
			<cf_rhempleado tabindex="1" size="30" form="form1">
		</cfif>				
	</td>
    <td><cf_translate key="LB_Estado" XmlFile="/rh/generales.xml">Estado</cf_translate></td>
    <td>
		<select name="fRHRSestado" tabindex="0">
			<option value=""><cf_translate key="CMB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate></option>
			<option value="10" <cfif  isdefined("form.fRHRSestado") and form.fRHRSestado eq 10>selected</cfif>><cf_translate key="CMB_EnProceso">En Proceso</cf_translate></option>
			<option value="20" <cfif  isdefined("form.fRHRSestado") and form.fRHRSestado eq 20>selected</cfif>><cf_translate key="CMB_Publicada">Publicada</cf_translate></option>
			<option value="30" <cfif  isdefined("form.fRHRSestado") and form.fRHRSestado eq 30>selected</cfif>><cf_translate key="CMB_Cerrada">Cerrada</cf_translate></option>
		</select>
	</td>
	<td><cf_translate key="LB_Tipo">Tipo</cf_translate></td>
	<td>
		<select name="fRHRStipo">
			<option value=""><cf_translate key="CMB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate></option>
			<option value="C" <cfif isdefined("form.fRHRStipo") and form.fRHRStipo EQ 'C'>selected</cfif>><cf_translate key="LB_Competencia">Competencia</cf_translate></option>
			<option value="O" <cfif isdefined("form.fRHRStipo") and form.fRHRStipo EQ 'O'>selected</cfif>><cf_translate key="LB_Objetivo">Objetivo</cf_translate></option>
		</select>
	</td>
    <td>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Filtrar"/>		
		<input tabindex="0" name="btnBuscar" type="submit" id="btnBuscar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
	</td>
  </tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	var f = document.form1;	
</script>