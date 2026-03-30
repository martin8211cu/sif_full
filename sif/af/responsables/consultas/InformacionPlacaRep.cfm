<!---
********************************************************
Módulo: Control de Reponsables
Nombre: Documento de Responsabilidad Vigente
********************************************************
Hecho por: NA
Creado: NA
********************************************************
Modificado por: Dorian Abarca Gómez
Modificado: 18 Julio 2006
Moficaciones:
1. Se modifica para que se imprima y baje a excel con el cf_htmlreportsheaders.
2. Se modifica para que se pinte con el jdbcquery.
3. Se verifica uso de cf_templateheader y cf_templatefooter.
4. Se verifica uso de cf_web_portlet_start y cf_web_portlet_end.
5. Se agrega cfsetting y cfflush.
6. Se envían estilos al head por medio del cfhtmlhead.
7. Se mantienen filtros de la consulta.
8. Se mofica conlis de placa por tag de sif_activo.
********************************************************
Modificado por: Randall Colomer en el ICE
Modificado: 29 Agosto 2006
Moficaciones:
1. Se cambio la variable form.Aplaca por form.AplacaINI.
2. Se cambio la variable form.Adescripcion por form.AdescripcionINI.
********************************************************
--->

<cfsetting enablecfoutputonly="yes" showdebugoutput="no" requesttimeout="36000">

<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo =  #Session.Ecodigo#   
		  and Pcodigo = #Arguments.pcodigo#
	</cfquery>
	<cfreturn #rs#>
</cffunction>
<cf_dbfunction name="now" returnvariable="hoy">
<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr >
    <td width="100%" align="right">
		<a id="VERDOC" onclick="javascript:verDocumento();">
			<img src="/cfmx/sif/imagenes/iindex.gif"
				border="0" style="cursor:pointer" class="noprint" title="Ver Documento">
		</a>
	</td>
  </tr>
</table>
</cfoutput>
<cf_htmlreportsheaders
	title="Detalle por Placa" 
	filename="InformacionPlaca#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" 
	ira="InformacionPlaca.cfm">
<!--- Empieza a pintar el reporte en el usuario cada 512 bytes los bytes que toma en cuenta son de aquí en adelante omitiendo lo que hay antes, y la informació de los headers de la cantidad de bytes --->
<cfflush interval="20">
<!--- Consultas --->
<cfquery name="rsPlacas" datasource="#session.DSN#">
	select Astatus
	from Activos
	where Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
	  and Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Verifica si tiene vales vigentes --->
<cfquery name="rsConvales" datasource="#session.DSN#">
	Select 1
	from Activos a
	where a.Ecodigo = #session.Ecodigo#
	  and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
	  and not exists ( 
	  	Select 1 
		from AFResponsables b 
		where b.Aid = a.Aid
		  and #hoy# between b.AFRfini and b.AFRffin)
</cfquery>

<cfif rsConvales.recordcount gt 0>
	<cfset tienevigentes=0>
	<cfquery name="rsRetirados" datasource="#session.DSN#">
		select AFRid
		from Activos a, AFResponsables b
		where a.Ecodigo = #session.Ecodigo#
		  and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
		  and b.Aid = a.Aid
		  and b.AFRfini = (select max(z.AFRfini) 
						   from AFResponsables z
						   where z.Aid = a.Aid)  
	</cfquery>
<cfelse>
	<cfset tienevigentes=1>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
select
		B.AFRid 				as id,
		C.Aplaca 				as placa,
		C.Adescripcion 			as descPlaca,
		B.CRDRdescdetallada 	as CRDRdescdetallada,
		I.AFMdescripcion 		as marca,		
		L.AFMMdescripcion 		as modelo,
		J.AFCdescripcion 		as tipo,	
		C.Aserie 				as serie,
		D.DEidentificacion 		as cedula,
		<cf_dbfunction name="concat" args="D.DEnombre ,' ', D.DEapellido1 ,' ', D.DEapellido2"> as nombre,
		<cf_dbfunction name="concat" args="rtrim(H.CFcodigo) ,'-',H.CFdescripcion"> as CF,
		<cf_dbfunction name="concat" args="rtrim(O.Oficodigo), '-' ,O.Odescripcion"> as Oficina,
		E.CRCCdescripcion 		as CC,		
		K.CRTDdescripcion 		as TipoDoc,
		F.ACdescripcion 		as Categoria,
		G.ACdescripcion 		as Clase,
		B.AFRfini 				as FI,
		case when (#hoy# >= B.AFRfini and #hoy# <= B.AFRffin) then 'Vigente' else 'No Vigente' end as descEstado,
		case when (#hoy# >= B.AFRfini and #hoy# <= B.AFRffin) then 'A' else 'I' end as idEstado ,
		case when (C.Astatus = 0) then 'Activo' else 'Retirado' end as ACTstatus,
		F.ACcodigodesc 	as codCategoria,
		G.ACcodigodesc 	as CodClasificacion,
		HIS.CRBfecha as UltimaMofic,
		
        case HIS.CRBmotivo 
				when 1 then 'Inclusion' 
				when 2 then 'Retiro' 
				when 3 then 'Traslado de responsable' 
				when 4 then 'Traslado de centro de custodia' 
				when 5 then 'Mejora' 
				when 6 then 'Inclusion Control de Responsables' 
			end as Transac,
		USR.Usulogin as usuario,
		C.Afechaaltaadq as Fecha_Ingreso,
		tcp.CRTCdescripcion as Tipo_Compra,
		B.CRDRdocori as Documento_Org,
		'' as Etiqueta_Origen,
        			
		<!---MONTO DE LA ADQUISICION--->
        tac.TAmontolocadq as Monto_Adquisicion,

		<!---PROVEEDOR--->
		coalesce(
		(Select ltrim(rtrim((ltrim(rtrim(sn.SNnombre))))) 
		from EDocumentosCP cp
				inner join SNegocios sn
					  on cp.SNcodigo = sn.SNcodigo
					and cp.Ecodigo = sn.Ecodigo
		where cp.Ddocumento= B.CRDRdocori
		   and cp.Ecodigo = B.Ecodigo),'NA' ) as Proveedor,

		<!---NO. ACUERDO--->
		coalesce((
			Select TESAPnumero
			from TESacuerdoPago tap
					inner join TESsolicitudPago sp
						 on tap.TESAPid = sp.TESAPid
						and sp.EcodigoOri = tap.Ecodigo
					inner join TESdetallePago dp
						  on sp.TESSPid = dp.TESSPid
					inner join EDocumentosCP dcp
						  on dcp.Ddocumento = dp.TESDPdocumentoOri 
						and dcp.Ecodigo = tap.Ecodigo
			where tap.Ecodigo = B.Ecodigo
			   and  dcp.Ddocumento = B.CRDRdocori			   
		) ,'NA' ) as Num_Acuerdo,

		<!---FECHA DE ACUERDO--->
		coalesce((
			Select TASAPfecha
			from TESacuerdoPago tap
					inner join TESsolicitudPago sp
						 on tap.TESAPid = sp.TESAPid
						and sp.EcodigoOri = tap.Ecodigo
					inner join TESdetallePago dp
						  on sp.TESSPid = dp.TESSPid
					inner join EDocumentosCP dcp
						  on dcp.Ddocumento = dp.TESDPdocumentoOri 
						and dcp.Ecodigo = tap.Ecodigo
			where tap.Ecodigo = B.Ecodigo
			   and  dcp.Ddocumento = B.CRDRdocori			   
		) ,'' ) as Fecha_Acuerdo

from Activos C
		inner join AFResponsables B  on 
				B.Aid     = C.Aid and
				B.Ecodigo = C.Ecodigo
				
		inner join TransaccionesActivos tac
			  on tac.Aid = C.Aid
			and tac.Ecodigo = C.Ecodigo
			and tac.IDtrans=1

		left outer join CRTipoCompra tcp on	
				B.CRTCid  = tcp.CRTCid and 
				B.Ecodigo = tcp.Ecodigo
				
		inner join DatosEmpleado D on 
				B.DEid 	  = D.DEid and 
				B.Ecodigo = D.Ecodigo
 
 		inner join CRCentroCustodia E on
				B.Ecodigo = E.Ecodigo and 
				B.CRCCid  = E.CRCCid

		inner join ACategoria F on
				C.Ecodigo  = F.Ecodigo and
				C.ACcodigo = F.ACcodigo

		inner join AClasificacion G on
				C.Ecodigo  = G.Ecodigo and
				C.ACcodigo = G.ACcodigo and
				C.ACid     = G.ACid

		left outer join CFuncional H on
				B.CFid = H.CFid

		left outer join Oficinas O on
				O.Ocodigo = H.Ocodigo and 
				O.Ecodigo = H.Ecodigo

		left outer join CRBitacoraTran HIS on
				B.Ecodigo = HIS.Ecodigo 
				and HIS.CRBPlaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">

		left outer join AFMarcas I on
				C.AFMid  = I.AFMid and 
				C.Ecodigo = I.Ecodigo

		left outer join AFClasificaciones J on
				C.AFCcodigo  = J.AFCcodigo and 
				C.Ecodigo = J.Ecodigo

		inner join CRTipoDocumento K on
				B.Ecodigo = K.Ecodigo and
				B.CRTDid = K.CRTDid

		inner join AFMModelos L on
				C.Ecodigo = L.Ecodigo and
				C.AFMMid = L.AFMMid

		left outer join Usuario USR on
				HIS.Usucodigo  = USR.Usucodigo 	

where C.Ecodigo  = #Session.Ecodigo#
    and C.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#"> 
		<cfif isdefined("rsPlacas") and rsPlacas.Recordcount GT 0>
			<cfif tienevigentes eq 1>
				    and (#hoy# >= B.AFRfini and #hoy# <= B.AFRffin) 
			<cfelse>
				<cfif isdefined("rsRetirados") and rsRetirados.Recordcount GT 0>
					and B.AFRid = #rsRetirados.AFRid#
				</cfif>
			</cfif>
		</cfif>
</cfquery>

<cfif isdefined("rsReporte") and rsReporte.RecordCount EQ 0>

  <cfquery name="rs_Info" datasource="#session.dsn#">
      select  max(BITC.CRBid) as CRBid
      FROM CRBitacoraTran  BITC
      where BITC.Ecodigo   = #session.Ecodigo#
          and BITC.CRBPlaca  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
  </cfquery>

	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
			A.CRDRid as id,
			A.CRDRplaca   	as placa,
			A.CRDRdescripcion    	as descPlaca,
			A.CRDRdescdetallada  	as CRDRdescdetallada,
			I.AFMdescripcion 		as marca,	
			L.AFMMdescripcion 		as modelo,
			J.AFCdescripcion 		as tipo,
			CRDRserie     			as serie,
			D.DEidentificacion 		as cedula,
			<cf_dbfunction name="concat" args="D.DEnombre ,' ', D.DEapellido1 ,' ', D.DEapellido2"> as nombre,
			<cf_dbfunction name="concat" args="rtrim(H.CFcodigo) ,'-',H.CFdescripcion"> as CF,
			<cf_dbfunction name="concat" args="rtrim(O.Oficodigo) ,'-',O.Odescripcion"> as Oficina,
			E.CRCCdescripcion 		as CC,
			K.CRTDdescripcion 		as TipoDoc,
			F.ACdescripcion 		as Categoria,
			G.ACdescripcion 		as Clase,
			CRDRfdocumento 			as FI,
			case when CRDRestado = 0 then 'En Tránsito (Digitación)' else 'En Tránsito' end as descEstado,
			'T' 					as idEstado,
			''						as ACTstatus,
			F.ACcodigodesc 			as codCategoria,
			G.ACcodigodesc 			as CodClasificacion	,
			HIS.CRBfecha 			as UltimaMofic,
			case HIS.CRBmotivo 
					when 1 then 'Inclusión' 
					when 2 then 'Retiro' 
					when 3 then 'Traslado de responsable' 
					when 4 then 'Traslado de centro de custodia' 
					when 5 then 'Mejora' 
					when 6 then 'Inclusión Control de Responsables' 
				end as Transac,
			USR.Usulogin as usuario,
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null"> as Fecha_Ingreso,
			tcp.CRTCdescripcion as Tipo_Compra,
			A.CRDRdocori as Documento_Org,
			A.CRorigen as Etiqueta_Origen,
		<!---PROVEEDOR--->
            'NA' as Proveedor
               	
		from CRDocumentoResponsabilidad  A
			left outer join CRTipoCompra tcp on	
				A.CRTCid  = tcp.CRTCid and 
				A.Ecodigo = tcp.Ecodigo
			
			left outer join CRBitacoraTran HIS on
				A.Ecodigo = HIS.Ecodigo 
				and HIS.CRBPlaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
				<cfif isdefined("rs_Info.CRBid") and rs_Info.CRBid gt 0>
					and HIS.CRBid = #rs_Info.CRBid# 
				<cfelse>
					and HIS.CRBid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
				</cfif>
		
            inner join DatosEmpleado D on 
				A.DEid 	= D.DEid and 
				A.Ecodigo = D.Ecodigo
			
            inner join CRCentroCustodia E on
				A.Ecodigo = E.Ecodigo and 
				A.CRCCid  = E.CRCCid
			
            inner join ACategoria F on
				A.Ecodigo = F.Ecodigo and
				A.ACcodigo = F.ACcodigo
			
            inner join AClasificacion G on
				A.Ecodigo = G.Ecodigo and
				A.ACcodigo = G.ACcodigo and
				A.ACid = G.ACid
			
            left outer join CFuncional H on
				A.CFid = H.CFid and 
				A.Ecodigo = H.Ecodigo
			
            left outer join Oficinas O on
				O.Ocodigo = H.Ocodigo and 
				O.Ecodigo = H.Ecodigo
			
            left outer join AFMarcas I on
				A.AFMid  = I.AFMid and 
				A.Ecodigo = I.Ecodigo
			
            left outer join AFClasificaciones J on
				A.AFCcodigo  = J.AFCcodigo and 
				A.Ecodigo = J.Ecodigo
			
            inner join CRTipoDocumento K on
				A.Ecodigo = K.Ecodigo and
				A.CRTDid = K.CRTDid
			
            inner join AFMModelos L on
				A.Ecodigo = L.Ecodigo and
				A.AFMMid = L.AFMMid
			
            left outer join Usuario USR on
				HIS.Usucodigo  = USR.Usucodigo 	
			
        where  A.CRDRplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AplacaINI#">
        and    A.Ecodigo  =  #Session.Ecodigo# 
        order by placa
    </cfquery>
</cfif>
<!--- Filtros --->
<cfset placaInicial  = " No Definida">
<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))>
	<cfset placaInicial  = " " & form.AplacaINI & " (" & form.AdescripcionINI & ")">
</cfif>
<!--- Reporte --->
<cfoutput>

<style type="text/css">
	* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
	.niv1 { font-size: 18px; }
	.niv2 { font-size: 16px; }
	.niv3 { font-size: 12px; }
	.niv4 { font-size: 10px; }
</style>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="niv4">
	<tr><td align="center" colspan="2"><cfinclude template="RetUsuario.cfm"></td></tr>
	<tr><td align="center" colspan="2"><strong>#session.Enombre#</strong></font></td></tr>
	<tr><td align="center" colspan="2"><font size="2"><strong>Informaci&oacute;n Detallada de la Placa</strong></font></td></tr>
	<tr><td align="center" colspan="2"><strong>#placaInicial#</strong></td></tr>
	<tr><td align="center" colspan="2"><hr></td></tr>
	<cfif rsReporte.recordcount gt 0>
	<tr>
		<td  width="10%"align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Placa:&nbsp;</strong></td>
		<td width="55%"align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.placa)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>	
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Descripci&oacute;n:</strong></td>
		<td align="left"valign="top">&nbsp;<font size="1">#trim(rsReporte.descPlaca)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Descripci&oacute;n Detallada:</strong></td>
		<td align="left"valign="top">&nbsp;<font size="1">#trim(rsReporte.CRDRdescdetallada)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Tipo:</strong></td>
		<td align="left"valign="top">&nbsp;<font size="1">#trim(rsReporte.tipo)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Marca:</strong></td>
		<td align="left"valign="top">&nbsp;<font size="1">#trim(rsReporte.marca)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Modelo:</strong></td>
		<td align="left"valign="top">&nbsp;<font size="1">#trim(rsReporte.modelo)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Serie:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.serie)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;C&eacute;dula:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.cedula)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Nombre:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.nombre)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Centro Funcional:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.CF)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Oficina :</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.Oficina)#</font></td>			
	</tr>								
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Centro Custodia:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.CC)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Tipo Documento:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.TipoDoc)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Categor&iacute;a:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.codCategoria)# #trim(rsReporte.Categoria)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Clase:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.codClasificacion)# #trim(rsReporte.Clase)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Fecha Ingreso:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(LSDateFormat("#rsReporte.Fecha_Ingreso#","dd/mm/yyyy"))#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Estado del Vale:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.descEstado)#</font></td>			
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Estado del Activo:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.ACTstatus)#</font></td>			
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;&Uacute;ltima Transacci&oacute;n:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.Transac)#&nbsp;</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>								
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Fecha Transacci&oacute;n:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(LSDateFormat("#rsReporte.UltimaMofic#","dd/mm/yyyy"))#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>								
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Usuario:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.usuario)#</font></td>
	</tr>				
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>								
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Tipo de Compra:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.Tipo_Compra)#</font></td>
	</tr>												
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>								
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Documento Origen:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.Documento_Org)#</font></td>
	</tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<cfset OrigenA = ObtenerDato(1110)>
	<tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;<cfif OrigenA.RecordCount gt 0 and len(trim(OrigenA.Pvalor))><cfoutput>#OrigenA.Pvalor#</cfoutput><cfelse>Origen</cfif>:</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.Etiqueta_Origen)#</font></td>
	</tr>
    <tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
    <!---NOMBRE DEL PROVEEDOR---->
   <tr>
		<td  width="10%"align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Nombre del Proveedor:&nbsp;</strong></td>
		<td width="55%"align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.Proveedor)#</font></td>
	</tr>  
    <tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
     <!---VALOR DE LA ADQUISICION---->
    <tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;Valor de Adquisición:&nbsp;</strong></td>
		<td align="left" valign="top">&nbsp;<font size="1">#trim(rsReporte.Monto_Adquisicion)#</font></td>
	</tr>
    <tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
	<tr> <td bgcolor="##CCCCCC">&nbsp;</td><td>&nbsp;</td></tr>
    <cfif trim(rsReporte.Documento_Org) neq "">    
    <tr>		
		<td align="left"  valign="top" bgcolor="##CCCCCC"><strong>&nbsp;&nbsp;Acuerdos de Pago</strong></td>
		<td align="left" valign="top">
        	&nbsp;
			<!---NO. DE ACUERDO DE PAGO---->                
            <a href="##" tabindex="-1" onclick="javascript: popAcuerdoPago('#trim(rsReporte.placa)#');">Ver Acuerdos de Pago <img src="../../../imagenes/copy.small.png" width="18" height="14" border="0"></a>            
        </td>
	</tr>    
	</cfif>                               
	<tr><td align="center" colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" nowrap align="center"><strong> --- Fin de la Consulta --- </strong></td></tr>
<cfelse>
	<tr><td align="center" colspan="2">&nbsp;</td></tr>
	<tr><td align="center" colspan="2"><strong> --- La consulta no gener&oacute; ning&uacute;n resultado --- </strong></td></tr>
</cfif>
</table>
</body>
</html>
<!--- Manejo de los Botones --->
<script language="Javascript" type="text/javascript">
	<!--//
	function verDocumento() {
		var id = <cfoutput>#rsReporte.id#</cfoutput>;
		window.open("InformacionPlaca-documento-Impr.cfm?id="+id);
	}
	//-->
//funcion pop-up
var popUpWin = 0;

function popUpWindow(URLStr, ancho, alto){
var pos_x; 
var posicion_y; 
pos_x=(screen.width/2)-(ancho/2); 
pos_y=(screen.height/2)-(alto/2);  

	if(popUpWin){
		if(!popUpWin.closed) popUpWin.close();
	}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=0,status=no,menubar=0,scrollbar=yes,resizable=no,copyhistory=yes,left='+pos_x+',top='+pos_y+', width='+ancho+',height='+alto+'');
	}	
//Llama al pop de los acuerdos de pago
	function popAcuerdoPago(placa) {
		popUpWindow("/cfmx/sif/af/responsables/consultas/popUp-AcuerdosPago.cfm?placa="+placa+"",400,300);
	}
</script>

</cfoutput>
