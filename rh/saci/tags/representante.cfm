<!--- Parametros del Tag --->
<cfparam 	name="Attributes.id_representante"		type="string"	default="-1">						<!--- Id del representante--->
<cfparam 	name="Attributes.id_duena"				type="string"	default="#session.saci.persona.id#"><!--- Id de la persona dueña del Representante--->
<cfparam 	name="Attributes.identificacion"		type="string"	default="">							<!--- Identificacion del Agente--->
<cfparam 	name="Attributes.form"					type="string"	default="form1">					<!--- form--->
<cfparam 	name="Attributes.porFila" 			type="boolean"	default="false">					<!--- se utiliza para indicar si se pintan los niveles por columna o fila ---><cfparam 	name="Attributes.funcion"		type="string"	default="">						<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam	name="Attributes.filtrarPersoneria"		type="string"	default="">							<!--- Se usa para filtrar los tipos de personeria que se requieren, se envían los códigos que se desean mostrar --->
<cfparam 	name="Attributes.pais"					type="string"	default="#session.saci.pais#">		<!--- Pais en caso de ser necesario--->
<cfparam 	name="Attributes.sufijo" 				type="string"	default="">							<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.Ecodigo" 				type="string"	default="#Session.Ecodigo#">		<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 				type="string"	default="#Session.DSN#">			<!--- cache de conexion --->
<cfparam 	name="Attributes.personeria" 			type="string"	default="">							<!--- Personeria del agente o cliente --->

<!------------- Selecciona los Datos del Representante en caso de que el id este definido en los atributos ------->

<cfif isdefined("Attributes.id_representante") and len(trim(Attributes.id_representante)) and Attributes.id_representante neq "-1">
	<cfquery datasource="#Attributes.Conexion#" name="rsRepresentanteTag">
		select Rid,Pcontacto,RJtipo,BMUsucodigo,ts_rversion
		from ISBpersonaRepresentante
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_duena#">
		and Pcontacto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_representante#">
	</cfquery>
</cfif>
 
<!------------------------------------ Define el modo agente ----------------------------------------------->
<cfset ExisteRepresentante = isdefined("rsRepresentanteTag") and rsRepresentanteTag.Recordcount GT 0>

<!------------------------------------ Pinta los campos ----------------------------------------------->
<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr><td align="right"><label>Tipo de Contacto</label>
		</td><td>
		
			
			
			<select name="RJtipo#Attributes.sufijo#" id="RJtipo#Attributes.sufijo#" tabindex="1">
				
				
				<cfif Attributes.personeria eq 'J'>
					<option value="L" <cfif ExisteRepresentante and rsRepresentanteTag.RJtipo is 'L'> selected</cfif>>Legal</option>
				<cfelse>
					<option value="L" <cfif ExisteRepresentante and rsRepresentanteTag.RJtipo is 'L'> selected</cfif>>Legal</option>
					<option value="A" <cfif ExisteRepresentante and rsRepresentanteTag.RJtipo is 'A'> selected</cfif>>Administrativo</option>
				</cfif>
				<!---option value="T" <cfif ExisteRepresentante and rsRepresentanteTag.RJtipo is 'T'> selected</cfif>>T&eacute;cnico</option>--->				
				<!---<option value="G" <cfif ExisteRepresentante and rsRepresentanteTag.RJtipo is 'G'> selected</cfif>>Gerencial</option>
				<option value="F" <cfif ExisteRepresentante and rsRepresentanteTag.RJtipo is 'F'> selected</cfif>>Financiero</option>
				<option value="O" <cfif ExisteRepresentante and rsRepresentanteTag.RJtipo is 'O'> selected</cfif>>Otro</option>--->
			</select>
		</td></tr>
		<!--- Tag Persona --->
		<cfset id_representante= "">
		<cfset id_PerRepre= "">
		<cfif ExisteRepresentante>
			<cfset id_representante= rsRepresentanteTag.Pcontacto>
			<cfset id_PerRepre= rsRepresentanteTag.Rid>
		</cfif>
		<cf_persona
			id="#id_representante#"
			form="#Attributes.form#"
			incluyeTabla="false"
			porFila="#Attributes.porFila#"
			columnas="1"
			filtrarPersoneria="#Attributes.filtrarPersoneria#"
			pais="#Attributes.pais#"
			funcion = "CargarValoresRepresentante#Attributes.sufijo#"
			sufijo= "#Attributes.sufijo#"
			TypeLocation = "R"
			RefIdLocation = "#id_PerRepre#"
			id_duenno = "#Attributes.id_duena#"
		>
		<!---<input type="hidden" name="Pquien#Attributes.sufijo#" id="Pquien#Attributes.sufijo#" value="#id_representante#"/>--->
	</table>

	<!------------------------------ Sentencia Iframe-------------------------------->
	<iframe id="datosRepresentante#Attributes.sufijo#" name="datosRepresentante#Attributes.sufijo#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>

	<script language="javascript1.2" type="text/javascript">
	<!--	
		<!----------------------- Refresca los valores del agente----------------------------------------->
		function CargarValoresRepresentante#Attributes.sufijo#() {
			
			ResetValoresRepresentante#Attributes.sufijo#();
			var id_p = '#Attributes.id_duena#';
			var id_c = document.#Attributes.form#.Pquien#Attributes.sufijo#.value;
			var personeria = document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value;
			ActualizaValoresRepresentante#Attributes.sufijo#(id_c,id_p);
		}
		<!----------------------- Reset de los campos adicionales para el agente----------------------------------------->
		function ResetValoresRepresentante#Attributes.sufijo#()
		{	
			//document.#Attributes.form#.RJtipo#Attributes.sufijo#.value="";
		}
		<!------------------------- Función que actualiza los valores de los campos de los Atr. Extendidos del Representante ------------------------>
		function ActualizaValoresRepresentante#Attributes.sufijo#(id_c,id_p) {
			
			CargarValoresPersona#Attributes.sufijo#();
			var frame = document.getElementById("datosRepresentante#Attributes.sufijo#");
			frame.src = "/cfmx/saci/utiles/representanteDatosAdicionalesUtiles.cfm?id_p="+id_p+"&id_c="+id_c+"&form_name=#Attributes.form#&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#";
			return true;
		}
		
		function ValidarRepresentante(formulario) 
		{
			var error_input;
			var error_msg = '';
		    
			if (document.form1.botonSel.value == 'Guardar') 
			{
				if( formulario.RJtipo#Attributes.sufijo#.value == "L")
				{
					if( formulario.RJtipo#Attributes.sufijo#.value == "")
					{
						error_msg += "\n - Dede seleccionar el Tipo de Contacto.";
						error_input = formulario.RJtipo#Attributes.sufijo#;
					}
					
					if (formulario.Ppersoneria#Attributes.sufijo#.value == "") 
					{
						error_msg += "\n - Personería no puede quedar en blanco.";
						error_input = formulario.Ppersoneria#Attributes.sufijo#;
					}
			
					if (formulario.Pid#Attributes.sufijo#.value == "") 
					{
						error_msg += "\n - Identificación no puede quedar en blanco.";
						error_input = formulario.Pid#Attributes.sufijo#;
					} else if (!validar_identificacion#Attributes.sufijo#()) 
					{
						error_msg += "\n - La Identificación no cumple con la máscara permitida.";
						error_input = formulario.Pid#Attributes.sufijo#;
					}
					
					if (formulario.Ppersoneria#Attributes.sufijo#.value != "") 
					{
						if (formulario.Ppersoneria#Attributes.sufijo#.value == 'J') 
						{
							if (formulario.PrazonSocial#Attributes.sufijo#.value == "") 
							{
								error_msg += "\n - La razón social no puede quedar en blanco.";
								error_input = formulario.PrazonSocial#Attributes.sufijo#;
							}
						} 
						else 
						{
							if (trim(formulario.Pnombre#Attributes.sufijo#.value) == "") 
							{
								error_msg += "\n - Nombre no puede quedar en blanco.";
								error_input = formulario.Pnombre#Attributes.sufijo#;
							}
			
							if (trim(formulario.Papellido#Attributes.sufijo#.value) == "") 
							{
								error_msg += "\n - 1er Apellido no puede quedar en blanco.";
								error_input = formulario.Papellido#Attributes.sufijo#;
							}
						}
					}
					
					if (formulario.Ppais#Attributes.sufijo#.value == "") 
					{
						error_msg += "\n - País no puede quedar en blanco.";
						error_input = formulario.Ppais#Attributes.sufijo#;
					}
			
					if (formulario.AEactividad#Attributes.sufijo#.value == "") 
					{
						error_msg += "\n - Actividad Económica no puede quedar en blanco.";
						error_input = formulario.AEactividad#Attributes.sufijo#;
					}
					
					if (formulario.Ptelefono1#Attributes.sufijo#.value == "") 
					{
						error_msg += "\n - Teléfono no puede quedar en blanco.";
						error_input = formulario.Ptelefono1#Attributes.sufijo#;
					}
			

					if (formulario.CPid#Attributes.sufijo#.value == "") {
						formulario.Papdo#Attributes.sufijo#.value = "";
					}
					
					<cfquery name="rsNiveles" datasource="#session.dsn#">
						select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
						from DivisionPolitica
						where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
					</cfquery>
					<cfset minnivel = rsNiveles.minNivel>
					<cfset maxnivel = rsNiveles.maxNivel>
					<cfloop condition="maxnivel GTE minnivel">
						if (formulario.LCcod_#minnivel##Attributes.sufijo#.value == "") 
						{
							error_msg += "\n - " + formulario.LCcod_#minnivel##Attributes.sufijo#.alt + " no puede quedar en blanco.";
							error_input = formulario.LCcod_#minnivel##Attributes.sufijo#;
						}
						<cfset minnivel = minnivel + 1>
					</cfloop>
				}
				else
				{  <!--- *** Cuando tipo de contacto es diferente de Legal realiza estas validaciones *** --->
						
					if (formulario.Pid#Attributes.sufijo#.value == "") 
					{
						error_msg += "\n - Identificación no puede quedar en blanco.";
						error_input = formulario.Pid#Attributes.sufijo#;
					} else if (!validar_identificacion#Attributes.sufijo#()) 
					{
						error_msg += "\n - La Identificación no cumple con la máscara permitida.";
						error_input = formulario.Pid#Attributes.sufijo#;
					}						
						
					if (trim(formulario.Pnombre#Attributes.sufijo#.value) == "") 
					{
						error_msg += "\n - Nombre no puede quedar en blanco.";
						error_input = formulario.Pnombre#Attributes.sufijo#;
					}
	
					if (trim(formulario.Papellido#Attributes.sufijo#.value) == "") 
					{
						error_msg += "\n - 1er Apellido no puede quedar en blanco.";
						error_input = formulario.Papellido#Attributes.sufijo#;
					}				
					  
					if (formulario.Ptelefono1#Attributes.sufijo#.value == "") 
					{
						error_msg += "\n - Teléfono no puede quedar en blanco.";
						error_input = formulario._Ptelefono1#Attributes.sufijo#;
					}																
						
					if (formulario.CPid#Attributes.sufijo#.value == "") {
						formulario.Papdo#Attributes.sufijo#.value = "";
					}
				} 
			}
			
	
				if(!emailCheck#Attributes.sufijo#(formulario.Pemail#Attributes.sufijo#.value))
					return false;			

			
			
			// Validacion terminada
			if (error_msg.length != "") 
			{
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			else 
			{
				eliminaMascara#Attributes.sufijo#();//esta funcion se encuentra dentro del tag de identificacion, y quita los '-','[' y ']' de la identificacion.
				if (document.form1.botonSel.value == 'Eliminar')
				{
					if(confirm('¿Esta seguro que desea eliminar el registro?') == false)return false;
				}	
			}
			return true;
		}
	//-->
	</script>
</cfoutput>
