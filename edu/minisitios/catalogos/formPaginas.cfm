<!-- Establecimiento del modo -->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="sdc">
		select a.MSPcodigo,a.MSCcategoria,a.MSPplantilla,a.MSPtitulo,b.MSMmenu
		from MSPagina a, MSMenu b
		where a.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
		and a.MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
		and b.Scodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
		and b.Scodigo =* a.Scodigo
		and b.MSPcodigo =* a.MSPcodigo
	</cfquery>

	<cfquery name="rsInicio" datasource="sdc">
		select 1
		from Sitio
		where MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
		  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
	</cfquery>
	
	<cfquery name="rsAreas" datasource="sdc">
		select MSPAarea, MSPAnombre
		from MSPaginaArea
		where MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
		  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
		order by MSPAarea
	</cfquery>

</cfif>

<cfquery name="rsMenu" datasource="sdc">
	select Scodigo, disp.MSMmenu, replicate('&nbsp;', disp.MSMprofundidad * 3) + disp.MSMtexto as MSMtexto 
	from MSMenu disp
	where disp.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
	order by disp.MSMpath, disp.MSMorden
</cfquery>

<cfquery name="rsCategorias" datasource="sdc">
	select convert(varchar, MSCcategoria) as MSCcategoria, MSCnombre
	from MSCategoria
	order by MSCnombre
</cfquery>

<script language="JavaScript" type="text/JavaScript">

function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } 
  
  /* Mi validacion ini */
	if ( trim(document.form1.MSPplantilla.value) != '' ){
		var objeto = eval("document.form1.area" + document.form1.MSPplantilla.value);
		if ( objeto.length ){
			for (var i=0; i<objeto.length; i++){
				if ( trim(objeto[i].value) == '' ){
					errors = errors += '- Los nombres de las areas son requeridos.\n';
					break;
				}
			}
		}
		else{
			if ( trim(objeto.value) == '' ){
				errors = errors += '- El nombre del area es requerido.\n';
			}
		}
	}	
	
  /* Mi validacion fin */
  
  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->

function validar(){
	if ( document.form1.botonSel.value != 'Baja' && document.form1.botonSel.value != 'Nuevo' ){
		//MM_validateForm('MSPcodigo','','R','MSMmenu','','R','MSCcategoria','','R','MSPtitulo','','R' );
		MM_validateForm('MSPcodigo','','R','MSCcategoria','','R','MSPtitulo','','R', 'MSPplantilla', '', 'R' );
		if ( document.MM_returnValue ){
			document.form1.MSPcodigo.disabled = false;	
			return true;
		}
		return false;
	}
	else{
		document.form1.MSPcodigo.disabled = false;	
		return true;	
	}	
}

</script>

<form action="SQLPaginas.cfm" method="post" name="form1" onSubmit="return validar();">
	<cfoutput>
	<table width="100%">
	
		<tr> 
		  <td class="tituloMantenimiento" colspan="2" align="center"><font size="3"> 
			<cfif modo eq "ALTA">
			  Nueva Página
			  <cfelse>
			  Modificar Página
			</cfif>
			</font></td>
		</tr>
	
		<tr>
			<td align="right">Código:&nbsp;</td>
			<td>
				<input type="text" size="20" maxlength="20" name="MSPcodigo" <cfif modo neq 'ALTA'>disabled</cfif> value="<cfif modo neq 'ALTA'>#trim(rsForm.MSPcodigo)#</cfif>" onfocus="javascript:this.select();" alt="El Código" >
			</td>
		</tr>
		
		<tr>
			<td align="right">Opción de menú:&nbsp;</td>
			<td>
				<select name="MSMmenu">
					<option value="">(Menú sin Asignar)</option>
					<cfloop query="rsMenu">
						<option value="#rsMenu.MSMmenu#" <cfif modo neq 'ALTA' and rsForm.MSMmenu eq rsMenu.MSMmenu >selected</cfif> >#rsMenu.MSMtexto#</option>
					</cfloop>
				</select>
			</td>
		</tr>		
		
		<tr>
			<td align="right">Categoría:&nbsp;</td>
			<td>
				<select name="MSCcategoria">
					<cfloop query="rsCategorias">
						<option value="#rsCategorias.MSCcategoria#" <cfif modo neq 'ALTA' and rsForm.MSCcategoria eq rsCategorias.MSCcategoria >selected</cfif>  >#MSCnombre#</option>
					</cfloop>
				</select>
			</td>
		</tr>		
		
		<tr>
			<td>&nbsp;</td>
			<td>
				<input type="checkbox" name="homepage" value="1" <cfif modo neq 'ALTA' and rsInicio.RecordCount gt 0>checked</cfif> >Página de Inicio
			</td>
		</tr>
		
		<tr>
			<td align="right">Título:&nbsp;</td>
			<td>
				<input type="text" size="50" maxlength="50" name="MSPtitulo" value="<cfif modo neq 'ALTA'>#trim(rsForm.MSPtitulo)#</cfif>" onfocus="javascript:this.select();" alt="El Título" >
			</td>
		</tr>
		
		<tr>
			<td colspan="2">
				<input type="hidden" name="Scodigo" value="#session.Scodigo#">
				<input type="hidden" name="MSPplantilla" value="<cfif modo neq 'ALTA'>#trim(rsForm.MSPplantilla)#</cfif>" alt="La Plantilla">
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr><td colspan="2" class="plantillaTitulo" align="center"><p>Seleccione una plantilla y asigne nombres a las diferentes áreas de ésta</p></td></tr>		
		
		<!--- =============== Plantillas ========================= --->

		<!--- style's de las plantillas --->
		<style type='text/css'>
 			table.plantilla {  width:160px; height:80px; border:none; } 
 			td.plantilla { border:solid skyblue;  background-color:skyblue;  vertical-align:top; text-align:left; } 
		</style>

		<!--- informacion de las plantillas --->
		<cfquery name="rsPlantillas" datasource="sdc">
			set nocount on	
        	select MSPplantilla, MSPnombre, MSPareas, MSPtexto
            from MSPlantilla
            order by 2
			set nocount off
		</cfquery>
		
		<!--- Numero de columnas que va a pintar por cada fila --->
        <cfif ( rsPlantillas.RecordCount mod 4 ) eq 0>
			<cfset colsPorFila = 4 >
		<cfelse>
			<cfset colsPorFila = 3 >
		</cfif>

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

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr><td colspan="2" align="center"><cfinclude template="../../portlets/pBotones.cfm"></td></tr>
	</table>
	</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	document.form1.MSMmenu.alt = "La Opción de menú";
	document.form1.MSCcategoria.alt = "La Categoría";

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
			
/*			
			if (pl0 != null) {
				pl0.style.border = 'none';
			}
			if (pl1 != null) {
				pl1.style.border = 'solid';
			}*/
			
		}
	}

	function selectPlantillaVisibility(areaInput, visibility, focus, values, arrayflag){
		if (areaInput) {
			if (areaInput.length) {
				for (i = 0; i < areaInput.length; i++) {
					areaInput[i].style.visibility = visibility;
					if (arrayflag == 0) {
						values[i] = areaInput[i].value;
					} else if (values.length > i) {
						areaInput[i].value = values[i];
					}
				}
				if (focus) {
					areaInput[0].focus();
				}
			} else {
				areaInput.style.visibility = visibility;
				if (arrayflag == 0) {
					values[0] = areaInput.value;
				} else {
					areaInput.value = values[0];
				}
				if (focus) {
					areaInput.focus();
				}
			}
		}
	}
</script>