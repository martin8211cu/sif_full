<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">
<cfquery name="qryLista" datasource="#session.dsn#">
select hedr.EDRnumero, hedr.EDRfechadoc, hedr.EDRfecharec, hedr.EOidorden, hedr.SNcodigo, hedr.EDRreferencia, 
	sn.SNnumero , sn.SNnombre, m.Mnombre,
	 (case when hedr.CFid is null then coalesce(alm.Bdescripcion,'') 
	  else coalesce(cf.CFdescripcion,'')
	end ) as CFdescripcion ,
	(case when hedr.CFid is null then coalesce(2,null) 
	  else coalesce(1,null)
	end ) as tipoCF ,
	alm.Bdescripcion,
	(case when hddr.Cid is null then coalesce(art.Adescripcion,'') 
	  else coalesce(con.Cdescripcion,'')
	end ) as DescTipoItem ,
	art.Acodigo,
	(case when hddr.Cid is null then coalesce(u.Udescripcion,'') 
	  else 'N/A' end ) as Umedida,
	(select sum(hddr1.DDRtotallin) from HDDocumentosRecepcion hddr1 
					where  hddr1.Ecodigo = hddr.Ecodigo
					  and hddr1.EDRid = hddr.EDRid
					   ) as montoRec,
	   edr.CPTcodigo #_Cat# '-' #_Cat# cpt.CPTdescripcion as TipoDoc, 
	   hedr.EDRid, hedr.EDRobs , hedr.EDRtc,  hedr.EDRimppro,
	   hedr.EDRdescpro,
	   hddr.DDRlinea ,hddr.Ecodigo, hddr.EDRid , hddr.DOlinea, hddr.Usucodigo, hddr.fechaalta, hddr.Aid, hddr.Cid, hddr.DDRtipoitem, hddr.DDRcantrec ,
	   hddr.DDRcantorigen,
	   #LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#, 
	   hddr.DDRdesclinea, hddr.DDRtotallin, hddr.DDRcostopro, hddr.DDRcostototal, hddr.ts_rversion, hddr.BMUsucodigo
  	  ,docm.Icodigo, docm.DOdescripcion,  docm.EOnumero, imp.Idescripcion
	 , er.fechaalta, er.ERobs
	from 
	HEDocumentosRecepcion hedr

		inner join HDDocumentosRecepcion hddr
		  on hedr.Ecodigo = hddr.Ecodigo
		  and hedr.EDRid = hddr.EDRid

		inner join SNegocios sn
		  on  hedr.Ecodigo = sn.Ecodigo
		  and hedr.SNcodigo = sn.SNcodigo

		inner join Monedas m
		  on hedr.Ecodigo = m.Ecodigo
		  and hedr.Mcodigo = m.Mcodigo
		  
	  inner join EDocumentosRecepcion edr
		on hedr.Ecodigo =  edr.Ecodigo
		  and hedr.EDRid =  edr.EDRid
		  
	  inner join CPTransacciones cpt
		  on edr.Ecodigo = cpt.Ecodigo
		  and edr.CPTcodigo = cpt.CPTcodigo
		  
	  inner join TipoDocumentoR tdr
	      on edr.TDRcodigo = tdr.TDRcodigo
		  and edr.Ecodigo = tdr.Ecodigo
		  
		left outer join CFuncional cf
		  on hedr.Ecodigo =  cf.Ecodigo
		  and hedr.CFid = cf.CFid	
		  
		left outer join Almacen alm
		  on hedr.Aid = alm.Aid
		  and hedr.Ecodigo = alm.Ecodigo
		  
		left outer join Articulos art
		  on hddr.Aid = art.Aid
		  and hddr.Ecodigo = art.Ecodigo
		
		left outer join  Unidades u
		  on  u.Ucodigo = art.Ucodigo
		  and u.Ecodigo = art.Ecodigo
		
		left outer join Conceptos con
		  on hddr.Cid = con.Cid
		  and hddr.Ecodigo = con.Ecodigo
		
		inner join DOrdenCM docm
		  on hddr.DOlinea=docm.DOlinea
		  
		  <!-----*/-*/-*/-*/-*/-*/-*/-/----->
		  left outer join AClasificacion ac
		  	on docm.ACid  = ac.ACid
			and docm.ACcodigo = ac.ACodigo
			and docm.Ecodigo = ac.Ecodigo 
		  <!-----*/-*/-*/-*/-*/-*/-*/-/----->
		inner join EOrdenCM eocm
		on docm.EOidorden=eocm.EOidorden
		
		inner join Impuestos imp
		  on docm.Icodigo = imp.Icodigo
	 	  and docm.Ecodigo = imp.Ecodigo
		 
		 left outer join EReclamos er
		  on hddr.EDRid = er.EDRid
		  and hddr.Ecodigo = er.Ecodigo
			
		 left outer join DReclamos dr
		  on dr.ERid = er.ERid
		  and dr.Ecodigo = er.Ecodigo
		  and hddr.DDRlinea = dr.DDRlinea
		  
	where hedr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and (isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))) >
		<cfif form.fEDRnumeroD  GT form.fEDRnumeroH>
			and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
			and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelseif form.fEDRnumeroD EQ form.fEDRnumeroH>
			and hedr.EDRnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelse>
				and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
				and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
		</cfif>
	</cfif>
	<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and not (isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))) >
			and hedr.EDRnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
	</cfif>
	<cfif isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH)) and not (isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD))) >
			and hedr.EDRnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
	</cfif>
	
	<cfif isdefined("form.fEOnumeroD") and len(trim(form.fEOnumeroD)) and (isdefined("form.fEOnumeroH") and len(trim(form.fEOnumeroH))) >
		<cfif form.fEOnumeroD  GT form.fEOnumeroH>
			and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumeroD#">
			and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumeroH#">
		<cfelseif form.fEOnumeroD EQ form.fEOnumeroH>
			and docm.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumeroD#">
		<cfelse>
				and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumeroD#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumeroH#">
		</cfif>
	</cfif>
	<cfif isdefined("form.fEOnumeroD") and len(trim(form.fEOnumeroD)) and not (isdefined("form.fEOnumeroH") and len(trim(form.fEOnumeroH))) >
			and docm.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumeroD#">
	</cfif>
	<cfif isdefined("form.fEOnumeroH") and len(trim(form.fEOnumeroH)) and not (isdefined("form.fEOnumeroD") and len(trim(form.fEOnumeroD))) >
			and docm.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumeroH#">
	</cfif>
	<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
		<cfif form.fechaD EQ form.fechaH>
			and a.ESfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
		<cfelse>
			and a.ESfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
		</cfif>
	</cfif>
	<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and not ( isdefined("Form.fechaH") and len(trim(Form.fechaH)) )>
		and a.ESfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
		<!---and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsMayorFecha.fechaMayor)#">--->
	</cfif>
	<cfif isdefined("Form.fechaH") and len(trim(Form.fechaH)) and not ( isdefined("Form.fechaD") and len(trim(Form.fechaD)) )>
		and a.ESfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
		<!---and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsMayorFecha.fechaMayor)#">--->
	</cfif>
	<cfif isdefined("Form.fTDRtipo") and Form.fTDRtipo  NEQ 'T'>
	    and edr.TDRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fTDRtipo#">
	</cfif>


	order by EDRnumero
</cfquery>

<cfinclude template="AREA_HEADER.cfm"><br>
<cfoutput query="qryLista" group="EDRid"> 

<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="4" class="tituloIndicacion"><strong>Datos de la Recepci&oacute;n de Mercader&iacute;a </strong></td>
	</tr>
  <tr>
		<td valign="top"><strong>N&uacute;mero de Recepci&oacute;n &nbsp;:&nbsp;</strong></td>
		<td valign="top">#EDRnumero#</td>
		<td valign="top"><strong>N&uacute;mero Referencia &nbsp;:&nbsp;</strong></td>
		<td valign="top">#EDRreferencia#</td>
  </tr>
  <tr>
		<td valign="top"><strong>Fecha de la Recepci&oacute;n:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(EDRfecharec,'dd/mm/yyyy')#</td>
		<td valign="top"><strong>Proveedor&nbsp;:&nbsp;</strong></td>
		<td valign="top">#SNnumero# - #SNnombre#</td>
  </tr>
 	<tr>
		<td valign="top"><strong>Observaciones&nbsp;:&nbsp;</strong></td>
		<td valign="top">#EDRobs#</td>
		<td valign="top"><strong>Moneda&nbsp;:&nbsp;</strong></td>
		<td valign="top">#Mnombre#</td>
  </tr>
 	<tr>
      <td valign="top"><strong><cfif tipoCF EQ 1>Almac&eacute;n&nbsp;:&nbsp;<cfelse>Centro Funcional&nbsp;:&nbsp;</cfif></strong></td>
      <td valign="top">#CFdescripcion#</td>
      <td valign="top"><strong>Tipo de Cambio&nbsp;:&nbsp;</strong></td>
      <td valign="top">#LSCurrencyFormat(EDRtc,'none')#</td>
    </tr>
	
	<tr>
	  <td valign="top"><strong>Tipo Documento :&nbsp;</strong></td>
	  <td>#TipoDoc#</td>
	  <td valign="top"><strong>Monto Descuento&nbsp;:&nbsp;</strong></td>
	  <td>#LSCurrencyFormat(EDRdescpro,'none')#</td>
	</tr>
	<tr>
	  <td valign="top"><strong>Monto de Impuesto&nbsp;:&nbsp;</strong></td>
	  <td>#LSCurrencyFormat(EDRimppro,'none')#</td>
	  <td valign="top"><strong>Total del Documento &nbsp;:&nbsp;</strong></td>
	  <td>
        <cfset totalDoc = montoRec + EDRdescpro + EDRimppro>
  #LSCurrencyFormat(totalDoc,'none')# </td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4" class="tituloIndicacion" style="border-bottom: 1px solid black;" ><strong>Detalles de la Recepci&oacute;n de Mercadería</strong></td>
	</tr>
</table>
<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td nowrap class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black;">Descripci&oacute;n</td>
		<cfif not isdefined("url.imprimir")>
			<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Num. Orden </td>
		    <td nowrap width="5%" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">L&iacute;nea</td>
		    <td nowrap width="5%" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">C&oacute;digo</td>
	    </cfif>	
		<td nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cant.Orden</td>
		<td nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Unidad Orden </td>
		<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Cantidad Recibida </td>
		<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">UM Recibida</td>
		<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Saldo UM </td> 
		<td nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Total por Línea</td>
		<td nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">N&uacute;mero Reclamo </td>		
	</tr>
	<cfif qryLista.RecordCount eq 1 and len(qryLista.DSlinea) eq 0>
	<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
		<td colspan="13" style="padding-right: 5px; border-bottom: 1px solid black; text-align:center">&nbsp;-- No hay detalles en la Recepci&oacute;n de Mercader&iacute;a --&nbsp;</td>
	</tr>
	<cfelse>

	<cfoutput>
	<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
		<td nowrap style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#trim(DOdescripcion)#&nbsp;</td>
		<!---<td>#EDRobs#</td>--->
		<cfif not isdefined("url.imprimir")>
			<td align="right" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">#EOnumero#</div></td>
		    <td width="5%" align="right" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">#DOlinea#</div></td>
		    <td width="5%" align="right" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">
		      <cfif len(trim(Aid)) NEQ 0>
		        #Acodigo#
		        <cfelseif len(trim(Cid))>
		        #Cid#
		        </cfif>
	        </div></td>
	      </cfif>
		<td nowrap align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;
		  <div align="right">#DDRcantorigen#&nbsp;</div></td> 
		<td nowrap align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;&nbsp;
		  <div align="right">#Umedida#</div></td>
		<td align="right" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;
		  <div align="right">#DDRcantrec#&nbsp;</div></td>
		<td align="right" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">&nbsp;</div></td>
		<td align="right" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;&nbsp;
		  <div align="right"></div></td> 
		<td nowrap align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">#LSCurrencyFormat(DDRtotallin,'none')#</div></td>
		<td nowrap align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;&nbsp;
		  <div align="right"></div></td>
	</tr>
	</cfoutput>
	</cfif>
</table>
<table width="108%" align="center"  border="0" cellspacing="2" cellpadding="2" style="border-top:1px solid black; ">
	<cfquery name="rsTotales" datasource="#session.DSN#">
		select coalesce(sum((Iporcentaje*DDRtotallin)/100),0) as impuesto, coalesce(sum(DDRcantrec*DDRpreciou),0) as subtotal
		from HEDocumentosRecepcion hedr
		inner join HDDocumentosRecepcion hddr
		  on hedr.Ecodigo = hddr.Ecodigo
		  and hedr.EDRid = hddr.EDRid
		
		inner join DOrdenCM docm
		  on hddr.DOlinea=docm.DOlinea

		inner join EOrdenCM eocm
		on docm.EOidorden=eocm.EOidorden

		inner join Impuestos imp
		  on docm.Icodigo = imp.Icodigo
	 	  and docm.Ecodigo = imp.Ecodigo
	where hedr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and hedr.EDRid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista.EDRid#">

	</cfquery>
	
	<tr>
		<td width="78%">&nbsp;</td>
		<td width="9%" align="right" ><strong>Subtotal&nbsp;:&nbsp;</strong></td>
		<td width="13%" align="right">#LSCurrencyFormat(rsTotales.subtotal,'none')#</td>
	</tr>
	<tr>
	  <td width="78%">&nbsp;</td>
		<td align="right" ><strong>Impuestos&nbsp;:&nbsp;</strong></td>
		<td align="right">#LSCurrencyFormat(rsTotales.impuesto,'none')#</td>
	</tr>
	<tr>
		<td rowspan="2" width="78%">&nbsp;</td>
		<td align="right"><div align="right"><strong>Total&nbsp;:&nbsp;</strong></div></td>
		<td align="right"><strong>#LSCurrencyFormat(rsTotales.subtotal+rsTotales.impuesto,'none')#</strong></td>
	</tr>
</table>  
</cfoutput>
