<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif not isdefined("url.bSel")>
	<cfset titulo = 'Detalle de Anticipos a Devolver'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	    <cf_dbfunction name="string_part" args="TESDPdescripcion,1,13" returnvariable="TESDPdescripcion1" datasource="#session.dsn#">
		<cf_dbfunction name="string_part" args="TESDPdescripcion,15,50" returnvariable="TESDPdescripcion2" datasource="#session.dsn#">
		<cfquery datasource="#session.dsn#" name="listaDet">
			Select 	TESSPid,TESDPid,
					TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, 
					case 
						when <!---subs(TESDPdescripcion,1,13)--->
						#TESDPdescripcion2#  = 'Devolución de'
							then 'Dev. ' #LvarCNCT# #TESDPdescripcion2#<!---substring(TESDPdescripcion,15,50)--->
							else TESDPdescripcion
					end as TESDPdescripcion, 
					TESDPfechaVencimiento,
				CFcuentaDB,CFformato,CFdescripcion
				<cfif isdefined("form.chkCancelados")>
					, 1 as chkCancelados
				</cfif>
	
			  from TESdetallePago dp
				left outer join CFinanciera cf
					on cf.CFcuenta=dp.CFcuentaDB
						and cf.Ecodigo=dp.EcodigoOri
			 where EcodigoOri=#session.Ecodigo#
			   and TESSPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		</cfquery>
		
		<cfif isdefined("LvarIncluyeForm") and LvarIncluyeForm>
			<cfset LvarIncluyeForm = "yes">
		<cfelse>
			<cfset LvarIncluyeForm = "no">
		</cfif>
		
		<cfif isdefined("form.chkCancelados")>
			<cfset LvarBotones = "">
		<cfelse>
			<cfset LvarBotones = "Seleccionar_Anticipos">
		</cfif>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#listaDet#"
			desplegar="TESDPfechaVencimiento, TESDPdescripcion, TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri"
			etiquetas="Fecha, Descripcion, Saldo, Monto a<BR>Devolver"
			formatos="D,S,M,M"
			align="left,left,right,right"
			ajustar="S,S,S,S"
			ira="solicitudesAnt#LvarTipoAnticipo#.cfm"
			form_method="post"	
			showEmptyListMsg="yes"
			keys="TESDPid"
			incluyeForm="#LvarIncluyeForm#"
			showLink="#LvarIncluyeForm#"
			botones="#LvarBotones#"
		/>							
		<BR>
		<script language="javascript">
			function funcSeleccionar_Anticipos()
			{
				<cfoutput>
				location.href = "solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#form.TESSPid#&bSel=1";
				</cfoutput>
				return false;
			}
		</script>
	<cf_web_portlet_end>
<cfelse>
	<cfset titulo = 'Lista de Anticipos a Seleccionar'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfif LvarTipoAnticipo EQ "POS">
			<cfquery datasource="#session.dsn#" name="listaDet">
				Select 	#url.TESSPid# as TESSPid,
						FAX14ID as DocId,
						a.FAX14FEC as Fecha,
						'Devolución de ' #LvarCNCT# 
								case 
									when a.FAX14CLA = '1' then 'Nota de Credito'
									else coalesce(ta.Descripcion, 'Adelanto')
								end #LvarCNCT# 
								' Num.' #LvarCNCT# a.FAX14DOC as Descripcion,
						a.FAX14MON-a.FAX14MAP-a.TESDPaprobadoPendiente as Monto
				  from FAX014 a
					left outer join FATiposAdelanto ta
						 on ta.IdTipoAd	= a.IdTipoAd
						and ta.Ecodigo	= a.Ecodigo
				 where a.Ecodigo	= #session.Ecodigo#
				   and a.CDCcodigo 	= #rsForm.CDCcodigo#
				   and a.FAX14CLA	in ('1','2')
				   and a.FAX14STS	= '1'	/* */
				   and a.FAX14MON-a.FAX14MAP-a.TESDPaprobadoPendiente > 0
				   and a.Mcodigo = #rsForm.McodigoOri#
				   and not exists (
						select 1 from TESdetallePago dp
						 where dp.EcodigoOri = a.Ecodigo
						   and dp.TESDPestado in (0,1)
						   and dp.TESDPidDocumento = a.FAX14ID
					)
					-- Verifica que el Recibo de Adelanto esté Contabilizado. Los NULL son adelantos migrados del sistema anterior
				   and (
							a.FAX01NTR IS NULL OR
							(select FAX01STA from FAX001 e where e.FAX01NTR = a.FAX01NTR) = 'C'
						)
			</cfquery>
		<cfelse>		
			<!--- CxC --->
			<cfquery datasource="#session.dsn#" name="listaDet">
				Select 	#url.TESSPid# as TESSPid,
						a.DdocumentoId as DocId,
						a.Dfecha as Fecha,
						'Devolución de ' #LvarCNCT# ta.CCTdescripcion #LvarCNCT# ' ' #LvarCNCT# a.Ddocumento as Descripcion,
						a.Dsaldo-a.TESDPaprobadoPendiente as Monto
					<cfif isdefined("form.chkCancelados")>
						, 1 as chkCancelados
					</cfif>
					, 1 as AltaDet	
				  from Documentos a
					inner join CCTransacciones ta
						 on ta.Ecodigo		= a.Ecodigo
						and ta.CCTcodigo	= a.CCTcodigo
						and ta.CCTtipo 		= 'C'
						and coalesce(ta.CCTpago,0) != 1
				 where a.Ecodigo	= #session.Ecodigo#
				   and a.SNcodigo 	= #rsForm.SNcodigoOri#
				   and a.Dsaldo-a.TESDPaprobadoPendiente > 0
				   and a.Mcodigo = #rsForm.McodigoOri#
				   and not exists(
						select 1 from TESdetallePago dp
						 where dp.EcodigoOri = a.Ecodigo
						   and dp.TESDPestado in (0,1)
						   and dp.TESDPidDocumento = a.DdocumentoId
					)
			</cfquery>
		</cfif>		
		
		<cfif isdefined("LvarIncluyeForm") and LvarIncluyeForm>
			<cfset LvarIncluyeForm = "yes">
			<cfset LvarCheckBoxes = "S">
			<cfset LvarBoton = "Seleccionar">
		<cfelse>
			<cfset LvarIncluyeForm = "no">
			<cfset LvarCheckBoxes = "N">
			<cfset LvarBoton = "">
		</cfif>
		
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#listaDet#"
			desplegar="Fecha, Descripcion, Monto"
			etiquetas="Fecha, Descripci&oacute;n, Saldo"
			formatos="D,S,M"
			align="left,left,right"
			ira="solicitudesAnt#LvarTipoAnticipo#_sql.cfm"
			form_method="post"	
			showEmptyListMsg="yes"
			incluyeForm="#LvarIncluyeForm#"
			checkboxes="#LvarCheckBoxes#"
			showLink="no"
			keys="TESSPid,DocId"
			botones="#LvarBoton#"
		/>							
		<BR>

	<cf_web_portlet_end>
</cfif>
