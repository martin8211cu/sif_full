
<cfinvoke  key="LB_Titulo" default="Validador de XML" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="validadorXML.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_Titulo#>
		<br><br>
		<form enctype="multipart/form-data" name="validaXML" method="post">
			<table cellpadding="0" cellspacing="0" border="0" align="center" width="50%">
				<tr>
					<td align="right"><strong>XML&nbsp;&nbsp;&nbsp;</strong></td>
					<td><input type="file" file_extension="xml" name="fileXML" id="fileXML" size="45"></td>
				</tr>
				<tr>
					<td align="right"><strong>XSD&nbsp;&nbsp;&nbsp;</strong></td>
					<td><input type="file" name="fileXSD" id="fileXSD" size="45"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="button" id="validar" name="validar" onClick="validaCampos();" value="Validar"/>
						<input type="hidden" name="nameXML" id="nameXML" value="" />
						<input type="hidden" name="nameXSD" id="nameXSD" value="" />
					</td>
				</tr>
			</table>

			<cfif isDefined("form.nameXML") AND #form.nameXML# NEQ "">
				
				<cfset strPath = ExpandPath( "./" ) />
				<cfset nameXML = "#form.nameXML#" />
				<cfset nameXSD = "#form.nameXSD#" />
				<cfset urlXSD = "" />

				<!--- <cfdump var="#form.fileXML#"> --->
				<cffile action="upload" fileField="fileXML" nameConflict = "overwrite" destination="#strPath#">
				<cffile action="upload" fileField="fileXSD" nameConflict = "overwrite" destination="#strPath#">

				<cfset urlXSD = "#strPath##nameXSD#" />

				<cfif FileExists("#strPath##nameXML#") AND #urlXSD# NEQ "">
					<cfset resultValidacion = XMLValidate("#strPath##nameXML#", "#urlXSD#")>
					<cfset estatus = "" />
					<table width="70%"  border="0" cellspacing="1" cellpadding="1"  align="center">
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<cfoutput>
						<cfif #resultValidacion.status# EQ "NO">
							<cfset estatus = "Inv&aacute;lido" />
							<cfelse>
								<cfset estatus = "V&aacute;lido" />
						</cfif>
						<tr><td colspan="2" align="center"><strong>Resultados de validaci&oacute;n:</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr style="font-size:15;background-color:E8E8E8;">
							<td width="25%" align="right"><strong>Estado: </strong></td>
							<td align="left">#estatus#</td>
						</tr>
						<tr style="font-size:15;background-color:E8E8E8;">
							<td align="right"><strong>Errores: </strong></td>
							<td align="left">
								<cfloop array=#resultValidacion.Errors# index="error">
								    <cfoutput>#error#</cfoutput><br><br>
								</cfloop>
							</td>
						</tr>
						<tr style="font-size:15;background-color:E8E8E8;">
							<td align="right"><strong>Errores Fatales: </strong></td>
							<td align="left">
								<cfloop array=#resultValidacion.FatalErrors# index="fatalError">
								    <cfoutput>#fatalError#</cfoutput><br><br>
								</cfloop>
							</td>
						</tr>
						</cfoutput>
					</table>

					<!--- ELIMINACION DE XML TEMPORAL --->
					<cffile action = "delete" file = "#strPath##nameXML#">
				</cfif>
				<cfif FileExists("#strPath##nameXSD#")>
					<!--- ELIMINACION DE XSD TEMPORAL (SI ES QUE EXISTE) --->
					<cffile action = "delete" file = "#strPath##nameXSD#">
				</cfif>

			</cfif>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>


<script language="javascript" type="text/javascript">
	function validaCampos(){
		var stop = false;
		var xmlValue = document.getElementById('fileXML').value;
		var xsdValue = document.getElementById('fileXSD').value;
		var extXml;
		var extXsd;

		if(xmlValue == ""){
			alert('Favor de seleccionar un XML')
		}else if(xsdValue == ""){
			alert('Favor de seleccionar un XSD')
		}else{
			extXml = (xmlValue.substring(xmlValue.lastIndexOf("."))).toLowerCase(); 
			extXsd = (xsdValue.substring(xsdValue.lastIndexOf("."))).toLowerCase(); 
			if(extXml != ".xml"){
				alert('Favor de seleccionar un XML valido')
			}else if(extXsd != ".xsd"){
				alert('Favor de seleccionar un XSD valido')
			}else{
				xmlValue = xmlValue.split('\\');
				xsdValue = xsdValue.split('\\');
				document.validaXML.nameXML.value = xmlValue[xmlValue.length-1]
				document.validaXML.nameXSD.value = xsdValue[xsdValue.length-1]
				document.validaXML.submit();
			}
		}
	}
</script>