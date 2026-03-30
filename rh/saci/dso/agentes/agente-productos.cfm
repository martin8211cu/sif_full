<cfoutput>

	<cfif isdefined("url.Filtro_nombre") and len(trim(url.Filtro_nombre))>
		<cfset form.Filtro_nombre = url.Filtro_nombre>
	</cfif>
	<cfif isdefined("url.Filtro_descripcion") and len(trim(url.Filtro_descripcion))>
		<cfset form.Filtro_descripcion = url.Filtro_descripcion>
	</cfif>
	<cfif isdefined("url.Filtro_HabilitadoProd") and len(trim(url.Filtro_HabilitadoProd))>
		<cfset form.Filtro_HabilitadoProd = url.Filtro_HabilitadoProd>
	</cfif>
	<cfparam name="form.Filtro_nombre" default="">
	<cfparam name="form.Filtro_descripcion" default="">
	<cfparam name="form.Filtro_HabilitadoProd" default="">
	
	<cfquery name="rsPaquete" datasource="#session.DSN#">
			select distinct paq.PQcodigo,paq.PQdescripcion,ofer.Habilitado,coalesce(paq.PQagrupa,-1) as PQagrupa 
			from ISBpaquete paq
				left join ISBagenteOferta ofer
				on paq.PQcodigo = ofer.PQcodigo
				and ofer.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGid#" null="#Len(form.AGid) Is 0#">
			Where paq.Habilitado = 1
			order by paq.PQcodigo	
	</cfquery>
		
		
	<!---- Final de la Lista --->
	<form name="form1" method="post" action="agente-productos-apply.cfm" style="margin: 0;">
		<input type="hidden" name="Filtro_nombre" value="#form.Filtro_nombre#">
		<input type="hidden" name="Filtro_descripcion" value="#form.Filtro_descripcion#">
		<input type="hidden" name="Filtro_HabilitadoProd" value="#form.Filtro_HabilitadoProd#">
		<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
		<cfinclude template="agente-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<cfif ExisteAgente>
		  <tr>
			<td colspan="4" align="center" class="menuhead">
				#rsDatosPersona.Pid#&nbsp;&nbsp;#rsDatosPersona.NombreCompleto#
			</td>
		  </tr>
		</cfif>
		   <tr align="center">
				<td class="subTitulo" colspan="4">Seleccione los paquetes que desea agregar a la oferta del Agente</td>
				<td valign="middle">
					<cf_botones names="Guardar" values="Guardar" tabindex="1">
				</td>
				<tr>
				<td align="right">
					<select name="grupo" id="grupo" >
						<option value="0" selected>Deshabilitado</option>
						<option value="1">Solo Interno</option>
						<option value="2">Interno/Externo</option>
						<option value="3">Grupo Vpn</option>
						<option value="4">Ready</option>
						<option value="5">Grupo Hogar</option>
						<option value="6">Plana, Alterno</option>
						<option value="7">Solo Interno No Cobrable</option>
						<option value="8">Solo Externo</option>
						<option value="9">Grupo Cabletica</option>
						<option value="10">Centros Empresariales</option>
						<option value="11">Grupo Amnet</option>
						<option value="12">Grupo Otros</option>
						<option value="13">Grupo Cuentas de Servicio</option>
						<option value="14">Grupo Consumo Conmutados</option>
						<option value="15">Grupo Correos</option>
						<option value="16">Grupo Conmutados</option>
					</select>
				</td>
				<td align="left">
					<cf_botones names="Marcar_Grupo" values="Marcar_Grupo" tabindex="1">
				</td>

				</tr>
				<table width="100%"  border="1" cellspacing="1" cellpadding="1">
					<tr> 
						<td><input  type="checkbox" name="OFC_todos" onclick="javascript: chequea(this);" tabindex="1" value="0"></td>
						<td><label>C&oacute;digo</label> </td>
						<td align="center"><label>Descripci&oacute;n</label> </td>
					</tr>
					<cfloop query="rsPaquete">
					<tr>
							<td><input  type="checkbox" name="OFC_#rsPaquete.PQcodigo#" <cfif Len(rsPaquete.Habilitado)> checked</cfif> tabindex="1" value="#rsPaquete.PQcodigo#"></td>
							<td>#rsPaquete.PQcodigo#</td>
							<td>#rsPaquete.PQdescripcion#</td>
					</tr>
					</cfloop>
				</table>
			
				<!---<td align="right" width="25%" valign="middle"><label>Paquete </label></td>--->
<!---				<td valign="middle" width="35%">		
				<cf_paquete 
					sufijo = ""
					agente = ""
					form = "form1"
					funcion = ""
					filtroPaqInterfaz = "0"
					Ecodigo = "#session.Ecodigo#"
					Conexion = "#session.DSN#"
					showCodigo="false"
				>
				</td>
				<td valign="middle"><label>&nbsp;&nbsp;&nbsp;&nbsp;Habilitado 
				    <input type="checkbox" name="Habilitado" value="1">
				</label></td>--->


			</tr>			
		  <tr>
			<td valign="bottom" colspan="3" align="right">
				<cf_botones names="Guardar" values="Guardar" tabindex="1">
			</td>
		 </tr>
		 <tr>	
			<td colspan="4">
				<hr>
			</td>

		  </tr>		   
	</table>
	</form>
	</div>
		
			
							<!---<cfinvokeargument name="columnas" value="a.AGid,
														a.PQcodigo,
														case a.Habilitado  
																when 1 then '<a href=''javascript: habDeshab(""' || a.PQcodigo || '"",""' || convert(varchar, a.AGid) || '"",""1"");''><img src=''/cfmx/saci/images/checked.gif'' border=''0''></a>'
															else 
																'<a href=''javascript: habDeshab(""' || a.PQcodigo || '"",""' || convert(varchar, a.AGid) || '"",""0"");''><img src=''/cfmx/saci/images/unchecked.gif'' border=''0''></a>'
														end as HabilitadoProd,
														a.Habilitado,
														rtrim(ltrim(b.PQcodigo)) || '-' || b.PQdescripcion as nombre, 
														b.PQdescripcion as descripcion,
														
														'<a href=''javascript: Eliminar(""' || rtrim(b.PQcodigo) || '"",""' || convert(varchar, a.AGid) || '"");''><img src=''/cfmx/saci/images/Borrar01_S.gif'' border=''0''></a>' as imag"/>
	--->
			
		
	<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>
			
			<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO HABILITADO--->
			<cfset rsHabilitadoProd = QueryNew("value, description, ord")>
			<cfset newRow = QueryAddRow(rsHabilitadoProd, 3)>
			<cfset temp = QuerySetCell(rsHabilitadoProd, "value", '', 1)>
			<cfset temp = QuerySetCell(rsHabilitadoProd, "description", '-- todos --', 1)>
			<cfset temp = QuerySetCell(rsHabilitadoProd, "ord", '0', 1)>		
			<cfset temp = QuerySetCell(rsHabilitadoProd, "value", '0', 2)>
			<cfset temp = QuerySetCell(rsHabilitadoProd, "description", 'Inhabilitado', 2)>
			<cfset temp = QuerySetCell(rsHabilitadoProd, "ord", '1', 2)>		
			<cfset temp = QuerySetCell(rsHabilitadoProd, "value", '1', 3)>
			<cfset temp = QuerySetCell(rsHabilitadoProd, "description", 'Habilitado', 3)>
			<cfset temp = QuerySetCell(rsHabilitadoProd, "ord", '1', 3)>
		
		<form name="listaProductos" method="get" action="#CurrentPage#" style="margin: 0">
				<input type="hidden" name="Baja" value="0" />
				<input type="hidden" name="Cambio" value="0" />
				<cfinclude template="agente-hiddens.cfm">
				<cfinvoke 
				 component="sif.Componentes.pListas" 
				 method="pLista">
					<cfinvokeargument name="tabla" value="ISBpaquete b
															 inner join ISBagenteOferta a
																on a.PQcodigo = b.PQcodigo
																and b.Ecodigo = #session.Ecodigo#"/>
							<cfinvokeargument name="columnas" value="a.AGid,
														coalesce(a.PQcodigo,b.PQcodigo) as PQcodigo,
														rtrim(ltrim(b.PQcodigo)) || '-' || b.PQdescripcion as nombre, 
														b.PQdescripcion as descripcion"/>
			<cfinvokeargument name="desplegar" value="nombre,descripcion"/>
					<cfinvokeargument name="etiquetas" value="Nombre,Descripción"/>
					<cfinvokeargument name="filtro" value="AGid=#form.AGid#"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="agente.cfm"/>
					<cfinvokeargument name="formName" value="listaProductos"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="form_method" value="get"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="filtrar_por" value="rtrim(ltrim(b.PQcodigo)) || '-' || b.PQnombre,b.PQdescripcion"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="maxrows" value="10"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="--- No hay Paquetes registrados ---"/>
					<!---<cfinvokeargument name="rsHabilitadoProd" value="#rsHabilitadoProd#"/>--->
					<cfinvokeargument name="debug" value="N"/>
					
				</cfinvoke>
			</form>
			
		</cfif>	
	<script language="javascript1.2" type="text/javascript">
		function chequea(obj){
			
			if (obj.checked == true){
			
			<cfloop query="rspaquete">
				if (document.form1.OFC_#rsPaquete.PQcodigo# != undefined) {
					document.form1.OFC_#rsPaquete.PQcodigo#.checked = true;
				}
			</cfloop>
			
			} else {
			
			<cfloop query="rspaquete">
				if (document.form1.OFC_#rsPaquete.PQcodigo# != undefined) {
					document.form1.OFC_#rsPaquete.PQcodigo#.checked = false;
				}
			</cfloop>
			}
					
		 return false;	
		}
		
		function funcMarcar_Grupo(){
						
			<cfloop query="rspaquete">
				if (document.form1.OFC_#rsPaquete.PQcodigo# != undefined){
						if (parseInt(document.form1.grupo.value,10) == #rsPaquete.PQagrupa#) {
						document.form1.OFC_#rsPaquete.PQcodigo#.checked = true;
					}
				}
			</cfloop>

		  return false;	
		}
		
		
		
		function Eliminar(PQcodigo,AGid){
			if (confirm("Desea eliminar el producto de la oferta del agente?")) {
				document.listaProductos.action = "agente-productos-apply.cfm";
				document.listaProductos.method = "post";
				document.listaProductos.Baja.value = "1";
				document.listaProductos.PQCODIGO.value = PQcodigo;
				document.listaProductos.AGID.value = AGid;
				document.listaProductos.submit();
				return false;
			}
		}
		
		
		function habDeshab(PQcodigo,AGid,Hab){
			var mensaje = "";
			if(Hab == 1)
				mensaje = "Inhabilitar";
			else
				mensaje = "habilitar";
				
			if (confirm("Desea " + mensaje + " este producto para el agente?")) {
				document.listaProductos.action = "agente-productos-apply.cfm";
				document.listaProductos.method = "post";
				document.listaProductos.Cambio.value = "1";
				document.listaProductos.PQCODIGO.value = PQcodigo;
				document.listaProductos.AGID.value = AGid;
				if(Hab == 1)
					document.listaProductos.HABILITADO.value = 0;
				else
					document.listaProductos.HABILITADO.value = 1;
				document.listaProductos.submit();
				return false;
			}		
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
