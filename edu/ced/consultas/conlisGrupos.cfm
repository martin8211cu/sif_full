<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Lista Grupos </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--- <link href="../../css/portlets.css" rel="stylesheet" type="text/css"> --->
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>
	<cfif isdefined("Url.SPEcodigo") and not isdefined("Form.SPEcodigo")>
		<cfparam name="Form.SPEcodigo" default="#Url.SPEcodigo#">
	</cfif> 
	<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
	</cfif> 
	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif> 
	
<!--- Consulta de Alumnos --->
	  <cfquery datasource="#Session.Edu.DSN#" name="conlis">
				Select distinct convert(varchar,b.GRcodigo) as Grupo, GRnombre
				from 	Alumnos a
						, GrupoAlumno b
						, Grupo c
						, Nivel d
						, Grado e
				where 	a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						<cfif isdefined("form.Ncodigo") and len(trim(form.Ncodigo)) NEQ 0>
							and c.Ncodigo =  #Form.Ncodigo#
						</cfif> 
						<cfif isdefined("form.PEcodigo") and len(trim(form.PEcodigo)) NEQ 0>
							and c.PEcodigo =  #Form.PEcodigo#
						</cfif> 
						<cfif isdefined("form.SPEcodigo") and len(trim(form.SPEcodigo)) NEQ 0>
							and c.SPEcodigo =  #Form.SPEcodigo#
						</cfif> 
						and a.CEcodigo=b.CEcodigo
						and a.Ecodigo=b.Ecodigo
						and b.GRcodigo  = c.GRcodigo
						and c.Ncodigo=d.Ncodigo
						and c.Gcodigo=e.Gcodigo
				order by Norden, Gorden, GRnombre
	</cfquery>	
	
	<script language="JavaScript" type="text/javascript">
		var gradostext = new Array();
		var grados = new Array();
		var niveles = new Array();
		
		function noMatr(obj){
			if(obj.checked)
				obj.form.FAretirado.checked = false;
		}
	</script>	

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
			window.opener.document.<cfoutput>#url.form#.#url.Grupo#</cfoutput>.value=valor;
			window.opener.document.<cfoutput>#url.form#.#url.GRnombre#</cfoutput>.value=Nomb;
			window.close();
		}
	</script>

<body>
	<form action="" method="post" name="conlis">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="areaFiltro">
		  <td>&nbsp;</td>
		</tr>
		<tr>
		  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr class="tituloListas"> 
				  <td width="59%" class="tituloListas">Nombre</td>
				  
            <td width="41%" class="tituloListas">&nbsp;</td>
				</tr>
	
				<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 	  
				  <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					<td>
  						<a href="javascript:Asignar(#conlis.Grupo#,'#JSStringFormat(conlis.GRnombre)#');">
							#conlis.GRnombre#
						</a>			
					</td>
					<td>&nbsp;
  						
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