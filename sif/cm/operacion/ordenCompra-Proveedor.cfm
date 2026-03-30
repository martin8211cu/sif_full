<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.EOidorden") and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = Url.EOidorden>
</cfif>

<cfquery name="qryLista" datasource="#session.dsn#">
	select 	a.EOidorden, a.Observaciones, a.EOfecha, a.EOtc, a.EOnumero, a.NAP, a.NRP, a.Impuesto,
			a.EOtotal, a.NAPcancel, a.EOdesc, a.EOestado, a.EOjustificacion,
			b.DOdescripcion, b.DOcantidad, b.DOcantsurtida, b.DOfechareq, b.DOtotal, 
			#LvarOBJ_PrecioU.enSQL_AS("b.DOpreciou")#, 
			b.Icodigo, b.DOlinea,
			c.Mnombre,
			d.CMCnombre, d.CMCcodigo,
			e.Ucodigo,
			f.CFcodigo, f.CFdescripcion,
			g.SNnumero, g.SNnombre,
			h.Bdescripcion, h.Almcodigo,
			i.Iporcentaje, 
			a.ETidtracking, 
			j.CMTgeneratracking,
			k.CMFPcodigo,
			k.CMFPdescripcion,
			l.CMIcodigo,
			l.CMIdescripcion

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
			
		left outer  join DOrdenCM b
		on a.EOidorden = b.EOidorden
			and a.Ecodigo = b.Ecodigo

		inner join Unidades e
			on b.Ucodigo = e.Ucodigo
			and b.Ecodigo = e.Ecodigo

		inner join Impuestos i
			on b.Icodigo = i.Icodigo
			and b.Ecodigo = i.Ecodigo
			
		inner join CFuncional f
			on  b.CFid = f.CFid
			and b.Ecodigo = f.Ecodigo
		
		left outer join Almacen h
			on b.Alm_Aid = h.Aid
			and b.Ecodigo = h.Ecodigo
			
		inner join CMTipoOrden j
		on a.CMTOcodigo=j.CMTOcodigo
			and a.Ecodigo=j.Ecodigo

		left outer join CMFormasPago k
		on a.Ecodigo = k.Ecodigo
		and a.CMFPid = k.CMFPid

		left outer join CMIncoterm l
		on a.Ecodigo = l.Ecodigo
		and a.CMIid = l.CMIid

	where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfoutput query="qryLista" group="EOidorden"> <br>
    <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td colspan="6" class="tituloListas"><strong>Datos de la Orden de Compra</strong></td>
      </tr>
    <td>&nbsp;</td>
    <tr>
      <td align="right" nowrap><strong>N&uacute;mero de Orden:</strong></td>
      <td nowrap>#EOnumero#</td>
      <td align="right" nowrap><strong>Fecha de la Orden:</strong></td>
      <td nowrap>#LSDateFormat(EOfecha,'dd/mm/yyy')#</td>
      <td align="right" nowrap><strong>Moneda:</strong></td>
      <td nowrap>#Mnombre#</td>
    </tr>
    <tr>
      <td align="right" nowrap><strong>Comprador:</strong></td>
      <td nowrap>#CMCcodigo# - #CMCnombre#</td>
      <td align="right" nowrap><strong>Forma de Pago:</strong></td>
      <td nowrap>
	  	<cfif Len(Trim(CMFPcodigo))>
			#CMFPcodigo# - #CMFPdescripcion#
		<cfelse>
			&nbsp;
		</cfif>
	  </td>
      <td align="right" nowrap><strong>Incoterm:</strong></td>
      <td nowrap>
	  	<cfif Len(Trim(CMIcodigo))>
			#CMIcodigo# - #CMIdescripcion#
		<cfelse>
			&nbsp;
		</cfif>
	  </td>
    </tr>
    <tr>
      <td align="right" nowrap><strong>Proveedor:</strong></td>
      <td nowrap>#SNnumero# - #SNnombre#</td>
      <cfif qryLista.CMTgeneratracking eq 1 >
        <td align="right" nowrap><strong>Control de Seguimiento:</strong></td>
        <td>
          <cfif len(trim(qryLista.ETidtracking)) >
		  	<cftransaction action="commit">
            <cfquery name="rsTracking" datasource="sifpublica">
				select ETnumtracking, ETconsecutivo from ETracking 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista.ETidtracking#">
            </cfquery>
            #rsTracking.ETconsecutivo#
          <cfelse>
            N/A
          </cfif>
        </td>
     <cfelse>
        <td nowrap>&nbsp;</td>
        <td nowrap>&nbsp;</td>
      </cfif>
		<td align="right" nowrap>&nbsp;</td>
		<td nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td align="right" nowrap><strong>Observaciones:</strong></td>
      <td colspan="5">#Observaciones#</td>
    </tr>
    <tr>
      <td colspan="6">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="6"  style="padding-right: 5px; border-bottom: 1px solid black; " ><strong>Detalles de la Orden de Compra</strong></td>
    </tr>
    </table>
    <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td width="40%" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">&Iacute;tem</td>
        <td width="5%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Ctro Funcional</td>
        <td width="5%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Almac&eacute;n</td>
        <td width="5%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Fecha Req.</td>
        <td width="2%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Unidad</td>
        <td width="2%" nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cant.</td>
        <td width="5%" nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Precio Unit.</td>
        <td width="2%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Impuesto</td>
        <td align="right" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Total l&iacute;nea</td>
      </tr>
      <cfif qryLista.RecordCount eq 1 and len(qryLista.DOlinea) eq 0>
        <tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
          <td  align="center" colspan="9" style="padding-right: 5px; border-bottom: 1px solid black; text-align:center">&nbsp;-- No hay detalles en la Solicitud de Compra --&nbsp;</td>
        </tr>
        <cfelse>
        <cfoutput>
          <tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
            <td width="40%" style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#trim(DOdescripcion)#&nbsp;</td>
            <td width="20%" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#CFdescripcion#&nbsp;</td>
            <td width="5%" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Almcodigo#&nbsp;</td>
            <td width="5%" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSDateFormat(DOfechareq,'dd/mm/yyy')#&nbsp;</td>
            <td width="2%" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#trim(Ucodigo)#&nbsp;</td>
            <td width="2%" nowrap align="center" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DOcantidad#&nbsp;</td>
            <td width="5%" nowrap align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LvarOBJ_PrecioU.enCF_RPT(DOpreciou)#&nbsp;</td>
            <td width="2%" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Icodigo# (#Iporcentaje#%)&nbsp;</td>
            <td align="right" nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(DOtotal,'none')#&nbsp;</td>
          </tr>
        </cfoutput>
      </cfif>
    </table>
    <table width="99%" align="center"  border="0" cellspacing="2" cellpadding="2" style="border-top:1px solid black; ">
	<cftransaction action="commit">
      <cfquery name="rsTotales" datasource="#session.DSN#">
    	select coalesce(sum(b.DOtotal),0) as Subtotal 
		from EOrdenCM a 
			inner join DOrdenCM b 
			on a.Ecodigo = b.Ecodigo 
			and a.EOidorden = b.EOidorden 
		where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
    	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      </cfquery>
      <tr>
        <td rowspan="4" width="100%">&nbsp;</td>
        <td >Subtotal&nbsp;:&nbsp;</td>
        <td align="right">#LSCurrencyFormat(rsTotales.Subtotal,'none')#</td>
      </tr>
      <tr>
        <td >Impuestos&nbsp;:&nbsp;</td>
        <td align="right">#LSCurrencyFormat(qryLista.Impuesto,'none')#</td>
      </tr>
      <tr>
        <td >Descuentos&nbsp;:&nbsp;</td>
        <td align="right">#LSCurrencyFormat(qryLista.EOdesc,'none')#</td>
      </tr>
      <tr>
        <td ><strong>Total&nbsp;:&nbsp;</strong></td>
        <td align="right"><strong>#LSCurrencyFormat(qryLista.EOtotal,'none')#</strong></td>
      </tr>
    </table>
</cfoutput>