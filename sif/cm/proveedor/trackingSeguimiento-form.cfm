<cfset modo = 'ALTA'>

<cfif isdefined("form.DTidtracking") and len(trim(form.DTidtracking))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery name="rsCourier" datasource="sifcontrol">
	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">

	union

	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo is null
	and Ecodigo is null
	and EcodigoSDC is null

	order by 2
</cfquery>

<cfquery name="rsEstadosTracking" datasource="sifpublica">
	select ETcodigo, ETdescripcion
	from EstadosTracking
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifpublica">
		select a.DTidtracking, 
			   a.ETidtracking, 
			   a.CEcodigo, 
			   a.EcodigoASP, 
			   a.Ecodigo, 
			   a.cncache, 
			   a.DTactividad, 
			   a.DTubicacion, 
			   a.Observaciones, 
			   a.DTtipo, 
			   a.DTfecha, 
			   a.DTfechaincidencia, 
			   a.DTfechaest, 
			   a.BMUsucodigo, 
			   a.CRid, 
			   a.DTnumreferencia, 
			   a.DTcampousuario, 
			   a.DTcampopwd, 
			   a.ETcodigo, 
			   a.DTrecibidopor, 
               a.DTfechaactividad,
               a.CMATid,
			   a.ts_rversion
		from DTracking a
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DTidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DTidtracking#">
	</cfquery>
</cfif>
<cfquery name="rsAct" datasource="sifpublica">
    select count(1) as cantidad from CMActividadTracking where Ecodigo = #session.ecodigo#
</cfquery>

<script type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="javascript1.2" type="text/javascript">
	var valida = true;

	function validar(){
		if (valida){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
			<cfif rsAct.cantidad eq 0>
				if ( trim(document.form1.DTactividad.value) == '' ){
					error = true;
					mensaje += ' - El campo Actividad es requerido.\n '
				}
			<cfelse>
				if ( trim(document.form1.CMATid.value) == '' ){
					error = true;
					mensaje += ' - El campo Actividad es requerido.\n '
				}
				if ( trim(document.form1.DTfechaactividad.value) == '' ){
					error = true;
					mensaje += ' - El campo Fecha Actividad es requerido.\n '
				}
			</cfif>
		
			if ( trim(document.form1.DTfechaincidencia.value) == '' ){
				error = true;
				mensaje += ' - El campo Fecha E/S es requerido.\n '
			}

			if (error){
				alert(mensaje);
			}
	
			return !error
		}
		return true;
	}

	function info_detalle(name,readonly){
		open('trackingSeguimiento-info.cfm?', 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
	
</script>

<!---- Informacion del Encabezado del Tracking ---->
<cfif isdefined("Form.ETidtracking")>
	<cfquery name="dataTracking" datasource="sifpublica">
		select a.ETidtracking, a.ETconsecutivo, a.ETnumtracking, a.CEcodigo, a.EcodigoASP, a.Ecodigo, a.ETcodigo, a.cncache, a.EOidorden, 
			   a.ETnumreferencia, a.CRid, a.ETfechagenerado, a.ETfechaestimada, a.ETfechaentrega, a.ETfechasalida, 
			   a.ETnumembarque, a.ETrecibidopor, 
			   case a.ETmediotransporte 
			   		when 0 then 'Tierra' 
					when 1 then 'Aéreo'
					when 2 then 'Barco'
					when 3 then 'Primera Clase'
					when 4 then 'Prioridad'
					when 5 then 'Otro'
					else ''
			   end as MedioTransporte, 
			   '' as CRdescripcion,
			   a.BMUsucodigo, a.ETestado, 
			   case a.ETestado when 'P' then 'En Proceso' when 'T' then 'En Tránsito' when 'E' then 'Entregado' end as Estado, 
			   a.ETcampousuario, a.ETcampopwd, b.ETdescripcion
		from ETracking a, EstadosTracking b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
		and a.Ecodigo = b.Ecodigo
		and a.ETcodigo = b.ETcodigo
	</cfquery>
	<cfif Len(Trim(dataTracking.CRid))>
		<cfquery name="courierEncabezado" datasource="sifcontrol">
			select CRdescripcion
			from Courier
			where CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTracking.CRid#">
		</cfquery>
		<cfset QuerySetCell(dataTracking, "CRdescripcion", courierEncabezado.CRdescripcion)>
	</cfif>
	
	<cfquery name="dataOrden" datasource="#session.DSN#">
		select EOnumero, Observaciones
		from EOrdenCM
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTracking.Ecodigo#">
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTracking.EOidorden#">
	</cfquery>
	
</cfif>

<!--- Ultimo Estado Tracking --->
<cfquery name="rsEstadoUltimo" datasource="sifpublica">
		select a.DTidtracking, 
			   a.ETidtracking, 
			   a.CEcodigo, 
			   a.EcodigoASP, 
			   a.Ecodigo, 
			   a.cncache, 
			   a.DTactividad, 
			   a.DTubicacion, 
			   a.Observaciones, 
			   a.DTtipo, 
			   a.DTfecha, 
			   a.DTfechaincidencia, 
			   a.DTfechaest, 
			   a.BMUsucodigo, 
			   a.DTnumreferencia, 
			   a.DTcampousuario, 
			   a.DTcampopwd, 
			   a.ETcodigo, 
			   a.DTrecibidopor, 
			   b.CRid,
			   b.ETnumreferencia,
			   a.ts_rversion
		from DTracking a, ETracking b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
		  and a.DTidtracking = (
			select max(DTidtracking) 
			from DTracking
			where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
		    and DTfechaincidencia = (
				select max(DTfechaincidencia)
				from DTracking
				where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
				<cfif modo EQ "CAMBIO">
				and DTidtracking < <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DTidtracking#">
				</cfif>
				and DTtipo <> 'C'
				and DTtipo <> 'M'
				and DTtipo <> 'T'
			)
			<cfif modo EQ "CAMBIO">
			and DTidtracking < <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DTidtracking#">
			</cfif>
		)
		<cfif modo EQ "CAMBIO">
		and a.DTidtracking < <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DTidtracking#">
		</cfif>
		and a.Ecodigo = b.Ecodigo
		and a.ETidtracking = b.ETidtracking
</cfquery>

<cfoutput>
<form name="form1" method="post" action="trackingSeguimiento-sql.cfm" onSubmit="return validar();">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr><td colspan="8" align="center">
		    <table width="98%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro" align="center">
              <tr>
                <td align="right" nowrap class="fileLabel">No. Tracking:</td>
                <td colspan="2" nowrap>#dataTracking.ETconsecutivo#</td>
                <td align="right" nowrap class="fileLabel">No. Control:</td>
                <td nowrap>#dataTracking.ETnumtracking#</td>
                <td align="right" nowrap class="fileLabel">Fecha Salida:</td>
                <td nowrap>
					<cfif Len(Trim(dataTracking.ETfechasalida))>
					#LSDateFormat(dataTracking.ETfechasalida,'dd/mm/yyyy')#
					<cfelse>
					-
					</cfif>
				</td>
                <td colspan="2" rowspan="3" align="center" valign="middle" nowrap>
					<strong>Estado</strong><br>
					#dataTracking.Estado#
				</td>
              </tr>
              <tr>
                <td align="right" nowrap class="fileLabel">No. Orden:</td>
                <td nowrap>#dataOrden.EOnumero#
                </td>
                <td class="fileLabel" align="right" nowrap>Orden de Compra:</td>
                <td colspan="2" nowrap>#dataOrden.Observaciones#</td>
                <td align="right" nowrap class="fileLabel">Fecha Estimada:</td>
                <td nowrap>
					<cfif Len(Trim(dataTracking.ETfechaestimada))>
					#LSDateFormat(dataTracking.ETfechaestimada,'dd/mm/yyyy')#
					<cfelse>
					-
					</cfif>
				</td>
              </tr>
              <tr>
                <td align="right" nowrap class="fileLabel">Courier:</td>
                <td colspan="2" nowrap>#dataTracking.CRdescripcion#</td>
                <td align="right" nowrap class="fileLabel">Tracking Courier:</td>
                <td nowrap>#dataTracking.ETnumreferencia#</td>
                <td align="right" nowrap class="fileLabel">Fecha Llegada:</td>
                <td nowrap>
					<cfif Len(Trim(dataTracking.ETfechaentrega))>
					#LSDateFormat(dataTracking.ETfechaentrega,'dd/mm/yyyy')#
					<cfelse>
					-
					</cfif>
				</td>
              </tr>
              <tr>
                <td align="right" nowrap class="fileLabel">No. Embarque: </td>
                <td colspan="2" nowrap>#dataTracking.ETnumembarque#</td>
                <td align="right" nowrap class="fileLabel">Medio Transporte: </td>
                <td nowrap>#dataTracking.MedioTransporte#</td>
                <td align="right" nowrap class="fileLabel">Recibido por: </td>
                <td nowrap>#dataTracking.ETrecibidopor#</td>
                <td align="right" nowrap class="fileLabel">Estado Tracking:</td>
                <td nowrap>#dataTracking.ETdescripcion#</td>
              </tr>
            </table>
			</td>
		</tr>
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap><strong>Tipo Actividad:</strong>&nbsp;</td>
			<td nowrap>
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="DTtipo" value="#data.DTtipo#">
					<cfif data.DTtipo eq 'C'>
						Consolidacion
					<cfelseif data.DTtipo eq 'M'>
						Transaccion
					<cfelseif data.DTtipo eq 'E'>
						Llegada
					<cfelseif data.DTtipo eq 'T'>
						Entrega
					<cfelseif data.DTtipo eq 'S'>
						Salida					
					</cfif>
				<cfelse>
					<select name="DTtipo" tabindex="1">					
						<cfif rsEstadoUltimo.recordCount GT 0>						
							<cfif rsEstadoUltimo.DTtipo EQ 'S'>
							<option value="E" <cfif modo neq 'ALTA' and data.DTtipo eq 'E'>selected</cfif>>Llegada</option>
							<cfelse>
							<option value="S" <cfif modo neq 'ALTA' and data.DTtipo eq 'S'>selected</cfif>>Salida</option>	
							</cfif>
						<cfelse>
							<option value="S" <cfif modo neq 'ALTA' and data.DTtipo eq 'S'>selected</cfif>>Salida</option>	
						</cfif>
					</select>
				</cfif>
			</td>
            <cfif rsAct.cantidad eq 0>
            <td align="right" nowrap><strong>Actividad:</strong>&nbsp;</td>
            <td><input <cfif modo neq 'ALTA' and (data.DTtipo eq 'C' or data.DTtipo eq 'M' or data.DTtipo eq 'T')>readonly</cfif> type="text" size="30" maxlength="255" name="DTactividad" onFocus="this.select();" tabindex="1" value="<cfif modo neq 'ALTA'>#data.DTactividad#</cfif>"></td>
           <cfelse>
           <td colspan="2">
           	<table border="0" width="100%"><tr>
                <td align="right" nowrap><strong>Actividad:</strong>&nbsp;</td>
                <td>
                <cfset valuesarray = ArrayNew(1)>
                <cfif modo neq 'ALTA' and len(trim(data.CMATid))>
                	<cfquery name="rsActd" datasource="sifpublica">
                        select CMATid,CMATcodigo,CMATdescripcion from CMActividadTracking where Ecodigo = #session.ecodigo# and CMATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CMATid#">
                    </cfquery>
                	<cfset ArrayAppend(valuesarray,"#rsActd.CMATid#")>
                    <cfset ArrayAppend(valuesarray,"#rsActd.CMATcodigo#")>
                    <cfset ArrayAppend(valuesarray,"#rsActd.CMATdescripcion#")>
                </cfif>
                <cf_conlis 
                    title="Actividad por Tracking" 
                    campos = "CMATid,CMATcodigo,CMATdescripcion" 
                    desplegables = "N,S,S" 
                    modificables = "N,S,N"
                    valuesarray = "#valuesarray#"
                    size = "0,10,30"
                    tabla="CMActividadTracking"
                    columnas="CMATid,CMATcodigo,CMATdescripcion"
                    filtro="Ecodigo = #Session.Ecodigo#"
                    desplegar="CMATcodigo,CMATdescripcion"
                    etiquetas="C&oacute;digo, Descripci&oacute;n"
                    formatos="S,S"
                    align="left,left"
                    asignar="CMATid,CMATcodigo,CMATdescripcion"
                    asignarformatos="i,S,S"
                    conexion="sifpublica">
                </td>
                <td align="right" nowrap><strong>Fecha Actividad:</strong>&nbsp;</td>
                <cfif modo neq 'ALTA'>
					<cfset fecha = LSDateFormat(data.DTfechaactividad,'dd/mm/yyyy') >
				<cfelse>
					<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy') >
				</cfif>
            	<td><cf_sifcalendario name="DTfechaactividad" value="#fecha#" tabindex="1"></td>
               	</tr></table>
            </td>
           	</cfif>
			<td align="right" nowrap><strong>Ubicaci&oacute;n:</strong>&nbsp;</td>
			<td nowrap><input type="text" size="30" maxlength="255" name="DTubicacion" onFocus="this.select();" tabindex="1" value="<cfif modo neq 'ALTA'>#data.DTubicacion#</cfif>"></td>
			<td colspan="2" align="center" nowrap>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%">
							<input type="hidden" name="Observaciones" value="<cfif modo neq 'ALTA'>#data.Observaciones#</cfif>">
							<strong>Observaciones</strong>
						</td>	
						<td>
							&nbsp;<img style="cursor: hand;" onClick="javascript:info_detalle()" src="../../imagenes/iedit.gif">
						</td>
					</tr>
				</table>
			</td>
			
			<td>&nbsp;</td>
		</tr>	
		<tr>
			<td align="right" nowrap><strong>Fecha E/S:</strong>&nbsp;</td>
			<td nowrap>				
				<cfif modo neq 'ALTA'>
					<cfset fecha = LSDateFormat(data.DTfechaincidencia,'dd/mm/yyyy') >
				<cfelse>
					<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy') >
				</cfif>
				<cfif modo neq 'ALTA' and (data.DTtipo eq 'C' or data.DTtipo eq 'M' or data.DTtipo eq 'T')>
					<input type="text" name="DTfechaincidencia" size="10" maxlength="11" value="#fecha#" readonly>
				<cfelse>
					<cf_sifcalendario name="DTfechaincidencia" value="#fecha#" tabindex="1">
				</cfif>				
			</td>

			<td align="right" nowrap>
				<cfif (rsEstadoUltimo.recordCount GT 0 and rsEstadoUltimo.DTtipo EQ 'E') or rsEstadoUltimo.recordCount EQ 0>
					<strong>Fecha Estimada Llegada:</strong>&nbsp;
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td nowrap>
				<cfif (rsEstadoUltimo.recordCount GT 0 and rsEstadoUltimo.DTtipo EQ 'E') or rsEstadoUltimo.recordCount EQ 0>
					<cfset fechaest = '' >
					<cfif modo neq 'ALTA' and len(trim(data.DTfechaest)) >
						<cfset fechaest = LSDateFormat(data.DTfechaest,'dd/mm/yyyy') >
					</cfif>
					<cf_sifcalendario name="DTfechaest" tabindex="1" value="#fechaest#">
				<cfelse>
					&nbsp;
				</cfif>
			</td>

			<td align="right" nowrap><strong>Estado:</strong>&nbsp;</td>
			<td colspan="3" nowrap>
				<select name="ETcodigo">
				<cfloop query="rsEstadosTracking">
					<option value="#rsEstadosTracking.ETcodigo#"<cfif modo EQ 'CAMBIO' and rsEstadosTracking.ETcodigo EQ data.ETcodigo> selected</cfif>>#rsEstadosTracking.ETdescripcion#</option>
				</cfloop>
				</select>
			</td>
		</tr>	

		<tr>
			<td align="right" nowrap><strong>Courier:</strong>&nbsp;</td>
			<td nowrap>
				<select name="CRid" tabindex="1">
					<option value="-1">--- Niguno ---</option>	
					<cfloop query="rsCourier">
						<option value="#rsCourier.CRid#" <cfif modo neq 'ALTA' and data.CRid eq rsCourier.CRid> selected<cfelseif rsEstadoUltimo.recordCount GT 0 and rsEstadoUltimo.CRid EQ rsCourier.CRid> selected</cfif>>#trim(rsCourier.CRcodigo)# - #trim(rsCourier.CRdescripcion)#</option>
					</cfloop>
				</select>
			</td>

			<td align="right" nowrap><strong>Tracking Courier:</strong>&nbsp;</td>
			<td nowrap><input type="text" size="30" maxlength="50" name="DTnumreferencia" onFocus="this.select();" tabindex="1" value="<cfif modo neq 'ALTA'>#data.DTnumreferencia#<cfelseif rsEstadoUltimo.recordCount GT 0 and rsEstadoUltimo.CRid EQ rsCourier.CRid>#rsEstadoUltimo.ETnumreferencia#</cfif>"></td>

			<td align="right" nowrap>
				<cfif rsEstadoUltimo.DTtipo EQ 'S'>
					<strong>Recibido por:</strong>&nbsp;
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td colspan="3" nowrap>
				<cfif rsEstadoUltimo.DTtipo EQ 'S'>
					<input type="text" size="30" maxlength="80" name="DTrecibidopor" onFocus="this.select();" tabindex="1" value="<cfif modo neq 'ALTA'>#data.DTrecibidopor#</cfif>">
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		</tr>	

		<tr><td colspan="8">&nbsp;</td></tr>
		<tr>
			<td colspan="8" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="Agregar" tabindex="2">
				<cfelse>	
					<input type="submit" name="Cambio" value="Modificar" tabindex="2">
					<cfif not (data.DTtipo eq 'C' or data.DTtipo eq 'M' or data.DTtipo eq 'T')>
						<input type="submit" name="Baja" value="Eliminar" tabindex="2" onClick="javascript:valida=false; if ( confirm('Desea eliminar el registro?') ){ return true; } else{return false;} ">
					</cfif>
					<input type="submit" name="Nuevo" value="Nuevo" tabindex="2" onClick="javascript:valida=false;">
				</cfif>
				<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href = 'trackingSeguimiento-lista.cfm';">
			</td>
		</tr>
		
		<tr><td colspan="8">&nbsp;</td></tr>
	</table>

	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="DTidtracking" value="#form.DTidtracking#">
	</cfif>

	<!--- Siempre se necesita --->
	<input type="hidden" name="ETidtracking" value="#form.ETidtracking#">
</form>
</cfoutput>