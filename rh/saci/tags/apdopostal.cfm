<cfset def = QueryNew('apdo')>

<cfparam 	name="Attributes.query"			type="query"	default="#def#">				<!--- consulta por defecto --->
<cfparam 	name="Attributes.pais" 			type="string"	default="#session.saci.pais#">	<!--- código de país --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexión --->
<cfparam	name="Attributes.readonly"		type="boolean"	default="false">				<!--- Indica si el campo de Apdo Postal es readonly --->
<cfparam	name="Attributes.verNombre"		type="boolean"	default="false">				<!--- Despliega o no el campo de nombre del apartado postal --->

<cfset ExisteApartado = Attributes.query.recordCount GT 0>

<cfif Attributes.readonly and not ExisteApartado>
	<cfthrow message="Error: para utilizar el atributo de readOnly se requiere enviar el atributo query para el Apdo Postal">
</cfif>

<cfset arrayApdo = ArrayNew(1)>
<cfset tam_array = 1>
<cfif Attributes.verNombre>
	<cfset tam_array = 2>
</cfif>
<cfif ExisteApartado>
	<cfset temp = ArraySet(arrayApdo, 1, tam_array, "")>
	<cfset arrayApdo[1] = Evaluate('Attributes.query.CPid#Attributes.sufijo#')>
	<cfif Attributes.verNombre>
		<cfset arrayApdo[2] = Evaluate('Attributes.query.CPnombre#Attributes.sufijo#')>
	</cfif>
</cfif>

<cfset valApdo = "">
<cfif ExisteApartado and isdefined("Attributes.query.Papdo#Attributes.sufijo#")>
	<cfset valApdo = HTMLEditFormat(Evaluate('Attributes.query.Papdo#Attributes.sufijo#'))>
</cfif>

<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0">
	  <tr>
 		<td id="apartado#Attributes.sufijo#">
			<cfif Attributes.readonly>
				#HTMLEditFormat(Trim(valApdo))#
				<input type="hidden" name="Papdo#Attributes.sufijo#" value="#HTMLEditFormat(Trim(valApdo))#">
			<cfelse>
				<cf_campoNumerico readonly="#Attributes.readonly#" name="Papdo#Attributes.sufijo#" decimales="-1" size="10" maxlength="8" value="#valApdo#" tabindex="1">			
			</cfif>			
		</td>
		<td id="guion#Attributes.sufijo#">
			&nbsp;-&nbsp;
		</td>
		<td>	
			<cfif Attributes.readonly>
                <table width="100%"  border="0" cellspacing="0" cellpadding="2">
                  <tr>
                    <td>
						#HTMLEditFormat(Trim(arrayApdo[1]))#
						<input type="hidden" name="CPid#Attributes.sufijo#" value="#HTMLEditFormat(Trim(arrayApdo[1]))#">					
					</td>
					<cfif Attributes.verNombre>
						<td>
							#HTMLEditFormat(Trim(arrayApdo[2]))#
							<input type="hidden" name="CPnombre#Attributes.sufijo#" value="#HTMLEditFormat(Trim(arrayApdo[2]))#">										
						</td>
					</cfif>
                  </tr>
                </table>				
			<cfelse>
				<cfif Attributes.verNombre>
					<cf_conlis 
						title = "Codigo Postal"
						campos = "CPid#Attributes.sufijo#,CPnombre#Attributes.sufijo#"
						desplegables = "S,S" 
						modificables = "S,N"
						size = "5,40"
						tabla = "OficinaPostal"
						columnas = "CPid as CPid#Attributes.sufijo#, CPnombre as CPnombre#Attributes.sufijo#" 
						filtro = "Ppais = '#Attributes.pais#'
								  order by CPnombre"
						filtrar_por = "CPid, CPnombre"
						desplegar = "CPid#Attributes.sufijo#, CPnombre#Attributes.sufijo#"
						etiquetas = "C&oacute;digo, Descripci&oacute;n"
						formatos = "I,S"
						align = "left,left"
						asignar = "CPid#Attributes.sufijo#,CPnombre#Attributes.sufijo#"
						asignarformatos = "I,S"
						Form = "#Attributes.form#"
						Conexion = "#Attributes.Conexion#"
						valuesArray = "#arrayApdo#"
						closeOnExit = "true"
						tabindex="1"
						onKeyPress="acceptNum"
						readonly="#Attributes.readonly#">
				<cfelse>
					<cf_conlis 
						title = "Codigo Postal"
						campos = "CPid#Attributes.sufijo#"
						desplegables = "S" 
						modificables = "S"
						size = "5"
						tabla = "OficinaPostal"
						columnas = "CPid as CPid#Attributes.sufijo#, CPnombre as CPnombre#Attributes.sufijo#" 
						filtro = "Ppais = '#Attributes.pais#'
								  order by CPnombre"
						filtrar_por = "CPid, CPnombre"
						desplegar = "CPid#Attributes.sufijo#, CPnombre#Attributes.sufijo#"
						etiquetas = "C&oacute;digo, Descripci&oacute;n"
						onKeyPress="acceptNum"
						formatos = "I,S"
						align = "left,left"
						asignar = "CPid#Attributes.sufijo#"
						asignarformatos = "I"
						Form = "#Attributes.form#"
						Conexion = "#Attributes.Conexion#"
						valuesArray = "#arrayApdo#"
						closeOnExit = "true"
						tabindex="1"
						readonly="#Attributes.readonly#"
						
						debug=false>
				</cfif>
			</cfif>	
		</td>
	  </tr>
	</table>
	
	<script language="javascript" type="text/javascript">
		function CargarValoresApdo#Attributes.sufijo#(apdo, codpostal, nombrepostal) {
			document.#Attributes.form#.Papdo#Attributes.sufijo#.value = apdo;
			document.#Attributes.form#.CPid#Attributes.sufijo#.value = codpostal;
			<cfif Attributes.verNombre>
			if (nombrepostal != undefined) {
				document.#Attributes.form#.CPnombre#Attributes.sufijo#.value = nombrepostal;
			}
			</cfif>
		}
	</script>
	
</cfoutput>
