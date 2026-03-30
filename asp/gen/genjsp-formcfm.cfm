<cfoutput>

<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i">
#'<'#cfparam name="url.#metadata.pk.cols[i].code#" default="">
</cfloop>

#'<'#cfquery datasource="##session.dsn##" name="data">
	select *
	from  #metadata.code#
	<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i">
		<cfif i is 1>where <cfelse>and </cfif>
		#metadata.pk.cols[i].code# =
		#'<'#cfqueryparam cfsqltype="#metadata.pk.cols[i].coldfusiontype#" value="##url.#metadata.pk.cols[i].code###" null="##Len(url.#metadata.pk.cols[i].code#) Is 0##">
	</cfloop>
#'<'#/cfquery>

#'<'#cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: #metadata.code# - #metadata.name#
		<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i">
			<cfset this_col = metadata.cols[i]>
			<cfif this_col.mandatory is 1 and this_col.identity neq 1 and ListFindNoCase('ts_rversion,BMfecha,BMfechamod,BMUsucodigo,Ecodigo,CEcodigo', this_col.code) is 0>
				// Columna: #this_col.code# #this_col.name# #this_col.type#
				if (formulario.#this_col.code#.value == "") {
					error_msg += "\n - #JSStringFormat(this_col.name)# no puede quedar en blanco.";
					error_input = formulario.#this_col.code#;
				}
			</cfif>
		</cfloop>			
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

<form action="#metadata.code#-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	#metadata.name#
	</td></tr>
	<cfset hidden_fields = "">
	<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i">
		<cfset this_col = metadata.cols[i]>
		<cfif this_col.identity or ListFindNoCase('ts_rversion,BMfecha,BMfechamod,BMUsucodigo,Ecodigo,CEcodigo', this_col.code)>
			<cfset hidden_fields = ListAppend(hidden_fields, this_col.code)>
		<cfelse>
		<tr><td valign="top">#HTMLEditFormat(this_col.name)#
		</td><td valign="top">
		<cfif IsDefined('this_col.values')>
			<select name="#HTMLEditFormat(this_col.code)#" id="#HTMLEditFormat(this_col.code)#">
			<cfloop from="1" to="#ArrayLen(this_col.values)#" index="j">
				<option value="#HTMLEditFormat(this_col.values[j].code)#" #'<'#cfif data.#this_col.code# is '#this_col.values[j].code#'>selected#'<'#/cfif> >
					#HTMLEditFormat(this_col.values[j].name)#
				</option>
			</cfloop>
			</select>
		<cfelseif this_col.type is 'datetime'>
			#'<'#cf_sifcalendario form="form1" name="#HTMLEditFormat(this_col.code)#" value="##DateFormat(data.#this_col.code#,'dd/mm/yyyy')##">
		<cfelseif this_col.type is 'text'>
			<textarea style="font-family:Arial, Helvetica, sans-serif;font-size:12px" rows="6" cols="40" name="#HTMLEditFormat(this_col.code)#" onfocus="this.select()">##HTMLEditFormat(data.#this_col.code#)##</textarea>
		<cfelseif this_col.type is 'bit'>
			<input name="#HTMLEditFormat(this_col.code)#" id="#HTMLEditFormat(this_col.code)#" type="checkbox" value="1" #'<'#cfif Len(data.#this_col.code#) And data.#this_col.code#>checked#'<'#/cfif> >
			<label for="#HTMLEditFormat(this_col.code)#">#HTMLEditFormat(this_col.name)#</label>
		<cfelse>
			<input name="#HTMLEditFormat(this_col.code)#" id="#HTMLEditFormat(this_col.code)#" type="text" value="##HTMLEditFormat(data.#this_col.code#)##" 
				maxlength="#this_col.textlen#"
				onfocus="this.select()" <!--- onblur="onblur#ListFirst(this_col.type,'(')#()" ---> >
		</cfif>
		</td></tr>
		</cfif>
	</cfloop>
	<tr><td colspan="2" class="formButtons">
		#'<'#cfif data.RecordCount>
			#'<'#cf_botones modo='CAMBIO'>
		#'<'#cfelse>
			#'<'#cf_botones modo='ALTA'>
		#'<'#/cfif>
	</td></tr>
	</table>
	<!--- hidden fields --->
	<cfloop list="#hidden_fields#" index="hiddn">
		<cfif hiddn is 'ts_rversion'>
			#'<'#cfset ts = "">
			#'<'#cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="##data.ts_rversion##" returnvariable="ts">
			#'<'#/cfinvoke>
			<input type="hidden" name="ts_rversion" value="##ts##">
		<cfelse>
			<input type="hidden" name="#hiddn#" value="##HTMLEditFormat(data.#hiddn#)##">
		</cfif>
	</cfloop>
</form>

#'<'#/cfoutput>
</cfoutput>
