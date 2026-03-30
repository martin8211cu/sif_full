<!--- Parametros del Tag --->
<cfparam 	name="Attributes.id_agente"		type="string"	default="-1">					<!--- Id del Agente--->
<cfparam 	name="Attributes.identificacion"type="string"	default="">						<!--- Identificacion del Agente--->
<cfparam 	name="Attributes.form"			type="string"	default="form1">				<!--- form--->
<cfparam 	name="Attributes.funcion"		type="string"	default="">						<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam 	name="Attributes.pais"			type="string"	default="#session.saci.pais#">	<!--- Pais en caso de ser necesario--->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.TipodeAgente"  type="string"	default="Interno">							<!--- Indica si es un Vendedor de RACSA o un Agente Autorizado --->


<!------------- Selecciona los Datos del agente en caso de que el id este definido en los atributos ------->
<cfif isdefined("Attributes.id_agente") and len(trim(Attributes.id_agente)) and Attributes.id_agente neq "-1">
	<cfquery datasource="#Attributes.Conexion#" name="rsAgenteTag">
		select a.AGid, a.Pquien, a.CTidAcceso, a.CTidFactura, a.Ecodigo, a.AAregistro, a.AAaprobacion, 
			   a.AAplazoDocumentacion, a.AAprospecta, a.AAcomisionTipo, a.AAcomisionPctj, a.AAcomisionMnto, a.AAinterno, 
			   a.Habilitado, a.AAmotivo, a.BMUsucodigo, a.ts_rversion, a.AAfechacontrato,
			   Case 
			   		When Habilitado = 1 Then 'Activo'
					When Habilitado = 0 Then 'Inhabilitado'
					When Habilitado = 2 Then 'Borrado'
				End as estado
		from ISBagente a
		where a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_agente#" null="#Len(Attributes.id_agente) Is 0#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	</cfquery>
</cfif>

<!------------------------------------ Define el modo agente ----------------------------------------------->
<cfset modo_agente = "ALTA">
<cfif isdefined("rsAgenteTag") and rsAgenteTag.Recordcount GT 0>
	<cfset modo_agente = "CAMBIO">
</cfif>

<!------------------------------------ Pinta los campos ----------------------------------------------->
<cfoutput>
	<cfset ts_ag = "">
	<cfif modo_agente NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#rsAgenteTag.ts_rversion#" returnvariable="ts_ag">
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion_agente#Attributes.sufijo#" value="#ts_ag#">
	<input name="AGid#Attributes.sufijo#" id="AGid#Attributes.sufijo#" type="hidden" value="<cfif modo_agente NEQ "ALTA">#rsAgenteTag.AGid#</cfif>">
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<!--- Tag Persona --->
			<cfset id_persona= "">
			<cfif modo_agente NEQ "ALTA">
				<cfset id_persona= rsAgenteTag.Pquien>
			</cfif>
			
			<tr valign="top" >
			<td align="left"><cfif modo_agente NEQ "ALTA"><label for="Codigo_Agente">C&oacute;digo de Agente</label></cfif></td>
				<td>
					<cfif modo_agente NEQ "ALTA">
					<cf_campoNumerico 
						readonly="true" 
						name="BDAGid#Attributes.sufijo#" 
						decimales="0" 
						size="10" 
						maxlength="10" 
						value="#HTMLEditFormat(rsAgenteTag.AGid)#" 
						tabindex="1"
						>
					</cfif>
			</td>
			<cfif modo_agente NEQ "ALTA">
				<td colspan="6" align="right"><label for="Estado_Agente">Estado: #rsAgenteTag.estado#</label></td>
			</cfif>
			</tr>	
			<!---#HTMLEditFormat(rsAgenteTag.AGid)#--->
			
			<cf_persona
				id = "#id_persona#"
				form = "#Attributes.form#"
				incluyeTabla = "false"
				pais = "#Attributes.pais#"
				onchangePersoneria = "onchangeAgente#Attributes.sufijo#"
				funcionValorEnBlanco = "ResetValoresAgente#Attributes.sufijo#"
				funcion = "CargarValoresAgente#Attributes.sufijo#"
				sufijo = "#Attributes.sufijo#"
				TypeLocation = "A"
				RefIdLocation = "#Attributes.id_agente#"
				TipodeAgente = "#form.tipo#"
			>

		<tr <cfif form.tipo eq 'Interno'> style="visibility:hidden"</cfif> valign="bottom">
			<td class="subTitulo" colspan="6" align="center" >
				Datos Adicionales
			</td>
		</tr>
		<tr <cfif form.tipo eq 'Interno'> style="visibility:hidden"</cfif>>
				<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="PG_plazoDoc">
					<cfinvokeargument name="Pcodigo" value="10">
				</cfinvoke>		

			<td colspan="4" valign="middle" align="center"><label>El Plazo para Entrega de  Documentaci&oacute;n es de #PG_plazoDoc# día(s) </label><hr/></td>		
		</tr>
		<tr <cfif form.tipo eq 'Interno'> style="visibility:hidden"</cfif>>
			<td valign="middle" align="right"><label>Plazo de Entrega Extendido</label></td>
			<td valign="middle">				
				<!-----<input name="AAplazoDocumentacion#Attributes.sufijo#" id="AAplazoDocumentacion#Attributes.sufijo#" type="text" size="20" maxlength="18" value="<cfif modo_agente NEQ "ALTA">#HTMLEditFormat(rsAgenteTag.AAplazoDocumentacion)#<cfelse>#PG_plazoDoc#</cfif>" onfocus="this.select()" tabindex="1">------>
				<cfif modo_agente NEQ "ALTA">
					<cfset PG_plazoDoc = HTMLEditFormat(rsAgenteTag.AAplazoDocumentacion)>
				</cfif>
				<cf_inputNumber name="AAplazoDocumentacion#Attributes.sufijo#" enteros="3"  codigoNumerico="yes" value="#PG_plazoDoc#">
			</td>
			
			<td valign="middle"align="right"><label>Tipo de comisi&oacute;n</label></td>
			<td valign="middle">
				<select name="AAcomisionTipo#Attributes.sufijo#" id="AAcomisionTipo#Attributes.sufijo#" onchange="javascript: muestraPorcentaje();" tabindex="1">
					<option value="0"<cfif modo_agente NEQ "ALTA" and rsAgenteTag.AAcomisionTipo is '0'> selected</cfif>>No comisiona</option>
					<option value="1"<cfif modo_agente NEQ "ALTA" and rsAgenteTag.AAcomisionTipo is '1'> selected</cfif>>Porcentual</option>
					<option value="2"<cfif modo_agente NEQ "ALTA" and rsAgenteTag.AAcomisionTipo is '2'> selected</cfif>>Monto fijo</option>
					<option value="3"<cfif modo_agente NEQ "ALTA" and rsAgenteTag.AAcomisionTipo is '3'> selected</cfif>>Primer pago</option>
				</select>
			</td>
			<td valign="middle"align="right" id="comisionPorcL"><label>Comisi&oacute;n</label></td>
			<td valign="middle" id="comisionPorc">
				<cfset porc = "0.00">
				<cfif modo_agente NEQ "ALTA">
					<cfset porc = LSNumberFormat(rsAgenteTag.AAcomisionPctj, '9.00')>
				</cfif>
				<cf_campoNumerico name="AAcomisionPctj#Attributes.sufijo#" decimales="2" size="10" maxlength="6" value="#porc#" tabindex="1">%
			</td>
			<td valign="middle" align="right" id="comisionMontoL"><label>Monto comisi&oacute;n</label></td>
			<td valign="middle" id="comisionMonto">
				<cfset porc = "0.00">
				<cfif modo_agente NEQ "ALTA">
					<cfset porc = LSNumberFormat(rsAgenteTag.AAcomisionMnto, ',9.00')>
				</cfif>
				<cf_campoNumerico name="AAcomisionMnto#Attributes.sufijo#" decimales="2" size="22" maxlength="18" value="#porc#" tabindex="1">
			</td>
		</tr>
		<tr <cfif form.tipo eq 'Interno'> style="visibility:hidden"</cfif>>
		
			<td align="right">
				<input name="AAprospecta#Attributes.sufijo#" id="AAprospecta#Attributes.sufijo#" type="checkbox" value="1" <cfif modo_agente NEQ "ALTA" and Len(rsAgenteTag.AAprospecta) And rsAgenteTag.AAprospecta> checked</cfif> tabindex="1">
			</td>
			<td>
				<label for="AAprospecta">Prospecta?</label>
			</td>
			<!--- <td colspan="4">&nbsp;</td> --->
			<!---
			<td align="right">
				<input name="AAinterno" id="AAinterno" type="checkbox" value="1" <cfif modo_agente NEQ "ALTA" and Len(rsAgenteTag.AAinterno) And rsAgenteTag.AAinterno> checked</cfif> tabindex="1">
			</td>
			<td>
				<label for="AAinterno">Interno</label>
			</td>
			<td align="right">
				<input name="Habilitado" id="Habilitado" type="checkbox" value="1" <cfif modo_agente NEQ "ALTA" and Len(rsAgenteTag.Habilitado) And rsAgenteTag.Habilitado> checked</cfif> tabindex="1">
			</td>
			<td>
				<label for="Habilitado">Habilitado</label>
			</td>
			--->
		
		
		
			<td valign="middle"align="right" id="AAfechacontrato#Attributes.sufijo#"><label>Fecha Firma Contrato</label>
			<cfset fechafirma = "">
			<cfif modo_agente NEQ "ALTA">
				<cfset fechafirma = rsAgenteTag.AAfechacontrato>
			</cfif>	
			</td>
			<td><cf_sifcalendario form="form1" name="AAfechacontrato#Attributes.sufijo#" value="#DateFormat(fechafirma,'dd/mm/yyyy')#" >
			</td>			
	
		
		</tr>
		
		
		<!--- Tag de Atributos extendidos para el Agente --->
		<cfif isdefined('Attributes.TipodeAgente') and Attributes.TipodeAgente eq "Externo">
		<tr>
			<td align="center" valign="middle" colspan="6">
				<cfset id_agente = "">
				<cfif modo_agente neq "ALTA">
					<cfset id_agente = rsAgenteTag.AGid>
				</cfif>
				<cf_atrExtendidos
					tipo="3"
					id="#id_agente#"
					form="#Attributes.form#"
					columnas="3"
					sufijo="#Attributes.sufijo#2"
					incluyeTabla="true"
				>
			</td>				
		</tr>
		</cfif>
	</table>
	
	<!------------------------------ Sentencia Iframe-------------------------------->
	<iframe id="datosAgente#Attributes.sufijo#" name="datosAgente#Attributes.sufijo#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
		
	<script language="javascript1.2" type="text/javascript">
		<!----------------------- Refresca los valores del agente----------------------------------------->
		function CargarValoresAgente#Attributes.sufijo#() {
			ResetValoresAgente#Attributes.sufijo#();
			var id = document.#Attributes.form#.Pquien#Attributes.sufijo#.value;
			var personeria = document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value;
			CargarValoresPersona#Attributes.sufijo#();
			ActualizaValoresAgente#Attributes.sufijo#(id);
			CargarFormatoTels#Attributes.sufijo#();
		}
		
		<!----------------------- Reset de los campos adicionales para el agente----------------------------------------->
		function ResetValoresAgente#Attributes.sufijo#() {
			resetPersona#Attributes.sufijo#();
			document.#Attributes.form#.AGid#Attributes.sufijo#.value="";
			<cfif modo_agente NEQ "ALTA">
				document.#Attributes.form#.BDAGid#Attributes.sufijo#.value= "0";
			</cfif>
			document.#Attributes.form#.AAplazoDocumentacion#Attributes.sufijo#.value = "#PG_plazoDoc#";
			document.#Attributes.form#.AAfechacontrato#Attributes.sufijo#.value = "#fechafirma#";
			document.#Attributes.form#.AAcomisionTipo#Attributes.sufijo#.value = "0";
			document.#Attributes.form#.AAcomisionPctj#Attributes.sufijo#.value = "0.00";
			document.#Attributes.form#.AAcomisionMnto#Attributes.sufijo#.value = "0.00";
			document.#Attributes.form#.AAprospecta#Attributes.sufijo#.checked = false;
			
		}
		
		function CargarFormatoTels#Attributes.sufijo#(){
		
			/***--se carga los valores iniciales de telefonos--****/
			var fv = document.all.Ptelefono1#Attributes.sufijo#.value;
			if(fv.length > 0)
				document.all._Ptelefono1#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
			fv = document.all.Ptelefono2#Attributes.sufijo#.value;
			if(fv.length > 0)
				document.all._Ptelefono2#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);	
			fv = document.all.Pfax#Attributes.sufijo#.value;
			if(fv.length > 0)
				document.all._Pfax#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
			/*****Fin de carga****/
	
		}
		
		<!------------------------- Función que actualiza los valores de los campos de los Atr. Extendidos del agente ------------------------>
		function ActualizaValoresAgente#Attributes.sufijo#(id) {			
			var fr = document.getElementById("datosAgente#Attributes.sufijo#");			
			fr.src = "/cfmx/saci/utiles/agenteDatosAdicionalesUtiles.cfm?Ecodigo=#Attributes.Ecodigo#&id="+id+"&form_name=#Attributes.form#&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#&modo=#modo_agente#&tipo=#Attributes.TipodeAgente#";			
			return true;
		}
	
		<!---------- Aparece y desaparese los campos de de comision-monto y comision-porcenteajes, segun el dominio de Tipo de Comision ------------------------>
		function muestraPorcentaje#Attributes.sufijo#() {			
			document.getElementById('comisionMontoL#Attributes.sufijo#').style.display = 'none';
			document.getElementById('comisionMonto#Attributes.sufijo#').style.display = 'none';  
			document.getElementById('comisionPorcL#Attributes.sufijo#').style.display = 'none'; 
			document.getElementById('comisionPorc#Attributes.sufijo#').style.display = 'none'; 
			
			if (document.#Attributes.form#.AAcomisionTipo#Attributes.sufijo#.value == "1") {
				document.getElementById('comisionPorcL#Attributes.sufijo#').style.display = '';	
				document.getElementById('comisionPorc#Attributes.sufijo#').style.display = '';	
			}
			
			if (document.#Attributes.form#.AAcomisionTipo.value == "2") {
				document.getElementById('comisionMontoL#Attributes.sufijo#').style.display = '';
				document.getElementById('comisionMonto#Attributes.sufijo#').style.display = '';	
			}
			
		}
		
		function onchangeAgente#Attributes.sufijo#() {
			funcionesOnchange#Attributes.sufijo#();
			muestraPorcentaje#Attributes.sufijo#();
			<cfif isdefined('Attributes.TipodeAgente') and Attributes.TipodeAgente eq "Externo">		
				ActualizaValoresExtendidos#Attributes.sufijo#2(3,document.#Attributes.form#.AGid#Attributes.sufijo#.value);
			</cfif>
		}
		
		onchangeAgente#Attributes.sufijo#();
		
	</script>
</cfoutput>
