<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de febrero del 2006
	Motivo: Actualizacin de fuentes de educación a nuevos estndares de Pantallas y Componente de Listas.
 ---> 
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_template template="#session.sitio.template#">
	
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>	
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<cfif isdefined("Url.FNcodigoC") and not isdefined("Form.FNcodigoC")>
				<cfparam name="Form.FNcodigoC" default="#Url.FNcodigoC#">
			</cfif>
			<cfif isdefined("Url.FGcodigoC") and not isdefined("Form.FGcodigoC")>
				<cfparam name="Form.FGcodigoC" default="#Url.FGcodigoC#">
			</cfif>
			<cfquery name="rsNiveles" datasource="#Session.Edu.DSN#">
				select convert(varchar, Ncodigo) as Ncodigo, 
					substring(Ndescripcion ,1,50) as Ndescripcion 
				from Nivel 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
				order by Norden
			</cfquery>
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
				select convert(varchar, b.Ncodigo)
					   + '|' + convert(varchar, b.Gcodigo) as Codigo, 
					   substring(b.Gdescripcion ,1,50) as Gdescripcion 
				from Nivel a, Grado b
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
				  and a.Ncodigo = b.Ncodigo 
				order by Codigo,Gdescripcion
			</cfquery>

			<form name="lista" method="post" action="Materias.cfm" style="margin:0">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tituloListas" style="margin:0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td width="6%" align="right"><strong>Nivel:</strong></td>
						<td width="13%">
							<select name="FNcodigoC" id="FNcodigoC" tabindex="5" onChange="javascript: cargarGrados(this, this.form.FGcodigoC, '<cfif isdefined("Form.FGcodigoC")><cfoutput>#Form.FGcodigoC#</cfoutput></cfif>', true)">
								<option value="-1">Todos</option>
								<cfoutput query="rsNiveles"> 
								<option value="#Ncodigo#" <cfif isdefined("Form.FNcodigoC") AND (Form.FNcodigoC EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
								</cfoutput> 
							</select>	
						</td>
						<td width="5%" align="right"><strong>Grado:</strong></td>
						<td width="76%">
							<select name="FGcodigoC" id="FGcodigoC" tabindex="5">
								<cfoutput query="rsGrado"> 
								<option value="#Codigo#" <cfif isdefined("Form.FGcodigoC") AND (Form.FGcodigoC EQ rsGrado.Codigo)>selected</cfif>>#Gdescripcion#</option>
								</cfoutput> 
							</select>	
						</td>
					</tr>
				</table>
				<!--- Query para manejar el tipo de materia en los filtros de la lista --->
				<cfquery datasource="#Session.Edu.DSN#" name="rsMateriaTipo">
					select '-1' as value, '-- todos --' as description
					union
					select 
						MTdescripcion as value
						, substring(MTdescripcion,1,50) as description 
					from MateriaTipo 
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
					order by description
				</cfquery>
					
				<!--- Query para manejar el tipo de modalidad en los filtros de la lista--->
					<cfset rsModalidad = QueryNew("value,description")>
					<cfset fila = QueryAddRow(rsModalidad, 1)>
					<cfset tmp  = QuerySetCell(rsModalidad, "value", "-1") >
					<cfset tmp  = QuerySetCell(rsModalidad, "description",  "Todas")>			
					<cfset fila = QueryAddRow(rsModalidad, 1)>
					<cfset tmp  = QuerySetCell(rsModalidad, "value", "R") >
					<cfset tmp  = QuerySetCell(rsModalidad, "description",  "Regular")>
					<cfset fila = QueryAddRow(rsModalidad, 1)>
					<cfset tmp  = QuerySetCell(rsModalidad, "value", "S") >
					<cfset tmp  = QuerySetCell(rsModalidad, "description",  "Sustitutiva")>
					<cfset fila = QueryAddRow(rsModalidad, 1)>
					<cfset tmp  = QuerySetCell(rsModalidad, "value", "E") >
					<cfset tmp  = QuerySetCell(rsModalidad, "description",  "Electiva")>
					<cfset fila = QueryAddRow(rsModalidad, 1)>
					<cfset tmp  = QuerySetCell(rsModalidad, "value", "C") >
					<cfset tmp  = QuerySetCell(rsModalidad, "description",  "Complementaria")>	
				
				 <cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
					select convert(varchar, Ncodigo) as value, 
						substring(Ndescripcion ,1,50) as description 
					from Nivel 
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
					order by Norden
				</cfquery>
				
				 <cfset filtro = "">
				 <cfset navegacion = "">
				<cfif isdefined("Form.FNcodigoC") and Form.FNcodigoC NEQ '-1'>
					<cfset filtro = filtro & " and c.Ncodigo = " & Form.FNcodigoC>
					<cfset f1 = Form.FNcodigoC>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FNcodigoC=" & Form.FNcodigoC>
				</cfif>
				<cfif isdefined("Form.FGcodigoC") and Form.FGcodigoC NEQ '-1'>
					<cfset filtro = filtro & " and c.Gcodigo = " & Form.FGcodigoC>
					<cfset f2 = Form.FGcodigoC>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FGcodigoC=" & Form.FGcodigoC>
				</cfif>
				<cfparam name="f1" default="-1">
				<cfparam name="f2" default="-1">
				<cfparam name="form.Pagina" default="1">
				<input name="Pagina" type="hidden" value="<cfoutput>#form.Pagina#</cfoutput>">
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" 			value="Nivel a, Grado b, Materia c, MateriaTipo d"/>
					<cfinvokeargument name="columnas" 		value="
															'#f1#' as FNcodigo
															, '#f2#' as FGcodigo
															, convert(varchar, c.Ncodigo) as Ncodigo
															, convert(varchar, c.Gcodigo) as Gcodigo
															, c.Mcodigo as Mcodigo
															, convert(varchar, c.Mconsecutivo) as Mconsecutivo
															, substring(c.Mnombre,1,35) as Mnombre
															, a.Ndescripcion+': '+(case when c.Gcodigo is null then 'Sustitutivas' else b.Gdescripcion end) as Grado
															, case c.Melectiva when 'R' then 'Regular' when 'S' then 'Sustitutiva' when 'E' then 'Electiva' when 'C' then 'Complementaria' else '' end as Melectiva
															, c.Morden as Morden
															, d.MTdescripcion"/>
					<cfinvokeargument name="desplegar" 		value="Mcodigo, Mnombre, Melectiva, MTdescripcion"/>
					<cfinvokeargument name="etiquetas" 		value="Codigo, Materia, Modalidad, Tipo de Materia"/>
					<cfinvokeargument name="formatos" 		value="S,S,S,S"/>
					<cfinvokeargument name="filtro" 		value=" a.CEcodigo = #Session.Edu.CEcodigo# 
																and a.Ncodigo = c.Ncodigo 
																and b.Ncodigo =* c.Ncodigo 
																and b.Gcodigo =* c.Gcodigo 
																and c.MTcodigo = d.MTcodigo #filtro# 
																order by a.Norden, b.Gorden, c.Morden, c.Mcodigo, c.Mnombre, d.MTdescripcion"/>
					<cfinvokeargument name="align" 				value="left,left,left,left"/>
					<cfinvokeargument name="ajustar" 			value="N,N,N,N"/>
					<cfinvokeargument name="irA" 				value="Materias.cfm"/>
					<cfinvokeargument name="cortes" 			value="Grado"/>
					<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
					<cfinvokeargument name="debug" 				value="N"/>
					<cfinvokeargument name="Conexion" 			value="#session.Edu.DSN#"/>
					<cfinvokeargument name="mostrar_filtro" 	value="true"/>									
					<cfinvokeargument name="filtrar_automatico" value="true"/>					
					<cfinvokeargument name="filtrar_por" 		value="Mcodigo, Mnombre, Melectiva, MTdescripcion"/>	
					<cfinvokeargument name="rsMelectiva" 		value="#rsModalidad#"/>
					<cfinvokeargument name="rsMTdescripcion" 	value="#rsMateriaTipo#"/>	
					<cfinvokeargument name="botones" 			value="Nuevo"/>
					<cfinvokeargument name="keys" 				value="Mconsecutivo"/>
					<cfinvokeargument name="maxRows" 			value="15"/>
					<cfinvokeargument name="incluyeForm"		value="false"/>
					<cfinvokeargument name="nameForm"			value="lista"/>
				</cfinvoke>
			</form>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
<script language="JavaScript" type="text/JavaScript">
	var gradostext = new Array();
	var grados = new Array();
	var niveles = new Array();

    // Esta función únicamente debe ejecutarlo una vez
	function obtenerGrados(f) {
        for(i=0; i<f.FGcodigoC.length; i++) {
			var s = f.FGcodigoC.options[i].value.split("|");
            // Códigos de los detalles
            niveles[i]= s[0];
			grados[i] = s[1];
			gradostext[i] = f.FGcodigoC	.options[i].text;
        }
	}
    function cargarGrados(csource, ctarget, vdefault, t){
		// Limpiar Combo
		for (var i=ctarget.length-1; i >=0; i--) {
			ctarget.options[i]=null;
		}
		var k = csource.value;
		var j = 0;
		if (t) {
			var nuevaOpcion = new Option("Todos","-1");
			ctarget.options[j]=nuevaOpcion;
			j++;
		}
		if (k != "-1") {
			for (var i=0; i<grados.length; i++) {
				if (niveles[i] == k) {
					nuevaOpcion = new Option(gradostext[i],grados[i]);
					ctarget.options[j]=nuevaOpcion;
					if (vdefault != null && grados[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
		} else {
			for (var i=0; i<grados.length; i++) {
				nuevaOpcion = new Option(gradostext[i],grados[i]);
				ctarget.options[i+1]=nuevaOpcion;
				if (vdefault != null && grados[i] == vdefault) {
					ctarget.selectedIndex = i+1;
				}
			}
		}
		if (!t) {
			var j = ctarget.length;
			nuevaOpcion = new Option("-------------------","");
			ctarget.options[j++]=nuevaOpcion;
			nuevaOpcion = new Option("Crear Nuevo ...","0");
			ctarget.options[j]=nuevaOpcion;
		}
    }
	
	
	obtenerGrados(document.lista);
	cargarGrados(document.lista.FNcodigoC, document.lista.FGcodigoC, '<cfif isdefined("Form.FGcodigoC")><cfoutput>#Form.FGcodigoC#</cfoutput></cfif>', true);
</script>


