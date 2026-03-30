<cfset modo = "ALTA">
<cfif isdefined('form.LCid') and form.LCid NEQ '' and form.modoLoc EQ 'CAMBIO'>
	<cfset modo = "CAMBIO">
</cfif>
<cfset cosdPermit = "">
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select lo.LCid
			, lo.Ppais
			, lo.DPnivel
			, lo.LCcod
			, lo.LCnombre
			, lo.LCidPadre
			, loc.LCnombre as nombrePadre
			, lo.Habilitado
			, lo.BMUsucodigo
			, lo.ts_rversion
		from  Localidad lo
			left outer join Localidad loc
				on loc.LCid=lo.LCidPadre
		where lo.LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCid#">
	</cfquery>
<cfelse>
	<cfif isdefined('form.LCidPadre') and form.LCidPadre NEQ ''>
		<cfquery datasource="#session.dsn#" name="dataPadre">
			select LCnombre
			from  Localidad
			where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCidPadre#">
		</cfquery>
		
		<cfquery datasource="#session.dsn#" name="rsCodigos">
			Select LCcod
			from Localidad
			where LCidPadre=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCidPadre#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsCodigos">
			Select LCcod
			from Localidad
			where LCidPadre is null
		</cfquery>		
	</cfif>

	<cfif isdefined('rsCodigos') and rsCodigos.recordCount GT 0>
		<cfset cosdPermit = ValueList(rsCodigos.LCcod, ',')>
	</cfif>	
</cfif>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validarLoc(formulario){
			var error_input;
			var error_msg = '';

			if((!btnSelected('RegresaListaIni',formulario))&&(!btnSelected('Regresar',formulario))&&(!btnSelected('Nuevo',formulario))){
				var error_msg = '';
				
				// Columna: Ppais Ppais char(2)
				if (formulario.Ppais.value == "") {
					error_msg += "\n - País no puede quedar en blanco.";
					error_input = formulario.Ppais;
				}
				// Columna: LCcod Código político varchar(10)
				if (formulario.LCcod.value == "") {
					error_msg += "\n - Código político no puede quedar en blanco.";
					error_input = formulario.LCcod;
				}else{
					if (formulario.LCcod.value == 0) {
						error_msg += "\n - Código político no puede ser igual a cero.";
						error_input = formulario.LCcod;
					}
				}
				// Columna: LCnombre Nombre varchar(80)
				if (formulario.LCnombre.value == "") {
					error_msg += "\n - Nombre no puede quedar en blanco.";
					error_input = formulario.LCnombre;
				}
				
				//Validacion de los codigos de localidad
				var existeCod = false;
				var codigosPer = "<cfoutput>#cosdPermit#</cfoutput>";
				var arrCods = codigosPer.split(',');
		
				//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
				for(var i=0; i < arrCods.length; i++){
					if(arrCods[i] == formulario.LCcod.value){
						existeCod = true;
						break;
					}
				}		
				
				if(existeCod){
					error_msg += "\n - El código indicado ya existe.";									
					error_input = formulario.LCcod;
				}		
			}
	
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) 
					error_input.focus();
					
				return false;
			}
			
			return true;
		}
	//-->
	</script>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<form action="Localidad-apply.cfm" onsubmit="javascript: return validarLoc(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="Localidad-hiddens.cfm">

		<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				<label for="Localidad">Localidad</label>
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<label for="Ppais">Padre:</label>			
			</td>
			<td valign="top">
				<cfif modo NEQ 'ALTA' and isdefined('data')>
					<cfif data.nombrePadre NEQ ''>
						#data.nombrePadre#
					<cfelse>
						Ninguno
					</cfif>
				<cfelseif isdefined('dataPadre')>
					#dataPadre.LCnombre#
				<cfelse>
					-- Ninguno --
				</cfif>
			</td>

		</tr>		
		<tr>	
			<td valign="top" align="right" nowrap>
				<label for="C&oacute;digo pol&iacute;tico">C&oacute;digo pol&iacute;tico:</label>						
			</td>
			<td valign="top">
				<cfset codPol = "">
				<cfif modo NEQ 'ALTA'><cfset codPol = HTMLEditFormat(data.LCcod)></cfif>
					<cf_campoNumerico 
						readonly="false" 
						name="LCcod" 
						decimales="0" 
						size="10" 
						maxlength="10" 
						value="#codPol#" 
						tabindex="1">
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<label for="Nombre">Nombre:</label>						
			</td>
			<td valign="top">
				<input name="LCnombre" 
					id="LCnombre" type="text" 
					onKeyUp="javascript: validaBlancos(this);"
					value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.LCnombre)#</cfif>" 
					maxlength="80" tabindex="1"
					onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="2" class="formButtons">
				<cfif isdefined('form.LCid') and form.LCid NEQ ''>
					<cfif isdefined('data') and data.DPnivel EQ 1>
						<cfset include="RegresaListaIni">
						<cfset includeValores="Lista Inicial">
					<cfelse>
						<cfset include="RegresaListaIni,Regresar">
						<cfset includeValores="Lista Inicial,Regresar">					
					</cfif>
				<cfelse>
					<cfset include="RegresaListaIni">
					<cfset includeValores="Lista Inicial">					
				</cfif>
				
				<cf_botones includevalues="#includeValores#" include="#Include#" modo="#modo#" tabindex="1" exclude="Nuevo">
			</td>
		</tr>
	</table>
		<cfif modo NEQ 'ALTA'>
			<input type="hidden" name="Habilitado" value="#HTMLEditFormat(data.Habilitado)#">
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
	</form>
</cfoutput>