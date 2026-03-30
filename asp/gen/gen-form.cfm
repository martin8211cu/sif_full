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
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
	function funcNuevo(){
		location.href = '#metadata.code#.cfm?edit=1';
		return false;
	}
//-->
</script>

<form action="#metadata.code#-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
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
		<tr><td valign="top"><label for="#HTMLEditFormat(this_col.code)#">#HTMLEditFormat(this_col.name)#</label>
		</td><td valign="top">
		<cfif IsDefined('this_col.values')>
			<select name="#HTMLEditFormat(this_col.code)#" id="#HTMLEditFormat(this_col.code)#" tabindex="1">
			<cfloop from="1" to="#ArrayLen(this_col.values)#" index="j">
				<option value="#HTMLEditFormat(this_col.values[j].code)#" #'<'#cfif data.#this_col.code# is '#this_col.values[j].code#'>selected#'<'#/cfif> >
					#HTMLEditFormat(this_col.values[j].name)#
				</option>
			</cfloop>
			</select>
		<cfelseif this_col.type is 'datetime'>
			#'<'#cf_sifcalendario form="form1" name="#HTMLEditFormat(this_col.code)#" value="##DateFormat(data.#this_col.code#,'dd/mm/yyyy')##" tabindex="1">
		<cfelseif this_col.type is 'text'>
			<textarea style="font-family:Arial, Helvetica, sans-serif;font-size:12px" rows="6" cols="40" name="#HTMLEditFormat(this_col.code)#" onfocus="this.select()" tabindex="1">##HTMLEditFormat(data.#this_col.code#)##</textarea>
		<cfelseif this_col.type is 'image'>
			#'<'#!---
				Nota: El onchange funciona en Internet Explorer 6.0 o anteriores, pero no funciona en Mozilla Firefox
				Más detalles en http://kb.mozillazine.org/Firefox_:_Issues_:_Links_to_Local_Pages_Don%27t_Work
			---#'>'#
			<input name="#HTMLEditFormat(this_col.code)#" id="#HTMLEditFormat(this_col.code)#" type="file" value="" 
				maxlength="#this_col.textlen#" tabindex="1"
				onfocus="this.select()" onchange="document.getElementById('img_#HTMLEditFormat(JSStringFormat(this_col.code))#').src=this.value"><br />
			<img width="120" style="max-height: 120; max-width: 120;" id="img_#HTMLEditFormat(this_col.code)#" tabindex="-1" src="#'<'#cfif Len(data.#this_col.code#)>#metadata.code#-download.cfm?f=#URLEncodedFormat(this_col.code)#<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" 
		index="i">&amp;#metadata.pk.cols[i].code#=##URLEncodedFormat(data.#metadata.pk.cols[i].code
				#)##</cfloop>#'<'#cfelse>about:blank#'<'#/cfif>">
		<cfelseif this_col.type is 'bit'>
			<input name="#HTMLEditFormat(this_col.code)#" id="#HTMLEditFormat(this_col.code)#" type="checkbox" value="1" tabindex="1" #'<'#cfif Len(data.#this_col.code#) And data.#this_col.code#>checked#'<'#/cfif> >
			<label for="#HTMLEditFormat(this_col.code)#">#HTMLEditFormat(this_col.name)#</label>
		<cfelse>
			<input name="#HTMLEditFormat(this_col.code)#" id="#HTMLEditFormat(this_col.code)#" type="text" value="##HTMLEditFormat(data.#this_col.code#)##" 
				maxlength="#this_col.textlen#" tabindex="1"
				onfocus="this.select()" <!--- onblur="onblur#ListFirst(this_col.type,'(')#()" ---> >
		</cfif>
		</td></tr>
		</cfif>
	</cfloop>
	<tr><td colspan="2" class="formButtons">
		#'<'#cfif data.RecordCount>
			#'<'#cf_botones  regresar="#metadata.code#.cfm" modo="CAMBIO" tabindex="1">
		#'<'#cfelse>
			#'<'#cf_botones  regresar="#metadata.code#.cfm" modo="ALTA" tabindex="1">
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
