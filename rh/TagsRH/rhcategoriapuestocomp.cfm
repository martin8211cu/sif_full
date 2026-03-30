<cfset def = QueryNew('dato')>

<cfparam name="Attributes.form" 				default="form1" 			type="String">		<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" 				default="#def#" 			type="query">		<!--- consulta por defecto --->
<cfparam name="Attributes.tablaReadonly" 		default="false" 			type="boolean">		<!--- indica si se accede en forma lectura --->
<cfparam name="Attributes.categoriaReadonly"	default="false" 			type="boolean">		<!--- indica si se accede en forma lectura --->
<cfparam name="Attributes.puestoReadonly"		default="false" 			type="boolean">		<!--- indica si se accede en forma lectura --->
<cfparam name="Attributes.showTablaSalarial" 	default="true" 				type="boolean">		<!--- indica si se muestra la fila de tabla Salarial --->
<cfparam name="Attributes.incluyeTabla" 		default="true" 				type="boolean">		<!--- indica si el tag incluye la tabla o solo pinta las filas --->
<cfparam name="Attributes.incluyeHiddens"		default="true" 				type="boolean">		<!--- Se determina si los hiddens deben incluirse en la pantalla en caso que se desplieguen los datos en modo consulta --->
<cfparam name="Attributes.ocultar"				default="false" 			type="boolean">		<!--- Se determina si hay que ocultar las filas de entrada --->
<cfparam name="Attributes.tabindex"				default="1"					type="string">		<!--- tab index para los campos html --->
<cfparam name="Attributes.Ecodigo"				default="#Session.Ecodigo#"	type="integer">		<!--- Empresa --->
<cfparam name="Attributes.align"				default="left"				type="string">		<!--- alineacion de las etiquetas --->

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTTid")>
	<cfset LvarRHTTid = Evaluate('Attributes.query.RHTTid')>
	<cfset LvarRHCid = Evaluate('Attributes.query.RHCid')>
	<cfset LvarRHMPPid = Evaluate('Attributes.query.RHMPPid')>
</cfif>

<cfoutput>
<cfif Attributes.incluyeTabla>
	<table border="0">
</cfif>
	<cfif Attributes.showTablaSalarial>
	  <tr id="trTipoTabla" <cfif Attributes.ocultar> style="display: none;"</cfif>>
		<td align="#Attributes.align#"><strong><cf_translate key="LB_TipoDeTabla">Tipo de Tabla</cf_translate></strong></td>
	  </tr>
	  <tr>
		<td>
			<cfif not Attributes.tablaReadonly>
				<cfquery name="rsTablas" datasource="#session.DSN#">
					select RHTTid, rtrim(RHTTcodigo) as RHTTcodigo, RHTTdescripcion
					from RHTTablaSalarial
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
					order by RHTTcodigo
				</cfquery>
				
				<cfif not Attributes.puestoReadonly>
					<script language="javascript" type="text/javascript">
						<!--- Limpia el puesto maestro --->
						function funcRHTTid() {
							<!--- Se limpia el puesto maestro si la categoría ha cambiado --->
							if (document.#Attributes.form#.RHTTid.value != document.#Attributes.form#.RHTTid_ant.value) {
							
								document.#Attributes.form#.RHMPPid.value = '';
								document.#Attributes.form#.RHMPPcodigo.value = '';
								document.#Attributes.form#.RHMPPdescripcion.value = '';

								document.#Attributes.form#.RHCid.value = '';
								document.#Attributes.form#.RHCcodigo.value = '';
								document.#Attributes.form#.RHCdescripcion.value = '';

								document.#Attributes.form#.LvarCat.value = '';
								document.#Attributes.form#.LvarPuesto.value = '';
								document.#Attributes.form#.LvarPid.value = '';
								document.#Attributes.form#.LvarCid.value = '';

								document.#Attributes.form#.RHTTid_ant.value = document.#Attributes.form#.RHTTid.value;
							}
						}
					</script>
				</cfif>
				
				<select name="RHTTid" onchange="javascript: funcRHTTid();" tabindex="#Attributes.tabindex#">
				<cfloop query="rsTablas">
					<option value="#rsTablas.RHTTid#"<cfif isdefined("LvarRHTTid") and LvarRHTTid EQ rsTablas.RHTTid> selected</cfif>>#rsTablas.RHTTcodigo# - #rsTablas.RHTTdescripcion#</option>
				</cfloop>
				</select>
				<cfif isdefined("LvarRHTTid")>
					<cfset RHTTid_ant = LvarRHTTid>
				<cfelse>
					<cfset RHTTid_ant = ''>
				</cfif>
				<input type="hidden" name="RHTTid_ant" value="#RHTTid_ant#" />
			<cfelseif isdefined("Attributes.query") and isdefined("Attributes.query.RHTTid")>
				<cfif Attributes.incluyeHiddens>
					<input type="hidden" name="RHTTid" value="#LvarRHTTid#" />
				</cfif>
				<cfif Len(Trim(Evaluate('Attributes.query.RHTTcodigo')))>
					#Evaluate('Attributes.query.RHTTcodigo')# - #Evaluate('Attributes.query.RHTTdescripcion')#
				<cfelse>
					&nbsp;
				</cfif>
			<cfelse>
				&nbsp;
			</cfif>
		</td>
	  </tr>
	</cfif>
	  <tr id="trPuestoCat" <cfif Attributes.ocultar> style="display: none;"</cfif>>
		<td align="#Attributes.align#" nowrap><strong><cf_translate key="LB_Puesto">Puesto/Categoría:</cf_translate></strong></td>
	  </tr>
	  <tr>	
		<td>
			<cfif not Attributes.puestoReadonly>
				<cfif isdefined("LvarRHMPPid")>
					<cf_rhpuestocategoriacomp form="#Attributes.form#" ValidaCatPuesto="true" idquery="#LvarRHMPPid#" tabindex="#Attributes.tabindex#" empresa="#Attributes.Ecodigo#">
				<cfelse>
					<cf_rhpuestocategoriacomp form="#Attributes.form#" ValidaCatPuesto="true" tabindex="#Attributes.tabindex#" empresa="#Attributes.Ecodigo#">
				</cfif>
			<cfelseif isdefined("Attributes.query") and isdefined("Attributes.query.RHTTid")>
				<cfif Attributes.incluyeHiddens>
					<input type="hidden" name="RHMPPid" value="#LvarRHMPPid#" />
				</cfif>
				<cfif Len(Trim(Evaluate('Attributes.query.RHMPPcodigo')))>
					#Evaluate('Attributes.query.RHMPPcodigo')# - #Evaluate('Attributes.query.RHMPPdescripcion')#
				<cfelse>
					&nbsp;
				</cfif>
			<cfelse>
				&nbsp;
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td  align="#Attributes.align#"><strong>Categoría:</strong></td>
	  </tr>
	  <tr>
		<td>
		<cfif isdefined ('LvarRHCid') and len(trim(LvarRHCid)) gt 0>
			<cfquery name="rsRHC" datasource="#session.dsn#">		
				select RHCcodigo#LvarCNCT#'-'#LvarCNCT# RHCdescripcion as descrip from RHCategoria where RHCid=#LvarRHCid#
			</cfquery>
			<input type="text" name="LvarCat" disabled="disabled" value="#rsRHC.descrip#" />
			<input type="hidden" name="LvarCid" value="#LvarRHCid#" />
		<cfelse>
			<input type="text" name="LvarCat" disabled="disabled" />
			<input type="hidden" name="LvarCid" />
		</cfif>
			
		</td>
	  </tr>
	   <tr>
		<td  align="#Attributes.align#"><strong>Puesto:</strong></td>
	   </tr>
	   <tr>
		<td>
		<cfif isdefined('LvarRHMPPid') and len(trim(LvarRHMPPid)) gt 0>
			<cfquery name="rsRHCP" datasource="#session.dsn#">
				select RHMPPcodigo#LvarCNCT#'-'#LvarCNCT# RHMPPdescripcion  as descrip from RHMaestroPuestoP where RHMPPid=#LvarRHMPPid#
			</cfquery>
			<input type="text" name="LvarPuesto" disabled="disabled" value="#trim(rsRHCP.descrip)#" />
			<input type="hidden" name="LvarPid" value="#LvarRHMPPid#" />
		<cfelse>
			<input type="text" name="LvarPuesto" disabled="disabled" />
			<input type="hidden" name="LvarPid" />
		</cfif>
		</td>
	  </tr>
<cfif Attributes.incluyeTabla>
	</table>
</cfif>
</cfoutput>
