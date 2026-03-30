<!--- Parametros del Tag --->
<cfparam 	name="Attributes.id_contacto"			type="string"	default="-1">						<!--- Id del contacto--->
<cfparam 	name="Attributes.id_cuenta"				type="string"	default="-1">						<!--- Id de la cuenta a la que queremos agregar el contacto--->
<cfparam 	name="Attributes.identificacion"		type="string"	default="">							<!--- Identificacion del Agente--->
<cfparam 	name="Attributes.form"					type="string"	default="form1">					<!--- form--->
<cfparam 	name="Attributes.porFila" 			type="boolean"	default="false">					<!--- se utiliza para indicar si se pintan los niveles por columna o fila ---><cfparam 	name="Attributes.funcion"		type="string"	default="">						<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam	name="Attributes.filtrarPersoneria"		type="string"	default="">							<!--- Se usa para filtrar los tipos de personeria que se requieren, se envían los códigos que se desean mostrar --->
<cfparam 	name="Attributes.pais"					type="string"	default="#session.saci.pais#">		<!--- Pais en caso de ser necesario--->
<cfparam 	name="Attributes.sufijo" 				type="string"	default="">							<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.Ecodigo" 				type="string"	default="#Session.Ecodigo#">		<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 				type="string"	default="#Session.DSN#">			<!--- cache de conexion --->


<!------------- Selecciona los Datos del contacto en caso de que el id este definido en los atributos ------->

<cfif isdefined("Attributes.id_contacto") and len(trim(Attributes.id_contacto)) and Attributes.id_contacto neq "-1">
	<cfquery datasource="#Attributes.Conexion#" name="rsContactoTag">
		select *
		from ISBcontactoCta
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_cuenta#" null="#Len(Attributes.id_cuenta) Is 0#">
		and Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_contacto#" null="#Len(Attributes.id_contacto) Is 0#">
	</cfquery>
</cfif>
 
<!------------------------------------ Define el modo agente ----------------------------------------------->
<cfset modo_contacto = "ALTA">
<cfif isdefined("rsContactoTag") and rsContactoTag.Recordcount GT 0>
	<cfset modo_contacto = "CAMBIO">
</cfif>

<!------------------------------------ Pinta los campos ----------------------------------------------->
<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr><td align="right"><label>Tipo de contacto</label>
		</td><td>
			<select name="CCtipo#Attributes.sufijo#" id="CCtipo#Attributes.sufijo#" tabindex="1">
				<option value="L" <cfif modo_contacto NEQ "ALTA" and rsContactoTag.CCtipo is 'L'> selected</cfif>>Legal</option>
				<option value="T" <cfif modo_contacto NEQ "ALTA" and rsContactoTag.CCtipo is 'T'> selected</cfif>>T&eacute;cnico</option>
				<option value="A" <cfif modo_contacto NEQ "ALTA" and rsContactoTag.CCtipo is 'A'> selected</cfif>>Administrativo</option>
				<option value="G" <cfif modo_contacto NEQ "ALTA" and rsContactoTag.CCtipo is 'G'> selected</cfif>>Gerencial</option>
				<option value="F" <cfif modo_contacto NEQ "ALTA" and rsContactoTag.CCtipo is 'F'> selected</cfif>>Financiero</option>
				<option value="O" <cfif modo_contacto NEQ "ALTA" and rsContactoTag.CCtipo is 'O'> selected</cfif>>Otro</option>
			</select>
		</td></tr>
		<!--- Tag Persona --->
		<cfset id_contacto= "">
		<cfif modo_contacto NEQ "ALTA">
			<cfset id_contacto= rsContactoTag.Pquien>
		</cfif>
		<cf_persona
			id="#id_contacto#"
			form="#Attributes.form#"
			incluyeTabla="false"
			porFila="#Attributes.porFila#"
			filtrarPersoneria="#Attributes.filtrarPersoneria#"
			pais="#Attributes.pais#"
			funcion = "CargarValoresContacto#Attributes.sufijo#"
			sufijo="#Attributes.sufijo#"
			columnas="2"
		>
		
	</table>

	<!------------------------------ Sentencia Iframe-------------------------------->
	<iframe id="datosContacto" name="datosContacto" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>

	<script language="javascript1.2" type="text/javascript">
		<!----------------------- Refresca los valores del agente----------------------------------------->
		function CargarValoresContacto#Attributes.sufijo#() {
			
			var id_p = '#Attributes.id_cuenta#';
			var id_c = document.#Attributes.form#.Pquien#Attributes.sufijo#.value;
			var personeria = document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value;
			ActualizaValoresContacto#Attributes.sufijo#(id_c,id_p);
		}
		<!------------------------- Función que actualiza los valores de los campos de los Atr. Extendidos del agente ------------------------>
		function ActualizaValoresContacto#Attributes.sufijo#(id_c,id_p) {
			
			CargarValoresPersona#Attributes.sufijo#();
			var frame = document.getElementById("datosContacto");
			frame.src = "/cfmx/saci/utiles/contactoDatosAdicionalesUtiles.cfm?id_p="+id_p+"&id_c="+id_c+"&form_name=#Attributes.form#&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#";
			return true;
		}
		
	</script>
</cfoutput>
