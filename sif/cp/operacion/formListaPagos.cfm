<!--- 
	Modificado por Gustavo Fonseca Hernández 
	Fecha: 23-5-2005
	Motivo: Se agreaga el botón de Reporte a la lista.
	
	Modificado por: Ana Villavicencio
	Fecha: 8 de setiembre del 2005
	Motivo: Se modifico la forma para que siguiera los estandares establecidos en el doc de Control de Calidad. 
			Se cambiaron los botones hacia la parte superior derecha
--->
<cfif isdefined("Url.pageNum_rsLista") and not isdefined("Form.pageNum_rsLista")>
	<cfparam name="Form.pageNum_rsLista" default="#Url.pageNum_rsLista#">
</cfif>
<cfif isdefined("Url.Fecha") and not isdefined("Form.Fecha")>
	<cfparam name="Form.Fecha" default="#Url.Fecha#">
</cfif>
<cfif isdefined("Url.Transaccion") and not isdefined("Form.Transaccion")>
	<cfparam name="Form.Transaccion" default="#Url.Transaccion#">
</cfif>
<cfif isdefined("Url.Usuario") and not isdefined("Form.Usuario")>
	<cfparam name="Form.Usuario" default="#Url.Usuario#">
</cfif>
<cfif isdefined("Url.Moneda") and not isdefined("Form.Moneda")>
	<cfparam name="Form.Moneda" default="#Url.Moneda#">
</cfif>

<!---Validacion de que existan cuentas bancarias--->
<cfquery name="rsCuentasBancos" datasource="#Session.DSN#">
	select count(1)
	from CuentasBancos
	where Ecodigo =  #Session.Ecodigo#  
    	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
</cfquery>
<cfif rsCuentasBancos.recordcount LTE 0>
	<cfthrow message="Falta definir las Cuentas Bancarias">
</cfif>

<cfquery name="rsFechas" datasource="#Session.DSN#">
	select distinct <cf_dbfunction name="to_sdateDMY" args="EPfecha"> as fecha, EPfecha
	from EPagosCxP 
	where Ecodigo =  #Session.Ecodigo# 
	order by EPfecha desc
</cfquery>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select distinct a.CPTcodigo, b.CPTdescripcion
	from CPTransacciones b
	 inner join EPagosCxP a
	 	on a.Ecodigo = b.Ecodigo
	   and a.CPTcodigo = b.CPTcodigo
	where a.Ecodigo =  #Session.Ecodigo# 
	and b.CPTtipo = 'D'
	and coalesce(b.CPTpago,0) = 1
	order by a.CPTcodigo
</cfquery>

<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select distinct EPusuario
	from EPagosCxP
	where Ecodigo =  #Session.Ecodigo# 
	order by EPusuario 
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct <cf_dbfunction name="to_char" args="a.Mcodigo"> as Mcodigo, b.Mnombre 
	from Monedas b
       inner join EPagosCxP a 
	     on b.Mcodigo = a.Mcodigo 
	where a.Ecodigo =  #Session.Ecodigo# 
	order by b.Mnombre
</cfquery>

<cfset LB_NoTiene	= t.Translate('LB_NoTiene','No Tiene','PagosCxP.cfm')>
<cfset LB_Desb		= t.Translate('LB_Desb','Desbalanceada!')>

<cfoutput>
<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.CPTcodigo,
		   a.IDpago,
		   c.CPTdescripcion,
		   a.EPdocumento,
		   a.EPfecha,
		   b.Mnombre,
		   <cf_dbfunction name="to_char" args="a.EPtotal"> as EPtotal ,
		   s.SNnombre,
		  (select Coalesce(<cf_dbfunction name="to_char" args="sum(NC_total)">,'#LB_NoTiene#') from APagosCxP Anti where Anti.IDpago = a.IDpago) as NC_total,
		  case when ((select coalesce(sum(round(z.DPtotal, 2)), 0.00) from DPagosCxP z 	  where z.Ecodigo    = a.Ecodigo and z.IDpago    = a.IDpago) + 
				     (select Coalesce(sum(round(NC_total ,2)) , 0.00) from APagosCxP Anti where Anti.IDpago = a.IDpago)
				   != a.EPtotal) 
	   		then '#LB_Desb#' else 	' ' end as Balance

	from  EPagosCxP a
	 inner join Monedas b
	 	on b.Mcodigo = a.Mcodigo 
	 inner join CPTransacciones c
	 	on c.Ecodigo = a.Ecodigo 
	   and c.CPTcodigo = a.CPTcodigo 
	 inner join SNegocios s 
	 	on a.Ecodigo = s.Ecodigo 
	   and a.SNcodigo = s.SNcodigo 
	where a.Ecodigo =  #Session.Ecodigo#  
	and c.CPTtipo = 'D'
	and coalesce(c.CPTpago, 0) = 1
	<cfif isdefined("Form.Fecha") and Form.Fecha NEQ "-1">
		and <cf_dbfunction name="to_sdate" args="a.EPfecha"> = <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.Fecha)#">
	</cfif>
	<cfif isdefined("Form.Transaccion") and Form.Transaccion NEQ "-1">
		and a.CPTcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.Transaccion#">
	</cfif>
	<cfif isdefined("Form.Usuario") and Form.Usuario NEQ "-1">
		and a.EPusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Usuario#">
	</cfif>
	<cfif isdefined("Form.Moneda") and Form.Moneda NEQ "-1">
		and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Moneda#">
	</cfif>
</cfquery>
</cfoutput>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("form.btnFiltrar")>
	<cfset form.PageNum_rsLista = 1 >
</cfif>

<cfparam name="PageNum_rsLista" default="1">

<cfset MaxRows_rsLista = 20 > <!--- 20 --->

<!--- Paginacion --->
<cfset StartRow_rsLista		= Min( (PageNum_rsLista-1)*MaxRows_rsLista+1, Max(rsLista.RecordCount,1) )>
<cfset EndRow_rsLista		= Min(StartRow_rsLista+MaxRows_rsLista-1,rsLista.RecordCount)>
<cfset TotalPages_rsLista	= Ceiling(rsLista.RecordCount/MaxRows_rsLista)>

<!--- ========================================================================================= --->
<!--- QueryString_rsLista (Declara y limpi ala variable ) --->
<!--- ========================================================================================= --->
<cfset QueryString_rsLista = Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"PageNum_rsLista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Fecha=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Fecha")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Fecha=#Form.Fecha#" >
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Transaccion=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Transaccion")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Transaccion=#Form.Transaccion#" >
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Usuario=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Usuario")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Usuario=#Form.Usuario#" >
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Moneda=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Moneda")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Moneda=#Form.Moneda#" >
</cfif>
<!--- ========================================================================================= --->

<style type="text/css">
	.tituloFiltros {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<cfset MSG_EscDoct 	= t.Translate('MSG_EscDoct','Debe escoger un documento de pago para aplicar')>
<cfset MSG_AplDoct 	= t.Translate('MSG_AplDoct','¿Está seguro de que desea aplicar los documentos de pago?')>
<cfset MSG_NoDocPag = t.Translate('MSG_NoDocPag','No hay documentos de pago para aplicar')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Usuario 	= t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_Todas 	= t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Todos 	= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','Anticipo.cfm')>
<cfset LB_Total 	= t.Translate('LB_Total','Total','Anticipo.cfm')>
<cfset LB_Proveedor = t.Translate('LB_Proveedor','Proveedor','/sif/generales.xml')>
<cfset LB_Anticipo 	= t.Translate('LB_Anticipo','Anticipo','PagosCxP.cfm')>
<cfset MSG_NoDocP 	= t.Translate('MSG_NoDocP','No hay documentos de Pagos')>
<cfset LB_btnFiltrar 	= t.Translate('LB_btnFiltrar','Filtrar','/sif/generales.xml')>
<cfset BTN_Aplicar 	= t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>
<cfset BTN_Nuevo 	= t.Translate('BTN_Nuevo','Nuevo','/sif/generales.xml')>
<cfset LB_Reporte 	= t.Translate('LB_Reporte','Reporte','/sif/generales.xml')>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	function Editar(data) {
		if (data!="") {
			document.form1.action='PagosCxP.cfm';
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}
	
	function checkAll(source) {
		var checkboxes = document.querySelectorAll('input[type="checkbox"]');
		for (var i = 0; i < checkboxes.length; i++) {
			if (!checkboxes[i].disabled && checkboxes[i] != source)
				checkboxes[i].checked = source.checked;
		}
	}
	
	function validaAplicacion(f) {
		var checkboxes = document.querySelectorAll('input[type="checkbox"]');
		for (var i = 0; i < checkboxes.length; i++) {
			if (!checkboxes[i].disabled && checkboxes[i].checked)
				return confirm("#MSG_AplDoct#");
		}
		
		alert("#MSG_EscDoct#");
		return false;
	}
</script>
</cfoutput>
<form style="margin:0;" name="form1" method="post" action="ListaPagos.cfm">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
  <tr> 
    <td align="center"> 
      
        <table cellpadding="0" cellspacing="2" border="0" width="100%" class="areaFiltro">
		
			<tr>
            	<cfoutput>
				<td width="13%"><b>#LB_Fecha#</b></td>
				<td width="20%"><b>#LB_Transaccion#</b></td>
	            <td width="16%"><b>#LB_Usuario#</b></td>
	            <td width="26%"><b>#LB_Moneda#</b></td>
                </cfoutput>
			</tr>

          <tr> 
            <td >
              <select name="Fecha" id="Fecha">
                <option value="-1" <cfif isdefined("Form.Fecha") and Form.Fecha EQ "-1">selected</cfif>><cfoutput>(#LB_Todas#)</cfoutput></option>
                <cfoutput query="rsFechas"> 
                  <option value="#fecha#" <cfif isdefined("Form.Fecha") and Form.Fecha EQ #fecha#>selected</cfif>>#fecha#</option>
                </cfoutput> 
              </select>
            </td>
            <td>
              <select name="Transaccion" id="Transaccion">
                <option value="-1" <cfif isdefined("Form.Transaccion") and Form.Transaccion EQ "-1">selected</cfif>><cfoutput>(#LB_Todos#)</cfoutput></option>
                <cfoutput query="rsTransacciones"> 
                  <option value="#CPTcodigo#" <cfif isdefined("Form.Transaccion") and Form.Transaccion EQ #CPTcodigo#>selected</cfif>>#CPTdescripcion#</option>
                </cfoutput> 
              </select>
            </td>
            <td>
              <select name="Usuario" id="Usuario">
                <option value="-1" <cfif isdefined("Form.Usuario") and Form.Usuario EQ "-1">selected</cfif>><cfoutput>(#LB_Todos#)</cfoutput></option>
                <cfoutput query="rsUsuarios"> 
                  <option value="#EPusuario#" <cfif isdefined("Form.Usuario") and Form.Usuario EQ #EPusuario#>selected</cfif>>#EPusuario#</option>
                </cfoutput> 
              </select>
            </td>
            <td>
              <select name="Moneda" id="Moneda">
                <option value="-1" <cfif isdefined("Form.Moneda") and Form.Moneda EQ "-1">selected</cfif>><cfoutput>(#LB_Todos#)</cfoutput></option>
                <cfoutput query="rsMonedas"> 
                  <option value="#Mcodigo#" <cfif isdefined("Form.Moneda") and Form.Moneda EQ #Mcodigo#>selected</cfif>>#Mnombre#</option>
                </cfoutput> 
              </select>
            </td>
            <td width="25%">
            <cfoutput>
				<input name="btnFiltrar"	  type="submit"  value="#LB_btnFiltrar#" class="btnFiltrar">
            </cfoutput>
				<input name="pageNum_rsLista" type="hidden"  value="<cfif isdefined('form.PageNum_rsLista') and len(trim(form.PageNum_rsLista))><cfoutput>#form.PageNum_rsLista#</cfoutput><cfelse>1</cfif>" />				
            </td>
          </tr>
        </table>
     <!---  </form> --->
    </td>
  </tr>
  <tr> 
    <td> 
    
		<cfif rsLista.recordCount GT 0>
			<!--- <form name="form2" method="post" action="ListaPagos.cfm"> --->
			  <table border="0" width="100%" cellpadding="0" cellspacing="0">
				<!--- Encabezado --->
				<tr> 
				  <td class="tituloListas" width="5%" align="center"><input type="checkbox" name="chkAll" onClick="javascript: checkAll(this);"></td>
                  <cfoutput>
				  <td class="tituloListas" width="10%">#LB_Transaccion#</td>
				  <td class="tituloListas" width="15%">#LB_Documento#</td>
				  <td class="tituloListas" width="20%">#LB_Proveedor#</td>
				  <td class="tituloListas" width="10%" align="center">#LB_Fecha#</td>
				  <td class="tituloListas" width="10%">#LB_Moneda#</td>
				  <td class="tituloListas" width="10%" align="right">#LB_Total#</td>
				  <td class="tituloListas" width="10%" align="right">#LB_Anticipo#</td>
				  <td class="tituloListas" width="10%" align="center">&nbsp;</td>
                  </cfoutput>
				</tr>
				<cfoutput query="rsLista" startrow="#StartRow_rsLista#" maxrows="#MaxRows_rsLista#"> 
				  <tr <cfif rsLista.CurrentRow Mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
					<td align="center" nowrap> 
					  <input type="checkbox" id="IDpago" name="IDpago" tabindex="-1" value="#IDpago#" <cfif rsLista.Balance NEQ " ">disabled</cfif>>
					</td>
					<td nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1">#CPTdescripcion#</a></td>
					<td nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1">#EPdocumento#</a></td>
					<td nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1">#SNnombre#</a></td>
					<td align="center" nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1">#EPfecha#</a></td>
					<td nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1">#Mnombre#</a></td>
					<td align="right" nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1">#LSCurrencyFormat(EPtotal,'none')#</a></td>
					<td align="right" nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1">#NC_total#</a></td>
					<td align="center" nowrap><a href="javascript:Editar('#IDpago#');" tabindex="-1"><font color="##FF0000">#Balance#</font></a></td>
				  </tr>
				</cfoutput> 
				<tr> 
				  <td colspan="9" align="center">&nbsp; 
					<table border="0" width="50%" align="center">
					  <cfoutput> 
						<tr> 
						  <td width="23%" align="center"> 
							<cfif PageNum_rsLista GT 1>
							  <a href="#CurrentPage#?PageNum_rsLista=1#QueryString_rsLista#"><img src="../../imagenes/First.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="31%" align="center"> 
							<cfif PageNum_rsLista GT 1>
							  <a href="#CurrentPage#?PageNum_rsLista=#Max(DecrementValue(PageNum_rsLista),1)##QueryString_rsLista#"><img src="../../imagenes/Previous.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="23%" align="center"> 
							<cfif PageNum_rsLista LT TotalPages_rsLista>
							  <a href="#CurrentPage#?PageNum_rsLista=#Min(IncrementValue(PageNum_rsLista),TotalPages_rsLista)##QueryString_rsLista#"><img src="../../imagenes/Next.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="23%" align="center"> 
							<cfif PageNum_rsLista LT TotalPages_rsLista>
							  <a href="#CurrentPage#?PageNum_rsLista=#TotalPages_rsLista##QueryString_rsLista#"><img src="../../imagenes/Last.gif" border=0></a> 
							</cfif>
						  </td>
						</tr>
					  </cfoutput> 
					</table>
				  </td>
				</tr>
				<tr> 
				  <td align="center" colspan="9"> 
					<br>
					<input name="datos" type="hidden" value="">
               </td>
				</tr>
			  </table>
        <cfelse>
			<cfif isdefined('form.BTNfiltrar')>
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr height="15"><td align="center" class="listaPar"><strong><cfoutput>#MSG_NoDocP#</cfoutput></strong></td></tr>
				</table>
        	<cfelse>
			<cflocation addtoken="no" url="PagosCxP.cfm">
			</cfif>
      </cfif>
    </td>
  </tr>
  <tr> 
  	<cfoutput>
    <td align="center">
		<input name="Aplicar" 	type="submit"  value="#BTN_Aplicar#" class="btnAplicar" id="Aplicar"  onClick="javascript: document.form1.action='SQLListaPagos.cfm'; return validaAplicacion(this.form); ">
		<input name="NuevoE"    type="submit"  value="#BTN_Nuevo#"	 class="btnNuevo"	id="NuevoE"   onClick="javascript:document.form1.action='PagosCxP.cfm';">
		<input name="Reporte"   type="submit"  value="#LB_Reporte#" class="btnNormal"  id="Reporte"  onClick="javascript: document.form1.action='../reportes/PagosSinAplicarCP.cfm'">
	</td>
  	</cfoutput>
  </tr>
</table>
</form>