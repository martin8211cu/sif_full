<!--- Parametros del Tag --->
<cfparam 	name="Attributes.id"				type="string"	default="">						<!--- Id de la Persona--->
<cfparam 	name="Attributes.form"				type="string"	default="form1">				<!--- form--->
<cfparam 	name="Attributes.pais"				type="string"	default="#session.saci.pais#">	<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam 	name="Attributes.incluyeTabla" 		type="boolean"	default="true">					<!--- incluye tabla --->
<cfparam 	name="Attributes.porFila" 			type="boolean"	default="false">				<!--- se utiliza para indicar si se pintan los niveles por columna o fila --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.readonly" 			type="boolean"	default="false">				<!--- indica se se muestra el prospecto para consulta --->
<cfparam 	name="Attributes.verNombApPost"		type="boolean"	default="false">				<!--- Para indicar si se quiere ver la descripción de la zona postal --->


<cfif Attributes.readonly and Len(Trim(Attributes.id)) EQ 0>
	<cfthrow message="Error: para utilizar el atributo de readOnly se requiere enviar el atributo id">
</cfif>

<!--- Define el modo--->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
	<cfset Attributes.id = val(Attributes.id)><!--- cambia el formato del id --->
	<cfset ExisteProspecto = true>
<cfelse>
	<cfset ExisteProspecto = false>
</cfif>

<!--- Datos de la persona --->
<cfif ExisteProspecto>	
	<cfquery datasource="#Attributes.Conexion#" name="rsProspectoTag">
		select a.Pquien, 
			   a.Ppersoneria, 
			   a.Pid, 
			   a.Pnombre, 
			   a.Papellido, 
			   a.Papellido2, 
			   a.PrazonSocial, 
			   a.Ppais, 
			   a.Pobservacion, 
			   a.Pprospectacion, 
			   a.CPid as CPid#Attributes.sufijo#, 
			   rtrim(a.Papdo) as Papdo#Attributes.sufijo#, 
			   a.LCid, 
			   a.Pdireccion, 
			   a.Pbarrio, 
			   rtrim(a.Ptelefono1) as Ptelefono1, 
			   rtrim(a.Ptelefono2) as Ptelefono2, 
			   rtrim(a.Pfax) as Pfax, 
			   a.Pemail, 
			   a.Pfecha,
			   b.CPnombre,
			   a.ts_rversion
		from ISBprospectos a
			left outer join OficinaPostal b
				on b.CPid = a.CPid
				and b.Ppais = '#Attributes.pais#'
		where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#" null="#Len(Attributes.id) Is 0#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	</cfquery>
	
</cfif>

<!--- Consulta de Atributos Extendidos Juridicos--->
<cfquery datasource="#Attributes.Conexion#" name="rsAtrJuridico">
	select Aid,Aetiq,AtipoDato 
	from ISBatributo
	where Habilitado=1
		and AapJuridica=1
	order by Aid
</cfquery>
<!--- Consulta de Atributos Extendidos Fisicos, excluyendo los atributos que tambien son Juridico, pues ya fueros tomados en cuenta en la cunsulta de atributos Juridicos--->
<cfquery datasource="#Attributes.Conexion#" name="rsAtrFisico">
	select Aid,Aetiq,AtipoDato 
	from ISBatributo
	where Habilitado=1
		and AapFisica=1
		and AapJuridica=0
	order by Aid
</cfquery>

<!--- Se obtiene la máscara --->
<cfset mask = "">
<cfquery datasource="#Attributes.Conexion#" name="rsMask">
	select Pvalor 
		from ISBparametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	  and Pcodigo = 60
</cfquery>

<cfif rsMask.recordCount gt 0 and len(trim(rsMask.Pvalor))>
	<cfset mask = trim(rsMask.Pvalor)>
</cfif>



<cfoutput>
	<!--- PINTADO DE  LOS CAMPOS --->
	<cfset ts = "">
	<cfif ExisteProspecto>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				  artimestamp="#rsProspectoTag.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	</cfif>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<input type="hidden" name="ts_rversion#Attributes.sufijo#" value="#ts#">
	<input type="hidden" name="Pquien_Ant#Attributes.sufijo#" value="<cfif ExisteProspecto and isdefined("rsProspectoTag")>#rsProspectoTag.Pquien#</cfif>" />
	<input type="hidden" name="Pid_Ant#Attributes.sufijo#" value="<cfif ExisteProspecto and isdefined("rsProspectoTag")>#rsProspectoTag.Pid#</cfif>" />
	<cfif Attributes.incluyeTabla>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
	</cfif>
		<!--- identificador --->
		<!------<cfinclude template="/saci/utiles/prospecto_id.cfm">---->
		<cf_identificacion
			id = "#Attributes.id#"
			form = "#Attributes.form#"
			Ecodigo = "#Attributes.Ecodigo#"
			Conexion = "#Attributes.Conexion#"
			alignEtiquetas = "right"
			colspan = "1"
			incluyeTabla = "false"
			porFila = "true"
			sufijo = "#Attributes.sufijo#"
			readOnly="#Attributes.readonly#"
			keyProspecto = "#Attributes.readonly#"
		>
		<tr id="Juridic">
			<td align="right"  valign="middle"><label>Raz&oacute;n Social</label></td>
			<td align="left"  valign="middle" <cfif Attributes.porFila EQ False>colspan="5"</cfif>>
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.PrazonSocial))#
					<input type="hidden" name="PrazonSocial#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.PrazonSocial))#">
				<cfelse>
					<input name="PrazonSocial#Attributes.sufijo#" id="PrazonSocial#Attributes.sufijo#" type="text" value="<cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.PrazonSocial))#</cfif>" maxlength="100" onfocus="this.select()" style="width: 100%" tabindex="1" /> 				
				</cfif> 
			</td>
		</tr>
		<tr id="trNombreCompleto" align="left">
			<td align="right"  valign="middle"><label>Nombre</label></td>
			<td  align="left" valign="middle">
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Pnombre))#
					<input type="hidden" name="Pnombre#Attributes.sufijo#"  value="#HTMLEditFormat(Trim(rsProspectoTag.Pnombre))#">
				<cfelse>
					<input name="Pnombre#Attributes.sufijo#" id="Pnombre#Attributes.sufijo#" 
						value="<cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.Pnombre))#</cfif>" 
						type="text" 					
						maxlength="80"
						onblur="javascript: validaBlancos(this);"
						onfocus="this.select()" tabindex="1"/>
				</cfif> 
			<!---</td>--->
		<!---<cfif Attributes.porFila></tr><tr></cfif>--->
			<!---<td  align="left" valign="middle"><label>1er Apellido</label></td>--->
			<!---<td  align="left" valign="middle">--->
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Papellido))#
					<input type="hidden" name="Papellido#Attributes.sufijo#"  value="#HTMLEditFormat(Trim(rsProspectoTag.Papellido))#">
				<cfelse>
					<input name="Papellido#Attributes.sufijo#" id="Papellido#Attributes.sufijo#" 
						value="<cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.Papellido))#</cfif>" 
						type="text" 
						maxlength="30"
						onblur="javascript: validaBlancos(this);"
						onfocus="this.select()" tabindex="1" />
				</cfif> 
			<!---</td>--->
		<!---<cfif Attributes.porFila></tr><tr></cfif>--->
			<!---<td align="left"  valign="middle" id="apell2L"><label>2do Apellido</label></td>--->
			<!---<td  align="left" valign="middle" id="apell2T">--->
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Papellido2))#
					<input type="hidden" name="Papellido2#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Papellido2))#">
				<cfelse>
					<input name="Papellido2#Attributes.sufijo#" id="Papellido2#Attributes.sufijo#" 
						value="<cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.Papellido2))#</cfif>" 
						type="text" 
						maxlength="30"
						onfocus="this.select()" tabindex="1" />
				</cfif> 
			</td>
		</tr>
		<tr>
			<td align="right" id="paisOrL" valign="middle"><label>Pa&iacute;s de Origen</label></td>
			<td align="left" id="paisOrT" valign="middle">
				<cfif ExisteProspecto>
					<cfset idpais = rsProspectoTag.Ppais>
				<cfelse>
					<cfset idpais = Attributes.pais>
				</cfif>
				<cf_pais
					id = "#idpais#"
					form = "#Attributes.form#"
					sufijo = "#Attributes.sufijo#"
					readOnly = "#Attributes.readonly#"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
				>
			</td>
		<tr align="left">
			<td  align="right" valign="middle"><label>Tel&eacute;fono</label></td>
			<td  align="left" valign="middle">
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Ptelefono1))#
					<input type="hidden" name="Ptelefono1#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Ptelefono1))#" id="Ptelefono1#Attributes.sufijo#" >
				<cfelse>
					<cfset tel = "">
					<cfif isdefined("rsPersonaTag")>
						<cfset tel = HTMLEditFormat(Trim(rsPersonaTag.Ptelefono1))>
					</cfif>
					<input type="hidden" name="Ptelefono1#Attributes.sufijo#" value="#tel#" id="Ptelefono1#Attributes.sufijo#" >
					<input name="_Ptelefono1#Attributes.sufijo#"
						type="text" 					
						size="20" 
						maxlength="15" 
						onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.Ptelefono1#Attributes.sufijo#);"
						onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.Ptelefono1#Attributes.sufijo#);"
						onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.Ptelefono1#Attributes.sufijo#.value)"
						value=""
						style="text-align:right;"
					>						
					<!---<font style="font-weight: normal; font-family: Arial, Verdana; font-size: xx-small; color: gray;">#mask#</font>--->
						
				</cfif> 			
			<!---</td>--->
		<!---<cfif Attributes.porFila></tr><tr></cfif>--->
			<!---<td  align="right" valign="middle"><label>Tel&eacute;fono 2</label></td>--->
			<label>Tel&eacute;fono 2</label>
			<!---<td  align="left" valign="middle">--->
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Ptelefono2))#
					<input type="hidden" name="Ptelefono2#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Ptelefono2))#" id="Ptelefono2#Attributes.sufijo#" >
				<cfelse>
					<cfset tel = "">
					<cfif isdefined("rsPersonaTag")>
						<cfset tel = HTMLEditFormat(Trim(rsPersonaTag.Ptelefono2))>
					</cfif>
					<input type="hidden" name="Ptelefono2#Attributes.sufijo#" value="#tel#" id="Ptelefono2#Attributes.sufijo#" >
					<input name="_Ptelefono2#Attributes.sufijo#"
						type="text" 					
						size="20" 
						maxlength="15" 
						onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.Ptelefono2#Attributes.sufijo#);"
						onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.Ptelefono2#Attributes.sufijo#);"
						onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.Ptelefono2#Attributes.sufijo#.value)"
						value=""
						style="text-align:right;"
					>						
					<!---<font style="font-weight: normal; font-family: Arial, Verdana; font-size: xx-small; color: gray;">#mask#</font>--->
					</cfif> 			
			<!---</td>--->
		<!---<cfif Attributes.porFila></tr><tr></cfif>--->
			<!---<td align="right" valign="middle"><label>Fax</label></td>--->
			<label>Fax</label>
			<!---<td align="left"  valign="middle">--->
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Pfax))#
					<input type="hidden" name="Pfax#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Pfax))#" id="Pfax#Attributes.sufijo#" >
				<cfelse>
					<cfset tel = "">
					<cfif isdefined("rsPersonaTag")>
						<cfset tel = HTMLEditFormat(Trim(rsPersonaTag.Pfax))>
					</cfif>
					<input type="hidden" name="Pfax#Attributes.sufijo#" value="#tel#" id="Pfax#Attributes.sufijo#" >
					<input name="_Pfax#Attributes.sufijo#"
						type="text" 					
						size="20" 
						maxlength="15" 
						onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.Pfax#Attributes.sufijo#);"
						onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.Pfax#Attributes.sufijo#);"
						onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.Pfax#Attributes.sufijo#.value)"
						value=""
						style="text-align:right;"
					>						
					
					<font  style="border:0;font-style:italic; background-color:transparent;">Capturar como: #mask#</font>
				</cfif> 						
			</td>
		</tr>
		
		<tr>
			  <td  align="right" valign="middle"><label>Apdo Postal</label></td>
			  <td align="left"  valign="middle">
				<cfif ExisteProspecto>
					<cfset queryDef = rsProspectoTag>
				<cfelse>
					<cfset queryDef = QueryNew('indefinido')>
				</cfif>
				<cf_apdopostal
					query = "#queryDef#"
					pais = "#Attributes.pais#"
					form = "#Attributes.form#"
					sufijo = "#Attributes.sufijo#"
					verNombre="#Attributes.verNombApPost#"
					readonly="#Attributes.readonly#"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
				>
			  </td>
		<cfif Attributes.porFila></tr><tr></cfif>
			  <td  align="right" valign="middle"><label>E-mail</label></td>
			  <td  align="left" valign="middle">
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Pemail))#
					<input type="hidden" name="Pemail#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Pemail))#">
				<cfelse>
					<input name="Pemail#Attributes.sufijo#" id="Pemail#Attributes.sufijo#" 
					 	onBlur="javascript: emailCheck#Attributes.sufijo#(this.value);"
						value="<cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.Pemail))#</cfif>" 
						type="text" 
						size="30" maxlength="50"
						onfocus="this.select()" tabindex="1" />
				</cfif> 			  
			  </td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		</tr>
			<cfset LlaveLocalidad = "">
			<cfif ExisteProspecto>
				<cfset LlaveLocalidad = rsProspectoTag.LCid>
			</cfif>
			
			<cf_localidad 
				id = "#LlaveLocalidad#"
				pais = "#Attributes.pais#"
				form = "form1"
				incluyeTabla = "false"
				alignEtiquetas = "right"
				sufijo = "#Attributes.sufijo#"
				readOnly = "#Attributes.readonly#"
				Ecodigo = "#Attributes.Ecodigo#"
				Conexion = "#Attributes.Conexion#"
			>
		
		<tr>
			<td align="right" valign="middle" width="11%"><label>Barrio</label></td>
			<td colspan="5" align="left" valign="middle">
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Pbarrio))#
					<input type="hidden" name="Pbarrio#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Pbarrio))#">
				<cfelse>
					<input name="Pbarrio#Attributes.sufijo#" id="Pbarrio#Attributes.sufijo#" 
						value="<cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.Pbarrio))#</cfif>" 
						type="text" 
						maxlength="80" 
						onfocus="this.select()" 
						style="width: 100%" tabindex="1" />
				</cfif> 				
			</td>		
		</tr>
	
		<tr>
			<td align="right" valign="middle" nowrap><label>Direcci&oacute;n Exacta</label></td>
			<td align="left" valign="middle" colspan="5">
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Pdireccion))#
					<input type="hidden" name="Pdireccion#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Pdireccion))#">
				<cfelse>
					<input name="Pdireccion#Attributes.sufijo#" id="Pdireccion#Attributes.sufijo#" 
						value="<cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.Pdireccion))#</cfif>" 
						type="text" 
						maxlength="1024" 
						onfocus="this.select()"  
						style="width: 100%" tabindex="1"/>						
				</cfif> 			
			</td>
		</tr>
		<tr>
			<td align="right" valign="top"><label>Observaciones</label></td>
			<td align="left" valign="middle" colspan="5">
				<cfif Attributes.readonly>
					#HTMLEditFormat(Trim(rsProspectoTag.Pobservacion))#
					<input type="hidden" name="Pobservacion#Attributes.sufijo#" value="#HTMLEditFormat(Trim(rsProspectoTag.Pobservacion))#">
				<cfelse>
					<textarea name="Pobservacion#Attributes.sufijo#" id="Pobservacion#Attributes.sufijo#"
						<cfif Attributes.readonly> readonly="true"</cfif>
						rows="3" 
						style="width: 100%" 
						tabindex="1"><cfif ExisteProspecto>#HTMLEditFormat(Trim(rsProspectoTag.Pobservacion))#</cfif></textarea>							
				</cfif> 					
			</td>
		</tr>
	<cfif Attributes.incluyeTabla>
		</table>
	</cfif>
  
</cfoutput>

<script type="text/javascript">
	
	
	<cfoutput>
	<!--- caso en que viene como parametro el id, al hacer clic en otro tab y volver, para que no se pierda el identificador--->
	<cfif ExisteProspecto>
		document.#Attributes.form#.Pid#Attributes.sufijo#.value = "#rsProspectoTag.Pid#";
		document.#Attributes.form#.CPid#Attributes.sufijo#.value = "#Evaluate('rsProspectoTag.CPid' & Attributes.sufijo)#";
	</cfif>
	document.#Attributes.form#.imagenPquien#Attributes.sufijo#.style.display = "none";
	
	function resetPersona() {
		<!---if ((document.#Attributes.form#.Pid.value != document.#Attributes.form#.Pid_Ant.value) && (document.#Attributes.form#.Pquien.value == document.#Attributes.form#.Pquien_Ant.value)) {--->
		if ((document.#Attributes.form#.PidSinMask#Attributes.sufijo#.value != document.#Attributes.form#.Pid_Ant#Attributes.sufijo#.value) && (document.#Attributes.form#.Pquien#Attributes.sufijo#.value == document.#Attributes.form#.Pquien_Ant#Attributes.sufijo#.value)) {
			 document.#Attributes.form#.Pquien#Attributes.sufijo#.value = ""; 
		}
		document.#Attributes.form#.Pquien_Ant#Attributes.sufijo#.value = document.#Attributes.form#.Pquien#Attributes.sufijo#.value; 
		document.#Attributes.form#.Pid_Ant#Attributes.sufijo#.value = document.#Attributes.form#.PidSinMask#Attributes.sufijo#.value;
		<!---document.#Attributes.form#.Pid_Ant.value = document.#Attributes.form#.Pid.value;--->
	}
	
	<!--- Aparece y desaparece los campos que son especficos para las personas de tipo Jurdico --->
	function esJuridica()
	{
		<!--- resetPersona(); --->
		var tipo = document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value; 
		if (tipo=="J") {
			document.getElementById('trNombreCompleto').style.display='none'; 	<!--- Nombre Completo --->
			document.getElementById('Juridic').style.display='';				<!--- Razon Social --->
			document.getElementById('paisOrL').style.display='none';			<!--- Etiqueta Pais --->
			document.getElementById('paisOrT').style.display='none';			<!--- Campo Pais --->
		} else if(tipo=="F") {
			document.getElementById('trNombreCompleto').style.display=''; 		<!--- Nombre Completo --->
			document.getElementById('Juridic').style.display='none';			<!--- Razon Social --->
			document.getElementById('paisOrL').style.display='none';			<!--- Etiqueta Pais --->
			document.getElementById('paisOrT').style.display='none';			<!--- Campo Pais --->
		} else if((tipo=="E") || (tipo=="R")) {
			document.getElementById('trNombreCompleto').style.display=''; 		<!--- Nombre Completo --->
			document.getElementById('Juridic').style.display='none';			<!--- Razon Social --->
			document.getElementById('paisOrL').style.display='';				<!--- Etiqueta Pais --->
			document.getElementById('paisOrT').style.display='';				<!--- Campo Pais --->
		}
	}

	function validarProspecto(formulario) {
		var error_input;
		var error_msg = '';

		if (formulario.Ppersoneria#Attributes.sufijo#.value == "") {
			error_msg += "\n - Personería no puede quedar en blanco.";
			error_input = formulario.Ppersoneria#Attributes.sufijo#;
		}
		
		if (formulario.Ppersoneria#Attributes.sufijo#.value != "") {
			if (formulario.Ppersoneria#Attributes.sufijo#.value == 'J') {
				if (formulario.PrazonSocial#Attributes.sufijo#.value == "") {
					error_msg += "\n - La razón social no puede quedar en blanco.";
					error_input = formulario.PrazonSocial#Attributes.sufijo#;
				}
			} else {
				if (formulario.Pnombre#Attributes.sufijo#.value == "") {
					error_msg += "\n - Nombre no puede quedar en blanco.";
					error_input = formulario.Pnombre#Attributes.sufijo#;
				}

				if (formulario.Papellido#Attributes.sufijo#.value == "") {
					error_msg += "\n - 1er Apellido no puede quedar en blanco.";
					error_input = formulario.Papellido#Attributes.sufijo#;
				}
			}
		}
		
		if (trim(formulario.Ptelefono1#Attributes.sufijo#.value) == "") {
			error_msg += "\n - Teléfono no puede quedar en blanco.";
			error_input = formulario.Ptelefono1#Attributes.sufijo#;
		}

		
		
		<cfquery name="rsNiveles" datasource="#session.DSN#">
			select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
			from DivisionPolitica
			where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.pais#">
		</cfquery>

		<cfset minnivel = rsNiveles.minNivel>
		<cfset maxnivel = rsNiveles.maxNivel>
		<cfloop condition="maxnivel GTE minnivel">
			if (formulario.LCcod_#minnivel#.value == "") {
				error_msg += "\n - " + formulario.LCcod_#minnivel#.alt + " no puede quedar en blanco.";
				error_input = formulario.LCcod_#minnivel#;
			}
			<cfset minnivel = minnivel + 1>
		</cfloop>
		
		<!--- Validacion terminada --->
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		if(!emailCheck#Attributes.sufijo#(formulario.Pemail#Attributes.sufijo#.value))
			return false;
					
		return true;
	}
	
	/*	-------------------------	VALIDACION DE DIRECCION DE CORREO	--------------------------*/

	function emailCheck#Attributes.sufijo# (emailStr) {
		if(emailStr == '')
			return true;
		/* The following variable tells the rest of the function whether or not
		to verify that the address ends in a two-letter country or well-known
		TLD.  1 means check it, 0 means don't. */
		var checkTLD=1;
		/* The following is the list of known TLDs that an e-mail address must end with. */
		var knownDomsPat=/^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum)$/;
		/* The following pattern is used to check if the entered e-mail address
		fits the user@domain format.  It also is used to separate the username
		from the domain. */
		var emailPat=/^(.+)@(.+)$/;
		/* The following string represents the pattern for matching all special
		characters.  We don't want to allow special characters in the address. 
		These characters include ( ) < > @ , ; : \ " . [ ] */
		var specialChars="\\(\\)><@,;:\\\\\\\"\\.\\[\\]";
		/* The following string represents the range of characters allowed in a 
		username or domainname.  It really states which chars aren't allowed.*/
		var validChars="\[^\\s" + specialChars + "\]";
		/* The following pattern applies if the "user" is a quoted string (in
		which case, there are no rules about which characters are allowed
		and which aren't; anything goes).  E.g. "jiminy cricket"@disney.com
		is a legal e-mail address. */
		var quotedUser="(\"[^\"]*\")";
		/* The following pattern applies for domains that are IP addresses,
		rather than symbolic names.  E.g. joe@[123.124.233.4] is a legal
		e-mail address. NOTE: The square brackets are required. */
		var ipDomainPat=/^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;
		/* The following string represents an atom (basically a series of non-special characters.) */
		var atom=validChars + '+';
		/* The following string represents one word in the typical username.
		For example, in john.doe@somewhere.com, john and doe are words.
		Basically, a word is either an atom or quoted string. */
		var word="(" + atom + "|" + quotedUser + ")";
		// The following pattern describes the structure of the user
		var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
		/* The following pattern describes the structure of a normal symbolic
		domain, as opposed to ipDomainPat, shown above. */
		var domainPat=new RegExp("^" + atom + "(\\." + atom +")*$");
		/* Finally, let's start trying to figure out if the supplied address is valid. */
		/* Begin with the coarse pattern to simply break up user@domain into
		different pieces that are easy to analyze. */
		var matchArray=emailStr.match(emailPat);
		if (matchArray==null) {
		/* Too many/few @'s or something; basically, this address doesn't
		even fit the general mould of a valid e-mail address. */
		alert("La dirección de correo esta incorrecta (revice @ y .'s)");
		return false;
		}
		var user=matchArray[1];
		var domain=matchArray[2];
		
		// Start by checking that only basic ASCII characters are in the strings (0-127).
		
		for (i=0; i<user.length; i++) {
		if (user.charCodeAt(i)>127) {
		alert("El nombre de usuario en la dirección de correo contiene caracteres inválidos.");
		return false;
		   }
		}
		for (i=0; i<domain.length; i++) {
		if (domain.charCodeAt(i)>127) {
		alert("El nombre del dominio en la dirección de correo contiene caracteres inválidos.");
		return false;
		   }
		}
		
		// See if "user" is valid 
		
		if (user.match(userPat)==null) {
		
		// user is not valid
		
		alert("El nombre de usuario en la dirección de correo no es válido.");
		return false;
		}
		
		/* if the e-mail address is at an IP address (as opposed to a symbolic
		host name) make sure the IP address is valid. */
		
		var IPArray=domain.match(ipDomainPat);
		if (IPArray!=null) {
		
		// this is an IP address
		
		for (var i=1;i<=4;i++) {
		if (IPArray[i]>255) {
		alert("La dirección IP de destino en la dirección de correo es inválida!");
		return false;
		   }
		}
		return true;
		}
		
		// Domain is symbolic name.  Check if it's valid.
		 
		var atomPat=new RegExp("^" + atom + "$");
		var domArr=domain.split(".");
		var len=domArr.length;
		for (i=0;i<len;i++) {
		if (domArr[i].search(atomPat)==-1) {
		alert("El nombre del dominio en la dirección de correo no es válido.");
		return false;
		   }
		}
		
		/* domain name seems valid, but now make sure that it ends in a
		known top-level domain (like com, edu, gov) or a two-letter word,
		representing country (uk, nl), and that there's a hostname preceding 
		the domain or country. */
		
		if (checkTLD && domArr[domArr.length-1].length!=2 && 
		domArr[domArr.length-1].search(knownDomsPat)==-1) {
		alert("La dirección de correo debería terminar en un dominio bien conocido o en dos letras del país.");
		return false;
		}
		
		// Make sure there's a host name preceding the domain.
		
		if (len<2) {
		alert("Se olvidó de digitar el nombre del host para la dirección de correo!");
		return false;
		}
		
		// If we've gotten this far, everything's valid!
		return true;
	}
	/*	-------------------------	FIN DE VALIDACION DE DIRECCION DE CORREO	--------------------------*/	
	
	esJuridica();
	
	
	function validateMask#Attributes.sufijo#(obj, aux){
		var r = "<cfoutput>#mask#</cfoutput>";
		
		if(r.length==0)
			return true;
		else if(r.length == obj.value.length)
			return true;
		if(aux.value.length > 0){
			//alert("El número digitado no corresponde con la máscara");
			aux.value = "";
			obj.value = "";
			return true;
		}else{
			aux.value = "";
			obj.value = "";
			return true;
		}
		return false;
	}
	
	function textToMask#Attributes.sufijo#(v){
		var r = "<cfoutput>#mask#</cfoutput>";
		var re = new RegExp("##");
		
		if(r.length == 0) return v;
		
		if(v.length == 0) return "";
		
		var c = "";
		for(i=0;i<v.length;i++){
				c = v.substr(i,1);
				r = r.replace(re,c);
		}
		for(i=0;(i<r.length && r.substr(i,1)!="##");i++);
		
		return r.substring(0,i);
	}
	
	function filtraChars#Attributes.sufijo#(e, obj, aux){
		var m = "<cfoutput>#mask#</cfoutput>";
		var cl = e.keyCode;
		if(obj.value.length <= m.length && !e.shiftKey){
			
			if((cl > 47)&&(cl<58)){
				aux.value += String.fromCharCode(cl);
				obj.value = textToMask#Attributes.sufijo#(aux.value);
			}else if((cl > 95)&&(cl<106)){
				aux.value += String.fromCharCode(cl-48);
				obj.value = textToMask#Attributes.sufijo#(aux.value);
			}else if(cl==8){
					aux.value=aux.value.substring(0,aux.value.length-1);
					obj.value = textToMask#Attributes.sufijo#(aux.value);
				}
				else
					obj.value = textToMask#Attributes.sufijo#(aux.value);
			
		}else{
			obj.value=obj.value.substring(0,obj.value.length-1);
		}
	}
	</cfoutput>
</script>