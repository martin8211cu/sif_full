<html>
<head>
<title>Lista de Profesores</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>

<body>
	<cfif isdefined("Url.form") and not isdefined("Form.form")>
		<cfparam name="Form.form" default="#Url.form#">
	</cfif>
	<cfif isdefined("Url.id") and not isdefined("Form.id")>
		<cfparam name="Form.id" default="#Url.id#">
	</cfif>
	<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
		<cfparam name="Form.desc" default="#Url.desc#">
	</cfif>
	<cfif isdefined("Url.nombre") and not isdefined("Form.nombre")>
		<cfparam name="Form.nombre" default="#Url.nombre#">
	</cfif>
	<cfif isdefined("Url.Curso") and not isdefined("Form.Curso")>
		<cfparam name="Form.Curso" default="#Url.Curso#">
	</cfif>
	
	
	<cfquery name="conlis" datasource="#Session.Edu.DSN#">
		select a.Splaza, 
			   ((case
				   when (rtrim(u.Papellido1) is not null) then u.Papellido1 + ' '
				   else null
			   end) +
			   (case
				   when (rtrim(u.Papellido2) is not null) then u.Papellido2 + ' '
				   else null
			   end) +
			   rtrim(u.Pnombre)) as nombre
		from Staff a, PersonaEducativo u
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.persona = u.persona
		<cfif isdefined("Form.nombre") and Len(Trim(Form.nombre)) NEQ 0>
		  and upper((case
				   when (rtrim(u.Papellido1) is not null) then u.Papellido1 + ' '
				   else null
			   end) +
			   (case
				   when (rtrim(u.Papellido2) is not null) then u.Papellido2 + ' '
				   else null
			   end) +
			   rtrim(u.Pnombre)) like '%#Ucase(Form.nombre)#%'
		</cfif>
		and a.autorizado = 1
		and a.retirado = 0
		order by nombre
	</cfquery>
		

	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfparam name="PageNum_conlis" default="1">
	<cfset MaxRows_conlis=15>
	<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
	<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
	<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
	<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
	<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
	</cfif>

	<cfif isdefined("Form.nombre")>
		<cfset QueryString_conlis = "&desc=#Form.desc#&form=#Form.form#&id=#Form.id#&nombre=#Form.nombre#&Curso=#Form.Curso#">
	</cfif>

	<script language="JavaScript" type="text/javascript">
		function Asignar(cod, desc) {
			window.opener.document.<cfoutput>#Form.form#.#Form.id#</cfoutput>.value = cod;
			window.opener.document.<cfoutput>#Form.form#.#Form.desc#</cfoutput>.value = desc;
			document.updateForm.Splaza.value = cod;
			document.updateForm.Curso.value = '<cfoutput>#Form.Curso#</cfoutput>';
			document.updateForm.submit();
		}
	</script>

	<form name="filtro" method="post" action="../consultas/conlisProfesor.cfm">
		<input type="hidden" name="form" value="<cfoutput>#Form.form#</cfoutput>">
		<input type="hidden" name="id" value="<cfoutput>#Form.id#</cfoutput>">
		<input type="hidden" name="desc" value="<cfoutput>#Form.desc#</cfoutput>">
		<input type="hidden" name="Curso" value="<cfoutput>#Form.Curso#</cfoutput>">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
		  <tr>
			<td width="70%">Nombre del Profesor <input type="text" name="nombre" id="nombre" value="<cfif isdefined("Form.nombre")><cfoutput>#Form.nombre#</cfoutput></cfif>" size="40" maxlength="80"></td>
			<td width="30%" align="center">
				<input type="submit" name="btnFiltrar" value="Filtrar">
				<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript: this.form.nombre.value = '';">
			</td>
		  </tr>
		</table>
	</form>
	
	</cfif>
	
	<cfif isdefined("conlis") and conlis.recordCount GT 0>
          <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr> 
              <td class="tituloListas" >Nombre del Profesor</td>
            </tr>
              <tr> 
                <td <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> nowrap> 
                  <a href="javascript:Asignar('','--Profesor sin Asignar--');">--Profesor sin Asignar--</a></td>
              </tr>
            <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
              <tr> 
                <td <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> nowrap> 
                  <a href="javascript:Asignar('#JSStringFormat(Splaza)#','#JSStringFormat(nombre)#');">#nombre#</a> </td>
              </tr>
            </cfoutput> 
          </table>
          <br>
          <table border="0" width="50%" align="center">
            <cfoutput> 
              <tr> 
                <td width="23%" align="center"> 
                  <cfif PageNum_conlis GT 1>
                    <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../Imagenes/First.gif" border=0></a> 
                  </cfif>
                </td>
                <td width="31%" align="center"> 
                  <cfif PageNum_conlis GT 1>
                    <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../Imagenes/Previous.gif" border=0></a> 
                  </cfif>
                </td>
                <td width="23%" align="center"> 
                  <cfif PageNum_conlis LT TotalPages_conlis>
                    <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../Imagenes/Next.gif" border=0></a> 
                  </cfif>
                </td>
                <td width="23%" align="center"> 
                  <cfif PageNum_conlis LT TotalPages_conlis>
                    <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../Imagenes/Last.gif" border=0></a> 
                  </cfif>
                </td>
              </tr>
            </cfoutput> 
          </table>
	</cfif>
	
</body>
</html>
