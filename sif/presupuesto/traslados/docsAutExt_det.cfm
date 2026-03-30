<cfif isdefined ('form.CPDAEid') AND form.CPDAEid NEQ "">
	<cfset modo='CAMBIO'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			CPDAEid,
			Ecodigo, 
			CPDAEcodigo,
			CPDAEdescripcion,
			CPTAEid,
			case CPDAEestado
				when 0 then 	'Inactivo: El documento no se puede utilizar'
				when 1 then 	'Abierto: Se pueden asignar traslados'
				when 2 then 	'Pausa: No permite nuevos traslados'
				when 3 then 	'Cerrado: No permite aprobar traslados'
				when 10 then 	'Enviado a Autorización Externa'
				when 11 then 	'APLICADO'
				when 12 then 	'RECHAZADO'
			end as estado,
			CPDAEmontoCF,
			BMUsucodigo 
		from CPDocumentoAE
		where Ecodigo=#session.Ecodigo# 
		and CPDAEid=#form.CPDAEid#
	</cfquery>
<cfelse>
	<cfexit>
</cfif>

<cfquery name="rsTipos" datasource="#session.dsn#">
	select 
		CPTAEid,
		CPTAEcodigo,
		CPTAEdescripcion
	from CPtipoAutExterna
	where Ecodigo=#session.Ecodigo# 
</cfquery>

<form name="form1" action="docsAutExt_sql.cfm" method="post" onSubmit="return validar(this);">
<cfif modo eq 'CAMBIO'>
	<cfoutput><input type="hidden" name="CPDAEid" value="#rsForm.CPDAEid#"></cfoutput>
</cfif>
<table align="left" width="100%">
<cfoutput>
	<tr>
		<td align="left">
			<strong>Documento:</strong> 
			#trim(rsForm.CPDAEcodigo)# - #trim(rsForm.CPDAEdescripcion)#
		</td>
		<td align="right">
			<strong>Estado:</strong>
			#rsForm.Estado#
		</td>
	</tr>
</cfoutput>
	<tr>
		<td colspan="2">
			<!---
				CPDEestadoDAE
				0	En Proceso
				9	Aprobado sin confirmar
				10	Aprobado Confirmado
				11	Aprobado con NRP
				12	Aprobado y Aplicado
			--->
			<cf_dbfunction name="OP_concat" returnvariable="_CAT">
			<cf_dbfunction name="to_char" args="a.CPDEid" isnumber="no" returnvariable="LvarCPDEid">
			<cfquery name="rsLista" datasource="#session.dsn#">
				select 
						a.CPDEid,
						a.CPPid, 
						a.CPDEfechaDocumento, 
						a.CPDEnumeroDocumento, 
						a.CPDEdescripcion,
						(select coalesce(sum(CPDDmonto), 0) from CPDocumentoD z where z.CPDDtipo = -1 and z.Ecodigo = a.Ecodigo and z.CPDEid = a.CPDEid) as Monto,
						(select coalesce(sum(CPDDmonto), 0) 
							from CPDocumentoE e
								inner join CPDocumentoD d on d.CPDEid = e.CPDEid
							where e.CPDAEid 	= a.CPDAEid
							  and e.CFidOrigen 	= a.CFidOrigen
							  and (e.CPDEenAprobacion = 1 OR e.CPDEaplicado = 1)
							  and (99-e.CPDEestadoDAE)*100000000000000000 + e.CPDEid <= (99-a.CPDEestadoDAE)*100000000000000000 + a.CPDEid
							  and d.CPDDtipo = -1
						) as Acumulado,
			
						'CENTRO FUNCIONAL: ' #_CAT# CFdescripcion as CentroFuncional,
						'&nbsp;&nbsp;&nbsp;' #_CAT# case
							when (CPDEenAprobacion = 0 AND CPDErechazado = 0 AND CPDEaplicado = 0)
														then 'En Preparación'
							when CPDEaplicado = 1 		then 'APLICADO'
							when CPDErechazado = 1 		then 'RECHAZADO'
							when CPDEestadoDAE = 0		then 'En Aprobación'
							when CPDEestadoDAE = 9		then 'Aprobado sin confirmar'
							when CPDEestadoDAE = 10		then 'Aprobado'
							when CPDEestadoDAE = 11		then 'Aprobado con NRP'
							when CPDEestadoDAE = 12		then 'APLICADO'
						end as Estado,
						case
							when (CPDEenAprobacion = 0 AND CPDErechazado = 0 AND CPDEenAprobacion = 0)
														then ''
							when CPDEaplicado = 1 		then ''
							when CPDErechazado = 1 		then ''
							when CPDEestadoDAE = 0		then
								'<img src="/cfmx/sif/imagenes/OP/page-go.gif" 		alt="Pasar a Otro Documento de Autorización Externa"	style="cursor:pointer"	onclick="sbOP(1,'	#_CAT# #preserveSingleQuotes(LvarCPDEid)# #_CAT# ')">' 
								#_CAT#
								'<img src="/cfmx/sif/imagenes/OP/page-cancel.gif" 	alt="Rechazar Traslado"									style="cursor:pointer"	onclick="sbOP(3,'	#_CAT# #preserveSingleQuotes(LvarCPDEid)# #_CAT# ')">'
							when CPDEestadoDAE = 9		then
								'<img src="/cfmx/sif/imagenes/OP/page-add.gif" 		alt="Confirmar Aprobación"								style="cursor:pointer"	onclick="sbOP(10,'	#_CAT# #preserveSingleQuotes(LvarCPDEid)# #_CAT# ')">'
								#_CAT#
								'<img src="/cfmx/sif/imagenes/OP/page-go.gif" 		alt="Pasar a Otro Documento de Autorización Externa"	style="cursor:pointer"	onclick="sbOP(1,'	#_CAT# #preserveSingleQuotes(LvarCPDEid)# #_CAT# ')">' 
								#_CAT#
								'<img src="/cfmx/sif/imagenes/OP/page-cancel.gif" 	alt="Rechazar Traslado"									style="cursor:pointer"	onclick="sbOP(3,'	#_CAT# #preserveSingleQuotes(LvarCPDEid)# #_CAT# ')">'
							when CPDEestadoDAE = 10		then
								'<img src="/cfmx/sif/imagenes/OP/page-del.gif" 		alt="Desconfirmar Aprobación "							style="cursor:pointer"	onclick="sbOP(9,'	#_CAT# #preserveSingleQuotes(LvarCPDEid)# #_CAT# ')">'
							when CPDEestadoDAE = 11		then
								'<img src="/cfmx/sif/imagenes/OP/page-cancel.gif" 	alt="Rechazar Traslado"									style="cursor:pointer"	onclick="sbOP(3,'	#_CAT# #preserveSingleQuotes(LvarCPDEid)# #_CAT# ')">'
						end as OPs
				  from CPDocumentoE a
					inner join CFuncional cf
						on cf.CFid = a.CFidOrigen
				 where a.Ecodigo = #session.Ecodigo# 
				   and a.CPDEtipoDocumento = 'E'
				   and a.CPDAEid = #form.CPDAEid#
				   and (CPDEenAprobacion = 1 OR CPDEaplicado = 1)
				order by CPDEestadoDAE desc
			</cfquery>

			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsLista#"

				Cortes="CentroFuncional,Estado"
				desplegar="OPs,CPDEnumeroDocumento, CPDEdescripcion, CPDEfechaDocumento, Monto, Acumulado"
				etiquetas="OP,Número, Descripción, Fecha, Monto, Acumulado"
				formatos="S,S,S,D,M,M"
				align="left,left,left,center,right,right"
				ira="docsAutExt.cfm"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="CPDEid"
				incluyeForm="yes"
				formName="formLista1"
				PageIndex="2"
				MaxRows="8"
				botones="Salir"
				showlink="no"
			/>
			<script language="javascript">
				function sbOP(op,id)
				{
					location.href = 'docsAutExt_sql.cfm?OPD='+op+'&id=<cfoutput>#form.CPDAEid#</cfoutput>&idd='+id;
				}
				function funcSalir()
				{
					location.href = 'docsAutExt.cfm';
				}
			</script>
		</td>
	</tr>
</table>
