<cfif NOT ISDEFINED('form.PBtabla') AND ISDEFINED('URL.PBtabla')>
	<CFSET form.PBtabla = URL.PBtabla>
</cfif>

<cfquery datasource="asp" name="caches">
	select distinct c.Ccache as cache
	from Caches c
		join Empresa e
			on c.Cid = e.Cid
	where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
	order by cache
</cfquery>
<cfparam name="form.PBtabla" default="">
<cfparam name="form.PCache" default="">

<cfquery datasource="asp" name="data">
	select *
	from  PBitacora
	where  PBtabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PBtabla#" null="#Len(form.PBtabla) Is 0#">
	and PCache = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PCache#" null="#Len(form.PCache) Is 0#">
</cfquery>

<cfset data_PBtabla       = data.PBtabla  >
<cfset data_PBdescripcion = data.PBdescripcion>
<cfset data_PBllaves      = data.PBllaves  >
<cfset data_PBalterna     = data.PBalterna >
<cfset data_PBlista       = data.PBlista   >
<cfset data_PCache      = data.PCache   >

<cfif isdefined('form.tabla') and isdefined('form.pk') >
	<cfset data_PBtabla       = form.tabla>
	<cfset data_PBdescripcion = form.tabla>
	<cfset data_PCache      = form.pcache   >
	<cfset data_PBllaves      = form.pk>
	<cfif isdefined('form.ak')>
		<cfset data_PBalterna     = form.ak>
	</cfif>
	<cfif isdefined('form.de')>
		<cfset data_PBlista       = form.de>
	</cfif>
</cfif>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: PBitacora - Configuración de la Bitácora



				// Columna: PBtabla Tabla varchar(30)
				if (formulario.PBtabla.value == "") {
					error_msg += "\n - Tabla no puede quedar en blanco.";
					error_input = formulario.PBtabla;
				}




				// Columna: PBdescripcion Descripción varchar(80)
				if (formulario.PBdescripcion.value == "") {
					error_msg += "\n - Descripción no puede quedar en blanco.";
					error_input = formulario.PBdescripcion;
				}




				// Columna: PBllaves Campos llave PK,AK varchar(255)
				if (formulario.PBllaves.value == "") {
					error_msg += "\n - Campos llave PK,AK no puede quedar en blanco.";
					error_input = formulario.PBllaves;
				}







				// Columna: PBinactivo Inactivo bit
				if (formulario.PBinactivo.value == "") {
					error_msg += "\n - Inactivo no puede quedar en blanco.";
					error_input = formulario.PBinactivo;
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

<form action="PBitacora-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
		<tr>
        	<td colspan="3" class="subTitulo">
				Configuración de la Bitácora
			</td>
        </tr>
		<tr>
        	<td valign="top">
            	Tabla
			</td>
            <td valign="top">
				<input name="PBtabla" id="PBtabla" type="text" value="#HTMLEditFormat(data_PBtabla)#" maxlength="30" size="30" onfocus="this.select()"  >
			</td>
			<td valign="top" align="right">
            	<input name="buscar" type="button" id="buscar" class="BtnFiltrar" value="Buscar" onClick="location.href='buscar.cfm?tabla='+escape(this.form.PBtabla.value)">
            </td>
		</tr>
		<tr>
        	<td valign="top">
            	Descripción
			</td>
            <td colspan="2" valign="top">
				<input name="PBdescripcion" id="PBdescripcion" type="text" value="#HTMLEditFormat(data_PBdescripcion)#" maxlength="80" size="50" onfocus="this.select()"  >
			</td>
	 	</tr>
		<tr>
        	<td valign="top">
            	Campos llave primaria
			</td>
            <td colspan="2" valign="top">
				<input name="PBllaves" id="PBllaves" type="text" value="#HTMLEditFormat(data_PBllaves)#" maxlength="255" size="50" onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
        	<td valign="top">
            	Campos llave alterna
			</td>
            <td colspan="2" valign="top">
				<input name="PBalterna" id="PBalterna" type="text" value="#HTMLEditFormat(data_PBalterna)#" maxlength="255" size="50"onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
        	<td valign="top">
            	Descripciones para lista csv
			</td>
            <td colspan="2" valign="top">
				<input name="PBlista" id="PBlista" type="text" value="#HTMLEditFormat(data_PBlista)#" maxlength="255" size="50"onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top">
            	Cache
			</td>
			<td colspan="2" valign="top">
				<select name="PCache" disabled>
	  				<cfloop query="caches">
	  					<option value="#HTMLEditFormat(caches.cache)#" <cfif #HTMLEditFormat(data_PCache)# eq #HTMLEditFormat(caches.cache)#>selected</cfif>>#HTMLEditFormat(caches.cache)#</option>
					</cfloop>
      			</select>
		       <input type="hidden" name="PCache" value="#HTMLEditFormat(data_PCache)#">
				<!---input name="PCache" id="PCache" type="text" value="#HTMLEditFormat(data_PCache)#" maxlength="25" size="50"onfocus="this.select()"  --->
			</td>
		</tr>
		<tr>
        	<td valign="top">
            </td>
            <td colspan="2" valign="top">
                <input name="PBinactivo" id="PBinactivo" type="checkbox" value="1" <cfif Len(data.PBinactivo) And data.PBinactivo>checked</cfif> >
                <label for="PBinactivo">Inactivo</label>
			</td>
		</tr>
		<tr>
        	<td colspan="3" class="formButtons">
                <table border="0" align="center">
                	<tr>
                    	<td>
                    		<cfif data.RecordCount>
                        		<cf_botones modo='CAMBIO'>
                            <cfelse>
                                <cf_botones modo='ALTA'>
                            </cfif>
                        </td>
                        <td>
                        	<input type="button" name="edit" value="Generar triggers ..." class="BtnSiguiente" onClick="location.href='../../operacion/trigger/index.cfm'">
                   		</td>
					    <td>
						    <input type="button" name="edit" value="Agregar Tablas" class="BtnSiguiente" onClick="location.href='tablas.cfm'">
						</td>
                    </tr>
                </table>
            </td>
        </tr>
	</table>
		<cfset ts = "">
        <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts">
        </cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
</form>
</cfoutput>