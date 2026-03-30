<cfif modo neq 'ALTA' and isdefined('form.Pid') and len(trim('form.Pid'))>
	<cfquery name="rsSelectDatosPeajes" datasource="#session.dsn#">
		select cf.CFdescripcion, cf.CFcodigo, cf.CFid , p.Pcodigo, p.Pdescripcion, p.Pcarriles, p.cuentac, p.ts_rversion, p.FPAEid, p.CFComplemento
		from Peaje p inner join CFuncional cf on cf.CFid=p.CFid
		where p.Pid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pid#"> and p.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset Pcodigo=rsSelectDatosPeajes.Pcodigo>
	<cfset Pdescripcion=rsSelectDatosPeajes.Pdescripcion>
	<cfset Pcarriles=rsSelectDatosPeajes.Pcarriles>
	<cfset cuentac=rsSelectDatosPeajes.cuentac>
	
	<cfset CFid=rsSelectDatosPeajes.CFid>
	<cfset CFdescripcion=rsSelectDatosPeajes.CFdescripcion>
	<cfset CFcodigo=rsSelectDatosPeajes.CFcodigo>
	
<cfelse>
	<cfset Pcodigo="">
	<cfset Pdescripcion="">
	<cfset Pcarriles="">
	<cfset cuentac="">
	
	<cfset CFid="">
	<cfset CFdescripcion="">
	<cfset CFcodigo="">
</cfif>
<cfform action="peajes_SQL.cfm" method="post" name="form1">
	<table align="center">
		<tr> 
      		<td nowrap align="right">C&oacute;digo Peaje:</td>
      		<td>
				<cfinput id="codPeaje" name="codPeaje" type="text" maxlength="20"  width="20" value="#Pcodigo#">			</td>
    	</tr>
		<tr>
			<td nowrap align="right">Centro funcional:</td>
      		<td>
				<cf_conlis
					Campos="CFid,CFcodigo,CFdescripcion"
					tabindex="6"
					values="#CFid#,#CFcodigo#,#CFdescripcion#,"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,15,35"
					Title="Lista de Centros Funcionales"
					Tabla="CFuncional cf"
					Columnas="CFid,CFcodigo,CFdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# order by CFcodigo,CFdescripcion"
					Desplegar="CFcodigo,CFdescripcion"
					Etiquetas="C&oacute;digo,Descripci&oacute;n"
					filtrar_por="CFcodigo,CFdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="CFid,CFcodigo,CFdescripcion"
					Asignarformatos="I,S,S"
					funcion="resetPeaje"/>
			</td>
		</tr>
		<tr> 
      		<td nowrap align="right">Cantidad de carrilles:</td>
      		<td>
				<cfinput id="cantCarriles" name="cantCarriles" type="text" maxlength="10"  width="10" value="#Pcarriles#"  onkeyup = "_CFinputText_onKeyUp(this,event,5,0,false);"></td>
    	</tr>
		<tr> 
      		<td nowrap align="right">Concepto Contable:</td>
      		<td>
				<cfinput id="codCuentaC" name="codCuentaC" type="text" maxlength="100" width="100" value="#cuentac#">			</td>
    	</tr>
		<tr>
		<td colspan="2" align="left">
            <cfif modo neq 'ALTA' and len(#rsSelectDatosPeajes.FPAEid#) neq 0 and len(#rsSelectDatosPeajes.CFComplemento#) neq 0 >
		     <cf_ActividadEmpresa name="CFComplemento_ALL" formname="form1"  idActividad="#rsSelectDatosPeajes.FPAEid#" valores="#rsSelectDatosPeajes.CFComplemento#">
 		 <cfelse>
			<cf_ActividadEmpresa name="CFComplemento_ALL" formname="form1">
		 </cfif>
		</td>		
		</tr>
		<tr> 
      		<td nowrap align="right">Descripci&oacute;n:</td>
      			<td>
					<cfoutput>
						 <input type="text" maxlength="50" name="descripcion" id="descripcion" value="#Pdescripcion#"  size="50"/> 
					</cfoutput>
				</td>
    	    </td>

		</tr>
		<tr> 
      		<td colspan="2">
				<cf_botones modo="#modo#">			</td>
    	</tr>
		<tr> 
      		<td colspan="2">
				<input type="hidden" id="modo" name="modo" value="#modo#" />
				<input type="hidden" id="Ecodigo" name="Ecodigo" value="<cfoutput>#session.Ecodigo#</cfoutput>" />
				<input type="hidden" id="MBUsucodigo" name="MBUsucodigo" value="<cfoutput>#session.usucodigo#</cfoutput>" />
				<cfset ts = "">
				<cfif modo neq "ALTA">
				<input type="hidden" id="Pid" name="Pid" value="<cfoutput>#form.Pid#</cfoutput>" />
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosPeajes.ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</td>
    	</tr>
  	</table>
</cfform>
<cfoutput>
<cf_qforms form='form1'>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript1.2" type="text/javascript">
	
	objForm.codPeaje.description = "#JSStringFormat('Código del Peaje')#";
	objForm.CFcodigo.description = "#JSStringFormat('Centro Fucional')#";
	objForm.cantCarriles.description = "#JSStringFormat('Cantidad de Carriles')#";
	objForm.codPeaje.required = true;
	objForm.CFcodigo.required=true;
	objForm.cantCarriles.required = true;

</script>
</cfoutput>