

<html>
<head>
<title>Lista de Documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<cf_templatecss>
</head>
<body>

<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
	select SNnombre
	from SNegocios
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Socio#">
     and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="conlis" datasource="#Session.DSN#">
SELECT 	a.CCTcodigo, a.CCTcodigo, a.Ddocumento, a.Mcodigo, a.Ccuenta, 
		c.Mnombre, d.Cdescripcion, a.Dsaldo, b.CCTdescripcion,
	   	a.Ddocumento , a.Dtipocambio, a.Dtotal, a.Dsaldo, 
	   	<cf_dbfunction name="to_date" args="a.Dfecha"> as Dfecha
FROM Documentos a, CCTransacciones b, Monedas c, CContables d 
WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  and a.Dsaldo > 0 
  and a.Ecodigo = b.Ecodigo 
  and b.CCTtipo = 'C' 
  and coalesce(b.CCTpago,0) != 1
  and a.CCTcodigo = b.CCTcodigo 
  and a.Mcodigo = c.Mcodigo 
  and a.Ecodigo = d.Ecodigo 
  and a.Ccuenta = d.Ccuenta 
  and a.SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Socio#">  
  and (a.CCTcodigo+rtrim(a.Ddocumento)) 
       not in (select (z.CCTcodigo+rtrim(z.Ddocumento)) 
	           from EFavor z where a.Ecodigo=z.Ecodigo) 
 <cfif isdefined("Form.Filtrar") and (Form.CCTcodigo NEQ "")>
	and upper(a.CCTcodigo) like '%#Ucase(Form.CCTcodigo)#%'
  </cfif>
  <cfif isdefined("Form.Filtrar") and (Form.Ddocumento NEQ "")>
	and upper(a.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
  </cfif>
   <cfif isdefined("Form.Filtrar") and (Form.Dfecha NEQ "")>
	and <cf_dbfunction name="to_date" args="a.Dfecha"> =  '#Form.Dfecha#'
  </cfif>
  <cfif isdefined("form.Filtrar") and (Form.Mnombre NEQ "")>
	and upper(c.Mnombre) like '%#Ucase(Form.Mnombre)#%'
  </cfif>
    
  order by a.Dfecha asc, a.Dsaldo desc </cfquery>


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
	//alert(valor1);alert(valor2);alert(valor3);alert(valor4);alert(valor5);alert(valor6);alert(valor7);
	
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#.#url.nombre#</cfoutput>.value=valor3;
	window.opener.document.<cfoutput>#url.form#.#url.tipocambio#</cfoutput>.value=fm(valor4,2);
	window.opener.document.<cfoutput>#url.form#.#url.saldo#</cfoutput>.value=fm(valor5,2);
	window.opener.document.<cfoutput>#url.form#.disponible</cfoutput>.value=fm(valor5,2);
	window.opener.document.<cfoutput>#url.form#.#url.moneda#</cfoutput>.value=valor6;
	window.opener.document.<cfoutput>#url.form#.#url.Ccuenta#</cfoutput>.value=valor7;
	window.close();
}
</script>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset BTN_Filtrar 	= t.Translate('BTN_Filtrar','Filtrar','/sif/generales.xml')>
<cfset LB_Doctode	= t.Translate('LB_Doctode','Documentos de')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Fecha	 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset BTN_Limpiar 	= t.Translate('BTN_Limpiar','Limpiar','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>

<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
  
  	<tr>
		<td colspan="6" class="tituloAlterno">
			<cfoutput>#LB_Doctode# #rsNombreSocio.SNnombre#</cfoutput>
		</td>
	</tr>
    <cfoutput>
    <tr> 
      <td width="10%" class="tituloListas"><div align="left">#LB_Transaccion#</div></td>
      <td width="25%" class="tituloListas"><div align="left">#LB_Documento#</div></td>
	  <td width="20%" class="tituloListas"><div align="left">#LB_Fecha#</div></td>
	  <td width="25%" class="tituloListas"><div align="left">#LB_Moneda#</div></td>
	  <td width="25%" class="tituloListas"><div align="left">#LB_Monto#</div></td>
	  <td width="19%" class="tituloListas"><div align="left">#LB_Saldo#</div></td>
      <td width="1%" class="tituloListas"><div align="right"> </div></td>
    </tr>
    </cfoutput>
    <tr> 
      <td><input name="CCTcodigo" type="text" size="15" maxlength="2"></td>
      <td ><input name="Ddocumento" type="text" size="25" maxlength="25"></td>
	  <td ><input name="Dfecha" type="text" size="15" maxlength="12"></td>
	  <td ><input name="Mnombre" type="text" size="30" maxlength="80"></td>
	  <td >&nbsp;</td>
	  <td >&nbsp;</td>
	  
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="CCTcodigo#conlis.CurrentRow#" value="#conlis.CCTcodigo#"> 
          <a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.Dsaldo#,#conlis.Mcodigo#, #conlis.Ccuenta#);">#conlis.CCTcodigo#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.Dsaldo#,#conlis.Mcodigo#, #conlis.Ccuenta#);">#conlis.Ddocumento#</a></td>
		
	    <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="CCTcodigo#conlis.CurrentRow#" value="#conlis.CCTcodigo#"> 
        	<a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.Dsaldo#,#conlis.Mcodigo#, #conlis.Ccuenta#);">#conlis.Dfecha#</a></td>

    	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="CCTcodigo#conlis.CurrentRow#" value="#conlis.CCTcodigo#"> 
        	<div align="left"><a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.Dsaldo#,#conlis.Mcodigo#, #conlis.Ccuenta#);">#conlis.Mnombre#</a></div></td>

    	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="CCTcodigo#conlis.CurrentRow#" value="#conlis.CCTcodigo#"> 
        	<div align="right"><a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.Dsaldo#,#conlis.Mcodigo#, #conlis.Ccuenta#);">#LSCurrencyFormat(conlis.Dtotal,'none')#</a></div></td>
      	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="CCTcodigo#conlis.CurrentRow#" value="#conlis.CCTcodigo#"> 
          <div align="right"><a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#','#JSStringFormat(conlis.Ddocumento)#','#JSStringFormat(conlis.Mnombre)#',#conlis.Dtipocambio#,#conlis.Dsaldo#,#conlis.Mcodigo#, #conlis.Ccuenta#);">#LSCurrencyFormat(conlis.Dsaldo,'none')#</a></div></td>
        </tr>
    </cfoutput> 
    <tr align="center"> 
    	<td colspan="7">
			<font color="#FFFFFF"> 
    		<cfoutput> 
        		<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
        		<input name="btnLimpiar" type="reset" id="btnLimpiar" value="#BTN_Limpiar#">
    		</cfoutput> 
        	</font> 
		</td>
    </tr>
	<tr> 
	   <td colspan="6">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="6">&nbsp; 
	  <cfif conlis.recordCount GT 0>
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
		<cfelse>
        <br/>
          <cfset Msg_SinReg = t.Translate('Msg_SinReg','NO SE ENCONTRARON REGISTROS QUE CUMPLAN CON EL CRITERIO DE BÚSQUEDA')>
          <cfoutput><p align="center">#Msg_SinReg#</p></cfoutput>
          <br/>
          <div align="center"> 
          	<cfset Btn_CerrarVent = t.Translate('Btn_CerrarVent','Cerrar Ventana')>
          	<cfoutput> 
            <input type="button" name="btnCerrar" value="#Btn_CerrarVent#" onClick="javascript:window.close();">
          	</cfoutput> 
          </div>
        </cfif>
        <div align="center"> </div></td>
    </tr>
  </table>
</form>

</body>
</html>