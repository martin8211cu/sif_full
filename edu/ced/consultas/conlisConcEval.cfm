<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Lista de Conceptos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--- <link href="../../css/portlets.css" rel="stylesheet" type="text/css"> --->
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>

	<cfif isdefined("Url.Mconsecutivo") and not isdefined("Form.Mconsecutivo")>
		<cfparam name="Form.Mconsecutivo" default="#Url.Mconsecutivo#">
	</cfif> 
	<cfif isdefined("Url.GRcodigo") and not isdefined("Form.GRcodigo")>
		<cfparam name="Form.GRcodigo" default="#Url.GRcodigo#">
	</cfif> 
	<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
	</cfif> 		
	

<!--- Consulta de Alumnos --->
	 <cfquery name="conlis" datasource="#Session.Edu.DSN#">
		select distinct convert(varchar,evc.ECcodigo) as ECcodigo, ECnombre, GRnombre, Ndescripcion
		from Curso c, EvaluacionConceptoCurso evc, EvaluacionConcepto ec, PeriodoEvaluacion pe, Grupo gr, Nivel n
		where c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			<cfif isdefined("form.btnFiltraAlum") and isdefined("form.Mconsecutivo") AND #form.Mconsecutivo# NEQ "-1" >
				and Mconsecutivo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mconsecutivo#"> 
			</cfif>
			and c.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GRcodigo#"> 
			and evc.PEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#"> 
			<cfif isdefined("form.btnFiltraAlum") and isdefined("form.nombreConc") AND #form.nombreConc# NEQ "" >
				and upper(ECnombre) like upper('%#Form.nombreConc#%')				
			</cfif>			
			and c.CEcodigo=ec.CEcodigo
			and c.Ccodigo=evc.Ccodigo
			and c.GRcodigo=gr.GRcodigo
			and evc.ECcodigo=ec.ECcodigo
			and evc.PEcodigo=pe.PEcodigo
			and gr.Ncodigo=n.Ncodigo
			and n.Ncodigo=pe.Ncodigo
		Order by ECorden, PEorden, ECnombre
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
			window.opener.document.<cfoutput>#url.form#.#url.ECcodigo#</cfoutput>.value=valor;
			window.opener.document.<cfoutput>#url.form#.#url.NombConc#</cfoutput>.value=Nomb;	
 			window.close();
		}
	</script>

<body>
	<form action="" method="post" name="conlis">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="areaFiltro">
		  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr class="encabReporte"> 
            <td width="60%" class="subTitulo">Nivel: <cfoutput>#conlis.Ndescripcion#</cfoutput></td>
            <td colspan="2" class="subTitulo">Grupo: <cfoutput>#conlis.GRnombre#</cfoutput></td>
          </tr>
          <tr> 
            <td colspan="2" class="subTitulo">Nombre del Concepto</td>
            <td width="12%" rowspan="2" align="center" valign="middle"><input name="btnFiltraAlum" type="submit" id="btnFiltraAlum" value="Filtrar" /></td>
          </tr>
          <tr> 
            <td colspan="2"><input name="nombreConc" type="text" id="nombreConc" onfocus="this.select()" size="120" maxlength="180" value="<cfif isdefined("form.btnFiltraAlum") and isdefined("form.nombreAlumno") AND #form.nombreAlumno# NEQ "" ><cfoutput>#form.nombreAlumno#</cfoutput></cfif>"/></td>
          </tr>
        </table>
      </td>
		</tr>
		<tr>
		  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr class="tituloListas"> 
            <td width="59%" class="tituloListas">Nombre</td>
          </tr>
            <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
              <td> 
                <a href="javascript:Asignar(-1,'-- Todos --');"> 
                -- Todos -- </a> </td>
            </tr>		  
          <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
            <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
              <td> 
                <a href="javascript:Asignar(#conlis.ECcodigo#,'#JSStringFormat(conlis.ECnombre)#');"> 
                #conlis.ECnombre# </a> </td>
            </tr>
          </cfoutput> 
          <tr> 
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