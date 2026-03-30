<cfparam 	name="Attributes.alignEtiquetas" 	type="string"	default="right">				<!--- alineación de etiquetas --->
<cfparam 	name="Attributes.incluyeTabla" 		type="boolean"	default="true">					<!--- se utiliza para indicar si incluye tabla --->
<cfparam 	name="Attributes.porFila" 		type="boolean"	default="true">					<!--- se utiliza para indicar si se pintan los niveles por columna o fila --->

<cfparam	name="Attributes.id"				type="string"	default="">						<!--- Id de Localidad --->
<cfparam	name="Attributes.pais"				type="string"	default="#session.saci.pais#">	<!--- Id de Pais --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.width" 			type="string"	default="">						<!--- ancho de cada columna de etiqueta --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">				<!--- para indicar si se muestran los datos en modo consulta --->
<cfparam 	name="Attributes.shownext" 		type="boolean"	default="true">				   <!--- para indicar si se desea mostrar los niveles siguientes. --->

<cfquery name="rsDivision" datasource="#Attributes.Conexion#">
	select a.DPnivel, a.DPnombre
	from DivisionPolitica a
	where a.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.pais#">
	order by a.DPnivel
</cfquery>

<cfif Len(Trim(Attributes.id))>
	<cfquery name="rsNiveles" datasource="#Attributes.Conexion#">
		select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.pais#">
	</cfquery>
	<cfset minnivel = rsNiveles.minNivel>
	<cfset maxnivel = rsNiveles.maxNivel>
	<cfset idactual = Attributes.id>
	<cfloop condition="maxnivel GTE minnivel">
		<cfquery name="rsLocalidad#maxnivel#" datasource="#Attributes.Conexion#">
			select LCid, LCcod, LCnombre, LCidPadre
			from Localidad
			where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idactual#">
		</cfquery>
		<cfset idactual = Evaluate('rsLocalidad#maxnivel#.LCidPadre')>
		<cfset maxnivel = maxnivel - 1>
	</cfloop>
</cfif>


<cfoutput>
	<cfif Attributes.incluyeTabla>
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
	</cfif>
	<cfloop query="rsDivision">
		<cfif rsDivision.currentRow EQ 1 or Attributes.porFila>
		<tr>
		</cfif>
			<td align="#Attributes.alignEtiquetas#"<cfif Len(Trim(Attributes.width))> width="#Attributes.width#"</cfif>>
				<label>#rsDivision.DPnombre#</label>
			</td>
			<td>			
				<cfif rsDivision.DPnivel EQ 1>
					<cfset filtro = "a.Ppais = '#Attributes.pais#' 
									and a.DPnivel = #rsDivision.DPnivel# 
									and a.Habilitado = 1 
									order by convert(int,a.LCcod)">
				<cfelse>
					<cfset filtro = "a.Ppais = '#Attributes.pais#' and a.DPnivel = #rsDivision.DPnivel# 
									and a.Habilitado = 1
									and a.LCidPadre = $LCid_#rsDivision.DPnivel-1##Attributes.sufijo#,numeric$ order by convert(int,a.LCcod)">
				</cfif>

				<cfset array = ArrayNew(1)>
				<cfif isdefined('rsLocalidad' & rsDivision.DPnivel)>
					<cfset temp = ArraySet(array, 1,4, "")>
					<cfset array[1] = Evaluate('rsLocalidad#rsDivision.DPnivel#.LCid')>
					<cfset array[2] = Evaluate('rsLocalidad#rsDivision.DPnivel#.LCid')>
					<cfset array[3] = Evaluate('rsLocalidad#rsDivision.DPnivel#.LCcod')>
					<cfset array[4] = Evaluate('rsLocalidad#rsDivision.DPnivel#.LCnombre')>
				</cfif>
				
				<cfif Attributes.readOnly>
					<cfif isdefined('rsLocalidad' & rsDivision.DPnivel)>
						<input name="LCid_#rsDivision.DPnivel##Attributes.sufijo#" type="hidden" value="#array[1]#" />
						<input name="LCcodAnt_#rsDivision.DPnivel##Attributes.sufijo#" type="hidden" value="#array[2]#" />
						<input name="LCcod_#rsDivision.DPnivel##Attributes.sufijo#" type="hidden" value="#array[3]#" />
						<input name="LCnombre_#rsDivision.DPnivel##Attributes.sufijo#" type="hidden" value="#array[4]#" />
						#HTMLEditFormat(array[3])#&nbsp;&nbsp;#HTMLEditFormat(array[4])#
					<cfelse>
						&lt;No Especificado&gt;
					</cfif>
				<cfelse>
					<cf_conlis 
						title="Localidad"
						campos = "LCid_#rsDivision.DPnivel##Attributes.sufijo#, LCcodAnt_#rsDivision.DPnivel##Attributes.sufijo#, LCcod_#rsDivision.DPnivel##Attributes.sufijo#, LCnombre_#rsDivision.DPnivel##Attributes.sufijo#" 
						desplegables = "N,N,S,S" 
						modificables = "N,N,S,N"
						size = "0,0,6,20"
						tabla = "Localidad a"
						columnas = "a.LCid as LCid_#rsDivision.DPnivel##Attributes.sufijo#, a.LCcod as LCcod_#rsDivision.DPnivel##Attributes.sufijo#, a.LCnombre as LCnombre_#rsDivision.DPnivel##Attributes.sufijo#" 
						desplegar = "LCcod_#rsDivision.DPnivel##Attributes.sufijo#, LCnombre_#rsDivision.DPnivel##Attributes.sufijo#"
						filtro = "#preserveSingleQuotes(filtro)#"
						filtrar_por = "a.LCcod, a.LCnombre"
						etiquetas = "C&oacute;digo, Localidad"
						formatos = "S,S"
						align = "left, left"
						asignar = "LCid_#rsDivision.DPnivel##Attributes.sufijo#, LCcod_#rsDivision.DPnivel##Attributes.sufijo#, LCnombre_#rsDivision.DPnivel##Attributes.sufijo#"
						asignarformatos = "S,S,S"
						Form = "#Attributes.form#"
						Conexion = "#Attributes.Conexion#"
						alt = "#rsDivision.DPnombre#, #rsDivision.DPnombre#, #rsDivision.DPnombre#, #rsDivision.DPnombre#"
						funcion = "funcLCid_#rsDivision.DPnivel##Attributes.sufijo#"
						valuesArray="#array#"
						closeOnExit="true"
						tabindex="1"
					>
				</cfif>
			
			</td>
		<cfif rsDivision.currentRow EQ rsDivision.recordCount or Attributes.porFila>
		</tr>
		</cfif>
	</cfloop>
	<cfif Attributes.incluyeTabla>
	</table>
	</cfif>
	
	<script language="javascript" type="text/javascript">
		<cfoutput>
		<cfloop query="rsDivision">
			<cfset nivel1 = DPnivel>
			function limpiarLCid_#nivel1##Attributes.sufijo#() {
				document.#Attributes.form#.LCid_#nivel1##Attributes.sufijo#.value = '';
				document.#Attributes.form#.LCcod_#nivel1##Attributes.sufijo#.value = '';
				document.#Attributes.form#.LCnombre_#nivel1##Attributes.sufijo#.value = '';
			}			
			
			function funcLCid_#nivel1##Attributes.sufijo#() {
				if (document.#Attributes.form#.LCcod_#nivel1##Attributes.sufijo#.value != document.#Attributes.form#.LCcodAnt_#nivel1##Attributes.sufijo#.value) {
					<cfloop query="rsDivision"><cfset nivel2 = DPnivel><cfif nivel2 GT nivel1>limpiarLCid_#nivel2##Attributes.sufijo#();</cfif></cfloop>
					<cfloop query="rsDivision"><cfset nivel2 = DPnivel><cfif nivel2 GT nivel1 and Attributes.shownext eq true>doConlisLCid_#nivel2##Attributes.sufijo#();<cfbreak></cfif></cfloop>
				}
				document.#Attributes.form#.LCcodAnt_#nivel1##Attributes.sufijo#.value = document.#Attributes.form#.LCcod_#nivel1##Attributes.sufijo#.value;
			}
			
			function CargarValorLocalidad_#nivel1##Attributes.sufijo#() {
				document.#Attributes.form#.LCid_#nivel1##Attributes.sufijo#.value = arguments[0];
				document.#Attributes.form#.LCcodAnt_#nivel1##Attributes.sufijo#.value = arguments[1];
				document.#Attributes.form#.LCcod_#nivel1##Attributes.sufijo#.value = arguments[2];
				document.#Attributes.form#.LCnombre_#nivel1##Attributes.sufijo#.value = arguments[3];
			}
		</cfloop>
		
		<cfset ind = 0>
		function CargarValoresLocalidadTodo#Attributes.sufijo#() {
			<cfloop query="rsDivision">
				CargarValorLocalidad_#DPnivel##Attributes.sufijo#(arguments[#ind#], arguments[#ind+1#], arguments[#ind+1#], arguments[#ind+2#]);<cfset ind = ind + 3></cfloop>
		}
		
		function CargarValoresLocalidad#Attributes.sufijo#(id) {
			var fr = document.getElementById("frLocalidad#Attributes.sufijo#");
			fr.src = '/cfmx/saci/utiles/queryLocalidad.cfm?LCid='+id+'&sufijo=#Attributes.sufijo#&pais=#Attributes.pais#&conexion=#Attributes.Conexion#';
		}
		</cfoutput>
	</script>

	<iframe id="frLocalidad#Attributes.sufijo#" name="frLocalidad#Attributes.sufijo#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	
</cfoutput>
