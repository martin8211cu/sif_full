	<!--- =============== Plantillas ========================= --->

	<!--- style's de las plantillas --->
	<style type='text/css'>
		table.plantilla {  width:160px; height:80px; border:none; } 
		td.plantilla { border:solid skyblue;  background-color:skyblue;  vertical-align:top; text-align:left; } 
	</style>

	<!--- informacion de las plantillas --->
	<cfquery name="rsPlantillas" datasource="sdc">
		select MSPplantilla, MSPnombre, MSPareas, MSPtexto
		from MSPlantilla
		order by 2
	</cfquery>
	
	<!--- Numero de columnas que va a pintar por cada fila --->
	<cfif ( rsPlantillas.RecordCount mod 4 ) eq 0>
		<cfset colsPorFila = 4 >
	<cfelse>
		<cfset colsPorFila = 3 >
	</cfif>

	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2">
				<input type="hidden" name="MSPplantilla" value="<cfif modo neq 'ALTA'>#trim(rsForm.MSPplantilla)#</cfif>" alt="La Plantilla">
			</td>
		</tr>

		<tr><td colspan="2" class="plantillaTitulo" align="center"><p>Seleccione una plantilla y asigne nombres a las diferentes áreas de ésta</p></td></tr>		
		<tr>
			<td colspan="2" align="center">
				<table border="0" align="center" bgcolor="##F5F5F5" class="plantillas">
					<!--- numero de filas que va a pintar --->
					<cfset rows = 0>
					<cfset dato1 = "">
					<cfset dato2 = "">
					<cfloop query="rsPlantillas">
						<!--- bretear aqui lo de los inputs INI --->
						<cfset tmp = "" >
						<cfset vMSPtexto = rsPlantillas.MSPtexto >
	
						<cfloop from="1" index="area" to="#rsPlantillas.MSPareas#">
							<cfset text_area = "AREA-" & area & "-">
							
							<cfset visible = "hidden" >
							<cfset value   = "" >
							<cfif modo neq 'ALTA' >
								<cfif trim(rsPlantillas.MSPplantilla) eq trim(rsForm.MSPplantilla) >
									<cfset visible = "visible">
								</cfif>
	
								<cfif rsAreas.RecordCount gt 0>
									<cfquery name="rsValor" dbtype="query">
										select MSPAnombre from rsAreas where MSPAarea = #area#
									</cfquery>
									<cfset value = rsValor.MSPAnombre >
								</cfif>
							</cfif>
							
							<cfset input = "<input type='text' value='#value#' size='10' maxlength='20' onfocus='this.select()' name='area#rsPlantillas.MSPplantilla#' " >
							<cfset input = input & " style= 'width:80%; font-size:8pt; visibility: #visible#' >" >
	
							<cfset vMSPtexto = Replace(vMSPtexto, trim(text_area), input) >
						</cfloop>
						<!--- bretear aqui lo de los inputs FIN --->
	
						<cfset plantilla = '"' & rsPlantillas.MSPplantilla & '"' > 	
						<cfset dato2 = dato2 & "<td id='plantilla#rsPlantillas.MSPplantilla#' title='#MSPplantilla#:#MSPnombre#'  onclick='javascript:select_plantilla(#plantilla#)' >" & vMSPtexto & "</td>" >
						<cfif (rsPlantillas.CurrentRow mod colsPorFila) eq 0 >
							<cfset dato1 = "<tr>" & dato2 & "</tr>">
							<cfset dato2 = "">
							#dato1#
						</cfif>
					</cfloop>
				</table>
			</td>
		</tr>
	</table>
	</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	//document.form1.MSMmenu.alt = "La Opción de menú";
	//document.form1.MSCcategoria.alt = "La Categoría";

	function select_plantilla(value){
		var f = document.form1;
		var value0 = f.MSPplantilla.value;
		if (value != value0) {
			var pl0 = document.all ? document.all["plantilla" + value0] : document.getElementById("plantilla" + value0);
			var pl1 = document.all ? document.all["plantilla" + value ] : document.getElementById("plantilla" + value );
			f.MSPplantilla.value = value;
			
			var values = new Array();
			selectPlantillaVisibility( f["area" + value0], "hidden",  false, values, 0);
			selectPlantillaVisibility( f["area" + value ], "visible", true,  values, 1);
			
		}
	}

	function selectPlantillaVisibility(areaInput, visibility, focus, values, arrayflag){
		if (areaInput) {
			if (areaInput.length) {
				for (i = 0; i < areaInput.length; i++) {
					areaInput[i].style.visibility = visibility;
					if (arrayflag == 0) {
						values[i] = areaInput[i].value;
					}
					else if (values.length > i) {
						areaInput[i].value = values[i];
					}
				}
				if (focus) {
					areaInput[0].focus();
				}
			} 
			else {
				areaInput.style.visibility = visibility;
				if (arrayflag == 0) {
					values[0] = areaInput.value;
				}
				else {
					areaInput.value = values[0];
				}
				if (focus) {
					areaInput.focus();
				}
			}
		}
	}
</script>