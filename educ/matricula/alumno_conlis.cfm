	<cfif isdefined("Url.TPer") and not isdefined("Form.TPer")>
		<cfparam name="Form.TPer" default="#Url.TPer#">
	</cfif>
	<cfparam name="Form.TPer" default="A">		
	<cfif isdefined("Url.Pid_filtro") and not isdefined("Form.Pid_filtro")>
		<cfparam name="Form.Pid_filtro" default="#Url.Pid_filtro#">
	</cfif>
		<cfparam name="Form.Pid_filtro" default="">
	<cfif isdefined("Url.Pnombre_filtro") and not isdefined("Form.Pnombre_filtro")>
		<cfparam name="Form.Pnombre_filtro" default="#Url.Pnombre_filtro#">
	</cfif>
		<cfparam name="Form.Pnombre_filtro" default="">
	<cfif isdefined("Url.Pmail1_filtro") and not isdefined("Form.Pmail1_filtro")>
		<cfparam name="Form.Pmail1_filtro" default="#Url.Pmail1_filtro#">
	</cfif>
	
	<cfparam name="Form.Pmail1_filtro" default="">

	<cfset irA = "">
	<cfset keys = "Apersona">
	<cfset select = "">	
	<cfset from   = "">	
	<cfset where  = "">	
	
	<cfif form.TPer EQ 'D' or form.TPer EQ 'A'>		<!--- (Docente o Administrativo) o Alumno --->
		<cfset select = "convert(varchar,Apersona) as Apersona
				, (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as PnombreCompleto
				, Pid">	
		<cfif form.TPer EQ 'D'>
			<cfset from   = "Docente">
		<cfelseif form.TPer EQ 'A'>
			<cfset from   = "Alumno">
		</cfif>
		<cfset where  = " Ecodigo=#session.Ecodigo#
			and Usucodigo=#session.Usucodigo#">
	<cfelseif form.TPer EQ 'TA'>	<!--- Administrativo --->			
		<cfset select = "convert(varchar,Apersona) as Apersona
				, (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as PnombreCompleto
				, Pid">	
		<cfset from   = "Alumno">
		<cfset where  = "Ecodigo=#session.Ecodigo#">
	<cfelseif form.TPer EQ 'G'>	<!--- Profesor Guia --->
		<cfset select = "convert(varchar,pga.Apersona) as Apersona
				, (a.Pnombre + ' ' + a.Papellido1 + ' ' + a.Papellido2) as PnombreCompleto
				, a.Pid">	
		<cfset from = " ProfesorGuia pg
				, ProfesorGuiaAlumno pga
				, Alumno a">	
		<cfset where  = " 
				pg.Usucodigo=#session.Usucodigo#
				and pg.Ecodigo=#session.Ecodigo#
				and pg.PGpersona=pga.PGpersona
				and pga.Apersona=a.Apersona">
	</cfif>	
	
	<cfset filtro = "">				
	<cfset navegacion = "">
	<cfif isdefined("form.Pid_filtro") and len(trim(form.Pid_filtro)) gt 0>
		<cfset filtro = filtro & " and Pid = '#form.Pid_filtro#'">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pid_filtro=" & Form.Pid_filtro>
	</cfif>
	<cfif isdefined("form.Pnombre_filtro") and len(trim(form.Pnombre_filtro)) gt 0>
		<cfset filtro = filtro & " and Upper(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) like Upper('%#form.Pnombre_filtro#%')">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pnombre_filtro=" & Form.Pnombre_filtro>
	</cfif>
	<cfif isdefined("form.Pemail1_filtro") and len(trim(form.Pemail1_filtro)) gt 0>
		<cfset filtro = filtro & " and Upper(Pemail1) like Upper('%#form.Pemail1_filtro#%')">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pemail1_filtro=" & Form.Pemail1_filtro>
	</cfif>
	
	<!--- Yu Hui 1 Abril 2004
	<cfif form.TPer EQ 'D' or form.TPer EQ 'A'>	<!--- (Docente o Administrativo) o Alumno --->	
		<cfset filtro = filtro & " order by Pnombre">				
	<cfelseif form.TPer EQ 'G'>	<!--- Profesor Guia --->
		<cfset filtro = filtro & " order by a.Pnombre">					
	</cfif>		
	--->
	<cfif Session.Menues.SScodigo EQ 'RH'>
		<cfset filtro = filtro & " order by Pid">
	<cfelse>
		<cfset filtro = filtro & " order by PnombreCompleto">
	</cfif>
<html>
<head>
<title>Lista de Estudiantes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/educ/css/educ.css" rel="stylesheet" type="text/css">
</head>
<body>
	<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>			
	<form name="formAlumno_filtro" method="post" action="" style="margin: 0">
		<cfoutput>
		  
    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="##CCCCCC">
      <tr> 
        <td width="5%">&nbsp;</td>
        <td width="27%"><strong>Número Identificación</strong></td>
        <td width="32%"><strong>eMail</strong></td>
        <td width="41%" rowspan="5" align="center" valign="middle"><input name="btnFiltro" type="submit" id="btnFiltro" value="Buscar"> 
        </td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td><input name="Pid_filtro"  id="Pid_filtro" type="text" value="<cfif isdefined('form.Pid_filtro') and form.Pid_filtro NEQ ''>#form.Pid_filtro#</cfif>" size="20" maxlength="20"></td>
        <td><input name="Pemail1_filtro"  id="Pemail1_filtro" type="text" value="<cfif isdefined('form.Pemail1_filtro') and form.Pemail1_filtro NEQ ''>#form.Pemail1_filtro#</cfif>" size="20" maxlength="20"></td>
      </tr>
      <tr> 
        <td width="0%">&nbsp;</td>
        <td width="27%"><strong>Nombre</strong></td>
        <td width="32%">&nbsp;</td></td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td colspan="2"><input name="Pnombre_filtro"  id="Pnombre_filtro" type="text" value="<cfif isdefined('form.Pnombre_filtro') and form.Pnombre_filtro NEQ ''>#form.Pnombre_filtro#</cfif>" size="80" maxlength="80"></td>
      </tr>
      <tr> 
        <td width="0%">&nbsp;</td>
        <td width="27%">&nbsp;</td>
        <td width="32%">&nbsp;</td></td>
      </tr>
    </table>
		</cfoutput>
	</form>	   
	<cfinvoke component="educ.componentes.pListas" 
			  method="pListaEdu" 
			  returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="#from#"/>
		<cfinvokeargument name="columnas" value="#select#"/>
		<cfinvokeargument name="desplegar" value="Pid, PnombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="Número ID, Nombre"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="
			#where# #filtro#"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="S,S"/>
		<cfinvokeargument name="keys" value="#keys#"/>
		<cfinvokeargument name="irA" value="#irA#"/>
		<cfinvokeargument name="funcion" value="fnSelecciona"/>
		<cfinvokeargument name="fParams" value="#keys#"/>
		<cfinvokeargument name="Botones" value=""/>
		<cfinvokeargument name="debug" value="N"/>				
		<cfinvokeargument name="formName" value="formAlumno_conlis"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>			   
	
	<script language="JavaScript" type="text/javascript">
		function fnSelecciona(Apersona)
		{
			if (opener.fnAlumno_conlis)
			  opener.fnAlumno_conlis (Apersona);
			window.close();
		}		
	</script>
</body>
</html>