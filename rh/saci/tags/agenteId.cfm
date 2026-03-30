<!--- Parametros del Tag --->
<cfparam 	name="Attributes.id_agente"		type="string"	default="-1">					<!--- Id del Agente--->
<cfparam 	name="Attributes.form"			type="string"	default="form1">				<!--- form--->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.funcion"		type="string"	default="CargarDescAgente#Attributes.sufijo#">						<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.size" 			type="string"	default="40">					<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 		type="boolean"	default="false">				<!--- se usa para indicar si se muestra en modo consulta --->



<!------------------------------------ Pinta los campos ----------------------------------------------->
<cfset id_persona="">
<cfoutput>
	<!------------- Selecciona los Datos del agente en caso de que el id este definido en los atributos ------->
	<cfif isdefined("Attributes.id_agente") and len(trim(Attributes.id_agente)) and Attributes.id_agente neq "-1">
		<cfquery datasource="#Attributes.Conexion#" name="rsAgenteTag">
			select AGid, Pquien
			from ISBagente
			where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_agente#" null="#Len(Attributes.id_agente) Is 0#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
		</cfquery>
		
		<cfset id_persona= "">
		<cfif isdefined('rsAgenteTag') and rsAgenteTag.recordCount GT 0>
			<cfset id_persona= rsAgenteTag.Pquien>
		</cfif>
	</cfif>

	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td width="30%">
			<cf_identificacion
				id = "#id_persona#"
				form = "#Attributes.form#"
				incluyeTabla = "true"
				alignEtiquetas = "right"					
				porFila = "false"
				soloAgentes = "true"
				sufijo = "#Attributes.sufijo#"
				ocultarPersoneria = "true"
				editable = "false"
				funcion = "CargarDescAgente#Attributes.sufijo#"
				Ecodigo = "#Attributes.Ecodigo#"
				pintaEtiq = "false"
				Conexion = "#Attributes.Conexion#"
				readOnly = "#Attributes.readOnly#"
			>			
		</td>
        <td width="68%">
			<input name="NombreAgente#Attributes.sufijo#" id="NombreAgente#Attributes.sufijo#" class="cajasinbordeb" readonly="true" type="text"  value="" size="#Attributes.size#" maxlength="70">
		</td>
      </tr>
    </table>
	<script language="javascript" type="text/javascript">
		function CargarDescAgente#Attributes.sufijo#(){
			formatMascara#Attributes.sufijo#();		//funcion que se encuentra en el tag de identificacion, se usa para dar formato a la identificacion dependiendo de la personeria. Se ejecuta al traer un nuevo identificador.
			var linDin = "document.#Attributes.form#.NombreAgente#Attributes.sufijo#.value = document.#Attributes.form#.nom_razonp#Attributes.sufijo#.value";
			eval(linDin);
		}
		<cfif isdefined('id_persona') and id_persona NEQ ''>
			CargarDescAgente#Attributes.sufijo#();
		</cfif>			
	</script>
</cfoutput>