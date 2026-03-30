
<cfparam 	name="Attributes.id"			type="string"	default="">								<!--- Id del Vendedor --->
<cfparam 	name="Attributes.form"			type="string"	default="form1">						<!--- form--->
<cfparam 	name="Attributes.funcion"		type="string"	default="">								<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam 	name="Attributes.pais"			type="string"	default="#session.saci.pais#">			<!--- Pais en caso de ser necesario--->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">								<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">			<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">				<!--- cache de conexion --->
<cfparam 	name="Attributes.agente" 		type="string"	default="#session.saci.agente.id#">		<!--- ID del agente --->

<cfif Len(Attributes.agente) is 0 or Attributes.agente is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfset ExisteVendedor = (isdefined("Attributes.id") and Len(Trim(Attributes.id)))>

<cfif ExisteVendedor>
	<cfquery name="rsVendedor" datasource="#Attributes.Conexion#">
		select Vid, Pquien, AGid, Vprincipal, Habilitado, BMUsucodigo, ts_rversion
		from ISBvendedor
		where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	</cfquery>
	<cfset ExisteVendedor = rsVendedor.recordCount GT 0>
</cfif>

<cfoutput>
	<input type="hidden" name="Vid" id="Vid" value="<cfif ExisteVendedor>#rsVendedor.Vid#</cfif>">
	<input type="hidden" name="Vprincipal" id="Vprincipal" value="<cfif ExisteVendedor>#rsVendedor.Vprincipal#<cfelse>0</cfif>">
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<!--- Tag Persona --->
			<cfset id_persona= "">
			<cfset id_ven= "">
			<cfif ExisteVendedor>
				<cfset id_persona = rsVendedor.Pquien>
				<cfset id_ven = rsVendedor.Vid>
			</cfif>

			<cf_persona
				id="#id_persona#"
				form="#Attributes.form#"
				incluyeTabla="#false#"
				pais="#Attributes.pais#"
				funcion = "CargarValoresVendedor"
				TypeLocation = "V"
				RefIdLocation = "#id_ven#"
				filtrarPersoneria = "F,E"
			>
	</table>

	<!------------------------------ Sentencia Iframe-------------------------------->
	<iframe id="frVendedor" name="frVendedor" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	
	<script language="javascript" type="text/javascript">
		function CargarValoresVendedor() {
			var id = document.#Attributes.form#.Pquien.value;
			if (document.#Attributes.form#.Vidp.value != '' && document.#Attributes.form#.Vidp.value != '0') {
				document.#Attributes.form#.Vid.value = document.#Attributes.form#.Vidp.value;
			}
			CargarValoresPersona();
			var fr = document.getElementById("frVendedor");
			fr.src = "/cfmx/saci/utiles/queryVendedor.cfm?AGid=#Attributes.agente#&id="+id+"&form_name=#Attributes.form#&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#";
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
	</script>
	
</cfoutput>
