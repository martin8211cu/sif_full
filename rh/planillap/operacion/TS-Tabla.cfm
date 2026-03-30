<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfparam name="url.RHEid" default="0">
<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>
	<cfset form.RHEid = url.RHEid>
</cfif>
<!----/////////////////////// ELIMINAR TABLA CON SUS HIJOS ///////////////////// ---->
<cfif isdefined("form.RHETEid") and len(trim(form.RHETEid)) and isdefined("form.RHEid") and len(trim(form.RHEid))>

	<!--- Elimina todos los registros asociados a la tabla salarial --->
	<cfinclude template="TS-BorrarTabla.cfm">

	<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
	<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
		update RHEscenarios
			set RHEcalculado = 0
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
	<script type="text/javascript" language="javascript1.2">
		window.document.location.href = "TS-Tabla.cfm?RHEid="+<cfoutput>#form.RHEid#</cfoutput>;
		window.close();
	</script>
</cfif>
<!----- ////////////////////// MANTENIMIENTO  DE LAS TABLAS ///////////////////////----->
<cf_templatecss>
<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcImportar(){
		var params ="?RHEid="+window.parent.document.form1.RHEid.value+"&RHEfdesde="+window.parent.document.form1.RHEfdesde.value+"&RHEfhasta="+window.parent.document.form1.RHEfhasta.value;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-importar.cfm"+params,110,100,800,600);		
	}
	function funcEliminar(prn_RHETEid){
		if( confirm('Este proceso, elimina todos los datos relacionados a la tabla salarial. Desea continuar?') ){
			document.formPlazas.RHETEid.value = prn_RHETEid;
			document.formPlazas.submit();
		}
	}	
</script>
<cfoutput>
<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfquery name="rsTablas" datasource="#session.DSN#">
		select 	a.RHEid,
				a.RHETEid,
				a.RHETEdescripcion,
				b.RHTTcodigo #LvarCNCT#' - '#LvarCNCT# b.RHTTdescripcion as TipoTabla,
				a.RHETEfdesde,
				a.RHETEfhasta,
                case a.RHETEesctabla
                	when  'T' then 'Tabla Salarial'
                    when  'E' then 'Escenario'
                    when  'I' then 'Archivo Importado' 
                end  as Tipo,
                a.RHETEvariacion,
				'<img border=''0'' onClick=''javascript: funcEliminar("'#LvarCNCT# <cf_dbfunction name="to_char" args="a.RHETEid"> #LvarCNCT#'");'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>' as eliminar								
		from RHETablasEscenario a
			inner join RHTTablaSalarial b
				on a.Ecodigo = b.Ecodigo
				and a.RHTTid = b.RHTTid
		where a.Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHEid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
</cfif>
</cfoutput>
<form name="formPlazas" action="" method="post">
	<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHETEid" value=""><!---Llave de la tabla por eliminar--->
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">  
	  <tr>
		<td width="90%" class="tituloListas" >
			<strong style="color:#003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Seleccione la Tabla Salarial</strong>	</td>
			<td width="10%" class="tituloListas"><cf_botones names="Importar" values="Importar"></td>
	  </tr>
	  <tr>
		<td class="tituloListas">&nbsp;</td>
		<td class="tituloListas">&nbsp;</td>
	  </tr>
	  <tr>
		<td valign="top" colspan="2">
			<fieldset>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr class="titulocorte">
					<td width="1%">&nbsp;</td>
					<td width="14%" nowrap="nowrap"><strong>Tipo Tabla&nbsp;</strong></td>
					<td width="50%" nowrap><strong>Descripci&oacute;n&nbsp;</strong></td>
					<td width="12%" nowrap><strong>Fecha desde&nbsp;</strong></td>
					<td width="12%" nowrap><strong>Fecha hasta&nbsp;</strong></td>
                    <td width="8%" nowrap><strong>Variación&nbsp;</strong></td>
                    <td width="12%" nowrap><strong>Origen&nbsp;</strong></td>
					<td width="2%">&nbsp;</td>
				</tr>
				<cfif  isdefined("rsTablas") and  rsTablas.RecordCount NEQ 0>
					<cfoutput query="rsTablas">
						<tr class="<cfif rsTablas.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" style="cursor:pointer;">
							<td width="1%"  onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">&nbsp;</td>
							<td onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">#rsTablas.TipoTabla#</td>
							<td onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">#rsTablas.RHETEdescripcion#</td>
							<td onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">#LSDateFormat(rsTablas.RHETEfdesde,'dd/mm/yyyy')#</td>
							<td onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">#LSDateFormat(rsTablas.RHETEfhasta,'dd/mm/yyyy')#</td>
                            
                            <td onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">#rsTablas.RHETEvariacion#%</td>
                            <td onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">#rsTablas.Tipo#</td>
                            
                            
							<td>#rsTablas.eliminar#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr><td colspan="6" align="center" class="listaPar"><strong>------  No hay tablas salariales asignadas al escenario ------</strong></td></tr>							
				</cfif>				
			</table>	
			</fieldset>	
		</td>
	  </tr>
	  <tr><td>&nbsp;</td></tr>
	</table>
</form>