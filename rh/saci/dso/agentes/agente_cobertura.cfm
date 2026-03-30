<cfoutput>

	<cfif isdefined("url.Filtro_localidad") and len(trim(url.Filtro_localidad))>
		<cfset form.Filtro_localidad = url.Filtro_localidad>
	</cfif>
	<cfparam name="form.Filtro_localidad" default="">

	<form name="form1" method="post" style="margin: 0;" action="agente_cobertura-apply.cfm" onSubmit="javascript: return validaCober(this);">
		<input type="hidden" name="Filtro_localidad" value="#form.Filtro_localidad#">
		<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
		<cfinclude template="agente-hiddens.cfm">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<cfif ExisteAgente>
		  <tr>
			<td colspan="2" align="center" class="menuhead">
				#rsDatosPersona.Pid#&nbsp;&nbsp;#rsDatosPersona.NombreCompleto#
			</td>
		  </tr>
		</cfif>
		   <tr>
				<td class="subTitulo" colspan="2" align="center">Elija la localidad que desea agregar a la cobertura del Agente</td>
		   </tr>
		  	<tr>
		   		<td style="font-size:10px" colspan="1" align="center">1. Para agregar todo el Territorio Nacional dejar los campos de Provincia, Cantón, Distrito en blanco.</td>
			</tr>
			<tr>
				<td style="font-size:10px" colspan="1" align="center">2. Para agregar una provincia en su totalidad seleccione la provincia y oprimia el botón guardar.</td>
			</tr>
		   <tr>
			<td>
				<cf_localidad 
					pais = "#session.saci.pais#"
					form = "form1"
					porFila = "false"
					incluyeTabla = "true"
					alignEtiquetas = "right"
					Ecodigo = "#session.Ecodigo#"
					Conexion = "#session.DSN#"
					shownext = "false"
				>
			</td>
	
			<td>
				<cf_botones names="Guardar" values="Guardar" tabindex="1">
			</td>
		   <tr>
		   <tr>
				<td align="center" colspan="2">
					<label>Habilitado </label>
				    <input type="checkbox" name="Habilitado" value="1">
				</td>			
		   </tr>		   
		</table>
   </form>
	   
	<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>
		<cfquery name="rsNiveles" datasource="#session.DSN#">
			select max(a.DPnivel) as maxNivel
			from DivisionPolitica a
			where a.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
		</cfquery>
	
		<cfset colLocalidad = "b.LCnombre">
		<cfloop from="1" to="#rsNiveles.maxNivel-1#" index="i">
				<cfset colLocalidad = 
			
			"
				case when b.DPnivel > #i# then
				(
				select y.LCnombre
				from LocalidadCubo x
					inner join Localidad y
						on y.LCid = x.LCidPadre 
				where x.LCidHijo = b.LCid
				and x.LCnivel = #i#
				) || ' / ' 
				else ' '
				end
				|| 
			"
			&
			colLocalidad>
		</cfloop>
		<cfset rsHabilitadoCob = QueryNew("value, description, ord")>
		<cfset newRow = QueryAddRow(rsHabilitadoCob, 3)>
		<cfset temp = QuerySetCell(rsHabilitadoCob, "value", '', 1)>
		<cfset temp = QuerySetCell(rsHabilitadoCob, "description", '-- todos --', 1)>
		<cfset temp = QuerySetCell(rsHabilitadoCob, "ord", '0', 1)>		
		<cfset temp = QuerySetCell(rsHabilitadoCob, "value", '0', 2)>
		<cfset temp = QuerySetCell(rsHabilitadoCob, "description", 'Inhabilitado', 2)>
		<cfset temp = QuerySetCell(rsHabilitadoCob, "ord", '1', 2)>		
		<cfset temp = QuerySetCell(rsHabilitadoCob, "value", '1', 3)>
		<cfset temp = QuerySetCell(rsHabilitadoCob, "description", 'Habilitado', 3)>
		<cfset temp = QuerySetCell(rsHabilitadoCob, "ord", '1', 3)>

		<form name="listaCobertura" method="get" action="#CurrentPage#" style="margin: 0">
			<input type="hidden" name="Baja" value="0" />
			<input type="hidden" name="Cambio" value="0" />

			<cfinclude template="agente-hiddens.cfm">

			<cfset ckLimpio = "<img src=''/cfmx/saci/images/verde.png'' border=''0'' title=''Aprobada''>">
			<cfset ckLleno = "<img src=''/cfmx/saci/images/verde.png'' border=''0'' title=''Aprobada''>">			
			
			<cfinvoke 
			 component="sif.Componentes.pListas" 
			 method="pLista">
				<cfinvokeargument name="tabla" value="ISBagenteCobertura a
														inner join Localidad b
															on b.LCid = a.LCid"/>
				<cfinvokeargument name="columnas" value="a.AGid, a.LCid, #preserveSingleQuotes(colLocalidad)# as localidad, 
														case a.Habilitado 
															when 1 then '<a href=''javascript: habDeshab(""' || convert(varchar, a.LCid) || '"",""' || convert(varchar, a.AGid) || '"",""1"");''><img src=''/cfmx/saci/images/checked.gif'' border=''0''></a>'
														else 
															'<a href=''javascript: habDeshab(""' || convert(varchar, a.LCid) || '"",""' || convert(varchar, a.AGid) || '"",""0"");''><img src=''/cfmx/saci/images/unchecked.gif'' border=''0''></a>'
														end as HabilitadoCob,
														a.Habilitado,
														'<a href=''javascript: Eliminar(""' || convert(varchar, a.LCid) || '"",""' || convert(varchar, a.AGid) || '"");''><img src=''/cfmx/saci/images/Borrar01_S.gif'' border=''0''></a>' as imag"/>
				<cfinvokeargument name="desplegar" value="localidad,HabilitadoCob,imag"/>
				<cfinvokeargument name="etiquetas" value="Localidades,Habilitar/Desabilitar,Eliminar"/>
				<cfinvokeargument name="filtro" value="a.AGid = #form.AGid#
													   order by b.LCcod"/>
				<cfinvokeargument name="align" value="left,center,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="agente.cfm"/>
				<cfinvokeargument name="formName" value="listaCobertura"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
				<cfinvokeargument name="form_method" value="get"/>
				<cfinvokeargument name="formatos" value="S,S,U"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="(#preserveSingleQuotes(colLocalidad)#), a.Habilitado, imag"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="maxrows" value="10"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="EmptyListMsg" value="--- No hay Localidades registradas ---"/>
				<cfinvokeargument name="rsHabilitadoCob" value="#rsHabilitadoCob#"/>
			</cfinvoke>
		</form>
	</cfif>
	
	<script language="javascript1.2" type="text/javascript">
		function Eliminar(LCid,AGid) {
			if (confirm("Desea eliminar la localidad de la cobertura del agente?")) {
				document.listaCobertura.action = "agente_cobertura-apply.cfm";
				document.listaCobertura.method = "post";
				document.listaCobertura.Baja.value = "1";
				document.listaCobertura.LCID.value = LCid;
				document.listaCobertura.AGID.value = AGid;
				document.listaCobertura.submit();
				return false;
			}
		}
		
		function habDeshab(LCid,AGid,Hab){
			var mensaje = "";
			if(Hab == 1)
				mensaje = "Inhabilitar";
			else
				mensaje = "habilitar";
				
			if (confirm("Desea " + mensaje + " la cobertura del agente?")) {
				document.listaCobertura.action = "agente_cobertura-apply.cfm";
				document.listaCobertura.method = "post";
				document.listaCobertura.Cambio.value = "1";
				document.listaCobertura.LCID.value = LCid;
				document.listaCobertura.AGID.value = AGid;
				if(Hab == 1)
					document.listaCobertura.HABILITADO.value = 0;
				else
					document.listaCobertura.HABILITADO.value = 1;
				document.listaCobertura.submit();
				return false;
			}		
		}
		
		function validaCober(f){
			var error_input;
			var error_msg = '';
					
			if (btnSelected('Guardar', f)){
				// Validacion fija Temporal para la Provincia LCid_1, porque hay que cambiarla por al dinamica
<!---				if (f.LCid_1.value == "") {
					error_msg += "\n - La Provincia no puede quedar en blanco.";
					error_input = f.LCcod_1;
				}					
--->			}
			
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) 
					error_input.focus();
				return false;
			}
			
			return true;
		}
	</script>
	<br />

	<form name="form2" method="post" style="margin: 0;" action="#CurrentPage#">
	<cfinclude template="agente-hiddens.cfm">
	<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td>
			<cf_botones names="Lista" values="Lista Agentes" tabindex="1">
		</td>
	  </tr>
	</table>
	</form>
	
</cfoutput>
