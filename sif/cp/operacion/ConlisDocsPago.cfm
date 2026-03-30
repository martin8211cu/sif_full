<html>
<head>
<title>Lista de Documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
<script language="JavaScript" src="../../js/calendar.js"></script>

</head>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_btnFiltrar 	= t.Translate('LB_btnFiltrar','Filtrar','/sif/generales.xml')>

<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
</cfif>
<cfif isdefined("Url.CPTcodigo") and not isdefined("Form.CPTcodigo")>
	<cfparam name="Form.CPTcodigo" default="#Url.CPTcodigo#">
</cfif>
<cfif isdefined("Url.Ddocumento") and not isdefined("Form.Ddocumento")>
	<cfparam name="Form.Ddocumento" default="#Url.Ddocumento#">
</cfif>
<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
</cfif>
<cfif isdefined("Url.Dfecha") and not isdefined("Form.Dfecha")>
	<cfparam name="Form.Dfecha" default="#Url.Dfecha#">
</cfif>

<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
	select SNnombre
	from SNegocios
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	and Ecodigo =  #Session.Ecodigo# </cfquery>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select a.CPTcodigo, a.CPTdescripcion
	from CPTransacciones a
	where a.Ecodigo =  #Session.Ecodigo# and a.CPTtipo = 'C' 
	and coalesce(a.CPTpago, 0) != 1
	order by a.CPTcodigo 
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct <cf_dbfunction name="to_char" args="b.Mcodigo"> as Mcodigo, b.Mnombre
	from EDocumentosCP a, Monedas b 
	where a.Ecodigo =  #Session.Ecodigo# and a.Mcodigo = b.Mcodigo 
	and EDsaldo > 0 
	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	and a.IDdocumento not in (select h.IDdocumento from DPagosCxP h 
							  where a.Ecodigo = h.Ecodigo )
	order by b.Mnombre
</cfquery>
<cf_dbfunction name="to_char" args="a.Mcodigo"      returnvariable="Mcodigo" 	 isNumber="false"> 
<cf_dbfunction name="to_char" args="b.IDdocumento"  returnvariable="IDdocumento" isNumber="false">
<cf_dbfunction name="to_char" args="b.Ccuenta"      returnvariable="Ccuenta" 	 isNumber="false">
<cf_dbfunction name="to_char" args="Dtipocambio"    returnvariable="Dtipocambio">
<cf_dbfunction name="to_char" args="EDsaldo"        returnvariable="EDsaldo">
<cf_dbfunction name="op_Concat" returnvariable="_Cat">

<cfquery name="conlis" datasource="#Session.DSN#">
	select	#Mcodigo#
			#_Cat# '|' 
			#_Cat# rtrim(coalesce(b.CPTcodigo,'')) 
			#_Cat# '|' 
			#_Cat# coalesce(#preserveSingleQuotes(IDdocumento)#,'') 
			#_Cat# '|' 
			#_Cat# rtrim(coalesce(#Ccuenta#,'')) 
			#_Cat# '|'
			#_Cat# coalesce(#preserveSingleQuotes(Dtipocambio)#,'') 
			#_Cat# '|' 
			#_Cat# coalesce(#preserveSingleQuotes(EDsaldo)#,'') 
			#_Cat# '|' 
			#_Cat# coalesce(c.Cdescripcion,'')
			#_Cat# '|' 
			#_Cat# ltrim(coalesce(b.Rcodigo,'')) as Codigo,
	
		   rtrim
		   (	b.CPTcodigo
		   		#_Cat# '-'
			   	#_Cat# rtrim(coalesce(b.Ddocumento,''))
			   	#_Cat# '-'
			   	#_Cat# coalesce(a.Mnombre,'')	 
		   ) as Descripcion,
		   a.Mnombre, 
		   <cf_dbfunction name="to_sdateDMY" args="b.Dfecha"> as Dfecha, 
		   d.CPTcodigo, 
		   rtrim(b.Ddocumento) as Ddocumento,
		   b.EDsaldo 
	from EDocumentosCP b
		inner join Monedas a
			on a.Mcodigo = b.Mcodigo 
		inner join CContables c
			on b.Ccuenta = c.Ccuenta 
		inner join CPTransacciones d
			on b.Ecodigo = d.Ecodigo 
		   and b.CPTcodigo = d.CPTcodigo 
	where b.Ecodigo =  #Session.Ecodigo# 
	<cfif isdefined("Form.CPTcodigo") and (Len(Trim(Form.CPTcodigo)) NEQ 0) and (Form.CPTcodigo NEQ "-1")>
		and b.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">
	</cfif>
	<cfif isdefined("Form.Ddocumento") and (Len(Trim(Form.Ddocumento)) NEQ 0)>
	  and upper(b.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
	</cfif>
 	<cfif isdefined("Form.Mcodigo") and (Len(Trim(Form.Mcodigo)) NEQ 0) and (Form.Mcodigo NEQ "-1")>
		and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
	</cfif>
	<cfif isdefined("Form.Dfecha") and (Len(Trim(Form.Dfecha)) NEQ 0)>
	  and <cf_dbfunction name="to_sdateDMY" args="b.Dfecha"> = '#Form.Dfecha#'
	</cfif>
	  and b.EDsaldo > 0 
	  and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	  and d.CPTtipo = 'C'
	  and coalesce(d.CPTpago, 0) != 1
	  and b.IDdocumento not in (select h.IDdocumento 
	                             from DPagosCxP h 
							    where b.Ecodigo = h.Ecodigo )
	order by b.Dfecha, b.Mcodigo, b.EDsaldo desc, b.CPTcodigo, b.Ddocumento 
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

<cfif isdefined("Form.btnFiltrar")>
	<cfset QueryString_conlis = "&desc=#Form.desc#&form=#Form.form#&SNcodigo=#Form.SNcodigo#&CPTcodigo=#Form.CPTcodigo#&Ddocumento=#Form.Ddocumento#&Mcodigo=#Form.Mcodigo#&Dfecha=#Form.Dfecha#">
</cfif>

<script language="JavaScript" type="text/javascript">
	function Asignar(cod, desc) {
		window.opener.document.<cfoutput>#Form.form#.#Form.desc#</cfoutput>.value = desc;
		window.opener.obtieneValores(window.opener.document.<cfoutput>#Form.form#</cfoutput>, cod);
		window.close();
	}

	function Limpiar(f) {
		f.CPTcodigo.selectedIndex = 0;
		f.Mcodigo.selectedIndex = 0;
		f.Ddocumento.value = "";
		f.Dfecha.value = "";
	}
	
</script>

<body>
<style type="text/css">
	.encabezado {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
</style>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_btnFiltrar 	= t.Translate('LB_btnFiltrar','Filtrar','/sif/generales.xml')>
<cfset LB_Doctosde = t.Translate('LB_Doctosde','Documentos de')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_ElDocto = t.Translate('LB_ElDocto','El Documento')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset Msg_NoSeEncReg = t.Translate('Msg_NoSeEncReg','NO SE ENCONTRARON REGISTROS QUE CUMPLAN CON EL CRITERIO DE B&Uacute;SQUEDA')>
<cfset Btn_CerrarVent = t.Translate('Btn_CerrarVent','Cerrar Ventana')>
<cfset BTN_Limpiar = t.Translate('BTN_Limpiar','Limpiar','/sif/generales.xml')>

<cfform action="ConlisDocsPago.cfm" name="conlis">
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="4" class="tituloAlterno">
			<cfoutput>#LB_Doctosde# #rsNombreSocio.SNnombre#</cfoutput>
		</td>
	</tr>
    <tr> 
    <cfoutput>
      <td align="center" class="encabezado">#LB_Transaccion#</td>
      <td align="center" class="encabezado">#LB_Documento#</td>
      <td align="center" class="encabezado">#LB_Moneda#</td>
      <td align="center" class="encabezado">#LB_Fecha# </td>
    </cfoutput>  
    </tr>
    <tr> 
      <td align="center"> 
        <select name="CPTcodigo" id="CPTcodigo">
          <option value="-1" <cfif isdefined("Form.CPTcodigo") AND Form.CPTcodigo EQ "-1">selected</cfif>><cfoutput>(#LB_Todos#)</cfoutput></option>
          <cfoutput query="rsTransacciones"> 
            <option value="#CPTcodigo#" <cfif isdefined("Form.CPTcodigo") AND rsTransacciones.CPTcodigo EQ Form.CPTcodigo>selected</cfif>>#CPTcodigo#</option>
          </cfoutput> 
        </select>
      </td>
      <td align="center">
	  	<input name="Ddocumento" type="text" id="Ddocumento" size="30" <cfoutput>alt="#LB_ElDocto#"</cfoutput> value="<cfif isdefined("Form.Ddocumento")><cfoutput>#Form.Ddocumento#</cfoutput></cfif>">
	  </td>
      <td align="center">
        <select name="Mcodigo" id="Mcodigo">
          <option value="-1" <cfif isdefined("Form.Mcodigo") AND Form.Mcodigo EQ "-1">selected</cfif>><cfoutput>(#LB_Todos#)</cfoutput></option>
          <cfoutput query="rsMonedas"> 
            <option value="#Mcodigo#" <cfif isdefined("Form.Mcodigo") AND rsMonedas.Mcodigo EQ Form.Mcodigo>selected</cfif>>#Mnombre#</option>
          </cfoutput> 
        </select>
	  </td>
      <td align="center" nowrap> <cfoutput> 
          <cfif isdefined('Form.Dfecha')>
            <cfinput name="Dfecha" type="text" size="10" maxlength="10" message="La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)."  validate="eurodate" value="#Form.Dfecha#">
          <cfelse>
            <cfinput name="Dfecha" type="text" size="10" maxlength="10" message="La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)"  validate="eurodate" value="">
          </cfif>
        </cfoutput> <a href="#" > <img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0" onClick="javascript:showCalendar('document.conlis.Dfecha');"></a> 
      </td>
    </tr>
    <tr align="center"> 
      <td colspan="4"> 
        <input name="id" type="hidden" id="id" value="<cfif isdefined("Form.id")><cfoutput>#Form.id#</cfoutput></cfif>">
        <input name="desc" type="hidden" id="desc" value="<cfif isdefined("Form.desc")><cfoutput>#Form.desc#</cfoutput></cfif>">
        <input name="form" type="hidden" id="form" value="<cfif isdefined("Form.form")><cfoutput>#Form.form#</cfoutput></cfif>">
        <input name="SNcodigo" type="hidden" id="SNcodigo" value="<cfif isdefined("Form.SNcodigo")><cfoutput>#Form.SNcodigo#</cfoutput></cfif>">
        <cfoutput>
        <input name="btnFiltrar" type="submit" id="btnFiltrar2" value="#LB_btnFiltrar#">
        <input name="btnLimpiar" type="button" id="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript:Limpiar(this.form);">
        </cfoutput>
      </td>
    </tr>
    <tr> 
      <td colspan="4"> 
        <cfif conlis.recordCount GT 0>
          <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr> 
            <cfoutput>
              <td class="encabReporte" align="center">#LB_Transaccion#</td>
              <td class="encabReporte">#LB_Documento#</td>
              <td class="encabReporte" align="center">#LB_Moneda#</td>
              <td class="encabReporte" align="right">#LB_Saldo#</td>
              <td class="encabReporte" align="center">#LB_Fecha#</td>
            </cfoutput>  
            </tr>
            <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
              <tr> 
                <td align="center" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> nowrap> 
                  <a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#conlis.CPTcodigo#</a> </td>
                <td <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> nowrap> 
                  <a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#conlis.Ddocumento#</a> </td>
                <td align="center" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
                  <a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#conlis.Mnombre#</a> </td>
                <td align="right" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#LSCurrencyFormat(conlis.EDsaldo,'none')#</a></td>
                <td align="center" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
                  <a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#conlis.Dfecha#</a> </td>
              </tr>
            </cfoutput> 
          </table>
          <br>
          <table border="0" width="50%" align="center">
            <cfoutput> 
              <tr> 
                <td width="23%" align="center"> 
                  <cfif PageNum_conlis GT 1>
                    <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a> 
                  </cfif>
                </td>
                <td width="31%" align="center"> 
                  <cfif PageNum_conlis GT 1>
                    <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a> 
                  </cfif>
                </td>
                <td width="23%" align="center"> 
                  <cfif PageNum_conlis LT TotalPages_conlis>
                    <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a> 
                  </cfif>
                </td>
                <td width="23%" align="center"> 
                  <cfif PageNum_conlis LT TotalPages_conlis>
                    <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a> 
                  </cfif>
                </td>
              </tr>
            </cfoutput> 
          </table>
          <cfelse>
          <br/>
          <cfoutput>
          <p align="center">#Msg_NoSeEncReg#</p>
          </cfoutput>
          <br/>
          <div align="center"> 
          <cfoutput>
            <input type="button" name="btnCerrar" value="#Btn_CerrarVent#" onClick="javascript:window.close();">
          </cfoutput>
          </div>
        </cfif>
      </td>
    </tr>
  </table>
</cfform>
</body>
</html>