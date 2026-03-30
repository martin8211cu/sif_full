<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cf_navegacion name="SC_INV" default="-1">
<cfset lvarFiltroEcodigo = #session.Ecodigo#>
<cfif url.SC_INV NEQ -1>
	<cfset LvarCFM_form		= "solicitudes_IN.cfm">
<cfelse>
	<cfset LvarCFM_form		= "solicitudes.cfm">
</cfif>
<cfif isdefined("form.ESidsolicitud")>
	<cfset Session.ImportarDetalleSC.idSol=form.ESidsolicitud>
</cfif>
<cfif isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud)) and not isdefined("form.ESidsolicitud")>
	<cfset form.ESidsolicitud = url.ESidsolicitud >
 	<cfset Session.ImportarDetalleSC.idSol=form.ESidsolicitud>
</cfif>

<cfquery name="rsUsaPlan" datasource="#session.DSN#">
	select Pvalor
		from Parametros
	where Pcodigo = 2300
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!---►►Actividad Empresarial (N-No se usa AE, S-Se usa Actividad Empresarial)◄◄--->
<cfquery name="rsActividad" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'N') as Pvalor
  	from Parametros
   where Pcodigo = 2200
     and Mcodigo = 'CG'
     and Ecodigo = #session.Ecodigo#
</cfquery>
<cfif not rsActividad.RecordCount>
	<cfset rsActividad.Pvalor = 'N'>
</cfif>

<!---►►Descipcion Alterna requierida(0-No es requerida, 1-Se requiere Descripcion alterna)◄◄--->
<cfquery name="rsDescripcionAR" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'0') as Pvalor
  	from Parametros
   where Pcodigo = 5307
     and Mcodigo = 'CM'
     and Ecodigo = #session.Ecodigo#
</cfquery>
<cfif not rsDescripcionAR.RecordCount>
	<cfset rsDescripcionAR.Pvalor = 'N'>
</cfif>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	function funcAplicar() {
		if (fnAplicar_TESOPFP)
		  if (!fnAplicar_TESOPFP()) return false;
		document.form1.action = 'ordenCompra-solicitud.cfm';
		return true;
	}
</script>

<cfset solicitante = -1 >
<cfif isdefined("session.compras.solicitante") and len(trim(session.compras.solicitante))>
	<cfset solicitante = session.compras.solicitante >
</cfif>

<!--- Establecimiento de la navegacion --->
<cfset navegacion = "">
<cfif isdefined("form.ESidsolicitud") and len(trim(form.ESidsolicitud)) >
	<cfset navegacion = navegacion & "&ESidsolicitud=#form.ESidsolicitud#">
</cfif>

<!--- establecimiento de los modos (ENC y DET)--->
<cfset modo  = 'ALTA'>
<cfset dmodo = 'ALTA'>
<cfif isdefined("form.ESidsolicitud") and len(trim(form.ESidsolicitud))>
	<cfset modo = 'CAMBIO'>
	<cfif isdefined("form.DSLinea") and len(trim(form.DSLinea))>
		<cfset dmodo = 'CAMBIO'>
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsDetalles" datasource="#session.DSN#">
		select *
		from DSolicitudCompraCM
		where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
		  and Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></td></tr>

	<form action="solicitudes-sql.cfm" method="post" name="form1" onSubmit="javascript: return valida();" >
    	<input type="hidden" name="fechaHoy" value="<cfoutput>#LSDATEFORMAT(NOW(),'DD/MM/YYYY')#</cfoutput>">
		<cfif url.SC_INV NEQ -1>
			<input type="hidden" name="SC_INV" value="1">

		</cfif>
        <cfif modo neq "ALTA">
		  <input type="hidden" name="Sid" value="<cfoutput >#form.ESidsolicitud#</cfoutput>"/>
        </cfif>
		<tr><td>
			<br>
			<table width="99%" cellpadding="0" cellspacing="0" align="center">
				<tr><td class="subTitulo" align="center"><font size="2">Encabezado de Solicitud de Compra</font></td></tr>
				<tr>
					<td align="center"><cfinclude template="solicitudesE-form.cfm"></td>
				</tr>

				<cfif modo neq "ALTA">
					<cfquery name="rsPreTotales" datasource="#session.DSN#">
					  select coalesce((DScant*DSmontoest),0) as subtotal,
					  		coalesce(round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0) as MotoIEPS,
						  case when (b.DStipo = 'S' or b.DStipo = 'A') and (COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1) THEN
						    coalesce(round(DScant*DSmontoest,2),0)
						  else
						    coalesce(round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
						  end as baseIVA,

						  case when (b.DStipo = 'S' or b.DStipo = 'A') and (COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1) THEN
						    coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2),0)
						  else
						    coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2),0)
						  end as IVA,

						  case when (b.DStipo = 'S' or b.DStipo = 'A') and (COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1) THEN
						    coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2) +
						    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
						  else
						    coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) +
						    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
						  end as MontoT
					   from ESolicitudCompraCM a
							inner join DSolicitudCompraCM b
								on a.ESidsolicitud=b.ESidsolicitud
							inner join Impuestos c
								on a.Ecodigo=c.Ecodigo
								and b.Icodigo=c.Icodigo
							left join Impuestos d
								on a.Ecodigo=d.Ecodigo
								and b.codIEPS=d.Icodigo
							left join Conceptos e
								on e.Cid = b.Cid

							left join Articulos f
								on f.Aid= b.Aid

					   where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
					</cfquery>

			<cfif rsPreTotales.recordcount gt 0>
					<cfquery name="rsTotales" dbtype="query">
						select sum(MotoIEPS) as TotalIEPS, sum(baseIVA) as TbaseIVA, sum(IVA) as impuesto,
						sum(MontoT) as STMontoT, sum(subtotal) as subtotal
						from rsPreTotales
					</cfquery>
			</cfif>
					<!--- <cfquery name="rsTotales" datasource="#session.DSN#">
						select coalesce(sum(round(ROUND(DScant*DSmontoest,2) * COALESCE(d.ValorCalculo/100,0),2)),0)  as TotalIEPS,
				   coalesce(sum(DScant*DSmontoest),0) as subtotal,
				   coalesce(sum(round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)),0) as TbaseIVA,
				   coalesce(sum(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2)),0) as impuesto,
				   coalesce(sum(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) +
							round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)),0) as STMontoT
						from ESolicitudCompraCM a
							inner join DSolicitudCompraCM b
								on a.ESidsolicitud=b.ESidsolicitud
							inner join Impuestos c
								on a.Ecodigo=c.Ecodigo
								and b.Icodigo=c.Icodigo
							left join Impuestos d
								on a.Ecodigo=d.Ecodigo
								and b.codIEPS=d.Icodigo

						where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
					</cfquery> --->

					<!---Si no esta Definido el Parametro o es una requisicion, no aplica el plan de Compras--->
					<cfif rsUsaPlan.Recordcount EQ 0 OR NOT LEN(TRIM(rsUsaPlan.Pvalor)) OR dataTS.CMTSconRequisicion NEQ 0>
						 <cfset rsUsaPlan.Pvalor = 0>
	 				</cfif>

					<tr><td>&nbsp;</td></tr>
					<tr><td class="subTitulo" align="center"><font size="2">Detalle de Solicitud de Compra</font></td></tr>
					<tr>
						<td><cfinclude template="solicitudesD-form.cfm"></td>
					</tr>
				</cfif>

				<!--- ============================================================================================================ --->
				<!---  											Botones													           --->
				<!--- ============================================================================================================ --->
				<tr><td >&nbsp;</td></tr>

				<!--- Integración con Proces de Solicitude Compra Rechazadas --->
				<cfif isdefined("Request.OCRechazada.ModoRechazo") and Request.OCRechazada.ModoRechazo>
					<input type="hidden" name="Action" value="<cfoutput>#Request.OCRechazada.Action#</cfoutput>">
					<cfset ocuBotByReqRech = true>
				<cfelse>
					<cfset ocuBotByReqRech = false>
				</cfif>

				<!-- Caso 1: Alta de Encabezados -->
				<cfif modo EQ 'ALTA'>
					<tr>
						<td align="center">
							<input type="submit" name="btnAgregarE" value="Agregar" tabindex="1" class="btnGuardar">
							<input type="reset"  name="btnLimpiar"  value="Limpiar" tabindex="1" class="btnLimpiar">
						</td>
					</tr>
				</cfif>

				<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
				<cfif modo neq 'ALTA' and dmodo eq 'ALTA' >
					<!--- Averiguar si hay que solicitar una pantalla intermedia para solicitar los datos para el encabezado de Orden de Compra --->
					<cfquery name="rsCompraDirecta" datasource="#Session.DSN#">
						select b.CMTScompradirecta
						from ESolicitudCompraCM a, CMTiposSolicitud b
						where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.Ecodigo = b.Ecodigo
						and a.CMTScodigo = b.CMTScodigo
					</cfquery>
					<tr>
					  <td align="center" valign="baseline" colspan="8">
         					<cfif rsUsaPlan.Pvalor neq 1>
								  <input type="submit"  id="btnAgregarD" name="btnAgregarD" value="Agregar" tabindex="13" class="btnGuardar" >
							</cfif>
							<cfif rsCompraDirecta.CMTScompradirecta EQ 1>
								<cfif isdefined("rsDetalles") and rsDetalles.recordCount gt 0>
									<input type="submit" name="btnAplicar"   tabindex="14" class="btnAplicar"  value="Aplicar" onClick="javascript:if( funcAplicar() ){ validar=false; return true;} return false;">
								</cfif>
							<cfelse>
								<cfif isdefined("rsDetalles") and rsDetalles.recordCount gt 0>
									<input type="submit" name="btnAplicar" 	 tabindex="15" class="btnAplicar"   value="Aplicar" onClick="javascript:if( confirm('Desea aplicar la Solicitud?') ){ validar=false; return true;} return false;">
								</cfif>
							</cfif>
							<cfif not ocuBotByReqRech>
									<input type="submit"  name="btnBorrarE"   id="btnRegresar"  tabindex="16" class="btnEliminar"  value="Borrar Solicitud" 	onClick="javascript:if ( confirm('Desea eliminar el registro de solicitud?') ){validar=false; return true;} return false;" >
							</cfif>
									<input type="reset"   name="btnLimpiar"   id="btnRegresar"  tabindex="17" class="btnLimpiar"   value="Limpiar">
                                    <input type="button"   name="btnImportar"   id="btnImportar"  tabindex="20" class="btnNormal"   value="Importar Detalle" onClick="javascript:location.href='ImportarDetalleSolCompra-form.cfm'">
							<cfif ocuBotByReqRech>
									<input type="submit"  name="btnRegresar"  id="btnRegresar"  tabindex="18" class="btnAnterior"  value="Regresar"  			onClick="javascript:validar=false;">
							</cfif>
							<cfif rsUsaPlan.Pvalor eq 1>
									<input type="button"  name="btnPlan"  	  id="btnPcompras"  tabindex="19" class="btnNormal"    value="Plan de Compras"  	 onClick="PlanCompras()">
						    </cfif>
						    <cfif rsTipos.CMTScontratos eq 1>
						    	<input type="button" name="btnContratos"  value="Contratos" tabindex="1" class="btnNormal" onClick="javascript:VentanaContratoSolicitud(<cfoutput><cfif isdefined('form.ESidsolicitud') and len(trim(#form.ESidsolicitud#))>#form.ESidsolicitud#</cfif></cfoutput>);">
						    </cfif>
						</td>
					</tr>
				</cfif>

				<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->
				<cfif modo neq 'ALTA' and dmodo neq 'ALTA' >
					<!--- Averiguar si hay que solicitar una pantalla intermedia para solicitar los datos para el encabezado de Orden de Compra --->
					<cfquery name="rsCompraDirecta" datasource="#Session.DSN#">
						select b.CMTScompradirecta
						from ESolicitudCompraCM a, CMTiposSolicitud b
						where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.Ecodigo = b.Ecodigo
						and a.CMTScodigo = b.CMTScodigo
					</cfquery>
					<tr>
						<td align="center" valign="baseline" colspan="8">
								<input type="submit" 	name="btnCambiarD" tabindex="13"  class="btnGuardar"	value="Cambiar">
							<cfif rsCompraDirecta.CMTScompradirecta EQ 1>
								<input type="submit" 	name="btnAplicar"  tabindex="14"  class="btnAplicar" 	value="Aplicar" 			onClick="javascript: funcAplicar(); validar=false; return true; " >
							<cfelse>
								<input type="submit" 	name="btnAplicar"  tabindex="14"  class="btnAplicar" 	value="Aplicar" 			onClick="javascript:if( confirm('Desea aplicar la Solicitud?') ){ validar=false; return true;} return false;">
							</cfif>
                            <cfif modo neq 'ALTA' and dmodo neq 'ALTA' and rsFormDetalle.DStipo eq 'D' >
								<input type="submit" 	name="btnBorrarD"  tabindex="15"  class="btnEliminar" 	value="Borrar Distribuci&oacute;n" 		onClick="javascript: if ( confirm('Desea eliminar todos los registros de la Distribución?') ){validar=false; return true;} return false;" >
                            <cfelse>
                               <input type="submit" 	name="btnBorrarD"  tabindex="15"  class="btnEliminar" 	value="Borrar Línea" 		onClick="javascript: if ( confirm('Desea eliminar el registro de detalle?') ){validar=false; return true;} return false;" >
                            </cfif>

							<cfif not ocuBotByReqRech>
								<input type="submit" 	name="btnBorrarE"  tabindex="16"  class="btnEliminar"  	value="Borrar Solicitud" 	onClick="javascript:if ( confirm('Desea eliminar el registro de solicitud?') ){validar=false; return true;} return false;" >
							</cfif>
								<input type="submit" 	name="btnNuevoD"   tabindex="17"  class="btnNuevo"		value="Nueva Línea" 		onClick="javascript:validar=false;" >
								<input type="reset"  	name="btnLimpiar"  tabindex="18"  class="btnLimpiar"	value="Limpiar" >
							<cfif ocuBotByReqRech>
								<input type="submit"  	name="btnRegresar" tabindex="19" class="btnAnterior"	value="Regresar" 			onClick="javascript:validar=false;">
							</cfif>
						</td>
					</tr>
				</cfif>
				<!-- ============================================================================================================ -->
				<!-- ============================================================================================================ -->
			</table>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</form>

	<tr>
		<td align="center">
			<table width="99%" align="center" >
				<tr><td>
					<cfif modo neq 'ALTA' >
					<cf_dbfunction name="to_char" args="a.DSlinea" returnvariable="DSlinea">
					<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return AlmacenarObjetos('+ #PreserveSingleQuotes(DSlinea)# +');''><img border=''0'' id=''img'+ #PreserveSingleQuotes(DSlinea)# +'''  src=''/cfmx/sif/imagenes/OP/folder-go.gif''>'" returnvariable="DocAD" delimiters="+">
                    <cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return AlmacenarObjetos('+ #PreserveSingleQuotes(DSlinea)# +');''><img border=''0'' id=''img'+ #PreserveSingleQuotes(DSlinea)# +'''  src=''/cfmx/sif/imagenes/ftv2folderopen.gif''>'" returnvariable="DocSAD" delimiters="+">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select  a.ESidsolicitud,
									a.ESnumero,
									a.DSconsecutivo,
									a.DSlinea,
									'<label style="font-weight:normal" title="'#_Cat# a.DSdescripcion #_Cat#'">' #_Cat# <cf_dbfunction name='sPart' args='a.DSdescripcion|1|50' delimiters='|'> #_Cat# case when <cf_dbfunction name="length" args="a.DSdescripcion"> > 50 then '...' else '' end as DSdescripcion,
                                     case when (select count(*) from DDocumentosAdjuntos dax where dax.DSlinea= a.DSlinea) > 0
                                     		then #PreserveSingleQuotes(DocAD)#
                                            else #PreserveSingleQuotes(DocSAD)#
                                            end as Doc,
									<!---a.DSdescripcion, --->
									a.DSobservacion,
									case DStipo
										when 'A' then 'Art&iacute;culo'
										when 'F' then 'Activo Fijo'
										when 'S' then 'Servicio'
										when 'P' then 'Obras en Construcci&oacute;n'
										end as Tipo,
									case DStipo
										when 'A' then e.Acodigo
										when 'F' then '-'
										when 'S' then f.Ccodigo
										when 'P' then f.Ccodigo end as Codigo,
									DScant,
									#LvarOBJ_PrecioU.enSQL_AS("DSmontoest")#,
									round(DScant*DSmontoest,2) as Subtotal,

									round(ROUND(DScant*DSmontoest,2)* COALESCE(h.ValorCalculo/100,0),2) as IEPS,

									case when (a.DStipo = 'S' or a.DStipo = 'A') and (f.afectaIVA = 1 or e.afectaIVA=1) THEN
								    	round(round(DScant*DSmontoest,2) * d.Iporcentaje/100,2)
									else
									    round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(h.ValorCalculo/100,0),2)) * d.Iporcentaje/100,2)
									end as Impuesto,


									case when (a.DStipo = 'S' or a.DStipo = 'A') and (f.afectaIVA = 1 or e.afectaIVA=1) THEN
									    round(round(DScant*DSmontoest,2) * d.Iporcentaje/100,2) +
									    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(h.ValorCalculo/100,0),2)
									else
									    round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(h.ValorCalculo/100,0),2)) * d.Iporcentaje/100,2) +
									    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(h.ValorCalculo/100,0),2)
									end as  DStotallinest
							<cfif url.SC_INV NEQ -1>
								, 1 as SC_INV
							</cfif>
							from DSolicitudCompraCM a

							inner join ESolicitudCompraCM b
									on a.Ecodigo=b.Ecodigo
								 and a.ESidsolicitud=b.ESidsolicitud

							inner join CMSolicitantes c
									on b.CMSid=c.CMSid
								 and b.Ecodigo=c.Ecodigo

							inner join Impuestos d
									on a.Icodigo=d.Icodigo
								 and a.Ecodigo=d.Ecodigo

							left join Articulos e
								on a.Aid = e.Aid

							left join Conceptos f
							  on a.Cid = f.Cid

							left join Impuestos h
							  on a.Ecodigo=h.Ecodigo
							  and a.codIEPS=h.Icodigo

							left outer join OBobra OB
								inner join  OBproyecto OP
									on OP.OBPid = OB.OBPid
								on OB.OBOid = a.OBOid

							where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
							  and a.Ecodigo		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by DSconsecutivo, Tipo
						</cfquery>
						<cfif isdefined("Request.OCRechazada.ModoRechazo") and Request.OCRechazada.ModoRechazo>
							<cfset action = Request.OCRechazada.Action>
						<cfelse>
							<cfset action = "#LvarCFM_form#">
						</cfif>

						<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="DSconsecutivo, Tipo, Codigo, DSdescripcion, DScant, DSmontoest, Subtotal, IEPS, Impuesto, DStotallinest, Doc"/>
							<cfinvokeargument name="etiquetas" value="Línea, Tipo, Codigo, Descripcion, Cantidad, Monto, SubTotal, IEPS, Impuesto, Total, Documentos"/>
							<cfinvokeargument name="formatos" value="V, V, V, V, M, M, M, M, M, M, U"/>
							<cfinvokeargument name="align" value="left, left, left, left, right, right, right, right, right, right, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="n"/>
							<cfinvokeargument name="irA" value="#action#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke>
					<cfelse>
						<cfif not isdefined('Form.btnNuevo')>
							<cf_navegacion name="SC_INV" default="-1">
							<cfif url.SC_INV NEQ -1>
								<cflocation addtoken="no" url='solicitudes-lista_IN.cfm?SC_INV=1'>
							<cfelse>
								<cflocation addtoken="no" url='solicitudes-lista.cfm'>
							</cfif>
						</cfif>
					</cfif>
				</td></tr>

				<cfif modo neq 'ALTA'>
					<cfoutput>
					<tr><td>
                      <hr width="100%" align="center">
                      <form name="form2" style="margin:0; " >
						<cfif url.SC_INV NEQ -1>
							<input type="hidden" name="SC_INV" value="1">
						</cfif>
					  <table align="right" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="right"><strong>SubTotal:&nbsp;</strong></td>
								<td align="right">
									<cfif modo EQ "CAMBIO" >
										<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_subtotal" name="subtotal" value="<cfif rsPreTotales.recordcount gt 0>#LSCurrencyFormat(rsTotales.subtotal,'none')#<cfelse>0</cfif>">
										<!---#LSCurrencyFormat(rsTotales.subtotal,'none')#--->
									<cfelse>
										<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_subtotal" name="subtotal" value="0.00">
									</cfif>
								</td>
							</tr>

							<tr>
								<td align="right"><strong>IEPS:&nbsp;</strong></td>
								<td align="right">
									<cfif modo EQ "CAMBIO" >
										<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_ieps" name="_ieps" value="<cfif rsPreTotales.recordcount gt 0>#LSCurrencyFormat(rsTotales.TotalIEPS,'none')#<cfelse>0</cfif>">
									<cfelse>
										<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_ieps" name="_ieps" value="0.00">
									</cfif>
								</td>
							</tr>

							<tr>
								<td align="right"><strong>Base para el IVA:&nbsp;</strong></td>
								<td align="right">
									<cfif modo EQ "CAMBIO" >
										<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_baseIVA" name="baseIVA" value="<cfif rsPreTotales.recordcount gt 0>#LSCurrencyFormat(rsTotales.TbaseIVA,'none')#<cfelse>0</cfif>">
									<cfelse>
										<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_baseIVA" name="baseIVA" value="0.00">
									</cfif>
								</td>
							</tr>

							<tr>
								<td align="right"><strong>Impuesto:&nbsp;</strong></td>
								<td align="right">
									<cfif modo EQ "CAMBIO">
										<input class="cajasinbordeb" type="text" style="text-align:right" readonly id="_impuesto" name="_impuesto" value="<cfif rsPreTotales.recordcount gt 0>#LSCurrencyFormat(rsTotales.impuesto,'none')#<cfelse>0</cfif>">
									<cfelse><input class="cajasinbordeb" readonly style="text-align:right" type="text" id="_impuesto" name="_impuesto" value="0.00">
									</cfif>
								</td>
							</tr>

							<tr>
								<td align="right"><strong>Total Estimado:&nbsp;</strong></td>
								<td align="right">
									<cfif modo EQ "CAMBIO">
										<input class="cajasinbordeb" type="text" style="text-align:right; " readonly id="_total" name="_total" value="<cfif rsPreTotales.recordcount gt 0>#LSCurrencyFormat(rsTotales.STMontoT,'none')#<cfelse>0</cfif>">
									<cfelse><input class="cajasinbordeb" readonly style="text-align:right" type="text" id="_total" name="_total" value="0.00">
									</cfif>
								</td>
							</tr>
					  </table>
					  </form>
					</td></tr>
					</cfoutput>
				</cfif>
			</table>
		</td>
	</tr>
	<tr><td>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td align="right"></td></tr>
		</table>
	</td></tr>
</table>
<script language="javascript1.2" type="text/javascript">
var validar = true;
function valida(){
	if (validar){
		var error = false;
		var Lvarcuenta = '';
		var mensaje = "Se presentaron los siguientes errores:\n";
		// Validacion de Encabezado
		/*if ( trim(document.form1.CFid.value) == '' ){
			error = true;
			mensaje += " - El campo Centro Funcional es requerido.\n";
		}*/
		if ( trim(document.form1.CMTScodigo.value) == '' ){
			error = true;
			mensaje += " - El campo Tipo es requerido.\n";
		}
		if ( trim(document.form1.ESobservacion.value) == '' ){
			error = true;
			mensaje += " - El campo Descripción es requerido.\n";
		}

		if ( document.form1.CMTScompradirecta.value == 1 ){
			if ( trim(document.form1.SNcodigo.value) == '' ){
				error = true;
				mensaje += " - El campo Proveedor es requerido.\n";
			}
		}

		if ( trim(document.form1.Mcodigo.value) == '' ){
			error = true;
			mensaje += " - El campo Moneda es requerido.\n";
		}


		if ( trim(document.form1.EStipocambio.value) == '' ){
			error = true;
			mensaje += " - El campo Tipo de Cambio es requerido.\n";
		}

		if (document.form1.DSfechareq && trim(document.form1.DSfechareq.value) != "" && trim(document.form1.fechaHoy.value) != ""){
			FR = document.form1.DSfechareq.value.split('/');
			FH = document.form1.fechaHoy.value.split('/');
			FRD = new Date(FR[2],FR[1]-1,FR[0]);
			FHD = new Date(FH[2],FH[1]-1,FH[0]);
				if(FRD < FHD){
					error = true;
					mensaje += " - La fecha requerida no puede ser menor al Dia de hoy.\n";
				}
			}


		<cfif modo neq 'ALTA'>

			var MSGvalidar_TESOPFP = '';
			// VALIDACION POR TIPO DE ITEM
			if (document.form1.DStipo.value == 'A'){
				if ( trim(document.form1.Alm_Aid.value) == '' ){
					error = true;
					mensaje += " - El campo Almacén es requerido.\n";
				}
				if ( trim(document.form1.Aid.value) == '' ){
					error = true;
					mensaje += " - El campo Artículo es requerido.\n";
				}
			}
			else if(document.form1.DStipo.value == 'S' || document.form1.DStipo.value == 'D') {
				if ( trim(document.form1.Cid.value) == '' ){
					error = true;
					mensaje += " - El campo Concepto es requerido.\n";
				}
			}
			else if (trim(document.form1.Aid.value) == 'F' ){
				if ( trim(document.form1.ACcodigo.value) == '' ){
					error = true;
					mensaje += " - El campo Categoría es requerido.\n";
				}
				if ( trim(document.form1.ACid.value) == '' ){
					error = true;
					mensaje += " - El campo Clasificación es requerido.\n";
				}
			}

			if ( trim(document.form1.DScant.value) == '' ){
				error = true;
				mensaje += " - El campo Cantidad es requerido.\n";
			}

			if ( new Number(qf(document.form1.DScant.value)) == 0 ){
				error = true;
				mensaje += " - El campo Cantidad es debe ser mayor que cero.\n";
			}

			if ( trim(document.form1.DScant.value) == '' ){
				error = true;
				mensaje += " - El campo Cantidad es requerido.\n";
			}

			if ( trim(document.form1.Icodigo.value) == '' ){
				error = true;
				mensaje += " - El campo Impuesto es requerido.\n";
			}

			if ( trim(document.form1.DSdescripcion.value) == '' ){
						error = true;
						mensaje += " - El campo Descripcion es requerido.\n";
			}

			<!---
				Validacion de la descripción alterna en caso de que este definido en parametros Auxiliares
				y solo para los casos Activos Fijos, Servicios, Articulos de Invetario
			--->
			<cfif rsDescripcionAR.Pvalor eq 'S'>
				if(document.form1.DStipo.value == 'A' || document.form1.DStipo.value == 'S' || document.form1.DStipo.value == 'F')
				{
					if ( trim(document.form1.DSdescalterna1.value) == '' ){
						error = true;
						mensaje += " - El campo Descripcion Alterna es requerido.\n";}
				}
			</cfif>

			if ( trim(document.form1.DSmontoest.value) == '' ){
				error = true;
				mensaje += " - El campo Monto es requerido.\n";
			}
			<cfif NOT isdefined('dataTS.CMTSconRequisicion') OR  dataTS.CMTSconRequisicion EQ 0>
			if ( new Number(qf(document.form1.DSmontoest.value)) == 0 ){
				error = true;
				mensaje += " - El campo Monto debe ser mayor que cero.\n";
			}
			</cfif>

			if ( !document.form1.DSespecificacuenta.checked && trim(document.form1.CFid_Detalle.value) == '' ){
				if(document.form1.DStipo.value != 'D'){
				error = true;
				mensaje += " - El campo Centro Funcional es requerido.\n";
				}
			  }
			else if (document.form1.DStipo.value == 'D' && trim(document.form1.CPDCid.value) == '' )
			   {
     				error = true;
	     			mensaje += " - El campo Distribucion es requerido.\n";
	 		    }
			<cfif rsActividad.Pvalor eq 'S'>
				if(!document.form1.DSespecificacuenta.checked && trim(document.form1.CFid_Detalle.value) != '' && document.form1.DStipo.value != 'D' && (trim(document.form1.actividad_Act.value) == '' || trim(document.form1.actividad_Valores.value) == '')){

					if(document.form1.DStipo.value == 'A')
						Lvarcuenta = document.form1.CFcuentainventario_Detalle.value;
					if(document.form1.DStipo.value == 'S')
						Lvarcuenta = document.form1.CFcuentac_Detalle.value;
					if(document.form1.DStipo.value == 'F')
						Lvarcuenta = document.form1.CFcuentainversion_Detalle.value;
					for(i=0;i<Lvarcuenta.length;i++){
						if(Lvarcuenta.charAt(i)=="_"){
							error = true;
	     					mensaje += " - La Actividad  Empresarial es requerida.\n";
							break;
						}
					}
				}
			</cfif>


			if ( document.form1.DSespecificacuenta.checked && ( trim(document.form1.Ccuenta.value) == '' ) ){
				error = true;
				mensaje += " - El campo Cuenta es requerido.\n";
			}

			if(document.MSGvalidar_TESOPFP) mensaje += MSGvalidar_TESOPFP();
		</cfif>

		if ( error ){
			alert(mensaje);
			return false;
		}
		else{
			//document.form1.EStotalest.value = qf(document.form1.EStotalest.value);
			document.form1.CMTScodigo.disabled 			= false;
			document.form1.EStipocambio.disabled 		= false;
			document.form1.DScant.disabled 				= false;
			document.form1.DSespecificacuenta.disabled 	= false;
			 document.form1.DStipo.disabled = false;


			<cfif modo neq 'ALTA'>
				document.form1.Adescripcion.disabled = false;
				document.form1.Cdescripcion.disabled = false;
				document.form1.Icodigo.disabled = false;
				document.form1.DStipo.disabled = false;
				document.form1.Ucodigo.disabled = false;
				document.form1.DSdescripcion.disabled = false;
				document.form1.DScant.value = qf(document.form1.DScant.value);
				document.form1.DStotallinest.value = qf(document.form1.DStotallinest.value);
				document.form1.DSmontoest.value = qf(document.form1.DSmontoest.value);
				document.form1.DSmontoest.disabled = false;
				document.form1.Icodigo.disabled = false;
			</cfif>
			return true;
		}
	}
	else{
		 document.form1.DStipo.disabled = false;
		return true;
	}
}

</script>
<script language="javascript1.2" type="text/javascript">
function PlanCompras()
{

    		var Lvartipo = '';

			if(document.form1.DStipo.value== 'A')
			  Lvartipo = 'A';
			if(document.form1.DStipo.value== 'F')
			  Lvartipo = 'F';
			if(document.form1.DStipo.value== 'S')
			  Lvartipo = 'S';
			 if(document.form1.DStipo.value== 'P')
			  Lvartipo = 'P';

			var LvarSid =document.form1.Sid.value;

			var LvarTRcodigo =document.form1.TRcodigo.value;
			if(LvarTRcodigo != '')
			{
			Lvartipo = 'A';
			}

			var LvarMcodigo =document.form1.Mcodigo.value;

			var LvarSnum =document.form1.ESnumero.value;

            var LvarCFid = document.form1.CFid.value;
			var LvarCMTS = document.form1.CMTScodigo.value;
			if((Lvartipo != '') && (LvarCFid != ''))
			{
              window.open('solicitudD-PCG.cfm?tipo='+Lvartipo+'&TRcodigo='+LvarTRcodigo+'&CFid='+LvarCFid+'&Sid='+LvarSid+'&ESnumero='+LvarSnum+'&CMTS='+LvarCMTS+'&Mcodigo='+LvarMcodigo,'popup','width=1200,height=700,left=100,top=50,scrollbars=yes');
			}
			else
			{
			 alert("Falta el Tipo en el detalle o el Id del Centro Funcional ");
			}
}
function AlmacenarObjetos(valor){
	if (valor != "")
	   {
        var PARAM  = "ObjetosSolicitudes.cfm?Modulo=SC&DSlinea1="+valor;
	    open(PARAM,'','left=50,top=150,scrollbars=yes,resizable=no,width=1000,height=400');
	   }
		return false;
	}
	function VentanaContratoSolicitud(ESidsolicitud) {
		var params ="";

		params = "&form=form1"

		popUpWindowIns("/cfmx/sif/cm/operacion/popUp-contratoSolicitud.cfm?ESidsolicitud="+ESidsolicitud+"&Ecodigo="+<cfoutput>#lvarFiltroEcodigo#</cfoutput>+params,50,50,window.screen.width/2+290 ,window.screen.height/2);
	}
	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
</script>
