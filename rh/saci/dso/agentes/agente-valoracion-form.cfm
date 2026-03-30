<cffunction name="calificacionAgente" output="true" returntype="string" access="remote">
	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
	<cfargument name="plazo" type="numeric" required="No" default="20"  displayname="Plazo de análisis a Utilizar">
	
	<cfinvoke component="saci.comp.ISBprospectos" method="GetPorcentajeCalificacion" returnvariable="Porcentaje">
		<cfinvokeargument name="AGid" value="#Arguments.AGid#">
		<cfinvokeargument name="plazo" value="#Arguments.plazo#">
	</cfinvoke>

	
	<cfinvoke component="saci.comp.ISBprospectos" method="GetCalificacion" returnvariable="nota">
		<cfinvokeargument name="AGid" value="#Arguments.AGid#">
		<cfinvokeargument name="porcentaje" value="#Porcentaje#">
	</cfinvoke>

	
	<cfset resultado = nota>

<cfreturn resultado>
</cffunction>

<cfif isdefined("url.ANid")and len(trim(url.ANid))>
	<cfset modoVal="CAMBIO">
<cfelse>
	<cfset modoVal="ALTA">
</cfif>

<cfset puntaje = calificacionAgente(form.AGid,20)>
<cfset puntaje_cortoplazo = calificacionAgente(form.AGid,21)>

<cfif modoVal NEQ "ALTA">
	<cfquery datasource="#session.dsn#" name="data">
		Select ANid
			, AGid
			, ANvaloracion
			, ANautomatica
			, ANobservacion
			, ANfecha
			, ANpuntaje
			, BMUsucodigo
			, ts_rversion
		from ISBagenteValoracion 
		where ANid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ANid#" null="#Len(url.ANid) Is 0#">
	</cfquery>
</cfif>
<style type="text/css">
<!--
.style2 {font-size: 18px;color:#006666}
.style4 {font-size: 14px}
.style5 {font-size: 16px}
-->
</style>


<form name="form1" method="post" action="agente-valoracion-apply.cfm" style="margin: 0;" onsubmit="return validar(this);">
	<cfoutput>
		<input type="hidden" name="Filtro_ANfecha2" value="#form.Filtro_ANfecha2#">
		<input type="hidden" name="Filtro_ANautomatica2" value="#form.Filtro_ANautomatica2#">
		<input type="hidden" name="Filtro_ANobservacion2" value="#form.Filtro_ANobservacion2#">
		<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
		<cfif modoVal NEQ "ALTA">
			<input type="hidden" name="ANid" value="#data.ANid#">
		</cfif>
		
		<cfinclude template="agente-hiddens.cfm">
	
		<table width="100%"  border="0"  cellspacing="0" cellpadding="0">
			<cfif ExisteAgente>
			  <tr class="menuhead">
				<td colspan="2" align="center">
					#rsDatosPersona.Pid#&nbsp;&nbsp;#rsDatosPersona.NombreCompleto#<br>
					<span class="style4"><span class="style5">Calificaci&oacute;n del Agente según Plazo de Análisis de Calidad</span>:</span> <span class="style2">#puntaje#</span>	</td>
			  </tr>
			  <tr class="menuhead">
				<td colspan="2" align="center">
					<span class="style4"><span class="style5">Calificaci&oacute;n del Agente según Plazo de Análisis de Calidad a Corto Plazo</span>:</span> <span class="style2">#puntaje_cortoplazo#</span>	</td>
			  </tr>
			  
			</cfif>
		  <tr>
			<td width="15%">&nbsp;</td>
			<td width="85%">&nbsp;</td>
		  </tr>
		  <tr>
			<td align="right"><label>Valoraci&oacute;n:</label></td>
			<td>&nbsp;&nbsp;
				<cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANautomatica EQ 1>
					<input name="ANvaloracion" id="ANvaloracion" tabindex="1" disabled="disabled" type="radio" value="1" <cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANvaloracion EQ 1>checked<cfelseif modoVal EQ 'ALTA'> checked</cfif>>
				  Positiva
					<input name="ANvaloracion" id="ANvaloracion" tabindex="1" disabled="disabled" type="radio" value="-1" <cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANvaloracion EQ -1> checked</cfif>>
				  Negativa
					
				<cfelse>				
					<input name="ANvaloracion" id="ANvaloracion" tabindex="2" type="radio" value="1" <cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANvaloracion EQ 1>checked<cfelseif modoVal EQ 'ALTA'> checked</cfif>>
				  Positiva
					<input name="ANvaloracion" id="ANvaloracion" tabindex="2" type="radio" value="-1" <cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANvaloracion EQ -1> checked</cfif>>
				  Negativa
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right"><label>Autom&aacute;tica:</label></td>
			<td>&nbsp;&nbsp;
				<input name="ANautomatica1" tabindex="3" id="ANautomatica1" disabled type="checkbox" value="1" <cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANautomatica EQ 1> checked</cfif>>
			  Si
		    	<input name="ANautomatica0" tabindex="3" id="ANautomatica0" disabled type="checkbox" value="0" <cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANautomatica EQ 0> checked<cfelseif modoVal EQ 'ALTA'> checked</cfif>>
		      No				  
			  <input type="hidden" tabindex="3" name="ANautomatica" value="<cfif modoVal NEQ 'ALTA' and isdefined('data')>#data.ANautomatica#<cfelse>0</cfif>">
			</td>
		  </tr>
  		  <tr>
			<td align="right" valign="top"><label>Puntaje:</label></td>
			<td align="left" >&nbsp;&nbsp;
			<cfset inhabil = "false">
			
			<cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANautomatica EQ 1>		
				<cfset inhabil = "true">
			</cfif>
					
				<cfif modoVal NEQ 'ALTA' and isdefined('data')>
					<cf_campoNumerico 
						readonly="#inhabil#"
						name="ANpuntaje" 
						decimales="-1" 
						size="10" 
						maxlength="3" 
						value="#HTMLEditFormat(data.ANpuntaje)#" 
						tabindex="4">
				<cfelse>
					<cf_campoNumerico 
						readonly="false"
						name="ANpuntaje" 
						decimales="-1" 
						size="10" 
						maxlength="3" 
						tabindex="4">				
				</cfif>
										
			</td>
		  </tr>
		  <tr>
			<td align="right" valign="top"><label>Observaci&oacute;n:</label></td>
			<td>&nbsp;&nbsp;
			<cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANautomatica EQ 1>
				<textarea name="ANobservacion" tabindex="5" readonly="readonly" cols="100" rows="2" id="ANobservacion"><cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANobservacion NEQ ''>#data.ANobservacion#</cfif></textarea></td>
			<cfelse>
				<textarea name="ANobservacion" tabindex="5" cols="100" rows="2" id="ANobservacion"><cfif modoVal NEQ 'ALTA' and isdefined('data') and data.ANobservacion NEQ ''>#data.ANobservacion#</cfif></textarea></td>
		  	</cfif>
		  </tr>
		  <tr>
			<td width="15%">&nbsp;</td>
			<td width="85%">&nbsp;</td>
		  </tr>	  
		  <tr>
			<td align="center" colspan="2">	
				<cf_botones modo="#modoVal#" tabindex="6" include="Lista,Totales" includevalues="Lista Agentes,Ver Gráfico">
			</td>
		  </tr>	
		  <tr>
			<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
			<td valign="bottom" align="left" colspan="1"><label>Plazo de graficaci&oacute;n:&nbsp;</label></td>
			<td valign="bottom" align="left" colspan="1">&nbsp;&nbsp;
			<select name="mostrar" tabindex="8" id="mostrar" style="width:150px">			
				<option value="21" selected="selected">Corto Plazo</option>
				<option value="20">Mediano Plazo</option>
			</select>			
			</td>
		  </tr>
				  
		</table>
	</form>		
	
	<script language="javascript" type="text/javascript">
		var popUpWin=0; 
		function popUpWindow(URLStr, left, top, width, height){
		  if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		  }
		  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}	

		function validar(formulario){
			var error_input;
			var error_msg = '';
				
			//if(btnSelected('Alta', formulario)){
				if (trim(formulario.ANobservacion.value) == "") {
					error_msg += "\n - La observación no puede quedar en blanco.";
					error_input = formulario.ANobservacion;
				}
			//}

			
			if (parseInt(formulario.ANpuntaje.value) <= 0) {
					error_msg += "\n - Puntaje no válido.";
					error_input = formulario.ANpuntaje;
			}
			
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguientes datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}							
				
			return true;
		}
		function funcTotales(){
			popUpWindow("agente-valoracion-totales.cfm?AGid=<cfoutput>#form.AGid#</cfoutput>" + "&plazo=" + document.form1.mostrar.value,250,100,650,500);
			return false;
		}
	</script>
</cfoutput>