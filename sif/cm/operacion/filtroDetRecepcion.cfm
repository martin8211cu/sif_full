<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset navegacion = "">
<cfif isdefined("url.EDRid") and not isdefined('form.EDRid')>	
	<cfset form.EDRid = url.EDRid>
</cfif>
<cfif isdefined("url.DOlinea") and not isdefined('form.DOlinea')>	
	<cfset form.DOlinea = url.DOlinea>
</cfif>
<cfif isdefined("url.numparteF") and not isdefined('form.numparteF')>	
	<cfset form.numparteF = url.numparteF>
</cfif>
<cfif isdefined("url.DOalternaF") and not isdefined('form.DOalternaF')>	
	<cfset form.DOalternaF = url.DOalternaF>
</cfif>
<cfif isdefined("url.DOobservacionesF") and not isdefined('form.DOobservacionesF')>	
	<cfset form.DOobservacionesF = url.DOobservacionesF>
</cfif>
<cfif isdefined("url.AcodigoF") and not isdefined('form.AcodigoF')>	
	<cfset form.AcodigoF = url.AcodigoF>
</cfif>
<cfif isdefined("url.DOdescripcionF") and not isdefined('form.DOdescripcionF')>	
	<cfset form.DOdescripcionF = url.DOdescripcionF>
</cfif>
<cfif isdefined("Form.EDRid") and Len(Trim(Form.EDRid)) NEQ 0>	
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EDRid=" & Form.EDRid>
</cfif>
<cfif isdefined("Form.DOlinea") and Len(Trim(Form.DOlinea)) NEQ 0>	
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOlinea=" & Form.DOlinea>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="dataLineas" datasource="#session.DSN#">
	select 	
			<cfif isdefined("form.numparteF") and form.numparteF NEQ ''>	
				'#form.numparteF#' as numparteF,
			</cfif>	
			<cfif isdefined("form.DOalternaF") and form.DOalternaF NEQ ''>	
				'#form.DOalternaF#' as DOalternaF,
			</cfif>		
			<cfif isdefined("form.DOobservacionesF") and form.DOobservacionesF NEQ ''>	
				'#form.DOobservacionesF#' as DOobservacionesF,
			</cfif>			
			<cfif isdefined("form.AcodigoF") and form.AcodigoF NEQ ''>	
				'#form.AcodigoF#' as AcodigoF,
			</cfif>		
			<cfif isdefined("form.DOdescripcionF") and form.DOdescripcionF NEQ ''>	
				'#form.DOdescripcionF#' as DOdescripcionF,
			</cfif>							
			a.EDRid,
			DOporcdesc,
			DDRcantordenconv,
			#LvarOBJ_PrecioU.enSQL_AS("DOpreciou")#,
			coalesce(DDRdescporclin,0) as DDRdescporclin,
			coalesce(DDRimptoporclin,0) as DDRimptoporclin,			
			coalesce(DDRmtoimpfact,0) as DDRmtoimpfact,						
			coalesce(DDRtotallincd,0) as DDRtotallincd,								
			(a.DDRtotallin  *   coalesce(i.Iporcentaje,i2.Iporcentaje,0) )/100 as ImpuestoCalc,	
			b.EOidorden, 
			b.DOalterna,
			b.DOobservaciones,
			b.DOconsecutivo,
			(<cf_dbfunction name="to_char" args="c.EOnumero" datasource="#session.dsn#"> #_Cat# ' - ' #_Cat# c.Observaciones) as descOrden,			
			c.EOnumero, 
			c.Observaciones, 
			a.DDRlinea, 
			a.DOlinea,
			b.DOdescripcion as descrArtServ,
			coalesce(i.Iporcentaje,i2.Iporcentaje,0) as Iporcentaje, 
			case when a.DDRtipoitem = 'A' then rtrim(d.Acodigo)#_Cat#' - '#_Cat#b.DOdescripcion
				 when a.DDRtipoitem = 'S' then rtrim(e.Ccodigo)#_Cat#' - '#_Cat#b.DOdescripcion
				 else b.DOdescripcion
			end  as DOdescripcion,
			case when a.DDRtipoitem = 'A' then rtrim(d.Acodigo)
				 when a.DDRtipoitem = 'S' then rtrim(e.Ccodigo)
			end  as codArtServ,			
			a.DDRtipoitem, 
			a.Aid, 
			a.Cid, 
			a.DDRcantorigen, 
			case 
				when a.DDRcantorigen = 0 then (b.DOcantidad-b.DOcantsurtida)
				else a.DDRcantorigen 
			end  as cantidadFactura,
			a.DDRcantrec,
			
			a.DDRcantrec  as cantidadRecibida,
			#LvarOBJ_PrecioU.enSQL_AS("DDRpreciou")#,
			#LvarOBJ_PrecioU.enSQL_AS(<!--- para brincarme la verificación automática ")# ---> "		
										case 
											when a.DDRpreciou = 0 then a.DDRprecioorig
											else a.DDRpreciou
										end
				", "precioFactura")#,
			coalesce(a.DDRtotallin,0) as DDRtotallin, 
			#LvarOBJ_PrecioU.enSQL_AS("a.DDRprecioorig")#, 
			coalesce(a.DDRdesclinea,0) as DDRdesclinea, 
			a.DDRobsreclamo,
			a.DDRgenreclamo,
		   	b.DOcantidad, 
			b.Ucodigo as UcodigoOC,
			coalesce(a.Ucodigo, b.Ucodigo) as Ucodigo, 
			coalesce(u.Udescripcion, u2.Udescripcion) as descUnidad,
			a.Icodigo as IcodigoFAC, 
			b.Icodigo, 
			coalesce(i.Idescripcion, i2.Idescripcion) as descImpuesto, 
			(b.DOcantidad-b.DOcantsurtida) as saldo,
			(b.DOcantidad-a.DDRcantorigen) as saldoDet,			
			coalesce(g.NumeroParte,d.Acodalterno) as numparte,
			DOmontodesc,
			c.Mcodigo,
			c.EOtc,
			edr.Mcodigo as McodigoF,
			edr.EDRtc,
			edr.EPDid
			
	from DDocumentosRecepcion a
		inner join EDocumentosRecepcion edr
		on edr.Ecodigo = a.Ecodigo
		and edr.EDRid = a.EDRid
	
		inner join DOrdenCM b
			on a.DOlinea=b.DOlinea

		inner join Unidades u
			 on u.Ucodigo=b.Ucodigo
			and u.Ecodigo=a.Ecodigo

		left outer join Unidades u2
			on u2.Ucodigo=a.Ucodigo
			and u2.Ecodigo=a.Ecodigo			
	
		inner join EOrdenCM c
			on b.EOidorden=c.EOidorden
	
		left outer join Articulos d
			on a.Ecodigo = d.Ecodigo
			and a.Aid = d.Aid 
			
		left outer join NumParteProveedor g
			on  d.Aid = g.Aid 
				and d.Ecodigo = g.Ecodigo            
				and c.SNcodigo = g.SNcodigo
				and  <cf_dbfunction name="now"> between g.Vdesde and g.Vhasta
			<!---	and g.NPPid in (select NP.NPPid from NumParteProveedor NP          
						   where NP.Ecodigo = g.Ecodigo and NP.SNcodigo = g.SNcodigo and  
								NP.Aid = g.Aid and 	<cf_dbfunction name="now">
									between NP.Vdesde and NP.Vhasta)	--->				
		
		left outer join Conceptos e
			on a.Ecodigo = e.Ecodigo
			and a.Cid = e.Cid 
			

		left outer join Impuestos i
			on a.Ecodigo = i.Ecodigo
			and a.Icodigo = i.Icodigo			

		inner join Impuestos i2
			on b.Ecodigo = i2.Ecodigo
			and b.Icodigo = i2.Icodigo			

	where a.EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
		and a.Ecodigo = #session.Ecodigo#
			<cfif isdefined("Form.numparteF") and Len(Trim(Form.numparteF)) NEQ 0>
				and Upper(coalesce(g.NumeroParte,d.Acodalterno)) like Upper('%#form.numparteF#%')
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "numparteF=" & Form.numparteF>	
			</cfif>
			<cfif isdefined("Form.DOalternaF") and Len(Trim(Form.DOalternaF)) NEQ 0>
				and Upper(DOalterna) like Upper('%#form.DOalternaF#%')
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOalternaF=" & Form.DOalternaF>	
			</cfif>
			<cfif isdefined("Form.DOobservacionesF") and Len(Trim(Form.DOobservacionesF)) NEQ 0>
				and Upper(DOobservaciones) like Upper('%#form.DOobservacionesF#%')
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOobservacionesF=" & Form.DOobservacionesF>	
			</cfif>			
			<cfif isdefined("Form.AcodigoF") and Len(Trim(Form.AcodigoF)) NEQ 0>
				and Upper(Acodigo) like Upper('%#form.AcodigoF#%')
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AcodigoF=" & Form.AcodigoF>	
			</cfif>	
			<cfif isdefined("Form.DOdescripcionF") and Len(Trim(Form.DOdescripcionF)) NEQ 0>
				and Upper(b.DOdescripcion) like Upper('%#form.DOdescripcionF#%')
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOdescripcionF=" & Form.DOdescripcionF>	
			 </cfif>						
	order by numparte,Acodigo,DDRtipoitem 
</cfquery>
<cfif isdefined('dataLineas') and dataLineas.recordCount EQ 1>
	<cfset form.DOlinea = dataLineas.DOlinea>
	<cfset form.DDRlinea = dataLineas.DDRlinea>
</cfif>

<cfset totalGen = 0>		
<cfif isdefined('dataLineas') and dataLineas.recordCount GT 0>
	<cfquery name="rsTotales" dbtype="query">
		select sum(DDRtotallin) as total,
			<cfif len(trim(dataLineas.EPDid)) eq 0>
					sum(((DDRtotallincd)*Iporcentaje)/100) as sumImpuesto,
			<cfelse>
				0.00 as sumImpuesto,
			</cfif>
			sum(DDRdesclinea) as sumDescuento
		from dataLineas
	</cfquery>

	<cfif isdefined('rsTotales') and rsTotales.recordCount GT 0>
		<cfset totalGen = (rsTotales.total + rsTotales.sumImpuesto) - rsTotales.sumDescuento>
	</cfif>	
</cfif>

<form name="formFiltro" method="post" action="documentos.cfm" style="margin:'0'">
	<cfoutput>
		<input type="hidden" name="EDRid" id="EDRid" value="#form.EDRid#">
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
		  <tr>
			<td width="17%" align="right" nowrap><strong>N&uacute;mero de Parte: </strong></td>
			<td width="26%"><input type="text" name="numparteF" id="numparteF2" value="<cfif isdefined('form.numparteF') and form.numparteF NEQ ''>#form.numparteF#</cfif>"></td>
			<td width="13%" align="right" nowrap><strong>C&oacute;digo de Articulo:</strong></td>
			<td width="21%"><input type="text" name="AcodigoF" id="AcodigoF" value="<cfif isdefined('form.AcodigoF') and form.AcodigoF NEQ ''>#form.AcodigoF#</cfif>"></td>
			<td width="11%" align="center" valign="middle"><strong>Descripcipci&oacute;n:</strong>:</td>
		    <td width="12%" align="center" valign="middle"><input name="DOdescripcionF" id="DOdescripcionF" value="<cfif isdefined('form.DOdescripcionF') and form.DOdescripcionF NEQ ''>#form.DOdescripcionF#</cfif>" type="text" size="30" maxlength="255"></td>
	      </tr>
		  <tr>
			<td align="right" nowrap><strong>Descripci&oacute;n Alterna: </strong></td>
			<td><input name="DOalternaF" id="DOalternaF" value="<cfif isdefined('form.DOalternaF') and form.DOalternaF NEQ ''>#form.DOalternaF#</cfif>" type="text" size="30" maxlength="1024"></td>
		    <td align="right" nowrap><strong>Observaciones:</strong></td>
		    <td><input name="DOobservacionesF" id="DOobservacionesF2" value="<cfif isdefined('form.DOobservacionesF') and form.DOobservacionesF NEQ ''>#form.DOobservacionesF#</cfif>" type="text" size="30" maxlength="255"></td>
		    <td width="0%" align="center" valign="middle"><input type="submit" name="btnFiltro" value="Filtrar"></td>
		    <td width="0%" align="center" valign="middle"><input type='button' onClick="javascript: limpiaFiltro();" name="btnLimpiar" value="Limpiar"></td>
	      </tr>
		</table>
	</cfoutput>		
</form>
<script language="javascript" type="text/javascript">
	function limpiaFiltro(){
		document.formFiltro.numparteF.value = '';
		document.formFiltro.DOalternaF.value = '';
		document.formFiltro.DOobservacionesF.value = '';
		document.formFiltro.AcodigoF.value = '';
		document.formFiltro.DOdescripcionF.value = '';		
	}
</script>