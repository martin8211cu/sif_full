

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<html>
<head>
<title>Anexos Financieros: Rangos por Anexo</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>


<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>

</head>

<!--- window.event.clientY < 0 ) || ( window.event.clientX < 0 --->
<body >
	<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

	<cfif not isdefined("url.AnexoId") or len(trim(url.AnexoId)) EQ 0>
  		<script language="JavaScript1.2">window.close();</script>
		<cfabort>
	</cfif>

	<cfquery name="rsAnexo" datasource="#Session.DSN#">
		select AnexoDes, <cf_dbfunction name="to_date" args="AnexoFec"> as AnexoFec, AnexoUsu 
		from Anexo
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>

	<cfquery name="rsxml" datasource="#Session.DSN#">
		select AnexoDef
		from Anexoim 
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_decimal" value="#url.AnexoId#">
	</cfquery>

	<!--- Crear una variable que contenga el xml del Anexo --->
	<cfset xmldoc = xmlparse(rsxml.AnexoDef)>
	<!---<cfdump var="#xmldoc#">--->

	<!--- Determinar la cantidad de Rangos que posee el XML y crear un query con los datos del Rango--->
	<cfset ExisteRangos1 = listFind(structkeylist(xmldoc['ss:WorkBook']),'ss:Names')>

	<cfif ExisteRangos1 GT 0 >
		<cfset cant = ArrayLen(xmldoc['ss:WorkBook']['ss:Names'].xmlChildren)>
		<cfset rsRangosxml = QueryNew("name,range, col, row")>
		
		<cfset temp = QueryAddRow(rsRangosxml,cant)>
		
		<cfloop index="i" from="1" to="#cant#">
			<cfset rango =  xmldoc['ss:WorkBook']['ss:Names'].xmlChildren[i].XmlAttributes['ss:RefersTo'] >
			<cfset nombre = xmldoc['ss:WorkBook']['ss:Names'].xmlChildren[i].XmlAttributes['ss:Name'] >
		
			<cfset rango = mid(rango, findnocase("!", rango) + 1, 255) >
		
			<cfif findnocase("C", rango) GTE 1>
				<cfset rangoCol = mid(rango, findnocase("C", rango) + 1, 255) >
				<cfset rangoRow = mid(rango, 2, findnocase("C", rango) - 2) >
			<cfelse>
				<cfset rangoCol = 0 >
				<cfset rangoRow = 0 >
			</cfif>
				
			
			<cfset temp = QuerySetCell(rsRangosxml, "name", nombre, i)>
			<cfset temp = QuerySetCell(rsRangosxml, "range", rango, i)>
			<cfset temp = QuerySetCell(rsRangosxml, "row", rangoRow, i)>
			<cfset temp = QuerySetCell(rsRangosxml, "col", rangoCol, i)>
		</cfloop>
	
		<cfquery name="rsRangos1" dbtype="query">
			select name, range, col, row from rsRangosXml
		</cfquery>

		<cfquery name="rsRangos2" datasource="#Session.DSN#">
			select AnexoRan as name, <cf_dbfunction name="to_char" args="AnexoCelId"> as AnexoCelId
			from AnexoCel
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_decimal" value="#url.AnexoId#">
		</cfquery>

		<cfquery name="rsRangos3" dbtype="query" >
			select name
			from rsRangos2
			union
			select name
			from rsRangos1
		</cfquery>
	<cfelse>
		<cfquery name="rsRangos3" datasource="#Session.DSN#">
			select AnexoRan as name, <cf_dbfunction name="to_char" args="AnexoCelId"> as AnexoCelId
			from AnexoCel
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_decimal" value="#url.AnexoId#">
		</cfquery>
	</cfif>
	
	<cfoutput>

	<cfparam name="PageNum_rsRangos3" default="1">
	<cfset MaxRows_rsRangos3=20>
	<cfset StartRow_rsRangos3=Min((PageNum_rsRangos3-1)*MaxRows_rsRangos3+1,Max(rsRangos3.RecordCount,1))>
	<cfset EndRow_rsRangos3=Min(StartRow_rsRangos3+MaxRows_rsRangos3-1,rsRangos3.RecordCount)>
	<cfset TotalPages_rsRangos3=Ceiling(rsRangos3.RecordCount/MaxRows_rsRangos3)>
	<cfset QueryString_rsRangos3=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
	<cfset tempPos=ListContainsNoCase(QueryString_rsRangos3,"PageNum_rsRangos3=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_rsRangos3=ListDeleteAt(QueryString_rsRangos3,tempPos,"&")>
	</cfif>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="ayuda">
		<tr><td colspan="5" bgcolor="##3399CC" align="center"><strong><font color="##FFFFFF" size="2">Anexos Financieros</font></strong></td></tr>

		<tr> 
			<td width="6%" height="19">Anexo:&nbsp;</td>
			<td width="29%">#rsAnexo.AnexoDes#</td>
			<td width="14%" align="right"></td>
			<td width="3%"><img src="../../imagenes/Recordset.gif" alt="" width="18" height="18" align="absmiddle" onload="MM_preloadImages('../../imagenes/Recordset.gif')"></td>
			<td width="48%">El rango est&aacute; definido solamente en la Base de Datos.</td>
		</tr>

		<tr> 
			<td><strong>Fecha:</strong></td>
			<td>#rsAnexo.AnexoFec#</td>
			<td>&nbsp;</td>
			<td><img src="../../imagenes/toolbar_sub.gif" alt="" width="15" height="20" align="absmiddle" onload="MM_preloadImages('../../imagenes/toolbar_sub.gif')"></td>
			<td>El rango est&aacute; definido solamente en la Hoja.</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><img src="../../imagenes/options.small.png" alt="" width="16" height="16" align="absmiddle" onload="MM_preloadImages('../../imagenes/options.small.png')"></td>
			<td>El rango est&aacute; correctamente definido.</td>
		</tr>
	</table>
	</cfoutput>

	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr> 
			<td width="38%" align="center" valign="top" nowrap>
				<form name="lista" method="post" action="">
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr><td colspan="5" align="center" bgcolor="#CCCCCC"><strong><font size="2">Rangos Definidos</font></strong></td></tr>
	
						<tr class="tituloListas"> 
							<td width="30%"><strong>Rango</strong></td>
							<td width="27%"><strong>Columna</strong></td>
							<td width="26%"><strong>Fila</strong></td>
							<td width="12%" align="center"><strong>Estado</strong></td>
							<td align="center"><strong>Cuentas</strong></td>
						</tr>
	
						<cfoutput query="rsRangos3" startrow="#StartRow_rsRangos3#" maxrows="#MaxRows_rsRangos3#"> 
							<tr <cfif rsRangos3.CurrentRow mod 2> class="listaNon" <cfelse> class="listaPar"</cfif>> 
								<td nowrap onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif rsRangos3.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
									<cfif isdefined("rsRangos2")>
										<cfquery name="rsIDCelda" dbtype="query">
											select AnexoCelId from rsRangos2 where name = '#rsRangos3.name#' 
										</cfquery>
										<a href="javascript:Asignar('#Trim(rsRangos3.name)#','#Trim(rsIDCelda.AnexoCelId)#');">#rsRangos3.name#</a>
									</cfif>
								</td>
									
								<cfif ExisteRangos1 GT 0>
									<cfquery name="rsRangos4" dbtype="query">
										select col, row from rsRangos1 where name = '#rsRangos3.name#' 
									</cfquery>
	
									<cfquery name="rsRangos5" dbtype="query">
										select 1 from rsRangos2 where name = '#rsRangos3.name#' 
									</cfquery>
									
									<td nowrap><cfif rsRangos4.RecordCount GT 0>#rsRangos4.col#<cfelse>--</cfif></td>
									
									<td nowrap><cfif rsRangos4.RecordCount GT 0>#rsRangos4.row#<cfelse>--</cfif></td>
	
									<td valign="middle" nowrap >
										<cfquery name="rsAnexoCelD" datasource="#Session.DSN#">
											select count(1) as cantidad from AnexoCelD where AnexoCelId = 
											<cfif len(trim(rsIDCelda.AnexoCelid)) NEQ 0>#rsIDCelda.AnexoCelId#<cfelse>-100</cfif>
										</cfquery>
										
										<cfif rsRangos4.RecordCount EQ 0>
											<img src="../../imagenes/Recordset.gif" alt="">BD 
										<cfelse>
											<cfif rsRangos5.recordcount GT 0>
												<img src="../../imagenes/options.small.png" alt="" onload="MM_preloadImages('../../imagenes/options.small.png')"> 
											<cfelse>
												<img src="../../imagenes/toolbar_sub.gif" width="15" height="20" alt="">Hoja 
											</cfif>
										</cfif>
									</td>
								<cfelseif isdefined("rsRangos2") and rsRangos2.RecordCount GT 0>
									<td valign="middle" nowrap> <img src="../../imagenes/Recordset.gif" alt="">BD</td>
								</cfif>
		
								<td>
									<cfif isdefined("rsAnexoCelD.cantidad")>
										<cfif rsAnexoCelD.cantidad EQ 0>No</cfif>
									</cfif> 
								</td>
							</tr>
						</cfoutput> 
	
						<tr> 
							<td colspan="4">
								<table border="0" width="50%" align="center">
									<cfoutput> 
									<tr> 
										<td width="23%" align="center"> <cfif PageNum_rsRangos3 GT 1><a href="#CurrentPage#?PageNum_rsRangos3=1#QueryString_rsRangos3#"><img src="/cfmx/sif/imagenes/First.gif" border=0></a></cfif></td>
										<td width="31%" align="center"> <cfif PageNum_rsRangos3 GT 1><a href="#CurrentPage#?PageNum_rsRangos3=#Max(DecrementValue(PageNum_rsRangos3),1)##QueryString_rsRangos3#"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a></cfif></td>
										<td width="23%" align="center"> <cfif PageNum_rsRangos3 LT TotalPages_rsRangos3><a href="#CurrentPage#?PageNum_rsRangos3=#Min(IncrementValue(PageNum_rsRangos3),TotalPages_rsRangos3)##QueryString_rsRangos3#"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a></cfif></td>
										<td width="23%" align="center"> <cfif PageNum_rsRangos3 LT TotalPages_rsRangos3><a href="#CurrentPage#?PageNum_rsRangos3=#TotalPages_rsRangos3##QueryString_rsRangos3#"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a></cfif></td>
									</tr>
									</cfoutput>
								</table>
							</td>
						</tr>
	
						<input type="hidden" name="AnexoCelId2" value="">
						<input type="hidden" name="AnexoRan2" value="">
					</table>
				</form>
			</td>
	
			<td align="left" valign="top" width="5%" nowrap>&nbsp;</td>
			<td align="left" valign="top">
				<blockquote> 
				<p><br>
				<cfinclude template="formAnexoCel.cfm">
				</blockquote>

				<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
					<tr><td><strong>Instrucciones:</strong></td></tr>
				
					<tr> 
						<td height="87">
							<ol>
								<li>Indique el Nombre del Rango que desea crear.</li>
								<li>Seleccione el Concepto de c&aacute;lculo para el Rango.<font color="#666699"><strong></strong></font></li>
								<li>Indique si el Mes es relativo. Cuando el Mes es relativo al 
								per&iacute;odo actual de la Contabilidad se le restan la cantidad 
								de meses indicados.</li>
								<li>Si el mes es Relativo, el Per&iacute;odo es el actual.</li>
								<li>Si no especifica una oficina para el rango se tomar&aacute; 
								la oficina que se indica en la Hoja del Anexo.</li>
								<li>Si desea que el resultado sea multiplicado por -1, marque la 
								opci&oacute;n indicada.</li>
								<li>Si desea modificar un Rango, selecci&oacute;nelo de la Lista, 
								haga el cambio que desea y oprima <font color="#333399"><strong>Modificar.</strong></font></li>
								<li>Para regresar a la Hoja del Anexo oprima <font color="#003399"><strong>Cerrar</strong></font>. 
								</li>
							</ol>
					
							<p>
								<strong>Nota:</strong><br>
								Solamente los Rangos que se encuentren en la Hoja y en la Base de 
								Datos podrán ser desplegados correctamente en la Hoja del Anexo. 
							</p>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr><td colspan="3">&nbsp;</td></tr>
	
		<tr><td colspan="3">&nbsp;</td></tr>
	</table>

	<script language="JavaScript1.2">
		function Asignar(rango, id) {
			if (id == ''){
				document.lista.AnexoCelId2.value = '';
				<cfset modo = "ALTA">
			}
			else{
				document.lista.AnexoCelId2.value=id;
				<cfset modo ="CAMBIO">
			}
			
			document.lista.AnexoRan2.value=rango;	
			document.lista.submit();
		}
		window.focus();
	</script>
</body>
</html>

