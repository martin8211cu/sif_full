<cfoutput>
<cfif modo neq 'ALTA' and isdefined('GEPVid') and len(trim('GEPVid'))>
	<cfquery name="rsSelectDatos" datasource="#session.dsn#">
		select gep.GEPVid, gep.GECVid, gep.GECid, gep.ts_rversion, gep.Mcodigo, gep.GEPVcodigo as GEPVcodigo, gep.GEPVtipoviatico, gep.GEPVdescripcion,  
			   gep.GEPVaplicaTodos, gep.GEPVmonto, gep.GEPVhoraini, gep.GEPVhorafin, gep.GEPVfechaini, gep.GEPVfechafin, 
			   gec.GECVid, gec.GECVcodigo, gec.GECVdescripcion,
               ge.GECid, ge.GECconcepto, ge.GECdescripcion, 
			   m.Mnombre
			   
		from GEPlantillaViaticos gep 
			inner join GEClasificacionViaticos gec 
				on gep.GECVid = gec.GECVid 
        	inner join GEconceptoGasto ge
        		on ge.GECid=gep.GECid
			inner join Monedas m
				on gep.Mcodigo= m.Mcodigo
		 where gep.GEPVid=#GEPVid#
	
	</cfquery>	

	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select GECVid as GECVid, GECVcodigo as GECVcodigo, GECVdescripcion as GECVdescripcion, GECVnivel as GECVnivel
		from GEClasificacionViaticos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and GECVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectDatos.GECVid#">
	</cfquery>
	
	<cfset GEPVid=rsSelectDatos.GEPVid>
	<cfset GEPVmonto=rsSelectDatos.GEPVmonto>
	<cfset GECid=rsSelectDatos.GECid>
	<cfset GECconcepto=rsSelectDatos.GECconcepto>
	<cfset GECdescripcion=rsSelectDatos.GECdescripcion>
	<cfset GECVid=rsSelectDatos.GECVid>
	<cfset GECVcodigo=rsSelectDatos.GECVcodigo>
	<cfset GECVdescripcion=rsSelectDatos.GECVdescripcion>
	<cfset Mcodigo=rsSelectDatos.Mcodigo>	
	<cfset Mnombre=rsSelectDatos.Mnombre>
	<cfset GEPVcodigo=rsSelectDatos.GEPVcodigo>	
	<cfset GEPVtipoviatico=rsSelectDatos.GEPVtipoviatico>
	<cfset GEPVdescripcion=rsSelectDatos.GEPVdescripcion>	
	<cfset GEPVaplicaTodos=rsSelectDatos.GEPVaplicaTodos>
	<cfset GEPVhoraini=rsSelectDatos.GEPVhoraini>
	<cfset GEPVhorafin=rsSelectDatos.GEPVhorafin>	
	<cfset GEPVfechaini=rsSelectDatos.GEPVfechaini>	
	<cfset GEPVfechafin=rsSelectDatos.GEPVfechafin>	
	<cfset ts_rversion=rsSelectDatos.ts_rversion>	
<cfelse>
	<cfset GEPVid="">
	<cfset GEPVmonto="">
	<cfset GECid="">
	<cfset GECconcepto="">
	<cfset GECdescripcion="">
	<cfset GECVid="">
	<cfset GECVcodigo="">
	<cfset GECVdescripcion="">
	<cfset Mcodigo="">
	<cfset Mnombre="">
	<cfset GEPVcodigo="">	
	<cfset GEPVtipoviatico="">
	<cfset GEPVdescripcion="">	
	<cfset GEPVaplicaTodos="0">
	<cfset GEPVhoraini="0">
	<cfset GEPVhorafin="0">	
	<cfset GEPVfechaini="">	
	<cfset GEPVfechafin="">
	<cfset ts_rversion="">
	<cfset check='no'>		
	
	
</cfif>
<cfparam name="check" default="no">

<cfquery name="rsSelectMonedas" datasource="#session.dsn#">
		select Mcodigo,Mnombre
		from Monedas
		where Ecodigo=#session.Ecodigo#
</cfquery>

<cfform action="catalogoPlantillaViaticos-SQL.cfm" method="post" name="form1" onSubmit="return validar(this);">
	<table align="center">
		<tr> 
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td>
				<input name="GEPVcodigo" type="text" value="<cfif modo neq "ALTA" >#trim(GEPVcodigo)#</cfif>" size="10" maxlength="5"  alt="El Código de la Planilla" onFocus="this.select();"> 
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="_GEPVcodigo" value="#GEPVcodigo#" >
				</cfif>
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="GEPVdescripcion" type="text"  value="<cfif modo neq "ALTA">#GEPVdescripcion#</cfif>" size="35" maxlength="50" onFocus="this.select();"  alt="La Descripción del Concepto">
			</td>
		</tr>
	
		<tr>
			<td align="right" nowrap>Clasificaci&oacute;n Vi&aacute;tico:&nbsp;</td>
			<td>
			<cfif modo neq 'ALTA' and isdefined('rsClasificacion') >
				<cf_sifclasificacionViaticos query="#rsClasificacion#" id="GECVid" name="GECVcodigo" desc="GECVdescripcion"  >
			<cfelse>
				<cf_sifclasificacionViaticos id="GECVid" name="GECVcodigo" desc="GECVdescripcion"  >
			</cfif>
			</td>
		</tr>	
		<tr> 
      		<td nowrap align="right">Concepto de Gasto:</td>
      		<td>
				<cf_conlis
					Campos="GECid,GECconcepto,GECdescripcion"
					tabindex="6"
					values="#GECid#,#GECconcepto#,#GECdescripcion#,"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,15,25"
					Title="Lista de Conceptos"
					Tabla="GEconceptoGasto ge inner join GEtipoGasto g on g.GETid=ge.GETid "
					Columnas="GECid,GECconcepto,GECdescripcion"
					Desplegar="GECconcepto,GECdescripcion"
					Etiquetas="Concepto,Descripci&oacute;n"
					filtrar_por="GECconcepto,GECdescripcion"
					filtro="g.Ecodigo= #session.Ecodigo#"
					Formatos="S,S"
					Align="left,left"
					Asignar="GECid,GECconcepto,GECdescripcion"
					Asignarformatos="I,S,S"
					funcion="resetPeaje"/>
			</td>
    	</tr>
	<tr> 
      		<td nowrap align="right">Moneda:</td>
      		<td>
				<cfselect name="monedas" id="monedas">
					<cfif modo neq "ALTA">
							<option Value="<cfoutput>#Mcodigo#</cfoutput>" selected><cfoutput>#Mnombre#</cfoutput></option>
					</cfif>
						<cfloop query="rsSelectMonedas">
							<option value="<cfoutput>#Mcodigo#</cfoutput>"><cfoutput>#Mnombre#</cfoutput></option>
					</cfloop>
				</cfselect>

			</td>
    	</tr>
			<tr> 
      		<td nowrap align="right">Monto:</td>
      		<td>
				<cf_monto name="GEPVmonto" id="GEPVmonto" tabindex="-1" value="#GEPVmonto#" decimales="2" negativos="false">
			</td>
    	</tr>
		<tr>
			<td nowrap align="right">Fecha Desde:&nbsp;&nbsp;</td>
			<td colspan="5"><cf_sifcalendario name="GEPVfechaini" tabindex="1" value="#LSDateFormat(GEPVfechaini,'dd/mm/yyyy')#"></td>
		</tr>
		<tr>
			<td nowrap align="right">Fecha Hasta:&nbsp;&nbsp;</td>
			<td colspan="5"><cf_sifcalendario name="GEPVfechafin" tabindex="1" value="#LSDateFormat(GEPVfechafin,'dd/mm/yyyy')#"></td>
		</tr>
		<tr> 
      		<td nowrap align="right">Hora Inicio:</td>
      		<td>
				<cf_hora name="GEPVhoraini" form="form1" value="#GEPVhoraini#">
			</td>
	    </tr>
		<tr> 
      		<td nowrap align="right">Hora Final:</td>
			<td>
				<cf_hora name="GEPVhorafin" form="form1" value="#GEPVhorafin#">
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap>Tipo:&nbsp;</td>		
			<td align="left" colspan="3">
				<input type="radio" name="GEPVtipoviatico" id="GEPVtipoviatico1" value="1" tabindex="1" <cfif modo neq "ALTA" and #GEPVtipoviatico# EQ 1> checked=" checked " </cfif>checked  onchange="requerido()">
					<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal">Nacional</label>
				 <input type="radio" name="GEPVtipoviatico" id="GEPVtipoviatico2" value="2"  tabindex="1"<cfif modo neq "ALTA" and #GEPVtipoviatico# EQ 2>  checked="checked"  </cfif> onchange="requerido()">
					<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal">Exterior</label>
			</td>
		</tr>
		<tr>	
			<td nowrap align="right">Aplica a todos:</td>
      		<td>
				<cfif modo NEQ "ALTA" and #GEPVaplicaTodos# EQ 1> <cfset check='yes'> </cfif>
				<cfinput id="GEPVaplicaTodos" name="GEPVaplicaTodos" type="checkbox"  tabindex="1" checked="#check#" value="1" >
			</td>
		
		<tr valign="baseline"> 
			<td colspan="2" align="right" nowrap > 
				<cfset Lvar_botones = 'ImportarI'>
				<cfset Lvar_botonesV = 'Importar Plantilla Viático'>	
				
				<cf_botones modo="#modo#" tabindex="1" include="#Lvar_botones#" includevalues="#Lvar_botonesV#">
			</td>
		</tr>
		
		<tr> 
      	<td colspan="2">
				<input type="hidden" name="modo" value="#modo#" />
				<input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				<input type="hidden" name="Ecodigo" value="#session.Ecodigo#" />
					<cfif modo neq "ALTA">
			<input type="hidden" id="GEPVid" name="GEPVid" value="#GEPVid#" />
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</td>
    	</tr>
  	</table>
</cfform>

<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.GECconcepto.description = "Concepto de Gasto";
		objForm.GECVcodigo.description = "Clasificación de Viático";
		objForm.GEPVmonto.description = "Monto";
		objForm.GEPVcodigo.description = "Código de la Planilla";
		objForm.GEPVfechaini.description = "Fecha de Inicio";
		objForm.GEPVfechafin.description = "Fecha Final";
		
		objForm.GECconcepto.required = true;
		objForm.GECVcodigo.required = true;
		objForm.GEPVmonto.required = true;
		objForm.GEPVcodigo.required = true;
		objForm.GEPVfechaini.required = true;
		objForm.GEPVfechafin.required = true;

		
	function fnFechaYYYYMMDD (LvarFecha)
	{
		return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
	}
	
	function validar(form1){
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1)){
			var error_input;
			var error_msg = '';
	
		if (fnFechaYYYYMMDD(document.form1.GEPVfechaini.value) > fnFechaYYYYMMDD(document.form1.GEPVfechafin.value))
		{
			alert ("La Fecha de Inicio debe ser menor a la Fecha Final");
			return false;
		}

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}   

	function deshabilitarValidacion() {
		objForm.GEPVcodigo.required = false;
		objForm.GEPVdescripcion.required = false;
		objForm.GEPVtipoviatico.required = false;
		
		objForm.GECVcodigo.required = false;
		
		objForm.GECid.required = false;
		objForm.GECconcepto.required = false;
		objForm.GECdescripcion.required = false;
		
		objForm.GEPVfechaini.required = false;
		objForm.GEPVfechafin.required = false;
		
	}

	function funcImportarI(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/tesoreria/GestionEmpleados/importaViaticoInterno.cfm'
	}
	
	function funcImportarE(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/tesoreria/GestionEmpleados/importaViaticoExterno.cfm'
	}
 
</script>
</cfoutput>
