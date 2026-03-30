<cfparam name="url.s" default="">
<cfset url.s = Trim(url.s)>
<cfinclude template="catinit.cfm">
<!--- esto seria muy bonito si no se enciclara.
	como hay un forward desde catview2 cuando subcat.RecordCount is 0 hacia
	esta página, no se puede hacer este location.
<cfif Len(url.s) Is 0>
	<cflocation url="catview.cfm?cat=#URLEncodedFormat(url.cat)#">
</cfif>
--->

<cfinclude template="../../../Utiles/sifConcat.cfm">

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_bestseller" default="1">
<cfquery datasource="#session.dsn#" name="searchsize">
	select count(1) as SQLRecordCount
	from Articulos p
		join DListaPrecios lp
			on lp.Aid = p.Aid
			and lp.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.lista_precios#">
	  and lp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where (lower(p.Adescripcion) like '%' #_Cat# lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">) #_Cat# '%'
	       )
	  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  <cfif url.cat>
	  and p.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  </cfif>
set rowcount 0
</cfquery>

<cfset MaxRows_bestseller=12>
<cfset StartRow_bestseller=Min((PageNum_bestseller-1)*MaxRows_bestseller+1,Max(searchsize.SQLRecordCount,1))>
<cfset EndRow_bestseller=Min(StartRow_bestseller+MaxRows_bestseller-1,searchsize.SQLRecordCount)>
<cfset TotalPages_bestseller=Ceiling(searchsize.SQLRecordCount/MaxRows_bestseller)>
<cfset QueryString_bestseller=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_bestseller,"PageNum_bestseller=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_bestseller=ListDeleteAt(QueryString_bestseller,tempPos,"&")>
</cfif>

<cfquery datasource="#session.dsn#" name="bestseller">
set rowcount #StartRow_bestseller + MaxRows_bestseller - 1#
	select p.Aid, p.Adescripcion, lp.DLprecio as precio, m.Miso4217 as moneda
	from Articulos p
		join DListaPrecios lp
			on lp.Aid = p.Aid
			and lp.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.lista_precios#">
	  and lp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		join Monedas m
			on m.Miso4217 = lp.moneda
			and m.Ecodigo = lp.Ecodigo
	where (lower(p.Adescripcion) like '%' #_Cat# lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">) #_Cat# '%'
	       )
	  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  <cfif url.cat>
	  and p.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  </cfif>
set rowcount 0
</cfquery>

<cfquery datasource="#session.dsn#" name="categoria" >
	select c.Ccodigo, c.Cdescripcion, c.Ctexto
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#" null="#Len(url.cat) IS 0#">
	order by c.Cpath, c.Cdescripcion
</cfquery>

<cf_template>
	<cf_templatearea name="title">Ver categor&iacute;a</cf_templatearea>
	<cf_templatearea name="body">
<cfinclude template="estilo.cfm">

<table width="750" border="0">
  <tr valign="top">
    <td colspan="3"><cfinclude template="catpath.cfm"></td>
  </tr>
  <tr>
    <td width="9%" valign="top">&nbsp;</td>
    <td width="82%" valign="top"><table width="100%"  cellpadding="4" cellspacing="0" class="catview_thinv" >
      <tr >
        <td class="catview_thinv">
		<cfinclude template="catsearch-form.cfm"></td>
      </tr>
    </table></td>
    <td width="9%" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;<span class="catview_th">
	<cfif len(url.s)>
		Resultado de la b&uacute;squeda de &quot;<cfoutput>#HTMLEditFormat(url.s)#</cfoutput>&quot;
		<cfif categoria.RecordCount and categoria.Ccodigo>
			en <cfoutput>#categoria.Cdescripcion#</cfoutput>
		</cfif>
	<cfelseif Len(categoria.Ccodigo) And categoria.Ccodigo>
		Mostrando categor&iacute;a <cfoutput>#categoria.Cdescripcion#</cfoutput>
	<cfelse>
		Listado de todos los productos
	</cfif>
			</span><br>

	<cfif bestseller.RecordCount>
	<table width="738" border="0">
      <tr>
        <td colspan="2"></td>
      </tr>
  	<cfset cantCk = 0>

<form name="formCompara" method="get" action="comparacionProd.cfm">		<!---  onSubmit="javascript: return validar();" --->
      <tr>
        <td width="369" valign="top">
	<table width="368" border="0">
	<cfif url.cat>
	  <tr>
		<td align="center" valign="middle">
<input type="checkbox" name="ckAll" id="ckAll" value="checkbox" onClick="javascript: funcChkAll(this);">
			<label for="ckAll"></label></td>
		<td colspan="3" valign="middle"><label for="ckAll">Seleccionar Todos</label>
<input name="add" onClick="javascript: return validar();" type="image" id="Comparar" value="Comparar" src="images/btn_comparar.gif" alt="Comparar caracteristicas de los productos seleccionados"></td>
		</tr>	</cfif>
			<input name="cat" value="<cfoutput>#URLEncodedFormat(url.cat)#</cfoutput>" type="hidden">
		  <cfoutput query="bestseller" startRow="#StartRow_bestseller#" maxRows="#Ceiling(MaxRows_bestseller / 2)#">
			<cfset cantCk = cantCk + 1>
			  <tr>
				<td rowspan="2" valign="middle" align="center">
					<input type="checkbox" name="ckCompa" value="#Aid#" onClick="javascript: UpdChkAll(this);">
				</td>		  
				<td width="89" rowspan="2"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.Ecodigo#&id=#Aid#&sz=sm" height="60" border="0"></a></td>
				<td width="27" valign="top">#CurrentRow# . </td>
				<td width="238" valign="top"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#" class="catview_link">#Adescripcion#</a></td>
			  </tr>
			  <tr>
				<td valign="top">&nbsp;</td>
				<td valign="top">Precio: <span class="catview_price">#moneda# #LSCurrencyFormat(precio,'none')#</span></td>
			  </tr>
		  </cfoutput>
        </table>
	    </td>
			<td width="359" valign="top">
			<table width="368" border="0">
			  <cfoutput query="bestseller" startRow="#StartRow_bestseller + Ceiling(MaxRows_bestseller / 2)#" maxRows="#Ceiling(MaxRows_bestseller / 2)#">
	  			<cfset cantCk = cantCk + 1>
				  <tr>
				    <td width="238" rowspan="2" valign="middle" align="center">
						<input type="checkbox" name="ckCompa" value="#Aid#"  onClick="javascript: UpdChkAll(this);">
					</td>
					<td width="89" rowspan="2"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.Ecodigo#&id=#Aid#&sz=sm" height="60" border="0"></a></td>
					<td width="27" valign="top">#CurrentRow# . </td>
					<td width="238" valign="top"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#" class="catview_link">#Adescripcion#</a></td>
				  </tr>
				  <tr>
				    <td valign="top">&nbsp;</td>
					<td valign="top">Precio: <span class="catview_price">#moneda# #LSCurrencyFormat(precio,'none')#</span></td>
				  </tr>
			  </cfoutput>
			</table>
		</td>
      </tr>
</form>

<script language="javascript" type="text/javascript">
	function funcChkAll(c) {
		if (document.formCompara.ckCompa) {
			if (document.formCompara.ckCompa.value) {
				if (!document.formCompara.ckCompa.disabled) { 
					document.formCompara.ckCompa.checked = c.checked;
				}
			} else {
				for (var counter = 0; counter < document.formCompara.ckCompa.length; counter++) {
					if (!document.formCompara.ckCompa[counter].disabled) {
						document.formCompara.ckCompa[counter].checked = c.checked;
					}
				}
			}
		}
	}
	
	function UpdChkAll(c) {
		var allChecked = true;
		if (!c.checked) {
			allChecked = false;
		} else {
			if (document.formCompara.ckCompa.value) {
				if (!document.formCompara.ckCompa.disabled) allChecked = true;
			} else {
				for (var counter = 0; counter < document.formCompara.ckCompa.length; counter++) {
					if (!document.formCompara.ckCompa[counter].disabled && !document.formCompara.ckCompa[counter].checked) {allChecked=false; break;}
				}
			}
		}
		document.formCompara.ckAll.checked = allChecked;
	}	

	function validar(){
		var cantCK = 0;		

		for(var i=0; i< <cfoutput>#cantCk#</cfoutput>  ;i++){
			if(document.formCompara.ckCompa[i].checked)
				cantCK++;
		}

		if(cantCK < 2){
			alert('Debe seleccionar al menos dos artículos');
			return false;			
		}

		return true;
	}
</script>
	  
      <tr>
        <td colspan="2">&nbsp; <cfoutput>Mostrando resultados del #StartRow_bestseller# al #EndRow_bestseller# de #searchsize.SQLRecordCount# </cfoutput> </td>
      </tr>
<tr>
  <td colspan="2">
    <table border="0" width="23%" align="center">
        <cfoutput>
          <tr>
            <td width="23%" align="center">
              <cfif PageNum_bestseller GT 1>
                <a href="#CurrentPage#?PageNum_bestseller=1#QueryString_bestseller#"><img src="images/First.gif" border=0></a>
              </cfif>
            </td>
            <td width="31%" align="center">
              <cfif PageNum_bestseller GT 1>
                <a href="#CurrentPage#?PageNum_bestseller=#Max(DecrementValue(PageNum_bestseller),1)##QueryString_bestseller#"><img src="images/Previous.gif" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_bestseller LT TotalPages_bestseller>
                <a href="#CurrentPage#?PageNum_bestseller=#Min(IncrementValue(PageNum_bestseller),TotalPages_bestseller)##QueryString_bestseller#"><img src="images/Next.gif" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_bestseller LT TotalPages_bestseller>
                <a href="#CurrentPage#?PageNum_bestseller=#TotalPages_bestseller##QueryString_bestseller#"><img src="images/Last.gif" border=0></a>
              </cfif>
            </td>
          </tr>
        </cfoutput>
    </table></td>
  </tr>
    </table>
	</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
<cfelse>
No se encontraron resultados para la b&uacute;squeda de
	&quot;<cfoutput>#HTMLEditFormat(url.s)#</cfoutput>&quot;
	</cfif>
	

	
	</cf_templatearea>
</cf_template>
