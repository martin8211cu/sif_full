<cf_templatecss>
<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>
	<cfset form.RHEid = url.RHEid>
</cfif>

<cfif isdefined("form.btn_Eliminar") and isdefined("form.chk") and len(trim(form.chk)) and isdefined("form.RHEid") and len(trim(form.RHEid)) >
	<cftransaction>		
		<cfloop list="#form.chk#" delimiters="," index="i">
			<cfset form.RHSPid = i >
			<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
			<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
				update RHEscenarios
					set RHEcalculado = 0
				where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			<!----//////////////// ELIMINAR REGISTROS DE LA FORMULACION //////////////////------>
			<!---Cortes de la formulacion---->
			<cfquery name="rsCortesF" datasource="#session.DSN#">			
				delete RHCortesPeriodoF
				from RHCFormulacion b
					inner join RHFormulacion c
						on b.RHFid = c.RHFid
						and b.Ecodigo = c.Ecodigo
					inner join RHSituacionActual d
						on c.RHSAid = d.RHSAid
						and c.Ecodigo = d.Ecodigo
						and d.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and d.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
				where RHCortesPeriodoF.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHCortesPeriodoF.RHCFid = b.RHCFid
				  and RHCortesPeriodoF.Ecodigo = b.Ecodigo
			</cfquery>
			<!---Componentes de la formulacion---->
			<cfquery name="rsComponentes" datasource="#session.DSN#">
				delete RHCFormulacion
				from RHFormulacion b
					inner join RHSituacionActual c
						on b.RHSAid = c.RHSAid
						and b.Ecodigo = c.Ecodigo
						and c.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
						and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				where RHCFormulacion.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
					and RHCFormulacion.RHFid = b.RHFid
					and RHCFormulacion.Ecodigo = b.Ecodigo
			</cfquery>
			<!---Registro de la formulacion---->
			<cfquery name="rsFormulacion" datasource="#session.DSN#">
				delete RHFormulacion
				from RHFormulacion a
					inner join RHSituacionActual b
						on a.RHSAid = b.RHSAid
						and a.Ecodigo = b.Ecodigo
						and b.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
			</cfquery>
			<!----/////////////// ELIMINAR REGISTROS DE LA SITUACION ACTUAL ///////////////----->
			<!---Eliminar los detalles primero---->
			<cfquery name="rsDetalles" datasource="#session.DSN#">
				delete RHCSituacionActual
				from RHCSituacionActual cp
					inner join RHSituacionActual pe
						on cp.RHSAid = pe.RHSAid
						and cp.Ecodigo = pe.Ecodigo
				where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and pe.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
			</cfquery>
			<!----Eliminar encabezados---->	
			<cfquery name="rsElimina" datasource="#session.DSN#">
				delete from RHSituacionActual
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
			</cfquery>		
		</cfloop>
	</cftransaction>
	<script type="text/javascript" language="javascript1.2">
		window.opener.document.formSolicitudPlaza.submit();		
		window.close();
	</script>
</cfif>

<cfoutput>
<form name="form1" action="" method="post">
    <table width="98%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Eliminar Solicitudes de Plaza</strong></td>
		</tr>
		<tr><td colspan="2" align="center">
			<table width="95%" align="center"><tr><td>
				<hr>
			</td></tr></table>
		</td></tr>
		<tr><td width="15%">&nbsp;</td></tr>
		<tr>
			<td width="69%" colspan="2">
				<cfset navegacion = "&RHEid=#form.RHEid#" >
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="distinct #form.RHEid# as RHEid, pe.RHSPid,sp.RHSPconsecutivo,sp.RHSPfdesde,sp.RHSPfhasta"
					etiquetas="Solicitud, Fecha Desde, Fecha Final"
					tabla="RHSituacionActual pe
						inner join RHSolicitudPlaza sp
							on pe.RHSPid = sp.RHSPid
							and pe.Ecodigo = sp.Ecodigo"
					keys="RHSPid"
					filtro="pe.Ecodigo = #Session.Ecodigo#
						and pe.RHEid = #form.RHEid# 
						Order by RHSPconsecutivo"
					mostrar_filtro="true"
					filtrar_automatico="true"
					desplegar="RHSPconsecutivo,RHSPfdesde,RHSPfhasta"
					filtrar_por="RHSPconsecutivo,RHSPfdesde,RHSPfhasta"
					align="left,left,left"
					formatos="S,D,D"
					ira=""
					maxrows="25"
					showemptylistmsg="true"
					incluyeform="false"
					formname="form1"
					checkboxes="S"
					navegacion="#navegacion#"
					showlink="false" />
		  </td>
		</tr>
		<tr><td>&nbsp;</td></tr>	
		<tr>
	  		<td colspan="2" align="center">
				<table>
					<tr>
						<td>
							<input type="submit" name="btn_eliminar" value="Eliminar" onclick="javascript: if (confirm('Desea eliminar del escenario las solicitudes de plaza seleccionadas?')){ return eliminar(); } return false;" />
						</td>
						<td>
							<input type="button" name="btn_cerrar" value="Cerrar" onclick="javascript: window.close();" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	  <tr><td>&nbsp;</td></tr>
	  <tr><td>&nbsp;</td></tr>	
    </table>
</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function funcFiltrar(){
		document.form1.RHEID.value = <cfoutput>#form.RHEid#</cfoutput>;
		return true;
	}
	
	function eliminar(){
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				return (document.form1.chk.checked);
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) return true;
				}
			}
		}
		alert('Debe seleccionar al menos una Solicitud de Plaza para ser eliminada.')
		return false;
	}
</script>