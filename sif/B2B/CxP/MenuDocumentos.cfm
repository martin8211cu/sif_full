<!--- 
	Consulta todos los documentos para el pintado de la lista
	Manejado por Niveles 
	Anlisis por Cliente ***  Variable Analisis = 1 ***
	Variable Nivel = 1 (Predeterminado) Solo Presenta Deuda por Cliente en Moneda Local y Total en Moneda Local
	Variable Nivel = 2 (Click On Socio) Presenta Deuda por Cliente por Moneda Y Total en Moneda Local por Cliente
	Variable Nivel = 3 (Click On Moneda) Presenta Deuda por Cliente por Moneda por Documento Total por Moneda, y Total en Moneda Local por Cliente
	Anlisis por Moneda *** Variable Analisis = 2 ***
	Variable Nivel = 1 (Predeterminado) Solo Presenta Deuda por Moneda y Total en Moneda Local
	Variable Nivel = 2 (Click On Moneda) Presenta Deuda por Cliente por Moneda Y Total en Moneda Local por Cliente
	Variable Nivel = 3 (Click On Socio) Presenta Deuda por Cliente por Moneda por Documento Total por Moneda, y Total en Moneda Local por Cliente
--->
<cfif isdefined("Url.Analisis")><cfset Form.Analisis = Url.Analisis></cfif>
<cfif isdefined("Url.Nivel")><cfset Form.Nivel = Url.Nivel></cfif>
<cfif isdefined("Url.Order_By")><cfset Form.Order_By = Url.Order_By></cfif>

<!---<cfdump var="#form#">
<cfdump var="#url#">
<cfif isdefined("form.Ocodigo") and not isdefined("url.Ocodigo") and len(trim(form.Ocodigo))>
	<cfset url.Ocodigo = form.Ocodigo>
</cfif>

<cfif isdefined("url.Ocodigo") and not isdefined("form.Ocodigo") and len(trim(url.Ocodigo))>
	<cfset form.Ocodigo = url.Ocodigo>
</cfif>

<cfif isdefined("url.Ocodigo2") and not isdefined("form.Ocodigo") and len(trim(url.Ocodigo2))>
	<cfset form.Ocodigo = url.Ocodigo2>
</cfif>

<cfdump var="#form#">
<cfdump var="#url#">--->

<cfparam name="Form.Analisis" default="2">
<cfparam name="Form.Nivel" default="1">
<cfif Form.Analisis eq 1>
	<cfparam name="Form.Order_By" default="1">
	<cfif Form.Nivel eq 1>
		<cfset Descripcion = "Cliente">
		<cfset Desplegar = "SNnombre, Ltotal, Lsaldo">
		<cfset Campos = "a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, ">
		<cfset Group_By = "a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero">
		<cfset Order_By_Allowed = "1,2,7,8,9,10">
		<cfset Order_By_Str = "">
	<cfelseif Form.Nivel eq 2>
		<cfset Descripcion = "Moneda">
		<cfset Desplegar = "Mnombre, Dtotal, Dsaldo">
		<cfset Campos = "a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, c.Mcodigo, c.Mnombre, ">
		<cfset Group_By = "a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, c.Mcodigo, c.Mnombre">
		<cfset Order_By_Allowed = "3,4,7,8,9,10">
		<cfset Order_By_Str = "a.SNnombre">
	<cfelse>
		<cfset Descripcion = "Documento">
		<cfset Desplegar = "Ddocumento, Ltotal, Lsaldo">
		<cfset Campos = "a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, c.Mcodigo, c.Mnombre, b.Ddocumento, ">
		<cfset Group_By = "a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, c.Mcodigo, c.Mnombre, b.Ddocumento">
		<cfset Order_By_Allowed = "5,6,7,8,9,10">
		<cfset Order_By_Str = "a.SNnombre, c.Mnombre">
	</cfif>
<cfelse>
	<cfparam name="Form.Order_By" default="3">
	<cfif Form.Nivel eq 1>
		<cfset Descripcion = "Moneda">
		<cfset Desplegar = "Mnombre, Dtotal, Dsaldo">
		<cfset Campos = "c.Mcodigo, c.Mnombre, ">
		<cfset Group_By = "c.Mcodigo, c.Mnombre">
		<cfset Order_By_Allowed = "3,4,7,8,9,10">
		<cfset Order_By_Str = "">
	<cfelseif Form.Nivel eq 2>
		<cfset Descripcion = "Cliente">
		<cfset Desplegar = "SNnombre, Dtotal, Dsaldo">
		<cfset Campos = "c.Mcodigo, c.Mnombre, a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, ">
		<cfset Group_By = "c.Mcodigo, c.Mnombre, a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero">
		<cfset Order_By_Allowed = "1,2,7,8,9,10">
		<cfset Order_By_Str = "c.Mnombre">
	<cfelse>
		<cfset Descripcion = "Documento">
		<cfset Desplegar = "Ddocumento, Dtotal, Dsaldo">
		<cfset Campos = "c.Mcodigo, c.Mnombre, a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, b.Ddocumento, ">
		<cfset Group_By = "c.Mcodigo, c.Mnombre, a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, b.Ddocumento">
		<cfset Order_By_Allowed = "5,6,7,8,9,10">
		<cfset Order_By_Str = "c.Mnombre, a.SNnombre">
	</cfif>
</cfif>
<cfset order_by_SNnombre = 1><cfset order_by_SNnombreDesc = 2>
<cfset order_by_Mnombre = 3><cfset order_by_Mnombredesc = 4>
<cfset order_by_Ddocumento = 5><cfset order_by_Ddocumentodesc = 6>
<cfset order_by_Total = 7><cfset order_by_TotalDesc = 8>
<cfset order_by_Saldo = 9><cfset order_by_SaldoDesc = 10>
<!--- ******************************************************* CONSULTA *************************************************************** --->
<cfquery name="Lista" datasource="#session.dsn#">
	select #Campos# 
		round(sum(coalesce(b.Dtotal,0)),2) as Dtotal, 
		round(sum(coalesce((b.Dtotal * b.Dtipocambio),0)),2) as Ltotal, 
		round(sum(coalesce(b.EDsaldo,0)),2) as Dsaldo, 
		round(sum(coalesce((b.EDsaldo * b.Dtipocambio),0)),2) as Lsaldo 
	from SNegocios a
		inner join EDocumentosCP b <cf_dbforceindex name="EDocumentosCP_FK3 ">
			on  b.Ecodigo = a.Ecodigo
			and b.SNcodigo = a.SNcodigo
		inner join Monedas c
			on c.Mcodigo = b.Mcodigo
		inner join CPTransacciones d
			on  b.CPTcodigo = d.CPTcodigo 
			and b.Ecodigo   = d.Ecodigo 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.SNcodigo = #session.B2B.SNcodigo#
	  and b.EDsaldo > 0
      <cfif isdefined("Form.Ocodigo")  and len(trim(form.Ocodigo)) and form.Ocodigo neq '-1'>
		and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
	</cfif>
	  <!---and b.Dfechavenc between 
				<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(now()),month(now()),01)#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">--->
	  and d.CPTtipo = 'C'
	Group By #Group_By# 
	<cfswitch expression="#Form.Order_By#">
		<cfcase value="1"><cfif ListFind(Order_By_Allowed,'1')><cfif Find('SNnombre',Order_By_Str,1) eq 0><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'SNnombre'></cfif></cfif></cfcase>
		<cfcase value="2"><cfif ListFind(Order_By_Allowed,'2')><cfif Find('SNnombre',Order_By_Str,1) eq 0><cfset Replace(Order_By_Str,'SNnombre','SNnombre desc')><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'SNnombre desc'></cfif></cfif></cfcase>
		<cfcase value="3"><cfif ListFind(Order_By_Allowed,'3')><cfif Find('Mnombre',Order_By_Str,1) eq 0><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Mnombre'></cfif></cfif></cfcase>
		<cfcase value="4"><cfif ListFind(Order_By_Allowed,'4')><cfif Find('Mnombre',Order_By_Str,1) eq 0><cfset Replace(Order_By_Str,'Mnombre','Mnombre desc')><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Mnombre desc'></cfif></cfif></cfcase>
		<cfcase value="5"><cfif ListFind(Order_By_Allowed,'5')><cfif Find('Ddocumento',Order_By_Str,1) eq 0><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Ddocumento'></cfif></cfif></cfcase>
		<cfcase value="6"><cfif ListFind(Order_By_Allowed,'6')><cfif Find('Ddocumento',Order_By_Str,1) eq 0><cfset Replace(Order_By_Str,'Ddocumento','Ddocumento desc')><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Ddocumento desc'></cfif></cfif></cfcase>
		<cfcase value="7"><cfif ListFind(Order_By_Allowed,'7')><cfif Find('Dtotal',Order_By_Str,1) eq 0><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Dtotal'></cfif></cfif></cfcase>
		<cfcase value="8"><cfif ListFind(Order_By_Allowed,'8')><cfif Find('Dtotal',Order_By_Str,1) eq 0><cfset Replace(Order_By_Str,'Dtotal','Dtotal desc')><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Dtotal desc'></cfif></cfif></cfcase>
		<cfcase value="9"><cfif ListFind(Order_By_Allowed,'9')><cfif Find('Dsaldo',Order_By_Str,1) eq 0><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Dsaldo'></cfif></cfif></cfcase>
		<cfcase value="10"><cfif ListFind(Order_By_Allowed,'10')><cfif Find('Dsaldo',Order_By_Str,1) eq 0><cfset Replace(Order_By_Str,'Dsaldo','Dsaldo desc')><cfif len(Order_By_Str) gt 0><cfset Order_By_Str = Order_By_Str & ','></cfif><cfset Order_By_Str = Order_By_Str & 'Dsaldo desc'></cfif></cfif></cfcase>
	</cfswitch>
	<cfif len(Order_By_Str) gt 0>Order By #Order_By_Str#</cfif>
</cfquery>
<!--- ******************************************************* /CONSULTA ************************************************************** --->
<!--- Variables para manejar la lista --->
<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">
<cfparam name="PageNum_Lista" default="1">
<cfparam name="PageIndex" default="">
<cfparam name="QueryString_lista" default="">
<cfset MaxRows_Lista=15>
<cfset StartRow_Lista=Min((PageNum_Lista-1)*MaxRows_Lista+1,Max(Lista.RecordCount,1))>
<cfset EndRow_Lista=Min(StartRow_Lista+MaxRows_Lista-1,Lista.RecordCount)>
<cfset TotalPages_Lista=Ceiling(Lista.RecordCount/MaxRows_Lista)>
<cfset QueryString_lista=Iif(Len(Trim(CGI.QUERY_STRING)),DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista#PageIndex#=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"Analisis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"Nivel=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"Order_By=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"Ocodigo=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<table width="100%" border="1" cellspacing="2" cellpadding="0">
	<cfif not isdefined("LvarAnalisis")>
	  <tr> 
        <td colspan="2" width="100%" align="center"><cfoutput><strong>Proveedor:</strong> #session.B2B.SNnombre# / <strong>Número:</strong> #session.B2B.SNnumero#</cfoutput></td>
      </tr>
      <tr> 
        <td width="50%" align="left" style="padding-left: 5px; padding-right: 5px">Oficina</td>
        <td  align="right" width="50%"> 
        <form action="MenuCP.cfm" method="post" name="formDoc">
			<cfif isdefined("Form.Ocodigo") and Form.Ocodigo NEQ -1>	
                <cf_sifoficinas form="formDoc" id="#form.Ocodigo#">
            <cfelse>
                <cf_sifoficinas form="formDoc">
            </cfif>
        </form>
        </td>
      </tr>
    </cfif>
    
	<tr>
	<td colspan="2">
	
	<table width="99.5%" align="center"  border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
		<tr>
		  <td class="cfmenu_titulo" colspan="4" align="center">
			Documentos pendientes por pagar de #LSMonthAsString(Month(Now()))# (Analisis por <input class="cfmenu_titulo" type="radio" onclick="javascript:funcAnalisis(2);" <cfif Form.Analisis eq 2>checked</cfif> />Moneda / <input class="cfmenu_titulo" type="radio" onclick="javascript:funcAnalisis(1);" <cfif Form.Analisis eq 1>checked</cfif> />Cliente)
		  </td>
		</tr>
		<tr>
			<td class="cfmenu_menu" align="left" width="50%"><a href="##"onclick="javascript: funcOrderBy(1);"><strong>#Descripcion#</strong></a> (<cfif Form.Nivel EQ 1><a href="##" onclick="javascript: funcNivel(2);">Ver Detalles</a><cfelse><a href="##" onclick="javascript: funcNivel(1);">Cerrar Detalles</a></cfif>)</td>
			<td class="cfmenu_menu" align="right" width="25%"><a href="##"onclick="javascript: funcOrderBy(2);"><strong>Total</strong></a></td>
			<td class="cfmenu_menu" align="right" width="25%"><a href="##"onclick="javascript: funcOrderBy(3);"><strong>Saldo</strong></a></td>
		</tr>
	</cfoutput>
	</table>
	<div id="divDocumentos" style="overflow:auto; margin:0;">
	<table width="100%"  border="0" cellspacing="2" cellpadding="0">
	<!--- ************************************************** PINTADO LISTA *********************************************************** --->
	<cfset _Corte_Nivel2 = -1>
	<cfoutput query="Lista" startrow="#StartRow_Lista#" maxrows="#MaxRows_Lista#">
		<!--- CORTES --->
		<cfif Form.Analisis eq 1>
			<cfif Form.Nivel eq 2>
				<cfif isdefined("Lista.SNid") and _Corte_Nivel2 NEQ Lista.SNid>
					<cfset _Corte_Nivel2 = Lista.SNid>
					<tr>
						<td class="cfmenu_submenu" align="left" colspan="3"><strong>#SNnombre#</strong> (<cfif Form.Nivel EQ 2><a href="##" onclick="javascript: funcNivel(3);">Ver Documentos</a><cfelse><a href="##" onclick="javascript: funcNivel(2);">Cerrar Documentos</a></cfif>)</td>
					</tr>
				</cfif>
			<cfelseif Form.Nivel eq 3>
				<cfif isdefined("Lista.SNid") and _Corte_Nivel2 NEQ Lista.SNid>
					<cfset _Corte_Nivel2 = Lista.SNid>
					<cfset _Corte_Nivel3 = -1>
					<tr>
						<td class="cfmenu_submenu" align="left" colspan="3"><strong>#SNnombre#</strong> (<cfif Form.Nivel EQ 2><a href="##" onclick="javascript: funcNivel(3);">Ver Documentos</a><cfelse><a href="##" onclick="javascript: funcNivel(2);">Cerrar Documentos</a></cfif>)</td>
					</tr>
				</cfif>
				<cfif isdefined("Lista.Mcodigo") and _Corte_Nivel3 NEQ Lista.Mcodigo>
					<cfset _Corte_Nivel3 = Lista.Mcodigo>
					<tr>
						<td class="cfmenu_submenu" align="left" colspan="3"><strong>#Mnombre#</strong></td>
					</tr>
				</cfif>
			</cfif>
		<cfelse>
			<cfif Form.Nivel eq 2>
				<cfif isdefined("Lista.Mcodigo") and _Corte_Nivel2 NEQ Lista.Mcodigo>
					<cfset _Corte_Nivel2 = Lista.Mcodigo>
					<tr>
						<td class="cfmenu_submenu" align="left" colspan="3"><strong>#Mnombre#</strong> (<cfif Form.Nivel EQ 2><a href="##" onclick="javascript: funcNivel(3);">Ver Documentos</a><cfelse><a href="##" onclick="javascript: funcNivel(2);">Cerrar Documentos</a></cfif>)</td>
					</tr>
				</cfif>
			<cfelseif Form.Nivel eq 3>
				<cfif isdefined("Lista.Mcodigo") and _Corte_Nivel2 NEQ Lista.Mcodigo>
					<cfset _Corte_Nivel2 = Lista.Mcodigo>
					<cfset _Corte_Nivel3 = -1>
					<tr>
						<td class="cfmenu_submenu" align="left" colspan="3"><strong>#Mnombre#</strong> (<cfif Form.Nivel EQ 2><a href="##" onclick="javascript: funcNivel(3);">Ver Documentos</a><cfelse><a href="##" onclick="javascript: funcNivel(2);">Cerrar Documentos</a></cfif>)</td>
					</tr>
				</cfif>
				<cfif isdefined("Lista.SNid") and _Corte_Nivel3 NEQ Lista.SNid>
					<cfset _Corte_Nivel3 = Lista.SNid>
					<tr>
						<td class="cfmenu_submenu" align="left" colspan="3"><strong>#SNnombre#</strong></td>
					</tr>
				</cfif>
			</cfif>
		</cfif>
		<!--- CORTES --->
		<cfset LvarListaNon = (CurrentRow MOD 2)>
		<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
			<cfset Arr_Desplegar = ListToArray(Desplegar)>
			<td width="50%" class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="left">#Evaluate(Arr_Desplegar[1])#</td>
			<td width="25%" class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right"><font color="##FF0000">#LsCurrencyFormat(Evaluate(Arr_Desplegar[2]),"none")#</font></td>
			<td width="25%" class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right"><font color="##FF0000">#LsCurrencyFormat(Evaluate(Arr_Desplegar[3]),"none")#</font></td>
		</tr>
	</cfoutput>
	<!--- ************************************************** /PINTADO LISTA ********************************************************** --->
	<cfoutput>
	<tr> 
		<td align="center" colspan="4">
		<cfif PageNum_lista GT 1>
			<a href="#CurrentPage#?PageNum_lista#PageIndex#=1#QueryString_lista#&Analisis=#Form.Analisis#&Nivel=#Form.Nivel#&Order_By=#Form.Order_By#" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border=0></a> 
		</cfif>
		<cfif PageNum_lista GT 1>
			<a href="#CurrentPage#?PageNum_lista#PageIndex#=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#&Analisis=#Form.Analisis#&Nivel=#Form.Nivel#&Order_By=#Form.Order_By#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a> 
		</cfif>
		<cfif PageNum_lista LT TotalPages_lista>
			<a href="#CurrentPage#?PageNum_lista#PageIndex#=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#&Analisis=#Form.Analisis#&Nivel=#Form.Nivel#&Order_By=#Form.Order_By#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a> 
		</cfif>
		<cfif PageNum_lista LT TotalPages_lista>
			<a href="#CurrentPage#?PageNum_lista#PageIndex#=#TotalPages_lista##QueryString_lista#&Analisis=#Form.Analisis#&Nivel=#Form.Nivel#&Order_By=#Form.Order_By#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a> 
		</cfif> 
		</td>
	</tr>
	<script language="javascript" type="text/javascript">
		<!--//
			function funcOrderBy(ob) {
				if (ob==1){
					var vob = <cfif Form.Analisis eq 1>
						<cfif Form.Nivel eq 1>
							<cfif Form.Order_By eq 1>2<cfelse>1</cfif>
						<cfelseif Form.Nivel eq 2>
							<cfif Form.Order_By eq 3>4<cfelse>3</cfif>
						<cfelse>
							<cfif Form.Order_By eq 5>6<cfelse>5</cfif>
						</cfif>
					<cfelse>
						<cfif Form.Nivel eq 1>
							<cfif Form.Order_By eq 3>4<cfelse>3</cfif>
						<cfelseif Form.Nivel eq 2>
							<cfif Form.Order_By eq 1>2<cfelse>1</cfif>
						<cfelse>
							<cfif Form.Order_By eq 5>6<cfelse>5</cfif>
						</cfif>
					</cfif>;
					location.href="#CurrentPage#?PageNum_lista#PageIndex#=#PageNum_Lista##QueryString_lista#&Analisis=#Form.Analisis#&Nivel=#Form.Nivel#&Order_By="+vob;
				} else if (ob==2) {
					location.href="#CurrentPage#?PageNum_lista#PageIndex#=#PageNum_Lista##QueryString_lista#&Analisis=#Form.Analisis#&Nivel=#Form.Nivel#&Order_By=<cfif Form.Order_By eq 7>8<cfelse>7</cfif>";
				} else {
					location.href="#CurrentPage#?PageNum_lista#PageIndex#=#PageNum_Lista##QueryString_lista#&Analisis=#Form.Analisis#&Nivel=#Form.Nivel#&Order_By=<cfif Form.Order_By eq 9>10<cfelse>9</cfif>";
				}
			}
			function funcAnalisis(an) {
				location.href="#CurrentPage#?PageNum_lista#PageIndex#=#PageNum_Lista##QueryString_lista#&Analisis="+an;
			}
			function funcNivel(nv) {
				location.href="#CurrentPage#?PageNum_lista#PageIndex#=#PageNum_Lista##QueryString_lista#&Analisis=#Form.Analisis#&Order_By=#Form.Order_By#&Nivel="+nv;
			}
		//-->
	</script>
	</cfoutput>
	</table>
	</div>
	</td>
	</tr>
</table>


<cffunction 
	name="LSMonthAsString" 
	output="true"
	returntype="string">
	<cfargument name="Month" required="true">
	<cfquery name="rsMonthAsString" datasource="sifcontrol">
		select min(b.VSdesc) as Month
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Month#">
			and b.VSgrupo = 1
		where a.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
	</cfquery>
	<cfif rsMonthAsString.recordcount>
		<cfreturn rsMonthAsString.Month>
	</cfif>
</cffunction>
<script language="javascript" type="text/javascript">
	function funcOficodigo(){document.formDoc.submit();}
	
</script>