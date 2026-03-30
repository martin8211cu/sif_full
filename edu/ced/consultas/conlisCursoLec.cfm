<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Lista Cursos Lectivos </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--- <link href="../../css/portlets.css" rel="stylesheet" type="text/css"> --->
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>



<!--- Consulta de Alumnos --->

	<cfquery name="conlis" datasource="#Session.Edu.DSN#">
Select distinct	convert(varchar,spe.PEcodigo) as PEcodigo, 
				convert(varchar,spe.SPEcodigo) as SPEcodigo,
				convert(varchar,d.Ncodigo) as Ncodigo, 
				d.Ndescripcion ,
				spe.SPEorden, substring(spe.SPEdescripcion,1,50) as SPEdescripcion, 
				convert(varchar,spe.SPEfechafin,103) as SPEfechafin, 
				convert(varchar,spe.SPEfechainicio,103) as SPEfechainicio , d.Ndescripcion + ' : ' + pe.PEdescripcion as PEdescripcion
				from Alumnos a , GrupoAlumno b , Grupo c , Nivel d , Grado e , SubPeriodoEscolar spe, PeriodoEscolar  pe
				where a.CEcodigo=#Session.Edu.CEcodigo#
					and a.CEcodigo=b.CEcodigo 
					and a.Ecodigo=b.Ecodigo 
					and b.GRcodigo = c.GRcodigo 
					and c.Ncodigo=d.Ncodigo 
					and c.Gcodigo=e.Gcodigo 
					and c.PEcodigo = spe.PEcodigo 
					and c.SPEcodigo = spe.SPEcodigo 
					and spe.PEcodigo = pe.PEcodigo 
					and d.Ncodigo = pe.Ncodigo 
			  <cfif isdefined("form.FNcodigo") and form.FNcodigo NEQ "-1">
				 and c.Ncodigo =  #Form.FNcodigo#
			  </cfif> 
			  <cfif isdefined("form.filtro_ano") and len(trim(form.filtro_ano)) NEQ 0>
				 and (datepart(yy,spe.SPEfechainicio) =  #Form.filtro_ano# or datepart(yy,spe.SPEfechafin) =  #Form.filtro_ano#)
			  </cfif> 
			order by d.Norden, pe.PEorden, spe.SPEorden
	</cfquery>	
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
		select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  and Preesco = 0
		order by Norden
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
		function Asignar(valor,nivel,periodo,Nomb) {
			window.opener.document.<cfoutput>#url.form#.#url.SPEcodigo#</cfoutput>.value=valor;
			window.opener.document.<cfoutput>#url.form#.#url.Ncodigo#</cfoutput>.value=nivel;
			window.opener.document.<cfoutput>#url.form#.#url.PEcodigo#</cfoutput>.value=periodo;
			window.opener.document.<cfoutput>#url.form#.#url.SPEdescripcion#</cfoutput>.value=Nomb;
			window.close();
		}
	</script>

<body>
	<form action="" method="post" name="conlis">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="areaFiltro">
		  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="subTitulo">Nivel</td>
            <td class="subTitulo">A&ntilde;o</td>
            <td width="12%" rowspan="2" align="center" valign="middle"><input name="btnFiltraAlum" type="submit" id="btnFiltraAlum" value="Filtrar" /></td>
          </tr>
          <tr> 
            <td width="60%"><select name="FNcodigo" id="FNcodigo" tabindex="5">
                <option value="-1">Todos</option>
                <cfoutput query="rsNiveles"> 
                  <option value="#Ncodigo#" <cfif isdefined("Form.FNcodigo") AND (Form.FNcodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
                </cfoutput> </select></td>
            <td width="19%"><input name="filtro_ano" type="text" id="filtro_ano" onfocus="this.select()" size="15" maxlength="4" value="<cfif isdefined("form.btnFiltraAlum") and isdefined("form.filtro_ano") AND #form.filtro_ano# NEQ "" ><cfoutput>#form.filtro_ano#</cfoutput></cfif>" /></td>
          </tr>
          <tr>
            <td class="subTitulo">&nbsp;</td>
            <td class="subTitulo">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp; </td>
            <td>&nbsp; </td>
            <td>&nbsp;</td>
          </tr>		  
        </table>
      </td>
		</tr>
		<tr>
		  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr class="tituloListas"> 
				  <td width="59%" class="tituloListas">Nombre</td>
				  
            <td width="41%" class="tituloListas">Curso Lectivo</td>
				</tr>
	
				<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 	  
				  <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					<td>
  						<a href="javascript:Asignar(#conlis.SPEcodigo#,#conlis.Ncodigo#,#conlis.PEcodigo#,'#JSStringFormat(conlis.Ndescripcion&'-'&conlis.SPEdescripcion)#');">
							#conlis.Ndescripcion#
						</a>			
					</td>
					<td>
  						<a href="javascript:Asignar(#conlis.SPEcodigo#,#conlis.Ncodigo#,#conlis.PEcodigo#,'#JSStringFormat(conlis.Ndescripcion&'-'&conlis.SPEdescripcion)#');">   
							#conlis.SPEdescripcion#
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