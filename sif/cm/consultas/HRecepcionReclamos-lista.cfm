<cf_templatecss>

<cfif isdefined("url.EOidorden") and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = Url.EOidorden>
</cfif>

<cfquery name="datosOrden" datasource="#session.dsn#">
	select 	a.EOidorden, a.Observaciones, a.EOfecha, a.EOtc, a.EOnumero, a.NAP, a.NRP, a.Impuesto,
			a.EOtotal, a.NAPcancel, a.EOdesc, 
			case when a.EOestado = 55 then 'Orden Cancelada Parcialmente Surtida'
				 when (a.EOestado = 10) and (select count(1) from DOrdenCM x where x.EOidorden = a.EOidorden and x.DOcantidad > x.DOcantsurtida) > 0 then 'Parcialmente Surtida'
				 else 'Surtida'
			end as Estado,
			c.Mnombre,
			d.CMCnombre, d.CMCcodigo,
			g.SNnumero, g.SNnombre,
			t.CMTOdescripcion
 		
	from EOrdenCM a
		inner join Monedas c
			on a.Mcodigo = c.Mcodigo
			and a.Ecodigo = c.Ecodigo

		inner join CMCompradores d
			on a.CMCid = d.CMCid
			and a.Ecodigo = d.Ecodigo

		inner join SNegocios g
			on a.SNcodigo = g.SNcodigo
			and a.Ecodigo = g.Ecodigo
			
		inner join CMTipoOrden t
			on a.Ecodigo = t.Ecodigo
			and a.CMTOcodigo = t.CMTOcodigo

	where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="datosRecepcion" datasource="#Session.DSN#">
	select a.EDRnumero, a.EDRreferencia, a.EDRfecharec, b.SNnombre 
	from HEDocumentosRecepcion a, SNegocios b, TipoDocumentoR c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	and a.Ecodigo = b.Ecodigo
	and a.SNcodigo = b.SNcodigo
	and a.Ecodigo = c.Ecodigo
	and a.TDRcodigo = c.TDRcodigo
	and c.TDRtipo = 'R'
</cfquery>

<cfquery name="datosDevolucion" datasource="#Session.DSN#">
	select a.EDRnumero, a.EDRreferencia, a.EDRfecharec, b.SNnombre 
	from HEDocumentosRecepcion a, SNegocios b, TipoDocumentoR c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	and a.Ecodigo = b.Ecodigo
	and a.SNcodigo = b.SNcodigo
	and a.Ecodigo = c.Ecodigo
	and a.TDRcodigo = c.TDRcodigo
	and c.TDRtipo = 'D'
</cfquery>

<cfquery name="datosReclamos" datasource="#Session.DSN#">
	select x.ERid, x.EDRnumero, x.EDRfecharec, b.SNnombre, c.CMCnombre, 
		   case x.ERestado when 0 then 'Sin Procesar' when 10 then 'En Proceso' when 20 then 'Concluído' else '' end as Estado
	from EReclamos x, HEDocumentosRecepcion a, SNegocios b, CMCompradores c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and x.Ecodigo = a.Ecodigo
	and x.EDRid = a.EDRid
	and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	and x.Ecodigo = b.Ecodigo
	and x.SNcodigorec = b.SNcodigo
	and x.Ecodigo = c.Ecodigo
	and x.CMCid = c.CMCid
</cfquery>

<script language="javascript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOidorden="+valor,10,10,1000,550);
	}
	
	function doConlisReclamo(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/Reclamos-vista.cfm?ERid="+valor,10,10,1000,550);
	}
</script>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
		<tr><td colspan="11" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td></tr>
		<tr><td colspan="11">&nbsp;</td></tr>
		<tr><td colspan="11" align="center"><b>Hist&oacute;rico de Recepci&oacute;n y Reclamos</b></td></tr>
		<tr><td colspan="11" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td></tr>
	</table>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td class="listaCorte"><strong>Datos de Orden de Compra</strong></td>
	    <td class="listaCorte" align="right">
			<cfif not isdefined("Url.imprimir")>
			<a href="javascript: doConlis('#form.EOidorden#');"><strong><font color="##FF0000">VER DATOS ORDEN >></font></strong></a>
			<cfelse>
			&nbsp;
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td colspan="2">
			<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td class="fileLabel" align="right">N&uacute;mero Orden:</td>
				<td>#datosOrden.EOnumero#</td>
				<td class="fileLabel" align="right">Fecha:</td>
				<td>#LSDateFormat(datosOrden.EOfecha, 'dd/mm/yyyy')#</td>
				<td class="fileLabel" align="right">Tipo de Orden:</td>
				<td>#datosOrden.CMTOdescripcion#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" align="right">Monto Total:</td>
				<td>#LSNumberFormat(datosOrden.EOtotal, ',9.00')#</td>
				<td class="fileLabel" align="right">Moneda:</td>
				<td>#datosOrden.Mnombre#</td>
				<td class="fileLabel" align="right">Proveedor:</td>
				<td>#datosOrden.SNnombre#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" align="right">Comprador:</td>
				<td colspan="3">#datosOrden.CMCnombre#</td>
				<td class="fileLabel" align="right">Estado:</td>
				<td>#datosOrden.Estado#</td>
			  </tr>
			  <tr>
				<td class="fileLabel" align="right">Observaciones:</td>
				<td colspan="5">#datosOrden.Observaciones#</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td colspan="2"><strong>Recepciones de Mercader&iacute;a</strong></td>
	  </tr>
	  <tr>
		<td colspan="2">
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#datosRecepcion#"/> 
				<cfinvokeargument name="desplegar" value="EDRnumero, EDRreferencia, EDRfecharec, SNnombre"/> 
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Referencia, Fecha, Proveedor"/> 
				<cfinvokeargument name="formatos" value="V,V,D,V"/> 
				<cfinvokeargument name="align" value="left,left,left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="formname" value="listaRecepcion"/> 
				<cfinvokeargument name="incluyeForm" value="false"/> 
				<cfinvokeargument name="maxrows" value="0"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
			</cfinvoke> 
		</td>
	  </tr>
	  <tr>
		<td colspan="2"><strong>Devoluciones de Mercader&iacute;a</strong></td>
	  </tr>
	  <tr>
		<td colspan="2">
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#datosDevolucion#"/> 
				<cfinvokeargument name="desplegar" value="EDRnumero, EDRreferencia, EDRfecharec, SNnombre"/> 
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Referencia, Fecha, Proveedor"/> 
				<cfinvokeargument name="formatos" value="V,V,D,V"/> 
				<cfinvokeargument name="align" value="left,left,left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="formname" value="listaRecepcion"/> 
				<cfinvokeargument name="incluyeForm" value="false"/> 
				<cfinvokeargument name="maxrows" value="0"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
			</cfinvoke> 
		</td>
	  </tr>
	  <tr>
		<td colspan="2"><strong>Reclamos</strong></td>
	  </tr>
	  <tr>
		<td colspan="2">
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#datosReclamos#"/> 
				<cfinvokeargument name="desplegar" value="EDRnumero, EDRfecharec, SNnombre, CMCnombre, Estado"/> 
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Fecha, Proveedor, Comprador, Estado"/> 
				<cfinvokeargument name="formatos" value="V,D,V,V,V"/> 
				<cfinvokeargument name="align" value="left,left,left,left,center"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="formname" value="listaRecepcion"/> 
				<cfinvokeargument name="incluyeForm" value="false"/> 
				<cfinvokeargument name="maxrows" value="0"/> 
				<cfinvokeargument name="funcion" value="doConlisReclamo"/> 
				<cfinvokeargument name="fparams" value="ERid"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke> 
		</td>
	  </tr>
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	</table>
</cfoutput>
