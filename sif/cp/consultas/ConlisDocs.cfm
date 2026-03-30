<!--- 
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 7-10-2005.
		Motivo: Se modificó la el Javascript de la lista se cabió #conlis.IDdocumento)# por '#JSStringFormat(conlis.IDdocumento)#': 
		por perdida de presición de JavaScript.
 --->
<html>
<head>
<title>Lista de Transacciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<cf_templatecss>
</head>
<body>
<cfquery name="conlis" datasource="#Session.DSN#">
SELECT a.CPTcodigo, a.Ddocumento, a.Ddocumento , a.Dtipocambio, a.Mcodigo,c.Mnombre, d.Cdescripcion, a.Dtotal, a.EDsaldo,, b.CPTdescripcion,  
		<cf_dbfunction name="to_sdateDMY"	args="a.Dfecha"> as Dfecha, 
		<cf_dbfunction name="to_char"	    args="a.Ccuenta"> as Ccuenta, 
		<cf_dbfunction name="to_char"	    args="a.IDdocumento"> as IDdocumento    
FROM EDocumentosCP a
	inner join CPTransacciones b
		on a.Ecodigo=b.Ecodigo 
		and a.CPTcodigo=b.CPTcodigo 
	inner join Monedas c
		on a.Mcodigo=c.Mcodigo 
	inner join CContables d 
		on a.Ecodigo=d.Ecodigo 
	   and a.Ccuenta=d.Ccuenta 
where a.Ecodigo =  #Session.Ecodigo# 
  and a.EDsaldo > 0 
  and a.SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Socio#"> 
  and b.CPTtipo = 'D' 
  and coalesce(b.CPTpago, 0) != 1
  and (a.CPTcodigo+rtrim(a.Ddocumento)) not in (select (z.CPTcodigo+rtrim(z.Ddocumento)) 
  										from EAplicacionCP z where a.Ecodigo=z.Ecodigo) 

 <cfif isdefined("Form.Filtrar") and (Form.CPTcodigo NEQ "")>
	and upper(a.CPTcodigo) like '%#Ucase(Form.CPTcodigo)#%'
  </cfif>
  <cfif isdefined("Form.Filtrar") and (Form.Ddocumento NEQ "")>
	and upper(a.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
  </cfif>
   <cfif isdefined("Form.Filtrar") and (Form.Dfecha NEQ "")>
	and <cf_dbfunction name="to_sdateDMY"	args="a.Dfecha"> =  '#Form.Dfecha#'
  </cfif>
  <cfif isdefined("form.Filtrar") and (Form.Mnombre NEQ "")>
	and upper(c.Mnombre) like '%#Ucase(Form.Mnombre)#%'
  </cfif>
  order by CPTcodigo, Ddocumento
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

<script language="JavaScript">
function Asignar(valor1, valor2, valor3, valor4, valor5, valor6, valor7) {
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#.#url.nombre#</cfoutput>.value=valor3;
	window.opener.document.<cfoutput>#url.form#.#url.tipocambio#</cfoutput>.value=fm(valor4,4);
	window.opener.document.<cfoutput>#url.form#.#url.saldo#</cfoutput>.value=fm(valor5,2);
	window.opener.document.<cfoutput>#url.form#.disponible</cfoutput>.value=fm(valor5,2);
	window.opener.document.<cfoutput>#url.form#.#url.moneda#</cfoutput>.value=valor6;
	window.opener.document.<cfoutput>#url.form#.#url.IDdocument#</cfoutput>.value=valor7;
	window.close();
}
</script>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset BTN_Filtrar 	= t.Translate('BTN_Filtrar','Filtrar','/sif/generales.xml')>

<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
  	<cfoutput>
    <tr> 
      <td width="44%"  class="tituloListas"><div align="left">#LB_Transaccion#</div></td>
      <td width="28%"  class="tituloListas"><div align="left">#LB_Documento#</div></td>
      <td width="44%"  class="tituloListas"><div align="left">#LB_Fecha#</div></td>
      <td width="28%"  class="tituloListas"><div align="left">#LB_Moneda#</div></td>
      <td width="44%"  class="tituloListas"><div align="left">#LB_Monto#</div></td>
      <td width="28%"  class="tituloListas"><div align="left">#LB_Saldo#</div></td>
      <td width="1%" class="tituloListas"><div align="right">
          <input type="submit" name="Filtrar" value="#BTN_Filtrar#">
          </div></td>
    </tr>
    </cfoutput>
    <tr> 
      <td><input name="CPTcodigo" type="text" size="15" maxlength="2"></td>
      <td ><input name="Ddocumento" type="text" size="25" maxlength="25"></td>
	  <td ><input name="Dfecha" type="text" size="15" maxlength="12"></td>
	  <td ><input name="Mnombre" type="text" size="30" maxlength="80"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="CPTcodigo#conlis.CurrentRow#" value="#conlis.CPTcodigo#"> 
          <a href="javascript:Asignar('#JSStringFormat(conlis.CPTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.EDsaldo#,#conlis.Mcodigo#, '#JSStringFormat(conlis.IDdocumento)#');">#conlis.CPTcodigo#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CPTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.EDsaldo#,#conlis.Mcodigo#, '#JSStringFormat(conlis.IDdocumento)#');">#conlis.Ddocumento#</a></td>
		<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CPTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.EDsaldo#,#conlis.Mcodigo#, '#JSStringFormat(conlis.IDdocumento)#');">#conlis.Dfecha#</a></td>
		<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CPTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.EDsaldo#,#conlis.Mcodigo#, '#JSStringFormat(conlis.IDdocumento)#');">#conlis.Mnombre#</a></td>
		<td align="right" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CPTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.EDsaldo#,#conlis.Mcodigo#, '#JSStringFormat(conlis.IDdocumento)#');">#LSCurrencyFormat(conlis.Dtotal, 'none')#</a></td>
		<td align="right" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CPTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.EDsaldo#,#conlis.Mcodigo#, '#JSStringFormat(conlis.IDdocumento)#');">#LSCurrencyFormat(conlis.EDsaldo, 'none')#</a></td>
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp; <table border="0" width="50%" align="center">
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