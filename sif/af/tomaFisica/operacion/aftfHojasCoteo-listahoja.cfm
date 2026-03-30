<!--- lista de detalles de la hoja de conteo --->
<!--- los botones desplegados en la lista dependen del estado de la hoja --->
<cfset Lvar_max_rows = "0">
<cfswitch expression="#rsform.AFTFestatus_hoja#">
	<cfcase value="0">
		<!--- Botones de la lista cuando la Hoja Tiene estado cero --->
		<cfset Gvar_botones ="Eliminar_Activos, Eliminar_Todos">
	</cfcase>
	<cfcase value="1">
		<!--- Botones de la lista cuando la Hoja Tiene estado uno --->
		<cfset Gvar_botones ="Aplicar,Cancelar">
	</cfcase>
	<cfcase value="2">
		<!--- Botones de la lista cuando la Hoja Tiene estado dos --->
		<cfset Gvar_botones ="Normal,No_Contado,Contado,Eliminar_Activos,Agregar_Activos,Aplicar,Cancelar,Importar">
	</cfcase>
	<cfdefaultcase>
		<!--- Botones de la lista cuando la Hoja Tiene estados tres o nueve --->
		<cfset Gvar_botones ="">
	</cfdefaultcase>
</cfswitch>


<!--- el comportamiento de la lista depende del estado de la hoja --->

<cfswitch expression="#rsform.AFTFestatus_hoja#">

	<cfcase value="0">
	
		<!--- comportamiento de la lista en estado cero --->
		
		<cfsavecontent variable="Lvar_Joins">
			left outer join ACategoria b
				on b.Ecodigo = a.Ecodigo
				and b.ACcodigo = a.ACcodigo			
			left outer join AClasificacion c
				on c.Ecodigo = a.Ecodigo
				and c.ACid = a.ACid
				and c.ACcodigo = a.ACcodigo
			left outer join CFuncional d
				on d.CFid = a.CFid
		</cfsavecontent>
		<cfset Lvar_columnas = "b.ACdescripcion as Categoria,c.ACdescripcion as Clase,d.CFdescripcion">
		<cfset Lvar_desplegar = "Categoria,Clase,CFdescripcion">
		<cfset Lvar_etiquetas = "Categor&iacute;a,Clase,Centro Funcional">
		<cfset Lvar_formatos = "S, S, S">
		<cfset Lvar_align = "left, left, left">
		<cfset Lvar_filtrar_por = "b.ACdescripcion,c.ACdescripcion,d.CFdescripcion">
		<cfset Lvar_max_rows = 10>
		<cfset Lvar_max_rows_query = 250>
		
			
	</cfcase>
	
	
	<cfdefaultcase>
		
		<!--- comportamiento de la lista en estado mayor que cero (uno, dos, tres o nueve) --->
	    <cfparam default="10" name="form.Filtro_Ver">
		<cfif isdefined("Url.Filtro_Ver") and len(trim(Url.Filtro_Ver)) gt 0>
			<cfparam default="#Url.Filtro_Ver#" name="form.Filtro_Ver">
		</cfif>
		
		<cfsavecontent variable="Lvar_Joins">
			left outer join DatosEmpleado c
				on c.DEid = a.DEid_lectura
			left outer join CFuncional d
				on d.CFid = a.CFid_lectura
		</cfsavecontent>
		<cfsavecontent variable="Lvar_columnas">
			 case AFTFbanderaproceso
				when 0 then 'Sin Definir'
				when 1 then 'Normal'
				when 2 then 'No Contado'
				when 3 then 'Contado + de 1'
				when 4 then 'Agregado a la hoja'
			end as Estatus, 
			c.DEidentificacion,
			d.CFdescripcion,'' as Ver
		 </cfsavecontent>
		<cfset Lvar_desplegar = "Estatus,DEidentificacion,CFdescripcion,Ver">
		<cfset Lvar_etiquetas = "Condici&oacute;n,Nuevo Empleado,Nuevo C.Funcional,Ver">
		<cfset Lvar_formatos = "S, S, S, IS">
		<cfset Lvar_align = "left, left, left, right">
		<cfset Lvar_filtrar_por = "a.AFTFbanderaproceso,c.DEidentificacion,d.CFdescripcion,#Form.Filtro_Ver#">
		<cfif isdefined('Form.Filtro_Ver') and len(trim(Form.Filtro_Ver))>
			<cfset Lvar_max_rows = "#Form.Filtro_Ver#">
		</cfif>
		<cfif isdefined('url.Filtro_Ver') and len(trim(url.Filtro_Ver))>
			<cfset Lvar_max_rows = "#url.Filtro_Ver#">
		</cfif>
		<cfif Lvar_max_rows gt 250>
			<cfset Lvar_max_rows_query = Lvar_max_rows>
		<cfelse>
			<cfset Lvar_max_rows_query = 250>
		</cfif>
		
		<!--- crea la consulta de Estados de la lista --->
		
		<!--- create a query, specify data types for each column --->
		<cfset rsEstatus = queryNew("value, description", "CF_SQL_INTEGER, CF_SQL_VARCHAR")>
		
		<!--- add rows --->
		<cfset newrow = queryaddrow(rsEstatus, 6)>
		
		<!--- set values in cells --->
		<cfset temp = querysetcell(rsEstatus, "value", "", 1)>
		<cfset temp = querysetcell(rsEstatus, "description", "--todos--", 1)>
		
		<cfset temp = querysetcell(rsEstatus, "value", "0", 2)>
		<cfset temp = querysetcell(rsEstatus, "description", "Sin Definir", 2)>
		
		<cfset temp = querysetcell(rsEstatus, "value", "1", 3)>
		<cfset temp = querysetcell(rsEstatus, "description", "Normal", 3)>
		
		<cfset temp = querysetcell(rsEstatus, "value", "2", 4)>
		<cfset temp = querysetcell(rsEstatus, "description", "No Contado", 4)>
	
		<cfset temp = querysetcell(rsEstatus, "value", "3", 5)>
		<cfset temp = querysetcell(rsEstatus, "description", "Contado + de 1", 5)>
	
		<cfset temp = querysetcell(rsEstatus, "value", "4", 6)>
		<cfset temp = querysetcell(rsEstatus, "description", "Agregado a la hoja", 6)>
		
	</cfdefaultcase>

</cfswitch>

<!--- pintado de la lista --->



<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<fieldset><legend>Lista de Activos Asociados a la Hoja de Conteo</legend>
		<cfset QueryString_lista=CGI.QUERY_STRING>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"Pagina2=","&")>
		<cfif tempPos NEQ 0>
		  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>
		<cfinvoke QueryString_lista="#QueryString_lista#"
			component="sif.Componentes.pListas" 
			method="pLista"
			tabla="AFTFDHojaConteo a #Lvar_Joins#"
			columnas="a.AFTFid_hoja,a.AFTFid_detallehoja,a.Aplaca,a.Aserie,a.Adescripcion
					, #Lvar_columnas#
					, '' as AFTFespacio_en_blanco"
			filtro="AFTFid_hoja = #form.AFTFid_hoja# order by Aplaca"
			desplegar="Aplaca, Aserie, Adescripcion
					, #Lvar_desplegar#
					, AFTFespacio_en_blanco"
			etiquetas="Activo, Serie, Descripci&oacute;n
					, #Lvar_etiquetas#
					, "
			formatos="S, S, S
					, #Lvar_Formatos#
					, U"
			align="left, left, left
					, #Lvar_align#
					, right"
			ajustar="N"
			irA="aftfHojasCoteo.cfm"
			showLink="#rsform.AFTFestatus_hoja eq 2#"
			funcion="#iif(rsform.AFTFestatus_hoja eq 2,DE('funcProcesarLista2'),DE(''))#"
			fparams="#iif(rsform.AFTFestatus_hoja eq 2,DE('AFTFid_detallehoja'),DE(''))#"
			checkboxes="#iif(ListContains('0,2',rsform.AFTFestatus_hoja),DE('S'),DE('N'))#"
			botones="#Gvar_botones#"
			keys="AFTFid_detallehoja"
			mostrar_filtro="true"
			filtrar_automatico="true"
			filtrar_por="a.Aplaca,a.Aserie,a.Adescripcion
					, #Lvar_filtrar_por#
					, ''"
			maxrows="#Lvar_max_rows#"
			maxrowsquery="#Lvar_max_rows_query#"
			PageIndex="2"
			FormName="lista2"
			navegacion="AFTFid_hoja=#form.AFTFid_hoja#&#Gvar_navegacion_Lista1#"
		>
			<cfloop index = "ColumnName" list = "#Lvar_desplegar#"> 
				<cfif isdefined("rs#trim(ColumnName)#")>
					<cfinvokeargument name="rs#trim(ColumnName)#" value="#Evaluate('rs#trim(ColumnName)#')#">
				</cfif>
			</cfloop>
		</cfinvoke>

	</fieldset>

</td>
</tr>
</table>
<cfoutput>
<script language="javascript" type="text/javascript">
	<!--//
	/*Funciones de la Lista*/
	<cfswitch expression="#rsform.AFTFestatus_hoja#">
		<cfcase value="0">
			<!--- Funciones en de la lista cuando la Hoja Tiene estado cero --->
			/* Funcion cuando se preciona el boton eliminar activos de la lista*/
			function funcEliminar_Activos(){
				if (fnAlgunoMarcadolista2()){
					if (confirm("¿Está seguro de que desea Eliminar los Activos seleccionados de la Hoja?")) {
						return setFormParams(false);
					}
				} else {
					alert('Debe seleccionar un Activo a Eliminar de la Hoja!');
				}		
				return false;
			}
			/* Funcion cuando se preciona el boton eliminar todos de la lista*/
			function funcEliminar_Todos(){
				if (confirm("¿Está seguro de que desea Eliminar Todos los Activos de la Hoja?")) {
					return setFormParams(false);
				}
				return false;
			}
			function funcAplicar(){
				if (confirm("¿Confirma que desea Aplicar la Hoja de Conteo?")) {
					return setFormParams(false);
				}
				return false;
			}
		</cfcase>
		<cfcase value="1">
			function funcAplicar(){
				if (confirm("¿Confirma que desea Aplicar la Hoja de Conteo?")) {
					return setFormParams(false);
				}
				return false;
			}
			function funcCancelar(){
				if (confirm("¿Confirma que desea Cancelar la Hoja de Conteo?")) {
					return setFormParams(false);
				}
				return false;
			}
		</cfcase>
		<cfcase value="2">
			<!--- Funciones en de la lista cuando la Hoja Tiene estado dos --->
			/*funcion cuando se da click a la lista 2*/
			function funcProcesarLista2(id_detalle){
				setFormParams(false,"aftfHojasCoteo.cfm");
				document.lista2.AFTFID_DETALLEHOJA.value=id_detalle;
				document.lista2.submit();
				return true;
			}
			/* Funcion cuando se preciona el boton eliminar activos de la lista*/
			function funcEliminar_Activos(){
				if (fnAlgunoMarcadolista2()){
					if (confirm("¿Está seguro de que desea Eliminar los Activos seleccionados de la Hoja?")) {
						return setFormParams(false);
					}
				} else {
					alert('Debe seleccionar un Activo a Eliminar de la Hoja!');
				}		
				return false;
			}
			/* Funcion cuando se preciona el boton Normal de la lista*/
			function funcNormal(){
				return setFormParams(true);
			}
			/* Funcion cuando se preciona el boton No Contado de la lista*/
			function funcNo_Contado(){
				return setFormParams(true);
			}
			/* Funcion cuando se preciona el boton Contado de la lista*/
			function funcContado(){
				return setFormParams(true);
			}
			function funcAplicar(){
				if (confirm("¿Confirma que desea Aplicar la Hoja de Conteo?")) {
					return setFormParams(false);
				}
				return false;
			}
			function funcCancelar(){
				if (confirm("¿Confirma que desea Cancelar la Hoja de Conteo?")) {
					return setFormParams(false);
				}
				return false;
			}
			function funcAgregar_Activos(){
				return setFormParams(false,'aftfHojasCoteo.cfm');
			}
			function funcImportar(){
				return setFormParams(false,'aftfHojasCoteo.cfm');
			}
		</cfcase>
	</cfswitch>
	/*Funcion cuando se preciona el boton filtrar de la lista*/
	function funcFiltrar2(){
		return setFormParams(false,"aftfHojasCoteo.cfm");
	}
	function setFormParams(validarAlgunoMarcado,action){
		if (!action||action=='') action = "aftfHojasCoteo-sql.cfm";
		if (validarAlgunoMarcado&&!fnAlgunoMarcadolista2()){
			alert('Debe seleccionar un Activo de la Hoja!');
			return false;
		}
		document.lista2.AFTFID_HOJA.value="#Form.AFTFid_hoja#";
		document.lista2.action = action + "?#JSStringFormat(Gvar_navegacion_Lista1)#";
		return true;
	}
	//-->
</script>
</cfoutput>