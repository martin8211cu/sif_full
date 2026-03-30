<!--- DEFINE EL MODO --->
<cfset modo="ALTA">
<cfif isdefined("url.INid") and len(trim(url.INid))>
	<cfset modo="CAMBIO">
</cfif>
<cfif isdefined("url.AGid") and len(trim(url.AGid))>
	<cfset form.AGid = url.AGid>	
</cfif>
<cfif isdefined("url.CTid2") and len(trim(url.CTid2))>
	<cfset url.CTid = url.CTid2>	
</cfif>

<!--- CONSULTAS --->	
<cfquery datasource="#Session.DSN#" name="rsIncons">
	select * 
	from  ISBinconsistencias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<cfif modo NEQ 'ALTA'>
	<!--- 1. Form --->	
	<cfquery datasource="#Session.DSN#" name="rsAnotacion">
		select *
		from  ISBagenteIncidencia
		where INid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.INid#" null="#Len(url.INid) Is 0#">
	</cfquery>
	
	<cfquery datasource="#Session.DSN#" name="rsAnPaquete">
		select
			d.PQcodigo, d.PQnombre
		from 
			ISBproducto c
			inner join ISBpaquete d
				on  d.PQcodigo = c.PQcodigo
				and  d.Habilitado = 1
		where 
			c.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnotacion.Contratoid#" null="#Len(url.INid) Is 0#">
	</cfquery>
	
	<cfset url.CTid=rsAnotacion.CTid>	
</cfif>

<cfquery datasource="#Session.DSN#" name="rsPaquetes">
	select
		d.PQcodigo, d.PQnombre	 
	from 
		ISBproducto c
		inner join ISBpaquete d
			on  d.PQcodigo = c.PQcodigo
			and  d.Habilitado = 1
	where 
		c.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTid#">
		and c.CTcondicion = '0'
</cfquery>	
	
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->				
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset url.Pagina = url.PageNum_Lista>
	<cfset url.INid = 0>
</cfif>	
<!--- VARIABLE PARA LA PAGINA Y LOS FILTROS --->

<cfparam name="url.Pagina" default="1">					
<cfparam name="url.Filtro_Inombre" default="">
<cfparam name="url.Filtro_IEstado" default="">
<cfparam name="url.Filtro_INobsCrea" default="">
<cfif not isdefined("url.Pagina") or not len(trim(url.Pagina))>
	<cfset url.Pagina = 1>
</cfif>
<!--- INTERFASE --->
<cfoutput>
<center>
  <table width="95%" border="0" cellspacing="0" cellpadding="2">
    <tr align="center"> 
      <td class="subTitulo">Anotaciones</td></tr>
	<tr> 
	  	<td valign="middle"> 
		 	
			<form name="form1" method="post" action="anotaciones-apply.cfm" onsubmit="return validar(this);">
				
				<!--- Variables que vienen de la pantalla principal y necesitan ser enviadas al apply --->
				<cfif modo NEQ 'ALTA'><input type="hidden" 	name="INid" value="#url.INid#"/></cfif>
				<input type="hidden" 	name="CTid" 	value="<cfif modo NEQ 'ALTA'>#rsAnotacion.CTid#<cfelse>#url.CTid#</cfif>" />
				<!---Variables de pagina y de filtros para que no se pierdan al ejecutar una alta, cambio o baja---> 
				<input type="hidden" 	name="Pagina" 	value="#url.Pagina#" />
				<input type="hidden" 	name="Filtro_Inombre" 	value="#url.Filtro_Inombre#" />
				<input type="hidden" 	name="Filtro_IEstado" 	value="#url.Filtro_IEstado#" />
				<input type="hidden" 	name="Filtro_INobsCrea" 	value="#url.Filtro_INobsCrea#" />
				
				<!--- Pinta los campos del form --->
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					
					<tr><td valign="top" align="right">Paquete
					</td><td valign="top">
						<select name="PQcodigo" id="PQcodigo" tabindex="1">
							<cfloop query="rsPaquetes">
							<option value="#rsPaquetes.PQcodigo#" <cfif modo NEQ 'ALTA' and rsPaquetes.PQcodigo EQ rsAnPaquete.PQcodigo>selected</cfif>>#rsPaquetes.PQnombre#</option>
							</cfloop>
						</select>
					</td>
					<td valign="top" align="right">Inconsistencia
					</td><td valign="top">
						<select name="Iid" id="Iid" tabindex="1">
							<cfloop query="rsIncons">
							<option value="#rsIncons.Iid#" <cfif modo NEQ 'ALTA' and rsIncons.Iid EQ rsAnotacion.Iid>selected</cfif>>#rsIncons.Inombre#</option>
							</cfloop>
						</select>
					</td>
					<td valign="top" align="right">Estado
					</td><td valign="top">
						<select name="IEstado" id="IEstado" tabindex="1">
							<option value="0" <cfif modo NEQ 'ALTA' and rsAnotacion.IEstado is '0'>selected</cfif>>No resuelta </option>
							<option value="1" <cfif modo NEQ 'ALTA' and rsAnotacion.IEstado is '1'>selected</cfif> >Resuelta </option>
						</select>
					</td>
					</tr><tr>
					<td valign="top" align="right">Observación
					</td><td valign="top" colspan="5">
						<input name="INobsCrea" id="INobsCrea" type="text" value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(rsAnotacion.INobsCrea)#</cfif>" maxlength="255" onfocus="this.select()"  size="100" tabindex="1"><!---style="width: 100%" --->
					</td></tr>
					<tr><td colspan="6"> 
						<cf_botones modo="#modo#" tabindex="1">
					</td></tr>
				</table>
			</form>
			
		  </td>
		</tr>
		<tr>
		  <td valign="middle"> 
		 	<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr><td>
					
					
					<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
					<cfquery name="rsInombre" datasource="#session.DSN#">
						select '' as value, '-- todos --' as description, '0' as ord
						union
						select <cf_dbfunction name="to_char" args="Iid"> as value, Inombre as descripcion, '1'as ord  
						from  ISBinconsistencias
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						order by 3,2
					</cfquery>
					<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
					<cfquery name="rsIEstado" datasource="#session.DSN#">
						select '' as value, '-- todos --' as description, '0' as ord
						union
						select '0' as value, 'No Resuelta' as description, '1' as ord
						union
						select '1' as value, 'Resuelta' as description, '1' as ord
						order by 3,2
					</cfquery>
					<!--- LISTA --->
					<form name="lista2" method="get" action="anotaciones.cfm?pagina=#url.pagina#">
					<input type="hidden" 	name="CTid2" 	value="<cfif modo NEQ 'ALTA'>#rsAnotacion.CTid#<cfelse>#url.CTid#</cfif>" />
					<cfinvoke 
						 component="sif.Componentes.pListas" 
						 method="pLista">
							  <cfinvokeargument name="tabla" value=" ISBagenteIncidencia a
																	inner join ISBinconsistencias b
																	on	a.Iid = b.Iid"/>
							  <cfinvokeargument name="columnas" value="a.INid, 
																		case a.IEstado  when '0' then 'No resuelta' else 'Resuelta' end as IEstado ,
																		a.Iid, b.Inombre, a.INobsCrea,
																		a.AGid, a.CTid, a.Contratoid, #url.Pagina# as pagina"/>
							  <cfinvokeargument name="desplegar" value="Inombre,IEstado,INobsCrea"/>
							  <cfinvokeargument name="etiquetas" value="Inconsistencia,Estado,Observacion"/>
							  <cfinvokeargument name="filtro" value="CTid=#url.CTid#"/>
							  <cfinvokeargument name="align" value="left,left,left"/>
							  <cfinvokeargument name="ajustar" value="N"/>
							  <cfinvokeargument name="maxRows" value="15"/>
							  <cfinvokeargument name="irA" value="anotaciones.cfm?pagina=#url.pagina#"/>
							  <cfinvokeargument name="incluyeForm" value="false"/>
							  <cfinvokeargument name="formName" value="lista2"/>
							  <cfinvokeargument name="conexion" value="#session.DSN#"/>
							  <cfinvokeargument name="keys" value="INid"/>
							  <cfinvokeargument name="formatos" value="S,S,S"/>
							  <cfinvokeargument name="mostrar_filtro" value="true"/>
							  <cfinvokeargument name="filtrar_automatico" value="true"/>
							  <cfinvokeargument name="filtrar_por" value="a.Iid,a.IEstado,a.INobsCrea"/>
							  <cfinvokeargument name="form_method" value="get"/>
							  <cfinvokeargument name="rsinombre" value="#rsInombre#"/>
							  <cfinvokeargument name="rsiestado" value="#rsIEstado#"/>
					</cfinvoke>
					</form>
					<script language="javascript" type="text/javascript">
						function funcSalir() {
							window.close();
							return false;
						}
						function funcFiltrar() {
							document.lista2.CTID.value='<cfoutput>#url.CTid#</cfoutput>';
							return true;
						}						
						
					</script>
				</td></tr>
			</table>
	  	</td>
    </tr>
	<tr><td align="center"><form name="formSalir"><cf_botones names="Salir" values="Salir"></form></td></tr>
  </table>
</center>

<script type="text/javascript">
<!--
	<!--- Validación del formulario--->
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		
		if (formulario.INobsCrea.value == "") {
			error_msg += "\n - Observación no puede quedar en blanco.";
			error_input = formulario.INobsCrea;
		}
		if(!btnSelected('Baja', formulario)){
			if (formulario.PQcodigo.value == "") {
				error_msg += "\n - El Paquete no puede quedar en blanco.";
				error_input = formulario.PQcodigo;
			}		
		}
		
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}	
	}
//-->
</script>

</cfoutput>
