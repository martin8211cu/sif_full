
<!---

	Codificado por: Luis Alberto Hernández Córdova
	Fecha: 17 de Marzo del 2015
	Motivo: Seleccionar addendas del catálógo de addendas y asignarlas a determinado socio
	Lineas: 184

 --->

<cfset 	SocioActual = #form.SNcodigo#>

<cfquery name="AddendasAsignadasAlSocio" datasource="#Session.DSN#">
		select sa.ADDcodigo, sa.StatusSeleccion, a.ADDNombre
		from SocioAddenda sa, Addendas a where SNcodigo=#SocioActual#
		and (sa.ADDcodigo = a.ADDcodigo)
</cfquery>

<cfquery name="AdendasDisponibles" datasource="#Session.DSN#">
	select ADDcodigo, ADDNombre from Addendas
</cfquery>

<form action="Adenda-sql.cfm"  method="post" name="form" id="form1">
    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
	        <td width="50%" valign="top" align="left">
	        	<strong>Addendas Asignadas:</strong>
				<!---Imprime las Addendas que tiene relacionadas el socio en cuestion--->
			    <div id = "divImpresionAddendasEnlistadas">
					<cfloop index = "LoopCount" from = "1" to = "#AddendasAsignadasAlSocio.recordcount#">
						<input type="checkbox" name="AddendaPorImprimir" 
						    id="<cfoutput>#AddendasAsignadasAlSocio.ADDcodigo[LoopCount]#</cfoutput>"
							value="<cfoutput>#AddendasAsignadasAlSocio.ADDcodigo[LoopCount]#</cfoutput>"  
							onchange="cambioSeleccion(this);"
							addendaSocioCodigo = "<cfoutput>#AddendasAsignadasAlSocio.ADDcodigo[LoopCount]#</cfoutput>"
							<cfif AddendasAsignadasAlSocio.StatusSeleccion[LoopCount] EQ 1>
							   <cfoutput>checked = "checked"</cfoutput>
							</cfif>>
						<label><cfoutput>#AddendasAsignadasAlSocio.ADDNombre[LoopCount]#</cfoutput></label>
						<br/><br/>
					</cfloop>
			    </div>
			</td>
            <td width="50%" valign="top" align="left">
            	<strong>Asignar Addenda Nueva:</strong>
				
				<br/>
				<select width="75%" onChange = "AddendaPorAgregar(this)">
					<option>---</option>
					<cfloop index = "LoopCount" from = "1" to = "#AdendasDisponibles.recordcount#">
						<option value="<cfoutput>#AdendasDisponibles.ADDcodigo[LoopCount]#</cfoutput>"
						    valueName = "<cfoutput>#AdendasDisponibles.ADDNombre[LoopCount]#</cfoutput>">
						    <cfoutput>#AdendasDisponibles.ADDcodigo[LoopCount]# - #AdendasDisponibles.ADDNombre[LoopCount]#</cfoutput>
						</option>
					</cfloop>
				</select>				              		              			            		            	 
				<input name="btnAgregar" type="button" onClick="EnlistarAddenda()"
				    value = "Agregar" class = "btnNuevo"/>
				<br/>
	        </td>
        </tr>
			<!---Botón para guardar la forma en la base de datos--->
		<tr>
		    <td colspan="4" align="left">
				<br/>
				<input type="submit" name="btnSubmit" value="Guardar" class = "btnGuardar">
		    </td>
		</tr>
	</table>
	<!---Manda el valor de SNcodigo al archivo de SQL--->
	<input  tabindex="-1" type="hidden" name="SNcodigo" value="<cfoutput>#form.SNcodigo#</cfoutput>">
</form>

<script type="text/javascript" src="/jquery/librerias/jquery-1.11.1.min.js"></script>
<script language="javascript" type="text/javascript">
    var AddendasEnPantalla = [];
	var checkedAsignadoActualmente = null;
	var addendaPorEnlistar = "---";
	var addendaPorEnlistarNombre = "";
    $(document).ready(function() {
        var addendasAsignadas = $("input[type=checkbox][addendaSocioCodigo]").get();
		for(var i = 0; i < addendasAsignadas.length; i++){
			AddendasEnPantalla.push(addendasAsignadas[i].value);
		}
		//revisar si se una addenda asignada
		for(var i = 0; i < addendasAsignadas.length; i++){
			if($(addendasAsignadas[i]).prop("checked") === true){
				checkedAsignadoActualmente = addendasAsignadas[i];
				break;
			}
		}
    });

	function cambioSeleccion(checkbox){
		if($(checkbox).prop("checked") === true){
			var addendasAsignadas = $("input[type=checkbox][addendaSocioCodigo]").get();
			for(var i = 0; i < addendasAsignadas.length; i++){
			    $(addendasAsignadas[i]).prop('checked', false).removeAttr('checked');
			}
			$(checkbox).prop('checked', true).attr('checked', 'checked');
			checkedAsignadoActualmente = checkbox;
        }
	}

	function AddendaPorAgregar(selectOption){	
		addendaPorEnlistar = $(selectOption).children("option:selected").val();
		addendaPorEnlistarNombre = $(selectOption).children("option:selected").attr("valueName");
	}

    function EnlistarAddenda(){
		var ExisteAddenda = false;
		if(addendaPorEnlistar === "---"){
			ExisteAddenda = true;
		}
	    for(i = 0; i < AddendasEnPantalla.length; i++){
		    if(addendaPorEnlistar == AddendasEnPantalla[i]){
			    ExisteAddenda = true;
				break;
		    }
	    }
		if(ExisteAddenda === false){
			var newInput = document.createElement("input");
			newInput.type = "Checkbox";
			newInput.name = "AddendaPorImprimir";
			newInput.id = addendaPorEnlistar;
			newInput.value = addendaPorEnlistar;
			newInput.setAttribute("addendaSocioCodigo", addendaPorEnlistar);
			newInput.setAttribute("onchange", "cambioSeleccion(this);");;
			var newLabel = document.createElement("label");
			var labelContent = document.createTextNode(addendaPorEnlistarNombre);
			newLabel.appendChild(labelContent);
			document.getElementById("divImpresionAddendasEnlistadas").appendChild(newInput);
			document.getElementById("divImpresionAddendasEnlistadas").appendChild(newLabel);
			document.getElementById("divImpresionAddendasEnlistadas").appendChild(document.createElement("br"));
			document.getElementById("divImpresionAddendasEnlistadas").appendChild(document.createElement("br"));
			AddendasEnPantalla.push(addendaPorEnlistar);
		}
	}

</script>