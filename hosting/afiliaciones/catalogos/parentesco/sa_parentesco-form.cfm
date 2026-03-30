<cfparam name="url.id_parentesco" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from  sa_parentesco
	where id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_parentesco#" null="#Len(url.id_parentesco) Is 0#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="inversos">
	select id_parentesco, nombre_masc, nombre_fem, upper(nombre_masc) as nombre_masc_upper
	from  sa_parentesco
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by nombre_masc_upper
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: sa_parentesco - sa_parentesco
			// Columna: nombre_masc nombre_masc varchar(30)
			if (formulario.nombre_masc.value == "") {
				error_msg += "\n - nombre_masc no puede quedar en blanco.";
				error_input = formulario.nombre_masc;
			}
		
			// Columna: nombre_fem nombre_fem varchar(30)
			if (formulario.nombre_fem.value == "") {
				error_msg += "\n - nombre_fem no puede quedar en blanco.";
				error_input = formulario.nombre_fem;
			}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>

<form action="sa_parentesco-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr>
	  <td colspan="2" class="subTitulo">
	Parentesco</td>
	</tr>
	
		<tr>
		  <td valign="top">Nombre masculino </td>
		  <td valign="top">
		
			<input name="nombre_masc" id="nombre_masc" type="text" value="#HTMLEditFormat(data.nombre_masc)#" 
				maxlength="30"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr>
		  <td valign="top">Nombre femenino </td>
		  <td valign="top">
		
			<input name="nombre_fem" id="nombre_fem" type="text" value="#HTMLEditFormat(data.nombre_fem)#" 
				maxlength="30"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr>
		  <td valign="top">Parentesco Inverso </td>
		  <td valign="top">
		<select name="inverso" id="inverso">
			<option value="">(ninguno)</option>
			<cfif Len(url.id_parentesco) is 0>
			<option value="-1">(El mismo)</option>
			</cfif>
			<cfloop query="inversos">
			<option value="#inversos.id_parentesco#" <cfif inversos.id_parentesco is data.inverso>selected</cfif>>
				#HTMLEditFormat(inversos.nombre_masc)#/#HTMLEditFormat(inversos.nombre_fem)#</option>
			</cfloop>
		</select>
		
		</td></tr>
		
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones modo='CAMBIO'>
		<cfelse>
			<cf_botones modo='ALTA'>
		</cfif>
	</td></tr>
	</table>
			<input type="hidden" name="id_parentesco" value="#HTMLEditFormat(data.id_parentesco)#">
		
	
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
	
		
			<input type="hidden" name="CEcodigo" value="#HTMLEditFormat(data.CEcodigo)#">
		
	
		
			<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
		
	
		
			<input type="hidden" name="BMfechamod" value="#HTMLEditFormat(data.BMfechamod)#">
		
	
		
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		
	
</form>

</cfoutput>
