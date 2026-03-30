<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Imprimir Placas" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Selecciones un archivo para importar" returnvariable="LB_Archivo"/>

<cffunction name="RandString" output="no" returntype="string">
	<cfargument name="length" type="numeric" required="yes">
	<!--- Local vars --->
	<cfset var result="">
	<cfset var i=0>
	<!--- Create string --->
	 <cfloop index="i" from="1" to="#ARGUMENTS.length#">
		 <!--- Random character in range A-Z --->
		 <cfset result=result&Chr(RandRange(65, 90))>
	 </cfloop>
 
	 <!--- Return it --->
	 <cfreturn result>
</cffunction>
 
<cffunction name="InsertaPlaca">
	<cfargument name="placa" type="string" required="yes">
	<cfquery datasource="#session.dsn#">
		 insert into #PLACAS#
		 (Placa, Ecodigo) values ('#arguments.placa#',#session.Ecodigo#)
	</cfquery>
</cffunction>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<div align="center">
			<form name="form1" action="#" onsubmit="return validate(this);" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td align="right"><cfoutput>#LB_Archivo#:&nbsp;</cfoutput> </td>
						<td >
							<input type="file" name="fileToUpload" id="fileToUpload" <!--- accept="text/plain, .txt" ---> required>
						</td>
					</tr>
				</table>
				<br/>
				<input type="submit" value="Generar" name="submit">
			</form>

			<cfif isdefined('form.FILETOUPLOAD')>
				<cfset _guid = RandString(8)>
				<cf_dbtemp name="placa_#_guid#" returnvariable="PLACAS">
					<cf_dbtempcol name="Placa"     		type="varchar(50)"  mandatory="yes">
					<cf_dbtempcol name="Ecodigo" 		type="int" 			mandatory="yes">
				</cf_dbtemp>
				<cftry>

					<cfscript>
						myfile = FileOpen(form.FILETOUPLOAD, "read"); 
						while(NOT FileisEOF(myfile)) { 
							_line = FileReadLine(myfile);
							
							InsertaPlaca(_line);
							
						} 
						FileClose(myfile); 
					</cfscript>	
				<cfcatch>
					<cfthrow message = "Archivo da&ntilde;ado, no se puede cargar.">
				</cfcatch>
				</cftry>	
				
				<cfquery name="rsValidaPlaca" datasource="#Session.dsn#">
					select p.*
					from #PLACAS# p
					left join Activos a
						on p.Placa = a.Aplaca 
						and p.Ecodigo = a.Ecodigo
					where a.Aplaca is null and a.Ecodigo is null
				</cfquery>

				<cfif rsValidaPlaca.recordCount gt 0>
					<cfoutput>
						<div>
							<cfset tdstyle = "text-align: left; padding: 8px; border-bottom: 1px solid ##ddd; background-color: white;">
							<cfset thstyle = "#tdstyle# background-color: ##0C869C; color: white;">
							<table style="border-collapse: collapse; width: 70%;">
							<font size="5" color="red"> Reporte de Errores:</font>
							<font size="2" color="blue"><br>No se encontraron las siguientes placas: </font>
								<tr>
									<th style="#thstyle#">Placa</th>
								</tr>
								<cfloop query="#rsValidaPlaca#">
									<tr>
										<td style="#tdstyle#">#rsValidaPlaca.placa#</td>
									</tr>
								</cfloop>
							</table>
							<br>
						</div>
					</cfoutput>
				<cfelse>
					<cfquery name="rsinfoPlaca" datasource="#Session.dsn#">
						select a.Aplaca placa, a.Adescripcion descripcion, a.Aserie serie, getdate() Fecha
						from #PLACAS# p
						inner join Activos a
							on p.Placa = a.Aplaca 
							and p.Ecodigo = a.Ecodigo
						where a.Ecodigo = #session.Ecodigo#
					</cfquery>

					<cfset objEstadoCuenta = createObject( "component","sif.af.Componentes.ImprimePlaca")>
							
					<cftry>
						<cfset pdf = objEstadoCuenta.imprimir(placas= "#rsinfoPlaca#")>
					<cfcatch type="any">
						<cfrethrow>
					</cfcatch>
					</cftry>
					<cfheader name="Content-Disposition" value="attachment; filename=placas.pdf">
					<cfcontent type="application/pdf" file="#pdf#" deletefile="no" reset="yes"> 

				</cfif>

				<!--- <cfif importe>
					<script>
						alert("Fin de la Importacion");
					</script>
				</cfif> --->
				
			</cfif>


		</div>
	<cf_web_portlet_end>
<cf_templatefooter>

<script>
	function validate(form) {
		if(document.form1.CFcodigo.value == ''){ alert("Debe seleccionar un Centro Funcional"); return false;}

		return confirm("Esta seguro de que quiere importar estos pagos?");
	}

	function soloNumeros(e){
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 46))
		return true;
		
		return /\d/.test(String.fromCharCode(keynum));
	}

</script>
