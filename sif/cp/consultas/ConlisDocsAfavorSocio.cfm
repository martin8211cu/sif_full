<!--- 
	Modificado por: Gustavo Fonseca Hernández.
		Fecha: 7-10-2005.
		Motivo: Se corrige una caracter extraño donde debía ir una "ó" y se cambia la "+" por "||" como forma de concatenación.
 --->
<html>
<head>
<title>Lista de Documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>
	<cf_dbfunction name="to_char" args="b.IDdocumento" returnvariable="IDdocumento">
	<cf_dbfunction name="to_char" args="a.Mcodigo" returnvariable="Mcodigo">
	<cf_dbfunction name="to_char" args="b.Ccuenta" returnvariable="Ccuenta">
	<cf_dbfunction name="to_char" args="Dtipocambio" returnvariable="Dtipocambio">
	<cf_dbfunction name="to_char" args="EDsaldo" returnvariable="EDsaldo">
	<cf_dbfunction name="to_char" args="Cdescripcion" returnvariable="Cdescripcion">
	
	<cfquery name="conlis" datasource="#Session.DSN#">
		select <cf_dbfunction name="concat"	args="rtrim(#IDdocumento#),'|',rtrim(#Mcodigo#),'|',rtrim(b.CPTcodigo),'|',rtrim(b.Ddocumento),'|',rtrim(#Ccuenta#),'|',#Dtipocambio#,'|',#EDsaldo#,'|',#Cdescripcion#	,'|',rtrim(#IDdocumento#)">  as IDdocumento, 
		rtrim(<cf_dbfunction name="to_char" args="b.Ddocumento">) as Ddocumento, 
		Cdescripcion,
	    <cf_dbfunction name="concat" args="rtrim(b.CPTcodigo) , '-'+rtrim(b.Ddocumento) ,'-' ,rtrim(a.Mnombre)"> as Documento,
		a.Mnombre as Mnombre, 
		rtrim(b.CPTcodigo) as CPTcodigo
		from EDocumentosCP b
			inner join Monedas a
				on a.Mcodigo = b.Mcodigo 
			inner join CContables c
				on b.Ccuenta = c.Ccuenta  
			inner join CPTransacciones d
				on b.Ecodigo = d.Ecodigo 
		       and b.CPTcodigo = d.CPTcodigo
		where b.Ecodigo =  #Session.Ecodigo# 
		   and EDsaldo > 0  
		  and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Socio#"> 
		  and d.CPTtipo = 'C'
		  and coalesce(d.CPTpago,0) != 1
		  and <cf_dbfunction name="concat"	args="b.CPTcodigo, b.Ddocumento"> not in 
						  (select <cf_dbfunction name="concat"	args="h.DAtransref, h.DAdocref"> 
						  	  from DAplicacionCP h 
							where b.Ecodigo=h.Ecodigo )
		  <cfif isdefined("Form.Filtrar") and (Form.Mnombre NEQ "")>
		  	and upper(Mnombre) like '%#Ucase(Form.Mnombre)#%'
		  </cfif>
		  <cfif isdefined("Form.Filtrar") and (Form.Ddocumento NEQ "")>
			and upper(Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
		  </cfif>
  		  <cfif isdefined("Form.Filtrar") and (Form.Cdescripcion NEQ "")>
			and upper(Cdescripcion) like '%#Ucase(Form.Cdescripcion)#%'
		  </cfif>
		  <cfif isdefined("Form.Filtrar") and (Form.CPTcodigo NEQ "")>
			and upper(b.CPTcodigo) like '%#Ucase(Form.CPTcodigo)#%'
		  </cfif>
		order by b.CPTcodigo,b.Ddocumento 
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

<script language="JavaScript1.2">
function Asignar(valor1, valor2 ) {
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.opener.obtieneValores(window.opener.document.<cfoutput>#url.form#</cfoutput>, valor1);
	window.close();
}
</script>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset MSG_Descripcion 	= t.Translate('MSG_Descripcion','Descripci&oacute;n','/sif/generales.xml')>
<cfset BTN_Filtrar 	= t.Translate('BTN_Filtrar','Filtrar','/sif/generales.xml')>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
  	<cfoutput>
    <tr>
      <td width="10%"  class="tituloListas"><div align="left">#LB_Transaccion#</div></td>
      <td width="30%" class="tituloListas"> <div align="left">#LB_Documento#</div>
        <div align="left"></div>
        <div align="left"></div>
        <div align="right"><font color="#FFFFFF"> </font></div></td>
      <td width="30%" class="tituloListas">#LB_Moneda#</td>
      <td width="30%" class="tituloListas">#MSG_Descripcion#</td>
      <td align="right" class="tituloListas">
        <input type="submit" name="Filtrar" value="#BTN_Filtrar#">
        </td>
    </tr>
    </cfoutput>
    <tr>
      <td><input name="CPTcodigo" type="text" size="15" maxlength="2"></td>
      <td> <input name="Ddocumento" type="text" size="25" maxlength="20"> </td>
      <td><input name="Mnombre" type="text" size="25" maxlength="80"></td>
      <td><input name="Cdescripcion" type="text" size="40" maxlength="80"></td>
      <td>&nbsp;</td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr>
        <td align="center" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>> 
          <a href="javascript:Asignar('#conlis.IDdocumento#','#JSStringFormat(conlis.Documento)#');">#conlis.CPTcodigo#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="SNcodigo#conlis.CurrentRow#" value="#conlis.Ddocumento#"> 
          <a href="javascript:Asignar('#conlis.IDdocumento#','#JSStringFormat(conlis.Documento)#');">#conlis.Ddocumento#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#conlis.IDdocumento#','#JSStringFormat(conlis.Documento)#');">#conlis.Mnombre#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#conlis.IDdocumento#','#JSStringFormat(conlis.Documento)#');">#Mid(conlis.Cdescripcion,1,45)#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>&nbsp;</td>
      </tr>
    </cfoutput> 
    <tr> 

    <tr>
      <td width="13%">&nbsp;</td>
      <td width="13%">&nbsp;</td>
      <table border="0" width="50%" align="center">
        <cfoutput> 
          <tr> 
            <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a> 
              </cfif> </td>
            <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a> 
              </cfif> </td>
            <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a> 
              </cfif> </td>
            <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a> 
              </cfif> </td>
          </tr>
        </cfoutput> 
      </table>
      <div align="center"> </div></td>
    </tr>
  </table>
</form>
</body>
</html>