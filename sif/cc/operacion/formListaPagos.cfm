<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 23 de febrero del 2006
	Motivo: Se agregaron los botones al pie de la lista.

	Modificado por: Ana Villavicencio
	Fecha: 08 de diciembre del 2005
	Motivo: Cambio en la forma del despliegue de datos. 

	Modificado por: Ana Villavicencio
	Fecha: 12 de setiembre del 2005
	Motivo: Se modifico la forma para que siguiera los estandares establecidos en el doc de Control de Calidad. 
			Se cambiaron los botones hacia la parte superior derecha

	Modificado por Gustavo Fonseca Hernández 
	Fecha: 20-5-2005
	Motivo: Se agreaga el botón de Reporte a la lista.
	
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_DocCobApli = t.Translate('LB_DocCobApli','Debe escoger un documento de Cobro para aplicar')>
<cfset LB_SegApliDoc = t.Translate('LB_SegApliDoc','¿Está seguro de que desea aplicar los documentos de Cobro?')>
<cfset LB_NoDocCobApli = t.Translate('LB_NoDocCobApli','No hay documentos de Cobro para aplicar')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha')>
<cfset LB_Todas = t.Translate('LB_Todas','(Todas)')>
<cfset LB_Transac = t.Translate('LB_Transac','Transacci&oacute;n')>
<cfset LB_Todos = t.Translate('LB_Fecha','(Todos)')>
<cfset LB_Usuario = t.Translate('LB_Usuario','Usuario')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda')>
<cfset LB_Filtrar = t.Translate('LB_Filtrar','Filtrar')>
<cfset LB_Aplicar = t.Translate('LB_Aplicar','Aplicar')>
<cfset LB_Nuevo = t.Translate('LB_Nuevo','Nuevo')>
<cfset LB_Reporte = t.Translate('LB_Reporte','Reporte')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo')>
<cfset LB_Recibo = t.Translate('LB_Recibo','Recibo')>
<cfset LB_Cliente = t.Translate('LB_Cliente','Cliente')>
<cfset LB_Total = t.Translate('LB_Total','Total')>
<cfset LB_Desbalan = t.Translate('LB_Desbalan','Desbalanceada!')>
<cfset LB_Anticipo = t.Translate('LB_Anticipo','Anticipo')>
<cfset LB_Notiene = t.Translate('LB_Notiene','No Tiene')>
<cfset Msg_NoHayDocCobr = t.Translate('Msg_NoHayDocCobr','No hay documentos de Cobros')>


<cfif isdefined("Url.pageNum_rsLista") and not isdefined("Form.pageNum_rsLista")>
	<cfparam name="Form.pageNum_rsLista" default="#Url.pageNum_rsLista#">
</cfif>
<cfparam name="form.pageNum_rsLista" default="1">

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

<cfquery name="rsFechas" datasource="#Session.DSN#">
	select distinct Pfecha as fecha
	from Pagos 
	where Ecodigo = #Session.Ecodigo#
	order by Pfecha desc
</cfquery>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select distinct a.CCTcodigo, b.CCTdescripcion 
	from CCTransacciones b, Pagos a 
	where a.Ecodigo = #Session.Ecodigo#
	and a.Ecodigo = b.Ecodigo
	and a.CCTcodigo = b.CCTcodigo
	and b.CCTtipo = 'C'
	and coalesce(b.CCTpago,0) = 1
	order by a.CCTcodigo 
</cfquery>

<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select distinct Pusuario 
    from Pagos
	where Ecodigo = #Session.Ecodigo#
	order by Pusuario 
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct a.Mcodigo, b.Mnombre
	from Monedas b, Pagos a 
	where a.Ecodigo = #Session.Ecodigo#
	and b.Mcodigo = a.Mcodigo 
	and a.Ecodigo = b.Ecodigo
	order by b.Mnombre
</cfquery>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.CCTcodigo, 
	   <cf_dbfunction name="concat" args="rtrim(a.CCTcodigo)+'|'+rtrim(a.Pcodigo)" delimiters="+"> as IDpago,
	   c.CCTdescripcion,
	   rtrim(a.Pcodigo) as Pcodigo,
	   Pfecha,
	   b.Mnombre,
	   Ptotal, 
	   s.SNnombre, 
	   g.GSNdescripcion,
	   (select Coalesce(<cf_dbfunction name="to_char" args="sum(NC_total)">,'#LB_Notiene#') from APagosCxC Anti where Anti.Ecodigo = a.Ecodigo and Anti.CCTcodigo = a.CCTcodigo and Anti.Pcodigo = a.Pcodigo) as NC_total,
	   case when ((select coalesce(sum(round(z.DPtotal, 2)), 0.00) from DPagos z 	   where z.Ecodigo   = a.Ecodigo  and z.CCTcodigo    = a.CCTcodigo and z.Pcodigo    = a.Pcodigo) + 
				  (select Coalesce(sum(round(NC_total ,2)) , 0.00) from APagosCxC Anti where Anti.Ecodigo = a.Ecodigo and Anti.CCTcodigo = a.CCTcodigo and Anti.Pcodigo = a.Pcodigo)
				   != a.Ptotal) 
	   then 
	   	'#LB_Desbalan#' 
	   else 
	   	' ' 
	   end as Balance
	from Pagos a
	inner join Monedas b
	  	on  b.Mcodigo = a.Mcodigo
	  	and b.Ecodigo = a.Ecodigo
	inner join CCTransacciones c
		on  c.Ecodigo   = a.Ecodigo
		and c.CCTcodigo = a.CCTcodigo
	left outer join SNegocios s
		on  a.Ecodigo 	= s.Ecodigo 
		and a.SNcodigo 	= s.SNcodigo
	left outer join GrupoSNegocios g
		on  a.Ecodigo 	= g.Ecodigo
		and a.GSNid 	= g.GSNid
	where a.Ecodigo = #Session.Ecodigo# 
	and c.CCTtipo = 'C'
	and coalesce(c.CCTpago, 0) = 1
	<cfif isdefined("Form.Fecha") and Form.Fecha NEQ "-1">
        and a.Pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(mid(form.fecha,7,4),mid(form.fecha,4,2),mid(form.fecha,1,2))#">
	</cfif>
	<cfif isdefined("Form.Transaccion") and Form.Transaccion NEQ "-1">
		and a.CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Transaccion#">
	</cfif>
	<cfif isdefined("Form.Usuario") and Form.Usuario NEQ "-1">
		and a.Pusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Usuario#">
	</cfif>
	<cfif isdefined("Form.Moneda") and Form.Moneda NEQ "-1">
		and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Moneda#">
	</cfif>
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_rsLista" default="#form.pageNum_rsLista#">

<cfset MaxRows_rsLista = 20 >

<cfset StartRow_rsLista=Min((PageNum_rsLista-1)*MaxRows_rsLista+1,Max(rsLista.RecordCount,1))>
<cfset EndRow_rsLista=Min(StartRow_rsLista+MaxRows_rsLista-1,rsLista.RecordCount)>
<cfset TotalPages_rsLista=Ceiling(rsLista.RecordCount/MaxRows_rsLista)>
<cfset QueryString_rsLista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"PageNum_rsLista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista=ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>


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
<!--- ========================================================================================= --->

<style type="text/css">
	.tituloFiltros {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>
<cfoutput>
<script language="JavaScript" type="text/javascript">
	function Editar(data) {
		if (data!="") {
			document.form1.action='PagosCxC.cfm';
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}
	
	function checkAll(f) {
		if (f.IDpago != null) {
			if (f.IDpago.value != null) {
				if (!f.IDpago.disabled) f.IDpago.checked = f.chkAll.checked;
			} else {
				for (var i=0; i<f.IDpago.length; i++) {
					if (!f.IDpago[i].disabled) f.IDpago[i].checked = f.chkAll.checked;
				}
			}
		}
	}
	
	function validaAplicacion(f) {
		if (f.IDpago != null) {
			if (f.IDpago.value != null) {
				if (!f.IDpago.checked) { 
					alert("#LB_DocCobApli#");
					return false;
				} else {
					return confirm("#LB_SegApliDoc#");
				}
			} else {
				for (var i=0; i<f.IDpago.length; i++) {
					if (f.IDpago[i].checked) {
						return confirm("#LB_SegApliDoc#");
					}
				}
				alert("#LB_DocCobApli#");
				return false;
			}
		} else {
			alert("#LB_NoDocCobApli#");
			return false;
		}
	}
</script>
</cfoutput>
<form style="margin:0" name="form1" method="post" action="ListaPagos.cfm">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
  <tr> 
    <td align="center"> 
      
        <table cellpadding="0" cellspacing="3" border="0" width="100%" class="areaFiltro">
          <tr> 
            <td style="padding-left: 10px"><cfoutput>#LB_Fecha#</cfoutput> &nbsp; 
              <select name="Fecha" id="Fecha">
                <option value="-1" <cfif isdefined("Form.Fecha") and Form.Fecha EQ "-1">selected</cfif>><cfoutput>#LB_Todas#</cfoutput></option>
                <cfoutput query="rsFechas"> 
                  <option value="#dateformat(fecha,'dd/mm/yyyy')#" <cfif isdefined("Form.Fecha") and Form.Fecha EQ #dateformat(fecha,'dd/mm/yyyy')#>selected</cfif>>#dateformat(fecha,'dd/mm/yyyy')#</option>
                </cfoutput> 
              </select>
            </td>
            <td><cfoutput>#LB_Transac#</cfoutput> &nbsp; 
              <select name="Transaccion" id="Transaccion">
                <option value="-1" <cfif isdefined("Form.Transaccion") and Form.Transaccion EQ "-1">selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
                <cfoutput query="rsTransacciones"> 
                  <option value="#CCTcodigo#" <cfif isdefined("Form.Transaccion") and Form.Transaccion EQ #CCTcodigo#>selected</cfif>>#CCTcodigo#-#CCTdescripcion#</option>
                </cfoutput> 
              </select>
            </td>
            <td><cfoutput>#LB_Usuario#</cfoutput> &nbsp; 
              <select name="Usuario" id="Usuario">
                <option value="-1" <cfif isdefined("Form.Usuario") and Form.Usuario EQ "-1">selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
                <cfoutput query="rsUsuarios"> 
                  <option value="#Pusuario#" <cfif isdefined("Form.Usuario") and Form.Usuario EQ #Pusuario#>selected</cfif>>#Pusuario#</option>
                </cfoutput> 
              </select>
            </td>
            <td><cfoutput>#LB_Moneda#</cfoutput> &nbsp; 
              <select name="Moneda" id="Moneda">
                <option value="-1" <cfif isdefined("Form.Moneda") and Form.Moneda EQ "-1">selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
                <cfoutput query="rsMonedas"> 
                  <option value="#Mcodigo#" <cfif isdefined("Form.Moneda") and Form.Moneda EQ #Mcodigo#>selected</cfif>>#Mnombre#</option>
                </cfoutput> 
              </select>
            </td>
			<td nowrap>
				<cfoutput>
				<input name="btnFiltrar" type="submit" id="btnFiltrar" class="btnFiltrar" 	value="#LB_Filtrar#">
				<input name="Aplicar" 	 type="submit" id="Aplicar"    class="btnAplicar"   value="#LB_Aplicar#" onClick="javascript: document.form1.action='SQLListaPagos.cfm'; return validaAplicacion(this.form); ">
				<input name="NuevoE" 	 type="submit" id="NuevoE" 	   class="btnNuevo"		value="#LB_Nuevo#" 	onClick="javascript:document.form1.action='PagosCxC.cfm';">
				<input name="Reporte" 	 type="submit" id="Reporte"    class="btnNormal"    value="#LB_Reporte#" onClick="javascript: document.form1.method='get'; document.form1.action='../reportes/PagosSinAplicar.cfm'">
				<input name="pageNum_rsLista" type="hidden" class="btnAnterior" value="<cfif isdefined('form.pageNum_rsLista')><cfoutput>#form.pageNum_rsLista#</cfoutput><cfelse>1</cfif>" >
			</cfoutput>
            </td>
          </tr>
        </table>
     <!---  </form> --->
    </td>
  </tr>
  <tr> 
    <td> 
      <cfif rsLista.recordCount GT 0>
      <!---   <form name="form2" method="post" action="ListaPagos.cfm"> --->
          <table border="0" width="100%" cellpadding="0" cellspacing="0">
            <!--- Encabezado --->
            <tr> 
              <td class="tituloListas" width="5%" align="center"><input type="checkbox" name="chkAll" onClick="javascript: checkAll(this.form);"></td>
              <td class="tituloListas" width="5%"><strong><cfoutput>#LB_Tipo#</cfoutput></strong></td>
              <td class="tituloListas" width="15%"><strong><cfoutput>#LB_Recibo#</cfoutput></strong></td>
              <td class="tituloListas" width="20%"><strong><cfoutput>#LB_Cliente#</cfoutput></strong></td>
              <td class="tituloListas" width="10%" align="center"><strong><cfoutput>#LB_Fecha#</cfoutput></strong></td>
              <td class="tituloListas" width="10%"><strong><cfoutput>#LB_Moneda#</cfoutput></strong></td>
              <td class="tituloListas" width="10%" align="right"><strong><cfoutput>#LB_Total#</cfoutput></strong></td>
              <td class="tituloListas" width="10%" align="right"><strong><cfoutput>#LB_Anticipo#</cfoutput></strong></td>
              <td class="tituloListas" width="10%" align="center">&nbsp;</td>
            </tr>
            <cfoutput query="rsLista" startrow="#StartRow_rsLista#" maxrows="#MaxRows_rsLista#"> 
              <tr <cfif rsLista.CurrentRow Mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
                <td align="center"> 
                  <input type="checkbox" name="IDpago" tabindex="-1" value="#IDpago#" <cfif rsLista.Balance NEQ " ">disabled</cfif>>
                </td>
                <td
				style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#CCTcodigo#</td>
                <td style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#Pcodigo#</td>
				<cfif rsLista.GSNdescripcion NEQ ''>
				<td style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#GSNdescripcion#</td>
				<cfelse>
	            <td style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#SNnombre#</td>
				</cfif>
                <td align="center" style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#DateFormat(Pfecha,'dd/mm/yyyy')#</td>
                <td style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#Mnombre#</a></td>
                <td align="right" style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#LSCurrencyFormat(Ptotal,'none')#</td>
                <td align="right" style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'">#NC_total#</td>
                <td align="center" style="cursor: pointer;"
				onClick="javascript:Editar('#IDpago#');"
				onMouseOver="javascript: style.color = 'red'" 
				onMouseOut="javascript: style.color = 'black'"><font color="##FF0000">#Balance#</font></td>
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
					<cfoutput>
					<input name="btnFiltrar" 	type="submit" id="btnFiltrar" class="btnFiltrar" value="#LB_Filtrar#">
					<input name="Aplicar" 		type="submit" id="Aplicar"    class="btnAplicar" value="#LB_Aplicar#" onClick="javascript: document.form1.action='SQLListaPagos.cfm'; return validaAplicacion(this.form); ">
					<input name="NuevoE" 		type="submit" id="NuevoE" 	  class="btnNuevo"	 value="#LB_Nuevo#"   onClick="javascript:document.form1.action='PagosCxC.cfm';">
					<input name="Reporte" 		type="submit" id="Reporte"    class="btnNormal"  value="#LB_Reporte#" onClick="javascript: document.form1.method='get'; document.form1.action='../reportes/PagosSinAplicar.cfm'">
					</cfoutput>
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
				<cfoutput>
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr height="15"><td align="center" class="listaPar"><strong>#Msg_NoHayDocCobr#</strong></td></tr>
				</table>
				</cfoutput>
        	<cfelse>
			<cflocation addtoken="no" url="PagosCxC.cfm">
			</cfif>
      </cfif>
    </td>
  </tr>
</table>
  </form>
