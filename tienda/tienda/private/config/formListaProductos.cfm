<!--- esta parte se usa cuando navega por la lista --->
<cfparam name="url.fBuscar" default="">
<cfset url.fBuscar = Trim(url.fBuscar)>
<!--- esta parte se usa cuando hace submit al buscar, esto para que inicie la lista desde la pagina 1, y no donde quedo la ultima vez que navego --->
<cfif Len(url.fBuscar)>
	<cfset url.PageNum_rs = 1 >
</cfif>

<cfif Len(url.fBuscar) gt 0 >
	<cfset filtro = " 	and ( upper(p.nombre_producto) like upper('%#url.fBuscar#%')   
					       or upper(r.nombre_presentacion) like upper('%#url.fBuscar#%')   
					       or upper(convert(varchar(255), p.txt_descripcion)) like upper('%#url.fBuscar#%') 
	                      or upper(c.nombre_categoria) like upper('%#url.fBuscar#%') )" >
</cfif>

<cffunction name="Highlight" returntype="string" output="false">
	<cfargument name="str" required="yes">
	
	<cfif Len(url.fBuscar)>
		<cfreturn REReplaceNoCase(str, url.fBuscar, '<b>\0</b>', 'all')>
	<cfelse>
		<cfreturn Arguments.str>
	</cfif>
</cffunction>

<cfquery name="rs" datasource="#session.DSN#">
	select c.id_categoria, c.nombre_categoria, p.id_producto,
		p.nombre_producto, p.txt_descripcion, p.precio, r.nombre_presentacion
	from Producto p, Categoria c, ProductoCategoria pc, Presentacion r
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	  and c.id_categoria =* pc.id_categoria 
	  and p.id_producto *= pc.id_producto
	  and r.id_producto = p.id_producto
	  <cfif isdefined("filtro")>#preservesinglequotes(filtro)#</cfif>
	order by upper(c.nombre_categoria), upper(p.nombre_producto)
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_rs" default="1">

<cfset MaxRows_rs=10>
<cfset StartRow_rs=Min((PageNum_rs-1)*MaxRows_rs+1,Max(rs.RecordCount,1))>
<cfset EndRow_rs=Min(StartRow_rs+MaxRows_rs-1,rs.RecordCount)>
<cfset TotalPages_rs=Ceiling(rs.RecordCount/MaxRows_rs)>
<cfset QueryString_rs=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rs,"PageNum_rs=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString_rs=ListDeleteAt(QueryString_rs,tempPos,"&")>
</cfif>

<cfif Len(url.fBuscar) >
	<cfset tempPos = ListContainsNoCase(QueryString_rs,"fBuscar=","&")>
	<cfif tempPos NEQ 0>
		<cfset QueryString_rs=ListDeleteAt(QueryString_rs,tempPos,"&")>
	</cfif>
	<cfset QueryString_rs = QueryString_rs & "&fBuscar=#url.fBuscar#">
</cfif>

<table border="0" width="100%" cellspacing="0" cellpadding="2">

	<tr>
		<td colspan="4">
			<cfoutput>
			<form style="margin:0" name="filtro" method="get" action="">
			<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
				<tr>
					<td width="1%">Buscar:&nbsp;</td>
					<td width="1%"><input type="text" name="fBuscar" size="40" maxlength="100" onFocus="this.select();" value="#HTMLEditFormat(url.fBuscar)#" ></td>
					<td width="3%">&nbsp;</td>
					<td width="95%" align=""><a href="javascript:filtrar()"><img border="0" src="../../images/find.small.png" alt="Filtrar lista de Productos"></a></td>
				</tr>
				
			</table>
			</form>
			</cfoutput>
		</td>
	</tr>

	<tr>
		<td colspan="4"><font size="2"><b>Listado de Productos</b></font></td>
	</tr>

	<cfif Len(url.fBuscar) gt 0>
		<tr>
			<td colspan="4"><b>Resultado de la Busqueda para:&nbsp;&nbsp;<cfoutput>#HTMLEditFormat(url.fBuscar)#</b></cfoutput></td>
		</tr>
	</cfif>

	<cfif rs.RecordCount gt 0 >
		<tr>
			<td class="tituloListas">Categor&iacute;a</td>
			<td class="tituloListas">Producto</td>
			<td class="tituloListas" align="right">Precio</td>
			<td class="tituloListas">Presentaci&oacute;n</td>
		</tr>
		
		<form name="lista" action="producto.cfm" method="get">
			<input type="hidden" name="id_producto" value="">
			<input type="hidden" name="modo" value="CAMBIO">
 		<cfoutput query="rs" startrow="#StartRow_rs#" maxrows="#MaxRows_rs#" group="id_producto" >
			<cfif rs.CurrentRow mod 2 eq 0><cfset class="listaNon"><cfelse><cfset class="listaPar"></cfif>
			
			<!--- <tr class="#class#" id="tr1_#rs.CurrentRow#" onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rs.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" > --->
			<tr class="#class#" id="tr1_#rs.CurrentRow#" onClick="javascript:procesar('#rs.id_producto#');" onmouseover="javascript:mouseOver(#rs.CurrentRow#);" onmouseout="javascript:mouseOut(#rs.CurrentRow#);" style="cursor:pointer " >
				<td>#Highlight(rs.nombre_categoria)#</td>
				<td># Highlight(rs.nombre_producto)#</td>
				<td align="right"><cfif len(trim(rs.precio)) gt 0>
				#LSNumberFormat(rs.precio,',9.00')#<cfelse>-
				</cfif></td>
				
				<cfquery name="rsPresentacion" datasource="#session.DSN#">
					select nombre_presentacion
					from Presentacion
					where id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.id_producto#">
				</cfquery>
				<cfset presentacion = ''>
				<cfoutput>
					<cfif Len(presentacion)>
						<cfset presentacion = presentacion & ', ' >
					</cfif>
					<cfset presentacion = presentacion & Trim(rs.nombre_presentacion) >
				</cfoutput>
				
				<td># Highlight(presentacion)#</td>
			</tr>
		</cfoutput>

		<cfoutput>
			<tr>
				<td align="center" colspan="4">
					<table border="0" width="10%" align="center">
						<tr>
							<cfif PageNum_rs GT 1>
							<td width="23%" align="center">
								<a href="#CurrentPage#?PageNum_rs=1#QueryString_rs#"><img src="/cfmx/sif/imagenes/First.gif" border=0></a>
							</td>
							</cfif>							

							<td width="31%" align="center">
								<cfif PageNum_rs GT 1>
									<a href="#CurrentPage#?PageNum_rs=#Max(DecrementValue(PageNum_rs),1)##QueryString_rs#"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a>
								</cfif>
							</td>

							<cfif PageNum_rs LT TotalPages_rs>
							<td width="23%" align="center">
								<a href="#CurrentPage#?PageNum_rs=#Min(IncrementValue(PageNum_rs),TotalPages_rs)##QueryString_rs#"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a>
							</td>
							</cfif>

							<cfif PageNum_rs LT TotalPages_rs>
							<td width="23%" align="center">
								<a href="#CurrentPage#?PageNum_rs=#TotalPages_rs##QueryString_rs#"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a>
							</td>
							</cfif>
						</tr>
					</table>	
				</td>	
			</tr>
		</cfoutput>

		</form>
	<cfelse>
		<tr><td colspan="4"><b>No se encontraron registros</b></td></tr>
	</cfif>
	
	<tr><td>&nbsp;</td></tr>

</table>

<script type="text/javascript" language="javascript1.2">
<!--
	function mouseOver(value){
		document.getElementById("tr1_" + value).style.backgroundColor='#E4E8F3';
		if ( document.getElementById("tr2_" + value)){
			document.getElementById("tr2_" + value).style.backgroundColor='#E4E8F3';
		}
	}

	function mouseOut(value){
		document.getElementById("tr1_" + value).style.backgroundColor = (value%2 == 0 ) ? '#FFFFFF' : '#FAFAFA';
		if ( document.getElementById("tr2_" + value) ){
			document.getElementById("tr2_" + value).style.backgroundColor = (value%2 == 0 ) ? '#FFFFFF' : '#FAFAFA';
		}	
	}
	
	function filtrar(){
		document.filtro.submit();
	}
	
	function procesar(value){
		document.lista.id_producto.value = value;
		document.lista.submit();
	}

	function funcNuevo(){
		document.lista.ID_PRODUCTO.value = '';
		document.lista.modo.value = 'ALTA';
		document.lista.submit();
	}
//-->
</script>
