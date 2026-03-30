<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif isdefined("url.ERid") and not isdefined("form.ERid")>
	<cfset form.ERid = Url.ERid>
</cfif>
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<form name="form1" method="post">
			
  <table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
	  <td colspan="11" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
	</tr>
	<tr> 
	  <td colspan="11">&nbsp;</td>
	</tr>
	<tr> 
	  <td colspan="11" align="center"><b>Consulta Hist&oacute;rica de Reclamos de Compras</b></td>
	</tr>
	<cfoutput> 
		<tr>
			<td colspan="11" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
		</tr>
		<cfif isdefined('form.EDRfecharecI') and len(trim(form.EDRfecharecI)) NEQ 0 or isdefined('form.EDRfecharecF') and len(trim(form.EDRfecharecF)) NEQ 0>
			<tr>
				<td colspan="11" align="center"><b>Rango de fechas del Reclamo :</b> <cfif isdefined('form.EDRfecharecI') and len(trim(form.EDRfecharecI)) NEQ 0>Del #LSDateFormat(form.EDRfecharecI, 'dd/mm/yyyy')# &nbsp; </cfif> <cfif isdefined('form.EDRfecharecF') and len(trim(form.EDRfecharecF)) NEQ 0> al &nbsp;  #LSDateFormat(form.EDRfecharecF, 'dd/mm/yyyy')# &nbsp; </cfif></td>
			</tr>
		</cfif>		
		
	</cfoutput>
	  <cfset filtro = "">
		<cfquery name="rsRango" datasource="#session.DSN#">
			  select er.ERid, er.Ecodigo, er.SNcodigo, er.EDRid, er.CMCid, er.EDRnumero, er.EDRfecharec, 
				er.Usucodigo, er.fechaalta, er.ERestado, ERobs, 
				sn.SNnumero, sn.SNnombre, 
				m.Mnombre, 
				(case when hedr.CFid is null then coalesce(alm.Bdescripcion,'') 
					else coalesce(cf.CFdescripcion,'')
					end ) as CFdescripcion, 
				case er.ERestado when 0 then 'Sin Asignar'
					when 10 then 'En Proceso'
					when 20 then 'Concluido'
					end as Estado,
				d.CMCnombre, d.CMCcodigo
				from EReclamos er 
				
				inner join SNegocios sn
				  on  er.Ecodigo = sn.Ecodigo
				  and er.SNcodigo = sn.SNcodigo
				
				inner join HEDocumentosRecepcion hedr
				  on er.Ecodigo = hedr.Ecodigo
				  and er.EDRid = hedr.EDRid
				
				inner join Monedas m
				  on hedr.Ecodigo = m.Ecodigo
				  and hedr.Mcodigo = m.Mcodigo
				
				left outer join CFuncional cf
				  on hedr.Ecodigo =  cf.Ecodigo
				  and hedr.CFid = cf.CFid	
				
				left outer join Almacen alm
				  on hedr.Aid = alm.Aid
				  and hedr.Ecodigo = alm.Ecodigo
				  
				inner join CMCompradores d
				  on er.CMCid = d.CMCid
				  and er.Ecodigo = d.Ecodigo
				  
			where er.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and er.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
		</cfquery>
<cfoutput> 

	<tr>
		<td colspan="11" class="tituloListas"><strong>Datos del Reclamo de la Orden de Compra</strong></td>
	</tr>
  <tr>
		<td width="18%" valign="top"><strong>Proveedor&nbsp;:&nbsp;</strong></td>
		<td width="28%" valign="top" nowrap>#rsRango.SNnumero# - #rsRango.SNnombre#</td>
		<td width="19%" valign="top">&nbsp;</td>
		<td width="16%" valign="top">&nbsp;</td>
		<td><strong>Fecha del Reclamo:&nbsp;</strong><strong></strong></td>
        <td colspan="6">#LSDateFormat(rsRango.EDRfecharec,'dd/mm/yyyy')#</td>
      </tr>
 <tr>
 		<td valign="top"><strong>Comprador:</strong></td>
		<td valign="top">#rsRango.CMCcodigo# - #rsRango.CMCnombre#  </td>
		<td valign="top">&nbsp;</td>
		<td valign="top" nowrap>&nbsp;</td>
		<td><strong>N&uacute;mero de Reclamo:</strong></td>
        <td colspan="6">#rsRango.EDRnumero#</td>
 </tr>
 	<tr>
		<td valign="top"><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
		<td valign="top" nowrap>#rsRango.CFdescripcion#</td>
		<td></td>
		<td></td>
		<td><strong>Moneda:</strong></td>
		<td colspan="6">#rsRango.Mnombre#</td>
		<!---<td valign="top"><strong>Tipo de Cambio&nbsp;:&nbsp;</strong></td>
		<td valign="top">#LSCurrencyFormat(EOtc,'none')#</td>--->
  	</tr>
	<tr>
		<!---<cfdump var="#form#">--->
		<td valign="top"><strong>Observaciones&nbsp;:&nbsp;</strong></td>	
		<td valign="top">#rsRango.ERobs#</td>
		<td>&nbsp;</td>


	    <td>&nbsp;</td>
	    <td><strong>Estado&nbsp;:&nbsp;</strong></td>
        <td colspan="6">#rsRango.Estado#</td>
	</tr>
	<tr>
		<td colspan="11">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="11"><strong>Detalles del Reclamo de la Orden de Compra</strong></td>

	</tr>


		
		<cfset codigoReclamo = "">
		<cfloop query="rsRango">
					<cfquery name="rsReclamo" datasource="#Session.DSN#">
					select dr.DRid, dr.ERid, dr.Ecodigo, dr.DDRlinea, dr.DRcantorig, dr.DRcantrec, 
						#LvarOBJ_PrecioU.enSQL_AS("dr.DRpreciooc")#, 
						#LvarOBJ_PrecioU.enSQL_AS("dr.DRpreciorec")#, 
						dr.DRfecharec,
					DRfechacomp, dr.Usucodigo, dr.fechaalta, dr.DRestado, dr.DDRobsreclamo, docm.DOdescripcion
					from EReclamos er, DReclamos dr, DDocumentosRecepcion ddr, DOrdenCM docm
					where 	er.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and dr.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ERid#">
							and er.ERid = dr.ERid
							and er.Ecodigo = dr.Ecodigo
							and ddr.Ecodigo = dr.Ecodigo
							and ddr.DDRlinea = dr.DDRlinea
							and docm.Ecodigo = ddr.Ecodigo
							and docm.DOlinea = ddr.DOlinea 
							order by dr.DDRlinea
					</cfquery>
					<cfif rsRango.Currentrow EQ 1>
					  <tr> 
						<td width="18%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; "> <div align="center"><strong>Linea</strong></div></td>
						<td width="28%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "><div align="left"><strong>Descripci&oacute;n</strong></div></td>
						<td width="19%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "><div align="center"><strong>Cant. original</strong></div></td>
						<td width="16%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "><div align="center"><strong>Cant. recibida</strong></div></td>						
						<td width="17%" align="right" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "> <div align="right"><strong>Precio Orden</strong></div></td>
						<td width="17%" align="right" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "> <div align="right"><strong>Precio recepci&oacute;n </strong></div></td>
						<!--- <td width="10%">&nbsp;</td> --->
						<td width="17%" align="right" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right"><strong>Fecha recepci&oacute;n</strong></div></td>
					  </tr>
		  </cfif>
					  <tr> 
						<td style="padding-right: 5px; border-bottom: 1px solid black;"><div align="center">#rsReclamo.CurrentRow#</div></td>
						<td nowrap  style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="center">#mid(rsReclamo.DOdescripcion,1,35)#</div></td>
						<td  nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="center">#rsReclamo.DRcantorig#</div></td>
						<td  nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="center">#rsReclamo.DRcantrec#</div></td>
						<td align="right"  nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">#LvarOBJ_PrecioU.enCF_RPT(rsReclamo.DRpreciooc)#</div></td>
						<!--- <td width="10%">&nbsp;</td> --->
						<td align="right"  nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">#LvarOBJ_PrecioU.enCF_RPT(rsReclamo.DRpreciorec)#</div></td>
						<td align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><div align="right">#LSDateFormat(rsReclamo.DRfecharec, 'dd/mm/yyyy')#</div></td>
					  </tr>
					  <tr>
					  <td><div align="center"><strong>Observaciones:</strong></div></td>
					  	<td colspan="6"><div align="left">#rsReclamo.DDRobsreclamo#</div></td>
					  </tr>
					  <tr><td>&nbsp;</td></tr>
					  <cfset codigoReclamo = rsRango.ERid>
		  </cfloop>
		<cfif rsRango.Recordcount NEQ 0>
			<tr>
				<td colspan="11" align="center">------------------ Fin del Reporte ------------------</td>
		  	</tr>					
		<cfelse>
			<tr>
				<td colspan="11" align="center">------------------ No existe detalle del reclamos para esta orden ------------------</td>
			</tr>					
		</cfif>	
	</cfoutput> 			
  </table>
</form>