<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfset modo = "ALTA">
<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select 	a.RHEid, a.RHEdescripcion, a.RHGEid, a.RHEtipo, a.RHEobs, 
				a.RHEidorigen, a.RHEfdesde, a.RHEfhasta, a.ts_rversion, coalesce(a.CPPid, 0) as CPPid, coalesce(a.RHEcalculado, 0) as RHEcalculado
		from  RHEscenarios a		
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#"> 
	</cfquery>	
	
	<cfquery name="periodo" datasource="#session.DSN#">
		select 'Presupuesto ' #LvarCNCT#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#LvarCNCT# ' de ' #LvarCNCT# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#LvarCNCT# ' ' #LvarCNCT# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#LvarCNCT# ' a ' #LvarCNCT# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#LvarCNCT# ' ' #LvarCNCT# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}"> as descripcion

		from CPresupuestoPeriodo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CPPid#">
	</cfquery>
</cfif>

<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function conlisCPPid(){
		popUpWindow('conlisCPPid.cfm', 300, 150, 600, 400);
	}

	function funcRegresar(){
		location.href = 'RHEscenarios-lista.cfm';
	}
	function funcCalcularEscenario(){
		if( confirm('Esta seguro que desea calcular el escenario?') ){
			document.form1.action = "PR-CalcularEscenario.cfm";
			document.form1.submit();
		}	
	}

	function funcAplicar(){
		if( confirm('Esta seguro que desea aprobar el escenario?') ){
			document.form1.action = "escenario-aprobar-sql.cfm";
			document.form1.submit();
		}	
	}

</script>
<cfoutput>
<form action="RHEscenario-sql.cfm" method="post" name="form1" id="form1">
	<table width="100%" border="0" cellspacing="0">		
		<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>		
		<tr><td width="9%">&nbsp;</td>
		</tr>
		<tr>
			<td width="9%">&nbsp;</td>
			<td width="16%" align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td width="32%">
				<input name="RHEdescripcion" size="60" id="RHEdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHEdescripcion)#</cfif>" maxlength="80" onfocus="this.select()">
  	  	  </td>

<!---
			<td width="9%" align="right"><strong>Tipo:&nbsp;</strong></td>
			<td width="34%">
				<select name="RHEtipo">				
					<option value="O">Ordinario</option>
					<option value="E">Extraordinario</option>
				</select>
		  </td>
--->		  
		</tr>
		<tr>
			<td width="9%">&nbsp;</td>
			<td align="right" nowrap="nowrap"><strong>Per&iacute;odo Presupuestario:&nbsp;</strong>
			</td>	
			<td colspan="3">
				<input type="hidden" name="CPPid" value="<cfif modo neq 'ALTA'>#data.CPPid#</cfif>" />
				<input type="text" name="CPPdesc" size="60" maxlength="80" readonly="readonly" value="<cfif modo neq 'ALTA'>#periodo.descripcion#</cfif>" />
				<cfif modo eq 'ALTA'><a onclick="javascript:conlisCPPid()"><img src="/cfmx/rh/imagenes/Description.gif" /></a></cfif></td>
		</tr>

<!---
		<tr>
			<td width="9%">&nbsp;</td>
			<td align="right"><strong>Fecha desde:&nbsp;</strong></td>

			<td>

				<cfif (modo EQ "CAMBIO")>
					<cf_sifcalendario name="RHEfdesde" value="#LSDateFormat(data.RHEfdesde,'dd/mm/yyyy')#">				
				<cfelse>
					<cf_sifcalendario name="RHEfdesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
				</cfif> 
			</td>
--->			
<!---
			<td align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
			<td>
				<cfif (modo EQ "CAMBIO")>
					<cf_sifcalendario name="RHEfhasta" value="#LSDateFormat(data.RHEfhasta,'dd/mm/yyyy')#">				
				<cfelse>
					<cf_sifcalendario name="RHEfhasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
				</cfif> 
			</td>
		</tr>	
--->					
		<tr>
			<td width="9%">&nbsp;</td>
			<td align="right" valign="top"><strong>Observaciones:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHEobs" type="text" value="<cfif modo NEQ 'ALTA'>#data.RHEobs#</cfif>" size="95">
				<!----<textarea cols="80"><cfif modo NEQ 'ALTA'>#data.RHEobs#</cfif></textarea>----->
			</td>
		</tr>		
		<tr>
			<td colspan="5" class="formButtons" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" class="btnGuardar" value="Agregar" onClick="javascript: habilitarValidacion();">
					<input type="reset" name="Limpiar" class="btnLimpiar" value="Limpiar">
				<cfelse>
					<input type="submit" name="Cambio" class="btnGuardar" value="Modificar" onClick="habilitarValidacion();">
					<input type="button" name="btn_regresar" class="btnNormal" value="Calcular" onClick="javascript: funcCalcularEscenario();">
					<cfif data.RHEcalculado eq 1 ><input type="button" class="btnAplicar" name="btnAprobar" value="Aplicar" onClick="javascript: funcAplicar();"></cfif>
					<input type="submit" name="Baja" value="Eliminar" class="btnEliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
					<input type="submit" name="Nuevo" class="btnNuevo" value="Nuevo" onClick="deshabilitarValidacion();">
				</cfif>
				<input type="button" name="btn_regresar" value="Regresar" class="btnAnterior" onClick="javascript: location.href='RHEscenarios-lista.cfm';">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHEid" value="#data.RHEid#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
		<input type="hidden" name="RHEfdesde" value="<cfif modo EQ 'CAMBIO'>#LSDateFormat(data.RHEfdesde,'dd/mm/yyyy')#</cfif>" />
		<input type="hidden" name="RHEfhasta" value="<cfif modo EQ 'CAMBIO'>#LSDateFormat(data.RHEfhasta,'dd/mm/yyyy')#</cfif>" />

</form>	
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	//objForm.RHEtipo.required = true;
	//objForm.RHEtipo.description="Tipo";				
	objForm.RHEdescripcion.required= true;
	objForm.RHEdescripcion.description="Descripcin";
	objForm.CPPid.required= true;
	objForm.CPPid.description="Período Presupuestario";
	objForm.RHEfdesde.required= true;
	objForm.RHEfdesde.description="Fecha desde";
	objForm.RHEfhasta.required= true;
	objForm.RHEfhasta.description="Fecha hasta";

	function habilitarValidacion(){
		//objForm.RHEtipo.required = true;
		objForm.RHEdescripcion.required = true;
		objForm.CPPid.required= true;
		objForm.RHEfdesde.required = true;
		objForm.RHEfhasta.required = true;
	}

	function deshabilitarValidacion(){
		//objForm.RHEtipo.required = false;
		objForm.RHEdescripcion.required = false;
		objForm.CPPid.required= false;
		objForm.RHEfdesde.required = false;
		objForm.RHEfhasta.required = false;
	}
</script>
<!-----<cf_web_portlet_end>
</cf_templatearea>
</cf_template>------>

