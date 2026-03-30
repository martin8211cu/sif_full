<html>
<head>
<title>Lista de Documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
<script language="JavaScript" src="../../js/calendar.js"></script>

</head>

<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
</cfif>
<cfif isdefined("Url.CCTcodigo") and not isdefined("Form.CCTcodigo")>
	<cfparam name="Form.CCTcodigo" default="#Url.CCTcodigo#">
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
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
	select SNnombre
	from SNegocios
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion 
	from CCTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and CCTtipo = 'D' 
	and coalesce(CCTpago,0) != 1
	order by CCTcodigo 
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct b.Mcodigo, b.Mnombre
	from Documentos a, Monedas b 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and a.Mcodigo = b.Mcodigo 
	and Dsaldo > 0 
	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	and a.CCTcodigo  not in (select h.CCTRcodigo from DFavor h where a.Ecodigo=h.Ecodigo )
	and a.Ddocumento not in (select h.DRdocumento from DFavor h where a.Ecodigo=h.Ecodigo )
	order by b.Mnombre
</cfquery>

<cfquery name="conlis" datasource="#Session.DSN#">
	select rtrim(a.Mcodigo)
     		#_Cat#'|'#_Cat#rtrim(b.CCTcodigo)
	        #_Cat#'|'#_Cat#rtrim(b.Ddocumento)
	        #_Cat#'|'#_Cat#rtrim(<cf_dbfunction name="to_char" args="b.Ccuenta">)
	        #_Cat#'|'#_Cat#<cf_dbfunction name="to_char" args="Dtipocambio"> 
	        #_Cat#'|'#_Cat#<cf_dbfunction name="to_char" args="Dsaldo">
	        #_Cat#'|'#_Cat#<cf_dbfunction name="to_char" args="c.Cdescripcion"> as Codigo, 
			   rtrim(b.CCTcodigo#_Cat#'-'#_Cat#rtrim(b.Ddocumento)#_Cat#'-'#_Cat#a.Mnombre) as Descripcion,
			   a.Mnombre, 
			   <cf_dbfunction name="to_date" args="b.Dfecha"> as Dfecha, 
			   d.CCTcodigo, 
			   rtrim(b.Ddocumento) as Ddocumento,
			   b.Dsaldo 
		from Documentos b, Monedas a, CContables c, CCTransacciones d
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and a.Mcodigo = b.Mcodigo 
 		<cfif isdefined("Form.CCTcodigo") and (Len(Trim(Form.CCTcodigo)) NEQ 0) and (Form.CCTcodigo NEQ "-1")>
			and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
		</cfif>
		<cfif isdefined("Form.Ddocumento") and (Len(Trim(Form.Ddocumento)) NEQ 0)>
		  and upper(b.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
		</cfif>
 		<cfif isdefined("Form.Mcodigo") and (Len(Trim(Form.Mcodigo)) NEQ 0) and (Form.Mcodigo NEQ "-1")>
			and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
		</cfif>
		<cfif isdefined("Form.Dfecha") and (Len(Trim(Form.Dfecha)) NEQ 0)>
		  and <cf_dbfunction name="to_date" args="b.Dfecha"> = '#Form.Dfecha#'
		</cfif>
		and b.Ccuenta = c.Ccuenta 
		and b.Dsaldo > 0 
		and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		and b.Ecodigo = d.Ecodigo 
		and b.CCTcodigo = d.CCTcodigo 
		and d.CCTtipo = 'D'
		and coalesce(d.CCTpago,0) != 1
		and not exists(
			select 1 
			from DFavor h 
			where h.Ecodigo = b.Ecodigo 
			  and h.DRdocumento = b.Ddocumento 
			  and h.CCTRcodigo = b.CCTcodigo
		)		
	order by b.Dfecha, b.Mcodigo, b.Dsaldo desc, b.CCTcodigo, b.Ddocumento 
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
	<cfset QueryString_conlis = "&desc=#Form.desc#&form=#Form.form#&SNcodigo=#Form.SNcodigo#&CCTcodigo=#Form.CCTcodigo#&Ddocumento=#Form.Ddocumento#&Mcodigo=#Form.Mcodigo#&Dfecha=#Form.Dfecha#">
</cfif>

<script language="JavaScript" type="text/javascript">
	function Asignar(cod, desc) {
		window.opener.document.<cfoutput>#Form.form#.#Form.desc#</cfoutput>.value = desc;
		window.opener.obtieneValores(window.opener.document.<cfoutput>#Form.form#</cfoutput>, cod);
		window.close();
	}

	function Limpiar(f) {
		f.CCTcodigo.selectedIndex = 0;
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
<cfset BTN_Filtrar 	= t.Translate('BTN_Filtrar','Filtrar','/sif/generales.xml')>
<cfset LB_Doctode	= t.Translate('LB_Doctode','Documentos de')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Fecha	 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset BTN_Limpiar 	= t.Translate('BTN_Limpiar','Limpiar','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>

<cfform action="ConlisDocsAfavorSocioCC.cfm" name="conlis">
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="4" class="tituloAlterno">
			<cfoutput>#LB_Doctode# #rsNombreSocio.SNnombre#</cfoutput>
		</td>
	</tr>
    <cfoutput>
    <tr> 
      <td align="center" class="encabezado">#LB_Transaccion#</td>
      <td align="center" class="encabezado">#LB_Documento#</td>
      <td align="center" class="encabezado">#LB_Moneda#</td>
      <td align="center" class="encabezado">#LB_Fecha#</td>
    </tr>
    </cfoutput>
    <tr> 
      <td align="center"> 
        <select name="CCTcodigo" id="CCTcodigo">
          <option value="-1" <cfif isdefined("Form.CCTcodigo") AND Form.CCTcodigo EQ "-1">selected</cfif>>(Todos)</option>
          <cfoutput query="rsTransacciones"> 
            <option value="#CCTcodigo#" <cfif isdefined("Form.CCTcodigo") AND rsTransacciones.CCTcodigo EQ Form.CCTcodigo>selected</cfif>>#CCTcodigo#</option>
          </cfoutput> 
        </select>
      </td>
      <td align="center">
	  	<input name="Ddocumento" type="text" id="Ddocumento" size="30" alt="El Documento" value="<cfif isdefined("Form.Ddocumento")><cfoutput>#Form.Ddocumento#</cfoutput></cfif>">
	  </td>
      <td align="center">
        <select name="Mcodigo" id="Mcodigo">
          <option value="-1" <cfif isdefined("Form.Mcodigo") AND Form.Mcodigo EQ "-1">selected</cfif>>(Todos)</option>
          <cfoutput query="rsMonedas"> 
            <option value="#Mcodigo#" <cfif isdefined("Form.Mcodigo") AND rsMonedas.Mcodigo EQ Form.Mcodigo>selected</cfif>>#Mnombre#</option>
          </cfoutput> 
        </select>
	  </td>
      <td align="center" nowrap> <cfoutput> 
		  <cfset Msg_FormFec = t.Translate('Msg_FormFec','La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy).')>
          <cfif isdefined('Form.Dfecha')>
            <cfinput name="Dfecha" type="text" size="10" maxlength="10" message="#Msg_FormFec#"  validate="eurodate" value="#Form.Dfecha#">
          <cfelse>
            <cfinput name="Dfecha" type="text" size="10" maxlength="10" message="#Msg_FormFec#"  validate="eurodate" value="">
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
        <input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
        <input name="btnLimpiar" type="button" id="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript:Limpiar(this.form);">
        </cfoutput>
      </td>
    </tr>
    <tr> 
      <td colspan="4"> 
        <cfif conlis.recordCount GT 0>
          <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr> 
              <td class="encabReporte" align="center">#LB_Transaccion#</td>
              <td class="encabReporte">#LB_Documento#</td>
              <td class="encabReporte" align="center">#LB_Moneda#</td>
              <td class="encabReporte" align="right">#LB_Saldo#</td>
              <td class="encabReporte" align="center">#LB_Fecha#</td>
            </tr>
            <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
              <tr> 
                <td align="center" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> nowrap> 
                  <a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#conlis.CCTcodigo#</a> </td>
                <td <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> nowrap> 
                  <a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#conlis.Ddocumento#</a> </td>
                <td align="center" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
                  <a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#conlis.Mnombre#</a> </td>
                <td align="right" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.Codigo)#','#JSStringFormat(conlis.Descripcion)#');">#LSCurrencyFormat(conlis.Dsaldo,'none')#</a></td>
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
      </td>
    </tr>
  </table>
</cfform>
</body>
</html>

