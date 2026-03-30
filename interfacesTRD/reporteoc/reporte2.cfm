<cf_PleaseWait SERVER_NAME="/cfmx/interfacesTRD/reporteoc/#archivo#" >
<cfsetting requesttimeout="3600"> 

<cfparam name="origen" default="cp">
<cfparam name="tipo"   default="pend">

<cfif not ListFind('cp,cc', origen)>
	<cfset origen = 'cc'>
</cfif>
<cfif not ListFind('pend,hist', tipo)>
	<cfset origen = 'pend'>
</cfif>

<cfif tipo is 'hist'>
	<cfparam name="periodo" type="numeric">
	<cfparam name="mes" type="numeric">
</cfif>

<cfif origen is 'cc'>
	<cfset title = "Ventas por Orden Comercial">
	<cfset filename = "VentasOC">
<cfelse>
	<cfset title = "Compras por Orden Comercial">
	<cfset filename = "ComprasOC">
</cfif>


<cf_htmlreportsheaders
title="#title#" 
filename="#filename#-#Session.Usucodigo#.xls" 
ira="#archivo#">

<cf_templatecss>



<cfquery datasource="#session.dsn#">

	set rowcount 0
	
	if object_id('##PASO') is not null
		drop table ##PASO
		
		
		
	<!---
create table ##PASO (
  OCid numeric null,
  CCTcodigo char(2) not null,
  Ddocumento char(20) not null,
  SNcodigo int null,
  SNnombre varchar(255) not null,
  SNidentificacion char(30) not null,
  Dtotal money not null,
  DDdescripcion varchar(255) null,
  DDcantidad float null,
  DDtotallinea money not null,
  Dfecha datetime not null,
  BMperiodo int not null,
  BMmes int not null,
  OCcontrato varchar(20) not null,
  OCTtransporte char(20) not null,
  OCVid numeric not null,
  OCVdescripcion varchar(40) not null,
  Cconcepto int not null,
  Edocumento int not null,
  IDcontable int not null
)

	--->
</cfquery>
<cfif origen is 'cc' and tipo is 'hist'>
	<!--- hist CC (ventas) --->
	<cfquery datasource="#session.dsn#">
		select distinct b.OCid,
			a.CCTcodigo,a.Ddocumento,a.SNcodigo,SNnombre,SNidentificacion,
			case when tt.CCTtipo='C' then - a.Dtotal else a.Dtotal end Dtotal,
			
			b.DDescripcion as DDdescripcion ,b.DDcantidad,
			case when tt.CCTtipo='C' then - b.DDtotal else b.DDtotal end as DDtotallinea,
			
			a.Dfecha ,BMperiodo,BMmes,OCcontrato,OCTtransporte,f.OCVid,OCVdescripcion,
			convert(int,0) as Cconcepto, 0 Edocumento, IDcontable, m.Miso4217
		into ##PASO
		from HDocumentos a
			join CCTransacciones tt
				on tt.CCTcodigo = a.CCTcodigo
			join Monedas m
				on m.Ecodigo = a.Ecodigo
				and m.Mcodigo = a.Mcodigo,
			HDDocumentos b,BMovimientos c,
			OCordenComercial d,OCtransporte e,OCtipoVenta f,SNegocios g
		where a.Ecodigo = #session.Ecodigo#
		and a.HDid=b.HDid
		and DDtipo='O'
		and c.DRdocumento=a.Ddocumento
		and c.CCTRcodigo=a.CCTcodigo
		and c.SNcodigo=a.SNcodigo
		and d.OCid=b.OCid
		and e.OCTid=b.OCTid
		and f.OCVid=d.OCVid
		and a.SNcodigo=g.SNcodigo
		and c.BMperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
		and c.BMmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
		and exists (select 1 from HEContables z where z.IDcontable = c.IDcontable and Oorigen like 'CCFC')
	</cfquery>
<cfelseif origen is 'cp' and tipo is 'hist'>
	<!--- hist CP (compras) --->
	<cfquery datasource="#session.dsn#">
		select distinct b.OCid,
			a.CPTcodigo as CCTcodigo,a.Ddocumento,a.SNcodigo,SNnombre,SNidentificacion,
			
			case when tt.CPTtipo='D' then - a.Dtotal else a.Dtotal end Dtotal,
		
			b.DDescripcion as DDdescripcion ,b.DDcantidad,
			case when tt.CPTtipo='D' then - b.DDtotallin else b.DDtotallin end as DDtotallinea,
			
			a.Dfecha ,BMperiodo,BMmes,OCcontrato,OCTtransporte,0 OCVid,
			convert(int,0) as Cconcepto, 0 Edocumento, IDcontable, m.Miso4217
		into ##PASO
		from HEDocumentosCP a
			join CPTransacciones tt
				on tt.CPTcodigo = a.CPTcodigo
			join Monedas m
				on m.Ecodigo = a.Ecodigo
				and m.Mcodigo = a.Mcodigo,
			HDDocumentosCP b, BMovimientosCxP c,
			OCordenComercial d,OCtransporte e,SNegocios g
		where a.Ecodigo = #session.Ecodigo#
		and a.IDdocumento=b.IDdocumento
		and DDtipo='O'
		and c.DRdocumento=a.Ddocumento
		and c.CPTRcodigo=a.CPTcodigo
		and c.SNcodigo=a.SNcodigo
		and d.OCid=b.OCid
		and e.OCTid=b.OCTid
		and a.SNcodigo=g.SNcodigo
		and c.BMperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
		and c.BMmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
		and exists (select 1 from HEContables z where z.IDcontable = c.IDcontable and Oorigen like 'CPFC')
			 
	</cfquery>
<cfelseif origen is 'cc' and tipo is 'pend'>
	<!--- pend CC (ventas) --->
	<cfquery datasource="#session.dsn#">
		select distinct b.OCid,
			a.CCTcodigo,a.EDdocumento Ddocumento,a.SNcodigo,SNnombre,SNidentificacion,
			case when tt.CCTtipo='C' then - a.EDtotal else a.EDtotal end Dtotal,
			
			b.DDdescripcion,b.DDcantidad,
			case when tt.CCTtipo='C' then - b.DDtotallinea else b.DDtotallinea end DDtotallinea,
			
			a.EDfecha Dfecha,OCcontrato,OCTtransporte,f.OCVid,OCVdescripcion, m.Miso4217
		into ##PASO
		from EDocumentosCxC a
			join CCTransacciones tt
				on tt.CCTcodigo = a.CCTcodigo
			join Monedas m
				on m.Ecodigo = a.Ecodigo
				and m.Mcodigo = a.Mcodigo,
			DDocumentosCxC b, OCordenComercial d,
			OCtransporte e,OCtipoVenta f,SNegocios g
		where a.Ecodigo = #session.Ecodigo#
		and a.EDid=b.EDid
		and DDtipo='O'
		and d.OCid=b.OCid
		and e.OCTid=b.OCTid
		and f.OCVid=d.OCVid
		and a.SNcodigo=g.SNcodigo
	</cfquery>
<cfelseif origen is 'cp' and tipo is 'pend'>
	<!--- pend CP (compras) --->
	<cfquery datasource="#session.dsn#">
		select distinct b.OCid,
			a.CPTcodigo as CCTcodigo,a.EDdocumento Ddocumento,a.SNcodigo,SNnombre,SNidentificacion,
			case when tt.CPTtipo='D' then - a.EDtotal else a.EDtotal end Dtotal,
			
			b.DDdescripcion,b.DDcantidad,
			case when tt.CPTtipo='D' then - b.DDtotallinea else b.DDtotallinea end DDtotallinea,
			
			a.EDfecha Dfecha,OCcontrato,OCTtransporte,0 OCVid, m.Miso4217
		into ##PASO
		from EDocumentosCxP a
			join CPTransacciones tt
				on tt.CPTcodigo = a.CPTcodigo
			join Monedas m
				on m.Ecodigo = a.Ecodigo
				and m.Mcodigo = a.Mcodigo,
			DDocumentosCxP b, OCordenComercial d,
			SNegocios g
		where a.Ecodigo = #session.Ecodigo#
		and a.IDdocumento=b.IDdocumento
		and DDtipo='O'
		and d.OCid=b.OCid
		and a.SNcodigo=g.SNcodigo
	</cfquery>
<cfelse>
	<cfthrow message="Query no definido para tipo #tipo# y origen #origen#">
</cfif>


<cfif tipo is 'hist'>
	<cfquery datasource="#session.dsn#" name="datos">
		alter table ##PASO add Cdescripcion varchar(50) NULL
	</cfquery>
	<cfquery datasource="#session.dsn#" name="datos">
		update ##PASO
			set Cconcepto=a.Cconcepto,
				Edocumento=a.Edocumento
			from HEContables a,##PASO b
		where a.IDcontable=b.IDcontable
	</cfquery>
	<cfquery datasource="#session.dsn#" name="datos">
		update ##PASO set Cdescripcion = ce.Cdescripcion
		from ConceptoContableE ce
		where ce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ce.Cconcepto = ##PASO.Cconcepto
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="datos">
	select p.*
	from ##PASO p
	order by 
		<cfif origen is 'cc'>p.OCVdescripcion, p.OCVid, </cfif>
	p.OCid, p.CCTcodigo, p.Ddocumento
</cfquery>
<cfquery datasource="#session.dsn#">
	drop table ##PASO
</cfquery>

<style type="text/css">
td { overflow:hidden; }
</style>
<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
<tr>
	<td colspan="10" align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
</tr>					
<tr>
	<td style="font-size:16px" align="center" colspan="10">
	<strong>#session.Enombre#</strong>	
	</td>
</tr>
<tr>
	<td style="font-size:16px" align="center" colspan="10">
	<strong>#title#</strong>
	</td>
</tr>
<tr>
	<td style="font-size:16px" align="center" colspan="10">
<cfif tipo is 'hist'>

	<cfquery name="mes" datasource="#session.dsn#">
		select VSdesc as NombreMes
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSgrupo = 1
		where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
		  and b.VSvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mes#">
	</cfquery>

	<strong># HTMLEditFormat( mes.NombreMes )# - #HTMLEditFormat( periodo )#</strong>
<cfelse>
	<strong>Documentos pendientes</strong>
</cfif>
	</td>
</tr>
<tr>
	<td colspan="10">&nbsp;</td>
</tr>
</table>
</cfoutput>

<!--- El flush no debe ir antes, para que quede esperando en cf_pleasewait y no acá
<cfflush interval="512"> --->

<cfset total_general = 0>
<table width="100%" border="0" cellpadding="2" cellspacing="0" >
<cfoutput query="datos" group="OCVid">
<cfset total_ocv = 0>
<cfoutput group="OCid">
<cfset total_orden = 0>
  <tr>
    <td colspan="3"><strong>Orden</strong></td>
    <td colspan="3"><strong>Contrato</strong></td>
    <td><strong>Transporte</strong></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>#HTMLEditFormat(OCid)#</td>
    <td colspan="2"><cfif origen is 'cc'>#HTMLEditFormat(OCVdescripcion)#<cfelse>&nbsp;</cfif></td>
    <td colspan="3" align="left" nowrap="nowrap">#HTMLEditFormat(OCcontrato)#</td>
    <td>#HTMLEditFormat(OCTtransporte)#</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
<!---
</table>
<table width="100%" border="0" cellpadding="2" cellspacing="0" >
--->
  <cfoutput group="CCTcodigo">
  <cfoutput group="Ddocumento">
  <tr>
    <td>&nbsp;</td>
    <td style="background-color:##ededed"><strong>Trans.</strong></td>
    <td style="background-color:##ededed"><strong>Documento</strong></td>
    <td colspan="2" style="background-color:##ededed"><strong>Socio</strong></td>
    <td style="background-color:##ededed"><strong>Identif.</strong></td>
    <td align="left" style="background-color:##ededed"><strong>Fecha</strong></td>
    <td align="right" style="background-color:##ededed"><strong>Total</strong></td>
    <td align="right" style="background-color:##ededed"><cfif tipo is 'hist'><strong>Concepto</strong></cfif></td>
    <td align="right" style="background-color:##ededed"><cfif tipo is 'hist'><strong>Póliza </strong>
    </cfif></td>
    </tr>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">#HTMLEditFormat(CCTcodigo)#</td>
    <td align="left" nowrap="nowrap">#HTMLEditFormat(Ddocumento)#</td>
    <td align="left" nowrap="nowrap">#HTMLEditFormat(SNcodigo)#</td>
    <td align="left" nowrap="nowrap">#HTMLEditFormat(SNnombre)#</td>
    <td align="left" nowrap="nowrap"> #HTMLEditFormat(SNidentificacion)# </td>
    <td align="left" nowrap="nowrap"><cfif Len(Dfecha)>
      #DateFormat(Dfecha,'dd/mm/yyyy')#
          <cfelse>
      &nbsp;
    </cfif></td>
    <td align="right" nowrap="nowrap"><cfif Len(Dtotal)>
       
		<cfset total_general = total_general + Dtotal>
		<cfset total_ocv     = total_ocv     + Dtotal>
		<cfset total_orden   = total_orden   + Dtotal>
      #NumberFormat(Dtotal,',0.00')#
            <cfelse>
      &nbsp;
    </cfif></td>
    <td align="right" nowrap="nowrap"><cfif tipo is 'hist'>#HTMLEditFormat(Cdescripcion)#</cfif></td>
    <td align="right" nowrap="nowrap"><cfif tipo is 'hist'>#HTMLEditFormat(Edocumento)#</cfif></td>
    </tr>
  
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="3" align="left" nowrap="nowrap"><strong>Artículo</strong></td>
    <td align="right" nowrap="nowrap"><strong>Cantidad</strong></td>
    <td align="right" nowrap="nowrap"><strong>Importe</strong></td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr>
  <cfoutput>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="3" align="left" nowrap="nowrap">#HTMLEditFormat(DDdescripcion)#</td>
    <td align="right" nowrap="nowrap"><cfif Len(DDcantidad)>
      #NumberFormat(DDcantidad)#
          <cfelse>
      &nbsp;
    </cfif></td>
    <td align="right" nowrap="nowrap"><cfif Len(DDtotallinea)>#NumberFormat(DDtotallinea,',0.00')#
      <cfelse>
      &nbsp;
    </cfif></td>
    <td align="left" nowrap="nowrap"><cfif Len(Dtotal)>
      #HTMLEditFormat(Miso4217)#
          <cfelse>
      &nbsp;
    </cfif></td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr>
  </cfoutput>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="3" align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr>
  </cfoutput>
  </cfoutput>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="4" align="left" nowrap="nowrap" style="border-bottom:1px solid black"><em><strong>Total de la orden #HTMLEditFormat(OCid)# <cfif origen is 'cc'>#HTMLEditFormat(OCVdescripcion)#</cfif>
      #HTMLEditFormat(OCcontrato)#</strong></em></td>
    <td align="right" nowrap="nowrap" style="border-bottom:1px solid black"><strong>#NumberFormat(total_orden,',0.00')#  </strong></td>
    <td align="left" nowrap="nowrap">
      <strong>#HTMLEditFormat(Miso4217)#</strong></td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
  </tr>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="3" align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr></cfoutput>
	<cfif origen is 'cc'>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="4" align="left" nowrap="nowrap" style="border-bottom:3px double black"><em><strong>Total del tipo de venta #HTMLEditFormat(OCVdescripcion)#</strong></em></td>
    <td align="right" nowrap="nowrap" style="border-bottom:3px double black"><strong>#NumberFormat(total_ocv,',0.00')#  </strong></td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
  </tr></cfif>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="3" align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr></cfoutput><cfoutput>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="3" align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr>
	<cfif datos.RecordCount is 0 >
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="4" align="left" nowrap="nowrap" style="border-bottom:3px double black"><em><strong>No hay datos</strong></em></td>
    <td align="right" nowrap="nowrap" style="border-bottom:3px double black"><strong></strong></td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr><cfelse>
  <tr>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td colspan="4" align="left" nowrap="nowrap" style="border-bottom:3px double black"><em><strong>Total general </strong></em></td>
    <td align="right" nowrap="nowrap" style="border-bottom:3px double black"><strong>#NumberFormat(total_general,',0.00')#</strong></td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    <td align="left" nowrap="nowrap">&nbsp;</td>
    </tr>
  <tr>
    <td colspan="10" align="left" nowrap="nowrap">&nbsp;</td>
    </tr>
	</cfif></cfoutput>
</table>


</body>
</html>
