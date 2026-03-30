<!---
	*************************************************
		Módulo    : Control de Reponsables
		Nombre   : Reporte de Activos en Tránsito
	*************************************************
		Hecho por: Randall Colomer Villalta
		Creado    : 16 Junio 2006
	*************************************************
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
	*************************************************
--->

<cfinclude template="../../../Utiles/sifConcat.cfm">
<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query" output="no">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
<cfset contenidohtml = "">
<cfset registrosxcontext = 500>
<cfset tempfile = GetTempDirectory()>

<cfif isdefined("Form.formato") and trim(Form.formato) EQ "tabs">
	<cfset session.tempfile_xls = #tempfile# & "tmp_" & #session.Ecodigo# & "_" & #session.usuario# & ".xls">
	<cffile action="write" file="#session.tempfile_xls#" output="" nameconflict="overwrite">
    <cfset LvarExtensionArchivo = ".xls">
<cfelseif isdefined("Form.formato") and trim(Form.formato) EQ "comas">
	<cfset session.tempfile_xls = #tempfile# & "tmp_" & #session.Ecodigo# & "_" & #session.usuario# & ".txt">
	<cffile action="write" file="#session.tempfile_xls#" output="" nameconflict="overwrite">
    <cfset LvarExtensionArchivo = ".txt">
</cfif>
<!--- Exportar a Excel --->
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		document.form1.submit();
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
		tablabotones.style.display = 'none';
		window.print();
		tablabotones.style.display = '';
	}


	function SALVAEXCEL() {
		//var EXCEL = document.getElementById("EXCEL");
		//EXCEL.style.visibility='hidden';
		var frame = document.getElementById("FRAMECJNEGRA");
		frame.src = "to_excel.cfm";
	}
	
</script>
<cfsetting enablecfoutputonly="yes" requesttimeout="900">
<!--- Consulta de Activos en Tránsito --->
<cfif isdefined("Form.Estado") and trim(Form.Estado) EQ 1 >
	<cfset tablecolspan = "13">
	<cfsavecontent variable="queryActivoTransito">
		<cfoutput>
		select DISTINCT a.CRDRid,
				a.CFid,
				a.CRCCid,
				a.CRDRplaca, 
				a.CRDRdescdetallada,
				a.CRTDid,
				a.CRTCid,
				a.CRDRfdocumento,
				a.BMUsucodigo,
				a.CRDRserie,
				a.Monto,
				b.CRTDid,
				b.CRTDcodigo,
				b.CRTDdescripcion,
				c.CRTCid,
				c.CRTCcodigo,
				c.CRTCdescripcion,
				d.CRCCid,
				d.CRCCcodigo,
				d.CRCCdescripcion,
				e.Usulogin,  
				f.Pnombre#_Cat#' '#_Cat#f.Papellido1#_Cat#' '#_Cat#f.Papellido2 as Nombre,
				g.CFid,
				g.CFcodigo,
				g.CFdescripcion,
				g.CFidresp,
				i.CFid,
				i.CFcodigo as CFcodigoresp,
				i.CFdescripcion as CFdescripcionresp,
				f.Pid as Pid,
				a.CRorigen,
				h.Odescripcion,
				j.DEidentificacion,
				j.DEnombre#_Cat#' '#_Cat#j.DEapellido1#_Cat#' '#_Cat#j.DEapellido2 as NombreResp
				
		from CRDocumentoResponsabilidad a
			inner join CRTipoDocumento b
				on a.CRTDid = b.CRTDid
			inner join CRTipoCompra c
				on a.CRTCid = c.CRTCid
			inner join CRCentroCustodia d
				on a.CRCCid = d.CRCCid 
			inner join Usuario e
				on a.BMUsucodigo = e.Usucodigo 
				inner join DatosPersonales f
					on e.datos_personales = f.datos_personales
			inner join CFuncional g
				on a.CFid = g.CFid
			inner join Oficinas h
				on g.Ocodigo = h.Ocodigo and h.Ecodigo = #Session.Ecodigo#
			inner join CFuncional i
				on g.CFidresp = i.CFid
			inner join DatosEmpleado j
				on j.DEid = a.DEid				
		where a.Ecodigo = #Session.Ecodigo#
			and a.CRDRestado = 10
			<!--- Filtra por Centro de Custodia --->
			<cfif isdefined("Form.CRCCid") and trim(Form.CRCCid) GT 0 >
				and a.CRCCid = #form.CRCCid#
			</cfif>
			<!--- Filtra por un Rango de Fechas de Transacción --->
			<cfif isdefined("Form.FechaInicio") and len(trim(Form.FechaInicio)) and isdefined("Form.FechaFinal") and len(trim(Form.FechaFinal))>
				<cfif Form.FechaInicio EQ Form.FechaFinal>
					and coalesce ((Select <cf_dbfunction name="Date_Format" args="MAX(cb.CRBfecha),YYYYMMDD">
								   from CRBitacoraTran cb 
								   where cb.Ecodigo = #Session.Ecodigo#
								     and cb.CRBPlaca = a.CRDRplaca
									 and cb.CRDRid = a.CRDRid 
					              	 and CRBmotivo = 6) , <cf_dbfunction name="Date_Format" args="a.CRDRfdocumento,YYYYMMDD"> ) = '#LSDateFormat(LSParseDateTime(Form.FechaInicio),'yyyymmdd')#'
				<cfelse>
					and coalesce ((Select <cf_dbfunction name="Date_Format" args="MAX(cb.CRBfecha),YYYYMMDD">
								   from CRBitacoraTran cb 
								   where cb.Ecodigo = #Session.Ecodigo#
								     and cb.CRBPlaca = a.CRDRplaca
									 and cb.CRDRid = a.CRDRid 
					              	 and CRBmotivo = 6) , <cf_dbfunction name="Date_Format" args="a.CRDRfdocumento,YYYYMMDD">) between '#LSDateFormat(LSParseDateTime(Form.FechaInicio),'yyyymmdd')#'
					and '#LSDateFormat(LSParseDateTime(Form.FechaFinal),'yyyymmdd')#'
				</cfif>
			</cfif>
			<cfif isdefined("Form.FechaInicio") and len(trim(Form.FechaInicio)) and not ( isdefined("Form.FechaFinal") and len(trim(Form.FechaFinal)) )>
				and coalesce ((Select <cf_dbfunction name="Date_Format" args="MAX(cb.CRBfecha),YYYYMMDD">
								   from CRBitacoraTran cb 
								   where cb.Ecodigo = #Session.Ecodigo#
								     and cb.CRBPlaca = a.CRDRplaca
									 and cb.CRDRid = a.CRDRid 
					              	 and CRBmotivo = 6) , <cf_dbfunction name="Date_Format" args="a.CRDRfdocumento,YYYYMMDD">) >= '#LSDateFormat(LSParseDateTime(Form.FechaInicio),'yyyymmdd')#'
			</cfif>
			<cfif isdefined("Form.FechaFinal") and len(trim(Form.FechaFinal)) and not ( isdefined("Form.FechaInicio") and len(trim(Form.FechaInicio)) )>
				and coalesce ((Select <cf_dbfunction name="Date_Format" args="MAX(cb.CRBfecha),YYYYMMDD">
								   from CRBitacoraTran cb 
								   where cb.Ecodigo = #Session.Ecodigo#
								     and cb.CRBPlaca = a.CRDRplaca
									 and cb.CRDRid = a.CRDRid 
					              	 and CRBmotivo = 6) , <cf_dbfunction name="Date_Format" args="a.CRDRfdocumento,YYYYMMDD">) <= '#LSDateFormat(LSParseDateTime(Form.FechaFinal),'yyyymmdd')#'
			</cfif>
		order by d.CRCCcodigo, g.CFcodigo, a.CRDRfdocumento
		</cfoutput>
	</cfsavecontent>
</cfif>

<!--- Consulta de Transacción de Retiro --->
<cfif isdefined("Form.Estado") and trim(Form.Estado) EQ 2>
	<cfsavecontent variable="queryTransacionRetiro">
		<cfoutput>
		select a.CRBPlaca,
				b.CRDRdescdetallada,
				act.Aserie,
				b.Monto,
				c.CRTDid,
				c.CRTDcodigo,
				c.CRTDdescripcion,
				d.CRTCid,
				d.CRTCcodigo,
				d.CRTCdescripcion,
				e.CRCCid,
				e.CRCCcodigo,
				e.CRCCdescripcion, 		
				a.CRBfecha,
				f.Usulogin, 
				g.Pnombre#_Cat#' '#_Cat#g.Papellido1#_Cat#' '#_Cat#g.Papellido2 as Nombre,
				h.CFid,
				h.CFcodigo,
				h.CFdescripcion,
				g.Pid as Pid
		from CRBitacoraTran a
			inner join AFResponsables b
					inner join CRTipoDocumento c
						on b.CRTDid = c.CRTDid
					left outer join CRTipoCompra d
						on b.CRTCid = d.CRTCid
					inner join CRCentroCustodia e
						on b.CRCCid = e.CRCCid
					inner join CFuncional h
						on b.CFid = h.CFid				 
				on a.AFRid = b.AFRid
			inner join Usuario f
					inner join DatosPersonales g
						on f.datos_personales = g.datos_personales
				on a.BMUsucodigo = f.Usucodigo 
			inner join Activos act
				on b.Ecodigo = act.Ecodigo
				and b.Aid = act.Aid
				and Astatus != 60
		where a.Ecodigo = #Session.Ecodigo#
			and a.CRBmotivo = 2
			<!--- Filtra por Centro de Custodia --->
			<cfif isdefined("Form.CRCCid") and trim(Form.CRCCid) GT 0 >
				and b.CRCCid = #form.CRCCid#
			</cfif>
			<!--- Filtra por un Rango de Fechas de Transacción --->
			<cfif isdefined("Form.FechaInicio") and len(trim(Form.FechaInicio)) and isdefined("Form.FechaFinal") and len(trim(Form.FechaFinal))>
				<cfif Form.FechaInicio EQ Form.FechaFinal>
					and <cf_dbfunction name="Date_Format" args="a.CRBfecha,YYYYMMDD"> = '#LSDateFormat(LSParseDateTime(Form.FechaInicio),'yyyymmdd')#'
				<cfelse>
					and <cf_dbfunction name="Date_Format" args="a.CRBfecha,YYYYMMDD"> between '#LSDateFormat(LSParseDateTime(Form.FechaInicio),'yyyymmdd')#'
					and '#LSDateFormat(LSParseDateTime(Form.FechaFinal),'yyyymmdd')#'
				</cfif>
			</cfif>
			<cfif isdefined("Form.FechaInicio") and len(trim(Form.FechaInicio)) and not ( isdefined("Form.FechaFinal") and len(trim(Form.FechaFinal)) )>
				and <cf_dbfunction name="Date_Format" args="a.CRBfecha,YYYYMMDD"> >= '#LSDateFormat(LSParseDateTime(Form.FechaInicio),'yyyymmdd')#'
			</cfif>
			<cfif isdefined("Form.FechaFinal") and len(trim(Form.FechaFinal)) and not ( isdefined("Form.FechaInicio") and len(trim(Form.FechaInicio)) )>
				and <cf_dbfunction name="Date_Format" args="a.CRBfecha,YYYYMMDD"> <= '#LSDateFormat(LSParseDateTime(Form.FechaFinal),'yyyymmdd')#'
			</cfif>
		order by e.CRCCcodigo,h.CFcodigo, a.CRBfecha
		</cfoutput>
	</cfsavecontent>
</cfif>

<cfset Lvar_Title = "Titulo">
<cfset Lvar_FileName = "Archivo">

<!--- Valida para poner el título del Reporte --->
<cfif isdefined("Form.Estado") and trim(Form.Estado) EQ 1>
	<cfset Lvar_Title = "Documento de Activos en Tr&aacute;nsito" >
	<cfset Lvar_FileName = "DocumentoActivosEnTransito">
</cfif>
<cfif isdefined("Form.Estado") and trim(Form.Estado) EQ 2>
	<cfset Lvar_Title = "Documento de Transacciones de Retiro" >
	<cfset Lvar_FileName = "DocumentoActivosRetirados">
</cfif>

<cfset Lvar_FileName = Lvar_FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

<!--- Empieza a pintar el reporte en el usuario cada 10240 bytes los bytes que toma en cuenta son de aquí en adelante omitiendo lo que hay antes, y la informació de los headers de la cantidad de bytes --->
<cfflush interval="10240">

<!--- Variable para controlar la catidad de registros --->
<cfset Lvar_nrecordcount = 0>

<cfif isdefined("Form.formato") and trim(Form.formato) EQ "pantalla">
	<!--- Pintado del Reporte Activos en Tránsito / Transacción de Retiro. --->
    <cf_htmlreportsheaders
        title="#Lvar_Title#" 
        filename="#Lvar_FileName#" 
        ira="ActivosEnTransito.cfm">
	<cfoutput>
		<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
			<tr><td align="center" colspan="6"><cfinclude template="RetUsuario.cfm"></td></tr>
			<tr><td align="center" colspan="6"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
			<tr><td align="center" colspan="6"><font size="2"><strong>#Lvar_Title#</strong></font></td></tr>
			<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid)) gt 0 and form.CRCCid gt 0>
				<cfquery name="rsCRCentroCustodia" datasource="#session.dsn#">
					select CRCCdescripcion
					from CRCentroCustodia
					where CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">
				</cfquery>	
				<tr><td align="center" colspan="6"><strong>Centro de Custodia: #rsCRCentroCustodia.CRCCdescripcion#</strong></td></tr>
			</cfif>
			<tr><td align="center" colspan="6"><strong>Fecha Inicial: #Form.FechaInicio# - Fecha Final: #Form.FechaFinal#</strong></td></tr>
			<tr><td align="center" colspan="8"><hr></td></tr>		
	</cfoutput>
		<!--- Pinta el reporte de Activos en Tránsito --->
		<cfif isdefined("queryActivoTransito") and len(trim(queryActivoTransito)) gt 0>
            <cfquery datasource="#session.dsn#" name="rsActivoTransito">
                #PreserveSingleQuotes(queryActivoTransito)#
            </cfquery>
            <cfset Lvar_bx = false>
            <cfoutput query="rsActivoTransito" group="CRCCid">
                <cfif not Lvar_bx>
                    <cfset Lvar_bx = true>
                    <tr><td nowrap colspan="8" bgcolor="##999999"><strong>Lista de Activos en Tránsito</strong></td></tr>
                    <tr>
                        <td nowrap bgcolor="##CCCCCC" style="padding-left: 40px; "><strong>Placa</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Descripci&oacute;n Detallada</strong></td>
						<td nowrap bgcolor="##CCCCCC"><strong>Serie</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Tipo Documento</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Tipo Compra</strong></td>						
						<td nowrap bgcolor="##CCCCCC"><strong>Monto Adquisici&oacute;n</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Fecha</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Usuario</strong></td>			
                    </tr>
                </cfif>
                <tr>
                    <td nowrap colspan="6"><strong>Centro de Custodia:</strong>&nbsp;#CRCCcodigo# - #CRCCdescripcion#</td>
                </tr>
                <cfoutput group="CFid">
                    <tr>
                        <td nowrap colspan="6" style="padding-left: 20px;"><strong>Centro Funcional:</strong>&nbsp;#CFcodigo# - #CFdescripcion#</td>
                    </tr>
                    <cfoutput>
                    <cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
                    <tr >
                        <td nowrap style="padding-left: 40px; ">#CRDRplaca#</td>
                        <td nowrap>#mid(trim(CRDRdescdetallada),1,40)#</td>
						<td nowrap>#CRDRserie#</td>
                        <td nowrap>#CRTDcodigo# - #CRTDdescripcion#</td>
                        <td nowrap>#CRTCcodigo# - #CRTCdescripcion#</td>						
						<td nowrap>#Monto#</td>
                        <td nowrap>#LSDateFormat(CRDRfdocumento,'dd/mm/yyyy')#</td>
                        <td nowrap>#Usulogin#</td>			
                    </tr>
                    </cfoutput>
                    <tr><td colspan="6" height="10px;"></td></tr>
                </cfoutput>
                <tr><td colspan="6" height="10px;"><hr></td></tr>
            </cfoutput>
		</cfif>
		<!--- Pinta el reporte de Transacciones de Retiro --->
		<cfif isdefined("queryTransacionRetiro") and len(trim(queryTransacionRetiro)) gt 0>
            <cfquery datasource="#session.dsn#" name="rsTransacionRetiro">
                #PreserveSingleQuotes(queryTransacionRetiro)#
            </cfquery>
            <cfset Lvar_by = false>
            <cfoutput query="rsTransacionRetiro" group="CRCCid">
                <cfif not Lvar_by>
                    <cfset Lvar_by = true>
                    <tr><td nowrap colspan="8" bgcolor="##999999"><strong>Lista de Transacciones de Retiro</strong></td></tr>
                    <tr>
                        <td nowrap bgcolor="##CCCCCC" style="padding-left: 40px; "><strong>Placa</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Descripci&oacute;n Detallada</strong></td>
						<td nowrap bgcolor="##CCCCCC"><strong>Serie</strong></td>						
                        <td nowrap bgcolor="##CCCCCC"><strong>Tipo Documento</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Tipo Compra</strong></td>
						<td nowrap bgcolor="##CCCCCC"><strong>Monto Aquisici&oacute;n</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Fecha</strong></td>
                        <td nowrap bgcolor="##CCCCCC"><strong>Usuario</strong></td>			
                    </tr>
                </cfif>
                <tr>
                    <td nowrap colspan="6"><strong>Centro de Custodia:</strong>&nbsp;#CRCCcodigo# - #CRCCdescripcion#</td>
                </tr>
                <cfoutput group="CFid">
                    <tr>
                        <td nowrap colspan="6" style="padding-left: 20px;"><strong>Centro Funcional:</strong>&nbsp;#CFcodigo# - #CFdescripcion#</td>
                    </tr>
                    <cfoutput>
                    <cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
                    <tr >
                        <td nowrap style="padding-left: 40px; ">#CRBPlaca#</td>
                        <td nowrap>#mid(trim(CRDRdescdetallada),1,40)#</td>
						<td nowrap>#Aserie#</td>
                        <td nowrap>#CRTDcodigo# - #CRTDdescripcion#</td>
                        <td nowrap>#CRTCcodigo# - #CRTCdescripcion#</td>						
						<td nowrap>#Monto#</td>
                        <td nowrap>#LSDateFormat(CRBfecha,'dd/mm/yyyy')#</td>
                        <td nowrap>#Usulogin#</td>			
                    </tr>
                    </cfoutput>
                    <tr><td colspan="6" height="10px;"></td></tr>
                </cfoutput>
                <tr><td colspan="8" height="10px;"><hr></td></tr>
            </cfoutput>
		</cfif>
		<cfif Lvar_nrecordcount gt 0>
			<cfset Lvar_smsg = "Fin de la Consulta">
		<cfelse>
			<cfset Lvar_smsg = "No se encontraron registros que cumplan los filtros">
		</cfif>
	<cfoutput>
		<tr><td align="center" colspan="6"><strong> --- #Lvar_smsg# ---  </strong></td></tr>
	</table>
	</cfoutput>
<cfelseif isdefined("Form.formato") and (trim(Form.formato) EQ "tabs" or trim(form.formato) eq "comas")>
	<cfset fnGeneraSalida()>
</cfif>

<!--- *************************************************************************** --->
<cffunction name="fnGraba" output="no" access="private">
	<cfargument name="contenido" required="yes">
	<cfargument name="fin" required="no" default="no">
	<cfset contenido = replace(contenido,"  "," ","All")>
	<cfset contenidohtml = contenidohtml & contenido>
    <cfif len(contenidohtml) GT 1024 or fin>
		<cffile action="append" file="#tempfile#" output="#contenidohtml#">
		<cfset contenidohtml = "">
	</cfif>
</cffunction>  
<!--- *************************************************************************** --->
<cffunction name="fnGeneraSalida" output="no" access="private">
	<cfset tempfile = session.tempfile_xls>
    <cfset Lvarseparador = ",">
    <cfif trim(Form.formato) EQ "tabs">
    	<cfset Lvarseparador = chr(9)>
	</cfif>
	<!--- Salida del Archivo para Activos en Tránsito / Transacción de Retiro. --->
	<!--- Activos en Tránsito --->
    <cfif isdefined("queryActivoTransito") and len(trim(queryActivoTransito)) gt 0>
        <cfquery datasource="#session.dsn#" name="rsActivoTransito">
            #PreserveSingleQuotes(queryActivoTransito)#
        </cfquery>
        <cfset Lvar_bx = false>
        <cfoutput query="rsActivoTransito">
            <cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
            <cfif not Lvar_bx>
                <cfset Lvar_bx = true>
            </cfif>
            <cfset temp_tab_contenido = trim(CRCCcodigo) & " - " & trim(CRCCdescripcion) & LvarSeparador & trim(CFcodigo) & " - " & trim(CFdescripcion) & LvarSeparador
			& trim(CRDRplaca) & LvarSeparador
            & mid(trim(CRDRdescdetallada),1,40) & LvarSeparador
			& trim(CRDRserie) & LvarSeparador
            & trim(CRTDcodigo) & " - " & trim(CRTDdescripcion) & LvarSeparador
            & trim(CRTCcodigo) & " - " & trim(CRTCdescripcion) & LvarSeparador
			& trim(Monto) & LvarSeparador			
            & LSDateFormat(CRDRfdocumento,'dd/mm/yyyy') & LvarSeparador
            & trim(Usulogin) & chr(13)>

			<cfset fnGraba(temp_tab_contenido,false)>
        </cfoutput>
    </cfif>
	<!--- Transacciones de Retiro --->
    <cfif isdefined("queryTransacionRetiro") and len(trim(queryTransacionRetiro)) gt 0>
        <cfquery datasource="#session.dsn#" name="rsTransacionRetiro">
            #PreserveSingleQuotes(queryTransacionRetiro)#
        </cfquery>
        <cfset Lvar_by = false>
        <cfoutput query="rsTransacionRetiro">
            <cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
            <cfif not Lvar_by>
                <cfset Lvar_by = true>
            </cfif>
            <cfset temp_tab_contenido = trim(CRCCcodigo) & " - " & trim(CRCCdescripcion) & LvarSeparador
                    & trim(CFcodigo) & " - " & trim(CFdescripcion) & LvarSeparador
                    & trim(CRBPlaca) & LvarSeparador
					& trim(Aserie) & LvarSeparador
                    & mid(trim(CRDRdescdetallada),1,40) & LvarSeparador
                    & trim(CRTDcodigo) & " - " & CRTDdescripcion & LvarSeparador
                    & trim(CRTCcodigo) & " - " & CRTCdescripcion & LvarSeparador
					& trim(Monto) & LvarSeparador
                    & LSDateFormat(CRBfecha,'dd/mm/yyyy') & LvarSeparador
                    & trim(Usulogin) & chr(13)>

            <cfset fnGraba(temp_tab_contenido,false)>
        </cfoutput>
    </cfif>
    <cfif Lvar_nrecordcount gt 0>
        <cfset Lvar_smsg = "Fin de la Consulta">
    <cfelse>
        <cfset Lvar_smsg = "No se encontraron registros que cumplan los filtros">
    </cfif>
	<cfset fnGraba(Lvar_smsg & chr(13), false)>
	<cfset fnGraba("Generado #dateformat(now(),"DD/MM/YYYY")# #timeformat(now(),"HH:MM:SS")#", true)>   	
	
	<cfif Lvar_nrecordcount gt 0>
        <cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
        <cfheader name="Content-Disposition" value="attachment;filename=reporte-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')##LvarExtensionArchivo#">
		<cfif LvarExtensionArchivo eq ".xls">
			<cfcontent type="application/msexcel" reset="yes" file="#session.tempfile_xls#" deletefile="yes">
		<cfelse>
	        <cfcontent type="text/plain" reset="yes" file="#session.tempfile_xls#" deletefile="yes">
		</cfif>
    </cfif>
</cffunction>
