<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Lista de Alumnos por Nivel y Grupo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--- <link href="../../css/portlets.css" rel="stylesheet" type="text/css"> --->
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>

	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif> 
	<cfif isdefined("Url.GRcodigo") and not isdefined("Form.GRcodigo")>
		<cfparam name="Form.GRcodigo" default="#Url.GRcodigo#">
	</cfif> 	
	

<!--- Consulta de Alumnos --->
	<cfquery name="conlis" datasource="#Session.Edu.DSN#">
		select  pr.Ncodigo
				, ga.GRcodigo
				,convert(varchar,al.Ecodigo) as Ecodigo
				, pe.persona
				, (pe.Papellido1 + ' ' + pe.Papellido2 + ',' + pe.Pnombre) as Nombre
				, p.Pnombre
				, convert(varchar,pe.Pnacimiento,103) as Pnacimiento
				, pe.Pid
				, case when al.Aretirado=0 then 'Activo' when al.Aretirado=1 then 'Retirado' when al.Aretirado=2 then 'Graduado' end as estado 
				, Ndescripcion
				, GRnombre
		from PersonaEducativo pe
				, Pais p
				, Alumnos al
				, Estudiante es
				, GrupoAlumno ga 
				, Grupo gr
				, Promocion pr	
				, Nivel n
				, PeriodoVigente pv
		where pe.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and pr.PRactivo = 1
			and pr.Ncodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#"> 
			and ga.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GRcodigo#"> 
			<cfif isdefined("form.btnFiltraAlum") and isdefined("form.nombreAlumno") AND #form.nombreAlumno# NEQ "" >
				and upper((pe.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like upper('%#Form.nombreAlumno#%')
			</cfif>
			<cfif isdefined("form.filtro_Pid") and isdefined("form.filtro_Pid") AND #form.filtro_Pid# NEQ "" >
				and upper(Pid) like upper('%#Form.filtro_Pid#%')
			</cfif> 				
			and pe.Ppais = p.Ppais 
			and pe.persona = al.persona 
			and pe.CEcodigo = al.CEcodigo 
			and al.CEcodigo=n.CEcodigo
			and al.persona = es.persona 
			and al.Ecodigo = es.Ecodigo 
			and es.Ecodigo = ga.Ecodigo 
			and al.CEcodigo = ga.CEcodigo 
			and ga.GRcodigo=gr.GRcodigo
			and al.PRcodigo = pr.PRcodigo 
			and pr.PEcodigo = pv.PEcodigo 
			and pr.SPEcodigo = pv.SPEcodigo 
			and pv.PEcodigo = gr.PEcodigo 
			and pv.SPEcodigo = gr.SPEcodigo 
			and pr.Ncodigo=n.Ncodigo
			order by Nombre	
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
		function Asignar(valor,Nomb) {
			window.opener.document.<cfoutput>#url.form#.#url.Ecodigo#</cfoutput>.value=valor;
			window.opener.document.<cfoutput>#url.form#.#url.NombreAl#</cfoutput>.value=Nomb;	
 			window.close();
		}
	</script>

<body>
	<form action="" method="post" name="conlis">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="areaFiltro">
		  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr class="encabReporte"> 
            <td class="subTitulo">Nivel: <cfoutput>#conlis.Ndescripcion#</cfoutput></td>
            <td colspan="2" class="subTitulo">Grupo: <cfoutput>#conlis.GRnombre#</cfoutput></td>
          </tr>
          <tr> 
            <td class="subTitulo">Nombre del Alumno</td>
            <td class="subTitulo">Identificaci&oacute;n</td>
            <td width="12%" rowspan="2" align="center" valign="middle"><input name="btnFiltraAlum" type="submit" id="btnFiltraAlum" value="Filtrar" /></td>
          </tr>
          <tr> 
            <td width="60%"><input name="nombreAlumno" type="text" id="nombreAlumno" onfocus="this.select()" size="80" maxlength="180" value="<cfif isdefined("form.btnFiltraAlum") and isdefined("form.nombreAlumno") AND #form.nombreAlumno# NEQ "" ><cfoutput>#form.nombreAlumno#</cfoutput></cfif>"/></td>
            <td width="19%"><input name="filtro_Pid" type="text" id="filtro_Pid" onfocus="this.select()" size="30" maxlength="60" value="<cfif isdefined("form.btnFiltraAlum") and isdefined("form.filtro_Pid") AND #form.filtro_Pid# NEQ "" ><cfoutput>#form.filtro_Pid#</cfoutput></cfif>" /></td>
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
				  <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					<td>
  						<a href="javascript:Asignar(-1,'-- Todos --');">
							-- Todos --
						</a>			
					</td>
					<td>
  						<a href="javascript:Asignar(-1,'-- Todos --');">   
							****
						</a>			
					</td>
				  </tr>					
				<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 	  
				  <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					<td>
  						<a href="javascript:Asignar(#conlis.Ecodigo#,'#JSStringFormat(conlis.Nombre)#');">
							#conlis.Nombre#
						</a>			
					</td>
					<td>
  						<a href="javascript:Asignar(#conlis.Ecodigo#,'#JSStringFormat(conlis.Nombre)#');">   
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