<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<style type="text/css">
<!--
.style7 {color: #FF0000; font-weight: bold; }
-->
</style>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <!---Es x plan de compras?---->
	<cfquery name="rsUsaPlan" datasource="#session.DSN#">
		select Pvalor
			from Parametros
		where Pcodigo = 2300
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
	</cfquery>
	<cfset LvarParam4300 = 0>
	<cfif rsUsaPlan.Pvalor eq 1>
		 <!---Permite des reservar del presupuesto si la OC no cubre el total de la SC ---->
		<cfquery name="rsParam" datasource="#session.DSN#">
			select Pvalor
				from Parametros
			where Pcodigo = 4300
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
		</cfquery>
		 <cfset LvarParam4300 = rsParam.Pvalor>
	</cfif>
   <cfquery name="rsMontoMax" datasource="#session.dsn#">
    select CMCmontomax, Mcodigo  from CMCompradores
	where Ecodigo = #session.Ecodigo#
	and Usucodigo = #session.Usucodigo#
   </cfquery>
   <cfif rsOrden.Mcodigo neq  rsMontoMax.Mcodigo>
       <cfquery datasource="#session.dsn#" name="rsHtc">
			select coalesce(TCventa,0) as TCventa
			from Htipocambio
			where Mcodigo = #rsMontoMax.Mcodigo#
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between Hfecha and Hfechah
	   </cfquery>
	   <cfif rsHtc.recordcount eq 0>
	     <cfset LvarTC =  1>
	   <cfelse>
	    <cfset  LvarTC =  rsHtc.TCventa>
	   </cfif>

     <cfset LvarMontoDoc = 0>
	 <cfset LvarMontoDoc = rsTotales.subtotal+rsTotales.impuesto-rsTotales.descuento>
	 <cfset LvarMontoDoc = LvarMontoDoc * rsOrden.EOtc>
	 <cfset LvarMontoMaxCMC = rsMontoMax.CMCmontomax * LvarTC>
	<cfelse>
	 <cfset LvarMontoDoc = rsTotales.subtotal+rsTotales.impuesto-rsTotales.descuento>
	 <cfset LvarMontoMaxCMC = rsMontoMax.CMCmontomax>
	</cfif>
	<cfif LvarMontoDoc gt LvarMontoMaxCMC and modo EQ "CAMBIO" and rsOrden.EOestado neq -7 and rsOrden.EOestado neq 9 and rsOrden.EOestado neq -8 >
		<tr align="center">
			<td>
		       <span class="style7"> Usted excedió el monto máximo que tiene definido para comprar.	</span>
			</td>
		</tr>
        <tr align="center">
			<td class="style7"> Si aplica esta orden pasará a un proceso de aprobación, donde el jefe de compras deberá autorizar la Orden de compra.			</td>
	   </tr>
	</cfif>
	<tr>
		<td class="subTitulo"><font size="2">Lista de Detalles</font></td>
	</tr>
</table>
<cf_dbfunction name="to_char" args="a.DOlinea" returnvariable="DOlinea">
<cf_dbfunction name="to_char" args="a.EOidorden" returnvariable="orden">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return EditarLinea('+#PreserveSingleQuotes(DOlinea)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/iedit.gif''></a>&nbsp;'" returnvariable="edit" delimiters="+">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return EliminarLinea('+#PreserveSingleQuotes(DOlinea)#+','+#PreserveSingleQuotes(orden)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/idelete.gif''></a>&nbsp;'" returnvariable="eliminar" delimiters="+">

<cfif rsUsaPlan.Pvalor eq 1 and LvarParam4300 eq 1>
  <cfset campos= "DOconsecutivo,CMTipodesc,Codigo,DOdescripcion,DOcantidad,Udescripcion,DOpreciou,DOtotal,editar,eliminar">
  <cfset etiquetas= "L&iacute;nea,Tipo,C&oacute;digo,Descripci&oacute;n,Cantidad,Unidad Medida,Precio,Total, Editar, Eliminar">
  <cfset formatos= "V,V,V,V,M,V,V,M,U,U">
  <cfset posiciones= "left,left,left,left,right,center,right,right,center,center">

<cfelse>
  <cfset campos= "DOconsecutivo,ref,CMTipodesc,Codigo,DOdescripcion,DOcantidad,Udescripcion,DOpreciou,DOtotal">
  <cfset etiquetas= "L&iacute;nea,Ref.,Tipo,C&oacute;digo,Descripci&oacute;n,Cantidad,Unidad Medida,Precio,Total">
  <cfset formatos= "V,V,V,V,V,M,V,V,M">
  <cfset posiciones= "left,center,left,left,left,right,center,right,right">

</cfif>


<!---Lista de Items--->
<cfquery name="rsListaItems" datasource="#session.dsn#">
	select 	a.DOlinea as Linea,
	        a.EOidorden,
			e.Ucodigo,
			#PreserveSingleQuotes(edit)# as editar,
			#PreserveSingleQuotes(eliminar)# as eliminar,
			Udescripcion,
			a.DOconsecutivo,
			case a.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' when 'P' then 'Obras' end as CMTipodesc,
			a.DOdescripcion,
			a.DOcantidad as  DOcantidad,
			#LvarOBJ_PrecioU.enSQL_AS("a.DOpreciou")#,
			a.DOtotal,
			case CMtipo when 'A' then e.Acodigo when 'F' then '-' when 'S' then f.Ccodigo when 'P' then 'P' end as Codigo, a.CPDDid,
			case
				when CTDContid is not null then 'Cont'
				else
					case
						when CPDDid is not null then 'Suf'
						when DSlinea is not null then 'SC'
					end
				end as ref
	from DOrdenCM a
		left outer join Articulos e
			on a.Aid = e.Aid

		left outer join Conceptos f
			on a.Cid = f.Cid

		<!----left outer join Unidades u
			on e.Ucodigo = u.Ucodigo
			and e.Ecodigo=u.Ecodigo----->
		left outer join Unidades u
			on a.Ucodigo = u.Ucodigo
			and a.Ecodigo=u.Ecodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
		and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EOidorden#">
		and a.CTDContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Contid#">
	Order by DOconsecutivo
</cfquery>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
        	<input type="hidden" name="CPDDid"  value="<cfif (modoDet EQ "CAMBIO")>#rsListaItems.CPDDid#</cfif>">
			<cfif isdefined("Request.OCRechazada.ModoRechazo") and Request.OCRechazada.ModoRechazo>
				<cfset action=Request.OCRechazada.Action>
			<cfelse>
				<cfset action="popUp-contrato-clas.cfm?Contid=#url.Contid#">
			</cfif>

			<cfset navegacion = "">
			<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden)) >
				<cfset navegacion = navegacion & "&EOidorden=#form.EOidorden#">
			</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				<cfinvokeargument name="query" value="#rsListaItems#">
				<cfinvokeargument name="desplegar" value="#campos#">
				<cfinvokeargument name="etiquetas" value="#etiquetas#">
				<cfinvokeargument name="formatos" value="#formatos#">
				<cfinvokeargument name="align" value="#posiciones#">
				<cfinvokeargument name="ajustar" value="N">
				<cfinvokeargument name="irA" value="#action#">
				<cfinvokeargument name="incluyeForm" value="false">
				<cfinvokeargument name="formName" value="form1">
				<cfinvokeargument name="funcion" value="ProcesarLinea">
				<cfinvokeargument name="fparams" value="Linea">
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	</tr>
</table>
<hr width="99%" align="center">

<!---Línea de Totales--->
<table width="99%"  border="0" cellspacing="0" cellpadding="0">
<cfoutput>
  <!--- <tr>
    <td>
	  <table align="right" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right"><strong>SubTotal:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_subtotal" name="subtotal" value="<cfif modo EQ "CAMBIO" >#LSCurrencyFormat(rsTotales.subtotal,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>

			<tr>
				<td align="right"><strong>Descuento:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_descuento" name="_descuento" value="<cfif modo EQ "CAMBIO">#LSCurrencyFormat(rsTotales.descuento,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>

			<tr>
				<td align="right"><strong>Impuesto:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_impuesto" name="_impuesto" value="<cfif modo EQ "CAMBIO">#LSCurrencyFormat(rsTotales.impuesto,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>

			<tr>
				<td><strong>Total Estimado:&nbsp;</strong></td>
				<td align="right">
					<input class="cajasinbordeb" type="text" style="text-align:right; " readonly id="_total" name="_total" value="<cfif modo EQ "CAMBIO">#LSCurrencyFormat(rsTotales.subtotal+rsTotales.impuesto-rsTotales.descuento,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>
	  </table>

			<!---
			<table align="right" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>SubTotal&nbsp;:&nbsp;</td>
					<td><div align="right">
					  <cfif (modo EQ "CAMBIO")>
					    #LSCurrencyFormat(rsTotales.subtotal,'none')#
					    <cfelse>
					    0.00
					    </cfif>
					  </div></td>
				</tr>

				<tr>
					<td>Impuesto&nbsp;:&nbsp;</td>
					<td><div align="right">
					  <cfif (modo EQ "CAMBIO")>
					    #LSCurrencyFormat(rsTotales.impuesto,'none')#
					    <cfelse>
					    0.00
					    </cfif>
					  </div></td>
				</tr>
				<tr>
					<td>Descuento&nbsp;:&nbsp;</td>
					<td><div align="right">
					  <cfif (modo EQ "CAMBIO")>
					    #LSCurrencyFormat(rsTotales.descuento,'none')#
					    <cfelse>
					    0.00
					    </cfif>
					  </div></td>
				</tr>

				<tr>
					<td><strong>Total&nbsp;:&nbsp;</strong></td>
					<td><div align="right"><strong>
					  <cfif (modo EQ "CAMBIO")>
					    #LSCurrencyFormat(rsTotales.total,'none')#
					    <cfelse>
					    0.00
					    </cfif>
					  </strong></div></td>
				</tr>
			</table>
			--->


	  </td>
  </tr> --->
	<script language='javascript' type='text/JavaScript' >
	<!--//
		function ProcesarLinea(Linea){
			document.form1.DOlinea.value=Linea;
			document.form1.action="#action#";
			document.form1.submit();
		}
			function EditarLinea(linea){
			var PARAM  = "ordenCompraLEdit.cfm?linea="+linea;
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=600,height=300');
		}
		function EliminarLinea(linea,orden){
		if ( confirm('¿Desea borrar esta línea del documento?') ) {
       		window.location = "ordenCompraLEdit-SQL.cfm?linea="+linea+"&orden="+orden+"&modo=BAJA";
		 }
		}
	//-->
	</script>
</cfoutput>
</table>