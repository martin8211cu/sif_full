<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Lista de Encargados</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--- <link href="../../css/portlets.css" rel="stylesheet" type="text/css"> --->
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>
<!--- Consulta de Encargados --->
	<cfquery name="conlis" datasource="#Session.Edu.DSN#">
		select EEcodigo,a.persona, (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as Nombre, Pid, convert(varchar,Pnacimiento,103) as Pnacimiento, Pdireccion
		from Encargado a, PersonaEducativo b
		where  	a.persona=b.persona
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and EEcodigo not in (
						Select a.EEcodigo
						from EncargadoEstudiante a, Alumnos b
						where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
								and b.persona=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
								and a.CEcodigo=b.CEcodigo
								and a.Ecodigo=b.Ecodigo )						
		<cfif isdefined("form.btnFiltraEncar") and isdefined("form.nombreEnc") AND #form.nombreEnc# NEQ "" >
			and Upper(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) like upper('%#form.nombreEnc#%')			
		</cfif> 
		<cfif isdefined("form.filtro_Pid") and isdefined("form.filtro_Pid") AND #form.filtro_Pid# NEQ "" >
			and Upper(Pid) like Upper('%#form.filtro_Pid#%')
		</cfif> 		
		order by Nombre
	</cfquery>
	
	<!--- Para cargar en memoria el codigo del estudiante "Ecodigo" --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsEcodigo">
		Select convert(varchar,a.Ecodigo) as Ecodigo
		from Alumnos a, Estudiante b
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
			and a.persona=b.persona
			and a.Ecodigo=b.Ecodigo
	</cfquery>	

	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfparam name="PageNum_conlis" default="1">
	<cfset MaxRows_conlis=16>
	<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
	<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
	<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
	<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
	<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
	</cfif>

	<script language="JavaScript1.2" type="text/javascript">
		function Asignar(valor,Nomb,Ced,FNacim,Direcc) {
			window.opener.document.<cfoutput>#url.form#.#url.EEcodigo#</cfoutput>.value=valor;
			window.opener.document.<cfoutput>#url.form#.#url.NombreEncar#</cfoutput>.value=Nomb;	
 			window.opener.document.<cfoutput>#url.form#.#url.PidEncar#</cfoutput>.value=Ced;				
			window.opener.document.<cfoutput>#url.form#.#url.FechaNacEncar#</cfoutput>.value=FNacim;				
			window.opener.document.<cfoutput>#url.form#.#url.PdireccionEncar#</cfoutput>.value=Direcc;
			window.opener.document.<cfoutput>#url.form#.#url.Ecodigo#</cfoutput>.value=<cfoutput>#rsEcodigo.Ecodigo#</cfoutput>;
				
 			window.close();
		}
	</script>

<body>
	<form action="" method="post" name="conlis">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="areaFiltro">
		  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="subTitulo">Nombre del encargado</td>
            <td class="subTitulo">Identificaci&oacute;n</td>
            <td width="12%" rowspan="2" align="center" valign="middle"><input name="btnFiltraEncar" type="submit" id="btnFiltraEncar" value="Filtrar" /></td>
          </tr>
          <tr> 
            <td width="60%"><input name="nombreEnc" type="text" id="nombreEnc2" onfocus="this.select()" size="80" maxlength="180" value="<cfif isdefined("form.btnFiltraEncar") and isdefined("form.nombreEnc") AND #form.nombreEnc# NEQ "" ><cfoutput>#form.nombreEnc#</cfoutput></cfif>"/></td>
            <td width="19%"><input name="filtro_Pid" type="text" id="filtro_Pid" onfocus="this.select()" size="30" maxlength="60" value="<cfif isdefined("form.btnFiltraEncar") and isdefined("form.filtro_Pid") AND #form.filtro_Pid# NEQ "" ><cfoutput>#form.filtro_Pid#</cfoutput></cfif>" /></td>
          </tr>
        </table>
      </td>
		</tr>
		<tr>
		  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr class="tituloListas"> 
				  <td width="59%" class="tituloListas">Nombre</td>
				  <td width="41%" class="tituloListas">Identificaci&oacute;n</td>
				</tr>
	
				<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 	  
				  <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					<td>
  						<a href="javascript:Asignar(#conlis.EEcodigo#,'#JSStringFormat(conlis.Nombre)#','#JSStringFormat(conlis.Pid)#','#JSStringFormat(conlis.Pnacimiento)#','#JSStringFormat(conlis.Pdireccion)#');">
							#conlis.Nombre#
						</a>			
					</td>
					<td>
  						<a href="javascript:Asignar(#conlis.EEcodigo#,'#JSStringFormat(conlis.Nombre)#','#JSStringFormat(conlis.Pid)#','#JSStringFormat(conlis.Pnacimiento)#','#JSStringFormat(conlis.Pdireccion)#');">   
							#conlis.Pid#
						</a>			
					</td>
				  </tr>
				 </cfoutput>  
			  <tr> 
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			</table></td>
		</tr>
		<tr>
		  <td>
			<!--- Botones de la lista --->
				<table border="0" width="50%" align="center">
				  <cfoutput> 
					<tr> 
					  <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
						  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../Imagenes/First.gif" border=0></a> 
						</cfif> </td>
					  <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
						  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../Imagenes/Previous.gif" border=0></a> 
						</cfif> </td>
					  <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
						  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../Imagenes/Next.gif" border=0></a> 
						</cfif> </td>
					  <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
						  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../Imagenes/Last.gif" border=0></a> 
						</cfif> </td>
					</tr>
				  </cfoutput> 
			  </table>	  
		  </td>
		</tr>
	  </table>
	</form>
</body>
</html>